
(SELECT PERIOD,SUM(sales)AS 'Total Sales',SUM(bills)total_bills  
FROM(
(SELECT CASE 
WHEN modifiedtxndate BETWEEN '2025-04-01' AND '2025-06-30' THEN 'apr25-jun25(Q1-25)'
WHEN modifiedtxndate BETWEEN '2024-07-01' AND '2024-09-30' THEN 'jul24-sept24(Q2-25)'
WHEN modifiedtxndate BETWEEN '2025-07-01' AND '2025-09-30' THEN 'jul25-sept25(Q2-26)'
END PERIOD,
SUM(itemnetamount) AS sales,COUNT(DISTINCT uniquebillno)bills FROM sku_report_loyalty 
WHERE ((modifiedtxndate BETWEEN '2025-04-01' AND '2025-06-30') 
OR(modifiedtxndate BETWEEN '2024-07-01' AND '2024-09-30')
OR (modifiedtxndate BETWEEN '2025-07-01' AND '2025-09-30'))
AND modifiedbillno NOT LIKE '%test%' 
AND modifiedstorecode NOT LIKE '%demo%'AND modifiedbillno NOT LIKE '%roll%' AND modifiedstorecode NOT LIKE '%test%' 
AND modifiedstorecode <> 3011
GROUP BY 1)
UNION ALL 
(SELECT 
CASE 
WHEN modifiedtxndate BETWEEN '2025-04-01' AND '2025-06-30' THEN 'apr25-jun25(Q1-25)'
WHEN modifiedtxndate BETWEEN '2024-07-01' AND '2024-09-30' THEN 'jul24-sept24(Q2-25)'
WHEN modifiedtxndate BETWEEN '2025-07-01' AND '2025-09-30' THEN 'jul25-sept25(Q2-26)'
END PERIOD,
SUM(itemnetamount) AS sales,COUNT(DISTINCT uniquebillno)bills FROM sku_report_nonloyalty 
WHERE ((modifiedtxndate BETWEEN '2025-04-01' AND '2025-06-30') OR
(modifiedtxndate BETWEEN '2024-07-01' AND '2024-09-30')
OR 
(modifiedtxndate BETWEEN '2025-07-01' AND '2025-09-30'))
AND modifiedbillno NOT LIKE '%test%' 
AND modifiedstorecode <> 3011
AND modifiedstorecode NOT LIKE '%demo%'AND modifiedbillno NOT LIKE '%roll%' AND modifiedstorecode NOT LIKE '%test%' 
GROUP BY 1))b GROUP BY 1);


#non_loyalty_sales
SELECT SUM(itemnetamount) non_loyalty,COUNT(DISTINCT uniquebillno)bills FROM sku_report_nonloyalty 
WHERE modifiedTxnDate BETWEEN  '2025-07-01' AND '2025-09-30' AND modifiedbillno NOT LIKE '%test%' 
AND storecode NOT LIKE '%demo%'AND modifiedbillno NOT LIKE '%roll%' AND storecode NOT LIKE '%test%'
AND modifiedstorecode <>'ecom';

#loyalty_sales
SELECT SUM(itemnetamount) loyalty_sales,COUNT(DISTINCT uniquebillno)bills FROM  sku_report_loyalty
WHERE modifiedTxnDate BETWEEN   '2024-07-01' AND '2024-09-30' AND modifiedbillno NOT LIKE '%test%' 
AND storecode NOT LIKE '%demo%'AND modifiedbillno NOT LIKE '%roll%' AND storecode NOT LIKE '%test%'
AND modifiedstorecode =3011;


SELECT * FROM sku_report_loyalty
WHERE modifiedstorecode ='3011';

-- #Total_Transactors
--  SELECT CASE 
-- WHEN txndate BETWEEN '2025-04-01' AND '2025-06-30' THEN 'apr25-jun25(Q1-25)'
-- WHEN txndate BETWEEN '2024-07-01' AND '2024-09-30' THEN 'jul24-sept24(Q2-25)'
-- WHEN txndate BETWEEN '2025-07-01' AND '2025-09-30' THEN 'jul25-sept25(Q2-26)'
-- END PERIOD,COUNT(DISTINCT clientid)total_transactor FROM SKU_REPORT_LOYALTY 
-- WHERE ((modifiedtxndate BETWEEN '2025-04-01' AND '2025-06-30') OR
-- (modifiedtxndate BETWEEN '2024-07-01' AND '2024-09-30')
-- OR 
-- (modifiedtxndate BETWEEN '2025-07-01' AND '2025-09-30'))
--  AND modifiedstorecode NOT LIKE '%demo%'AND modifiedbillno NOT LIKE '%roll%' 
--  AND modifiedstorecode <>'ecom'
--  AND modifiedstorecode NOT LIKE '%test%'
--  group by 1;
-- --  Qc
--  SELECT COUNT(DISTINCT clientid) FROM SKU_REPORT_LOYALTY WHERE MODIFIEDTXNDATE BETWEEN '2025-04-01' AND '2025-06-30'
--  AND storecode NOT LIKE '%demo%'AND modifiedbillno NOT LIKE '%roll%' AND storecode NOT LIKE '%test%';
--  
 
  #Enrolments
SELECT CASE 
WHEN modifiedenrolledon BETWEEN '2025-04-01' AND '2025-06-30' THEN 'apr25-jun25(Q1-25)'
WHEN modifiedenrolledon BETWEEN '2024-07-01' AND '2024-09-30' THEN 'jul24-sept24(Q2-25)'
WHEN modifiedenrolledon BETWEEN '2025-07-01' AND '2025-09-30' THEN 'jul25-sept25(Q2-26)'
END PERIOD, 
COUNT(DISTINCT clientid) Enrolments FROM member_report 
WHERE  ((modifiedenrolledon BETWEEN '2025-04-01' AND '2025-06-30') OR
(modifiedenrolledon BETWEEN '2024-07-01' AND '2024-09-30')
OR 
(modifiedenrolledon BETWEEN '2025-07-01' AND '2025-09-30'))
AND enrolledstorecode<>'demo' AND enrolledstorecode <> 3011
GROUP BY 1;

-- QC
SELECT  COUNT(DISTINCT clientid) Enrolments FROM member_report 
WHERE  modifiedenrolledon BETWEEN '2025-04-01' AND '2025-06-30'
AND enrolledstorecode<>'demo';


#Total Quantity
SELECT CASE 
WHEN modifiedtxndate BETWEEN '2025-04-01' AND '2025-06-30' THEN 'apr25-jun25(Q1-25)'
WHEN modifiedtxndate BETWEEN '2024-07-01' AND '2024-09-30' THEN 'jul24-sept24(Q2-25)'
WHEN modifiedtxndate BETWEEN '2025-07-01' AND '2025-09-30' THEN 'jul25-sept25(Q2-26)'
END PERIOD,SUM(itemqty)total_loyalty_qty
FROM sku_report_loyalty 
WHERE ((modifiedtxndate BETWEEN '2025-04-01' AND '2025-06-30') 
OR(modifiedtxndate BETWEEN '2024-07-01' AND '2024-09-30')
OR (modifiedtxndate BETWEEN '2025-07-01' AND '2025-09-30'))
AND modifiedbillno NOT LIKE '%test%' 
AND modifiedstorecode NOT LIKE '%demo%'
AND modifiedbillno NOT LIKE '%roll%' 
AND modifiedstorecode NOT LIKE '%test%' 
AND modifiedstorecode <> 'ecom'
GROUP BY 1;

#Total Quantity
SELECT SUM(itemqty) FROM sku_report_loyalty 
WHERE modifiedTxnDate BETWEEN '2025-04-01' AND '2025-06-30'
AND storecode NOT LIKE '%demo%'AND modifiedbillno NOT LIKE '%roll%' AND storecode NOT LIKE '%test%';



#atv,amv,asp,upt
SELECT CASE 
WHEN modifiedtxndate BETWEEN '2025-04-01' AND '2025-06-30' THEN 'apr25-jun25(Q1-25)'
WHEN modifiedtxndate BETWEEN '2024-07-01' AND '2024-09-30' THEN 'jul24-sept24(Q2-25)'
WHEN modifiedtxndate BETWEEN '2025-07-01' AND '2025-09-30' THEN 'jul25-sept25(Q2-26)'
END PERIOD,
SUM(itemnetamount)/COUNT(DISTINCT uniquebillno) AS atv,
SUM(itemnetamount)/COUNT(DISTINCT clientid)amv,
SUM(itemnetamount)/(SUM(itemqty))asp,
SUM(itemqty)/COUNT(DISTINCT uniquebillno)AS upt
FROM sku_report_loyalty 
WHERE ((modifiedtxndate BETWEEN '2025-04-01' AND '2025-06-30') 
OR(modifiedtxndate BETWEEN '2024-07-01' AND '2024-09-30')
OR (modifiedtxndate BETWEEN '2025-07-01' AND '2025-09-30'))
AND storecode NOT LIKE '%demo%'AND modifiedbillno NOT LIKE '%roll%' 
AND storecode NOT LIKE '%test%' AND itemnetamount>0
GROUP BY 1;



#avg_visits,avg_Latency
SELECT PERIOD,
COUNT(DISTINCT clientid)total_transactor,
SUM(qty)total_qty_loyalty,
AVG(visits) AS avg_visits,
AVG(latency) AS Latency ,
COUNT(DISTINCT CASE WHEN minf=1 AND maxf=1 THEN clientid END)'onetimer customer',
SUM(CASE WHEN minf=1 AND maxf=1 THEN sales END)'onetimer sales',
SUM(CASE WHEN minf=1 AND maxf=1 THEN bills END)'onetimer bills',
COUNT(DISTINCT CASE WHEN maxf>1 THEN clientid END)'Repeater customer',
SUM(CASE WHEN maxf>1 THEN sales END)'Repeater sales',
SUM(CASE WHEN maxf>1 THEN bills END)'Repeater bills',
SUM(sales)/SUM(bills) AS atv,
SUM(sales)/COUNT(DISTINCT clientid)amv,
SUM(sales)/SUM(qty)asp,
SUM(qty)/SUM(bills)AS upt
FROM (
SELECT clientid,CASE 
WHEN modifiedtxndate BETWEEN '2025-04-01' AND '2025-06-30' THEN 'apr25-jun25(Q1-25)'
WHEN modifiedtxndate BETWEEN '2024-07-01' AND '2024-09-30' THEN 'jul24-sept24(Q2-25)'
WHEN modifiedtxndate BETWEEN '2025-07-01' AND '2025-09-30' THEN 'jul25-sept25(Q2-26)'
END PERIOD,
COUNT(DISTINCT modifiedtxndate) AS visits,SUM(itemqty)qty,
ROUND(DATEDIFF(MAX(modifiedtxndate),MIN(modifiedtxndate))/NULLIF((COUNT(DISTINCT modifiedtxndate)-1),0)) AS Latency,
MIN(frequencycount)minf,MAX(frequencycount)maxf,SUM(itemnetamount)sales,
COUNT(DISTINCT uniquebillno)bills
FROM sku_report_loyalty 
WHERE ((modifiedtxndate BETWEEN '2025-04-01' AND '2025-06-30') 
OR(modifiedtxndate BETWEEN '2024-07-01' AND '2024-09-30')
OR (modifiedtxndate BETWEEN '2025-07-01' AND '2025-09-30'))
AND modifiedstorecode NOT LIKE '%demo%'  
AND billno NOT LIKE '%test%'  
AND billno NOT LIKE '%roll%'
AND modifiedstorecode<>3011
GROUP BY 1,2)a
GROUP BY 1;


-- point data 
SELECT CASE 
WHEN txndate BETWEEN '2025-04-01' AND '2025-06-30' THEN 'apr25-jun25(Q1-25)'
WHEN txndate BETWEEN '2024-07-01' AND '2024-09-30' THEN 'jul24-sept24(Q2-25)'
WHEN txndate BETWEEN '2025-07-01' AND '2025-09-30' THEN 'jul25-sept25(Q2-26)'
END PERIOD,
SUM(pointscollected)point_issued,SUM(pointsspent)points_redeemed FROM txn_report_accrual_redemption 
WHERE ((txndate BETWEEN '2025-04-01' AND '2025-06-30') 
OR(txndate BETWEEN '2024-07-01' AND '2024-09-30')
OR (txndate BETWEEN '2025-07-01' AND '2025-09-30'))
AND storecode NOT LIKE '%demo%'  
AND billno NOT LIKE '%test%'  
AND billno NOT LIKE '%roll%'
AND storecode <> 3011
GROUP BY 1;



SELECT SUM(pointscollected)point_issued,SUM(pointsspent)points_redeemed FROM txn_report_accrual_redemption 
WHERE 
-- txndate BETWEEN '2025-04-01' AND '2025-06-30'

-- txndate BETWEEN '2024-07-01' AND '2024-09-30'
txndate BETWEEN '2025-07-01' AND '2025-09-30'
AND storecode NOT LIKE '%demo%'  
AND billno NOT LIKE '%test%'  
AND billno NOT LIKE '%roll%';



#mom
SELECT YEAR,MONTH,
COUNT(DISTINCT clientid) Transacting_customers,
COUNT(DISTINCT CASE WHEN maxf>1 THEN clientid END)Repeater,
COUNT(DISTINCT CASE WHEN maxf=1 THEN clientid END)Onetimers,
SUM(bills) Total_Bills,
SUM(CASE WHEN maxf>1 THEN bills END) AS Repeater_Bills,
SUM(CASE WHEN  maxf=1 THEN bills END)Onetimer_Bills,
SUM(sales) AS Total_Sales,
SUM(CASE WHEN maxf>1 THEN sales END) AS Repeater_sales,
SUM(CASE WHEN maxf=1 THEN sales END)Onetimer_Sales,
SUM(Quantity)Quantity,
SUM(sales)/SUM(bills) AS ATV,
SUM(sales)/COUNT(DISTINCT clientid)amv,
SUM(Quantity)/SUM(bills)AS upt,
SUM(sales)/SUM(Quantity)asp
FROM
(SELECT clientid,
MONTHNAME(modifiedtxndate) MONTH,YEAR(modifiedtxndate) YEAR,SUM(itemnetamount) AS sales,
COUNT(DISTINCT UniqueBillNo) AS bills, 
SUM(ItemQty)Quantity,
MAX(frequencycount) AS maxf, 
MIN(frequencycount) AS minf
FROM sku_report_loyalty
WHERE TxnDate BETWEEN '2024-04-01' AND '2024-09-30' 
AND storecode NOT LIKE '%demo%' 
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
GROUP BY 1,2,3)b
GROUP BY 1,2;

SELECT YEAR(ModifiedEnrolledOn)`year`,MONTHNAME(ModifiedEnrolledOn)`monthname`,COUNT(DISTINCT clientid)
FROM member_report
WHERE ModifiedEnrolledOn BETWEEN '2025-04-01' AND '2025-09-30'
AND enrolledstorecode<>'demo' 
GROUP BY 1,2;


SELECT 
CASE WHEN visits<=10  THEN visits ELSE 'More than 10' END AS visit_tag,
COUNT(DISTINCT clientid)customer,SUM(Amount) AS sales,SUM(bills) AS bills
FROM
(SELECT clientid,COUNT(DISTINCT uniquebillno) bills,SUM(itemnetAmount) AS Amount,
COUNT(DISTINCT txndate) AS visits
 FROM sku_report_loyalty
 WHERE storecode NOT LIKE '%Demo%' 
 AND modifiedtxndate BETWEEN '2025-07-01' AND '2025-09-30'
 AND billno NOT LIKE '%test%'
 AND billno NOT LIKE '%roll%'
 GROUP BY 1)a GROUP BY 1 ORDER BY visits;
 
 
 
 
 
 ####Tier_migration


CREATE TABLE dummy.tbs_tiermovement_jul24
SELECT mobile, MAX(DATE(TierStartDate))AS TierStartDate FROM tier_report_log 
WHERE TierStartDate<='2024-07-31' AND 1=0 GROUP BY 1; 

INSERT INTO dummy.tbs_tiermovement_jul24
SELECT mobile, MAX(DATE(TierStartDate))AS TierStartDate FROM tier_report_log 
WHERE TierStartDate<='2024-07-31' GROUP BY 1; #2553877

-- SELECT COUNT(a.mobile) FROM tier_Detail_report a JOIN dummy.tbs_tiermovement_jul24 b USING (mobile);
-- 
-- SELECT COUNT(mobile) FROM dummy.SKS_tiermovement_Apr24;

ALTER TABLE dummy.tbs_tiermovement_jul24 ADD COLUMN tier_dec24 VARCHAR(20),ADD INDEX a(mobile,TierStartDate);

ALTER TABLE dummy.tbs_tiermovement_jul24 
CHANGE COLUMN tier_dec24 tier_jul24 VARCHAR(50);
 
UPDATE dummy.tbs_tiermovement_jul24 a JOIN (SELECT mobile,DATE(TierStartDate) AS TierStartDate,currentTier 
FROM tier_report_log  
WHERE DATE(TierStartDate)<='2024-07-31')b ON a.mobile=b.mobile AND a.tierstartdate=b.tierstartdate 
SET a.tier_jul24=b.currenttier; #2553876


CREATE TABLE dummy.tbs_tiermovement_sept24
SELECT mobile, MAX(DATE(TierStartDate))AS TierStartDate FROM tier_report_log 
WHERE TierStartDate<='2024-09-30' AND 1=0 GROUP BY 1; 

INSERT INTO dummy.tbs_tiermovement_sept24
SELECT mobile, MAX(DATE(TierStartDate))AS TierStartDate FROM tier_report_log 
WHERE TierStartDate<='2024-09-30' GROUP BY 1; #2586587

ALTER TABLE dummy.tbs_tiermovement_sept24 ADD COLUMN tier_sept24 VARCHAR(20),ADD INDEX a(mobile,TierStartDate);



UPDATE dummy.tbs_tiermovement_sept24 a JOIN (SELECT mobile,DATE(TierStartDate) AS TierStartDate,currentTier 
FROM tier_report_log
WHERE DATE(TierStartDate)<='2024-09-30')b ON a.mobile=b.mobile AND a.tierstartdate=b.tierstartdate 
SET a.tier_sept24=b.currenttier;#2586586


SELECT * FROM dummy.tbs_tiermovement_sept24;

SELECT b.tier_jul24,a.tier_sept24,
COUNT(mobile) FROM dummy.tbs_tiermovement_sept24 a JOIN  dummy.tbs_tiermovement_jul24 b USING(mobile) 
GROUP BY 1,2;

SELECT a.tier_jul24,b.tier_sept24,COUNT(DISTINCT mobile)customer 
FROM dummy.tbs_tiermovement_jul24 a LEFT JOIN dummy.tbs_tiermovement_sept24 b USING(mobile)
GROUP BY 1,2

#
#july
CREATE TABLE dummy.tbs_tiermovement_jul25
SELECT mobile, MAX(DATE(TierStartDate))AS TierStartDate FROM tier_report_log 
WHERE TierStartDate<='2025-07-31' AND 1=0 GROUP BY 1; 

INSERT INTO dummy.tbs_tiermovement_jul25
SELECT mobile, MAX(DATE(TierStartDate))AS TierStartDate FROM tier_report_log 
WHERE TierStartDate<='2025-07-31'  GROUP BY 1; #2788664

 
ALTER TABLE dummy.tbs_tiermovement_jul25 ADD COLUMN tier_jul25 VARCHAR(20),ADD INDEX a(mobile,TierStartDate);


UPDATE dummy.tbs_tiermovement_jul25 a JOIN (SELECT mobile,DATE(TierStartDate) AS TierStartDate,currentTier 
FROM tier_report_log
WHERE DATE(TierStartDate)<='2025-07-31')b ON a.mobile=b.mobile AND a.tierstartdate=b.tierstartdate 
SET a.tier_jul25=b.currenttier;

SELECT * FROM dummy.tbs_tiermovement_jul25


##

CREATE TABLE dummy.tbs_tiermovement_sept25
SELECT mobile, MAX(DATE(TierStartDate))AS TierStartDate FROM tier_report_log 
WHERE TierStartDate<='2024-10-31' AND 1=0 GROUP BY 1; 

INSERT INTO dummy.tbs_tiermovement_sept25
SELECT mobile, MAX(DATE(TierStartDate))AS TierStartDate FROM tier_report_log 
WHERE TierStartDate<='2025-09-30'  GROUP BY 1; #2824187

 
ALTER TABLE dummy.tbs_tiermovement_sept25 ADD COLUMN tier_sept25 VARCHAR(20),ADD INDEX a(mobile,TierStartDate);


UPDATE dummy.tbs_tiermovement_sept25 a JOIN (SELECT mobile,DATE(TierStartDate) AS TierStartDate,currentTier 
FROM tier_report_log
WHERE DATE(TierStartDate)<='2025-09-30')b ON a.mobile=b.mobile AND a.tierstartdate=b.tierstartdate 
SET a.tier_sept25=b.currenttier;#2824186

-- SELECT a.tier_jul25,b.tier_dec24,
-- COUNT(mobile) FROM dummy.tbs_tiermovement_jul25
--  a JOIN dummy.tbs_tiermovement_jul24 b USING(mobile) 
-- GROUP BY 1,2;
-- 
-- SELECT a.tier_sept25,b.tier_sept24,
-- COUNT(mobile) FROM dummy.tbs_tiermovement_sept25
--  a JOIN dummy.tbs_tiermovement_jul25 b USING(mobile) 
-- GROUP BY 1,2;


SELECT a.tier_jul25,b.tier_sept25,COUNT(DISTINCT mobile)customer 
FROM dummy.tbs_tiermovement_jul25 a LEFT JOIN dummy.tbs_tiermovement_sept25 b USING(mobile)
GROUP BY 1,2;
-- tierwise data 
SELECT 
b.currenttier,COUNT(DISTINCT a.clientid) AS transactors,
SUM(a.itemnetamount)Sales,
COUNT(DISTINCT Uniquebillno)LoyaltyBills
FROM sku_report_loyalty a JOIN `tier_detail_report` b ON a.clientid=b.clientid
WHERE a.modifiedtxndate BETWEEN '2024-07-01' AND '2024-09-30'
AND a.storecode NOT LIKE '%demo%'
AND a.modifiedbillno NOT LIKE '%brn%'
AND a.modifiedbillno NOT LIKE '%roll%'
AND a.modifiedbillno NOT LIKE '%test%'
GROUP BY 1;

SELECT 
b.currenttier,
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN a.clientid END) AS Redeemers,
SUM(CASE WHEN a.pointsspent>0 THEN a.amount END) AS Redeemers_Sales,
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN uniquebillno END) AS Redeemers_bills,
SUM(a.pointscollected)LOYALTY_POINT_Issued,
SUM(a.pointsspent)LOYALTY_POINT_Redeemed
FROM txn_report_accrual_redemption a JOIN tier_detail_report b ON a.clientid=b.clientid
WHERE a.txndate BETWEEN '2024-07-01' AND '2024-09-30'
AND a.storecode NOT LIKE '%demo%'
AND a.modifiedbillno NOT LIKE '%brn%'
AND a.modifiedbillno NOT LIKE '%roll%'
AND a.modifiedbillno NOT LIKE '%test%'
GROUP BY 1;

SELECT tier,AVG(visits),SUM(itemqty)/SUM(bills) AS UPT FROM
( 
SELECT
a.clientid,tier,SUM(itemnetamount) sales,
COUNT(DISTINCT txndate) AS visits,
SUM(itemqty) AS itemqty,
COUNT(DISTINCT uniquebillno) AS bills
FROM `thebodyshop`.sku_report_loyalty a JOIN `tier_detail_report` b ON a.clientid=b.clientid
WHERE modifiedtxndate>='2024-07-01' AND modifiedtxndate<='2024-09-30'
AND a.modifiedstorecode NOT LIKE '%demo%'
AND a.modifiedbillno NOT LIKE '%brn%'
AND a.modifiedbillno NOT LIKE '%roll%'
AND a.modifiedbillno NOT LIKE '%test%'
GROUP BY 1,2
)a
GROUP BY 1;


SELECT b.currenttier,
SUM(pointscollected)Accruad_Issued
FROM txn_report_flat_accrual a JOIN `tier_detail_report` b ON a.mobile=b.mobile
WHERE txndate BETWEEN '2025-07-01' AND '2025-09-30'
AND storecode NOT LIKE '%demo%'
AND modifiedbillno NOT LIKE '%brn%'
AND modifiedbillno NOT LIKE '%roll%'
AND modifiedbillno NOT LIKE '%test%'
GROUP BY 1;
-- 
-- SELECT b.tier,
-- SUM(pointscollected)Accruad_Issued
-- FROM txn_report_flat_accrual a JOIN `member_report` b ON a.mobile=b.mobile
-- WHERE txndate BETWEEN '2024-07-01' AND '2024-09-30'
-- AND storecode NOT LIKE '%demo%'
-- AND modifiedbillno NOT LIKE '%brn%'
-- AND modifiedbillno NOT LIKE '%roll%'
-- AND modifiedbillno NOT LIKE '%test%'
-- GROUP BY 1;


SELECT MAX(txndate) FROM txn_report_flat_accrual;



SELECT * FROM txn_report_flat_accrual
WHERE txndate BETWEEN '2025-07-01' AND '2025-09-30';

