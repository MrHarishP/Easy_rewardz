
###################################MVC customers start previews year#################################################

-- mvc

-- 
-- CREATE TABLE dummy.tier_mvc_bb_may_24_harish_pv_r
-- SELECT mobile,tier FROM member_report WHERE tier='mvc';#144539

SELECT * FROM dummy.tier_mvc_bb_may_24_harish_pv_r


SELECT * FROM sku_report_loyalty
WHERE txnmappedmobile ='6000721551';

INSERT INTO dummy.tier_mvc_bb_may_24_harish_pv_r 
SELECT txnmappedmobile,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills,MAX(itemnetamount)max_atv,
MIN(frequencycount)minf,MAX(frequencycount)maxf
FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2023-05-01' AND '2024-04-30'
AND itemnetamount>0 AND modifiedstorecode <> 'demo' 
GROUP BY 1
HAVING sales>=20000; #93494


SELECT * FROM dummy.tier_mvc_bb_may_24_harish_pv_r;

UPDATE dummy.tier_mvc_bb_may_24_harish_pv_r 
SET MAX_ATV='0' 
WHERE MAX_ATV IS NULL; #58281



ALTER TABLE dummy.tier_mvc_bb_may_24_harish_pv_r ADD INDEX txnmappedmobile(txnmappedmobile),ADD COLUMN segment VARCHAR(200);


UPDATE dummy.tier_mvc_bb_may_24_harish_pv_r 
SET segment='MVC Customers whose Max of Bill Value is 0-6K'
WHERE MAX_ATV >=0 AND segment IS NULL
AND MAX_ATV<=6000; #28635






UPDATE dummy.tier_mvc_bb_may_24_harish_pv_r  
SET segment='MVC Customers whose Max of Bill Value is 6-10K'
WHERE MAX_ATV >6000 
AND MAX_ATV<=10000 AND segment IS NULL;#26648



UPDATE dummy.tier_mvc_bb_may_24_harish_pv_r a JOIN
(SELECT * FROM dummy.tier_mvc_bb_may_24_harish_pv_r
 WHERE minf=1 AND maxf=1 AND segment IS NULL 
 AND max_atv>10000)
  b USING(txnmappedmobile)
 SET a.segment='MVC One timers whose Max of Bill Value is greater than 10K'; #16356
 
 



UPDATE dummy.tier_mvc_bb_may_24_harish_pv_r a JOIN
(SELECT * FROM dummy.tier_mvc_bb_may_24_harish_pv_r
 WHERE minf>1 AND maxf>1 AND segment IS NULL
 AND max_atv>10000)
  b USING(txnmappedmobile)
 SET a.segment='MVC Repeaters whose Max of Bill Value is greater than 10K';#11072
 

-- select * from dummy.tier_mvc_bb_may_25_harish where segment is null;

-- UPDATE dummy.tier_mvc_bb_may_25_harish SET segment='mvc_repeater' WHERE segment IS NULL;

SELECT segment,COUNT(DISTINCT txnmappedmobile)customer,SUM(sales)sales,SUM(bills)bills FROM dummy.tier_mvc_bb_may_24_harish_pv_r 
WHERE segment IS NOT NULL
GROUP BY 1;

SELECT DISTINCT segment FROM dummy.tier_mvc_bb_may_25_harish;

-- segment =MVC Customers whose Max of Bill Value is 0-6K

SELECT COUNT(DISTINCT txnmappedmobile)customer,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2024-06-01' AND '2024-06-30' 
AND txnmappedmobile IN (SELECT DISTINCT txnmappedmobile FROM dummy.tier_mvc_bb_may_24_harish_pv_r 
WHERE segment='MVC Customers whose Max of Bill Value is 0-6K' AND segment IS NOT NULL)
AND modifiedstorecode <> 'demo' AND itemnetamount>0;

-- segment =MVC Customers whose Max of Bill Value is 6-10K
SELECT COUNT(DISTINCT txnmappedmobile)customer,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2024-06-01' AND '2024-06-30' 
AND txnmappedmobile IN (SELECT DISTINCT txnmappedmobile FROM dummy.tier_mvc_bb_may_24_harish_pv_r 
WHERE segment='MVC Customers whose Max of Bill Value is 6-10K' AND segment IS NOT NULL)
AND modifiedstorecode <> 'demo' AND itemnetamount>0;


-- segment =MVC Repeaters whose Max of Bill Value is greater than 10K
SELECT COUNT(DISTINCT txnmappedmobile)customer,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2024-06-01' AND '2024-06-30' 
AND txnmappedmobile IN 
(SELECT DISTINCT txnmappedmobile FROM dummy.tier_mvc_bb_may_24_harish_pv_r 
WHERE segment='MVC Repeaters whose Max of Bill Value is greater than 10K' AND segment IS NOT NULL)
AND modifiedstorecode <> 'demo' AND itemnetamount>0;


-- segment =MVC Repeaters whose Max of Bill Value is greater than 10K
SELECT COUNT(DISTINCT txnmappedmobile)customer,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2024-06-01' AND '2024-06-30' 
AND txnmappedmobile IN (SELECT DISTINCT txnmappedmobile FROM dummy.tier_mvc_bb_may_24_harish_pv_r 
WHERE segment='MVC One timers whose Max of Bill Value is greater than 10K' AND segment IS NOT NULL)
AND modifiedstorecode <> 'demo' AND itemnetamount>0;



SELECT COUNT(DISTINCT txnmappedmobile)customer FROM sku_report_loyalty a JOIN dummy.tier_mvc_bb_may_24_harish_pv_r b USING(txnmappedmobile)
WHERE modifiedtxndate BETWEEN '2024-06-01' AND '2024-06-30'  AND segment='MVC One timers whose Max of Bill Value is greater than 10K' AND segment IS NOT NULL

