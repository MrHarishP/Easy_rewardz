################################# winback segment start previews year ######################################

SELECT * FROM dummy.BB_May22_Apr23_transactors_pv_r;

INSERT INTO dummy.BB_May22_Apr23_transactors_pv_r
SELECT *FROM (
SELECT * FROM (
SELECT txnmappedmobile,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills,MAX(modifiedtxndate)max_txn  FROM sku_report_loyalty 
WHERE modifiedtxndate < '2024-06-01' AND modifiedstorecode <> 'demo' AND itemnetamount>0 
GROUP BY 1)a
WHERE max_txn < '2024-06-01')b
WHERE max_txn BETWEEN '2022-06-01' AND '2023-05-31';#

ALTER  TABLE dummy.BB_May22_Apr23_transactors_pv_r ADD INDEX mb(txnmappedmobile) ,ADD COLUMN tier VARCHAR(20),
ADD COLUMN fav_Formal VARCHAR(20),ADD COLUMN fav_Casual VARCHAR(20),
ADD COLUMN Mix_of_Category VARCHAR(20);



CREATE TABLE DUMMY.BB_FAV_Category_May22_Apr23_pv_1_r 
WITH sku_data AS(
SELECT txnmappedmobile,
ItemQty,
UniqueItemCode
FROM sku_report_loyalty
WHERE modifiedtxndate 
BETWEEN '2022-06-01' AND '2023-05-31' AND ItemNetAmount>0 AND modifiedstorecode <> 'demo'),
ITEM_MASTER AS 
(SELECT EAN,
Category_tag 
FROM dummy.blackberrys_EAN_CODE),
 SKU_ITEM_MASTER AS
(SELECT txnmappedmobile,ItemQty,UniqueItemCode,Category_tag FROM  sku_data A 
JOIN ITEM_MASTER B ON A.UniqueItemCode=B.EAN),
ItemQty AS
(SELECT  txnmappedmobile,Category_tag,SUM(ItemQty)ItemQty FROM SKU_ITEM_MASTER GROUP BY 1,2)
SELECT * ,ROW_NUMBER() OVER (PARTITION BY txnmappedmobile ORDER BY itemqty DESC) AS `rank` FROM ItemQty; -- 679174 row(s) affected

SELECT COUNT(DISTINCT txnmappedmobile) FROM DUMMY.BB_FAV_Category_May22_Apr23_pv_1_r; -- 416998

ALTER TABLE DUMMY.BB_FAV_Category_May22_Apr23_pv_1_r ADD INDEX a(txnmappedmobile);

SELECT * FROM dummy.BB_May22_Apr23_transactors_pv_r;

UPDATE dummy.BB_May22_Apr23_transactors_pv_r a JOIN member_report b ON a.txnmappedmobile = b.mobile
SET a.tier = b.tier; -- 460632 row(s) affected

SELECT tier, COUNT(DISTINCT txnmappedmobile) FROM dummy.BB_May22_Apr23_transactors_pv_r GROUP BY 1;



UPDATE dummy.BB_May22_Apr23_transactors_pv_r  a JOIN DUMMY.BB_FAV_Category_May22_Apr23_pv_1_r b 
USING(txnmappedmobile)
SET fav_Formal='1'
WHERE Category_tag='Formal' AND `rank`=1; -- 171311 row(s) affected

UPDATE dummy.BB_May22_Apr23_transactors_pv_r  a JOIN DUMMY.BB_FAV_Category_May22_Apr23_pv_1_r b 
USING(txnmappedmobile)
SET fav_Casual='1'
WHERE Category_tag='Casual' AND fav_Formal IS NULL AND `rank`=1; -- 94432 row(s) affected

UPDATE dummy.BB_May22_Apr23_transactors_pv_r SET Mix_of_Category='1'
WHERE fav_Formal IS NULL AND fav_Casual IS NULL; -- 197901 row(s) affected




-- Existing (R b/w 13-24 Month) - formal

SELECT COUNT(DISTINCT txnmappedmobile)customer,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills FROM  sku_report_loyalty 
WHERE txnmappedmobile IN (SELECT DISTINCT txnmappedmobile FROM dummy.BB_May22_Apr23_transactors_pv_r WHERE fav_formal='1' 
AND tier IS NOT NULL 
AND tier <> 'MVC')
AND modifiedtxndate BETWEEN '2024-06-01' AND '2024-06-30' AND modifiedstorecode <> 'demo' AND itemnetamount>0;


-- Existing (R b/w 13-24 Month) - Casual

SELECT COUNT(DISTINCT txnmappedmobile),SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills FROM  sku_report_loyalty 
WHERE txnmappedmobile IN (SELECT DISTINCT txnmappedmobile FROM dummy.BB_May22_Apr23_transactors_pv_r WHERE fav_Casual='1' 
AND tier IS NOT NULL 
AND tier <> 'MVC')
AND modifiedtxndate BETWEEN '2024-06-01' AND '2024-06-30' AND modifiedstorecode <> 'demo' AND itemnetamount>0;

-- Existing (R b/w 13-24 Month) - Mix of Category
SELECT COUNT(DISTINCT txnmappedmobile),SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills FROM  sku_report_loyalty 
WHERE txnmappedmobile IN (SELECT DISTINCT txnmappedmobile FROM dummy.BB_May22_Apr23_transactors_pv_r WHERE Mix_of_Category='1' 
AND tier IS NOT NULL 
AND tier <> 'MVC')AND modifiedtxndate BETWEEN '2024-06-01' AND '2024-06-30' AND modifiedstorecode <> 'demo' AND itemnetamount>0;





SELECT COUNT(txnmappedmobile), SUM(sales), SUM(bills) FROM dummy.BB_May22_Apr23_transactors_pv_r WHERE fav_Formal='1' AND tier IS NOT NULL 
AND tier <> 'MVC'; 

SELECT COUNT(txnmappedmobile), SUM(sales), SUM(bills) FROM dummy.BB_May22_Apr23_transactors_pv_r WHERE fav_Casual='1'AND tier IS NOT NULL 
AND tier <> 'MVC';

SELECT COUNT(txnmappedmobile), SUM(sales), SUM(bills)  FROM dummy.BB_May22_Apr23_transactors_pv_r WHERE Mix_of_Category='1'AND tier IS NOT NULL 
AND tier <> 'MVC';
