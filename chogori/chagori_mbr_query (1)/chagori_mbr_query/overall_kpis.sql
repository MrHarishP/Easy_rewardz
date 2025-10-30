
SELECT DATE_FORMAT(CURDATE() - INTERVAL 1 MONTH, '%Y-%m-01') INTO @startdate;

SELECT LAST_DAY(CURDATE() - INTERVAL 1 MONTH) INTO @enddate;
SET @startdate1m = DATE_FORMAT(@startdate - INTERVAL 1 MONTH, '%Y-%m-01');
SET @enddate1m = LAST_DAY(@startdate1m);
SET @startdate1y = DATE_FORMAT(@startdate - INTERVAL 1 YEAR, '%Y-%m-01');
SET @enddate1y = LAST_DAY(@startdate1y);



WITH 
current_period AS (
    SELECT 
        mobile,
        SUM(Amount) AS sales,
        COUNT(DISTINCT UniqueBillNo) AS bills,
        MAX(frequencycount) AS maxf,
        MIN(frequencycount) AS minf,
        SUM(pointscollected) AS points_collected,
        SUM(pointsspent) AS redeemed
    FROM txn_report_accrual_redemption 
    WHERE TxnDate BETWEEN @startdate AND @enddate
      AND storecode NOT LIKE '%demo%' 
      AND billno NOT LIKE '%test%' 
      AND billno NOT LIKE '%roll%' 
      AND insertiondate < CURDATE()
    GROUP BY mobile
),
prev_period AS (
    SELECT 
        mobile,
        SUM(Amount) AS sales,
        COUNT(DISTINCT UniqueBillNo) AS bills,
        MAX(frequencycount) AS maxf,
        MIN(frequencycount) AS minf,
        SUM(pointscollected) AS points_collected,
        SUM(pointsspent) AS redeemed
    FROM txn_report_accrual_redemption 
    WHERE TxnDate BETWEEN @startdate1m AND @enddate1m
      AND storecode NOT LIKE '%demo%' 
      AND billno NOT LIKE '%test%' 
      AND billno NOT LIKE '%roll%' 
      AND insertiondate < CURDATE()
    GROUP BY mobile
),
curr_month_prev_yr AS (
    SELECT 
        mobile,
        SUM(Amount) AS sales,
        COUNT(DISTINCT UniqueBillNo) AS bills,
        MAX(frequencycount) AS maxf,
        MIN(frequencycount) AS minf,
        SUM(pointscollected) AS points_collected,
        SUM(pointsspent) AS redeemed
    FROM txn_report_accrual_redemption 
    WHERE TxnDate BETWEEN @startdate1y AND @enddate1y
      AND storecode NOT LIKE '%demo%' 
      AND billno NOT LIKE '%test%' 
      AND billno NOT LIKE '%roll%' 
      AND insertiondate < CURDATE()
    GROUP BY mobile
),
enrolled_current AS (
    SELECT DISTINCT mobile
    FROM `outdoortribes`.member_report 
    WHERE enrolledstorecode NOT LIKE '%demo%'
      AND modifiedenrolledon BETWEEN @startdate AND @enddate
      AND insertiondate < CURDATE()
),
enrolled_prev AS (
    SELECT DISTINCT mobile
    FROM `outdoortribes`.member_report 
    WHERE enrolledstorecode NOT LIKE '%demo%'
      AND modifiedenrolledon BETWEEN @startdate1m AND @enddate1m
      AND insertiondate < CURDATE()
),
enrolled_curr_month_prev_yr AS (
    SELECT DISTINCT mobile
    FROM `outdoortribes`.member_report 
    WHERE enrolledstorecode NOT LIKE '%demo%'
      AND modifiedenrolledon BETWEEN @startdate1y AND @enddate1y
      AND insertiondate < CURDATE()
),
kpis AS (
    SELECT 
        kpis.TxnMonth,
        MAX(CASE WHEN PERIOD='curr_month_prev_yr' THEN VALUE END) AS curr_month_prev_yr,
        MAX(CASE WHEN PERIOD = 'previous' THEN VALUE END) AS prev_month_curr_yr,
        MAX(CASE WHEN PERIOD = 'current' THEN VALUE END) AS curr_month_curr_yr
    FROM (
        SELECT 'curr_month_prev_yr' AS PERIOD, 'enrollments' AS TxnMonth,COUNT(DISTINCT mobile) AS VALUE FROM enrolled_curr_month_prev_yr
        UNION ALL
        SELECT 'curr_month_prev_yr', 'Transacting_Customers', COUNT(DISTINCT mobile) FROM curr_month_prev_yr
        UNION ALL
        SELECT 'curr_month_prev_yr', 'OneTimer', COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN mobile END) FROM curr_month_prev_yr
        UNION ALL
        SELECT 'curr_month_prev_yr', 'New_Repeater', COUNT(DISTINCT CASE WHEN maxf>1 AND minf=1 THEN mobile END) FROM curr_month_prev_yr
        UNION ALL
        SELECT 'curr_month_prev_yr', 'Old_Repeater', COUNT(DISTINCT CASE WHEN maxf>1 AND minf>1 THEN mobile END) FROM curr_month_prev_yr
        UNION ALL
        SELECT 'curr_month_prev_yr', 'OneTimer_Sales', SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END) FROM curr_month_prev_yr
        UNION ALL
        SELECT 'curr_month_prev_yr', 'New_Repeat_Sales', SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END) FROM curr_month_prev_yr
        UNION ALL
        SELECT 'curr_month_prev_yr', 'Old_Repeat_Sales', SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END) FROM curr_month_prev_yr
        UNION ALL
        SELECT 'curr_month_prev_yr', 'sales', SUM(sales) FROM curr_month_prev_yr
        UNION ALL
        SELECT 'curr_month_prev_yr', 'onetimer_Bills', SUM(CASE WHEN maxf=1 AND minf=1 THEN bills END) FROM curr_month_prev_yr
        UNION ALL
        SELECT 'curr_month_prev_yr', 'New_Repeat_Bills', SUM(CASE WHEN maxf>1 AND minf=1 THEN bills END) FROM curr_month_prev_yr
        UNION ALL
        SELECT 'curr_month_prev_yr', 'Old_Repeat_Bills', SUM(CASE WHEN maxf>1 AND minf>1 THEN bills END) FROM curr_month_prev_yr
        UNION ALL
        SELECT 'curr_month_prev_yr', 'bills', SUM(bills) FROM curr_month_prev_yr
        UNION ALL
        SELECT 'curr_month_prev_yr', 'ABV', SUM(sales)/NULLIF(SUM(bills), 0) FROM curr_month_prev_yr
        UNION ALL
        SELECT 'curr_month_prev_yr', 'Onetimer_ABV', SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END)/NULLIF(SUM(CASE WHEN maxf=1 AND minf=1 THEN bills END), 0) FROM curr_month_prev_yr
        UNION ALL
        SELECT 'curr_month_prev_yr', 'New_Repeat_ABV', SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END)/NULLIF(SUM(CASE WHEN maxf>1 AND minf=1 THEN bills END), 0) FROM curr_month_prev_yr
        UNION ALL
        SELECT 'curr_month_prev_yr', 'Old_Repeat_ABV', SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END)/NULLIF(SUM(CASE WHEN maxf>1 AND minf>1 THEN bills END), 0) FROM curr_month_prev_yr
        UNION ALL
        SELECT 'curr_month_prev_yr', 'AMV', SUM(sales)/NULLIF(COUNT(DISTINCT mobile), 0) FROM curr_month_prev_yr
        UNION ALL
        SELECT 'curr_month_prev_yr', 'Onetimer_AMV', SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END)/NULLIF(COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN mobile END), 0) FROM curr_month_prev_yr
        UNION ALL
        SELECT 'curr_month_prev_yr', 'New_Repeat_AMV', SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END)/NULLIF(COUNT(DISTINCT CASE WHEN maxf>1 AND minf=1 THEN mobile END), 0) FROM curr_month_prev_yr
        UNION ALL
        SELECT 'curr_month_prev_yr', 'Old_Repeat_AMV', SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END)/NULLIF(COUNT(DISTINCT CASE WHEN maxf>1 AND minf>1 THEN mobile END), 0) FROM curr_month_prev_yr
        UNION ALL
        SELECT 'curr_month_prev_yr', 'Transaction_Points_issued', IFNULL(SUM(points_collected),0) FROM curr_month_prev_yr
        UNION ALL
        SELECT 'curr_month_prev_yr', 'Points_redeemed', IFNULL(SUM(redeemed),0) FROM curr_month_prev_yr
        
        UNION ALL
        -- Current Month KPIs
        SELECT 'current' AS PERIOD, 'enrollments' AS TxnMonth, COUNT(DISTINCT mobile) AS VALUE FROM enrolled_current
        UNION ALL
        SELECT 'current', 'Transacting_Customers', COUNT(DISTINCT mobile) FROM current_period
        UNION ALL
        SELECT 'current', 'OneTimer', COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN mobile END) FROM current_period
        UNION ALL
        SELECT 'current', 'New_Repeater', COUNT(DISTINCT CASE WHEN maxf>1 AND minf=1 THEN mobile END) FROM current_period
        UNION ALL
        SELECT 'current', 'Old_Repeater', COUNT(DISTINCT CASE WHEN maxf>1 AND minf>1 THEN mobile END) FROM current_period
        UNION ALL
        SELECT 'current', 'OneTimer_Sales', SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END) FROM current_period
        UNION ALL
        SELECT 'current', 'New_Repeat_Sales', SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END) FROM current_period
        UNION ALL
        SELECT 'current', 'Old_Repeat_Sales', SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END) FROM current_period
        UNION ALL
        SELECT 'current', 'sales', SUM(sales) FROM current_period
        UNION ALL
        SELECT 'current', 'onetimer_Bills', SUM(CASE WHEN maxf=1 AND minf=1 THEN bills END) FROM current_period
        UNION ALL
        SELECT 'current', 'New_Repeat_Bills', SUM(CASE WHEN maxf>1 AND minf=1 THEN bills END) FROM current_period
        UNION ALL
        SELECT 'current', 'Old_Repeat_Bills', SUM(CASE WHEN maxf>1 AND minf>1 THEN bills END) FROM current_period
        UNION ALL
        SELECT 'current', 'bills', SUM(bills) FROM current_period
        UNION ALL
        SELECT 'current', 'ABV', SUM(sales)/NULLIF(SUM(bills), 0) FROM current_period
        UNION ALL
        SELECT 'current', 'Onetimer_ABV', SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END)/NULLIF(SUM(CASE WHEN maxf=1 AND minf=1 THEN bills END), 0) FROM current_period
        UNION ALL
        SELECT 'current', 'New_Repeat_ABV', SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END)/NULLIF(SUM(CASE WHEN maxf>1 AND minf=1 THEN bills END), 0) FROM current_period
        UNION ALL
        SELECT 'current', 'Old_Repeat_ABV', SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END)/NULLIF(SUM(CASE WHEN maxf>1 AND minf>1 THEN bills END), 0) FROM current_period
        UNION ALL
        SELECT 'current', 'AMV', SUM(sales)/NULLIF(COUNT(DISTINCT mobile), 0) FROM current_period
        UNION ALL
        SELECT 'current', 'Onetimer_AMV', SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END)/NULLIF(COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN mobile END), 0) FROM current_period
        UNION ALL
        SELECT 'current', 'New_Repeat_AMV', SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END)/NULLIF(COUNT(DISTINCT CASE WHEN maxf>1 AND minf=1 THEN mobile END), 0) FROM current_period
        UNION ALL
        SELECT 'current', 'Old_Repeat_AMV', SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END)/NULLIF(COUNT(DISTINCT CASE WHEN maxf>1 AND minf>1 THEN mobile END), 0) FROM current_period
        UNION ALL
        SELECT 'current', 'Transaction_Points_issued', IFNULL(SUM(points_collected),0) FROM current_period
        UNION ALL
        SELECT 'current', 'Points_redeemed', IFNULL(SUM(redeemed),0) FROM current_period
        UNION ALL
        SELECT 'previous', 'enrollments', COUNT(DISTINCT mobile) FROM enrolled_prev
        UNION ALL
        SELECT 'previous', 'Transacting_Customers', COUNT(DISTINCT mobile) FROM prev_period
        UNION ALL
        SELECT 'previous', 'OneTimer', COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN mobile END) FROM prev_period
        UNION ALL
        SELECT 'previous', 'New_Repeater', COUNT(DISTINCT CASE WHEN maxf>1 AND minf=1 THEN mobile END) FROM prev_period
        UNION ALL
        SELECT 'previous', 'Old_Repeater', COUNT(DISTINCT CASE WHEN maxf>1 AND minf>1 THEN mobile END) FROM prev_period
        UNION ALL
        SELECT 'previous', 'OneTimer_Sales', SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END) FROM prev_period
        UNION ALL
        SELECT 'previous', 'New_Repeat_Sales', SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END) FROM prev_period
        UNION ALL
        SELECT 'previous', 'Old_Repeat_Sales', SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END) FROM prev_period
        UNION ALL
        SELECT 'previous', 'sales', SUM(sales) FROM prev_period
        UNION ALL
        SELECT 'previous', 'onetimer_Bills', SUM(CASE WHEN maxf=1 AND minf=1 THEN bills END) FROM prev_period
        UNION ALL
        SELECT 'previous', 'New_Repeat_Bills', SUM(CASE WHEN maxf>1 AND minf=1 THEN bills END) FROM prev_period
        UNION ALL
        SELECT 'previous', 'Old_Repeat_Bills', SUM(CASE WHEN maxf>1 AND minf>1 THEN bills END) FROM prev_period
        UNION ALL
        SELECT 'previous', 'bills', SUM(bills) FROM prev_period
        UNION ALL
        SELECT 'previous', 'ABV', SUM(sales)/NULLIF(SUM(bills), 0) FROM prev_period
        UNION ALL
        SELECT 'previous', 'Onetimer_ABV', SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END)/NULLIF(SUM(CASE WHEN maxf=1 AND minf=1 THEN bills END), 0) FROM prev_period
        UNION ALL
        SELECT 'previous', 'New_Repeat_ABV', SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END)/NULLIF(SUM(CASE WHEN maxf>1 AND minf=1 THEN bills END), 0) FROM prev_period
        UNION ALL
        SELECT 'previous', 'Old_Repeat_ABV', SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END)/NULLIF(SUM(CASE WHEN maxf>1 AND minf>1 THEN bills END), 0) FROM prev_period
        UNION ALL
        SELECT 'previous', 'AMV', SUM(sales)/NULLIF(COUNT(DISTINCT mobile), 0) FROM prev_period
        UNION ALL
        SELECT 'previous', 'Onetimer_AMV', SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END)/NULLIF(COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN mobile END), 0) FROM prev_period
        UNION ALL
        SELECT 'previous', 'New_Repeat_AMV', SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END)/NULLIF(COUNT(DISTINCT CASE WHEN maxf>1 AND minf=1 THEN mobile END), 0) FROM prev_period
        UNION ALL
        SELECT 'previous', 'Old_Repeat_AMV', SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END)/NULLIF(COUNT(DISTINCT CASE WHEN maxf>1 AND minf>1 THEN mobile END), 0) FROM prev_period
        UNION ALL
        SELECT 'previous', 'Transaction_Points_issued', IFNULL(SUM(points_collected),0) FROM prev_period
        UNION ALL
        SELECT 'previous', 'Points_redeemed', IFNULL(SUM(redeemed),0) FROM prev_period
    ) kpis
    GROUP BY kpis.TxnMonth
)

SELECT 
    TxnMonth,
    curr_month_prev_yr,
    prev_month_curr_yr,
    curr_month_curr_yr
    
FROM kpis
ORDER BY 
    FIELD(TxnMonth,
        'enrollments',
        'Transacting_Customers',
        'OneTimer',
        'New_Repeater',
        'Old_Repeater',
        'OneTimer_Sales',
        'New_Repeat_Sales',
        'Old_Repeat_Sales',
        'sales',
        'onetimer_Bills',
        'New_Repeat_Bills',
        'Old_Repeat_Bills',
        'bills',
        'ABV',
        'Onetimer_ABV',
        'New_Repeat_ABV',
        'Old_Repeat_ABV',
        'AMV',
        'Onetimer_AMV',
        'New_Repeat_AMV',
        'Old_Repeat_AMV',
        'Transaction_Points_issued',
        'Points_redeemed'
    );