
SET @startdate = DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-01');
SET @enddate = LAST_DAY(@startdate);
SET @startdate5M = DATE_FORMAT(DATE_SUB(@startdate, INTERVAL 5 MONTH), '%Y-%m-01');

WITH RECURSIVE 
month_sequence AS (
    SELECT 
        @startdate5M AS month_start,
        MONTH(@startdate5M) AS month_num,
        YEAR(@startdate5M) AS YEAR,
        1 AS seq
    UNION ALL
    SELECT 
        DATE_ADD(month_start, INTERVAL 1 MONTH),
        MONTH(DATE_ADD(month_start, INTERVAL 1 MONTH)),
        YEAR(DATE_ADD(month_start, INTERVAL 1 MONTH)),
        seq + 1
    FROM month_sequence
    WHERE DATE_ADD(month_start, INTERVAL 1 MONTH) <= @enddate
),
total_data AS (
    SELECT 
        MONTH(TxnDate) AS month_num,
        YEAR(TxnDate) AS YEAR,
        COUNT(DISTINCT uniquebillno) AS bills 
    FROM txn_report_accrual_redemption
    WHERE TxnDate BETWEEN @startdate5M AND @enddate
      AND modifiedbillno NOT LIKE '%test%'
      AND storecode NOT LIKE '%demo%'
      AND modifiedbillno NOT LIKE '%roll%'
      AND storecode NOT LIKE '%test%'
    GROUP BY 1, 2

    UNION ALL

    SELECT 
        MONTH(modifiedTxnDate) AS month_num,
        YEAR(modifiedTxnDate) AS YEAR,
        COUNT(DISTINCT uniquebillno) AS bills 
    FROM sku_report_nonloyalty 
    WHERE modifiedTxnDate BETWEEN @startdate5M AND @enddate
      AND modifiedbillno NOT LIKE '%test%'
      AND storecode NOT LIKE '%demo%'
      AND modifiedbillno NOT LIKE '%roll%'
      AND storecode NOT LIKE '%test%'
    GROUP BY 1, 2
),
loyalty_data AS (
    SELECT 
        MONTH(TxnDate) AS month_num,
        YEAR(TxnDate) AS YEAR,
        COUNT(DISTINCT uniquebillno) AS bills 
    FROM txn_report_accrual_redemption
    WHERE TxnDate BETWEEN @startdate5M AND @enddate
      AND modifiedbillno NOT LIKE '%test%'
      AND storecode NOT LIKE '%demo%'
      AND modifiedbillno NOT LIKE '%roll%'
      AND storecode NOT LIKE '%test%'
    GROUP BY 1, 2
),
combined_data AS (
    SELECT 
        'total_bills' AS MONTH,
        month_num,
        YEAR,
        SUM(bills) AS bills
    FROM total_data
    GROUP BY month_num, YEAR

    UNION ALL

    SELECT 
        'loyalty_bills' AS MONTH,
        month_num,
        YEAR,
        bills
    FROM loyalty_data
),

labeled_data AS (
    SELECT 
        CASE ms.seq
            WHEN 1 THEN 'prev_fifth_month'
            WHEN 2 THEN 'prev_fourth_month'  
            WHEN 3 THEN 'prev_third_month'   
            WHEN 4 THEN 'prev_second_month'
            WHEN 5 THEN 'prev_month'
            WHEN 6 THEN 'curr_month'
            ELSE NULL
        END AS month_label,
        cd.month,
        COALESCE(cd.bills, 0) AS bills
    FROM month_sequence ms
    LEFT JOIN combined_data cd 
        ON ms.month_num = cd.month_num AND ms.year = cd.year
)

SELECT 
    MONTH,
    MAX(CASE WHEN month_label = 'prev_fourth_month' THEN bills END) AS prev_fourth_month,
    MAX(CASE WHEN month_label = 'prev_third_month' THEN bills END) AS prev_third_month,
    MAX(CASE WHEN month_label = 'prev_second_month' THEN bills END) AS prev_second_month,
    MAX(CASE WHEN month_label = 'prev_month' THEN bills END) AS prev_month,
    MAX(CASE WHEN month_label = 'curr_month' THEN bills END) AS curr_month
FROM labeled_data
GROUP BY MONTH;
