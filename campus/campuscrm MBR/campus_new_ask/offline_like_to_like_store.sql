INSERT INTO dummy.ovearll_storecode_24_25_base_offline
WITH 25_base AS
(
SELECT DISTINCT storecode  
FROM `campuscrm`.txn_report_accrual_redemption
WHERE txndate BETWEEN '2025-04-01' AND '2025-06-30'
AND storecode NOT LIKE '%demo%'
AND billno NOT LIKE '%test%'
AND billno NOT LIKE '%roll%'
AND storecode NOT IN ('Corporate')
AND storecode NOT LIKE '%ecom%'
),
24_base AS
(SELECT DISTINCT storecode 
FROM `campuscrm`.txn_report_accrual_redemption
WHERE txndate BETWEEN '2024-04-01' AND '2024-06-30'
AND storecode NOT LIKE '%demo%'
AND billno NOT LIKE '%test%'
AND billno NOT LIKE '%roll%'
AND storecode NOT IN ('Corporate')
AND storecode NOT LIKE '%ecom%')
SELECT DISTINCT storecode FROM 25_base a JOIN 24_base b
USING(storecode)  ;#227


ALTER TABLE  dummy.ovearll_storecode_24_25_base_offline ADD INDEX a(storecode);






-- 2025
WITH base_data AS 
(SELECT 
a.mobile AS mobile,
SUM(a.amount) AS sales,
COUNT(DISTINCT a.UniqueBillNo) AS bills,
MAX(a.frequencycount) AS maxf, 
MIN(a.frequencycount) AS minf,
COUNT(DISTINCT a.txndate) AS frequency,
DATEDIFF(MAX(a.txndate), MIN(a.txndate)) / NULLIF((COUNT(DISTINCT a.txndate) - 1), 0) AS Latency
FROM `campuscrm`.txn_report_accrual_redemption a JOIN dummy.ovearll_storecode_24_25_base_offline b
USING(storecode)
WHERE a.txndate BETWEEN '2025-04-01' AND '2025-06-30'
AND a.storecode NOT LIKE '%demo%'
AND a.billno NOT LIKE '%test%'
AND a.billno NOT LIKE '%roll%'
AND a.storecode NOT IN ('Corporate')
AND a.storecode NOT LIKE '%ecom%'
AND a.amount > 0
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




-- Qc
SELECT b.storecode,SUM(amount),COUNT(DISTINCT uniquebillno)
FROM `campuscrm`.txn_report_accrual_redemption a JOIN dummy.ovearll_storecode_24_25_base_offline b
USING(storecode)
WHERE a.txndate BETWEEN '2025-04-01' AND '2025-06-30'
AND a.storecode NOT LIKE '%demo%'
AND a.billno NOT LIKE '%test%'
AND a.billno NOT LIKE '%roll%'
AND a.storecode NOT IN ('Corporate')
AND a.storecode NOT LIKE '%ecom%'
AND a.amount > 0
GROUP BY 1;

SELECT DISTINCT storecode FROM dummy.ovearll_storecode_24_25_base_offline ;





INSERT INTO dummy.enrolledstore_overall_24_25_offline
WITH 25_base AS
(SELECT DISTINCT EnrolledStoreCode  FROM member_report
WHERE ModifiedEnrolledOn BETWEEN '2025-04-01' AND '2025-06-30'
    AND EnrolledStoreCode NOT LIKE '%demo%'
    AND EnrolledStoreCode NOT LIKE '%test%'
    AND EnrolledStoreCode NOT LIKE '%roll%'
    AND EnrolledStoreCode NOT IN ('Corporate')
    AND EnrolledStoreCode NOT LIKE '%ecom%'

    ),
24_base AS
(SELECT DISTINCT EnrolledStoreCode  FROM member_report
WHERE ModifiedEnrolledOn BETWEEN '2024-04-01' AND '2024-06-30'
    AND EnrolledStoreCode NOT LIKE '%demo%'
    AND EnrolledStoreCode NOT LIKE '%test%'
    AND EnrolledStoreCode NOT LIKE '%roll%'
    AND EnrolledStoreCode NOT IN ('Corporate')
    AND EnrolledStoreCode NOT LIKE '%ecom%') 
SELECT DISTINCT  EnrolledStoreCode FROM   25_base a JOIN 24_base b
USING(EnrolledStoreCode) ;#254


SELECT * FROM dummy.enrolledstore_overall_24_25_offline;



SELECT COUNT(a.mobile) 
FROM member_report a JOIN dummy.enrolledstore_overall_24_25_offline b
USING(EnrolledStoreCode)
WHERE a.ModifiedEnrolledOn BETWEEN '2025-04-01' AND '2025-06-30'
AND a.EnrolledStoreCode NOT LIKE '%demo%'
AND a.EnrolledStoreCode NOT LIKE '%test%'
AND a.EnrolledStoreCode NOT LIKE '%roll%'
AND a.EnrolledStoreCode NOT IN ('Corporate')
AND a.EnrolledStoreCode NOT LIKE '%ecom%';





INSERT INTO dummy.sku_non_loyalty_25_24_base_offline
WITH 25_base AS
(SELECT DISTINCT ModifiedStoreCode FROM sku_report_nonloyalty
WHERE modifiedtxndate BETWEEN '2025-04-01' AND '2025-06-30'
AND ModifiedStoreCode NOT LIKE '%demo%'
AND ModifiedBillNo NOT LIKE '%test%'
AND ModifiedBillNo NOT LIKE '%roll%'
AND ModifiedStoreCode NOT IN ('Corporate')
AND ModifiedStoreCode NOT LIKE '%ecom%'
),
24_base AS
(SELECT DISTINCT ModifiedStoreCode FROM sku_report_nonloyalty
WHERE modifiedtxndate BETWEEN '2024-04-01' AND '2024-06-30'
AND ModifiedStoreCode NOT LIKE '%demo%'
AND ModifiedBillNo NOT LIKE '%test%'
AND ModifiedBillNo NOT LIKE '%roll%'
AND ModifiedStoreCode NOT IN ('Corporate')
AND ModifiedStoreCode NOT LIKE '%ecom%'
)
SELECT DISTINCT ModifiedStoreCode FROM 25_base a JOIN 24_base USING(ModifiedStoreCode);#91




