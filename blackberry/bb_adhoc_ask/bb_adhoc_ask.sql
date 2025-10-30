CREATE TABLE dummy.harish_bb_base_segment
SELECT  'Feb23 - Jan24' AS Duration,mobile,CASE WHEN minf=1 THEN 'new' ELSE 'repeater' END AS Cust_Tag FROM (
SELECT mobile,MIN(frequencycount)minf FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2023-02-01' AND '2024-01-31'
AND storecode <> 'demo' AND amount > 0
GROUP BY 1)a
UNION 
SELECT  'Mar23 - Feb24' AS Duration,mobile,CASE WHEN minf=1 THEN 'new' ELSE 'repeater' END AS Cust_Tag FROM (
SELECT mobile,MIN(frequencycount)minf FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2023-03-01' AND '2024-02-29'
AND storecode <> 'demo' AND amount>0
GROUP BY 1)a
UNION
SELECT  'Apr23 - Mar24' AS Duration,mobile,CASE WHEN minf=1 THEN 'new' ELSE 'repeater' END AS Cust_Tag FROM (
SELECT mobile,MIN(frequencycount)minf FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2023-04-01' AND '2024-03-31'
AND storecode <> 'demo' AND amount>0
GROUP BY 1)a
UNION
SELECT  'May23 - Apr24' AS Duration,mobile,CASE WHEN minf=1 THEN 'new' ELSE 'repeater' END AS Cust_Tag FROM (
SELECT mobile,MIN(frequencycount)minf FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2023-05-01' AND '2024-04-30'
AND storecode <> 'demo' AND amount>0
GROUP BY 1)a;#2542020

-- customer count or new and repeat
SELECT cust_tag,duration,COUNT(DISTINCT mobile)customers FROM dummy.harish_bb_base_segment
GROUP BY 1,2
ORDER BY FIELD(duration, 'Feb23 - Jan24', 'Mar23 - Feb24', 'Apr23 - Mar24', 'May23 - Apr24');


-- customer who repeat from new to repeat and repeat to repeat 
SELECT cust_tag,'Feb24' AS duration,COUNT(DISTINCT b.mobile)customer,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills FROM txn_report_accrual_redemption a 
JOIN dummy.harish_bb_base_segment b USING(mobile)
WHERE txndate BETWEEN '2024-02-01' AND '2024-02-29'
-- and cust_tag='new' 
AND duration ='Feb23 - Jan24'
GROUP BY 1
UNION ALL
SELECT cust_tag,'Mar24'AS duration,COUNT(DISTINCT b.mobile)customer,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills FROM txn_report_accrual_redemption a 
JOIN dummy.harish_bb_base_segment b USING(mobile)
WHERE txndate BETWEEN '2024-03-01' AND '2024-03-31'
-- and cust_tag='new' 
AND duration ='Mar23 - Feb24'
GROUP BY 1
UNION ALL 
SELECT cust_tag,'Apr24'AS duration,COUNT(DISTINCT b.mobile)customer,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills FROM txn_report_accrual_redemption a 
JOIN dummy.harish_bb_base_segment b USING(mobile)
WHERE txndate BETWEEN '2024-04-01' AND '2024-04-30'
-- and cust_tag='new' 
AND duration ='Apr23 - Mar24'
GROUP BY 1
UNION ALL 
SELECT cust_tag,'May24' AS duration,COUNT(DISTINCT b.mobile)customer,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills FROM txn_report_accrual_redemption a 
JOIN dummy.harish_bb_base_segment b USING(mobile)
WHERE txndate BETWEEN '2024-05-01' AND '2024-05-31'
-- and cust_tag='new' 
AND duration ='May23 - Apr24'
GROUP BY 1;




CREATE TABLE dummy.harish_bb_base_segment_25
SELECT  'Feb24 - Jan25' AS Duration,mobile,CASE WHEN minf=1 THEN 'new' ELSE 'repeater' END AS Cust_Tag FROM (
SELECT mobile,MIN(frequencycount)minf FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2024-02-01' AND '2025-01-31'
AND storecode <> 'demo' AND amount > 0
GROUP BY 1)a
UNION 
SELECT  'Mar24 - Feb25' AS Duration,mobile,CASE WHEN minf=1 THEN 'new' ELSE 'repeater' END AS Cust_Tag FROM (
SELECT mobile,MIN(frequencycount)minf FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2024-03-01' AND '2025-02-28'
AND storecode <> 'demo' AND amount>0
GROUP BY 1)a
UNION
SELECT  'Apr24 - Mar25' AS Duration,mobile,CASE WHEN minf=1 THEN 'new' ELSE 'repeater' END AS Cust_Tag FROM (
SELECT mobile,MIN(frequencycount)minf FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2024-04-01' AND '2025-03-31'
AND storecode <> 'demo' AND amount>0
GROUP BY 1)a
UNION
SELECT  'May24 - Apr25' AS Duration,mobile,CASE WHEN minf=1 THEN 'new' ELSE 'repeater' END AS Cust_Tag FROM (
SELECT mobile,MIN(frequencycount)minf FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2024-05-01' AND '2025-04-30'
AND storecode <> 'demo' AND amount>0
GROUP BY 1)a;#2707194

-- customer count or new and repeat
SELECT cust_tag,duration,COUNT(DISTINCT mobile)customers FROM dummy.harish_bb_base_segment_25
GROUP BY 1,2
ORDER BY FIELD(duration, 'Feb24 - Jan25', 'Mar24 - Feb25', 'Apr24 - Mar25', 'May24 - Apr25');


-- customer who repeat from new to repeat and repeat to repeat 
SELECT cust_tag,'feb25' AS duration,COUNT(DISTINCT b.mobile)customer,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills FROM txn_report_accrual_redemption a 
JOIN dummy.harish_bb_base_segment_25 b USING(mobile)
WHERE txndate BETWEEN '2025-02-01' AND '2025-02-28'
-- and cust_tag='new' 
AND duration ='Feb24 - Jan25'
GROUP BY 1
UNION ALL
SELECT cust_tag,'mar25' AS duration,COUNT(DISTINCT b.mobile)customer,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills FROM txn_report_accrual_redemption a 
JOIN dummy.harish_bb_base_segment_25 b USING(mobile)
WHERE txndate BETWEEN '2025-03-01' AND '2025-03-31'
-- and cust_tag='new' 
AND duration ='Mar24 - Feb25'
GROUP BY 1
UNION ALL 
SELECT cust_tag,'apr25' AS duration,COUNT(DISTINCT b.mobile)customer,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills FROM txn_report_accrual_redemption a 
JOIN dummy.harish_bb_base_segment_25 b USING(mobile)
WHERE txndate BETWEEN '2025-04-01' AND '2025-04-30'
-- and cust_tag='new' 
AND duration ='Apr24 - Mar25'
GROUP BY 1
UNION ALL 
SELECT cust_tag,'may25' AS duration,COUNT(DISTINCT b.mobile)customer,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills FROM txn_report_accrual_redemption a 
JOIN dummy.harish_bb_base_segment_25 b USING(mobile)
WHERE txndate BETWEEN '2025-05-01' AND '2025-05-31'
-- and cust_tag='new' 
AND duration ='May24 - Apr25'
GROUP BY 1;

-- previous year 24
CREATE TABLE dummy.harish_bb_base_segment24_winback1
WITH base AS (
SELECT DISTINCT mobile FROM txn_report_accrual_redemption WHERE txndate BETWEEN '2023-02-01' AND '2024-01-31')
SELECT DISTINCT mobile,'Before Feb23' AS duration  FROM txn_report_accrual_redemption a LEFT JOIN base b USING(mobile)
WHERE txndate < '2023-02-01' AND amount>0
AND b.mobile IS NULL 
UNION 
(WITH base AS (
SELECT DISTINCT mobile FROM txn_report_accrual_redemption WHERE txndate BETWEEN '2023-03-01' AND '2024-02-29')
SELECT DISTINCT mobile,'Before Mar23' AS duration FROM txn_report_accrual_redemption a LEFT JOIN base b USING(mobile)
WHERE txndate < '2023-03-01' AND amount>0
AND b.mobile IS NULL )
UNION
(WITH base AS (
SELECT DISTINCT mobile FROM txn_report_accrual_redemption WHERE txndate BETWEEN '2023-04-01' AND '2024-03-31')
SELECT DISTINCT mobile,'Before Apr23' AS duration FROM txn_report_accrual_redemption a LEFT JOIN base b USING(mobile)
WHERE txndate < '2023-04-01' AND amount>0
AND b.mobile IS NULL )
UNION
(WITH base AS (
SELECT DISTINCT mobile FROM txn_report_accrual_redemption WHERE txndate BETWEEN '2023-05-01' AND '2024-04-30')
SELECT DISTINCT mobile,'Before May23' AS duration FROM txn_report_accrual_redemption a LEFT JOIN base b USING(mobile)
WHERE txndate < '2023-05-01' AND amount>0
AND b.mobile IS NULL ); #4914184,4911598

SELECT duration, COUNT(DISTINCT mobile)customer
FROM dummy.harish_bb_base_segment24_winback1 
GROUP BY 1;

SELECT 'feb24' AS duration,COUNT(DISTINCT mobile)customer,SUM(amount)sales,
COUNT(DISTINCT uniquebillno)bills,SUM(amount)/COUNT(DISTINCT uniquebillno)atv 
FROM dummy.harish_bb_base_segment24_winback1 a JOIN txn_report_accrual_redemption b USING(mobile)
WHERE txndate BETWEEN '2024-02-01' AND '2024-02-29' AND duration ='Before feb23' AND amount>0
GROUP BY 1
UNION ALL
SELECT 'Mar24' AS duration,COUNT(DISTINCT mobile)customer,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills,
SUM(amount)/COUNT(DISTINCT uniquebillno)atv FROM dummy.harish_bb_base_segment24_winback1 a 
JOIN txn_report_accrual_redemption b USING(mobile)
WHERE txndate BETWEEN '2024-03-01' AND '2024-03-31'  AND duration ='Before Mar23' AND amount>0
GROUP BY 1
UNION ALL
SELECT 'Apr24' AS duration,COUNT(DISTINCT mobile)customer,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills,
SUM(amount)/COUNT(DISTINCT uniquebillno)atv FROM dummy.harish_bb_base_segment24_winback1 a JOIN txn_report_accrual_redemption b USING(mobile)
WHERE txndate BETWEEN '2024-04-01' AND '2024-04-30' AND duration ='Before apr23' AND amount>0
GROUP BY 1
UNION ALL
SELECT 'May24' AS duration,COUNT(DISTINCT mobile)customer,SUM(amount)sales,
COUNT(DISTINCT uniquebillno)bills,SUM(amount)/COUNT(DISTINCT uniquebillno)atv FROM dummy.harish_bb_base_segment24_winback1 a JOIN txn_report_accrual_redemption b USING(mobile)
WHERE txndate BETWEEN '2024-05-01' AND '2024-05-31' AND duration ='Before May23' AND amount>0
GROUP BY 1;


-- current year 2025 
INSERT INTO dummy.harish_bb_base_segment_25_winback1
WITH base AS (
SELECT DISTINCT mobile FROM txn_report_accrual_redemption WHERE txndate BETWEEN '2024-02-01' AND '2025-01-31')
SELECT DISTINCT mobile,'Before Feb24' AS duration  FROM txn_report_accrual_redemption a LEFT JOIN base b USING(mobile)
WHERE txndate < '2024-02-01' AND amount>0 AND storecode <> 'demo'
AND b.mobile IS NULL 
UNION 
(WITH base AS (
SELECT DISTINCT mobile FROM txn_report_accrual_redemption WHERE txndate BETWEEN '2024-03-01' AND '2025-02-28')
SELECT DISTINCT mobile,'Before Mar24' AS duration FROM txn_report_accrual_redemption a LEFT JOIN base b USING(mobile)
WHERE txndate < '2024-03-01' AND amount>0 AND storecode <> 'demo'
AND b.mobile IS NULL )
UNION
(WITH base AS (
SELECT DISTINCT mobile FROM txn_report_accrual_redemption WHERE txndate BETWEEN '2024-04-01' AND '2025-03-31')
SELECT DISTINCT mobile,'Before Apr24' AS duration FROM txn_report_accrual_redemption a LEFT JOIN base b USING(mobile)
WHERE txndate < '2024-04-01' AND amount>0 AND storecode <> 'demo'
AND b.mobile IS NULL )
UNION
(WITH base AS (
SELECT DISTINCT mobile FROM txn_report_accrual_redemption WHERE txndate BETWEEN '2024-05-01' AND '2025-04-30')
SELECT DISTINCT mobile,'Before May24' AS duration FROM txn_report_accrual_redemption a LEFT JOIN base b USING(mobile)
WHERE txndate < '2024-05-01' AND amount>0 AND storecode <> 'demo'
AND b.mobile IS NULL); #6485815,6483405

SELECT duration,COUNT(DISTINCT mobile) FROM dummy.harish_bb_base_segment_25_winback1
GROUP BY 1;

SELECT 'feb25' AS duration,COUNT(DISTINCT mobile)customer,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills FROM dummy.harish_bb_base_segment_25_winback1 a JOIN txn_report_accrual_redemption b USING(mobile)
WHERE txndate BETWEEN '2025-02-01' AND '2025-02-28' AND duration ='Before feb24' AND amount>0
GROUP BY 1
UNION ALL
SELECT 'Mar25' AS duration,COUNT(DISTINCT mobile)customer,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills FROM dummy.harish_bb_base_segment_25_winback1 a JOIN txn_report_accrual_redemption b USING(mobile)
WHERE txndate BETWEEN '2025-03-01' AND '2025-03-31' AND duration ='Before mar24' AND amount>0
GROUP BY 1
UNION ALL
SELECT 'Apr25' AS duration,COUNT(DISTINCT mobile)customer,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills FROM dummy.harish_bb_base_segment_25_winback1 a JOIN txn_report_accrual_redemption b USING(mobile)
WHERE txndate BETWEEN '2025-04-01' AND '2025-04-30' AND duration ='Before apr24' AND amount>0
GROUP BY 1
UNION ALL
SELECT 'May25' AS duration,COUNT(DISTINCT mobile)customer,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills FROM dummy.harish_bb_base_segment_25_winback1 a JOIN txn_report_accrual_redemption b USING(mobile)
WHERE txndate BETWEEN '2025-05-01' AND '2025-05-31' AND duration ='Before may24' AND amount>0
GROUP BY 1;

-- mvc tier migration
-- Jan25
CREATE TABLE dummy.tiermovement_jan25
SELECT mobile, MAX(TierStartDate)AS TierStartDate FROM tier_report_log 
WHERE TierStartDate<='2025-01-31' AND 1=0 GROUP BY 1;

INSERT INTO dummy.tiermovement_jan25
SELECT mobile, MAX(TierStartDate)AS TierStartDate FROM tier_report_log 
WHERE TierStartDate<='2025-01-31' GROUP BY 1;#2773509

ALTER TABLE dummy.tiermovement_jan25 ADD COLUMN tier_jan25 VARCHAR(20);
ALTER TABLE dummy.tiermovement_jan25 ADD INDEX mobile(mobile), ADD INDEX TierStartDate(TierStartDate);

UPDATE dummy.tiermovement_jan25 a JOIN (SELECT mobile,TierStartDate,currentTier 
FROM tier_report_log  
WHERE  DATE(TierStartDate)<='2025-01-31')b ON a.mobile=b.mobile AND a.tierstartdate=b.tierstartdate 
SET a.tier_jan25=b.currenttier; #2773509

SELECT tier_jan25,COUNT(*) FROM dummy.tiermovement_jan25 
GROUP BY 1;

SELECT a.tier_jan25 AS previous_month_tier,b.tier_feb25 AS current_month_tier, COUNT(DISTINCT b.mobile)customer
FROM dummy.tiermovement_jan25 a RIGHT JOIN dummy.tiermovement_feb25 b ON a.mobile=b.mobile 
GROUP BY 1,2;


-- Feb25
CREATE TABLE dummy.tiermovement_feb25
SELECT mobile, MAX(TierStartDate)AS TierStartDate FROM tier_report_log 
WHERE TierStartDate<='2025-02-28' AND 1=0 GROUP BY 1;

INSERT INTO dummy.tiermovement_feb25
SELECT mobile, MAX(TierStartDate)AS TierStartDate FROM tier_report_log 
WHERE TierStartDate<='2025-02-28' GROUP BY 1;

ALTER TABLE dummy.tiermovement_feb25 ADD COLUMN tier_feb25 VARCHAR(20);
ALTER TABLE dummy.tiermovement_feb25 ADD INDEX mobile(mobile), ADD INDEX TierStartDate(TierStartDate);

UPDATE dummy.tiermovement_feb25 a JOIN (SELECT mobile,TierStartDate,currentTier 
FROM tier_report_log  
WHERE  DATE(TierStartDate)<='2025-02-28')b ON a.mobile=b.mobile AND a.tierstartdate=b.tierstartdate 
SET a.tier_feb25=b.currenttier;

SELECT tier_feb25,COUNT(*) FROM dummy.tiermovement_feb25
GROUP BY 1;

SELECT a.tier_feb25 AS previous_month_tier,b.tier_mar25 AS current_month_tier, COUNT(DISTINCT b.mobile)customer
FROM dummy.tiermovement_feb25 a RIGHT JOIN dummy.tiermovement_mar25 b ON a.mobile=b.mobile 
GROUP BY 1,2;


-- Mar25
CREATE TABLE dummy.tiermovement_mar25
SELECT mobile, MAX(TierStartDate)AS TierStartDate FROM tier_report_log 
WHERE TierStartDate<='2025-03-31' AND 1=0 GROUP BY 1;

INSERT INTO dummy.tiermovement_mar25
SELECT mobile, MAX(TierStartDate)AS TierStartDate FROM tier_report_log 
WHERE TierStartDate<='2025-03-31' GROUP BY 1;

ALTER TABLE dummy.tiermovement_mar25 ADD COLUMN tier_mar25 VARCHAR(20);
ALTER TABLE dummy.tiermovement_mar25 ADD INDEX mobile(mobile), ADD INDEX TierStartDate(TierStartDate);

UPDATE dummy.tiermovement_mar25 a JOIN (SELECT mobile,TierStartDate,currentTier 
FROM tier_report_log  
WHERE  DATE(TierStartDate)<='2025-03-31')b ON a.mobile=b.mobile AND a.tierstartdate=b.tierstartdate 
SET a.tier_mar25=b.currenttier;

SELECT tier_mar25,COUNT(*) FROM dummy.tiermovement_mar25
GROUP BY 1;

SELECT a.tier_mar25 AS previous_month_tier,b.tier_apr25 AS current_month_tier, COUNT(DISTINCT b.mobile)customer
FROM dummy.tiermovement_mar25 a RIGHT JOIN dummy.tiermovement_apr25 b ON a.mobile=b.mobile 
GROUP BY 1,2;

SELECT a.tier_mar25 AS previous_month_tier,b.tier_apr25 AS current_month_tier, COUNT(DISTINCT b.mobile)customer
FROM dummy.tiermovement_mar25 a left JOIN dummy.tiermovement_apr25 b ON a.mobile=b.mobile 
GROUP BY 1,2;


-- Apr25
CREATE TABLE dummy.tiermovement_Apr25
SELECT mobile, MAX(TierStartDate)AS TierStartDate FROM tier_report_log 
WHERE TierStartDate<='2025-04-30' AND 1=0 GROUP BY 1;

INSERT INTO dummy.tiermovement_Apr25
SELECT mobile, MAX(TierStartDate)AS TierStartDate FROM tier_report_log 
WHERE TierStartDate<='2025-04-30' GROUP BY 1;

ALTER TABLE dummy.tiermovement_Apr25 ADD COLUMN tier_Apr25 VARCHAR(20);
ALTER TABLE dummy.tiermovement_Apr25 ADD INDEX mobile(mobile), ADD INDEX TierStartDate(TierStartDate);

UPDATE dummy.tiermovement_Apr25 a JOIN (SELECT mobile,TierStartDate,currentTier 
FROM tier_report_log  
WHERE  DATE(TierStartDate)<='2025-04-30')b ON a.mobile=b.mobile AND a.tierstartdate=b.tierstartdate 
SET a.tier_Apr25=b.currenttier;

SELECT tier_apr25,COUNT(*) FROM dummy.tiermovement_apr25
GROUP BY 1;

SELECT a.tier_apr25 AS previous_month_tier,b.tier_may25 AS current_month_tier, COUNT(DISTINCT b.mobile)customer
FROM dummy.tiermovement_apr25 a RIGHT JOIN dummy.tiermovement_may25 b ON a.mobile=b.mobile 
GROUP BY 1,2;


-- May25

CREATE TABLE dummy.tiermovement_May25
SELECT mobile, MAX(TierStartDate)AS TierStartDate FROM tier_report_log 
WHERE TierStartDate<='2025-05-31' AND 1=0 GROUP BY 1;

INSERT INTO dummy.tiermovement_May25
SELECT mobile, MAX(TierStartDate)AS TierStartDate FROM tier_report_log 
WHERE TierStartDate<='2025-05-31' GROUP BY 1;

ALTER TABLE dummy.tiermovement_May25 ADD COLUMN tier_May25 VARCHAR(20);
ALTER TABLE dummy.tiermovement_May25 ADD INDEX mobile(mobile), ADD INDEX TierStartDate(TierStartDate);

UPDATE dummy.tiermovement_May25 a JOIN (SELECT mobile,TierStartDate,currentTier 
FROM tier_report_log  
WHERE  DATE(TierStartDate)<='2025-05-31')b ON a.mobile=b.mobile AND a.tierstartdate=b.tierstartdate 
SET a.tier_May25=b.currenttier;

SELECT tier_may25,COUNT(*) FROM dummy.tiermovement_apr25
GROUP BY 1;

SELECT a.tier_apr25 AS previous_month_tier,b.tier_may25 AS current_month_tier, COUNT(DISTINCT b.mobile)customer
FROM dummy.tiermovement_may25 a RIGHT JOIN dummy.tiermovement_june25 b ON a.mobile=b.mobile 
GROUP BY 1,2;


-- Jun25
CREATE TABLE dummy.tiermovement_Jun25
SELECT mobile, MAX(TierStartDate)AS TierStartDate FROM tier_report_log 
WHERE TierStartDate<='2025-06-30' AND 1=0 GROUP BY 1;

INSERT INTO dummy.tiermovement_Jun25
SELECT mobile, MAX(TierStartDate)AS TierStartDate FROM tier_report_log 
WHERE TierStartDate<='2025-06-30' GROUP BY 1;

ALTER TABLE dummy.tiermovement_Jun25 ADD COLUMN tier_Jun25 VARCHAR(20);
ALTER TABLE dummy.tiermovement_Jun25 ADD INDEX mobile(mobile), ADD INDEX TierStartDate(TierStartDate);

UPDATE dummy.tiermovement_Jun25 a JOIN (SELECT mobile,TierStartDate,currentTier 
FROM tier_report_log  
WHERE  DATE(TierStartDate)<='2025-06-30')b ON a.mobile=b.mobile AND a.tierstartdate=b.tierstartdate 
SET a.tier_Jun25=b.currenttier;

SELECT tier_jun25,COUNT(*) FROM dummy.tiermovement_jun25
GROUP BY 1;

SELECT a.tier_may25 AS previous_month_tier,b.tier_jun25 AS current_month_tier, COUNT(DISTINCT b.mobile)customer
FROM dummy.tiermovement_25 a RIGHT JOIN dummy.tiermovement_june25 b ON a.mobile=b.mobile 
GROUP BY 1,2;