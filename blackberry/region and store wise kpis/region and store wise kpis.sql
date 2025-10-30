SELECT DISTINCT Group_Category FROM dummy.blackberrys_EAN_CODE;

SELECT * FROM dummy.blackberrys_EAN_CODE;
SELECT * FROM dummy.blackberrys_STORE_MASTER_10_04_25;


-- region and store wise data 
SELECT region,mall_highstreet,urban_nonurban,COUNT(DISTINCT mobile)customers,
SUM(sales)sales,SUM(bills)bills,SUM(qty)qty FROM(
SELECT 
	txnmappedmobile mobile,region,mall_highstreet,urban_nonurban,b.Group_Category,
	SUM(itemnetamount)sales,
	COUNT(DISTINCT uniquebillno)bills,MIN(frequencycount)minfc,MAX(frequencycount)maxfc,SUM(itemqty)qty 
FROM sku_report_loyalty a LEFT JOIN dummy.blackberrys_EAN_CODE b ON a.uniqueitemcode=b.EAN
LEFT JOIN dummy.blackberrys_STORE_MASTER_10_04_25 c ON  a.modifiedstorecode=c.store_code
WHERE modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31' AND `STATUS` = 'active'
AND modifiedstorecode <> 'demo' 
AND itemnetamount>0
GROUP BY 1)a
GROUP BY 1,2,3;

-- QC
SELECT region,COUNT(DISTINCT txnmappedmobile),
SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills,
SUM(itemqty)qty FROM dummy.blackberrys_STORE_MASTER_10_04_25 a
JOIN sku_report_loyalty b ON a.store_code=b.modifiedstorecode
WHERE a.region LIKE 'east' AND modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31' AND STATUS LIKE 'active'
AND mall_highstreet = 'High Street Store'
AND urban_nonurban = 'Urban Store'
GROUP BY 1 ;

-- fav category ovrall
SELECT 
	region,mall_highstreet,
	urban_nonurban,Group_Category,
	COUNT(DISTINCT mobile)customer,
	SUM(sales)sales,SUM(bills)bills 
FROM (
	SELECT * ,ROW_NUMBER() OVER (PARTITION BY mobile ORDER BY qty DESC) AS `ranks` FROM(
SELECT 
	txnmappedmobile mobile,region,mall_highstreet,urban_nonurban,b.Group_Category,
	SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills,
	SUM(itemqty)qty
FROM sku_report_loyalty a JOIN dummy.blackberrys_EAN_CODE b ON a.uniqueitemcode=b.EAN
JOIN dummy.blackberrys_STORE_MASTER_10_04_25 c ON  a.modifiedstorecode=c.store_code
WHERE modifiedtxndate <= '2025-03-31' AND `STATUS`='active'
AND modifiedstorecode <>'demo' 
AND itemnetamount>0
GROUP BY 1,5)b )a
WHERE ranks=1
GROUP BY 1,2,3,4;

SELECT * FROM dummy.blackberrys_EAN_CODE LIMIT 10;


-- new onetimer
SELECT 
	region,mall_highstreet,urban_nonurban,b.Group_Category AS Fav_Category,
	COUNT(DISTINCT CASE WHEN minfc=1 AND maxfc=1 THEN mobile END)new_onetimer_customer,
	SUM(CASE WHEN minfc=1 AND maxfc=1 THEN sales END)new_onetimer_sales,
	SUM(CASE WHEN minfc=1 AND maxfc=1 THEN bills END)new_onetimer_bills
FROM (
	
SELECT *, ROW_NUMBER() OVER (PARTITION BY mobile ORDER BY qty DESC)AS `ranks` FROM (
SELECT 
	txnmappedmobile mobile,region,mall_highstreet,urban_nonurban,b.Group_Category,
	SUM(itemnetamount)sales,
	COUNT(DISTINCT uniquebillno)bills,MIN(frequencycount)minfc,MAX(frequencycount)maxfc,SUM(itemqty)qty 
FROM sku_report_loyalty a LEFT JOIN dummy.blackberrys_EAN_CODE b ON a.uniqueitemcode=b.EAN
LEFT JOIN dummy.blackberrys_STORE_MASTER_10_04_25 c ON  a.modifiedstorecode=c.store_code
WHERE modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31' AND `STATUS` = 'active'
AND modifiedstorecode <> 'demo' 
AND itemnetamount>0
GROUP BY 1,5)a)b
WHERE ranks=1
GROUP BY 1,2,3,4;






-- new to repeat customers and there fav category
SELECT region,mall_highstreet,urban_nonurban,b.Group_Category AS Fav_Category,
	COUNT(DISTINCT CASE WHEN minfc=1 AND maxfc>1 THEN mobile END)new_repeat_customer,
	SUM(CASE WHEN minfc=1 AND maxfc>1 THEN sales END)new_repeater_sales,
	SUM(CASE WHEN minfc=1 AND maxfc>1 THEN bills END)new_repeater_bills FROM (

SELECT *, ROW_NUMBER() OVER (PARTITION BY mobile ORDER BY qty DESC)AS `ranks` FROM (
SELECT 
	txnmappedmobile mobile,region,mall_highstreet,urban_nonurban,b.Group_Category,
	SUM(itemnetamount)sales,
	COUNT(DISTINCT uniquebillno)bills,MIN(frequencycount)minfc,MAX(frequencycount)maxfc,SUM(itemqty)qty 
FROM sku_report_loyalty a LEFT JOIN dummy.blackberrys_EAN_CODE b ON a.uniqueitemcode=b.EAN
LEFT JOIN dummy.blackberrys_STORE_MASTER_10_04_25 c ON  a.modifiedstorecode=c.store_code
WHERE modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31' AND `STATUS` = 'active'
AND modifiedstorecode <> 'demo' 
-- AND modifiedbillno NOT LIKE '%test%' 
AND itemnetamount>0
GROUP BY 1,5)a)b
WHERE ranks=1
GROUP BY 1,2,3,4;



-- old repeat customers and there fav category
SELECT region,mall_highstreet,urban_nonurban,b.Group_Category AS Fav_Category,
	COUNT(DISTINCT CASE WHEN minfc>1 THEN mobile END)repeat_customer,
	SUM(CASE WHEN minfc>1 THEN sales END)repeat_sales,
	SUM(CASE WHEN minfc>1 THEN bills END)repeat_bills  FROM (

SELECT *, ROW_NUMBER() OVER (PARTITION BY mobile ORDER BY qty DESC)AS `ranks` FROM (
SELECT 
	txnmappedmobile mobile,region,mall_highstreet,urban_nonurban,b.Group_Category,
	SUM(itemnetamount)sales,
	COUNT(DISTINCT uniquebillno)bills,MIN(frequencycount)minfc,MAX(frequencycount)maxfc,SUM(itemqty)qty 
FROM sku_report_loyalty a LEFT JOIN dummy.blackberrys_EAN_CODE b ON a.uniqueitemcode=b.EAN
LEFT JOIN dummy.blackberrys_STORE_MASTER_10_04_25 c ON  a.modifiedstorecode=c.store_code
WHERE modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31' AND `STATUS` = 'active'
AND modifiedstorecode <> 'demo' 
-- AND modifiedbillno NOT LIKE '%test%' 
AND itemnetamount>0
GROUP BY 1,5)a)b
WHERE ranks=1
GROUP BY 1,2,3,4;


-- on 2nd visit 

SELECT region,mall_highstreet,urban_nonurban,b.Group_Category AS fav_category_2ndvisit,COUNT(DISTINCT mobile)customer,
SUM(sales)sales,SUM(bills)bills FROM (
SELECT *, ROW_NUMBER() OVER (PARTITION BY mobile ORDER BY qty DESC)AS `ranks` FROM (
SELECT 
	txnmappedmobile mobile,region,mall_highstreet,urban_nonurban,b.Group_Category,
	SUM(itemnetamount)sales,
	COUNT(DISTINCT uniquebillno)bills,SUM(itemqty)qty,COUNT(DISTINCT modifiedtxndate,txnmappedmobile)visit 
FROM 
sku_report_loyalty a LEFT JOIN dummy.blackberrys_EAN_CODE b ON a.uniqueitemcode=b.EAN
LEFT JOIN dummy.blackberrys_STORE_MASTER_10_04_25 c ON  a.modifiedstorecode=c.store_code
WHERE modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31' AND `STATUS`='active'
AND modifiedstorecode <> 'demo' 
-- AND modifiedbillno NOT LIKE '%test%' 
AND itemnetamount>0 
GROUP BY 1,5)a)b
WHERE ranks=1 AND visit=2
GROUP BY 1,2,3,4;







-- QC

SELECT COUNT(DISTINCT mobile),SUM(sales)sales,SUM(bills) FROM (
SELECT *, ROW_NUMBER() OVER (PARTITION BY mobile ORDER BY qty DESC)AS `ranks` FROM (
SELECT 
	txnmappedmobile mobile,region,mall_highstreet,urban_nonurban,b.Group_Category,
	SUM(itemnetamount)sales,
	COUNT(DISTINCT uniquebillno)bills,SUM(itemqty)qty,COUNT(DISTINCT modifiedtxndate,txnmappedmobile)visit 
FROM 
sku_report_loyalty a JOIN dummy.blackberrys_EAN_CODE b ON a.uniqueitemcode=b.EAN
JOIN dummy.blackberrys_STORE_MASTER_10_04_25 c ON  a.modifiedstorecode=c.store_code
WHERE modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31' AND STATUS LIKE 'active'
AND itemnetamount>0 
GROUP BY 1,2,3,4,5)a)b
WHERE ranks=1 AND visit=2 AND region ='east' AND mall_highstreet='high street store' AND urban_nonurban='non urban store'
AND Group_Category='ACCESSORIES'


-- region and store wise storecount
SELECT region,mall_highstreet,urban_nonurban,COUNT(DISTINCT store_code)storecount FROM(
SELECT 
	txnmappedmobile mobile,region,mall_highstreet,urban_nonurban,b.Group_Category,store_code,
	SUM(itemnetamount)sales,
	COUNT(DISTINCT uniquebillno)bills,MIN(frequencycount)minfc,MAX(frequencycount)maxfc,SUM(itemqty)qty 
FROM sku_report_loyalty a LEFT JOIN dummy.blackberrys_EAN_CODE b ON a.uniqueitemcode=b.EAN
LEFT JOIN dummy.blackberrys_STORE_MASTER_10_04_25 c ON  a.modifiedstorecode=c.store_code
WHERE modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31' AND `STATUS` = 'active'
AND modifiedstorecode <> 'demo' 
AND itemnetamount>0
GROUP BY 1)a
GROUP BY 1,2,3;

-- total customer count dusring this peirod 

SELECT COUNT(DISTINCT txnmappedmobile) mobile

FROM sku_report_loyalty a LEFT JOIN dummy.blackberrys_EAN_CODE b ON a.uniqueitemcode=b.EAN
JOIN dummy.blackberrys_STORE_MASTER_10_04_25 c ON  a.modifiedstorecode=c.store_code
WHERE modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31' AND STATUS LIKE 'active'
AND modifiedstorecode NOT LIKE 'demo' AND modifiedbillno NOT LIKE '%test%' 
AND itemnetamount>0;



SELECT group_category,COUNT(DISTINCT txnmappedmobile)customer,SUM(sales)sales,SUM(bills)bills FROM (
SELECT txnmappedmobile,group_category,COUNT(DISTINCT uniquebillno)bills,SUM(itemnetamount)sales,SUM(itemqty)qty 
FROM sku_report_loyalty a LEFT JOIN dummy.blackberrys_EAN_CODE b ON a.uniqueitemcode=b.EAN
WHERE modifiedstorecode <> 'demo' AND itemnetamount>0 AND modifiedtxndate BETWEEN '2024-01-01' AND '2025-03-31'
GROUP BY 1,2)a
WHERE bills>1
GROUP BY 1;

-- single category purchase
SELECT group_category,COUNT(DISTINCT txnmappedmobile)customers,SUM(sales)sales,SUM(bills)bills,SUM(qty)qty FROM (
SELECT  txnmappedmobile,group_category,GROUP_CONCAT(group_category)category,COUNT(DISTINCT group_category)single_cat,COUNT(DISTINCT uniquebillno) bills,SUM(itemnetamount)sales,SUM(itemqty)qty FROM sku_report_loyalty a LEFT JOIN dummy.blackberrys_EAN_CODE b ON a.uniqueitemcode=b.EAN
WHERE modifiedstorecode <> 'demo' AND itemnetamount>0 
AND modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31' GROUP BY 1)A 
WHERE bills>1 AND single_cat=1
GROUP BY 1;




-- multiple category code 
SELECT 
  CASE 
    WHEN category_count BETWEEN 1 AND 10 THEN category_count
    ELSE '10+'
  END AS category_range,
  COUNT(DISTINCT txnmappedmobile) AS customer,
  SUM(sales) AS sales,
  SUM(bills) AS bills
FROM (
  SELECT 
    txnmappedmobile,
    COUNT(DISTINCT group_category) AS category_count,
    COUNT(DISTINCT uniquebillno) AS bills,
    SUM(itemnetamount) AS sales
  FROM sku_report_loyalty a
  LEFT JOIN dummy.blackberrys_EAN_CODE b 
    ON a.uniqueitemcode = b.EAN
  WHERE 
    modifiedstorecode <> 'demo' 
    AND itemnetamount > 0 
    AND modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31'
  GROUP BY txnmappedmobile
) AS grouped
GROUP BY 1;




-- single category code 

SELECT 
    group_category,
    COUNT(DISTINCT txnmappedmobile) AS customers,
    SUM(sales) AS sales,
    SUM(bills) AS bills,
    SUM(qty) AS qty
FROM (
    SELECT  
        txnmappedmobile,
        MAX(group_category) AS group_category, -- since only 1 category exists
        COUNT(DISTINCT group_category) AS single_cat,
        COUNT(DISTINCT uniquebillno) AS bills,
        SUM(itemnetamount) AS sales,
        SUM(itemqty) AS qty
    FROM sku_report_loyalty a 
    LEFT JOIN dummy.blackberrys_EAN_CODE b 
        ON a.uniqueitemcode = b.EAN
    WHERE 
        a.modifiedstorecode <> 'demo'
        AND a.itemnetamount > 0
        AND a.modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31'
    GROUP BY txnmappedmobile
) A
WHERE single_cat = 1 AND bills>1
GROUP BY group_category;







-- dummy created by this query 
SELECT txnmappedmobile mobile,Group_Category,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills, SUM(itemqty)qty
FROM sku_report_loyalty a 
JOIN dummy.blackberrys_EAN_CODE b ON a.uniqueitemcode=b.EAN 
WHERE modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31'
GROUP BY 1,2;


-- fav category
WITH fav_cat_last_store AS(
SELECT * FROM (
SELECT *,ROW_NUMBER() OVER(PARTITION BY mobile ORDER BY qty DESC)AS ranks 
FROM (
	SELECT mobile,region,mall_highstreet,urban_nonurban,
	Group_Category,`last shopped store`,
	SUM(sales)sales,SUM(bills)bills,SUM(qty)qty 
FROM 
dummy.harish_blackberrys_fav_cat a 
JOIN dummy.blackberrys_STORE_MASTER_10_04_25 b ON a.`last shopped store`=b.store_code
GROUP BY 1,2,3,4,5)a)b
WHERE ranks=1)

SELECT region,mall_highstreet,urban_nonurban,Group_Category,COUNT(DISTINCT mobile)customer,
SUM(sales),SUM(bills)bills,SUM(qty)qty 
FROM fav_cat_last_store 
GROUP BY 1,2,3,4;




















-- another way to find the single and multiple categories 
SET SESSION group_concat_max_len = 1000000;
CREATE TABLE dummy.bb_new_data
SELECT 
    txnmappedmobile,
    group_category,
    GROUP_CONCAT(group_category) AS category,
    COUNT(DISTINCT group_category) AS single_cat,
    COUNT(DISTINCT uniquebillno) AS bills,
    SUM(itemnetamount) AS sales,
    SUM(itemqty) AS qty
FROM sku_report_loyalty a
LEFT JOIN dummy.blackberrys_EAN_CODE b 
    ON a.uniqueitemcode = b.EAN
WHERE modifiedstorecode <> 'demo' 
    AND itemnetamount > 0 
    AND modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31'
GROUP BY txnmappedmobile; -- Groups only by txnmappedmobile
 
SELECT * FROM dummy.bb_new_data;
SELECT category, COUNT(txnmappedmobile),SUM(sales),SUM(bills) FROM dummy.bb_new_data  WHERE qty =1 GROUP BY 1;
 
SELECT * FROM dummy.bb_new_data WHERE qty>10;
 
SELECT 
  CASE 
    WHEN qty BETWEEN 1 AND 10 THEN qty
    ELSE '10+'
  END AS category_range,
  COUNT(txnmappedmobile) AS customer,
  SUM(sales) AS sales,
  SUM(bills) AS bills FROM dummy.bb_new_data GROUP BY 1;

  SELECT txnmappedmobile,bills,sales,qty FROM dummy.bb_new_data  WHERE qty>10;