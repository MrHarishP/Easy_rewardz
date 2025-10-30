
-- 1st Apr'25 - 30th June'25

SELECT 
MONTHNAME(txndate),
COUNT(DISTINCT mobile)CUSTOMER,
SUM(amount)sales,
COUNT(DISTINCT uniquebillno)BILLS
FROM campuscrm.txn_report_accrual_redemption
WHERE txndate BETWEEN '2025-01-01' AND '2025-06-30'
AND storecode NOT LIKE '%demo%'
AND billno NOT LIKE '%test%'
AND billno NOT LIKE '%roll%'
AND storecode NOT IN ('Corporate')
AND storecode  LIKE '%ecom%'
AND storecode IN(SELECT StoreCode FROM STORE_MASTER WHERE StoreType1 LIKE '%FOFO%')
AND amount>0 
GROUP BY 1;


