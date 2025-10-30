CREATE TABLE dummy.BB_May23_Apr24_transactors
SELECT txnmappedmobile, SUM(itemnetamount) sales, COUNT(DISTINCT uniquebillno) bills, MAX(modifiedtxndate) max_txn_date
FROM sku_report_loyalty WHERE modifiedbillno NOT LIKE '%test%' AND modifiedbillno NOT LIKE '%roll%' 
AND modifiedstorecode NOT LIKE '%demo%' AND itemnetamount > 0 AND 1=0
GROUP BY txnmappedmobile
HAVING max_txn_date BETWEEN '2023-05-01' AND '2024-04-30';

INSERT INTO dummy.BB_May23_Apr24_transactors
SELECT txnmappedmobile, SUM(itemnetamount) sales, COUNT(DISTINCT uniquebillno) bills, MAX(modifiedtxndate) max_txn_date
FROM sku_report_loyalty WHERE modifiedbillno NOT LIKE '%test%' AND modifiedbillno NOT LIKE '%roll%' 
AND modifiedstorecode NOT LIKE '%demo%' AND itemnetamount > 0 
GROUP BY txnmappedmobile
HAVING max_txn_date BETWEEN '2023-05-01' AND '2024-04-30'; -- 495043 row(s) affected

ALTER  TABLE dummy.BB_May23_Apr24_transactors ADD COLUMN tier VARCHAR(20),
ADD COLUMN fav_Formal VARCHAR(20),ADD COLUMN fav_Casual VARCHAR(20),
ADD COLUMN Mix_of_Category VARCHAR(20);

ALTER  TABLE dummy.BB_May23_Apr24_transactors ADD INDEX mb(txnmappedmobile);

CREATE TABLE DUMMY.BB_FAV_Category_May23_Apr24 
WITH sku_data AS(
SELECT txnmappedmobile,
ItemQty,
UniqueItemCode
FROM sku_report_loyalty
WHERE modifiedtxndate 
BETWEEN '2023-05-01' AND '2024-04-30' AND ItemNetAmount>0),
ITEM_MASTER AS 
(SELECT EAN,
Category_tag 
FROM dummy.blackberrys_EAN_CODE),
 SKU_ITEM_MASTER AS
(SELECT txnmappedmobile,ItemQty,UniqueItemCode,Category_tag FROM  sku_data A 
JOIN ITEM_MASTER B ON A.UniqueItemCode=B.EAN),
ItemQty AS
(SELECT  txnmappedmobile,Category_tag,SUM(ItemQty)ItemQty FROM SKU_ITEM_MASTER GROUP BY 1,2)
SELECT * ,ROW_NUMBER() OVER (PARTITION BY txnmappedmobile ORDER BY itemqty DESC) AS `rank` FROM ItemQty; -- 1040122 row(s) affected

SELECT COUNT(DISTINCT txnmappedmobile) FROM DUMMY.BB_FAV_Category_May23_Apr24; -- 643802

ALTER TABLE DUMMY.BB_FAV_Category_May23_Apr24 ADD INDEX a(txnmappedmobile);

SELECT * FROM dummy.BB_May23_Apr24_transactors;

UPDATE dummy.BB_May23_Apr24_transactors a JOIN member_report b ON a.txnmappedmobile = b.mobile
SET a.tier = b.tier; -- 492969 row(s) affected

SELECT tier, COUNT(DISTINCT txnmappedmobile) FROM dummy.BB_May23_Apr24_transactors GROUP BY 1;


UPDATE dummy.BB_May23_Apr24_transactors  a JOIN DUMMY.BB_FAV_Category_May23_Apr24 b 
USING(txnmappedmobile)
SET fav_Formal='1'
WHERE Category_tag='Formal' AND `rank`=1; -- 261349 row(s) affected

UPDATE dummy.BB_May23_Apr24_transactors  a JOIN DUMMY.BB_FAV_Category_May23_Apr24 b 
USING(txnmappedmobile)
SET fav_Casual='1'
WHERE Category_tag='Casual' AND fav_Formal IS NULL AND `rank`=1; -- 165051 row(s) affected

UPDATE dummy.BB_May23_Apr24_transactors SET Mix_of_Category='1'
WHERE fav_Formal IS NULL AND fav_Casual IS NULL; -- 68643 row(s) affected

SELECT 68643 + 165051 + 261349 ; -- 495043

SELECT COUNT(txnmappedmobile), SUM(sales), SUM(bills) FROM dummy.BB_May23_Apr24_transactors WHERE fav_Formal='1' AND tier IS NOT NULL 
AND tier <> 'MVC'; 

SELECT COUNT(txnmappedmobile), SUM(sales), SUM(bills) FROM dummy.BB_May23_Apr24_transactors WHERE fav_Casual='1'AND tier IS NOT NULL 
AND tier <> 'MVC';

SELECT COUNT(txnmappedmobile), SUM(sales), SUM(bills)  FROM dummy.BB_May23_Apr24_transactors WHERE Mix_of_Category='1'AND tier IS NOT NULL 
AND tier <> 'MVC';