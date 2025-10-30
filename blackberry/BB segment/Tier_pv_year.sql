##########################################Tier active start previews year #################################################


CREATE TABLE dummy.harish_may24_active_new_one_repater_pv
WITH sku AS
(SELECT txnmappedmobile mobile,SUM(itemnetamount)sales, COUNT(DISTINCT uniquebillno) bills, 
MAX(frequencycount)maxf,MIN(frequencycount)minf FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2024-04-01' AND '2024-04-30' AND modifiedstorecode <> 'demo'
GROUP BY 1
HAVING sales<20000),
member_report AS
(SELECT mobile,ModifiedEnrolledOn,tier FROM member_report WHERE ModifiedEnrolledOn >'2024-04-01' 
AND enrolledstorecode <> 'demo'),
new_repater AS
(SELECT a.*,b.tier
 FROM sku a  JOIN member_report b USING(mobile))
 SELECT mobile, SUM(sales), SUM(bills) FROM new_repater 
 WHERE minf=1 AND maxf=1 GROUP BY 1 ;#28228



SELECT COUNT(DISTINCT mobile)customer,SUM(`sum(sales)`)sales,SUM(`sum(bills)`)bills FROM dummy.harish_may24_active_new_one_repater_pv;

SELECT COUNT(DISTINCT txnmappedmobile)customer,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills FROM sku_report_loyalty 
WHERE txnmappedmobile IN (SELECT DISTINCT mobile FROM dummy.harish_may24_active_new_one_repater_pv)
AND modifiedtxndate BETWEEN '2024-06-01' AND '2024-06-30';

SELECT * FROM dummy.harish_bb_category_tag_may24_pv

INSERT INTO dummy.harish_bb_category_tag_may24_pv
SELECT Txnmappedmobile AS Mobile,uniquebillno,SUM(itemnetamount)Sales,
DATEDIFF('2024-04-30',MAX(modifiedtxndate))Recency
FROM sku_report_loyalty a 
WHERE modifiedtxndate BETWEEN '2023-05-01' AND '2024-04-30'
AND itemnetamount>0 AND modifiedstorecode <> 'demo'
GROUP BY 1,2
HAVING sales<20000; #1006441



-- fav_Category
SELECT * FROM dummy.harish_max_sales_may24_pv 

CREATE TABLE dummy.harish_max_sales_may24_pv  
SELECT mobile,MAX(sales) FROM dummy.harish_bb_category_tag_may24_pv GROUP BY 1;#616645

ALTER TABLE dummy.harish_max_sales_may24_pv  ADD COLUMN recency VARCHAR(20),ADD COLUMN fav_Formal VARCHAR(20),
ADD COLUMN fav_Casual VARCHAR(20), ADD COLUMN Mix_of_Category VARCHAR(20),
ADD COLUMN frequencycount VARCHAR(20);

SELECT * FROM dummy.harish_bb_campning_may24_pv;

CREATE TABLE dummy.harish_bb_campning_may24_pv
WITH sku_data AS(
SELECT txnmappedmobile,
ItemQty,
UniqueItemCode
FROM sku_report_loyalty
WHERE modifiedtxndate 
BETWEEN '2023-05-01' AND'2024-04-30' AND ItemNetAmount>0 AND modifiedstorecode <> 'demo'),
ITEM_MASTER AS 
(SELECT EAN,
Category_tag 
FROM dummy.blackberrys_EAN_CODE),
 SKU_ITEM_MASTER AS
(SELECT txnmappedmobile,ItemQty,UniqueItemCode,Category_tag FROM  sku_data A 
JOIN ITEM_MASTER B ON A.UniqueItemCode=B.EAN),
ItemQty AS
(SELECT  txnmappedmobile,Category_tag,SUM(ItemQty)ItemQty FROM SKU_ITEM_MASTER GROUP BY 1,2)
SELECT * ,ROW_NUMBER() OVER (PARTITION BY txnmappedmobile ORDER BY itemqty DESC) AS `rank` FROM ItemQty; #1040122

ALTER TABLE  dummy.harish_bb_campning_may24_pv ADD INDEX a(txnmappedmobile);




SELECT * FROM dummy.harish_max_sales_may24_pv ;

UPDATE dummy.harish_max_sales_may24_pv  a JOIN (
SELECT DISTINCT Mobile FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2023-05-01' AND'2024-04-30' AND storecode <> 'demo'
AND frequencycount=1) b USING(mobile)
SET a.FrequencyCount='1'; #415948

UPDATE dummy.harish_max_sales_may24_pv  a JOIN (
SELECT DISTINCT Mobile FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2023-05-01' AND'2024-04-30' AND storecode <> 'demo'
AND frequencycount>1) b USING(mobile)
SET a.FrequencyCount='2' WHERE a.FrequencyCount IS NULL;#200695



SELECT * FROM dummy.harish_max_sales_may24_pv

ALTER TABLE dummy.harish_max_sales_may24_pv  ADD COLUMN max_sales INT;

UPDATE dummy.harish_max_sales_may24_pv  SET max_sales ='1'
WHERE `max(sales)` BETWEEN  15000  AND 19500;#51516

UPDATE dummy.harish_max_sales_may24_pv  a JOIN  dummy.harish_bb_campning_may24_pv b 
ON a.mobile=b.txnmappedmobile
SET fav_Formal='1'
WHERE b.Category_tag='Formal' AND b.`rank`=1 AND max_sales IS NULL;#287125

UPDATE dummy.harish_max_sales_may24_pv  a JOIN  dummy.harish_bb_campning_may24_pv b 
ON a.mobile=b.txnmappedmobile SET fav_Casual='1'
 WHERE b.Category_tag='Casual' AND b.`rank`=1 AND max_sales IS NULL AND fav_Formal IS NULL;#206927
 
 UPDATE dummy.harish_max_sales_may24_pv  SET Mix_of_Category='1'
 WHERE  max_sales IS NULL AND fav_Formal IS NULL  AND max_sales IS NULL AND fav_Casual IS NULL;#71077
 
 ALTER TABLE dummy.harish_max_sales_may24_pv  ADD COLUMN sales FLOAT,ADD COLUMN bills INT
 SELECT * FROM dummy.harish_max_sales_may24_pv 
 

UPDATE dummy.harish_max_sales_may24_pv  a JOIN
(SELECT txnmappedmobile,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2023-05-01' AND '2024-04-30'
AND itemnetamount>0 AND modifiedstorecode <> 'demo'
GROUP BY 1
)b ON a.mobile=b.txnmappedmobile
SET a.sales=b.sales,a.bills=b.bills;#616644

 
 
 
SELECT COUNT(mobile),SUM(sales)sales,SUM(bills)bills FROM dummy.harish_max_sales_may24_pv   WHERE  max_sales='1';

SELECT FrequencyCount,COUNT(mobile),SUM(sales)sales,SUM(bills)bills FROM dummy.harish_max_sales_may24_pv   WHERE  fav_Formal='1'
GROUP BY 1;

SELECT FrequencyCount,COUNT(mobile),SUM(sales)sales,SUM(bills)bills FROM dummy.harish_max_sales_may24_pv  WHERE fav_Casual='1'
GROUP BY 1;

SELECT FrequencyCount,COUNT(mobile),SUM(sales)sales,SUM(bills)bills FROM dummy.harish_max_sales_may24_pv  WHERE Mix_of_Category='1'
GROUP BY 1;





SELECT b.FrequencyCount,COUNT(DISTINCT txnmappedmobile)customer,SUM(itemnetamount)sales,
COUNT(DISTINCT uniquebillno)bills FROM sku_report_loyalty a JOIN dummy.harish_max_sales_may24_pv b ON a.txnmappedmobile=b.mobile
WHERE modifiedtxndate BETWEEN '2024-06-01' AND '2024-06-30' AND fav_Formal='1'
GROUP BY 1;

SELECT b.FrequencyCount,COUNT(DISTINCT txnmappedmobile)customer,SUM(itemnetamount)sales,
COUNT(DISTINCT uniquebillno)bills FROM sku_report_loyalty a JOIN dummy.harish_max_sales_may24_pv b ON a.txnmappedmobile=b.mobile
WHERE modifiedtxndate BETWEEN '2024-06-01' AND '2024-06-30' AND fav_Casual='1'
GROUP BY 1;


SELECT b.FrequencyCount,COUNT(DISTINCT txnmappedmobile)customer,SUM(itemnetamount)sales,
COUNT(DISTINCT uniquebillno)bills FROM sku_report_loyalty a JOIN dummy.harish_max_sales_may24_pv b ON a.txnmappedmobile=b.mobile
WHERE modifiedtxndate BETWEEN '2024-06-01' AND '2024-06-30' AND Mix_of_Category='1'
GROUP BY 1;


##########################################Tier active end previews year #################################################

