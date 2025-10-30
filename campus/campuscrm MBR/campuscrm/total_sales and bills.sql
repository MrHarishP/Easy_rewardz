-- Overall Campus Shoes Level



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


-- Offline Level - COCO


-- MAY 2025
SELECT SUM(SALES), SUM(BILLS) FROM (
    SELECT 
        SUM(amount) AS SALES,
        COUNT(DISTINCT UniqueBillNo) AS BILLS   
     FROM txn_report_accrual_redemption 
  a JOIN store_master b USING(storecode)
 WHERE amount > 0
      AND storecode NOT IN ('Demo','ecom','corporate')
      AND billno NOT LIKE '%test%' 
      AND billno NOT LIKE '%roll%' 
      AND storetype1 LIKE '%coco%'
      AND TXNDATE BETWEEN '2025-05-01' AND '2025-05-31'
    
    UNION 
    
    SELECT 
        SUM(ItemNetAmount) AS SALES,
        COUNT(DISTINCT UniqueBillNo) AS BILLS
    FROM SKU_REPORT_NONLOYALTY a
   JOIN store_master b ON b.storecode=a.ModifiedStoreCode
 WHERE ModifiedTxnDate BETWEEN '2025-05-01' AND '2025-05-31'
      AND ModifiedStoreCode NOT IN ('Demo','ecom','corporate')
      AND ModifiedBillNo NOT LIKE '%test%' 
      AND ModifiedBillNo NOT LIKE '%roll%' 
      AND storetype1 LIKE '%coco%'
      AND ItemNetAmount > 0
) A

UNION 

-- APRIL 2025
SELECT SUM(SALES), SUM(BILLS) FROM (
    SELECT 
        SUM(amount) AS SALES,
        COUNT(DISTINCT UniqueBillNo) AS BILLS
FROM txn_report_accrual_redemption 
  a JOIN store_master b USING(storecode)
    WHERE amount > 0
      AND storecode NOT IN ('Demo','ecom','corporate')
      AND billno NOT LIKE '%test%' 
      AND billno NOT LIKE '%roll%' 
      AND storetype1 LIKE '%coco%'
      AND TXNDATE BETWEEN '2025-04-01' AND '2025-04-30'
    
    UNION 
    
    SELECT 
        SUM(ItemNetAmount) AS SALES,
        COUNT(DISTINCT UniqueBillNo) AS BILLS
        FROM SKU_REPORT_NONLOYALTY a
   JOIN store_master b ON b.storecode=a.ModifiedStoreCode
WHERE ModifiedTxnDate BETWEEN '2025-04-01' AND '2025-04-30'
      AND ModifiedStoreCode NOT IN ('Demo','ecom','corporate')
      AND ModifiedBillNo NOT LIKE '%test%' 
      AND ModifiedBillNo NOT LIKE '%roll%' 
      AND storetype1 LIKE '%coco%'
      AND ItemNetAmount > 0
) A

UNION 

-- MAY 2024
SELECT SUM(SALES), SUM(BILLS) FROM (
    SELECT 
        SUM(amount) AS SALES,
        COUNT(DISTINCT UniqueBillNo) AS BILLS
FROM txn_report_accrual_redemption 
  a JOIN store_master b USING(storecode)
WHERE amount > 0
      AND storecode NOT IN ('Demo','ecom','corporate')
      AND billno NOT LIKE '%test%' 
      AND billno NOT LIKE '%roll%' 
      AND storetype1 LIKE '%coco%'
      AND TXNDATE BETWEEN '2024-05-01' AND '2024-05-31'
    
    UNION 
    
    SELECT 
        SUM(ItemNetAmount) AS SALES,
        COUNT(DISTINCT UniqueBillNo) AS BILLS
FROM SKU_REPORT_NONLOYALTY a
   JOIN store_master b ON b.storecode=a.ModifiedStoreCode
   WHERE ModifiedTxnDate BETWEEN '2024-05-01' AND '2024-05-31'
      AND ModifiedStoreCode NOT IN ('Demo','ecom','corporate')
      AND ModifiedBillNo NOT LIKE '%test%' 
      AND ModifiedBillNo NOT LIKE '%roll%' 
      AND storetype1 LIKE '%coco%'
      AND ItemNetAmount > 0
) A;








-- Offline Level - fOfO





-- MAY 2025
SELECT SUM(SALES), SUM(BILLS) FROM (
    SELECT 
        SUM(amount) AS SALES,
        COUNT(DISTINCT UniqueBillNo) AS BILLS   
     FROM txn_report_accrual_redemption 
  a JOIN store_master b USING(storecode)
 WHERE amount > 0
      AND storecode NOT IN ('Demo','ecom','corporate')
      AND billno NOT LIKE '%test%' 
      AND billno NOT LIKE '%roll%' 
      AND storetype1 LIKE '%fofo%'
      AND TXNDATE BETWEEN '2025-05-01' AND '2025-05-31'
    
    UNION 
    
    SELECT 
        SUM(ItemNetAmount) AS SALES,
        COUNT(DISTINCT UniqueBillNo) AS BILLS
    FROM SKU_REPORT_NONLOYALTY a
   JOIN store_master b ON b.storecode=a.ModifiedStoreCode
 WHERE ModifiedTxnDate BETWEEN '2025-05-01' AND '2025-05-31'
      AND ModifiedStoreCode NOT IN ('Demo','ecom','corporate')
      AND ModifiedBillNo NOT LIKE '%test%' 
      AND ModifiedBillNo NOT LIKE '%roll%' 
      AND storetype1 LIKE '%fofo%'
      AND ItemNetAmount > 0
) A

UNION 

-- APRIL 2025
SELECT SUM(SALES), SUM(BILLS) FROM (
    SELECT 
        SUM(amount) AS SALES,
        COUNT(DISTINCT UniqueBillNo) AS BILLS
FROM txn_report_accrual_redemption 
  a JOIN store_master b USING(storecode)
    WHERE amount > 0
      AND storecode NOT IN ('Demo','ecom','corporate')
      AND billno NOT LIKE '%test%' 
      AND billno NOT LIKE '%roll%' 
      AND storetype1 LIKE '%fofo%'
      AND TXNDATE BETWEEN '2025-04-01' AND '2025-04-30'
    
    UNION 
    
    SELECT 
        SUM(ItemNetAmount) AS SALES,
        COUNT(DISTINCT UniqueBillNo) AS BILLS
        FROM SKU_REPORT_NONLOYALTY a
   JOIN store_master b ON b.storecode=a.ModifiedStoreCode
WHERE ModifiedTxnDate BETWEEN '2025-04-01' AND '2025-04-30'
      AND ModifiedStoreCode NOT IN ('Demo','ecom','corporate')
      AND ModifiedBillNo NOT LIKE '%test%' 
      AND ModifiedBillNo NOT LIKE '%roll%' 
      AND storetype1 LIKE '%fofo%'
      AND ItemNetAmount > 0
) A

UNION 

-- MAY 2024
SELECT SUM(SALES), SUM(BILLS) FROM (
    SELECT 
        SUM(amount) AS SALES,
        COUNT(DISTINCT UniqueBillNo) AS BILLS
FROM txn_report_accrual_redemption 
  a JOIN store_master b USING(storecode)
WHERE amount > 0
      AND storecode NOT IN ('Demo','ecom','corporate')
      AND billno NOT LIKE '%test%' 
      AND billno NOT LIKE '%roll%' 
      AND storetype1 LIKE '%fofo%'
      AND TXNDATE BETWEEN '2024-05-01' AND '2024-05-31'
    
    UNION 
    
    SELECT 
        SUM(ItemNetAmount) AS SALES,
        COUNT(DISTINCT UniqueBillNo) AS BILLS
FROM SKU_REPORT_NONLOYALTY a
   JOIN store_master b ON b.storecode=a.ModifiedStoreCode
   WHERE ModifiedTxnDate BETWEEN '2024-05-01' AND '2024-05-31'
      AND ModifiedStoreCode NOT IN ('Demo','ecom','corporate')
      AND ModifiedBillNo NOT LIKE '%test%' 
      AND ModifiedBillNo NOT LIKE '%roll%' 
      AND storetype1 LIKE '%fofo%'
      AND ItemNetAmount > 0
) A;







-- MAY 2025
SELECT SUM(SALES), SUM(BILLS) FROM (
    SELECT 
        SUM(amount) AS SALES,
        COUNT(DISTINCT UniqueBillNo) AS BILLS   
     FROM txn_report_accrual_redemption 
 WHERE amount > 0
      AND storecode IN ('Demo','ecom','corporate')
      AND billno NOT LIKE '%test%' 
      AND billno NOT LIKE '%roll%' 
      AND TXNDATE BETWEEN '2025-05-01' AND '2025-05-31'
    
    UNION 
    
    SELECT 
        SUM(ItemNetAmount) AS SALES,
        COUNT(DISTINCT UniqueBillNo) AS BILLS
    FROM SKU_REPORT_NONLOYALTY 
     WHERE ModifiedTxnDate BETWEEN '2025-05-01' AND '2025-05-31'
      AND ModifiedStoreCode IN ('Demo','ecom','corporate')
      AND ModifiedBillNo NOT LIKE '%test%' 
      AND ModifiedBillNo NOT LIKE '%roll%' 
      AND ItemNetAmount > 0
) A
UNION 
-- APRIL 2025
SELECT SUM(SALES), SUM(BILLS) FROM (
    SELECT 
        SUM(amount) AS SALES,
        COUNT(DISTINCT UniqueBillNo) AS BILLS
FROM txn_report_accrual_redemption 
    WHERE amount > 0
      AND storecode  IN ('Demo','ecom','corporate')
      AND billno NOT LIKE '%test%' 
      AND billno NOT LIKE '%roll%' 
      AND TXNDATE BETWEEN '2025-04-01' AND '2025-04-30'
    
 UNION 
    
    SELECT 
        SUM(ItemNetAmount) AS SALES,
        COUNT(DISTINCT UniqueBillNo) AS BILLS
        FROM SKU_REPORT_NONLOYALTY 
WHERE ModifiedTxnDate BETWEEN '2025-04-01' AND '2025-04-30'
      AND ModifiedStoreCode  IN ('Demo','ecom','corporate')
      AND ModifiedBillNo NOT LIKE '%test%' 
      AND ModifiedBillNo NOT LIKE '%roll%' 
      AND ItemNetAmount > 0
) A

UNION 

-- MAY 2024
SELECT SUM(SALES), SUM(BILLS) FROM (
 SELECT 
 SUM(amount) AS SALES,
 COUNT(DISTINCT UniqueBillNo) AS BILLS
FROM txn_report_accrual_redemption 
WHERE amount > 0
AND storecode IN ('Demo','ecom','corporate')
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%' 
AND TXNDATE BETWEEN '2024-05-01' AND '2024-05-31'
 UNION 
SELECT SUM(ItemNetAmount) AS SALES,
COUNT(DISTINCT UniqueBillNo) AS BILLS
FROM SKU_REPORT_NONLOYALTY
WHERE ModifiedTxnDate BETWEEN '2024-05-01' AND '2024-05-31'
AND ModifiedStoreCode  IN ('Demo','ecom','corporate')
AND ModifiedBillNo NOT LIKE '%test%' 
AND ModifiedBillNo NOT LIKE '%roll%' 
AND ItemNetAmount > 0
) A;











-- MAY 2025
SELECT SUM(SALES), SUM(BILLS) FROM (
    SELECT 
        SUM(amount) AS SALES,
        COUNT(DISTINCT UniqueBillNo) AS BILLS   
     FROM txn_report_accrual_redemption 
 WHERE amount > 0
      AND storecode  NOT IN  ('Demo','ecom','corporate')
      AND billno NOT LIKE '%test%' 
      AND billno NOT LIKE '%roll%' 
      AND TXNDATE BETWEEN '2025-05-01' AND '2025-05-31'
    
    UNION 
    
    SELECT 
        SUM(ItemNetAmount) AS SALES,
        COUNT(DISTINCT UniqueBillNo) AS BILLS
    FROM SKU_REPORT_NONLOYALTY 
     WHERE ModifiedTxnDate BETWEEN '2025-05-01' AND '2025-05-31'
      AND ModifiedStoreCode  NOT IN  ('Demo','ecom','corporate')
      AND ModifiedBillNo NOT LIKE '%test%' 
      AND ModifiedBillNo NOT LIKE '%roll%' 
      AND ItemNetAmount > 0
) A
UNION 
-- APRIL 2025
SELECT SUM(SALES), SUM(BILLS) FROM (
    SELECT 
        SUM(amount) AS SALES,
        COUNT(DISTINCT UniqueBillNo) AS BILLS
FROM txn_report_accrual_redemption 
    WHERE amount > 0
      AND storecode   NOT IN  ('Demo','ecom','corporate')
      AND billno NOT LIKE '%test%' 
      AND billno NOT LIKE '%roll%' 
      AND TXNDATE BETWEEN '2025-04-01' AND '2025-04-30'
    
 UNION 
    
    SELECT 
        SUM(ItemNetAmount) AS SALES,
        COUNT(DISTINCT UniqueBillNo) AS BILLS
        FROM SKU_REPORT_NONLOYALTY 
WHERE ModifiedTxnDate BETWEEN '2025-04-01' AND '2025-04-30'
      AND ModifiedStoreCode  NOT IN  ('Demo','ecom','corporate')
      AND ModifiedBillNo NOT LIKE '%test%' 
      AND ModifiedBillNo NOT LIKE '%roll%' 
      AND ItemNetAmount > 0
) A

UNION 

-- MAY 2024
SELECT SUM(SALES), SUM(BILLS) FROM (
 SELECT 
 SUM(amount) AS SALES,
 COUNT(DISTINCT UniqueBillNo) AS BILLS
FROM txn_report_accrual_redemption 
WHERE amount > 0
AND storecode  NOT IN  ('Demo','ecom','corporate')
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%' 
AND TXNDATE BETWEEN '2024-05-01' AND '2024-05-31'
 UNION 
SELECT SUM(ItemNetAmount) AS SALES,
COUNT(DISTINCT UniqueBillNo) AS BILLS
FROM SKU_REPORT_NONLOYALTY
WHERE ModifiedTxnDate BETWEEN '2024-05-01' AND '2024-05-31'
AND ModifiedStoreCode NOT IN ('Demo','ecom','corporate')
AND ModifiedBillNo NOT LIKE '%test%' 
AND ModifiedBillNo NOT LIKE '%roll%' 
AND ItemNetAmount > 0
) A;




SELECT DISTINCT storetype1 FROM store_master WHERE city ='Surat';
SELECT DISTINCT storetype1 FROM store_master WHERE city='Ahmedabad';




