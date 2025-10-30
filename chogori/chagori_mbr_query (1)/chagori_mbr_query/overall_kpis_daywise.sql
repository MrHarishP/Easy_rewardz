SELECT 
    DAYNAME(txndate) AS DAY,
    SUM(CASE WHEN txndate BETWEEN prev_month_start AND prev_month_end THEN amount ELSE 0 END) AS monthly_sales,
    SUM(amount) AS fy_sales
FROM txn_report_accrual_redemption
CROSS JOIN (
    SELECT 
        DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-01') AS prev_month_start,
        LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH)) AS prev_month_end,
        IF(MONTH(CURDATE()) >= 4,
            DATE_FORMAT(CURDATE(), '%Y-04-01'),
            DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 YEAR), '%Y-04-01')) AS fiscal_start,
        LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH)) AS fiscal_end
) AS dates
WHERE txndate BETWEEN fiscal_start AND fiscal_end
GROUP BY DAY
ORDER BY (DAYOFWEEK(txndate) + 5) % 7;