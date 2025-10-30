SET @startdate = DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-01');
SET @enddate = LAST_DAY(@startdate);
SET @startdate1M = DATE_FORMAT(DATE_SUB(@startdate, INTERVAL 1 MONTH), '%Y-%m-01');
SET @enddate1M = LAST_DAY(@startdate1M);

WITH combined_data AS (
    SELECT 
        mobile,
        SUM(CASE WHEN TxnDate BETWEEN @startdate1M AND @enddate1M THEN Amount END) AS prev_sales,
        COUNT(DISTINCT CASE WHEN TxnDate BETWEEN @startdate1M AND @enddate1M THEN UniqueBillNo END) AS prev_bills,
        MAX(CASE WHEN TxnDate BETWEEN @startdate1M AND @enddate1M THEN frequencycount END) AS prev_maxf,
        SUM(CASE WHEN TxnDate BETWEEN @startdate AND @enddate THEN Amount END) AS curr_sales,
        COUNT(DISTINCT CASE WHEN TxnDate BETWEEN @startdate AND @enddate THEN UniqueBillNo END) AS curr_bills,
        MAX(CASE WHEN TxnDate BETWEEN @startdate AND @enddate THEN frequencycount END) AS curr_maxf
    FROM txn_report_accrual_redemption 
    WHERE (TxnDate BETWEEN @startdate1M AND @enddate1M OR TxnDate BETWEEN @startdate AND @enddate)
      AND storecode NOT LIKE '%demo%'
      AND billno NOT LIKE '%test%'
      AND billno NOT LIKE '%roll%'
    GROUP BY mobile
),
unioned_data AS (
    SELECT 
        mobile,
        CASE WHEN prev_maxf = 1 THEN 'prev_onetimer' ELSE 'prev_repeater' END AS category,
        prev_sales AS sales,
        prev_bills AS bills
    FROM combined_data
    WHERE prev_sales IS NOT NULL  
    
    UNION ALL
    
    SELECT 
        mobile,
        CASE WHEN curr_maxf = 1 THEN 'curr_onetimer' ELSE 'curr_repeater' END AS category,
        curr_sales AS sales,
        curr_bills AS bills
    FROM combined_data
    WHERE curr_sales IS NOT NULL  
),
aggregated AS (
    SELECT 
        category,
        COUNT(DISTINCT mobile) AS customers,
        SUM(sales) AS sales,
        SUM(bills) AS bills,
        SUM(sales)/SUM(bills) AS atv,
        SUM(sales)/COUNT(DISTINCT mobile) AS amv
    FROM unioned_data
    GROUP BY category
)

SELECT 
    kpis.kpi,
    COALESCE(SUM(CASE WHEN category = 'prev_onetimer' THEN metric END), 0) AS prev_month_onetimer,
    COALESCE(SUM(CASE WHEN category = 'prev_repeater' THEN metric END), 0) AS prev_month_repeater,
    COALESCE(SUM(CASE WHEN category = 'curr_onetimer' THEN metric END), 0) AS curr_month_onetimer,
    COALESCE(SUM(CASE WHEN category = 'curr_repeater' THEN metric END), 0) AS curr_month_repeater
FROM (
    SELECT 'customers' AS kpi, category, customers AS metric FROM aggregated
    UNION ALL
    SELECT 'sales', category, sales FROM aggregated
    UNION ALL
    SELECT 'bills', category, bills FROM aggregated
    UNION ALL
    SELECT 'atv', category, atv FROM aggregated
    UNION ALL
    SELECT 'amv', category, amv FROM aggregated
) AS kpis
GROUP BY kpis.kpi
ORDER BY FIELD(kpis.kpi, 'customers', 'sales', 'bills', 'atv', 'amv');