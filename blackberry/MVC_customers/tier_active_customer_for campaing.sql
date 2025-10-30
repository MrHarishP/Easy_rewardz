
CREATE TABLE dummy.harish_apr25_active_new_one_repater
WITH sku AS
(SELECT txnmappedmobile mobile,SUM(itemnetamount)sales, COUNT(DISTINCT uniquebillno) bills, 
MAX(frequencycount)maxf,MIN(frequencycount)minf FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2025-04-01' AND '2025-04-30' GROUP BY 1),
member_report AS
(SELECT mobile,ModifiedEnrolledOn,tier FROM member_report WHERE ModifiedEnrolledOn >'2025-04-01' AND tier ='active'),
new_repater AS
(SELECT a.*,b.tier
 FROM sku a  JOIN member_report b USING(mobile))
 SELECT mobile, SUM(sales), SUM(bills) FROM new_repater 
 WHERE minf=1 GROUP BY 1;#21325

SELECT COUNT(DISTINCT mobile)customer,SUM(`sum(sales)`)sales,SUM(`sum(bills)`)bills FROM dummy.harish_apr25_active_new_one_repater

SELECT * FROM dummy.harish_bb_category_tag_apr25

INSERT INTO dummy.harish_bb_category_tag_apr25
SELECT Txnmappedmobile AS Mobile,uniquebillno,SUM(itemnetamount)Sales,
DATEDIFF('2025-04-30',MAX(modifiedtxndate))Recency
FROM sku_report_loyalty a JOIN member_report b ON a.Txnmappedmobile=b.mobile
WHERE modifiedtxndate BETWEEN '2024-05-01' AND'2025-04-30'
AND itemnetamount>0 AND b.tier='active' 
GROUP BY 1,2; #698914



-- fav_Category
SELECT * FROM dummy.harish_max_sales_apr25 

CREATE TABLE dummy.harish_max_sales_apr25 
SELECT mobile,MAX(sales) FROM dummy.harish_bb_category_tag_apr25 GROUP BY 1;#527422

ALTER TABLE dummy.harish_max_sales_apr25 ADD COLUMN recency VARCHAR(20),ADD COLUMN fav_Formal VARCHAR(20),
ADD COLUMN fav_Casual VARCHAR(20), ADD COLUMN Mix_of_Category VARCHAR(20),
ADD COLUMN Total_Visits VARCHAR(20);

SELECT * FROM dummy.harish_bb_campning_apr25

CREATE TABLE dummy.harish_bb_campning_apr25
WITH sku_data AS(
SELECT txnmappedmobile,
ItemQty,
UniqueItemCode
FROM sku_report_loyalty
WHERE modifiedtxndate 
BETWEEN '2024-05-01' AND'2025-04-30' AND ItemNetAmount>0),
ITEM_MASTER AS 
(SELECT EAN,
Category_tag 
FROM dummy.blackberrys_EAN_CODE),
 SKU_ITEM_MASTER AS
(SELECT txnmappedmobile,ItemQty,UniqueItemCode,Category_tag FROM  sku_data A 
JOIN ITEM_MASTER B ON A.UniqueItemCode=B.EAN),
ItemQty AS
(SELECT  txnmappedmobile,Category_tag,SUM(ItemQty)ItemQty FROM SKU_ITEM_MASTER GROUP BY 1,2)
SELECT * ,ROW_NUMBER() OVER (PARTITION BY txnmappedmobile ORDER BY itemqty DESC) AS `rank` FROM ItemQty; #852248

ALTER TABLE  dummy.harish_bb_campning_apr25 ADD INDEX a(txnmappedmobile);
ALTER TABLE dummy.harish_max_sales_apr25 CHANGE Total_Visits FrequencyCount INT;



SELECT * FROM dummy.harish_max_sales_apr25;

UPDATE dummy.harish_max_sales_apr25 a JOIN (
SELECT DISTINCT Mobile FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2024-05-01' AND'2025-04-30'
AND frequencycount=1) b USING(mobile)
SET a.FrequencyCount='1'; #354804

UPDATE dummy.harish_max_sales_apr25 a JOIN (
SELECT DISTINCT Mobile FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2024-05-01' AND'2025-04-30'
AND frequencycount>1) b USING(mobile)
SET a.FrequencyCount='2' WHERE a.FrequencyCount IS NULL;#172618



SELECT * FROM dummy.harish_max_sales_apr25

ALTER TABLE dummy.harish_max_sales_apr25 ADD COLUMN max_sales INT;

UPDATE dummy.harish_max_sales_apr25 SET max_sales ='1'
WHERE `max(sales)` BETWEEN  15000  AND 19500;#22556

UPDATE dummy.harish_max_sales_apr25 a JOIN  dummy.harish_bb_campning_apr25 b 
ON a.mobile=b.txnmappedmobile
SET fav_Formal='1'
WHERE b.Category_tag='Formal' AND b.`rank`=1 AND max_sales IS NULL;#189911

UPDATE dummy.harish_max_sales_apr25 a JOIN  dummy.harish_bb_campning_apr25 b 
ON a.mobile=b.txnmappedmobile SET fav_Casual='1'
 WHERE b.Category_tag='Casual' AND b.`rank`=1 AND max_sales IS NULL AND fav_Formal IS NULL ;#159869
 
 UPDATE dummy.harish_max_sales_apr25 SET Mix_of_Category='1'
 WHERE  max_sales IS NULL AND fav_Formal IS NULL  AND max_sales IS NULL AND fav_Casual IS NULL;#155086
 
 ALTER TABLE dummy.harish_max_sales_apr25 ADD COLUMN sales FLOAT,ADD COLUMN bills INT
 SELECT * FROM dummy.harish_max_sales_apr25
 

UPDATE dummy.harish_max_sales_apr25 a JOIN
(SELECT txnmappedmobile,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2024-05-01' AND '2025-04-30'
AND itemnetamount>0 AND modifiedstorecode <> 'demo'
GROUP BY 1
)b ON a.mobile=b.txnmappedmobile
SET a.sales=b.sales,a.bills=b.bills;#527422

 
 
 
SELECT COUNT(mobile),SUM(sales)sales,SUM(bills)bills FROM dummy.harish_max_sales_apr25  WHERE  max_sales='1';

SELECT FrequencyCount,COUNT(mobile),SUM(sales)sales,SUM(bills)bills FROM dummy.harish_max_sales_apr25  WHERE  fav_Formal='1'
GROUP BY 1;

SELECT FrequencyCount,COUNT(mobile),SUM(sales)sales,SUM(bills)bills FROM dummy.harish_max_sales_apr25 WHERE fav_Casual='1'
GROUP BY 1;

SELECT FrequencyCount,COUNT(mobile),SUM(sales)sales,SUM(bills)bills FROM dummy.harish_max_sales_apr25 WHERE Mix_of_Category='1'
GROUP BY 1;




