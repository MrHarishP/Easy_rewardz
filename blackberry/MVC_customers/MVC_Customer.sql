-- mvc
SELECT * FROM dummy.tier_mvc_bb_may_25_harish
CREATE TABLE dummy.tier_mvc_bb_may_25_harish
SELECT mobile,tier FROM member_report WHERE tier='mvc';#143759

ALTER TABLE dummy.tier_mvc_bb_may_25_harish ADD INDEX mobile(mobile),
ADD COLUMN bills VARCHAR(200),ADD COLUMN sales FLOAT,ADD COLUMN MAX_ATV FLOAT


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


#################################################
