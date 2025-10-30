WITH date_range AS (
    SELECT 
        DATE_FORMAT(CURDATE() - INTERVAL 2 MONTH, '%Y-%m-01') AS startdate,
        LAST_DAY(CURDATE() - INTERVAL 1 MONTH) AS enddate,
        MONTH(DATE_FORMAT(CURDATE() - INTERVAL 2 MONTH, '%Y-%m-01')) AS prev_month_num,
        MONTH(DATE_FORMAT(CURDATE() - INTERVAL 2 MONTH, '%Y-%m-01') + INTERVAL 1 MONTH) AS curr_month_num
),
base_data AS (
    SELECT 
        'accrual_redemption' AS SOURCE,
        mobile,
        pointscollected,
        pointsspent,
        uniquebillno,
        amount,
        txndate,
        storecode,
        CASE WHEN storecode = 'ecom' THEN 'online' ELSE 'offline' END AS CHANNEL,
        CASE 
            WHEN MONTH(txndate) = dr.prev_month_num THEN 'prev_month'
            WHEN MONTH(txndate) = dr.curr_month_num THEN 'curr_month'
            ELSE 'other'
        END AS month_group
    FROM txn_report_accrual_redemption 
    CROSS JOIN date_range dr
    WHERE storecode <> 'demo' 
        AND billno NOT LIKE '%test%' 
        AND billno NOT LIKE '%roll%' 
        AND txndate BETWEEN dr.startdate AND dr.enddate
        AND insertiondate < CURDATE()
    UNION ALL
    SELECT 
        'flat_accrual' AS SOURCE,
        mobile,
        pointscollected,
        NULL AS pointsspent,
        NULL AS uniquebillno,
        NULL AS amount,
        txndate,
        storecode,
        CASE WHEN storecode = 'ecom' THEN 'online' ELSE 'offline' END AS CHANNEL,
        CASE 
            WHEN MONTH(txndate) = dr.prev_month_num THEN 'prev_month'
            WHEN MONTH(txndate) = dr.curr_month_num THEN 'curr_month'
            ELSE 'other'
        END AS month_group
    FROM txn_report_flat_accrual
    CROSS JOIN date_range dr
    WHERE storecode <> 'demo' 
        AND billno NOT LIKE '%test%' 
        AND billno NOT LIKE '%roll%'
        AND txndate BETWEEN dr.startdate AND dr.enddate
        AND insertiondate < CURDATE()
),
-- Rest of your original query remains unchanged --,
aggregated_data AS (
    SELECT
        CHANNEL,
        month_group,
        COUNT(DISTINCT mobile) AS customer,
        SUM(pointscollected) AS points_collected,
        SUM(CASE WHEN SOURCE = 'accrual_redemption' THEN pointsspent ELSE 0 END) AS points_redeemed,
        COUNT(DISTINCT CASE WHEN SOURCE = 'accrual_redemption' AND pointsspent > 0 THEN mobile END) AS redeemers,
        COUNT(DISTINCT CASE WHEN SOURCE = 'accrual_redemption' AND pointsspent > 0 THEN uniquebillno END) AS redemption_bills,
        SUM(CASE WHEN SOURCE = 'accrual_redemption' AND pointsspent > 0 THEN amount ELSE 0 END) AS redemption_sales,
        COUNT(DISTINCT CASE WHEN SOURCE = 'flat_accrual' THEN mobile END) AS accrued_customer,
        SUM(CASE WHEN SOURCE = 'flat_accrual' THEN pointscollected ELSE 0 END) AS points_issued
    FROM base_data
    WHERE month_group IN ('prev_month', 'curr_month')
    GROUP BY CHANNEL, month_group
)
SELECT 
    KPis,
    MAX(offline_prev_month) AS offline_prev_month,
    MAX(online_prev_month) AS online_prev_month,
    MAX(offline_curr_month) AS offline_curr_month,
    MAX(online_curr_month) AS online_curr_month
FROM (
    SELECT 
        'customer' AS KPIs,
        SUM(IF(CHANNEL = 'offline' AND month_group = 'prev_month', customer, 0)) AS offline_prev_month,
        SUM(IF(CHANNEL = 'online' AND month_group = 'prev_month', customer, 0)) AS online_prev_month,
        SUM(IF(CHANNEL = 'offline' AND month_group = 'curr_month', customer, 0)) AS offline_curr_month,
        SUM(IF(CHANNEL = 'online' AND month_group = 'curr_month', customer, 0)) AS online_curr_month
    FROM aggregated_data
    UNION ALL
    SELECT 
        'points_collected',
        SUM(IF(CHANNEL = 'offline' AND month_group = 'prev_month', points_collected, 0)),
        SUM(IF(CHANNEL = 'online' AND month_group = 'prev_month', points_collected, 0)),
        SUM(IF(CHANNEL = 'offline' AND month_group = 'curr_month', points_collected, 0)),
        SUM(IF(CHANNEL = 'online' AND month_group = 'curr_month', points_collected, 0))
    FROM aggregated_data
    UNION ALL
    SELECT 
        'points_reedemed',
        SUM(IF(CHANNEL = 'offline' AND month_group = 'prev_month', points_redeemed, 0)),
        SUM(IF(CHANNEL = 'online' AND month_group = 'prev_month', points_redeemed, 0)),
        SUM(IF(CHANNEL = 'offline' AND month_group = 'curr_month', points_redeemed, 0)),
        SUM(IF(CHANNEL = 'online' AND month_group = 'curr_month', points_redeemed, 0))
    FROM aggregated_data
    UNION ALL
    SELECT 
        'Redeemers',
        SUM(IF(CHANNEL = 'offline' AND month_group = 'prev_month', redeemers, 0)),
        SUM(IF(CHANNEL = 'online' AND month_group = 'prev_month', redeemers, 0)),
        SUM(IF(CHANNEL = 'offline' AND month_group = 'curr_month', redeemers, 0)),
        SUM(IF(CHANNEL = 'online' AND month_group = 'curr_month', redeemers, 0))
    FROM aggregated_data
    UNION ALL
    SELECT 
        'Redemption_Bills',
        SUM(IF(CHANNEL = 'offline' AND month_group = 'prev_month', redemption_bills, 0)),
        SUM(IF(CHANNEL = 'online' AND month_group = 'prev_month', redemption_bills, 0)),
        SUM(IF(CHANNEL = 'offline' AND month_group = 'curr_month', redemption_bills, 0)),
        SUM(IF(CHANNEL = 'online' AND month_group = 'curr_month', redemption_bills, 0))
    FROM aggregated_data
    UNION ALL
    SELECT 
        'Redemption_sales',
        SUM(IF(CHANNEL = 'offline' AND month_group = 'prev_month', redemption_sales, 0)),
        SUM(IF(CHANNEL = 'online' AND month_group = 'prev_month', redemption_sales, 0)),
        SUM(IF(CHANNEL = 'offline' AND month_group = 'curr_month', redemption_sales, 0)),
        SUM(IF(CHANNEL = 'online' AND month_group = 'curr_month', redemption_sales, 0))
    FROM aggregated_data
    UNION ALL
    SELECT 
        'accrued_customer',
        SUM(IF(CHANNEL = 'offline' AND month_group = 'prev_month', accrued_customer, 0)),
        SUM(IF(CHANNEL = 'online' AND month_group = 'prev_month', accrued_customer, 0)),
        SUM(IF(CHANNEL = 'offline' AND month_group = 'curr_month', accrued_customer, 0)),
        SUM(IF(CHANNEL = 'online' AND month_group = 'curr_month', accrued_customer, 0))
    FROM aggregated_data
    UNION ALL
    SELECT 
        'points_issued',
        SUM(IF(CHANNEL = 'offline' AND month_group = 'prev_month', points_issued, 0)),
        SUM(IF(CHANNEL = 'online' AND month_group = 'prev_month', points_issued, 0)),
        SUM(IF(CHANNEL = 'offline' AND month_group = 'curr_month', points_issued, 0)),
        SUM(IF(CHANNEL = 'online' AND month_group = 'curr_month', points_issued, 0))
    FROM aggregated_data
) AS kpi_data
GROUP BY KPIs
ORDER BY FIELD(KPIs, 'customer', 'points_collected', 'points_reedemed', 'Redeemers', 'Redemption_Bills', 'Redemption_sales', 'accrued_customer', 'points_issued');