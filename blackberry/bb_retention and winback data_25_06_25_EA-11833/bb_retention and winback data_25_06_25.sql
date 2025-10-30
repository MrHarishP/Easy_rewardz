#FY 21-22
SELECT * FROM store_master WHERE StoreCode='ecom';

SELECT COUNT(DISTINCT txnmappedmobile) FROM dummy.bb_FY21_22_txn_cusotmer;#4,43,001

SELECT 
StoreType1,
COUNT(txnmappedmobile) 
FROM dummy.bb_FY21_22_txn_cusotmer
GROUP BY 1;


SELECT * FROM store_master WHERE 
INSERT INTO dummy.bb_FY21_22_txn_cusotmer
WITH users AS (
  SELECT DISTINCT txnmappedmobile 
  FROM `blackberrys`.sku_report_loyalty 
  WHERE modifiedtxndate BETWEEN '2021-04-01' AND '2022-03-31'
    AND itemnetamount > 0
    AND ModifiedStore NOT LIKE '%demo%' 
    AND txnmappedmobile <> ''
), first_transactions AS (
  SELECT 
    txnmappedmobile,
    modifiedtxndate,
    modifiedstorecode,
    ROW_NUMBER() OVER (
      PARTITION BY txnmappedmobile 
      ORDER BY modifiedtxndate, modifiedstorecode
    ) AS rn
  FROM `blackberrys`.sku_report_loyalty
  WHERE txnmappedmobile IN (SELECT txnmappedmobile FROM users)
)
SELECT
  txnmappedmobile,
  modifiedtxndate AS first_txn_date,
  modifiedstorecode AS first_store
FROM first_transactions
WHERE rn = 1 ;#4,43,001


ALTER TABLE dummy.bb_FY21_22_txn_cusotmer 
ADD COLUMN Region VARCHAR(50),
ADD COLUMN StoreType1 VARCHAR(50),
ADD INDEX a(first_store),
ADD INDEX b(txnmappedmobile),
ADD COLUMN TXN_APR_25 VARCHAR(5), 
ADD COLUMN TXN_MAY_25 VARCHAR(5),
ADD COLUMN ytm VARCHAR(5); 





UPDATE dummy.bb_FY21_22_txn_cusotmer a 
JOIN store_master b
ON a.first_store=b.storecode
SET a.Region=b.Region,a.StoreType1=b.StoreType1;#397608



UPDATE dummy.bb_FY21_22_txn_cusotmer
SET storetype1 = TRIM(REPLACE(REPLACE(storetype1, '\r', ''), '\n', ''))
WHERE storetype1 IS NOT NULL;

SELECT COUNT(TXNMAPPEDMOBILE) FROM dummy.bb_FY21_22_txn_cusotmer WHERE 
StoreType1='FOFO'




ALTER TABLE  dummy.bb_FY21_22_txn_cusotmer
ADD COLUMN TXN_APR_25 VARCHAR(5), 
ADD COLUMN TXN_MAY_25 VARCHAR(5); 


ALTER TABLE dummy.bb_FY21_22_txn_cusotmer 
ADD COLUMN ytm_june VARCHAR(5),
ADD COLUMN txn_june VARCHAR(5);



-- june25
SELECT * FROM dummy.bb_FY21_22_txn_cusotmer;
UPDATE  dummy.bb_FY21_22_txn_cusotmer A  JOIN SKU_REPORT_LOYALTY B 
USING(TXNMAPPEDMOBILE)
SET A.txn_june='1'
WHERE B.MODIFIEDTXNDATE BETWEEN '2025-06-01' AND '2025-06-30';#8230
--  ytm_june25

UPDATE  dummy.bb_FY21_22_txn_cusotmer A  JOIN SKU_REPORT_LOYALTY B 
USING(TXNMAPPEDMOBILE)
SET A.ytm_june='1'
WHERE B.MODIFIEDTXNDATE BETWEEN '2025-04-01' AND '2025-06-30';#20462


-- apr 25
SELECT * FROM dummy.bb_FY21_22_txn_cusotmer;
UPDATE  dummy.bb_FY21_22_txn_cusotmer A  JOIN SKU_REPORT_LOYALTY B 
USING(TXNMAPPEDMOBILE)
SET A.TXN_APR_25='1'
WHERE B.MODIFIEDTXNDATE BETWEEN '2025-04-01' AND '2025-04-30';#8052
	
-- 1st May'25 - 31st May'25


UPDATE  dummy.bb_FY21_22_txn_cusotmer A  JOIN SKU_REPORT_LOYALTY B 
USING(TXNMAPPEDMOBILE)
SET A.TXN_MAY_25='1'
WHERE B.MODIFIEDTXNDATE BETWEEN '2025-05-01' AND '2025-05-31';#6410


-- ___________1st Apr'25 - 31st May'25_____________


UPDATE  dummy.bb_FY21_22_txn_cusotmer A  JOIN SKU_REPORT_LOYALTY B 
USING(TXNMAPPEDMOBILE)
SET A.ytm='1'
WHERE B.MODIFIEDTXNDATE BETWEEN '2025-04-01' AND '2025-05-31';#13420


SELECT
StoreType1,
Region,
COUNT(DISTINCT txnmappedmobile)customer 
FROM dummy.bb_FY21_22_txn_cusotmer
GROUP BY 1,2;


WITH apr_25 AS
(SELECT * FROM dummy.bb_FY21_22_txn_cusotmer WHERE TXN_APR_25='1')
SELECT StoreType1,Region,COUNT(txnmappedmobile) FROM apr_25 GROUP BY 1,2
ORDER BY 1,2;

WITH ytm_25 AS
(SELECT * FROM dummy.bb_FY21_22_txn_cusotmer WHERE ytm='1')
SELECT 
StoreType1,
Region,COUNT(txnmappedmobile) FROM ytm_25 GROUP BY 1,2
ORDER BY 1,2;

WITH TXN_MAY AS
(SELECT * FROM dummy.bb_FY21_22_txn_cusotmer WHERE TXN_MAY_25='1')
SELECT 
StoreType1,
Region,
COUNT(txnmappedmobile) 
FROM TXN_MAY GROUP BY 1,2
ORDER BY 1,2;





-- __________________FY 22-23____________________

SELECT StoreType1,COUNT(txnmappedmobile)
FROM dummy.bb_FY22_23_txn_cusotmer
 GROUP BY 1;#5,86,911

INSERT INTO  dummy.bb_FY22_23_txn_cusotmer
WITH users AS (
  SELECT DISTINCT txnmappedmobile 
  FROM `blackberrys`.sku_report_loyalty 
  WHERE modifiedtxndate BETWEEN '2022-04-01' AND '2023-03-31'
    AND itemnetamount > 0
    AND ModifiedStore NOT LIKE '%demo%' 
    AND txnmappedmobile <> ''
), first_transactions AS (
  SELECT 
    txnmappedmobile,
    modifiedtxndate,
    modifiedstorecode,
    ROW_NUMBER() OVER (
      PARTITION BY txnmappedmobile 
      ORDER BY modifiedtxndate, modifiedstorecode
    ) AS rn
  FROM `blackberrys`.sku_report_loyalty
  WHERE txnmappedmobile IN (SELECT txnmappedmobile FROM users)
)
SELECT
  txnmappedmobile,
  modifiedtxndate AS first_txn_date,
  modifiedstorecode AS first_store
FROM first_transactions
WHERE rn = 1 ;#586911



ALTER TABLE dummy.bb_FY22_23_txn_cusotmer 
ADD COLUMN Region VARCHAR(50),
ADD COLUMN StoreType1 VARCHAR(50),
ADD INDEX a(first_store), 
ADD INDEX b(txnmappedmobile),
ADD COLUMN TXN_APR_25 VARCHAR(5), 
ADD COLUMN TXN_MAY_25 VARCHAR(5),
ADD COLUMN ytm VARCHAR(5); 






UPDATE dummy.bb_FY22_23_txn_cusotmer a 
JOIN store_master b
ON a.first_store=b.storecode
SET a.Region=b.Region,a.StoreType1=b.StoreType1;   

UPDATE dummy.bb_FY22_23_txn_cusotmer
SET storetype1 = TRIM(REPLACE(REPLACE(storetype1, '\r', ''), '\n', ''))
WHERE storetype1 IS NOT NULL;


-- 1st Apr'25 - 30th Apr'25


UPDATE  dummy.bb_FY22_23_txn_cusotmer A  
JOIN SKU_REPORT_LOYALTY B 
USING(TXNMAPPEDMOBILE)
SET A.TXN_APR_25='1'
WHERE B.MODIFIEDTXNDATE BETWEEN '2025-04-01' AND '2025-04-30';#11445

-- 1st May'25 - 31st May'25


UPDATE  dummy.bb_FY22_23_txn_cusotmer A  JOIN SKU_REPORT_LOYALTY B 
USING(TXNMAPPEDMOBILE)
SET A.TXN_MAY_25='1'
WHERE B.MODIFIEDTXNDATE BETWEEN '2025-05-01' AND '2025-05-31';#9164


-- ______1st Apr'25 - 31st May'25_______


UPDATE  dummy.bb_FY22_23_txn_cusotmer A  JOIN SKU_REPORT_LOYALTY B 
USING(TXNMAPPEDMOBILE)
SET A.ytm='1'
WHERE B.MODIFIEDTXNDATE BETWEEN '2025-04-01' AND '2025-05-31';#19180


SELECT 
StoreType1,
Region,
COUNT(txnmappedmobile)
FROM dummy.bb_FY22_23_txn_cusotmer
GROUP BY 1,2 ORDER BY 1,2;

WITH apr_25 AS
(SELECT * FROM  dummy.bb_FY22_23_txn_cusotmer 
WHERE TXN_APR_25='1')
SELECT 
StoreType1,
Region,
COUNT(txnmappedmobile) 
FROM apr_25 
GROUP BY 1,2 ORDER BY 1,2;


WITH ytm_25 AS
(SELECT * FROM  dummy.bb_FY22_23_txn_cusotmer 
WHERE ytm='1')
SELECT 
StoreType1,
Region,
COUNT(txnmappedmobile) 
FROM ytm_25 
GROUP BY 1,2 ORDER BY 1,2;

WITH MAY_25 AS
(SELECT * FROM  dummy.bb_FY22_23_txn_cusotmer WHERE TXN_MAY_25='1')
SELECT 
StoreType1,
Region,
COUNT(txnmappedmobile) 
FROM MAY_25 
GROUP BY 1,2 
ORDER BY 1,2;


-- _________fy23_24___________


INSERT INTO   dummy.bb_FY23_24_txn_cusotmer
WITH users AS (
  SELECT DISTINCT txnmappedmobile 
  FROM `blackberrys`.sku_report_loyalty 
  WHERE modifiedtxndate BETWEEN '2023-04-01' AND '2024-03-31'
    AND itemnetamount > 0
    AND ModifiedStore NOT LIKE '%demo%' 
    AND txnmappedmobile <> ''
), first_transactions AS (
  SELECT 
    txnmappedmobile,
    modifiedtxndate,
    modifiedstorecode,
    ROW_NUMBER() OVER (
      PARTITION BY txnmappedmobile 
      ORDER BY modifiedtxndate, modifiedstorecode
    ) AS rn
  FROM `blackberrys`.sku_report_loyalty
  WHERE txnmappedmobile IN (SELECT txnmappedmobile FROM users)
)
SELECT
  txnmappedmobile,
  modifiedtxndate AS first_txn_date,
  modifiedstorecode AS first_store
FROM first_transactions
WHERE rn = 1;#636678




ALTER TABLE dummy.bb_FY23_24_txn_cusotmer
ADD COLUMN ytm VARCHAR(5)
ADD COLUMN Region VARCHAR(50),
ADD COLUMN StoreType1 VARCHAR(50),
ADD INDEX a(first_store), 
ADD INDEX b(txnmappedmobile),
ADD COLUMN TXN_APR_25 VARCHAR(5), 
ADD COLUMN TXN_MAY_25 VARCHAR(5); 



UPDATE dummy.bb_FY23_24_txn_cusotmer a 
JOIN store_master b
ON a.first_store=b.storecode
SET a.Region=b.Region,a.StoreType1=b.StoreType1;#613220



UPDATE dummy.bb_FY23_24_txn_cusotmer
SET storetype1 = TRIM(REPLACE(REPLACE(storetype1, '\r', ''), '\n', ''))
WHERE storetype1 IS NOT NULL;



-- 1st Apr'25 - 30th Apr'25

UPDATE  dummy.bb_FY23_24_txn_cusotmer A  
JOIN SKU_REPORT_LOYALTY B 
USING(TXNMAPPEDMOBILE)
SET A.TXN_APR_25='1'
WHERE B.MODIFIEDTXNDATE BETWEEN '2025-04-01' AND '2025-04-30';#15291


-- 1st May'25 - 31st May'25

UPDATE  dummy.bb_FY23_24_txn_cusotmer A  JOIN SKU_REPORT_LOYALTY B 
USING(TXNMAPPEDMOBILE)
SET A.TXN_MAY_25='1'
WHERE B.MODIFIEDTXNDATE BETWEEN '2025-05-01' AND '2025-05-31';#12197


-- _______1st Apr'25 - 31st May'25________


UPDATE  dummy.bb_FY23_24_txn_cusotmer A  JOIN SKU_REPORT_LOYALTY B 
USING(TXNMAPPEDMOBILE)
SET A.ytm='1'
WHERE B.MODIFIEDTXNDATE BETWEEN '2025-04-01' AND '2025-05-31';#25535


SELECT 
StoreType1,
Region,
COUNT(txnmappedmobile)
FROM dummy.bb_FY23_24_txn_cusotmer
GROUP BY 1,2 ORDER BY 1,2;


-- _____24_25___




INSERT INTO dummy.bb_FY24_25_txn_cusotmer
WITH users AS (
  SELECT DISTINCT txnmappedmobile 
  FROM `blackberrys`.sku_report_loyalty 
  WHERE modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31'
    AND itemnetamount > 0
    AND ModifiedStore NOT LIKE '%demo%' 
    AND txnmappedmobile <> ''
), first_transactions AS (
  SELECT 
    txnmappedmobile,
    modifiedtxndate,
    modifiedstorecode,
    ROW_NUMBER() OVER (
      PARTITION BY txnmappedmobile 
      ORDER BY modifiedtxndate, modifiedstorecode
    ) AS rn
  FROM `blackberrys`.sku_report_loyalty
  WHERE txnmappedmobile IN (SELECT txnmappedmobile FROM users)
)
SELECT
  txnmappedmobile,
  modifiedtxndate AS first_txn_date,
  modifiedstorecode AS first_store
FROM first_transactions
WHERE rn = 1 ;#657333


ALTER TABLE dummy.bb_FY24_25_txn_cusotmer
ADD COLUMN ytm VARCHAR(5)
ADD COLUMN Region VARCHAR(50),
ADD COLUMN StoreType1 VARCHAR(50),
ADD INDEX a(first_store), 
ADD INDEX b(txnmappedmobile),
ADD COLUMN TXN_APR_25 VARCHAR(5), 
ADD COLUMN TXN_MAY_25 VARCHAR(5); 



UPDATE dummy.bb_FY24_25_txn_cusotmer a 
JOIN store_master b
ON a.first_store=b.storecode
SET a.Region=b.Region,a.StoreType1=b.StoreType1;#636157


UPDATE dummy.bb_FY24_25_txn_cusotmer
SET storetype1 = TRIM(REPLACE(REPLACE(storetype1, '\r', ''), '\n', ''))
WHERE storetype1 IS NOT NULL;#107121



-- 1st Apr'25 - 30th Apr'25

UPDATE  dummy.bb_FY24_25_txn_cusotmer A  
JOIN SKU_REPORT_LOYALTY B 
USING(TXNMAPPEDMOBILE)
SET A.TXN_APR_25='1'
WHERE B.MODIFIEDTXNDATE BETWEEN '2025-04-01' AND '2025-04-30';#20553



-- 1st May'25 - 31st May'25

UPDATE  dummy.bb_FY24_25_txn_cusotmer A  JOIN SKU_REPORT_LOYALTY B 
USING(TXNMAPPEDMOBILE)
SET A.TXN_MAY_25='1'
WHERE B.MODIFIEDTXNDATE BETWEEN '2025-05-01' AND '2025-05-31';#16163




UPDATE  dummy.bb_FY24_25_txn_cusotmer A  JOIN SKU_REPORT_LOYALTY B 
USING(TXNMAPPEDMOBILE)
SET A.ytm='1'
WHERE B.MODIFIEDTXNDATE BETWEEN '2025-04-01' AND '2025-05-31';#333982



SELECT 
StoreType1,
Region,
COUNT(txnmappedmobile)
FROM dummy.bb_FY24_25_txn_cusotmer GROUP BY 1,2;

WITH apr_25 AS
(SELECT * FROM dummy.bb_FY24_25_txn_cusotmer WHERE TXN_APR_25='1')
SELECT 
StoreType1,
Region,
COUNT(txnmappedmobile) 
FROM apr_25  GROUP BY 1,2 ORDER BY 1,2;





WITH ytm_25 AS
(SELECT * FROM dummy.bb_FY24_25_txn_cusotmer WHERE ytm='1')
SELECT 
StoreType1,
Region,
COUNT(txnmappedmobile) 
FROM ytm_25  GROUP BY 1,2 ORDER BY 1,2;


WITH txn_may AS
(SELECT * FROM dummy.bb_FY24_25_txn_cusotmer WHERE TXN_MAY_25='1')
SELECT 
StoreType1,
Region,
COUNT(txnmappedmobile) 
FROM txn_may 
GROUP BY 1,2 
ORDER BY 1,2;

SELECT StoreType1,COUNT(DISTINCT txnmappedmobile) FROM dummy.bb_FY24_25_txn_cusotmer
 GROUP BY 1;
 
 SELECT COUNT(storecode) FROM store_master WHERE StoreType1 IS NOT NULL;#143
 #577
 #720
 
 SELECT * FROM sku_report_loyalty;
 ``