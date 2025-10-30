SELECT SUM(SALES),SUM(BILLS) FROM (
SELECT SUM(amount)SALES,
COUNT(DISTINCT UniqueBillNo) AS bills
FROM txn_report_accrual_redemption 
WHERE amount>0
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%' 
AND TXNDATE BETWEEN '2025-05-01' AND '2025-05-31'
UNION 
SELECT
SUM(ItemNetAmount)SALES,
COUNT(DISTINCT UniqueBillNo)BILLS
 FROM SKU_REPORT_NONLOYALTY 
WHERE ModifiedTxnDate 
BETWEEN  '2025-05-01' AND '2025-05-31'
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%' AND  ItemNetAmount>0)
A

UNION 
SELECT SUM(SALES),SUM(BILLS) FROM (
SELECT SUM(amount)SALES,
COUNT(DISTINCT UniqueBillNo) AS bills
FROM txn_report_accrual_redemption 
WHERE amount>0
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%' 
AND TXNDATE BETWEEN '2025-04-01' AND '2025-04-30'
UNION 
SELECT SUM(ItemNetAmount)SALES,
COUNT(DISTINCT UniqueBillNo)BILLS
 FROM SKU_REPORT_NONLOYALTY 
WHERE ModifiedTxnDate 
BETWEEN  '2025-04-01' AND '2025-04-30'
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%' AND  ItemNetAmount>0)
A
UNION 
SELECT SUM(SALES),SUM(BILLS) FROM (
SELECT SUM(amount)SALES,COUNT(DISTINCT UniqueBillNo) AS bills
FROM txn_report_accrual_redemption 
WHERE amount>0
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%' 
AND TXNDATE BETWEEN '2024-05-01' AND '2024-05-31'
UNION 
SELECT 
SUM(ItemNetAmount)SALES,
COUNT(DISTINCT UniqueBillNo)BILLS FROM SKU_REPORT_NONLOYALTY 
WHERE ModifiedTxnDate 
BETWEEN  '2024-05-01' AND '2024-05-31'
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%' AND  ItemNetAmount>0)
A;
