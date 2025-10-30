
  
SELECT DATE_FORMAT(CURDATE() - INTERVAL 1 MONTH, '%Y-%m-01') INTO @startdate;
SELECT LAST_DAY(CURDATE() - INTERVAL 1 MONTH) INTO @enddate;

SELECT lpaasstore lpaas_store,storecode AS store_code,SUM(BILLS) bills,SUM(AMOUNT)amount,
 SUM(CUSTOMER)customers,SUM(nonloyaltybills) nonloyalty_bills,SUM(nonloyalty_sales)nonloyalty_sales
FROM (
SELECT 
lpaasstore, storecode,
SUM(amount) AS AMOUNT,COUNT(DISTINCT uniquebillno) AS BILLS,
 COUNT(DISTINCT mobile) AS CUSTOMER,0 AS nonloyaltybills,0 AS nonloyalty_sales
FROM txn_report_accrual_redemption a JOIN store_master b USING(storecode)
WHERE TxnDate BETWEEN @startdate AND @enddate AND modifiedbillno NOT LIKE '%test%'
AND storecode NOT LIKE '%demo%'AND modifiedbillno NOT LIKE '%roll%'
AND storecode NOT LIKE '%test%' GROUP BY  storecode
UNION ALL
SELECT lpaasstore,modifiedstorecode AS storecode,SUM(itemnetamount) AS AMOUNT,0 AS BILLS,0 AS CUSTOMER,
COUNT(DISTINCT uniquebillno) AS nonloyaltybills,SUM(itemnetamount) AS nonloyalty_sales
FROM sku_report_nonloyalty a JOIN store_master b ON a.modifiedstorecode = b.storecode
 WHERE modifiedTxnDate BETWEEN @startdate AND @enddate AND modifiedbillno NOT LIKE '%test%'
 AND a.storecode NOT LIKE '%demo%'AND a.modifiedbillno NOT LIKE '%roll%'
 AND a.storecode NOT LIKE '%test%'GROUP BY  modifiedstorecode
) AS combined GROUP BY  2 ORDER BY 2;