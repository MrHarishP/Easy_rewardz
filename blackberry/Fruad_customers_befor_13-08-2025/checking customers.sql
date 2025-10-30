SELECT COUNT(DISTINCT mobile) FROM dummy.`bb_sept_crm_segments` GROUP BY 1;
 
SELECT segment,COUNT(DISTINCT mobile) FROM dummy.poja_bb_Segment GROUP BY 1; 


SELECT tier,COUNT(DISTINCT mobile)mobile FROM member_report a 
WHERE mobile NOT IN (SELECT DISTINCT mobile FROM dummy.bb_sept_crm_segments)
AND 
mobile NOT IN (SELECT DISTINCT mobile FROM probable_fraud_customer)
GROUP BY 1;#1593808



SELECT 
    a.tier,
    COUNT(DISTINCT a.mobile) AS customers
FROM member_report a
WHERE NOT EXISTS (
    SELECT 1 
    FROM dummy.bb_sept_crm_segments b
    WHERE b.mobile = a.mobile
)
AND NOT EXISTS (
    SELECT 1 
    FROM probable_fraud_customer c
    WHERE c.mobile = a.mobile
)
GROUP BY a.tier;



#######################


WITH base AS (
SELECT COUNT(DISTINCT mobile) FROM member_report
WHERE 
mobile NOT IN (SELECT DISTINCT mobile FROM dummy.bb_sept_crm_segments)
AND 
mobile NOT IN (SELECT DISTINCT mobile FROM probable_fraud_customer)
)
SELECT mobile FROM base a JOIN member_report b USING(mobile);



CREATE TABLE dummy.member_sept_comm
WITH base AS (
SELECT DISTINCT mobile FROM member_report
WHERE mobile IN (SELECT DISTINCT mobile FROM dummy.bb_sept_crm_segments)
)
SELECT mobile FROM base a JOIN member_report b USING(mobile);#1383659


SELECT mobile FROM dummy.member_sept_comm a JOIN dummy.`bb_sept_crm_segments` b USING(mobile);


WITH base AS (
SELECT * FROM dummy.`bb_sept_crm_segments` 
WHERE mobile NOT IN (SELECT DISTINCT mobile FROM dummy.member_sept_comm)
)
SELECT mobile FROM base a JOIN member_report b USING(mobile)

SELECT * FROM dummy.bb_sept_crm_segments a JOIN probable_fraud_customer b USING(mobile) 
WHERE segments LIKE '%Online%' AND identifieddatemin<='2025-08-13'
GROUP BY 1;



SELECT * FROM probable_fraud_customer

WITH base AS (
SELECT DISTINCT mobile FROM member_report
WHERE mobile NOT IN (SELECT DISTINCT mobile FROM dummy.bb_sept_crm_segments))

SELECT COUNT(DISTINCT mobile) FROM `probable_fraud_customer` a JOIN base b USING(mobile);#18524


WITH base AS (
SELECT DISTINCT mobile FROM member_report
WHERE mobile NOT IN (SELECT DISTINCT mobile FROM dummy.bb_sept_crm_segments))

SELECT COUNT(DISTINCT mobile) FROM `probable_fraud_customer`
WHERE mobile IN (SELECT DISTINCT mobile FROM base);#18524



INSERT INTO dummy.not_dormat_customer 
SELECT DISTINCT mobile FROM member_report
WHERE mobile NOT IN (SELECT DISTINCT mobile FROM dummy.bb_sept_crm_segments)
AND mobile NOT IN (SELECT DISTINCT mobile FROM probable_fraud_customer)
AND tier != 'Dormant';#316300


SELECT DISTINCT mobile FROM probable_fraud_customer a JOIN dummy.not_dormat_customer b USING(mobile);






CREATE TABLE dummy.not_dormat_customer 
SELECT DISTINCT mobile FROM member_report
WHERE mobile NOT IN (SELECT DISTINCT mobile FROM dummy.bb_sept_crm_segments)
AND tier != 'Dormant';#332270


SELECT * FROM dummy.available_sku

INSERT INTO dummy.available_sku
SELECT txnmappedmobile,MAX(modifiedtxndate)last_date,MAX(insertiondate)latest_insertion,DATEDIFF('2025-08-28',MAX(modifiedtxndate))recency
FROM sku_report_loyalty 
WHERE txnmappedmobile IN (SELECT DISTINCT mobile FROM dummy.not_dormat_customer) 
AND txnmappedmobile NOT IN (SELECT DISTINCT mobile FROM `probable_fraud_customer`)
GROUP BY 1; #select 133494-170656=37162

SELECT * FROM dummy.shopped_before_1_aug_23

INSERT INTO dummy.shopped_before_1_aug_23
SELECT txnmappedmobile,MAX(modifiedtxndate)last_date,MAX(insertiondate)latest_insertion,DATEDIFF('2025-08-28',MAX(modifiedtxndate))recency
FROM sku_report_loyalty 
WHERE txnmappedmobile IN (SELECT DISTINCT mobile FROM dummy.not_dormat_customer) 
AND txnmappedmobile NOT IN (SELECT DISTINCT mobile FROM `probable_fraud_customer`)
GROUP BY 1#133494
HAVING last_date<'2023-08-01';#56355


INSERT INTO dummy.shopped_before_1_aug_23
SELECT txnmappedmobile,last_date,latest_insertion,recency FROM(
SELECT txnmappedmobile,MAX(modifiedtxndate)last_date,MAX(insertiondate)latest_insertion,DATEDIFF('2025-08-28',MAX(modifiedtxndate))recency
FROM sku_report_loyalty 
WHERE txnmappedmobile IN (SELECT DISTINCT mobile FROM dummy.not_dormat_customer) 
AND txnmappedmobile NOT IN (SELECT DISTINCT mobile FROM `probable_fraud_customer`)
GROUP BY 1)a
WHERE last_date<'2023-08-01';#114301


SELECT * FROM dummy.Remaining
-- 
-- insert into dummy.Remaining
-- select distinct txnmappedmobile from dummy.available_sku a join dummy.shopped_before_1_aug_23 b using(txnmappedmobile);#56355

INSERT INTO dummy.Remaining
SELECT DISTINCT txnmappedmobile FROM dummy.available_sku 
WHERE txnmappedmobile NOT IN (SELECT DISTINCT txnmappedmobile FROM dummy.shopped_before_1_aug_23) ;#56355

ALTER TABLE dummy.Remaining ADD INDEX txnmappedmobile(txnmappedmobile),ADD COLUMN recency VARCHAR(100);
ALTER TABLE dummy.Remaining ADD COLUMN recency VARCHAR(100);

ALTER TABLE dummy.Remaining DROP recency


ALTER TABLE dummy.Remaining ADD COLUMN modifiedenrolledon DATE;
ALTER TABLE dummy.Remaining ADD COLUMN tier VARCHAR(25);

UPDATE  dummy.Remaining a JOIN ( 
SELECT DISTINCT mobile,tier,modifiedenrolledon FROM member_report
)b ON a.txnmappedmobile=b.mobile
SET a.modifiedenrolledon=b.modifiedenrolledon , 
a.tier=b.tier;#56355


SELECT * FROM dummy.Remaining;

UPDATE dummy.Remaining a
JOIN (SELECT txnmappedmobile,DATEDIFF('2025-08-28',MAX(modifiedtxndate))recency FROM sku_report_loyalty 
WHERE 
txnmappedmobile IN (SELECT DISTINCT txnmappedmobile FROM dummy.Remaining) 
AND 
modifiedtxndate <='2025-08-28'
GROUP BY 1)b USING(txnmappedmobile)
SET a.recency=b.recency;#56355



ALTER TABLE dummy.Remaining ADD COLUMN last_date DATE ADD COLUMN last_insertiondate DATE ADD COLUMN 1Year_spend;



SELECT 
CASE 
WHEN recency<=30 THEN '30'
WHEN recency>30 AND recency<=60 THEN '31-60'
WHEN recency>60 AND recency<=120 THEN '61-120'
WHEN recency>120 AND recency<=360 THEN '120-360'
WHEN recency>360 AND recency<=730 THEN '360-730'
WHEN recency>730 THEN '>730' END recency,COUNT(DISTINCT txnmappedmobile)customer FROM dummy.Remaining
GROUP BY 1



SELECT 
CASE 
WHEN recency<=30 THEN '30'
WHEN recency>30 AND recency<=60 THEN '31-60'
WHEN recency>60 AND recency<=120 THEN '61-120'
WHEN recency>120 AND recency<=360 THEN '120-360'
WHEN recency>360 AND recency<=730 THEN '360-730'
WHEN recency>730 THEN '>730' END recency,COUNT(DISTINCT txnmappedmobile)customer FROM (
SELECT txnmappedmobile,DATEDIFF('2025-08-28',MAX(modifiedtxndate))recency FROM sku_report_loyalty 
WHERE txnmappedmobile IN (SELECT DISTINCT txnmappedmobile FROM dummy.Remaining) 
AND modifiedtxndate <='2025-08-28'
GROUP BY 1)a
GROUP BY 1 
ORDER BY recency;

CREATE TABLE dummy.last_pool
SELECT DISTINCT txnmappedmobile FROM (
SELECT txnmappedmobile,DATEDIFF('2025-08-28',MAX(modifiedtxndate))recency FROM sku_report_loyalty 
WHERE txnmappedmobile IN (SELECT DISTINCT txnmappedmobile FROM dummy.Remaining) 
AND modifiedtxndate <='2025-08-28'
GROUP BY 1)a
WHERE recency>30 AND recency<=360;

SELECT * FROM dummy.last_pool

SELECT txnmappedmobile,MAX(modifiedtxndate)last_date,MAX(insertiondate)lastest_insertion
FROM sku_report_loyalty 
WHERE txnmappedmobile IN (SELECT DISTINCT txnmappedmobile FROM dummy.last_pool)
GROUP BY 1;

CREATE TABLE dummy.fraud_logs
SELECT DISTINCT txnmappedmobile FROM dummy.last_pool a JOIN `probable_fraud_customer_log` b ON a.txnmappedmobile=b.mobile;#42


WITH base AS (
SELECT txnmappedmobile mobile,c.tier,MAX(modifiedtxndate)last_date,MAX(a.insertiondate)lastest_insertion
FROM sku_report_loyalty a JOIN dummy.last_pool b USING(txnmappedmobile)
LEFT JOIN member_report c ON a.txnmappedmobile=c.mobile 
WHERE txnmappedmobile NOT IN (SELECT DISTINCT txnmappedmobile FROM dummy.fraud_logs)
GROUP BY 1)

SELECT a.mobile,last_date,lastest_insertion,MAX(tierchangedate)tierchangedate,c.tier 
FROM `tier_report_log` a JOIN base b USING(mobile)
JOIN member_report c ON a.mobile=c.mobile
GROUP BY 1;

WITH base AS (
SELECT txnmappedmobile mobile,c.tier,MAX(modifiedtxndate)last_date,MAX(a.insertiondate)lastest_insertion
FROM sku_report_loyalty a JOIN dummy.last_pool b USING(txnmappedmobile)
LEFT JOIN member_report c ON a.txnmappedmobile=c.mobile 
WHERE txnmappedmobile NOT IN (SELECT DISTINCT txnmappedmobile FROM dummy.fraud_logs)
GROUP BY 1)

SELECT mobile,last_date,lastest_insertion,MAX(tierstartdate)tierchangedate,currenttier FROM `tier_detail_report` a JOIN base b USING(mobile)
GROUP BY 1;

SELECT * FROM tier_detail_report



SELECT CASE WHEN visit<=9 THEN visit END visit_tag,COUNT(DISTINCT txnmappedmobile)mobile FROM (
SELECT txnmappedmobile,COUNT(DISTINCT modifiedtxndate)visit FROM sku_report_loyalty 
WHERE txnmappedmobile IN (SELECT DISTINCT txnmappedmobile FROM dummy.Remaining) 
AND modifiedtxndate <='2025-08-28' 
GROUP BY 1)a GROUP BY 1;

SELECT DISTINCT mobile,modifiedenrolledon FROM member_report
WHERE mobile IN (SELECT DISTINCT txnmappedmobile FROM dummy.last_pool)



SELECT tier,mobile,totalspend,totaltxn,lasttxndate FROM member_report 
WHERE mobile IN (SELECT DISTINCT txnmappedmobile FROM dummy.Remaining)
AND mobile NOT IN (SELECT DISTINCT mobile FROM `probable_fraud_customer`)
GROUP BY 1,2;


SELECT * FROM member_report



SELECT * FROM sku_report_loyalty 
WHERE txnmappedmobile = '6000571848'