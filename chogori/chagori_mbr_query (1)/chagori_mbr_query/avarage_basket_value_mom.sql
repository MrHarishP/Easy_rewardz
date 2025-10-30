SET @startdate = DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 4 MONTH), '%Y-%m-01');
SET @enddate = LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH));

SELECT 
    CASE
        WHEN PERIOD_DIFF = 3 THEN 'prev_third_month'
        WHEN PERIOD_DIFF = 2 THEN 'prev_second_month'
        WHEN PERIOD_DIFF = 1 THEN 'prev_month'
        WHEN PERIOD_DIFF = 0 THEN 'curr_month'
    END AS MONTHNAME,
    atv
FROM (
    SELECT 
        PERIOD_DIFF(DATE_FORMAT(@enddate, '%Y%m'), DATE_FORMAT(txndate, '%Y%m')) AS PERIOD_DIFF,
        SUM(amount)/COUNT(DISTINCT uniquebillno) AS atv
    FROM txn_report_accrual_redemption
    WHERE txndate BETWEEN @startdate AND @enddate
    GROUP BY PERIOD_DIFF(DATE_FORMAT(@enddate, '%Y%m'), DATE_FORMAT(txndate, '%Y%m'))
) AS sub
ORDER BY PERIOD_DIFF DESC;