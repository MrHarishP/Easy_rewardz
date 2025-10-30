SELECT * FROM dummy.bb_FY22_23_txn_cusotmer_1;

SELECT * FROM dummy.bb_FY24_25_txn_cusotmer_1 ;



SELECT storecode,storetype1,region FROM store_master
GROUP BY 1;
SELECT storetype1,modifiedstorecode,modifiedstore FROM dummy.bb_FY21_22_txn_cusotmer_1 a JOIN sku_report_loyalty b USING(txnmappedmobile)
-- where storetype1 is null
GROUP BY 2;
-- base 

SELECT COUNT(DISTINCT txnmappedmobile) FROM dummy.bb_FY21_22_txn_cusotmer_1;#390537


-- customer who txn in june 
CREATE TABLE dummy.bb_FY21_22_txn_cusotmer_1
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
WHERE rn = 1;#390537


SELECT * FROM dummy.bb_FY21_22_txn_cusotmer_1;

ALTER TABLE dummy.bb_FY21_22_txn_cusotmer_1 
ADD INDEX first_store(first_store),
ADD INDEX mobile(txnmappedmobile),
ADD COLUMN Region VARCHAR(50),
ADD COLUMN StoreType1 VARCHAR(50),
ADD COLUMN txn_june_25 VARCHAR(5),
ADD COLUMN ytm_june_25 VARCHAR(5); 



UPDATE dummy.bb_FY21_22_txn_cusotmer_1 a 
JOIN store_master b
ON a.first_store=b.storecode
SET a.Region=b.Region,a.StoreType1=b.StoreType1;#390537

UPDATE dummy.bb_FY21_22_txn_cusotmer_1
SET storetype1 = TRIM(REPLACE(REPLACE(storetype1, '\r', ''), '\n', ''))
WHERE storetype1 IS NOT NULL;

SELECT COUNT(TXNMAPPEDMOBILE) FROM dummy.bb_FY21_22_txn_cusotmer_1 
WHERE StoreType1='FOFO';


-- june 01- jun3e 30
UPDATE  dummy.bb_FY21_22_txn_cusotmer_1 A JOIN SKU_REPORT_LOYALTY B 
USING(TXNMAPPEDMOBILE)
SET A.txn_june_25='1'
WHERE B.MODIFIEDTXNDATE BETWEEN '2025-06-01' AND '2025-06-30';#8008

-- ytm apr to june25

UPDATE  dummy.bb_FY21_22_txn_cusotmer_1 A JOIN SKU_REPORT_LOYALTY B 
USING(TXNMAPPEDMOBILE)
SET A.ytm_june_25='1'
WHERE B.MODIFIEDTXNDATE BETWEEN '2025-04-01' AND '2025-06-30';#19868

SELECT StoreType1,COUNT(DISTINCT txnmappedmobile)customer 
FROM dummy.bb_FY21_22_txn_cusotmer_1
GROUP BY 1;
-- ytm customre
SELECT COUNT(DISTINCT txnmappedmobile)customer FROM dummy.bb_FY21_22_txn_cusotmer_1
WHERE ytm_june_25=1;#19868
-- store level

SELECT storetype1,COUNT(DISTINCT txnmappedmobile)customer FROM dummy.bb_FY21_22_txn_cusotmer_1
WHERE ytm_june_25=1
GROUP BY 1;#19868

-- june customer
SELECT COUNT(DISTINCT txnmappedmobile)customer FROM dummy.bb_FY21_22_txn_cusotmer_1
WHERE txn_june_25=1;

-- store level 

SELECT storetype1,COUNT(DISTINCT txnmappedmobile)customer FROM dummy.bb_FY21_22_txn_cusotmer_1
WHERE txn_june_25=1
GROUP BY 1;
-- region level

SELECT
StoreType1,
Region,
COUNT(DISTINCT txnmappedmobile)customer 
FROM dummy.bb_FY21_22_txn_cusotmer_1
WHERE storetype1 ='coco'
GROUP BY 1,2;


-- juen txn

SELECT
StoreType1,
Region,
COUNT(DISTINCT txnmappedmobile)customer 
FROM dummy.bb_FY21_22_txn_cusotmer_1
WHERE storetype1 ='fofo' AND txn_june_25=1
GROUP BY 1,2;
-- ytm june 

SELECT
StoreType1,
Region,
COUNT(DISTINCT txnmappedmobile)customer 
FROM dummy.bb_FY21_22_txn_cusotmer_1
WHERE storetype1 ='coco' AND ytm_june_25=1
GROUP BY 1,2;

################################################################################################3

-- fy 23_24


-- base 

SELECT COUNT(DISTINCT txnmappedmobile) FROM dummy.bb_FY23_24_txn_cusotmer_1;#549580


-- customer who txn in june 
INSERT INTO dummy.bb_FY23_24_txn_cusotmer_1
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
WHERE rn = 1;#549580


SELECT * FROM dummy.bb_FY23_24_txn_cusotmer_1;

ALTER TABLE dummy.bb_FY23_24_txn_cusotmer_1
ADD INDEX first_store(first_store),
ADD INDEX mobile(txnmappedmobile),
ADD COLUMN Region VARCHAR(50),
ADD COLUMN StoreType1 VARCHAR(50),
ADD COLUMN txn_june_25 VARCHAR(5),
ADD COLUMN ytm_june_25 VARCHAR(5); 



UPDATE dummy.bb_FY23_24_txn_cusotmer_1 a 
JOIN store_master b
ON a.first_store=b.storecode
SET a.Region=b.Region,a.StoreType1=b.StoreType1;#549580

UPDATE dummy.bb_FY23_24_txn_cusotmer_1
SET storetype1 = TRIM(REPLACE(REPLACE(storetype1, '\r', ''), '\n', ''))
WHERE storetype1 IS NOT NULL;

SELECT StoreType1,COUNT(TXNMAPPEDMOBILE) FROM dummy.bb_FY23_24_txn_cusotmer_1 
GROUP BY 1;


-- june 01- jun3e 30
UPDATE  dummy.bb_FY23_24_txn_cusotmer_1 A JOIN SKU_REPORT_LOYALTY B 
USING(TXNMAPPEDMOBILE)
SET A.txn_june_25='1'
WHERE B.MODIFIEDTXNDATE BETWEEN '2025-06-01' AND '2025-06-30';#15368

-- ytm apr to june25

UPDATE  dummy.bb_FY23_24_txn_cusotmer_1 A JOIN SKU_REPORT_LOYALTY B 
USING(TXNMAPPEDMOBILE)
SET A.ytm_june_25='1'
WHERE B.MODIFIEDTXNDATE BETWEEN '2025-04-01' AND '2025-06-30';#19868

SELECT StoreType1,COUNT(DISTINCT txnmappedmobile)customer 
FROM dummy.bb_FY23_24_txn_cusotmer_1
GROUP BY 1;
-- ytm customre
SELECT COUNT(DISTINCT txnmappedmobile)customer FROM dummy.bb_FY23_24_txn_cusotmer_1
WHERE ytm_june_25=1 GROUP BY 1;#19868
-- store level

SELECT storetype1,COUNT(DISTINCT txnmappedmobile)customer FROM dummy.bb_FY23_24_txn_cusotmer_1
WHERE ytm_june_25=1
GROUP BY 1;#19868

-- june customer
SELECT COUNT(DISTINCT txnmappedmobile)customer FROM dummy.bb_FY23_24_txn_cusotmer_1
WHERE txn_june_25=1;

-- store level 

SELECT storetype1,COUNT(DISTINCT txnmappedmobile)customer FROM dummy.bb_FY23_24_txn_cusotmer_1
WHERE txn_june_25=1
GROUP BY 1;
-- region level

SELECT
StoreType1,
Region,
COUNT(DISTINCT txnmappedmobile)customer 
FROM dummy.bb_FY23_24_txn_cusotmer_1
WHERE storetype1 ='fofo'
GROUP BY 1,2;

-- june txn
SELECT
StoreType1,
Region,
COUNT(DISTINCT txnmappedmobile)customer 
FROM dummy.bb_FY23_24_txn_cusotmer_1
WHERE storetype1 ='fofo' AND txn_june_25=1
GROUP BY 1,2;

-- ytm juen 


-- june txn
SELECT
StoreType1,
Region,
COUNT(DISTINCT txnmappedmobile)customer 
FROM dummy.bb_FY23_24_txn_cusotmer_1
WHERE storetype1 ='fofo' AND ytm_june_25=1
GROUP BY 1,2;


################################################################################################3

