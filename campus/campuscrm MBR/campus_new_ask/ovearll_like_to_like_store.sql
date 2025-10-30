SELECT DISTINCT storecode FROM dummy.ovearll_storecode_24_25_base


-- ovearll
INSERT INTO dummy.ovearll_storecode_24_25_base
WITH 25_base AS
(
SELECT DISTINCT storecode  
FROM `campuscrm`.txn_report_accrual_redemption
WHERE txndate BETWEEN '2025-04-01' AND '2025-06-30'
AND storecode NOT LIKE '%demo%'
AND billno NOT LIKE '%test%'
AND billno NOT LIKE '%roll%'
AND storecode NOT IN ('Corporate')
),
24_base AS
(SELECT DISTINCT storecode 
FROM `campuscrm`.txn_report_accrual_redemption
WHERE txndate BETWEEN '2024-04-01' AND '2024-06-30'
AND storecode NOT LIKE '%demo%'
AND billno NOT LIKE '%test%'
AND billno NOT LIKE '%roll%'
AND storecode NOT IN ('Corporate'))
SELECT DISTINCT storecode FROM 25_base a JOIN 24_base b
USING(storecode) ;#228



ALTER TABLE  dummy.ovearll_storecode_24_25_base ADD INDEX a(storecode);

-- 2025
WITH base_data AS 
(SELECT 
mobile AS mobile,
SUM(amount) AS sales,
COUNT(DISTINCT UniqueBillNo) AS bills,
MAX(frequencycount) AS maxf, 
MIN(frequencycount) AS minf,
COUNT(DISTINCT txndate) AS frequency,
DATEDIFF(MAX(txndate), MIN(txndate)) / NULLIF((COUNT(DISTINCT txndate) - 1), 0) AS Latency
FROM `campuscrm`.txn_report_accrual_redemption a JOIN dummy.ovearll_storecode_24_25_base b
USING(storecode)
WHERE txndate BETWEEN '2025-04-01' AND '2025-06-30'
AND storecode NOT LIKE '%demo%'
AND billno NOT LIKE '%test%'
AND billno NOT LIKE '%roll%'
AND storecode NOT IN ('Corporate')
AND amount > 0
GROUP BY 1
)
SELECT 
 COUNT(DISTINCT mobile) AS `Transacting Customer`,
 COUNT(DISTINCT CASE WHEN minf = 1 THEN mobile END) AS `New Customers`,
 COUNT(DISTINCT CASE WHEN minf > 1 THEN mobile END) AS `Repeat Customers (Existing)`,
 SUM(sales) AS `Loyalty Sales`,
 SUM(CASE WHEN minf = 1 THEN sales END) AS `New Customer Sales`,
 SUM(CASE WHEN minf > 1 THEN sales END) AS `Repeat Customer Sales`,
 SUM(bills) AS `Loyalty Bills`,
 SUM(CASE WHEN minf = 1 THEN bills END) AS `New Customer Bills`,  
 SUM(CASE WHEN minf > 1 THEN bills END) AS `Repeat Customer Bills`,
 ROUND(SUM(sales) / NULLIF(SUM(bills), 0), 2) AS `Overall ATV`,
 ROUND(SUM(sales) / NULLIF(COUNT(mobile), 0), 2) AS `Overall AMV`,           
 AVG(frequency) AS `Overall Frequency`,
 SUM(Latency)/COUNT(DISTINCT CASE WHEN minf =1 AND maxf >1  THEN mobile END)Latency
 FROM base_data;




-- 2024

WITH base_data AS 
(SELECT 
mobile AS mobile,
SUM(amount) AS sales,
COUNT(DISTINCT UniqueBillNo) AS bills,
MAX(frequencycount) AS maxf, 
MIN(frequencycount) AS minf,
COUNT(DISTINCT txndate) AS frequency,
DATEDIFF(MAX(txndate), MIN(txndate)) / NULLIF((COUNT(DISTINCT txndate) - 1), 0) AS Latency
FROM `campuscrm`.txn_report_accrual_redemption a JOIN dummy.ovearll_storecode_24_25_base b
USING(storecode)
WHERE txndate BETWEEN '2024-04-01' AND '2024-06-30'
AND storecode NOT LIKE '%demo%'
AND billno NOT LIKE '%test%'
AND billno NOT LIKE '%roll%'
AND storecode NOT IN ('Corporate')
AND amount > 0
GROUP BY 1
)
SELECT 
 COUNT(DISTINCT mobile) AS `Transacting Customer`,
 COUNT(DISTINCT CASE WHEN minf = 1 THEN mobile END) AS `New Customers`,
 COUNT(DISTINCT CASE WHEN minf > 1 THEN mobile END) AS `Repeat Customers (Existing)`,
 SUM(sales) AS `Loyalty Sales`,
 SUM(CASE WHEN minf = 1 THEN sales END) AS `New Customer Sales`,
 SUM(CASE WHEN minf > 1 THEN sales END) AS `Repeat Customer Sales`,
 SUM(bills) AS `Loyalty Bills`,
 SUM(CASE WHEN minf = 1 THEN bills END) AS `New Customer Bills`,  
 SUM(CASE WHEN minf > 1 THEN bills END) AS `Repeat Customer Bills`,
 ROUND(SUM(sales) / NULLIF(SUM(bills), 0), 2) AS `Overall ATV`,
 ROUND(SUM(sales) / NULLIF(COUNT(mobile), 0), 2) AS `Overall AMV`,           
 AVG(frequency) AS `Overall Frequency`,
 SUM(Latency)/COUNT(DISTINCT CASE WHEN minf =1 AND maxf >1  THEN mobile END)Latency
 FROM base_data;






-- QC
SELECT 
COUNT(DISTINCT mobile),
COUNT(DISTINCT uniquebillno),
SUM(amount)
FROM txn_report_accrual_redemption a JOIN dummy.ovearll_storecode_24_25_base b
USING(storecode) WHERE txndate BETWEEN '2024-04-01' AND '2024-06-30'
AND storecode NOT LIKE '%demo%'
AND billno NOT LIKE '%test%'
AND billno NOT LIKE '%roll%'
AND storecode NOT IN ('Corporate')
AND amount > 0;



-- Enrolled
INSERT INTO dummy.enrolledstore_overall_24_25
WITH 25_base AS
(SELECT DISTINCT EnrolledStoreCode  FROM member_report
WHERE ModifiedEnrolledOn BETWEEN '2025-04-01' AND '2025-06-30'
    AND EnrolledStoreCode NOT LIKE '%demo%'
    AND EnrolledStoreCode NOT LIKE '%test%'
    AND EnrolledStoreCode NOT LIKE '%roll%'
    AND EnrolledStoreCode NOT IN ('Corporate')),
24_base AS
(SELECT DISTINCT EnrolledStoreCode  FROM member_report
WHERE ModifiedEnrolledOn BETWEEN '2024-04-01' AND '2024-06-30'
    AND EnrolledStoreCode NOT LIKE '%demo%'
    AND EnrolledStoreCode NOT LIKE '%test%'
    AND EnrolledStoreCode NOT LIKE '%roll%'
    AND EnrolledStoreCode NOT IN ('Corporate')) 
SELECT DISTINCT  EnrolledStoreCode FROM   25_base a JOIN 24_base b
USING(EnrolledStoreCode);#255
    
    
  
-- 2024
SELECT COUNT(a.mobile) 
FROM member_report a JOIN dummy.enrolledstore_overall_24_25 b
USING(EnrolledStoreCode)
WHERE a.ModifiedEnrolledOn BETWEEN '2024-04-01' AND '2024-06-30'
AND a.EnrolledStoreCode NOT LIKE '%demo%'
AND a.EnrolledStoreCode NOT LIKE '%test%'
AND a.EnrolledStoreCode NOT LIKE '%roll%'
AND a.EnrolledStoreCode NOT IN ('Corporate');


-- 2025

SELECT COUNT(a.mobile) 
FROM member_report a JOIN dummy.enrolledstore_overall_24_25 b
USING(EnrolledStoreCode)
WHERE a.ModifiedEnrolledOn BETWEEN '2025-04-01' AND '2025-06-30'
AND a.EnrolledStoreCode NOT LIKE '%demo%'
AND a.EnrolledStoreCode NOT LIKE '%test%'
AND a.EnrolledStoreCode NOT LIKE '%roll%'
AND a.EnrolledStoreCode NOT IN ('Corporate');



-- non_loyalty_
INSERT INTO  dummy.sku_non_loyalty_25_24_base
WITH 25_base AS
(SELECT DISTINCT ModifiedStoreCode FROM sku_report_nonloyalty
WHERE modifiedtxndate BETWEEN '2025-04-01' AND '2025-06-30'
AND ModifiedStoreCode NOT LIKE '%demo%'
AND ModifiedBillNo NOT LIKE '%test%'
AND ModifiedBillNo NOT LIKE '%roll%'
AND ModifiedStoreCode NOT IN ('Corporate')),
24_base AS
(SELECT DISTINCT ModifiedStoreCode FROM sku_report_nonloyalty
WHERE modifiedtxndate BETWEEN '2024-04-01' AND '2024-06-30'
AND ModifiedStoreCode NOT LIKE '%demo%'
AND ModifiedBillNo NOT LIKE '%test%'
AND ModifiedBillNo NOT LIKE '%roll%'
AND ModifiedStoreCode NOT IN ('Corporate'))
SELECT DISTINCT ModifiedStoreCode FROM 25_base a JOIN 24_base USING(ModifiedStoreCode);



SELECT * FROM dummy.sku_non_loyalty_25_24_base;
ALTER TABLE dummy.sku_non_loyalty_25_24_base ADD INDEX a(ModifiedStoreCode);

SELECT SUM(itemnetamount),COUNT(DISTINCT uniquebillno)
 FROM sku_report_nonloyalty a JOIN dummy.sku_non_loyalty_25_24_base b
 USING(ModifiedStoreCode)
 WHERE modifiedtxndate BETWEEN  '2024-04-01' AND '2024-06-30'
 AND ModifiedStoreCode NOT LIKE '%demo%'
AND ModifiedBillNo NOT LIKE '%test%'
AND ModifiedBillNo NOT LIKE '%roll%'
AND ModifiedStoreCode NOT IN ('Corporate')
AND itemnetamount>0;
