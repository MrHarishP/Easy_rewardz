###################################MVC customers start current year#################################################

-- mvc
SELECT * FROM dummy.tier_mvc_bb_may_25_harish;
CREATE TABLE dummy.tier_mvc_bb_may_25_harish
SELECT mobile,tier FROM member_report WHERE tier='mvc';#143759

ALTER TABLE dummy.tier_mvc_bb_may_25_harish ADD INDEX mobile(mobile),
ADD COLUMN bills VARCHAR(200),ADD COLUMN sales FLOAT,ADD COLUMN MAX_ATV FLOAT

SELECT * FROM dummy.tier_mvc_bb_may_25_harish

UPDATE dummy.tier_mvc_bb_may_25_harish a 
JOIN(
SELECT Txnmappedmobile AS Mobile,
COUNT(DISTINCT uniquebillno)bills,
SUM(itemnetamount)Sales,
MAX(itemnetamount)MAX_ATV
FROM sku_report_loyalty 
WHERE modifiedtxndate 
BETWEEN '2024-05-01' AND'2025-04-30'
AND itemnetamount>0 AND modifiedstorecode <> 'demo'
GROUP BY 1)b
USING(mobile)
SET a.bills=b.bills,
a.sales=b.sales,
a.MAX_ATV=b.MAX_ATV;#107764

UPDATE dummy.tier_mvc_bb_may_25_harish 
SET MAX_ATV='0' 
WHERE MAX_ATV IS NULL; #35995

ALTER TABLE dummy.tier_mvc_bb_may_25_harish
ADD COLUMN recency VARCHAR(30),
ADD COLUMN segment VARCHAR(200),ADD COLUMN maxf VARCHAR(20),
ADD COLUMN minf VARCHAR(20);

WITH max_min_data AS
(SELECT txnmappedmobile,
MAX(frequencycount)maxf,
MIN(frequencycount)minf
FROM sku_report_loyalty a 
JOIN dummy.tier_mvc_bb_may_25 b
ON a.txnmappedmobile=b.mobile GROUP BY 1)
UPDATE dummy.tier_mvc_bb_may_25_harish a 
JOIN max_min_data b 
ON a.mobile=b.txnmappedmobile 
SET a.maxf=b.maxf,a.minf=b.minf; #142267

UPDATE dummy.tier_mvc_bb_may_25_harish 
SET segment='MVC Customers whose Max of Bill Value is 0-6K'
WHERE MAX_ATV >=0 
AND MAX_ATV<=6000;#82125

UPDATE dummy.tier_mvc_bb_may_25_harish  
SET segment='MVC Customers whose Max of Bill Value is 6-10K'
WHERE MAX_ATV >6000 
AND MAX_ATV<=10000;#25516


UPDATE dummy.tier_mvc_bb_may_25_harish a JOIN
(SELECT * FROM dummy.tier_mvc_bb_may_25_harish
 WHERE maxf=1 AND segment IS NULL 
 AND max_atv>10000)
  b USING(mobile)
 SET a.segment='MVC One timers whose Max of Bill Value is greater than 10K';#14959



UPDATE dummy.tier_mvc_bb_may_25_harish a JOIN
(SELECT * FROM dummy.tier_mvc_bb_may_25_harish
 WHERE maxf>1 AND segment IS NULL
 AND max_atv>10000)
  b USING(mobile)
 SET a.segment='MVC Repeaters whose Max of Bill Value is greater than 10K';#21139
 

-- select * from dummy.tier_mvc_bb_may_25_harish where segment is null;

-- UPDATE dummy.tier_mvc_bb_may_25_harish SET segment='mvc_repeater' WHERE segment IS NULL;

SELECT segment,COUNT(DISTINCT mobile)customer,SUM(sales)sales,SUM(bills)bills FROM dummy.tier_mvc_bb_may_25_harish 
-- WHERE segment IS NOT NULL
GROUP BY 1;

SELECT DISTINCT segment FROM dummy.tier_mvc_bb_may_25_harish;

###################################MVC customers end current year #################################################







 ###################################### one timer start ############################################
CREATE TABLE dummy.harish_apr25_active_new_onetimer
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
 WHERE minf=1 AND maxf=1 GROUP BY 1;#21325

SELECT COUNT(DISTINCT mobile)customer,SUM(`sum(sales)`)sales,SUM(`sum(bills)`)bills FROM dummy.harish_apr25_active_new_onetimer;

ALTER TABLE dummy.harish_apr25_active_new_onetimer  ADD COLUMN segment VARCHAR(50);
UPDATE dummy.harish_apr25_active_new_onetimer 
SET segment = 'New Onetimer'
WHERE segment IS NULL; #21325
 ###################################### one timer end ############################################
 
 ##########################################Tier active start current year #################################################
SELECT * FROM dummy.harish_bb_category_tag_apr25

INSERT INTO dummy.harish_bb_category_tag_apr25
SELECT Txnmappedmobile AS Mobile,uniquebillno,SUM(itemnetamount)Sales,
DATEDIFF('2025-04-30',MAX(modifiedtxndate))Recency
FROM sku_report_loyalty a JOIN member_report b ON a.Txnmappedmobile=b.mobile
WHERE modifiedtxndate BETWEEN '2024-05-01' AND'2025-04-30'
AND itemnetamount>0 AND b.tier='active' 
GROUP BY 1,2; #698914



-- fav_Category
SELECT * FROM dummy.harish_max_sales_apr25;

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



SELECT * FROM dummy.harish_max_sales_apr25;

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

UPDATE dummy.harish_max_sales_apr25 
SET segment=(CASE WHEN max_sales='1' AND segment IS NULL THEN 'Existing (R b/w 1-12 Month) - High Value (15-19.5K)'
WHEN fav_Formal='1' AND FrequencyCount='1' AND segment IS NULL  THEN 'Existing onetimer (R b/w 1-12 Month) - Formal'
WHEN fav_Casual='1' AND FrequencyCount='1' AND segment IS NULL  THEN 'Existing onetimer (R b/w 1-12 Month) - Casual'
WHEN Mix_of_Category='1' AND FrequencyCount='1' AND segment IS NULL  THEN 'Existing onetimer (R b/w 1-12 Month) - Mix of Category'
WHEN fav_Formal='1' AND FrequencyCount='2' AND segment IS NULL  THEN  'Existing  repeat (R b/w 1-12 Month) - Formal'
WHEN fav_Casual='1' AND FrequencyCount='2' AND segment IS NULL  THEN 'Existing  repeat (R b/w 1-12 Month) - Casual'
WHEN Mix_of_Category='1' AND FrequencyCount='2' AND segment IS NULL  THEN 'Existing  repeat (R b/w 1-12 Month) - Mix of Category' END);#527422



##########################################Tier active end current year #################################################



################################# winback segment start current year ######################################

CREATE TABLE dummy.BB_May22_Apr23_transactors_pv_re
SELECT txnmappedmobile, SUM(itemnetamount) sales, COUNT(DISTINCT uniquebillno) bills, MAX(modifiedtxndate) max_txn_date
FROM sku_report_loyalty WHERE modifiedbillno <> '%test%' AND modifiedbillno <> '%roll%' 
AND modifiedstorecode <> '%demo%' AND itemnetamount > 0 AND 1=0
GROUP BY txnmappedmobile
HAVING max_txn_date BETWEEN '2023-05-01' AND '2024-04-30';


INSERT INTO dummy.BB_May22_Apr23_transactors_pv_re
SELECT txnmappedmobile, SUM(itemnetamount) sales, COUNT(DISTINCT uniquebillno) bills, MAX(modifiedtxndate) max_txn_date
FROM sku_report_loyalty WHERE modifiedbillno <> '%test%' AND modifiedbillno <> '%roll%' 
AND modifiedstorecode <> '%demo%' AND itemnetamount > 0 
GROUP BY txnmappedmobile
HAVING max_txn_date BETWEEN '2023-05-01' AND '2024-04-30'; -- 495043, 494269 row(s) affected

ALTER  TABLE dummy.BB_May22_Apr23_transactors_pv_re ADD COLUMN tier VARCHAR(20),
ADD COLUMN fav_Formal VARCHAR(20),ADD COLUMN fav_Casual VARCHAR(20),
ADD COLUMN Mix_of_Category VARCHAR(20);

ALTER  TABLE dummy.BB_May22_Apr23_transactors_pv_re ADD INDEX mb(txnmappedmobile);



CREATE TABLE DUMMY.BB_FAV_Category_May22_Apr23_pv_1_re 
WITH sku_data AS(
SELECT txnmappedmobile,
ItemQty,
UniqueItemCode
FROM sku_report_loyalty
WHERE modifiedtxndate 
BETWEEN '2023-05-01' AND '2024-04-30' AND ItemNetAmount>0 AND modifiedstorecode <> 'demo'),
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

SELECT COUNT(DISTINCT txnmappedmobile) FROM DUMMY.BB_FAV_Category_May22_Apr23_pv_1_re; -- 643802

ALTER TABLE DUMMY.BB_FAV_Category_May22_Apr23_pv_1_re ADD INDEX a(txnmappedmobile);

SELECT * FROM dummy.BB_May22_Apr23_transactors_pv_re;

UPDATE dummy.BB_May22_Apr23_transactors_pv_re a JOIN member_report b ON a.txnmappedmobile = b.mobile
SET a.tier = b.tier; -- 492969,492195 row(s) affected

SELECT tier, COUNT(DISTINCT txnmappedmobile) FROM dummy.BB_May22_Apr23_transactors_pv_re GROUP BY 1;




UPDATE dummy.BB_May22_Apr23_transactors_pv_re  a JOIN DUMMY.BB_FAV_Category_May22_Apr23_pv_1_re b 
USING(txnmappedmobile)
SET fav_Formal='1'
WHERE Category_tag='Formal' AND `rank`=1; -- 261349,260920 row(s) affected

UPDATE dummy.BB_May22_Apr23_transactors_pv_re  a JOIN DUMMY.BB_FAV_Category_May22_Apr23_pv_1_re b 
USING(txnmappedmobile)
SET fav_Casual='1'
WHERE Category_tag='Casual' AND fav_Formal IS NULL AND `rank`=1; -- 165051,164765 row(s) affected

UPDATE dummy.BB_May22_Apr23_transactors_pv_re SET Mix_of_Category='1'
WHERE fav_Formal IS NULL AND fav_Casual IS NULL; -- 68643,68584 row(s) affected

SELECT 68643 + 165051 + 261349 ; -- 495043

SELECT COUNT(txnmappedmobile), SUM(sales), SUM(bills) FROM dummy.BB_May22_Apr23_transactors_pv_re WHERE fav_Formal='1' AND tier IS NOT NULL 
AND tier <> 'MVC'; 

SELECT COUNT(txnmappedmobile), SUM(sales), SUM(bills) FROM dummy.BB_May22_Apr23_transactors_pv_re WHERE fav_Casual='1'AND tier IS NOT NULL 
AND tier <> 'MVC';

SELECT COUNT(txnmappedmobile), SUM(sales), SUM(bills)  FROM dummy.BB_May22_Apr23_transactors_pv_re WHERE Mix_of_Category='1'AND tier IS NOT NULL 
AND tier <> 'MVC';


ALTER TABLE dummy.BB_May22_Apr23_transactors_pv_re segment VARCHAR(50);
 
UPDATE dummy.BB_May22_Apr23_transactors_pv_re
SET segment=(
CASE 
WHEN fav_Formal='1' AND tier IS NOT NULL 
AND tier <> 'MVC' THEN 'Existing (R b/w 13-24 Month) - Formal' 
WHEN fav_Casual='1' AND tier IS NOT NULL 
AND tier <> 'MVC' THEN 'Existing (R b/w 13-24 Month) - Casual'
WHEN Mix_of_Category='1' AND tier IS NOT NULL 
AND tier <> 'MVC' THEN 'Existing (R b/w 13-24 Month) - Mix of Category' END);#459099
################################# winback segment end current year ######################################


#################################### customer who never transacte after given time period start current year ###########################################

-- ask 1 re
CREATE TABLE dummy.harish_re_active_apr23
WITH cte AS (SELECT * FROM 
(SELECT mobile,MAX(txndate)max_txn FROM txn_report_accrual_redemption 
GROUP BY 1)a
WHERE max_txn BETWEEN '2022-05-01' AND '2023-04-30'
),
sale AS (
SELECT mobile,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2022-05-01' AND '2023-04-30'
GROUP BY 1)
SELECT a.mobile,SUM(sales)sales,SUM(bills)bills FROM cte a JOIN sale b USING(mobile)
GROUP BY 1;#406554

ALTER TABLE dummy.harish_re_active_apr23 ADD COLUMN segment VARCHAR(50);

UPDATE dummy.harish_re_active_apr23
SET segment= 'Reactivation (R b/w 24-36 Months)'
WHERE segment IS NULL;#406554

-- ask2
CREATE TABLE dummy.harish_re_active_befor22
WITH base_1 AS (
  SELECT txnmappedmobile
  FROM (
    SELECT txnmappedmobile, MAX(modifiedtxndate) AS max_txn
    FROM sku_report_loyalty 
    GROUP BY 1
  ) a
  WHERE max_txn < '2022-04-01'
)
SELECT 
  txnmappedmobile AS mobile,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills
FROM sku_report_loyalty 
JOIN base_1 USING(txnmappedmobile)
WHERE itemnetamount > 0 
  AND itemqty >= 1
  AND (
    (itemdiscountamount / itemmrp) * 100 >= 40
    OR MONTH(modifiedtxndate) = 6
    OR MONTH(modifiedtxndate) = 7
  )
  AND modifiedstorecode <> 'demo'
  GROUP BY 1;#252075
  

ALTER TABLE dummy.harish_re_active_befor22 ADD COLUMN segment VARCHAR(50);
  
UPDATE dummy.harish_re_active_befor22
SET segment ='Reactivation (R > 36 Months) and June July Purchasers or Discount seekers'
WHERE segment IS NULL;#252075
  
  
  
-- creating table for final data
CREATE TABLE dummy.Harish_BB_Campaign_finalSegments 
SELECT mobile,Segment,Sales,Bills FROM dummy.tier_mvc_bb_may_25_harish a 
JOIN member_report b USING(mobile)
WHERE enrolledstorecode <> 'demo' AND segment IS NOT NULL
UNION 
SELECT mobile,Segment,Sales,Bills  FROM dummy.harish_apr25_active_new_onetimer a 
JOIN member_report b USING(mobile)
WHERE enrolledstorecode <> 'demo'
UNION 
SELECT mobile,Segment,Sales,Bills FROM dummy.harish_max_sales_apr25 a 
JOIN member_report b USING(mobile)
WHERE enrolledstorecode <> 'demo' AND mobile NOT IN(SELECT DISTINCT mobile FROM dummy.harish_apr25_active_new_onetimer)
UNION 
SELECT txnmappedmobile AS mobile,Segment,Sales,Bills FROM dummy.BB_May22_Apr23_transactors_pv_re a 
JOIN member_report b ON a.txnmappedmobile=b.mobile
WHERE enrolledstorecode <> 'demo' AND segment IS NOT NULL
UNION 
SELECT mobile,Segment,Sales,Bills FROM dummy.harish_re_active_apr23 a 
JOIN member_report b USING(mobile)
WHERE enrolledstorecode <> 'demo'
UNION 
SELECT mobile,Segment,Sales,Bills FROM dummy.harish_re_active_befor22 a 
JOIN member_report b USING(mobile)
WHERE enrolledstorecode <> 'demo';
  

  #################################### customer who never transacte after given time period end current year ###########################################

  
  
  
  
  
  
  
  
  
  
  
###################################MVC customers start previews year#################################################

-- mvc
SELECT * FROM dummy.tier_mvc_bb_may_25_harish_pv;
CREATE TABLE dummy.tier_mvc_bb_may_25_harish_pv
SELECT mobile,tier FROM member_report WHERE tier='mvc';#144368

ALTER TABLE dummy.tier_mvc_bb_may_25_harish_pv ADD INDEX mobile(mobile),
ADD COLUMN bills VARCHAR(200),ADD COLUMN sales FLOAT,ADD COLUMN MAX_ATV FLOAT


UPDATE dummy.tier_mvc_bb_may_25_harish_pv a 
JOIN(
SELECT Txnmappedmobile AS Mobile,
COUNT(DISTINCT uniquebillno)bills,
SUM(itemnetamount)Sales,
MAX(itemnetamount)MAX_ATV
FROM sku_report_loyalty 
WHERE modifiedtxndate 
BETWEEN '2023-05-01' AND'2024-04-30'
AND itemnetamount>0 AND modifiedstorecode <> 'demo'
GROUP BY 1)b
USING(mobile)
SET a.bills=b.bills,
a.sales=b.sales,
a.MAX_ATV=b.MAX_ATV;#86219

UPDATE dummy.tier_mvc_bb_may_25_harish_pv 
SET MAX_ATV='0' 
WHERE MAX_ATV IS NULL; #58149

ALTER TABLE dummy.tier_mvc_bb_may_25_harish_pv
ADD COLUMN recency VARCHAR(30),
ADD COLUMN segment VARCHAR(200),ADD COLUMN maxf VARCHAR(20),
ADD COLUMN minf VARCHAR(20);

WITH max_min_data_pv AS
(SELECT txnmappedmobile,
MAX(frequencycount)maxf,
MIN(frequencycount)minf
FROM sku_report_loyalty a 
JOIN dummy.tier_mvc_bb_may_25 b
ON a.txnmappedmobile=b.mobile WHERE modifiedstorecode <> 'demo' GROUP BY 1)
UPDATE dummy.tier_mvc_bb_may_25_harish_pv a 
JOIN max_min_data_pv b 
ON a.mobile=b.txnmappedmobile 
SET a.maxf=b.maxf,a.minf=b.minf; #142260

UPDATE dummy.tier_mvc_bb_may_25_harish_pv 
SET segment='MVC Customers whose Max of Bill Value is 0-6K'
WHERE MAX_ATV >=0 
AND MAX_ATV<=6000;#94275

UPDATE dummy.tier_mvc_bb_may_25_harish_pv  
SET segment='MVC Customers whose Max of Bill Value is 6-10K'
WHERE MAX_ATV >6000 
AND MAX_ATV<=10000;#22723


UPDATE dummy.tier_mvc_bb_may_25_harish_pv a JOIN
(SELECT * FROM dummy.tier_mvc_bb_may_25_harish_pv
 WHERE maxf=1 AND segment IS NULL 
 AND max_atv>10000)
  b USING(mobile)
 SET a.segment='MVC One timers whose Max of Bill Value is greater than 10K';#10082



UPDATE dummy.tier_mvc_bb_may_25_harish_pv a JOIN
(SELECT * FROM dummy.tier_mvc_bb_may_25_harish_pv
 WHERE maxf>1 AND segment IS NULL
 AND max_atv>10000)
  b USING(mobile)
 SET a.segment='MVC Repeaters whose Max of Bill Value is greater than 10K';#17274
 

-- select * from dummy.tier_mvc_bb_may_25_harish where segment is null;

-- UPDATE dummy.tier_mvc_bb_may_25_harish SET segment='mvc_repeater' WHERE segment IS NULL;

SELECT segment,COUNT(DISTINCT mobile)customer,SUM(sales)sales,SUM(bills)bills FROM dummy.tier_mvc_bb_may_25_harish_pv 
-- WHERE segment IS NOT NULL
GROUP BY 1;

SELECT DISTINCT segment FROM dummy.tier_mvc_bb_may_25_harish;

###################################MVC customers end previews year #################################################




SELECT * FROM dummy.harish_apr24_active_new_one_repater_pv;

##########################################Tier active start previews year #################################################


CREATE TABLE dummy.harish_apr24_active_new_one_repater_pv
WITH sku AS
(SELECT txnmappedmobile mobile,SUM(itemnetamount)sales, COUNT(DISTINCT uniquebillno) bills, 
MAX(frequencycount)maxf,MIN(frequencycount)minf FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2024-04-01' AND '2024-04-30' AND modifiedstorecode <> 'demo'
GROUP BY 1),
member_report AS
(SELECT mobile,ModifiedEnrolledOn,tier FROM member_report WHERE ModifiedEnrolledOn >'2024-04-01' 
AND tier ='active' AND enrolledstorecode <> 'demo'),
new_repater AS
(SELECT a.*,b.tier
 FROM sku a  JOIN member_report b USING(mobile))
 SELECT mobile, SUM(sales), SUM(bills) FROM new_repater 
 WHERE minf=1 GROUP BY 1;#30154



SELECT COUNT(DISTINCT mobile)customer,SUM(`sum(sales)`)sales,SUM(`sum(bills)`)bills FROM dummy.harish_apr24_active_new_one_repater_pv

SELECT * FROM dummy.harish_bb_category_tag_apr24_pv

CREATE TABLE dummy.harish_bb_category_tag_apr24_pv
SELECT Txnmappedmobile AS Mobile,uniquebillno,SUM(itemnetamount)Sales,
DATEDIFF('2024-04-30',MAX(modifiedtxndate))Recency
FROM sku_report_loyalty a JOIN member_report b ON a.Txnmappedmobile=b.mobile
WHERE modifiedtxndate BETWEEN '2023-05-01' AND'2024-04-30'
AND itemnetamount>0 AND b.tier='active' AND modifiedstorecode <> 'demo'
GROUP BY 1,2; #750107



-- fav_Category
SELECT * FROM dummy.harish_max_sales_apr24_pv 

CREATE TABLE dummy.harish_max_sales_apr24_pv 
SELECT mobile,MAX(sales) FROM dummy.harish_bb_category_tag_apr24_pv GROUP BY 1;#552556

ALTER TABLE dummy.harish_max_sales_apr24_pv ADD COLUMN recency VARCHAR(20),ADD COLUMN fav_Formal VARCHAR(20),
ADD COLUMN fav_Casual VARCHAR(20), ADD COLUMN Mix_of_Category VARCHAR(20),
ADD COLUMN Total_Visits VARCHAR(20);

SELECT * FROM dummy.harish_bb_campning_apr25_pv;

CREATE TABLE dummy.harish_bb_campning_apr25_pv
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

ALTER TABLE  dummy.harish_bb_campning_apr25_pv ADD INDEX a(txnmappedmobile);
ALTER TABLE dummy.harish_max_sales_apr24_pv CHANGE Total_Visits FrequencyCount INT;



SELECT * FROM dummy.harish_max_sales_apr24_pv;

UPDATE dummy.harish_max_sales_apr24_pv a JOIN (
SELECT DISTINCT Mobile FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2023-05-01' AND'2024-04-30' AND storecode <> 'demo'
AND frequencycount=1) b USING(mobile)
SET a.FrequencyCount='1'; #388424

UPDATE dummy.harish_max_sales_apr24_pv a JOIN (
SELECT DISTINCT Mobile FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2023-05-01' AND'2024-04-30' AND storecode <> 'demo'
AND frequencycount>1) b USING(mobile)
SET a.FrequencyCount='2' WHERE a.FrequencyCount IS NULL;#164132



SELECT * FROM dummy.harish_max_sales_apr25

ALTER TABLE dummy.harish_max_sales_apr24_pv ADD COLUMN max_sales INT;

UPDATE dummy.harish_max_sales_apr24_pv SET max_sales ='1'
WHERE `max(sales)` BETWEEN  15000  AND 19500;#33606

UPDATE dummy.harish_max_sales_apr24_pv a JOIN  dummy.harish_bb_campning_apr25_pv b 
ON a.mobile=b.txnmappedmobile
SET fav_Formal='1'
WHERE b.Category_tag='Formal' AND b.`rank`=1 AND max_sales IS NULL;#260762

UPDATE dummy.harish_max_sales_apr24_pv a JOIN  dummy.harish_bb_campning_apr25_pv b 
ON a.mobile=b.txnmappedmobile SET fav_Casual='1'
 WHERE b.Category_tag='Casual' AND b.`rank`=1 AND max_sales IS NULL AND fav_Formal IS NULL ;#190000
 
 UPDATE dummy.harish_max_sales_apr24_pv SET Mix_of_Category='1'
 WHERE  max_sales IS NULL AND fav_Formal IS NULL  AND max_sales IS NULL AND fav_Casual IS NULL;#68188
 
 ALTER TABLE dummy.harish_max_sales_apr24_pv ADD COLUMN sales FLOAT,ADD COLUMN bills INT
 SELECT * FROM dummy.harish_max_sales_apr24_pv
 

UPDATE dummy.harish_max_sales_apr24_pv a JOIN
(SELECT txnmappedmobile,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2023-05-01' AND '2024-04-30'
AND itemnetamount>0 AND modifiedstorecode <> 'demo'
GROUP BY 1
)b ON a.mobile=b.txnmappedmobile
SET a.sales=b.sales,a.bills=b.bills;#552556

 
 
 
SELECT COUNT(mobile),SUM(sales)sales,SUM(bills)bills FROM dummy.harish_max_sales_apr24_pv  WHERE  max_sales='1';

SELECT FrequencyCount,COUNT(mobile),SUM(sales)sales,SUM(bills)bills FROM dummy.harish_max_sales_apr24_pv  WHERE  fav_Formal='1'
GROUP BY 1;

SELECT FrequencyCount,COUNT(mobile),SUM(sales)sales,SUM(bills)bills FROM dummy.harish_max_sales_apr24_pv WHERE fav_Casual='1'
GROUP BY 1;

SELECT FrequencyCount,COUNT(mobile),SUM(sales)sales,SUM(bills)bills FROM dummy.harish_max_sales_apr24_pv WHERE Mix_of_Category='1'
GROUP BY 1;


##########################################Tier active end previews year #################################################

SELECT * FROM dummy.BB_May22_Apr23_transactors_pv_pv;

################################# winback segment start previews year ######################################

INSERT INTO dummy.BB_May22_Apr23_transactors_pv
SELECT * FROM
(SELECT txnmappedmobile, SUM(itemnetamount) sales,COUNT(DISTINCT uniquebillno) bills, MAX(modifiedtxndate) max_txn_date
FROM sku_report_loyalty WHERE modifiedbillno NOT LIKE '%test%' AND modifiedbillno NOT LIKE '%roll%' 
AND modifiedstorecode NOT LIKE '%demo%' AND itemnetamount>0 
GROUP BY 1)a
WHERE max_txn_date BETWEEN '2022-05-01' AND '2023-04-30';#408477





ALTER  TABLE dummy.BB_May22_Apr23_transactors_pv ADD COLUMN tier VARCHAR(20),
ADD COLUMN fav_Formal VARCHAR(20),ADD COLUMN fav_Casual VARCHAR(20),
ADD COLUMN Mix_of_Category VARCHAR(20);

ALTER  TABLE dummy.BB_May22_Apr23_transactors_pv ADD INDEX mb(txnmappedmobile);

CREATE TABLE DUMMY.BB_FAV_Category_May22_Apr23_pv_1 
WITH sku_data AS(
SELECT txnmappedmobile,
ItemQty,
UniqueItemCode
FROM sku_report_loyalty
WHERE modifiedtxndate 
BETWEEN '2022-05-01' AND '2023-04-30' AND ItemNetAmount>0 AND modifiedstorecode <> 'demo'),
ITEM_MASTER AS 
(SELECT EAN,
Category_tag 
FROM dummy.blackberrys_EAN_CODE),
 SKU_ITEM_MASTER AS
(SELECT txnmappedmobile,ItemQty,UniqueItemCode,Category_tag FROM  sku_data A 
JOIN ITEM_MASTER B ON A.UniqueItemCode=B.EAN),
ItemQty AS
(SELECT  txnmappedmobile,Category_tag,SUM(ItemQty)ItemQty FROM SKU_ITEM_MASTER GROUP BY 1,2)
SELECT * ,ROW_NUMBER() OVER (PARTITION BY txnmappedmobile ORDER BY itemqty DESC) AS `rank` FROM ItemQty; -- 598247 row(s) affected

SELECT COUNT(DISTINCT txnmappedmobile) FROM DUMMY.BB_FAV_Category_May22_Apr23_pv_1; -- 643802

ALTER TABLE DUMMY.BB_FAV_Category_May22_Apr23_pv_1 ADD INDEX a(txnmappedmobile);

SELECT * FROM dummy.BB_May22_Apr23_transactors_pv;

UPDATE dummy.BB_May22_Apr23_transactors_pv a JOIN member_report b ON a.txnmappedmobile = b.mobile
SET a.tier = b.tier; -- 405904 row(s) affected

SELECT tier, COUNT(DISTINCT txnmappedmobile) FROM dummy.BB_May22_Apr23_transactors_pv GROUP BY 1;



UPDATE dummy.BB_May22_Apr23_transactors_pv  a JOIN DUMMY.BB_FAV_Category_May22_Apr23_pv_1 b 
USING(txnmappedmobile)
SET fav_Formal='1'
WHERE Category_tag='Formal' AND `rank`=1; -- 132693 row(s) affected

UPDATE dummy.BB_May22_Apr23_transactors_pv  a JOIN DUMMY.BB_FAV_Category_May22_Apr23_pv_1 b 
USING(txnmappedmobile)
SET fav_Casual='1'
WHERE Category_tag='Casual' AND fav_Formal IS NULL AND `rank`=1; -- 70138 row(s) affected

UPDATE dummy.BB_May22_Apr23_transactors_pv SET Mix_of_Category='1'
WHERE fav_Formal IS NULL AND fav_Casual IS NULL; -- 205646 row(s) affected

SELECT 132693 + 70138 + 205646 ; -- 495043 , 408477

SELECT COUNT(txnmappedmobile), SUM(sales), SUM(bills) FROM dummy.BB_May22_Apr23_transactors_pv WHERE fav_Formal='1' AND tier IS NOT NULL 
AND tier <> 'MVC'; 

SELECT * FROM dummy.BB_May22_Apr23_transactors_pv WHERE fav_Formal='1' AND tier IS NOT NULL 
AND tier <> 'MVC'; 

SELECT COUNT(txnmappedmobile), SUM(sales), SUM(bills) FROM dummy.BB_May22_Apr23_transactors_pv WHERE fav_Casual='1'AND tier IS NOT NULL 
AND tier <> 'MVC';

SELECT COUNT(txnmappedmobile), SUM(sales), SUM(bills)  FROM dummy.BB_May22_Apr23_transactors_pv WHERE Mix_of_Category='1'AND tier IS NOT NULL 
AND tier <> 'MVC';


################################# winback segment end previews year ######################################


#################################### customer who never transacte after given time period start previews year ###########################################

-- ask 1 re
CREATE TABLE dummy.harish_re_active_june22_pv_1
WITH cte AS (SELECT * FROM 
(SELECT mobile,MAX(txndate)max_txn FROM txn_report_accrual_redemption 
WHERE storecode <> 'demo'
GROUP BY 1)a
WHERE max_txn BETWEEN '2021-05-01' AND '2022-04-30'
),
sale AS (
SELECT mobile,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2021-05-01' AND '2022-04-30' AND storecode <> 'demo'
GROUP BY 1 
HAVING sales <20000)
SELECT a.mobile,SUM(sales)sales,SUM(bills)bills FROM cte a JOIN sale b USING(mobile)
GROUP BY 1;#254458


  SELECT COUNT(DISTINCT mobile)customer,SUM(sales)sales,SUM(bills) FROM dummy.harish_re_active_june22_pv_1;
  
  SELECT COUNT(DISTINCT txnmappedmobile) FROM sku_report_loyalty 
  WHERE modifiedtxndate BETWEEN '2024-06-01' AND '2024-06-30'
  AND txnmappedmobile IN (SELECT DISTINCT mobile FROM dummy.harish_re_active_june22_pv_1)

-- ask2
CREATE TABLE dummy.harish_re_active_befor_apr21_pv_
WITH base_1 AS (
  SELECT txnmappedmobile
  FROM (
    SELECT txnmappedmobile, MAX(modifiedtxndate) AS max_txn
    FROM sku_report_loyalty 
    WHERE modifiedstorecode <> 'demo'
    GROUP BY txnmappedmobile
  ) a
  WHERE max_txn <= '2021-04-30'
)
SELECT 
  txnmappedmobile AS mobile,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills 
FROM sku_report_loyalty 
JOIN base_1 USING(txnmappedmobile)
WHERE itemnetamount > 0 
  AND itemqty >= 1
  AND (
    (itemdiscountamount / itemmrp) * 100 >= 40
    OR MONTH(modifiedtxndate) = 6
    OR MONTH(modifiedtxndate) = 7
  )
  AND modifiedstorecode <> 'demo'
  GROUP BY 1
  HAVING sales<20000;#157666
  
  SELECT COUNT(DISTINCT mobile)customer,SUM(sales)sales,SUM(bills) FROM dummy.harish_re_active_befor_apr21_pv_;
  
    SELECT COUNT(DISTINCT txnmappedmobile) FROM sku_report_loyalty 
  WHERE modifiedtxndate BETWEEN '2024-06-01' AND '2024-06-30'
  AND txnmappedmobile IN (SELECT DISTINCT mobile FROM dummy.harish_re_active_befor_apr21_pv_)
  
  #################################### customer who never transacte after given time period end previews year###########################################


SELECT * FROM dummy.tier_mvc_bb_may_25_harish_pv;
SELECT * FROM dummy.harish_apr24_active_new_one_repater_pv;
SELECT * FROM dummy.harish_max_sales_apr24_pv;
SELECT * FROM dummy.BB_May22_Apr23_transactors_pv; 
SELECT * FROM dummy.harish_re_active_apr22_pv_1;
SELECT * FROM dummy.harish_re_active_befor21_pv_1;


SELECT COUNT(DISTINCT txnmappedmobile) FROM sku_report_loyalty 
WHERE txnmappedmobile IN (SELECT mobile FROM dummy.tier_mvc_bb_may_25_harish_pv 
WHERE segment IN (
'MVC Customers whose Max of Bill Value is 0-6K'
-- 'MVC Repeaters whose Max of Bill Value is greater than 10K',
-- 'MVC One timers whose Max of Bill Value is greater than 10K'
-- 'MVC Customers whose Max of Bill Value is 6-10K'
) GROUP BY 1)
AND modifiedtxndate BETWEEN '2024-06-01' AND '2024-06-30';

-- mvc customer count and there sale and bills 
SELECT DISTINCT  segment FROM dummy.tier_mvc_bb_may_25_harish_pv;

-- segment =MVC Customers whose Max of Bill Value is 0-6K

SELECT COUNT(DISTINCT txnmappedmobile)customer,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2024-06-01' AND '2024-06-30' 
AND txnmappedmobile IN (SELECT DISTINCT mobile FROM dummy.tier_mvc_bb_may_25_harish_pv WHERE segment='MVC Customers whose Max of Bill Value is 0-6K')
AND modifiedstorecode <> 'demo' AND itemnetamount>0;

-- segment =MVC Customers whose Max of Bill Value is 6-10K
SELECT COUNT(DISTINCT txnmappedmobile)customer,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2024-06-01' AND '2024-06-30' 
AND txnmappedmobile IN (SELECT DISTINCT mobile FROM dummy.tier_mvc_bb_may_25_harish_pv WHERE segment='MVC Customers whose Max of Bill Value is 6-10K')
AND modifiedstorecode <> 'demo' AND itemnetamount>0;


-- segment =MVC Repeaters whose Max of Bill Value is greater than 10K
SELECT COUNT(DISTINCT txnmappedmobile)customer,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2024-06-01' AND '2024-06-30' 
AND txnmappedmobile IN (SELECT DISTINCT mobile FROM dummy.tier_mvc_bb_may_25_harish_pv WHERE segment='MVC Repeaters whose Max of Bill Value is greater than 10K')
AND modifiedstorecode <> 'demo' AND itemnetamount>0;


-- segment =MVC Repeaters whose Max of Bill Value is greater than 10K
SELECT COUNT(DISTINCT txnmappedmobile)customer,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2024-06-01' AND '2024-06-30' 
AND txnmappedmobile IN (SELECT DISTINCT mobile FROM dummy.tier_mvc_bb_may_25_harish_pv WHERE segment='MVC One timers whose Max of Bill Value is greater than 10K')
AND modifiedstorecode <> 'demo' AND itemnetamount>0;

-- New One timer (minf = 1 and maxf = 1)
SELECT COUNT(DISTINCT txnmappedmobile)customer,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2024-06-01' AND '2024-06-30' AND modifiedstorecode <> 'demo' AND itemnetamount>0
AND txnmappedmobile IN (SELECT DISTINCT mobile FROM dummy.harish_apr24_active_new_one_repater_pv);



-- Existing (R b/w 1-12 Month) - High Value (15-19.5K)

SELECT COUNT(DISTINCT txnmappedmobile),SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills FROM  sku_report_loyalty 
WHERE txnmappedmobile IN (SELECT DISTINCT mobile FROM dummy.harish_max_sales_apr24_pv  WHERE  max_sales='1')
AND modifiedtxndate BETWEEN '2024-06-01' AND '2024-06-30' AND modifiedstorecode <> 'demo' AND itemnetamount>0;



SELECT COUNT(DISTINCT txnmappedmobile),SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills FROM  sku_report_loyalty 
WHERE txnmappedmobile IN (SELECT DISTINCT mobile FROM dummy.harish_max_sales_apr24_pv  WHERE  fav_Formal='1' AND frequencycount=1)
AND modifiedtxndate BETWEEN '2024-06-01' AND '2024-06-30' AND modifiedstorecode <> 'demo' AND itemnetamount>0;


SELECT COUNT(DISTINCT txnmappedmobile),SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills FROM  sku_report_loyalty 
WHERE txnmappedmobile IN (SELECT DISTINCT mobile FROM dummy.harish_max_sales_apr24_pv  WHERE  fav_Casual='1' AND frequencycount=1)
AND modifiedtxndate BETWEEN '2024-06-01' AND '2024-06-30' AND modifiedstorecode <> 'demo' AND itemnetamount>0;


SELECT COUNT(DISTINCT txnmappedmobile),SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills FROM  sku_report_loyalty 
WHERE txnmappedmobile IN (SELECT DISTINCT mobile FROM dummy.harish_max_sales_apr24_pv  WHERE  Mix_of_Category='1' AND frequencycount=1)
AND modifiedtxndate BETWEEN '2024-06-01' AND '2024-06-30' AND modifiedstorecode <> 'demo' AND itemnetamount>0;



SELECT COUNT(DISTINCT txnmappedmobile),SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills FROM  sku_report_loyalty 
WHERE txnmappedmobile IN (SELECT DISTINCT mobile FROM dummy.harish_max_sales_apr24_pv  WHERE  fav_Formal='1' AND frequencycount=2)
AND modifiedtxndate BETWEEN '2024-06-01' AND '2024-06-30' AND modifiedstorecode <> 'demo' AND itemnetamount>0;


SELECT COUNT(DISTINCT txnmappedmobile),SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills FROM  sku_report_loyalty 
WHERE txnmappedmobile IN (SELECT DISTINCT mobile FROM dummy.harish_max_sales_apr24_pv  WHERE  fav_Casual='1' AND frequencycount=2)
AND modifiedtxndate BETWEEN '2024-06-01' AND '2024-06-30' AND modifiedstorecode <> 'demo' AND itemnetamount>0;


SELECT COUNT(DISTINCT txnmappedmobile),SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills FROM  sku_report_loyalty 
WHERE txnmappedmobile IN (SELECT DISTINCT mobile FROM dummy.harish_max_sales_apr24_pv  WHERE  Mix_of_Category='1' AND frequencycount=2)
AND modifiedtxndate BETWEEN '2024-06-01' AND '2024-06-30' AND modifiedstorecode <> 'demo' AND itemnetamount>0;

-- Existing (R b/w 13-24 Month) - Formal

SELECT COUNT(DISTINCT txnmappedmobile),SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills FROM  sku_report_loyalty 
WHERE
 txnmappedmobile IN (SELECT DISTINCT txnmappedmobile FROM dummy.BB_May22_Apr23_transactors_pv WHERE fav_Formal='1' 
AND tier IS NOT NULL 
AND tier NOT IN ('MVC')
) 
AND 
modifiedtxndate BETWEEN '2024-06-01' AND '2024-06-30' AND modifiedstorecode <> 'demo' AND itemnetamount>0; 



SELECT txnmappedmobile,MAX(modifiedtxndate) FROM sku_report_loyalty 
WHERE txnmappedmobile IN (SELECT DISTINCT txnmappedmobile FROM dummy.BB_May22_Apr23_transactors_pv)
GROUP BY 1;




SELECT txnmappedmobile,modifiedtxndate,COUNT(DISTINCT txnmappedmobile),SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills FROM  sku_report_loyalty 
WHERE txnmappedmobile IN (SELECT txnmappedmobile FROM dummy.BB_May22_Apr23_transactors_pv 
WHERE 
Mix_of_Category='1' AND 
tier IS NOT NULL 
AND tier ='active') AND modifiedtxndate >'2023-06-01'  AND modifiedstorecode <> 'demo' AND itemnetamount>0
GROUP BY 1; 






SELECT * FROM  sku_report_loyalty a
JOIN dummy.BB_May22_Apr23_transactors_pv b  USING(txnmappedmobile)
WHERE 
--  b.fav_Formal='1' 
-- AND tier IS NOT NULL 
-- AND 
b.tier <>'MVC'
AND a.modifiedtxndate > '2023-05-01'  
AND a.modifiedstorecode <> 'demo' AND a.itemnetamount>0; 

DESCRIBE dummy.BB_May22_Apr23_transactors_pv;



SELECT DISTINCT tier FROM dummy.BB_May22_Apr23_transactors_pv;

SELECT * FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2023-06-01' AND '2023-06-30' AND modifiedstorecode <> 'demo' AND itemnetamount>0
AND txnmappedmobile ='6005961088';

SELECT * FROM sku_report_loyalty 
WHERE txnmappedmobile ='6009140988'


SELECT COUNT(DISTINCT b.txnmappedmobile)customer,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills 
FROM sku_report_loyalty a JOIN dummy.BB_May22_Apr23_transactors_pv b USING(txnmappedmobile)
WHERE modifiedtxndate BETWEEN '2023-06-01' AND '2023-06-30' AND modifiedstorecode <> 'demo' AND itemnetamount>0 AND fav_Formal='1'
AND tier IS NOT NULL 
AND tier <> 'MVC';


SELECT * FROM sku_report_loyalty 
WHERE txnmappedmobile IN ()
AND modifiedtxndate >'2023-04-30' AND modifiedstorecode <> 'demo' AND itemnetamount>0 



-- Existing (R b/w 13-24 Month) - Casual

SELECT COUNT(DISTINCT txnmappedmobile),SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills FROM  sku_report_loyalty 
WHERE txnmappedmobile IN (SELECT DISTINCT txnmappedmobile FROM dummy.BB_May22_Apr23_transactors_pv WHERE fav_Casual='1' 
-- AND tier IS NOT NULL 
AND tier <> 'MVC')
AND modifiedtxndate BETWEEN '2023-06-01' AND '2023-06-30' AND modifiedstorecode <> 'demo' AND itemnetamount>0;

-- Existing (R b/w 13-24 Month) - Mix of Category
SELECT COUNT(DISTINCT txnmappedmobile),SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills FROM  sku_report_loyalty 
WHERE txnmappedmobile IN (SELECT DISTINCT txnmappedmobile FROM dummy.BB_May22_Apr23_transactors_pv WHERE Mix_of_Category='1' 
-- AND tier IS NOT NULL 
AND tier <> 'MVC')AND modifiedtxndate BETWEEN '2023-06-01' AND '2023-06-30' AND modifiedstorecode <> 'demo' AND itemnetamount>0;









-- not in use yet 
SELECT COUNT(DISTINCT txnmappedmobile),SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills FROM  sku_report_loyalty 
WHERE txnmappedmobile IN (SELECT DISTINCT mobile FROM dummy.harish_re_active_apr22_pv_1)
AND modifiedtxndate BETWEEN '2022-06-01' AND '2022-06-30' AND modifiedstorecode <> 'demo' AND itemnetamount>0;



SELECT COUNT(DISTINCT txnmappedmobile),SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills FROM  sku_report_loyalty 
WHERE txnmappedmobile IN (SELECT DISTINCT mobile FROM dummy.harish_re_active_befor21_pv_1)
AND modifiedtxndate BETWEEN '2022-06-01' AND '2022-06-30' AND modifiedstorecode <> 'demo' AND itemnetamount>0;




SELECT COUNT(DISTINCT mobile)customers,SUM(sales)sales,SUM(bills)bills FROM dummy.harish_re_active_apr22_pv_1;

SELECT * FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2022-06-01' AND '2022-06-30' AND modifiedstorecode <> 'demo' AND itemnetamount>0
AND txnmappedmobile IN (SELECT DISTINCT mobile FROM dummy.harish_re_active_apr22_pv_1);



SELECT * FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2022-06-01' AND '2022-06-30' AND modifiedstorecode <> 'demo' AND itemnetamount>0
AND txnmappedmobile ='6000158176'


SELECT DISTINCT mobile FROM dummy.harish_re_active_befor21_pv_1;

###

SELECT txnmappedmobile AS mobile,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills
FROM sku_report_loyalty 
WHERE itemnetamount > 0  AND 
  AND itemqty >= 1
  AND((itemdiscountamount / itemmrp) * 100 >= 40 OR MONTH(modifiedtxndate) IN(6,7))
  AND modifiedstorecode <> 'demo' AND 
  txnmappedmobile IN(SELECT txnmappedmobile FROM (
    SELECT txnmappedmobile, MAX(modifiedtxndate) AS max_txn
    FROM sku_report_loyalty 
    WHERE modifiedstorecode <> 'demo'
    GROUP BY txnmappedmobile HAVING max_txn<='2021-04-30')a)
  GROUP BY 1;#162454

#######

WITH cte AS (SELECT txnmappedmobile AS mobile,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills
FROM sku_report_loyalty 
WHERE itemnetamount > 0 
  AND itemqty >= 1
  AND((itemdiscountamount / itemmrp) * 100 >= 40 OR MONTH(modifiedtxndate) IN(6,7))
  AND modifiedstorecode <> 'demo' AND 
  txnmappedmobile IN(SELECT txnmappedmobile FROM (
    SELECT txnmappedmobile, MAX(modifiedtxndate) AS max_txn
    FROM sku_report_loyalty 
    WHERE modifiedstorecode <> 'demo'
    GROUP BY txnmappedmobile HAVING max_txn<='2021-04-30')a)
  GROUP BY 1)
  SELECT txnmappedmobile,CONCAT(MONTHNAME(modifiedtxndate),YEAR(modifiedtxndate))PERIOD,SUM(itemnetamount),COUNT(DISTINCT uniquebillno) FROM 
  sku_report_loyalty
  WHERE txnmappedmobile IN(SELECT DISTINCT mobile FROM cte) AND 
  MONTH(modifiedtxndate) IN(6,7)
  GROUP BY 1,2;
  
  
SELECT * FROM sku_report_loyalty
WHERE txnmappedmobile='9922222287'