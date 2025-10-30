
SELECT DATE_FORMAT(CURDATE() - INTERVAL 1 MONTH, '%Y-%m-01') INTO @startdate;
SELECT LAST_DAY(CURDATE() - INTERVAL 1 MONTH) INTO @enddate;



SELECT 
    YEAR(txndate) AS YEAR,
    SUM(pointscollected) AS points_collected,
    SUM(pointsspent) AS points_reedemed
FROM txn_report_accrual_redemption 
WHERE storecode <> 'demo' 
  AND billno NOT LIKE '%test%' 
  AND billno NOT LIKE '%roll%'
  AND txndate >='2024-01-01'
GROUP BY YEAR(txndate);
