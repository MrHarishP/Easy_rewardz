SELECT COUNT(DISTINCT storecode)storecount FROM dummy.ovearll_storecode_24sept_25sept_base; #229 will do this again 
SELECT COUNT(DISTINCT storecode)storecount FROM dummy.storecode_24sept_25sept_base_coco;#127
SELECT COUNT(DISTINCT storecode)storecount FROM dummy.storecode_24sept_25sept_base_fofo_1;#101 will do this again 
SELECT COUNT(DISTINCT storecode)storecount FROM dummy.storecode_24sept_25sept_base_offline;#228



CREATE TABLE dummy.ovearll_storecode_24sept_25sept_base
WITH 25_base AS
(
SELECT DISTINCT storecode  
FROM `campuscrm`.txn_report_accrual_redemption
WHERE txndate BETWEEN '2025-08-01' AND '2025-09-30'
AND storecode NOT LIKE '%demo%'
AND billno NOT LIKE '%test%'
AND billno NOT LIKE '%roll%'
AND storecode NOT IN ('Corporate')
-- AND storecode NOT LIKE '%ecom%'
-- and storecode in (select distinct storecode from store_master where ((storecode ='CAPLGDUK') OR (storetype1='fofo')))
),
24_base AS
(SELECT DISTINCT storecode 
FROM `campuscrm`.txn_report_accrual_redemption
WHERE txndate BETWEEN '2024-09-01' AND '2024-09-30'
AND storecode NOT LIKE '%demo%'
AND billno NOT LIKE '%test%'
AND billno NOT LIKE '%roll%'
AND storecode NOT IN ('Corporate')
-- AND storecode NOT LIKE '%ecom%' 
-- AND storecode IN (SELECT DISTINCT storecode FROM store_master WHERE ((storecode ='CAPLGDUK') OR (storetype1='fofo')))
)
SELECT DISTINCT storecode FROM 25_base a JOIN 24_base b
USING(storecode);#229,101,127


ALTER TABLE  dummy.ovearll_storecode_24sept_25sept_base ADD INDEX a(storecode);



-- select distinct storecode,lpaasstore,storetype1 
-- from  store_master  a 
-- JOIN dummy.ovearll_storecode_24sept_25sept_base_overall b using(storecode);
-- 
-- SELECT DISTINCT storecode,lpaasstore,storetype1 
-- FROM  store_master  a 
-- JOIN dummy.storecode_24sept_25sept_base_offline; b USING(storecode);
-- 
-- 
-- 


-- 2025
WITH base_data AS 
(SELECT 
a.mobile AS mobile,
CASE WHEN a.txndate BETWEEN '2024-09-01' AND '2024-09-30' THEN 'sept-24'
WHEN a.txndate BETWEEN '2025-08-01' AND '2025-08-31' THEN 'aug-25'
WHEN a.txndate BETWEEN '2025-09-01' AND '2025-09-30' THEN 'sept-25' 
END txnmonth,
SUM(a.amount) AS sales,
COUNT(DISTINCT a.UniqueBillNo) AS bills,
MAX(a.frequencycount) AS maxf, 
MIN(a.frequencycount) AS minf,
COUNT(DISTINCT a.txndate) AS frequency,
DATEDIFF(MAX(a.txndate), MIN(a.txndate)) / NULLIF((COUNT(DISTINCT a.txndate) - 1), 0) AS Latency,
SUM(storecode)storecode
FROM `campuscrm`.txn_report_accrual_redemption a JOIN dummy.ovearll_storecode_24sept_25sept_base b
USING(storecode)
WHERE ((a.txndate BETWEEN '2024-09-01' AND '2024-09-30')
OR (a.txndate BETWEEN '2025-08-01' AND '2025-08-31')
OR (a.txndate BETWEEN '2025-09-01' AND '2025-09-30'))
AND a.storecode NOT LIKE '%demo%'
AND a.billno NOT LIKE '%test%'
AND a.billno NOT LIKE '%roll%'
AND a.storecode NOT IN ('Corporate')
AND a.storecode NOT LIKE '%ecom%'
AND a.amount > 0
AND insertiondate<'2025-10-08'
GROUP BY 1,2
)
SELECT txnmonth,
 COUNT(DISTINCT mobile) AS `Transacting Customer`,
 COUNT(DISTINCT CASE WHEN minf =1 AND maxf=1 THEN mobile END)+ COUNT(DISTINCT CASE WHEN minf = 1  AND maxf>1 THEN mobile END) AS `New Customers`,
 COUNT(DISTINCT CASE WHEN minf = 1  AND maxf= 1 THEN mobile END) AS `New Onetimer`,
 COUNT(DISTINCT CASE WHEN minf = 1  AND maxf>1 THEN mobile END) AS `New_Repeater`,
 COUNT(DISTINCT CASE WHEN minf > 1 THEN mobile END) AS `Repeat Customers (Existing)`,
 SUM(sales) AS `Loyalty Sales`,
 SUM(CASE WHEN minf = 1 AND maxf=1 THEN sales END) +
 SUM(CASE WHEN minf = 1 AND maxf>1 THEN sales END) AS `New Customer Sales`,
 SUM(CASE WHEN minf > 1 THEN sales END) AS `Repeat Customer Sales`,
 SUM(bills) AS `Loyalty Bills`,
 SUM(CASE WHEN minf = 1 AND maxf=1 THEN bills END)+
 SUM(CASE WHEN minf = 1 AND maxf>1 THEN bills END) AS `New Customer Bills`,  
 SUM(CASE WHEN minf > 1 THEN bills END) AS `Repeat Customer Bills`,
 ROUND(SUM(sales) / NULLIF(SUM(bills), 0), 2) AS `Overall ATV`,
 ROUND(SUM(CASE WHEN minf = 1 AND maxf>1 THEN sales END ) / NULLIF(SUM(CASE WHEN minf=1 AND maxf>1 THEN bills END ),0), 2) AS `New Customers ATV`,
 ROUND(SUM(CASE WHEN minf > 1 THEN sales END ) / NULLIF(SUM(CASE WHEN minf>1 THEN bills END ), 0), 2) AS `Repeat Customers ATV`,
 ROUND(SUM(sales) / NULLIF(COUNT(mobile), 0), 2) AS `Overall AMV`,
 ROUND(SUM( CASE WHEN minf=1 AND maxf>1 THEN sales END ) / NULLIF(COUNT(CASE WHEN minf=1 AND maxf>1 THEN mobile END), 0), 2) AS `New Customer's AMV`,
 ROUND(SUM( CASE WHEN minf>1 THEN sales END ) / NULLIF(COUNT(CASE WHEN minf>1  THEN mobile END), 0), 2) AS `Repeat Customer's AMV`,
 AVG(frequency) AS `Overall Frequency`,
 SUM(Latency)/COUNT(DISTINCT CASE WHEN minf =1 AND maxf >1  THEN mobile END)Latency,
 storecode
 FROM base_data
 GROUP BY 1;




-- Qc
	SELECT SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills
	FROM `campuscrm`.txn_report_accrual_redemption a JOIN dummy.storecode_24sept_25sept_base_fofo b
	USING(storecode)
	WHERE a.txndate BETWEEN '2025-09-01' AND '2025-09-30'
	AND a.storecode NOT LIKE '%demo%'
	AND a.billno NOT LIKE '%test%'
	AND a.billno NOT LIKE '%roll%'
	AND a.storecode NOT IN ('Corporate')
	AND a.storecode NOT LIKE '%ecom%'
	AND a.amount > 0
	GROUP BY 1;

SELECT DISTINCT storecode FROM dummy.ovearll_storecode_24jul_25jul_base_offline_fofo ;


enrolledstore_overall_24sept_25sept_overall;#246
dummy.enrolledstore_24sept_25sept_offline;#245
dummy.enrolledstore_24sept_25sept_coco;#127
dummy.enrolledstore_24sept_25sept_fofo;#118

CREATE TABLE dummy.enrolledstore_24sept_25sept_offline
WITH 25_base AS
(SELECT DISTINCT EnrolledStoreCode  FROM member_report
WHERE ModifiedEnrolledOn BETWEEN '2025-08-01' AND '2025-09-30'
    AND EnrolledStoreCode NOT LIKE '%demo%'
    AND EnrolledStoreCode NOT LIKE '%test%'
    AND EnrolledStoreCode NOT LIKE '%roll%'
    AND EnrolledStoreCode NOT IN ('Corporate')-- 
    AND EnrolledStoreCode NOT LIKE '%ecom%'
--     and EnrolledStoreCode in (select distinct storecode from store_master where ((storecode ='CAPLGDUK') OR (storetype1='fofo')))

    ),
24_base AS
(SELECT DISTINCT EnrolledStoreCode  FROM member_report
WHERE ModifiedEnrolledOn BETWEEN '2024-09-01' AND '2024-09-30'
    AND EnrolledStoreCode NOT LIKE '%demo%'
    AND EnrolledStoreCode NOT LIKE '%test%'
    AND EnrolledStoreCode NOT LIKE '%roll%'
    AND EnrolledStoreCode NOT IN ('Corporate')
    AND EnrolledStoreCode NOT LIKE '%ecom%'
--     AND EnrolledStoreCode IN (SELECT DISTINCT storecode FROM store_master WHERE ((storecode ='CAPLGDUK') OR (storetype1='fofo')))
    ) 
SELECT DISTINCT  EnrolledStoreCode FROM   25_base a JOIN 24_base b
USING(EnrolledStoreCode);#245,127,118


SELECT * FROM dummy.enrolledstore_overall_24jul_25jul_overall;



SELECT CASE WHEN a.ModifiedEnrolledOn BETWEEN '2024-09-01' AND '2024-09-30' THEN 'sept-24'
WHEN a.ModifiedEnrolledOn BETWEEN '2025-08-01' AND '2025-08-31' THEN 'aug-25'
WHEN  a.ModifiedEnrolledOn BETWEEN '2025-09-01' AND '2025-09-30' THEN 'sept-25'
END txnmonth,
COUNT(a.mobile)enrollment
FROM member_report a JOIN dummy.enrolledstore_overall_24sept_25sept_overall b
USING(EnrolledStoreCode)
WHERE ((a.ModifiedEnrolledOn BETWEEN '2024-09-01' AND '2024-09-30')
OR (a.ModifiedEnrolledOn BETWEEN '2025-08-01' AND '2025-08-31')
OR (a.ModifiedEnrolledOn BETWEEN '2025-09-01' AND '2025-09-30')
)
AND a.EnrolledStoreCode NOT LIKE '%demo%'
AND a.EnrolledStoreCode NOT LIKE '%test%'
AND a.EnrolledStoreCode NOT LIKE '%roll%'
AND a.EnrolledStoreCode NOT IN ('Corporate')
-- AND a.EnrolledStoreCode NOT LIKE '%ecom%'
AND insertiondate <'2025-10-08'
GROUP BY 1;


sku_non_loyalty_25sept_24sept_base_overall;#68
dummy.sku_non_loyalty_25sept_24sept_offline;68
sku_non_loyalty_25sept_24sept_coco;#40
dummy.sku_non_loyalty_25sept_24sept_fofo;#28


CREATE TABLE dummy.sku_non_loyalty_25sept_24sept_offline

WITH 25_base AS
(SELECT DISTINCT ModifiedStoreCode FROM sku_report_nonloyalty
WHERE modifiedtxndate BETWEEN '2025-08-01' AND '2025-09-30'
AND ModifiedStoreCode NOT LIKE '%demo%'
AND ModifiedBillNo NOT LIKE '%test%'
AND ModifiedBillNo NOT LIKE '%roll%'
AND ModifiedStoreCode NOT IN ('Corporate')-- 
AND ModifiedStoreCode NOT LIKE '%ecom%'
-- AND ModifiedStoreCode in (select distinct storecode from store_master where ((storecode ='CAPLGDUK') OR (storetype1='fofo')))

),
24_base AS
(SELECT DISTINCT ModifiedStoreCode FROM sku_report_nonloyalty
WHERE modifiedtxndate BETWEEN '2024-09-01' AND '2024-09-30'
AND ModifiedStoreCode NOT LIKE '%demo%'
AND ModifiedBillNo NOT LIKE '%test%'
AND ModifiedBillNo NOT LIKE '%roll%'
AND ModifiedStoreCode NOT IN ('Corporate')-- 
AND ModifiedStoreCode NOT LIKE '%ecom%'
-- AND ModifiedStoreCode IN (SELECT DISTINCT storecode FROM store_master WHERE ((storecode ='CAPLGDUK') OR (storetype1='fofo')))

)
SELECT DISTINCT ModifiedStoreCode FROM 25_base a JOIN 24_base USING(ModifiedStoreCode);#29



SELECT CASE WHEN modifiedtxndate BETWEEN '2024-09-01' AND '2024-09-30' THEN 'sept-24'
WHEN modifiedtxndate BETWEEN '2025-08-01' AND '2025-08-31' THEN 'aug-25'
WHEN modifiedtxndate BETWEEN '2025-09-01' AND '2025-09-30' THEN 'sept-25'
END txnmonth,
SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills 
FROM sku_report_nonloyalty JOIN dummy.sku_non_loyalty_25sept_24sept_base_overall USING(ModifiedStoreCode)
WHERE ((modifiedtxndate BETWEEN '2024-09-01' AND '2024-09-30')
OR (modifiedtxndate BETWEEN '2025-08-01' AND '2025-08-31')
OR (modifiedtxndate BETWEEN '2025-09-01' AND '2025-09-30'))
AND ModifiedStoreCode NOT LIKE '%demo%'
AND ModifiedBillNo NOT LIKE '%test%'
AND ModifiedBillNo NOT LIKE '%roll%'
AND ModifiedStoreCode NOT IN ('Corporate')
-- AND ModifiedStoreCode NOT LIKE '%ecom%'
GROUP BY 1

