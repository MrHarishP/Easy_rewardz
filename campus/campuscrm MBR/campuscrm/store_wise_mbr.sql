SELECT storecode,lpaasstore,storetype1,COUNT(DISTINCT mobile)customer,
SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills 
FROM txn_report_accrual_redemption a LEFT JOIN store_master b USING(storecode)
WHERE txndate BETWEEN '2025-09-01' AND '2025-09-30'  
AND a.storecode NOT LIKE '%demo%'
AND a.billno NOT LIKE '%test%'
AND a.billno NOT LIKE '%roll%'
AND a.storecode NOT IN ('Corporate')
AND a.storecode NOT LIKE '%ecom%'
AND a.amount > 0
AND a.insertiondate<'2025-10-08'
GROUP BY 1