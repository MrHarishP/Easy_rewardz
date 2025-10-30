-- Total base
SELECT COUNT(DISTINCT mobile)`Total base` FROM member_report
WHERE insertiondate<='2025-06-29' AND enrolledstorecode <> 'demo' AND enrolledstorecode <> 'corporate';#2762353

-- Total active base
SELECT COUNT(DISTINCT mobile)active_base FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN DATE_SUB('2025-06-29', INTERVAL 12 MONTH) AND '2025-06-29'
AND amount>0 AND storecode <> 'demo' AND storecode <> 'corporate'
AND insertiondate <='2025-06-29';#477164


-- platinum base and new repeater
WITH platinum_base AS (
SELECT  clientid,enrolledstorecode FROM member_report 
WHERE tier = 'platinum' AND enrolledstorecode <> 'demo' 
AND enrolledstorecode <> 'corporate'
 AND insertiondate<='2025-06-29'
 GROUP BY 1,2)#61719,61584
 
SELECT CASE WHEN enrolledstorecode=3011 THEN 'online' 
WHEN enrolledstorecode <> 3011 THEN 'offline' ELSE 'NULL' END `channel`,
CASE WHEN maxf=1 THEN 'new' 
WHEN maxf>1 THEN 'repeater' ELSE 'NULL' END tag,
COUNT(DISTINCT clientid)customer FROM (
 SELECT clientid,MAX(frequencycount)maxf,MIN(frequencycount)minf,a.enrolledstorecode FROM platinum_base a LEFT JOIN txn_report_accrual_redemption b USING(clientid)
 WHERE storecode <> 'demo' AND storecode <> 'corporate' AND amount>0
 GROUP BY 1)a
 GROUP BY 1,2;
 
 
 SELECT * FROM program_single_view
WHERE clientid='31884758' 
 SELECT * FROM txn_report_accrual_redemption 
 WHERE clientid ='1230960237';
 
 SELECT * FROM sku_report_loyalty 
 WHERE clientid IN ('1000175992',
'1000179649',
'1000193174',
'1230907745',
'1230853653',
'1230960237'
);
 
 
 
 -- club base and new repeater
WITH club_base AS (
SELECT clientid,enrolledstorecode FROM member_report 
WHERE tier = 'club' AND enrolledstorecode <> 'demo' 
AND enrolledstorecode <> 'corporate'
 AND insertiondate<='2025-06-29'GROUP BY 1,2)#162618
 
SELECT CASE WHEN enrolledstorecode=3011 THEN 'online' 
WHEN enrolledstorecode <> 3011 THEN 'offline' ELSE 'NULL' END `channel`,
CASE WHEN maxf=1 THEN 'new' 
WHEN maxf>1 THEN 'repeater' ELSE 'NULL' END tag,
COUNT(DISTINCT clientid)customer FROM (
 SELECT clientid,MAX(frequencycount)maxf,MIN(frequencycount)minf,a.enrolledstorecode FROM club_base a LEFT JOIN txn_report_accrual_redemption b USING(clientid)
 WHERE storecode <> 'demo' AND storecode <> 'corporate' AND amount>0
 GROUP BY 1)a
 GROUP BY 1,2;#163270
 
 
 -- friend base and new repeater
WITH friend_base AS (
SELECT clientid,enrolledstorecode FROM member_report 
WHERE tier = 'Friend' AND enrolledstorecode <> 'demo' 
AND enrolledstorecode <> 'corporate'
AND insertiondate<='2025-06-29' GROUP BY 1,2)#2538646

 
SELECT CASE WHEN enrolledstorecode=3011 THEN 'online' 
WHEN enrolledstorecode <> 3011 THEN 'offline' ELSE 'NULL' END `channel`,
CASE WHEN maxf=1 THEN 'new' 
WHEN maxf>1 THEN 'repeater' ELSE 'NULL' END tag,
COUNT(DISTINCT clientid)customers FROM (
SELECT clientid,MAX(frequencycount)maxf,MIN(frequencycount)minf,a.enrolledstorecode FROM friend_base a LEFT JOIN txn_report_accrual_redemption b USING(clientid)
WHERE storecode <> 'demo' AND storecode <> 'corporate' AND amount>0
GROUP BY 1)a
GROUP BY 1,2;#2049016
 
 
-- Type of customers who are in lapsed base.( 1-2 years)
 
WITH recency AS (
SELECT clientid,MAX(frequencycount)maxf,DATEDIFF('2025-06-29',MAX(txndate))recency FROM txn_report_accrual_redemption 
WHERE storecode <> 'demo' AND storecode <> 'corporate' AND amount>0
GROUP BY 1)

SELECT CASE WHEN maxf=1 THEN 'New' WHEN maxf>1 THEN 'Repeater' END 'Type',COUNT(DISTINCT clientid)customers FROM recency
WHERE recency BETWEEN 365 AND 730
GROUP BY 1;

-- Type of customers who have not shopped with us since 4-12 months

WITH recency AS (
SELECT clientid,MAX(frequencycount)maxf,DATEDIFF('2025-06-29',MAX(txndate))recency FROM txn_report_accrual_redemption 
WHERE storecode <> 'demo' AND storecode <> 'corporate' AND amount>0
GROUP BY 1)

SELECT CASE WHEN maxf=1 THEN 'New' WHEN maxf>1 THEN 'Repeater' END 'Type',COUNT(DISTINCT clientid)customers FROM recency
WHERE recency BETWEEN 120 AND 365
GROUP BY 1;




-- tier migration 
CREATE TABLE dummy.tiermovement_fy24_25_1
SELECT MembershipCardNo, MAX(TierStartDate)AS TierStartDate FROM tier_report_log 
WHERE TierStartDate<='2025-03-31' AND 1=0 GROUP BY 1;

INSERT INTO dummy.tiermovement_fy24_25_1
SELECT MembershipCardNo, MAX(TierStartDate)AS TierStartDate FROM tier_report_log 
WHERE TierStartDate<='2025-03-31' GROUP BY 1;#2714017

ALTER TABLE dummy.tiermovement_fy24_25_1 ADD COLUMN tier_fy24_25 VARCHAR(20);
ALTER TABLE dummy.tiermovement_fy24_25_1 ADD INDEX MembershipCardNo(MembershipCardNo), ADD INDEX TierStartDate(TierStartDate);

UPDATE dummy.tiermovement_fy24_25_1 a JOIN (SELECT MembershipCardNo,TierStartDate,currentTier 
FROM tier_report_log  
WHERE  DATE(TierStartDate)<='2025-03-31')b ON a.MembershipCardNo=b.MembershipCardNo AND a.tierstartdate=b.tierstartdate 
SET a.tier_fy24_25=b.currenttier; #2714016

SELECT tier_fy24_25,COUNT(*) FROM dummy.tiermovement_fy24_25_1 
GROUP BY 1;


SELECT a.tier_fy24_25 AS previous_month_tier,b.tier_feb25 AS current_month_tier, COUNT(DISTINCT b.mobile)customer
FROM dummy.tiermovement_fy24_25_1 a RIGHT JOIN dummy.tiermovement_feb25 b ON a.mobile=b.mobile 
GROUP BY 1,2;



CREATE TABLE dummy.tiermovement_fy23_24
SELECT MembershipCardNo, MAX(TierStartDate)AS TierStartDate FROM tier_report_log 
WHERE TierStartDate<='2024-03-31' AND 1=0 GROUP BY 1;

INSERT INTO dummy.tiermovement_fy23_24
SELECT MembershipCardNo, MAX(TierStartDate)AS TierStartDate FROM tier_report_log 
WHERE TierStartDate<='2024-03-31' GROUP BY 1;#2480167

ALTER TABLE dummy.tiermovement_fy23_24 ADD COLUMN tier_fy23_24 VARCHAR(20);
ALTER TABLE dummy.tiermovement_fy23_24 ADD INDEX MembershipCardNo(MembershipCardNo), ADD INDEX TierStartDate(TierStartDate);

UPDATE dummy.tiermovement_fy23_24 a JOIN (SELECT MembershipCardNo,TierStartDate,currentTier 
FROM tier_report_log  
WHERE  DATE(TierStartDate)<='2024-03-31')b ON a.MembershipCardNo=b.MembershipCardNo AND a.tierstartdate=b.tierstartdate 
SET a.tier_fy23_24=b.currenttier; #2480166

SELECT tier_fy23_24,COUNT(*) FROM dummy.tiermovement_fy23_24 
GROUP BY 1;
SELECT * FROM  dummy.tiermovement_fy24_25_1 


SELECT a.tier_fy23_24 AS previous_year_tier,b.tier_fy24_25 AS current_year_tier, COUNT(DISTINCT b.MembershipCardNo)customer
FROM dummy.tiermovement_fy23_24 a RIGHT JOIN dummy.tiermovement_fy24_25_1 b ON a.MembershipCardNo=b.MembershipCardNo 
GROUP BY 1,2;

-- upgrading with respect to few code 

SELECT CASE WHEN enrolledstorecode=3011 THEN 'online' 
WHEN enrolledstorecode <> 3011 THEN 'offline' END `channel`,
CASE WHEN maxf=1 THEN 'new' WHEN maxf>1 THEN 'repeater' END customer_type,membershipcardno,
SUM(sales)sales,SUM(bills)bills,uniqueitemcode FROM (
SELECT membershipcardno,MAX(frequencycount)maxf,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills,uniqueitemcode,enrolledstorecode
FROM dummy.tiermovement_fy24_25_1 a JOIN sku_report_loyalty b ON a.MembershipCardNo =b.clientid
JOIN member_report c ON a.MembershipCardNo=b.clientid
WHERE modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31'
AND uniqueitemcode IN ('BS-23221001',
'BS-23221R001',
'BS-23221P01',
'BS-23221PR01'
) 
AND itemnetamount>0 
AND modifiedstorecode NOT IN ('demo','corporate')
-- AND a.clientid IS NOT NULL
GROUP BY 1)a
GROUP BY 1,2,3;


-- insert into dummy.subscription_base
WITH base AS (
SELECT CASE WHEN enrolledstorecode=3011 THEN 'online'
WHEN enrolledstorecode <> 3011 THEN 'offline' END `channel`, membershipcardno,MAX(frequencycount)maxf,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills,uniqueitemcode
FROM dummy.tiermovement_fy24_25_1 a JOIN sku_report_loyalty b ON a.MembershipCardNo =b.clientid
JOIN member_report c ON a.MembershipCardNo=b.clientid
WHERE modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31'
AND uniqueitemcode IN ('BS-23221001',
'BS-23221R001',
'BS-23221P01',
'BS-23221PR01'
) 
AND itemnetamount>0 
AND modifiedstorecode NOT IN ('demo','corporate')
-- AND a.clientid IS NOT NULL
GROUP BY 1,2),
maxf AS (
SELECT CASE WHEN maxf=1 THEN 'new' WHEN maxf>1 THEN 'repeater' END `type`,`channel`,membershipcardno,SUM(sales)sales,SUM(bills)bills 
FROM base 
GROUP BY 1,2,3)

SELECT `channel`,`type`,
membershipcardno,SUM(sales),SUM(bills)bills,uniqueitemcode FROM base a JOIN maxf b ON a.membershipcardno=b.clientid
GROUP BY 1,2;







-- downgrade

INSERT INTO dummy.base_fy23_24
SELECT DISTINCT txnmappedmobile,uniqueitemcode FROM sku_report_loyalty
WHERE modifiedtxndate BETWEEN '2023-04-01' AND '2024-03-31'
AND uniqueitemcode IN ('BS-23221001',
'BS-23221R001',	
'BS-23221P01',	
'BS-23221PR01')  #81823

ALTER TABLE dummy.base_fy23_24 ADD INDEX txnmappedmobile(txnmappedmobile),ADD COLUMN maxdate DATE;

UPDATE dummy.base_fy23_24 a JOIN (
SELECT mobile,DATE(MAX(tierchangedate))maxdate FROM tier_report_log
WHERE tierchangedate BETWEEN '2023-04-01' AND '2024-03-31'
GROUP BY 1)b ON a.txnmappedmobile=b.mobile
SET a.maxdate=b.maxdate;#81609

ALTER TABLE dummy.base_fy23_24 ADD COLUMN previoustier23_24 VARCHAR(20);

UPDATE dummy.base_fy23_24 a JOIN (
SELECT DISTINCT txnmappedmobile,maxdate,b.currenttier FROM dummy.base_fy23_24 a JOIN tier_report_log b ON a.txnmappedmobile=b.mobile
AND a.maxdate=b.tierchangedate
WHERE tierchangedate BETWEEN '2023-04-01' AND '2024-03-31' GROUP BY 1,2)b ON a.txnmappedmobile=b.txnmappedmobile
SET a.currenttier= b.currenttier;#81609


ALTER TABLE dummy.base_fy23_24 ADD COLUMN fy24_25tier VARCHAR(20),ADD COLUMN TierChangeType VARCHAR(50);

SELECT * FROM dummy.base_fy23_24;

UPDATE dummy.base_fy23_24 a JOIN (
SELECT mobile,
MAX(tierchangedate)maxdate FROM tier_report_log b 
WHERE tierchangedate BETWEEN '2024-04-01' AND '2025-03-31'
GROUP BY 1)b ON a.txnmappedmobile=b.mobile
SET a.tierchange_date=b.maxdate;#75415

SELECT * FROM dummy.base_fy23_24;

UPDATE dummy.base_fy23_24 a JOIN (
SELECT DISTINCT mobile,currenttier,tierchangedate FROM tier_report_log
WHERE tierchangedate BETWEEN '2024-04-01' AND '2025-03-31')b ON a.txnmappedmobile = b.mobile AND a.tierchange_date=b.tierchangedate
SET a.fy24_25tier =b.currenttier;#75415

SELECT * FROM tier_report_log;#TierChangeType

UPDATE dummy.base_fy23_24 a JOIN (
SELECT mobile,TierChangeType,tierchangedate   FROM tier_report_log
WHERE tierchangedate BETWEEN '2024-04-01' AND '2025-03-31')b ON a.txnmappedmobile = b.mobile AND a.tierchange_date=b.tierchangedate
SET a.TierChangeType =b.TierChangeType;#75415

ALTER TABLE dummy.base_fy23_24 ADD COLUMN enrollestorecode VARCHAR(50);
SELECT * FROM dummy.base_fy23_24;

UPDATE dummy.base_fy23_24 a JOIN (
SELECT mobile,enrolledstorecode FROM member_report
)b ON a.txnmappedmobile=b.mobile
SET enrollestorecode='offline'
WHERE enrolledstorecode <> '3011';


SELECT * FROM sku_report_loyalty
WHERE txnmappedmobile = '9819084998';


SELECT CASE WHEN previoustier23_24 IN ('club','friend','platinum') THEN 'Retain'
WHEN previoustier23_24=fy24_25tier THEN 'Downgrade'
WHEN previoustier23_24=fy24_25tier THEN 'upgrade'
END


UPDATE dummy.base_fy23_24 AS main
JOIN (
    SELECT txnmappedmobile
    FROM dummy.base_fy23_24
    WHERE previoustier23_24 = 'Club'
) AS temp
ON main.txnmappedmobile = temp.txnmappedmobile
SET main.customer_status = 'Downgrade'
WHERE main.previoustier23_24 = 'Club' 
  AND main.fy24_25tier = 'friend'
  AND main.customer_status IS NULL;#13144,18054
  
  
  UPDATE dummy.base_fy23_24 AS main
JOIN (
    SELECT txnmappedmobile
    FROM dummy.base_fy23_24
    WHERE previoustier23_24 = 'Club'
) AS temp
ON main.txnmappedmobile = temp.txnmappedmobile
SET main.customer_status = 'Upgrade'
WHERE main.previoustier23_24 = 'Club' 
  AND main.fy24_25tier = 'Platinum'
  AND main.customer_status IS NULL;#13144,18054,2382
  
  
  
  
    UPDATE dummy.base_fy23_24 AS main
JOIN (
    SELECT txnmappedmobile
    FROM dummy.base_fy23_24
    WHERE previoustier23_24 = 'platinum'
) AS temp
ON main.txnmappedmobile = temp.txnmappedmobile
SET main.customer_status = 'Retain'
WHERE main.previoustier23_24 = 'Platinum' 
  AND main.fy24_25tier = 'Platinum'
  AND main.customer_status IS NULL;#9678
  
  
  
      UPDATE dummy.base_fy23_24 AS main
JOIN (
    SELECT txnmappedmobile
    FROM dummy.base_fy23_24
    WHERE previoustier23_24 = 'platinum'
) AS temp
ON main.txnmappedmobile = temp.txnmappedmobile
SET main.customer_status = 'Downgrade'
WHERE main.previoustier23_24 = 'Platinum' 
  AND main.fy24_25tier = 'Friend'
  AND main.customer_status IS NULL;#9678,32129,28
  
  
  SELECT * FROM dummy.base_fy23_24
  
  SELECT SUM(itemnetamount)sales FROM sku_report_loyalty a JOIN dummy.base_fy23_24 b USING(txnmappedmobile)
  WHERE modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31' AND b.uniqueitemcode IN ('BS-23221001',
'BS-23221R001',	
'BS-23221P01',	
'BS-23221PR01') AND tierchange_date IS NOT NULL



SELECT a.txnmappedmobile,a.uniqueitemcode,SUM(itemnetamount)sales 
FROM dummy.base_fy23_24 a JOIN sku_report_loyalty b USING(txnmappedmobile)
WHERE tierchange_date BETWEEN '2024-04-01' AND '2025-03-31' AND tierchange_date IS NOT NULL AND 
b.uniqueitemcode IN ('BS-23221001',
'BS-23221R001',	
'BS-23221P01',	
'BS-23221PR01')
GROUP BY 1;
2

SELECT * FROM sku_report_loyalty
WHERE txnmappedmobile ='9769467337'