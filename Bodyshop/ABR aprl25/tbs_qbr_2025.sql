SET @startdate='2024-07-01',@enddate='2024-09-30';
SET @startdate='2023-10-01',  @enddate='2023-12-31';
SET @startdate='2024-10-01',@enddate='2024-12-31';

(SELECT SUM(sales_loyalty) AS 'Total Sales' 
FROM(
(SELECT SUM(itemnetamount) AS sales_loyalty FROM sku_report_loyalty 
WHERE modifiedTxnDate BETWEEN @startdate AND @enddate AND modifiedbillno NOT LIKE '%test%' 
AND storecode NOT LIKE '%demo%'AND modifiedbillno NOT LIKE '%roll%' AND storecode NOT LIKE '%test%' 
)
UNION ALL 
(SELECT SUM(itemnetamount) AS sales_loyalty FROM sku_report_nonloyalty 
WHERE modifiedTxnDate BETWEEN @startdate AND @enddate AND modifiedbillno NOT LIKE '%test%' 
AND storecode NOT LIKE '%demo%'AND modifiedbillno NOT LIKE '%roll%' AND storecode NOT LIKE '%test%' ))b);

#non_loyalty_sales
SELECT SUM(itemnetamount) non_loyalty FROM sku_report_nonloyalty 
WHERE modifiedTxnDate BETWEEN  @startdate AND @enddate AND modifiedbillno NOT LIKE '%test%' 
AND storecode NOT LIKE '%demo%'AND modifiedbillno NOT LIKE '%roll%' AND storecode NOT LIKE '%test%';

#loyalty_sales
SELECT SUM(itemnetamount) loyalty_sales FROM  sku_report_loyalty
WHERE modifiedTxnDate BETWEEN  @startdate AND @enddate AND modifiedbillno NOT LIKE '%test%' 
AND storecode NOT LIKE '%demo%'AND modifiedbillno NOT LIKE '%roll%' AND storecode NOT LIKE '%test%';



#Total_Transactors
 SELECT COUNT(DISTINCT clientid) FROM SKU_REPORT_LOYALTY WHERE MODIFIEDTXNDATE BETWEEN @startdate AND @enddate
 AND storecode NOT LIKE '%demo%'AND modifiedbillno NOT LIKE '%roll%' AND storecode NOT LIKE '%test%';
 
 
 #Enrolments
SELECT  COUNT(DISTINCT clientid) Enrolments FROM member_report WHERE  modifiedenrolledon BETWEEN @startdate AND @enddate
AND enrolledstorecode<>'demo';


#total_bills
(SELECT SUM(BILLS_loyalty) AS 'Total BILLS' 
FROM(
(SELECT COUNT(DISTINCT UniqueBillNo) AS BILLS_loyalty FROM sku_report_loyalty 
WHERE modifiedTxnDate BETWEEN @startdate AND @enddate AND modifiedbillno NOT LIKE '%test%' 
AND storecode NOT LIKE '%demo%'AND modifiedbillno NOT LIKE '%roll%' AND storecode NOT LIKE '%test%'
)
UNION ALL 
(SELECT COUNT(DISTINCT UniqueBillNo) AS BILLS_loyalty FROM sku_report_nonloyalty 
WHERE modifiedTxnDate BETWEEN @startdate AND @enddate AND modifiedbillno NOT LIKE '%test%' 
AND storecode NOT LIKE '%demo%'AND modifiedbillno NOT LIKE '%roll%' AND storecode NOT LIKE '%test%'))b);

#Total Quantity
SELECT SUM(itemqty) FROM sku_report_loyalty WHERE modifiedTxnDate BETWEEN @startdate AND @enddate
AND storecode NOT LIKE '%demo%'AND modifiedbillno NOT LIKE '%roll%' AND storecode NOT LIKE '%test%';

#atv
SELECT SUM(itemnetamount)/COUNT(DISTINCT uniquebillno) AS atv FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN @startdate AND @enddate 
AND storecode NOT LIKE '%demo%'AND modifiedbillno NOT LIKE '%roll%' AND storecode NOT LIKE '%test%' AND itemnetamount>0;

#amv
SELECT SUM(itemnetamount)/COUNT(DISTINCT clientid)amv FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN @startdate AND @enddate
AND storecode NOT LIKE '%demo%'AND modifiedbillno NOT LIKE '%roll%' AND storecode NOT LIKE '%test%' AND itemnetamount>0;

#asp
SELECT SUM(itemnetamount)/(SUM(itemqty))asp FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN @startdate AND @enddate
AND storecode NOT LIKE '%demo%'AND modifiedbillno NOT LIKE '%roll%' AND storecode NOT LIKE '%test%' AND itemnetamount>0;

#upt
SELECT SUM(itemqty)/COUNT(DISTINCT uniquebillno)AS upt FROM sku_report_loyalty
WHERE modifiedtxndate BETWEEN @startdate AND @enddate
AND storecode NOT LIKE '%demo%'AND modifiedbillno NOT LIKE '%roll%' AND storecode NOT LIKE '%test%' AND itemnetamount>0;



#avg_visits,avg_Latency
SELECT AVG(visits) AS avg_visits,
AVG(latency) AS Latency FROM (
SELECT clientid,COUNT(DISTINCT modifiedtxndate) AS visits,
ROUND(DATEDIFF(MAX(modifiedtxndate),
MIN(modifiedtxndate))/NULLIF((COUNT(DISTINCT modifiedtxndate)-1),0)) AS Latency
FROM sku_report_loyalty WHERE modifiedtxndate BETWEEN @startdate AND @enddate 
AND storecode NOT LIKE '%demo%'  AND billno NOT LIKE '%test%'  AND billno NOT LIKE '%roll%'
GROUP BY 1)a;


#Points Issued #Points Redeemed
SELECT SUM(pointscollected)Points_Issued,SUM(pointsspent)Points_Redemption FROM txn_report_accrual_redemption WHERE txndate BETWEEN @startdate AND @enddate AND storecode NOT LIKE '%demo%'  AND billno NOT LIKE '%test%'  AND billno NOT LIKE '%roll%';



#New/Onetimer Customers
#New/Onetimer Sales
#New/Onetimer Bills
####sku
SELECT COUNT(DISTINCT clientid)`New/Onetimer Customers`,SUM(sales)sales,SUM(bills)bills FROM (
SELECT clientid,SUM(itemnetamount) AS sales,
COUNT(DISTINCT UniqueBillNo) AS bills, 
MAX(frequencycount) AS maxf, MIN(frequencycount) AS minf
FROM sku_report_loyalty  
WHERE TxnDate BETWEEN @startdate AND @enddate 
AND storecode NOT LIKE '%demo%' 
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%' GROUP BY 1)A
WHERE maxf=1 AND minf=1;



-- Repeat Customers
-- Repeat Sales
-- Repeat Bills

SELECT COUNT(DISTINCT clientid)`Repeat Customers`,SUM(sales)`Repeat Sales`,SUM(bills)`Repeat Bills` FROM (
SELECT clientid,SUM(ITEMNETamount) AS sales,
COUNT(DISTINCT UniqueBillNo) AS bills, MAX(frequencycount) AS maxf
FROM SKU_REPORT_LOYALTY  
WHERE MODIFIEDTXNDATE BETWEEN @startdate AND @enddate 
AND storecode NOT LIKE '%demo%' 
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%' GROUP BY 1)A
WHERE maxf>1;#184418



#mom
SELECT ModifiedEnrolledOn FROM member_report LIMIT 10;
SELECT YEAR(ModifiedEnrolledOn)`year`,MONTHNAME(ModifiedEnrolledOn)`monthname`,COUNT(DISTINCT clientid)
FROM member_report
WHERE ModifiedEnrolledOn BETWEEN @startdate AND @enddate 
GROUP BY 1,2;


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
SUM(sales)/SUM(Quantity)asp
FROM
(SELECT clientid,
MONTHNAME(modifiedtxndate) MONTH,YEAR(modifiedtxndate) YEAR,SUM(itemnetamount) AS sales,
COUNT(DISTINCT UniqueBillNo) AS bills, 
SUM(ItemQty)Quantity,
MAX(frequencycount) AS maxf, 
MIN(frequencycount) AS minf
FROM sku_report_loyalty
WHERE TxnDate BETWEEN @startdate AND @enddate 
AND storecode NOT LIKE '%demo%' 
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
GROUP BY 1,2,3)b
GROUP BY 1,2;

#
SELECT YEAR,MONTH,
SUM(sales)/SUM(bills) AS ATV,
SUM(sales)/COUNT(DISTINCT clientid)amv,
SUM(sales)/SUM(Quantity)asp FROM 
(SELECT clientid,MONTHNAME(modifiedtxndate) MONTH,YEAR(modifiedtxndate) YEAR,SUM(itemnetamount) AS sales,
COUNT(DISTINCT UniqueBillNo) AS bills, 
SUM(ItemQty)Quantity,
MAX(frequencycount) AS maxf, 
MIN(frequencycount) AS minf
FROM sku_report_loyalty
WHERE TxnDate BETWEEN @startdate AND @enddate 
AND storecode NOT LIKE '%demo%' 
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
GROUP BY 1,2,3)b
GROUP BY 1,2;
 

SELECT CASE
WHEN visits=1 THEN '1'
WHEN visits=2  THEN '2'
WHEN visits=3  THEN '3'
WHEN visits=4  THEN '4'
WHEN visits=5  THEN '5'
WHEN visits=6  THEN '6'
WHEN visits=7  THEN '7'
WHEN visits=8  THEN '8'
WHEN visits=9  THEN '9'
WHEN visits=10  THEN '10'
WHEN visits>10 THEN 'More than 10' END AS visit_tag,
COUNT(txnmappedMobile)customer,SUM(Amount) AS sales,SUM(bills) AS bills
FROM
(SELECT txnmappedMobile,COUNT(DISTINCT uniquebillno) bills,SUM(itemnetAmount) AS Amount,
COUNT(DISTINCT txndate) AS visits
 FROM sku_report_loyalty
 WHERE storecode NOT LIKE '%Demo%' 
 AND modifiedtxndate BETWEEN '2024-07-01' AND '2024-12-31'
 @startdate AND @enddate
 AND billno NOT LIKE '%test%'
 AND billno NOT LIKE '%roll%'
 GROUP BY 1)a GROUP BY 1 ORDER BY visits;

####Tier_migration


CREATE TABLE dummy.tbs_tiermovement_dec24
SELECT mobile, MAX(DATE(TierStartDate))AS TierStartDate FROM tier_report_log 
WHERE TierStartDate<='2024-12-31' AND 1=0 GROUP BY 1; 

INSERT INTO dummy.tbs_tiermovement_dec24
SELECT mobile, MAX(DATE(TierStartDate))AS TierStartDate FROM tier_report_log 
WHERE TierStartDate<='2024-12-31' GROUP BY 1; #2645836

SELECT COUNT(a.mobile) FROM tier_Detail_report a JOIN dummy.tbs_tiermovement_dec24 b USING (mobile);

SELECT COUNT(mobile) FROM dummy.SKS_tiermovement_Apr24;

ALTER TABLE dummy.tbs_tiermovement_dec24 ADD COLUMN tier_dec24 VARCHAR(20),ADD INDEX a(mobile,TierStartDate);
 
UPDATE dummy.tbs_tiermovement_dec24 a JOIN (SELECT mobile,DATE(TierStartDate) AS TierStartDate,currentTier 
FROM tier_report_log  
WHERE DATE(TierStartDate)<='2024-12-31')b ON a.mobile=b.mobile AND a.tierstartdate=b.tierstartdate 
SET a.tier_dec24=b.currenttier; 


CREATE TABLE dummy.tbs_tiermovement_dec23
SELECT mobile, MAX(DATE(TierStartDate))AS TierStartDate FROM tier_report_log 
WHERE TierStartDate<='2023-12-31' AND 1=0 GROUP BY 1; 

INSERT INTO dummy.tbs_tiermovement_dec23
SELECT mobile, MAX(DATE(TierStartDate))AS TierStartDate FROM tier_report_log 
WHERE TierStartDate<='2023-12-31' GROUP BY 1; #2415760

ALTER TABLE dummy.tbs_tiermovement_dec23 ADD COLUMN tier_dec23 VARCHAR(20),ADD INDEX a(mobile,TierStartDate);



UPDATE dummy.tbs_tiermovement_dec23 a JOIN (SELECT mobile,DATE(TierStartDate) AS TierStartDate,currentTier 
FROM tier_report_log
WHERE DATE(TierStartDate)<='2023-12-31')b ON a.mobile=b.mobile AND a.tierstartdate=b.tierstartdate 
SET a.tier_dec23=b.currenttier;#2415759


#
#oct
CREATE TABLE dummy.tbs_tiermovement_oct24
SELECT mobile, MAX(DATE(TierStartDate))AS TierStartDate FROM tier_report_log 
WHERE TierStartDate<='2024-10-31' AND 1=0 GROUP BY 1; 

INSERT INTO dummy.tbs_tiermovement_oct24
SELECT mobile, MAX(DATE(TierStartDate))AS TierStartDate FROM tier_report_log 
WHERE TierStartDate<='2024-10-31'  GROUP BY 1; #2602258

 
ALTER TABLE dummy.tbs_tiermovement_oct24 ADD COLUMN tier_oct24 VARCHAR(20),ADD INDEX a(mobile,TierStartDate);


UPDATE dummy.tbs_tiermovement_oct24 a JOIN (SELECT mobile,DATE(TierStartDate) AS TierStartDate,currentTier 
FROM tier_report_log
WHERE DATE(TierStartDate)<='2024-10-31')b ON a.mobile=b.mobile AND a.tierstartdate=b.tierstartdate 
SET a.tier_oct24=b.currenttier;




##

CREATE TABLE dummy.tbs_tiermovement_oct23
SELECT mobile, MAX(DATE(TierStartDate))AS TierStartDate FROM tier_report_log 
WHERE TierStartDate<='2024-10-31' AND 1=0 GROUP BY 1; 

INSERT INTO dummy.tbs_tiermovement_oct23
SELECT mobile, MAX(DATE(TierStartDate))AS TierStartDate FROM tier_report_log 
WHERE TierStartDate<='2023-10-31'  GROUP BY 1; #2602258

 
ALTER TABLE dummy.tbs_tiermovement_oct23 ADD COLUMN tier_oct23 VARCHAR(20),ADD INDEX a(mobile,TierStartDate);


UPDATE dummy.tbs_tiermovement_oct23 a JOIN (SELECT mobile,DATE(TierStartDate) AS TierStartDate,currentTier 
FROM tier_report_log
WHERE DATE(TierStartDate)<='2023-10-31')b ON a.mobile=b.mobile AND a.tierstartdate=b.tierstartdate 
SET a.tier_oct23=b.currenttier;

SELECT a.tier_oct24,b.tier_dec24,
COUNT(mobile) FROM dummy.tbs_tiermovement_oct24
 a JOIN dummy.tbs_tiermovement_dec24 b USING(mobile) 
GROUP BY 1,2;

SELECT a.tier_oct23,b.tier_dec23,
COUNT(mobile) FROM dummy.tbs_tiermovement_oct23
 a JOIN dummy.tbs_tiermovement_dec23 b USING(mobile) 
GROUP BY 1,2;

#Tier wise data

SELECT 
b.currenttier,COUNT(DISTINCT a.clientid) AS transactors,
SUM(a.amount)Sales,
COUNT(DISTINCT Uniquebillno)LoyaltyBills,
FROM sku_report_loyalty a JOIN `tier_detail_report` b ON a.clientid=b.clientid
WHERE a.modifiedtxndate BETWEEN '2024-10-01' AND '2024-12-31'
AND a.storecode NOT LIKE '%demo%'
AND a.modifiedbillno NOT LIKE '%brn%'
AND a.modifiedbillno NOT LIKE '%roll%'
AND a.modifiedbillno NOT LIKE '%test%'
GROUP BY 1;

SELECT 
b.currenttier,
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN a.clientid END) AS Redeemers,
SUM(CASE WHEN a.pointsspent>0 THEN a.amount END) AS Redeemers_Sales,
SUM(a.pointscollected)LOYALTY_POINT_Issued,
SUM(a.pointsspent)LOYALTY_POINT_Redeemed
FROM txn_report_accrual_redemption a JOIN tier_detail_report ON a.clientid=b.clientid
WHERE a.txndate BETWEEN '2025-10-01' AND '2024-12-31'
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
WHERE modifiedtxndate>='2024-10-01' AND modifiedtxndate<='2024-12-31'
AND a.modifiedstorecode NOT LIKE '%demo%'
AND a.modifiedbillno NOT LIKE '%brn%'
AND a.modifiedbillno NOT LIKE '%roll%'
AND a.modifiedbillno NOT LIKE '%test%'
GROUP BY 1,2
)a
GROUP BY 1;



