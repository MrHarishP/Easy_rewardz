INSERT INTO dummy.ovearll_storecode_24_25_base_offline_fofo
WITH 25_base AS
(
SELECT DISTINCT storecode  
FROM `campuscrm`.txn_report_accrual_redemption a JOIN store_master b
USING(storecode)
WHERE txndate BETWEEN '2025-04-01' AND '2025-06-30'
AND storecode NOT LIKE '%demo%'
AND billno NOT LIKE '%test%'
AND billno NOT LIKE '%roll%'
AND storecode NOT IN ('Corporate')
AND storecode NOT LIKE '%ecom%'
AND StoreType1 LIKE '%fofo%'
),
24_base AS
(
SELECT DISTINCT storecode  
FROM `campuscrm`.txn_report_accrual_redemption a JOIN store_master b
USING(storecode)
WHERE txndate BETWEEN '2024-04-01' AND '2024-06-30'
AND storecode NOT LIKE '%demo%'
AND billno NOT LIKE '%test%'
AND billno NOT LIKE '%roll%'
AND storecode NOT IN ('Corporate')
AND storecode NOT LIKE '%ecom%'
AND StoreType1 LIKE '%fofo%'
)
SELECT DISTINCT storecode FROM 25_base a JOIN 24_base b
USING(storecode);#104





ALTER TABLE  dummy.ovearll_storecode_24_25_base_offline_fofo ADD INDEX a(storecode);




WITH base_data AS 
(SELECT 
a.mobile AS mobile,
SUM(a.amount) AS sales,
COUNT(DISTINCT a.UniqueBillNo) AS bills,
MAX(a.frequencycount) AS maxf, 
MIN(a.frequencycount) AS minf,
COUNT(DISTINCT a.txndate) AS frequency,
DATEDIFF(MAX(a.txndate), MIN(a.txndate)) / NULLIF((COUNT(DISTINCT a.txndate) - 1), 0) AS Latency
FROM `campuscrm`.txn_report_accrual_redemption a JOIN store_master  b
USING(storecode)
WHERE a.txndate BETWEEN '2025-04-01' AND '2025-06-30'
AND a.storecode NOT LIKE '%demo%'
AND a.billno NOT LIKE '%test%'
AND a.billno NOT LIKE '%roll%'
AND a.storecode NOT IN ('Corporate')
AND a.storecode NOT LIKE '%ecom%'
AND storecode IN (SELECT storecode FROM dummy.ovearll_storecode_24_25_base_offline_fofo)
AND a.amount > 0
AND b.StoreType1 LIKE '%fofo%'
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





SELECT a.storecode,
SUM(amount),
COUNT(DISTINCT uniquebillno) 
FROM dummy.ovearll_storecode_24_25_base_offline_fofo a 
JOIN txn_report_accrual_redemption b
USING(storecode)
WHERE txndate BETWEEN '2025-04-01' AND '2025-06-30'
AND storecode NOT LIKE '%demo%'
AND billno NOT LIKE '%test%'
AND billno NOT LIKE '%roll%'
AND storecode NOT IN ('Corporate')
AND storecode NOT LIKE '%ecom%'
AND amount>0
GROUP BY 1;




INSERT INTO  dummy.enrolledstore_overall_24_25_offline_fofo
WITH 25_base AS
(
SELECT DISTINCT EnrolledStoreCode  FROM member_report a JOIN store_master b
ON a.EnrolledStoreCode=b.storecode
WHERE a.ModifiedEnrolledOn BETWEEN '2025-04-01' AND '2025-06-30'
    AND a.EnrolledStoreCode NOT LIKE '%demo%'
    AND a.EnrolledStoreCode NOT LIKE '%test%'
    AND a.EnrolledStoreCode NOT LIKE '%roll%'
    AND a.EnrolledStoreCode NOT IN ('Corporate')
    AND a.EnrolledStoreCode NOT LIKE '%ecom%'
    AND b.storetype1 LIKE '%fofo%'

    ),
24_base AS
(

SELECT DISTINCT EnrolledStoreCode  FROM member_report a JOIN store_master b
ON a.EnrolledStoreCode=b.storecode
WHERE a.ModifiedEnrolledOn BETWEEN '2024-04-01' AND '2024-06-30'
    AND a.EnrolledStoreCode NOT LIKE '%demo%'
    AND a.EnrolledStoreCode NOT LIKE '%test%'
    AND a.EnrolledStoreCode NOT LIKE '%roll%'
    AND a.EnrolledStoreCode NOT IN ('Corporate')
    AND a.EnrolledStoreCode NOT LIKE '%ecom%'
    AND b.storetype1 LIKE '%fofo%'
) 
SELECT DISTINCT  EnrolledStoreCode FROM   25_base a JOIN 24_base b
USING(EnrolledStoreCode);#127




SELECT a.EnrolledStoreCode,b.storetype1 FROM dummy.enrolledstore_overall_24_25_offline_fofo a JOIN store_master b
ON a.EnrolledStoreCode=b.storecode;






SELECT COUNT(a.mobile) FROM member_report a 
JOIN dummy.enrolledstore_overall_24_25_offline_fofo b
USING(EnrolledStoreCode)
WHERE a.ModifiedEnrolledOn BETWEEN '2025-04-01' AND '2025-06-30'
AND a.EnrolledStoreCode NOT LIKE '%demo%'
AND a.EnrolledStoreCode NOT LIKE '%test%'
AND a.EnrolledStoreCode NOT LIKE '%roll%'
AND a.EnrolledStoreCode NOT IN ('Corporate')
AND a.EnrolledStoreCode NOT LIKE '%ecom%'
AND a.EnrolledStoreCode IN (SELECT storecode FROM store_master WHERE storetype1 LIKE '%fofo%');



SELECT b.EnrolledStoreCode,COUNT(a.mobile) FROM member_report a 
JOIN dummy.enrolledstore_overall_24_25_offline_fofo b
USING(EnrolledStoreCode)
WHERE a.ModifiedEnrolledOn BETWEEN '2024-04-01' AND '2024-06-30'
AND a.EnrolledStoreCode NOT LIKE '%demo%'
AND a.EnrolledStoreCode NOT LIKE '%test%'
AND a.EnrolledStoreCode NOT LIKE '%roll%'
AND a.EnrolledStoreCode NOT IN ('Corporate')
AND a.EnrolledStoreCode NOT LIKE '%ecom%'
GROUP BY 1;








INSERT INTO dummy.sku_non_loyalty_25_24_base_offline_fofo
WITH 25_base AS
(SELECT DISTINCT ModifiedStoreCode FROM sku_report_nonloyalty a JOIN store_master b 
ON a.ModifiedStoreCode=b.storecode
WHERE modifiedtxndate BETWEEN '2025-04-01' AND '2025-06-30'
AND ModifiedStoreCode NOT LIKE '%demo%'
AND ModifiedBillNo NOT LIKE '%test%'
AND ModifiedBillNo NOT LIKE '%roll%'
AND ModifiedStoreCode NOT IN ('Corporate')
AND ModifiedStoreCode NOT LIKE '%ecom%'
AND b.storetype1 LIKE '%fofo%'
),
24_base AS
(SELECT DISTINCT ModifiedStoreCode FROM sku_report_nonloyalty a JOIN store_master b 
ON a.ModifiedStoreCode=b.storecode
WHERE modifiedtxndate BETWEEN '2024-04-01' AND '2024-06-30'
AND ModifiedStoreCode NOT LIKE '%demo%'
AND ModifiedBillNo NOT LIKE '%test%'
AND ModifiedBillNo NOT LIKE '%roll%'
AND ModifiedStoreCode NOT IN ('Corporate')
AND ModifiedStoreCode NOT LIKE '%ecom%'
AND b.storetype1 LIKE '%fofo%'
)
SELECT DISTINCT ModifiedStoreCode FROM 25_base a JOIN 24_base USING(ModifiedStoreCode) ;#43






SELECT SUM(itemnetamount),COUNT(DISTINCT uniquebillno)
 FROM sku_report_nonloyalty a JOIN dummy.sku_non_loyalty_25_24_base_offline_fofo b
 USING(ModifiedStoreCode)
 WHERE modifiedtxndate BETWEEN  '2024-04-01' AND '2024-06-30'
 AND ModifiedStoreCode NOT LIKE '%demo%'
AND ModifiedBillNo NOT LIKE '%test%'
AND ModifiedBillNo NOT LIKE '%roll%'
AND ModifiedStoreCode NOT IN ('Corporate')
AND itemnetamount>0;


SELECT DISTINCT modifiedstorecode FROM dummy.sku_non_loyalty_25_24_base_offline_fofo;



SELECT * FROM member_report;

SELECT * FROM txn_report_accrual_redemption;
SELECT * FROM `lapse_report`;