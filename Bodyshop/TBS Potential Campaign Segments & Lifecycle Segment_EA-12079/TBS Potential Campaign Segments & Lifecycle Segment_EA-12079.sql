SELECT DISTINCT storecustomerid FROM `tier_detail_report`;
SELECT * FROM tier_report_log;

-- clientid ,current tier sales ,current tier bill;
-- friend tier 
SELECT 'Fence Sitter-Friend ( Customers who have current tier as Friend & have spent between 3,000 & 5,000 in last 1 year)'AS 'tag'
,COUNT(DISTINCT clientid)customers,SUM(sales)sales,SUM(bills)bills FROM (
SELECT clientid,
SUM(currenttierspends)sales,
SUM(currenttierbills)bills FROM tier_detail_report
WHERE tierstartdate BETWEEN SUBDATE('2025-07-29',INTERVAL 11 MONTH) AND  '2025-07-29'
AND currenttier = 'friend' 
GROUP BY 1
)a
WHERE sales BETWEEN 3000 AND 5000;


-- club tier 
SELECT 'Fence Sitter- Club ( Customers who have current tier as Club & have spent between 12,000 & 15,000 in last 1 year)'AS 'tag'
,COUNT(DISTINCT clientid)customers,SUM(sales)sales,SUM(bills)bills FROM (
SELECT clientid,
SUM(currenttierspends)sales,
SUM(currenttierbills)bills FROM tier_detail_report
WHERE tierstartdate BETWEEN SUBDATE('2025-07-29',INTERVAL 11 MONTH) AND  '2025-07-29'
AND currenttier = 'club' 
GROUP BY 1
)a
WHERE sales BETWEEN 12000 AND 15000;


-- Enrolled in last 1 year but less than 2 txn(bills)

SELECT 'Enrolled in last 1 year but less than 2 txn(bills)' AS 'tag',
COUNT(DISTINCT clientid)customer,SUM(sales)sales,SUM(bills)bills FROM (
SELECT clientid,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills FROM txn_report_accrual_redemption
WHERE clientid IN (
SELECT DISTINCT clientid FROM member_report
WHERE modifiedenrolledon BETWEEN SUBDATE('2025-07-29', INTERVAL 1 YEAR) AND '2025-07-29' AND enrolledstorecode NOT IN ('demo','corporate')) 
AND amount>0 AND storecode NOT IN ('demo','corporate') AND billno NOT IN ('brn','roll','test')
GROUP BY 1)a
WHERE bills<=2;


-- Recently Lapsed customers (recency b/w 365 and 545 days)
-- Lapsed customers (recency b/w 545 and 1095 days)\

SELECT CASE WHEN recency BETWEEN 365 AND 545 THEN 'Recently Lapsed customers (recency b/w 365 and 545 days)'
WHEN recency BETWEEN 545 AND 1095 THEN 'Lapsed customers (recency b/w 545 and 1095 days)' END tag,
COUNT(DISTINCT clientid)customer,SUM(sales)sales,SUM(bills)bills FROM (
SELECT clientid,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills,DATEDIFF('2025-07-29',MAX(txndate))recency
FROM txn_report_accrual_redemption 
WHERE amount>0 AND storecode NOT IN ('demo','corporate') AND billno NOT IN ('brn','roll','test')
GROUP BY 1)a
WHERE recency BETWEEN 365 AND 545 OR recency BETWEEN 545 AND 1095
GROUP BY 1
ORDER BY recency;

-- Active Repeaters with Recency > 180 days & less than 365 days

SELECT COUNT(DISTINCT clientid)customer,SUM(sales)sales,SUM(bills)bills FROM (
SELECT clientid,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills,
DATEDIFF('2025-07-29',MAX(txndate))recency,frequencycount fc
FROM txn_report_accrual_redemption 
WHERE amount>0 AND storecode NOT IN ('demo','corporate') AND billno NOT IN ('brn','roll','test')
GROUP BY 1)a
WHERE recency BETWEEN 180 AND 365 AND fc>1;


-- Club Tier customers who have last 1 year spent less than 5000

SELECT COUNT(DISTINCT clientid)customer,SUM(sales)sales,SUM(bills)bills FROM (
SELECT clientid,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills 
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN SUBDATE('2025-07-29', INTERVAL 1 YEAR) AND '2025-07-29' 
AND amount>0 AND storecode NOT IN ('demo','corporate') AND billno NOT IN ('brn','roll','test')
AND clientid IN (
SELECT clientid FROM member_report 
WHERE tier = 'club' AND enrolledstorecode NOT IN ('demo','corporate'))
GROUP BY 1)a
WHERE sales<=5000;


-- Platinum tier customer who have last 1 year spend less than 15000


SELECT COUNT(DISTINCT clientid)customer,SUM(sales)sales,SUM(bills)bills FROM (
SELECT clientid,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills 
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN SUBDATE('2025-07-29', INTERVAL 1 YEAR) AND '2025-07-29' 
AND amount>0 AND storecode NOT IN ('demo','corporate') AND billno NOT IN ('brn','roll','test')
AND clientid IN (
SELECT clientid FROM member_report 
WHERE tier = 'Platinum' AND enrolledstorecode NOT IN ('demo','corporate'))
GROUP BY 1)a
WHERE sales<=15000;


-- Customers in Friend tier who have atv > 2500 or UPT>3.5 and have visits more than 1
SELECT COUNT(DISTINCT clientid)customer,SUM(sales)sales,SUM(bills)bills FROM (
SELECT clientid,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills,SUM(itemnetamount)/COUNT(DISTINCT uniquebillno)ATV,
SUM(itemqty)/COUNT(DISTINCT uniquebillno)upt,COUNT(DISTINCT modifiedtxndate,clientid)visit
FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN SUBDATE('2025-07-29', INTERVAL 1 YEAR) AND '2025-07-29' 
AND itemnetamount>0 AND modifiedstorecode NOT IN ('demo','corporate') AND billno NOT IN ('brn','roll','test')
AND clientid IN (SELECT clientid FROM member_report 
WHERE tier = 'friend' AND enrolledstorecode NOT IN ('demo','corporate'))
GROUP BY 1)a
WHERE ATV>=2500 OR upt>=3.5 AND visit>1;


SELECT COUNT(DISTINCT clientid)customer,SUM(sales)sales,SUM(bills)bills FROM (
SELECT a.clientid,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills,SUM(itemnetamount)/COUNT(DISTINCT uniquebillno)ATV,
SUM(itemqty)/COUNT(DISTINCT uniquebillno)upt,COUNT(DISTINCT modifiedtxndate,a.clientid)visit
FROM sku_report_loyalty a JOIN member_report b ON a.clientid=b.clientid AND b.tier='friend'
WHERE modifiedtxndate BETWEEN SUBDATE('2025-07-29', INTERVAL 1 YEAR) AND '2025-07-29' 
AND itemnetamount>0 AND modifiedstorecode NOT IN ('demo','corporate') AND billno NOT IN ('brn','roll','test')
-- AND clientid IN (SELECT clientid FROM member_report 
-- WHERE tier = 'friend' AND enrolledstorecode NOT IN ('demo','corporate'))
	GROUP BY 1)a
WHERE ATV>=2500 OR upt>=3.5 AND visit>1;


-- Customers in Club tier who have atv > 2750 or UPT>3.5 and have visits more than 1
SELECT COUNT(DISTINCT clientid)customer,SUM(sales)sales,SUM(bills)bills FROM (
SELECT clientid,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills,SUM(itemnetamount)/COUNT(DISTINCT uniquebillno)ATV,
SUM(itemqty)/COUNT(DISTINCT uniquebillno)upt,COUNT(DISTINCT modifiedtxndate,clientid)visit
FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN SUBDATE('2025-07-29', INTERVAL 1 YEAR) AND '2025-07-29' 
AND itemnetamount>0 AND modifiedstorecode NOT IN ('demo','corporate') AND billno NOT IN ('brn','roll','test')
AND clientid IN (SELECT clientid FROM member_report 
WHERE tier = 'club' AND enrolledstorecode NOT IN ('demo','corporate'))
GROUP BY 1)a
WHERE ATV>=2700 OR upt>=3.5 AND visit>1;

SELECT COUNT(DISTINCT clientid)customer,SUM(sales)sales,SUM(bills)bills FROM (
SELECT a.clientid,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills,SUM(itemnetamount)/COUNT(DISTINCT uniquebillno)ATV,
SUM(itemqty)/COUNT(DISTINCT uniquebillno)upt,COUNT(DISTINCT modifiedtxndate,a.clientid)visit
FROM sku_report_loyalty a JOIN member_report b ON a.clientid=b.clientid AND b.tier='club'
WHERE modifiedtxndate BETWEEN SUBDATE('2025-07-29', INTERVAL 1 YEAR) AND '2025-07-29' 
AND itemnetamount>0 AND modifiedstorecode NOT IN ('demo','corporate') AND billno NOT IN ('brn','roll','test')
-- AND clientid IN (SELECT clientid FROM member_report 
-- WHERE tier = 'club' AND enrolledstorecode NOT IN ('demo','corporate'))
GROUP BY 1)a
WHERE ATV>=2700 OR upt>=3.5 AND visit>1;





-- lifecycle



INSERT INTO dummy.BS_segment_jun25_1
SELECT clientid,MAX(frequencycount)FCOverall,
DATEDIFF('2024-06-30',MAX(modifiedtxndate))Recency
FROM `thebodyshop`.Sku_report_loyalty
WHERE txndate <='2025-06-30' 
AND modifiedstorecode NOT IN ('demo','corporate') AND billno NOT IN ('brn','roll','test')
AND itemnetamount>0 
GROUP BY 1; -- 2516032 row(s) affected

ALTER TABLE dummy.BS_segment_jun25_1 ADD INDEX cl(clientid);
ALTER TABLE dummy.BS_segment_jun25_1 ADD COLUMN fcYear INT;

UPDATE dummy.BS_segment_jun25_1 a JOIN(
SELECT clientid,COUNT(DISTINCT txndate)fcyear
FROM `thebodyshop`.Sku_report_loyalty
WHERE txndate BETWEEN '2025-06-30' - INTERVAL 1 YEAR AND '2025-06-30'
GROUP BY 1)b USING(clientid)
SET a.fcyear=b.fcyear;  -- 476481 row(s) affected


SELECT CASE
WHEN recency<=365 AND FCOverall=1 THEN 'New'
WHEN recency<= 120  AND FCyear<4 THEN 'Grow'
WHEN recency<= 120  AND FCyear>=4 THEN 'Stable'
WHEN recency BETWEEN 121 AND 365 AND FCOverall>=2 THEN 'Declining'
WHEN recency BETWEEN 366 AND 1095 THEN 'Lapsed'
WHEN recency>1095 THEN 'Dormant' END AS segment4, COUNT(clientid)
FROM dummy.BS_segment_jun25_1
GROUP BY 1;


SELECT * FROM sku_report_loyalty
WHERE billno LIKE '%brn%' AND billno LIKE '%roll%' AND billno LIKE '%test%'
