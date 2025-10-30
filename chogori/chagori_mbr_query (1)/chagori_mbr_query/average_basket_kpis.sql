SET @startdate = DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-01');
SET @enddate = LAST_DAY(@startdate);

SELECT 
    'total_loyalty_bills' AS TxnMonth,
    curr.total_loyalty_bills AS curr_month,
    prev_yr.total_loyalty_bills AS prev_yr_curr_month
FROM (
    SELECT SUM(bills) AS total_loyalty_bills
    FROM (
        SELECT COUNT(DISTINCT UniqueBillNo) AS bills
        FROM txn_report_accrual_redemption
        WHERE TxnDate BETWEEN @startdate AND @enddate
        AND storecode NOT LIKE '%demo%' 
        AND billno NOT LIKE '%test%' 
        AND billno NOT LIKE '%roll%'
        GROUP BY mobile
    ) a
) curr
CROSS JOIN (
    SELECT SUM(bills) AS total_loyalty_bills
    FROM (
        SELECT COUNT(DISTINCT UniqueBillNo) AS bills
        FROM txn_report_accrual_redemption
        WHERE TxnDate BETWEEN @startdate - INTERVAL 1 YEAR AND @enddate - INTERVAL 1 YEAR
        AND storecode NOT LIKE '%demo%' 
        AND billno NOT LIKE '%test%' 
        AND billno NOT LIKE '%roll%'
        GROUP BY mobile
    ) a
) prev_yr

UNION ALL

SELECT 
    'total_repeat_bills',
    curr.total_repeat_bills,
    prev_yr.total_repeat_bills
FROM (
    SELECT SUM(CASE WHEN maxf > 1 THEN bills END) AS total_repeat_bills
    FROM (
        SELECT 
            COUNT(DISTINCT UniqueBillNo) AS bills,
            MAX(frequencycount) AS maxf
        FROM txn_report_accrual_redemption
        WHERE TxnDate BETWEEN @startdate AND @enddate
        AND storecode NOT LIKE '%demo%' 
        AND billno NOT LIKE '%test%' 
        AND billno NOT LIKE '%roll%'
        GROUP BY mobile
    ) a
) curr
CROSS JOIN (
    SELECT SUM(CASE WHEN maxf > 1 THEN bills END) AS total_repeat_bills
    FROM (
        SELECT 
            COUNT(DISTINCT UniqueBillNo) AS bills,
            MAX(frequencycount) AS maxf
        FROM txn_report_accrual_redemption
        WHERE TxnDate BETWEEN @startdate - INTERVAL 1 YEAR AND @enddate - INTERVAL 1 YEAR
        AND storecode NOT LIKE '%demo%' 
        AND billno NOT LIKE '%test%' 
        AND billno NOT LIKE '%roll%'
        GROUP BY mobile
    ) a
) prev_yr

UNION ALL

SELECT 
    'total_loyalty_sales',
    curr.total_loyalty_sales,
    prev_yr.total_loyalty_sales
FROM (
    SELECT SUM(Amount) AS total_loyalty_sales
    FROM txn_report_accrual_redemption
    WHERE TxnDate BETWEEN @startdate AND @enddate
    AND storecode NOT LIKE '%demo%' 
    AND billno NOT LIKE '%test%' 
    AND billno NOT LIKE '%roll%'
) curr
CROSS JOIN (
    SELECT SUM(Amount) AS total_loyalty_sales
    FROM txn_report_accrual_redemption
    WHERE TxnDate BETWEEN @startdate - INTERVAL 1 YEAR AND @enddate - INTERVAL 1 YEAR
    AND storecode NOT LIKE '%demo%' 
    AND billno NOT LIKE '%test%' 
    AND billno NOT LIKE '%roll%'
) prev_yr

UNION ALL

SELECT 
    'total_repeat_sales',
    curr.total_repeat_sales,
    prev_yr.total_repeat_sales
FROM (
    SELECT SUM(CASE WHEN maxf > 1 THEN sales END) AS total_repeat_sales
    FROM (
        SELECT 
            SUM(Amount) AS sales,
            MAX(frequencycount) AS maxf
        FROM txn_report_accrual_redemption
        WHERE TxnDate BETWEEN @startdate AND @enddate
        AND storecode NOT LIKE '%demo%' 
        AND billno NOT LIKE '%test%' 
        AND billno NOT LIKE '%roll%'
        GROUP BY mobile
    ) a
) curr
CROSS JOIN (
    SELECT SUM(CASE WHEN maxf > 1 THEN sales END) AS total_repeat_sales
    FROM (
        SELECT 
            SUM(Amount) AS sales,
            MAX(frequencycount) AS maxf
        FROM txn_report_accrual_redemption
        WHERE TxnDate BETWEEN @startdate - INTERVAL 1 YEAR AND @enddate - INTERVAL 1 YEAR
        AND storecode NOT LIKE '%demo%' 
        AND billno NOT LIKE '%test%' 
        AND billno NOT LIKE '%roll%'
        GROUP BY mobile
    ) a
) prev_yr;