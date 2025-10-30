


SELECT DATE_FORMAT(CURDATE() - INTERVAL 1 MONTH, '%Y-%m-01') INTO @startdate;
SELECT LAST_DAY(CURDATE() - INTERVAL 1 MONTH) INTO @enddate;


SELECT LpaasStore AS lpaasstore,
storecode,SUM(pointscollected)points_collected,SUM(pointsspent)points_reedemed FROM txn_report_accrual_redemption a JOIN store_master b USING(storecode)
WHERE TxnDate BETWEEN @startdate AND @enddate
AND storecode NOT LIKE '%demo%' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
GROUP BY 1,2;


