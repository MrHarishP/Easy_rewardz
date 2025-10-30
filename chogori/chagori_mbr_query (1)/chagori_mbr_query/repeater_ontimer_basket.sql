WITH date_ranges AS (
    SELECT 
        DATE_FORMAT(DATE_SUB(CURRENT_DATE, INTERVAL 12 MONTH), '%Y-%m-01') AS start_12m,
        LAST_DAY(DATE_SUB(CURRENT_DATE, INTERVAL 7 MONTH)) AS end_7m,
        DATE_FORMAT(DATE_SUB(CURRENT_DATE, INTERVAL 6 MONTH), '%Y-%m-01') AS start_6m,
        LAST_DAY(DATE_SUB(CURRENT_DATE, INTERVAL 4 MONTH)) AS end_4m,
        DATE_FORMAT(DATE_SUB(CURRENT_DATE, INTERVAL 3 MONTH), '%Y-%m-01') AS start_3m,
        LAST_DAY(DATE_SUB(CURRENT_DATE, INTERVAL 1 MONTH)) AS end_1m
),
aggregated_data AS (
    SELECT 
        mobile,
        txndate,
        MAX(FrequencyCount) AS FrequencyCount
    FROM txn_report_accrual_redemption 
    WHERE storecode NOT LIKE '%demo%' 
      AND billno NOT LIKE '%test%' 
      AND billno NOT LIKE '%roll%'
    GROUP BY mobile, txndate
)
SELECT 
    month_tag,
    COUNT(DISTINCT CASE WHEN FrequencyCount = 1 THEN mobile END) AS one_timer_count,
    COUNT(DISTINCT CASE WHEN FrequencyCount > 1 THEN mobile END) AS repeater_count
FROM (
    SELECT
        a.mobile,
        a.FrequencyCount,
        CASE 
            WHEN a.txndate < dr.start_12m THEN '12 months and above'
            WHEN a.txndate BETWEEN dr.start_12m AND dr.end_7m THEN 'last 7-12'
            WHEN a.txndate BETWEEN dr.start_6m AND dr.end_4m THEN 'last 4-6'
            WHEN a.txndate BETWEEN dr.start_3m AND dr.end_1m THEN 'last 1-3'
        END AS month_tag
    FROM aggregated_data a
    CROSS JOIN date_ranges dr
) categorized
WHERE month_tag IS NOT NULL
GROUP BY month_tag
ORDER BY 
    CASE month_tag
        WHEN 'last 1-3' THEN 1
        WHEN 'last 4-6' THEN 2
        WHEN 'last 7-12' THEN 3
        ELSE 4
    END;