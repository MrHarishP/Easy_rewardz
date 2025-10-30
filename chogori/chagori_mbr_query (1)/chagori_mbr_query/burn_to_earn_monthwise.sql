

SELECT DATE_FORMAT(CURDATE() - INTERVAL 1 MONTH, '%Y-%m-01') INTO @startdate;
SELECT LAST_DAY(CURDATE() - INTERVAL 1 MONTH) INTO @enddate;


SET @startdate4m = DATE_SUB(@startdate, INTERVAL 3 MONTH);


SET @curr_month = MONTHNAME(@enddate);
SET @prev_month = MONTHNAME(DATE_SUB(@enddate, INTERVAL 1 MONTH));
SET @prev_second_month = MONTHNAME(DATE_SUB(@enddate, INTERVAL 2 MONTH));
SET @prev_third_month = MONTHNAME(DATE_SUB(@enddate, INTERVAL 3 MONTH));


SELECT
    CASE 
        WHEN `month` = @curr_month THEN 'curr_month'
        WHEN `month` = @prev_month THEN 'prev_month'
        WHEN `month` = @prev_second_month THEN 'prev_second_month'
        WHEN `month` = @prev_third_month THEN 'prev_third_month'
        ELSE 'other_month' 
    END AS mom,
    SUM(points_collected) AS points_collected,
    SUM(points_reedemed) AS points_reedemed
FROM (
    SELECT
        MONTHNAME(txndate) AS `month`,
        SUM(pointscollected) AS points_collected,
        SUM(pointsspent) AS points_reedemed
    FROM txn_report_accrual_redemption 
    WHERE storecode <> 'demo' 
      AND billno NOT LIKE '%test%' 
      AND billno NOT LIKE '%roll%'
      AND txndate BETWEEN @startdate4m AND @enddate 
    GROUP BY 1
) a 
GROUP BY 1
ORDER BY 
    FIELD(mom, 'prev_third_month', 'prev_second_month', 'prev_month', 'curr_month');