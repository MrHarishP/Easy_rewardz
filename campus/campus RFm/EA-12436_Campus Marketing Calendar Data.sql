SELECT * FROM fact_customer_rfm;
SELECT 
CASE 
WHEN ab.activity_segment IN('Active One Timer','Active Repeater') THEN 'Active'
WHEN ab.activity_segment IN('Dormant One timer','Dormant Repeater') THEN 'Dormant'
WHEN ab.activity_segment IN('Lapsed One Timer','Lapsed Repeater') THEN 'Lapsed' END'Activity_segment',
CASE 
WHEN psv.`last shopped store` = 'CAPLCAPLAGSB' THEN 'North'
ELSE region END AS region,
COUNT(ab.mobile)customer, SUM( ab.`Total Spends`) sales, 
SUM(ab.`Total Transactions`) bills
FROM fact_customer_rfm ab
JOIN program_single_view psv ON ab.mobile COLLATE utf8mb4_0900_ai_ci = psv.mobile
LEFT JOIN store_master b ON psv.`last shopped store` = b.storecode
WHERE b.storetype1 = 'COCO' AND psv.`last shopped store` NOT IN ('ecom', 'demo')
AND ab.mobile COLLATE utf8mb4_0900_ai_ci IN (SELECT DISTINCT mobile FROM member_report WHERE smsreachability='true')
GROUP BY 1,2;


-- QC

SELECT -- CASE 
-- WHEN psv.`last shopped store` = 'CAPLCAPLAGSB' THEN 'North'
-- ELSE region END AS 
region,
COUNT(ab.mobile)customer, SUM( ab.`Total Spends`) sales, 
SUM(ab.`Total Transactions`) bills
FROM fact_customer_rfm ab
JOIN program_single_view psv ON ab.mobile COLLATE utf8mb4_0900_ai_ci = psv.mobile
LEFT JOIN store_master b ON psv.`last shopped store` = b.storecode
WHERE b.storetype1 = 'COCO' AND psv.`last shopped store` NOT IN ('ecom', 'demo')
AND ab.mobile COLLATE utf8mb4_0900_ai_ci IN (SELECT DISTINCT mobile FROM member_report WHERE smsreachability='true')
-- and region = 'North'
GROUP BY 1;




-- fofo

SELECT 
CASE 
WHEN ab.activity_segment IN('Active One Timer','Active Repeater') THEN 'Active'
WHEN ab.activity_segment IN('Dormant One timer','Dormant Repeater') THEN 'Dormant'
WHEN ab.activity_segment IN('Lapsed One Timer','Lapsed Repeater') THEN 'Lapsed' END'Activity_segment',
CASE 
WHEN psv.`last shopped store` = 'CAPLCAPLAGSB' THEN 'North'
ELSE region END AS region,
COUNT(ab.mobile)customer, SUM( ab.`Total Spends`) sales, 
SUM(ab.`Total Transactions`) bills
FROM fact_customer_rfm ab
JOIN program_single_view psv ON ab.mobile COLLATE utf8mb4_0900_ai_ci = psv.mobile
LEFT JOIN store_master b ON psv.`last shopped store` = b.storecode
WHERE b.storetype1 = 'FOFO' AND psv.`last shopped store` NOT IN ('ecom', 'demo')
AND ab.mobile COLLATE utf8mb4_0900_ai_ci IN (SELECT DISTINCT mobile FROM member_report WHERE smsreachability='true')
GROUP BY 1,2;

-- QC

SELECT CASE 
WHEN psv.`last shopped store` = 'CAPLCAPLAGSB' THEN 'North'
ELSE region END AS region,SUM( ab.`Total Spends`) sales, 
SUM(ab.`Total Transactions`) bills
FROM fact_customer_rfm ab
JOIN program_single_view psv ON ab.mobile COLLATE utf8mb4_0900_ai_ci = psv.mobile
LEFT JOIN store_master b ON psv.`last shopped store` = b.storecode
WHERE b.storetype1 = 'FOFO' AND psv.`last shopped store` NOT IN ('ecom', 'demo')
AND ab.mobile COLLATE utf8mb4_0900_ai_ci IN (SELECT DISTINCT mobile FROM member_report WHERE smsreachability='true')
-- and region ='North' or psv.`last shopped store` = 'CAPLCAPLAGSB'
GROUP BY 1;

SELECT region,SUM( ab.`Total Spends`) sales, 
SUM(ab.`Total Transactions`) bills
FROM fact_customer_rfm ab
JOIN program_single_view psv ON ab.mobile COLLATE utf8mb4_0900_ai_ci = psv.mobile
LEFT JOIN store_master b ON psv.`last shopped store` = b.storecode
WHERE b.storetype1 = 'FOFO' AND psv.`last shopped store` NOT IN ('ecom', 'demo')
AND ab.mobile COLLATE utf8mb4_0900_ai_ci IN (SELECT DISTINCT mobile FROM member_report WHERE smsreachability='true')
AND region ='north' 
OR psv.`last shopped store` = 'CAPLCAPLAGSB'
GROUP BY 1;


-- online
SELECT 
ab.activity_segment,
CASE 
WHEN psv.`last shopped store` = 'CAPLCAPLAGSB' THEN 'North'
ELSE region END AS region,
COUNT(ab.mobile)customer, SUM( ab.`Total Spends`) sales, 
SUM(ab.`Total Transactions`) bills
FROM fact_customer_rfm ab
JOIN program_single_view psv ON ab.mobile COLLATE utf8mb4_0900_ai_ci = psv.mobile
LEFT JOIN store_master b ON psv.`last shopped store` = b.storecode
WHERE  psv.`last shopped store`='ECOM' AND psv.`last shopped store` <>'demo'
AND ab.mobile COLLATE utf8mb4_0900_ai_ci IN (SELECT DISTINCT mobile FROM member_report WHERE smsreachability='true')
GROUP BY 1,2;

-- QC
SELECT
SUM( ab.`Total Spends`) sales, 
SUM(ab.`Total Transactions`) bills
FROM fact_customer_rfm ab
JOIN program_single_view psv ON ab.mobile COLLATE utf8mb4_0900_ai_ci = psv.mobile
LEFT JOIN store_master b ON psv.`last shopped store` = b.storecode
WHERE psv.`last shopped store` = 'ecom' AND psv.`last shopped store` NOT IN ('demo','corporate')
AND ab.mobile COLLATE utf8mb4_0900_ai_ci IN (SELECT DISTINCT mobile FROM member_report WHERE smsreachability='true');

SELECT region,SUM( ab.`Total Spends`) sales, 
SUM(ab.`Total Transactions`) bills
FROM fact_customer_rfm ab
JOIN program_single_view psv ON ab.mobile COLLATE utf8mb4_0900_ai_ci = psv.mobile
LEFT JOIN store_master b ON psv.`last shopped store` = b.storecode
WHERE psv.`last shopped store` NOT IN ('demo','corporate')
AND ab.mobile COLLATE utf8mb4_0900_ai_ci IN (SELECT DISTINCT mobile FROM member_report WHERE smsreachability='true')
GROUP BY 1;





-- offline
SELECT COUNT(ab.mobile), SUM( ab.`Total Spends`) sales, 
SUM(ab.`Total Transactions`) bills, SUM(`1_year_sales`) 1_year_sales ,SUM(`1_year_bills`) 1_year_bills
FROM fact_customer_rfm ab
JOIN program_single_view psv ON ab.mobile COLLATE utf8mb4_0900_ai_ci = psv.mobile
LEFT JOIN store_master b ON psv.`last shopped store` = b.storecode
WHERE psv.`last shopped store` <> 'ecom' AND psv.`last shopped store` NOT IN ('demo','corporate')
AND ab.mobile COLLATE utf8mb4_0900_ai_ci IN (SELECT DISTINCT mobile FROM member_report WHERE smsreachability='true');

-- total customer
SELECT region,
SUM( ab.`Total Spends`) sales, 
SUM(ab.`Total Transactions`) bills
FROM fact_customer_rfm ab
JOIN program_single_view psv ON ab.mobile COLLATE utf8mb4_0900_ai_ci = psv.mobile
LEFT JOIN store_master b ON psv.`last shopped store` = b.storecode
WHERE psv.`last shopped store` NOT IN ('demo','corporate')
AND ab.mobile COLLATE utf8mb4_0900_ai_ci IN (SELECT DISTINCT mobile FROM member_report WHERE smsreachability='true')
GROUP BY 1;


SELECT storetype1,SUM( ab.`Total Spends`) sales, 
SUM(ab.`Total Transactions`) bills,SUM(`1_year_sales`) 1_year_sales ,SUM(`1_year_bills`) 1_year_bills
FROM  fact_customer_rfm ab
JOIN program_single_view psv ON ab.mobile COLLATE utf8mb4_0900_ai_ci = psv.mobile
LEFT JOIN store_master b ON psv.`last shopped store` = b.storecode
WHERE ab.recency > 30 AND psv.`last shopped store` <> 'demo' AND psv.`last shopped store`<> 'corporate'
AND ab.mobile COLLATE utf8mb4_0900_ai_ci IN (SELECT DISTINCT mobile FROM member_report WHERE smsreachability='true')
GROUP BY 1;


-- ask 1 email we have
SELECT d.storetype1, COUNT(a.mobile) FROM 
(SELECT mobile, CASE WHEN `total transactions` = 0 THEN enrolledstore
                     WHEN `total transactions` > 0 THEN `last shopped store` END AS store
FROM program_single_view WHERE email IS NOT NULL
AND mobile IN (SELECT DISTINCT mobile FROM member_report WHERE smsreachability='true')
GROUP BY 1)a 
LEFT JOIN store_master d
ON a.store = d.storecode
WHERE store NOT LIKE '%demo%' AND store NOT LIKE '%corporate%'
GROUP BY 1;

SELECT COUNT(*) FROM(
SELECT mobile, CASE WHEN `total transactions` = 0 THEN enrolledstore
                     WHEN `total transactions` > 0 THEN `last shopped store` END AS store
FROM program_single_view WHERE email IS NOT NULL
AND mobile IN (SELECT DISTINCT mobile FROM member_report WHERE smsreachability='true')
GROUP BY 1) a
WHERE store = 'Ecom' AND store NOT LIKE 'demo' AND store NOT LIKE 'corporate';

SELECT COUNT(*) FROM member_report WHERE email IS NOT NULL 
AND mobile IN (SELECT DISTINCT mobile FROM member_report WHERE smsreachability='true');#431350
SELECT COUNT(*) FROM member_report WHERE email IS NOT NULL AND enrolledstorecode ='ecom'
AND mobile IN (SELECT DISTINCT mobile FROM member_report WHERE smsreachability='true');#375250




-- __________________ask 2 bday__________________________

SELECT COUNT(*) FROM member_Report WHERE MONTHNAME(dateofbirth) = 'august'
AND mobile IN (SELECT DISTINCT mobile FROM member_report WHERE smsreachability='true'); -- 14676
SELECT COUNT(*) FROM program_single_view WHERE MONTHNAME(dateofbirth) = 'august'
AND mobile IN (SELECT DISTINCT mobile FROM member_report WHERE smsreachability='true'); -- 13528
SELECT COUNT(*) FROM program_single_view WHERE MONTHNAME(dateofbirth) = 'august' AND `total transactions` = 0; -- 370
SELECT MAX(`last shopped date`) FROM program_single_view; -- 2025-04-25

SELECT d.storetype1, COUNT(a.mobile) FROM 
(SELECT mobile, CASE WHEN `total transactions` = 0 THEN enrolledstore
                     WHEN `total transactions` > 0 THEN `last shopped store` END AS store
FROM program_single_view WHERE MONTHNAME(dateofbirth) = 'October' 
AND mobile IN (SELECT DISTINCT mobile FROM member_report WHERE smsreachability='true')
GROUP BY 1)a 
JOIN store_master d
ON a.store = d.storecode
WHERE store NOT LIKE 'demo' AND store NOT LIKE 'corporate'
GROUP BY 1;

SELECT COUNT(*) FROM(
SELECT mobile, CASE WHEN `total transactions` = 0 THEN enrolledstore
                     WHEN `total transactions` > 0 THEN `last shopped store` END AS store
FROM program_single_view WHERE MONTHNAME(dateofbirth) = 'September'
AND mobile IN (SELECT DISTINCT mobile FROM member_report WHERE smsreachability='true')
GROUP BY 1) a
WHERE store = 'Ecom' AND store NOT LIKE 'demo' AND store NOT LIKE 'corporate'; -- 68


-- ask 3  column is missing 
SELECT storetype1, COUNT(DISTINCT mobile) FROM (
SELECT mobile,`last shopped store` storecode,`Total Transactions`,dateofbirth,gender,email,storetype1 
FROM program_single_view a JOIN store_master b
ON a.`last shopped store` = b.storecode 
WHERE (dateofbirth IS NOT NULL OR gender IS NOT NULL OR email IS NOT NULL)
AND `last shopped store` NOT LIKE '%demo%' AND enrolledstore NOT LIKE '%demo%'
AND mobile IN (SELECT DISTINCT mobile FROM member_report WHERE smsreachability='true')
GROUP BY 1)a
GROUP BY 1; 



SELECT DISTINCT storetype1,storecode,lpaasstore FROM store_master;
SELECT COUNT(*) FROM member_report WHERE (dateofbirth IS NOT NULL OR gender IS NOT NULL OR email IS NOT NULL)
AND smsreachability='true';


SELECT COUNT(DISTINCT mobile) FROM (
SELECT mobile,`last shopped store` storecode,`Total Transactions`,dateofbirth,gender,email,storetype1 
FROM program_single_view a JOIN store_master b
ON a.`last shopped store` = b.storecode 
WHERE (dateofbirth IS NOT NULL OR gender IS NOT NULL OR email IS NOT NULL)
AND `last shopped store` NOT LIKE '%demo%' AND a.`last shopped store`='corporate'
AND mobile IN (SELECT DISTINCT mobile FROM member_report WHERE smsreachability='true')
GROUP BY 1)a




## Execution Time : 33.586 sec
SELECT COUNT(mobile) FROM member_report 
WHERE mobile NOT IN 
(SELECT mobile FROM txn_report_accrual_redemption WHERE txndate BETWEEN '2024-02-01' AND '2025-05-31'
AND storecode NOT LIKE '%demo%')
AND enrolledon BETWEEN '2024-02-01' AND '2025-05-31'
AND enrolledstorecode NOT LIKE '%demo%'; -- 294186,300781

## Execution Time : 11.792 sec
SELECT COUNT(*) FROM program_single_view WHERE 
enrolledon BETWEEN '2024-02-01' AND '2025-05-31'
AND `total transactions` = 0 AND `last shopped date` IS NULL; -- 291718,297499

-- ______________________ask 4 ent _________________
 
SELECT d.storetype1, COUNT(a.mobile) FROM 
(SELECT mobile, enrolledstore AS store
FROM program_single_view WHERE enrolledon BETWEEN '2025-06-01' AND '2025-08-31'
AND `total transactions` = 0 AND `last shopped date` IS NULL AND enrolledstore NOT LIKE '%demo%' 
AND enrolledstore NOT LIKE '%corporate%'
AND mobile IN (SELECT DISTINCT mobile FROM member_report WHERE smsreachability='true')
GROUP BY 1)a 
JOIN store_master d
ON a.store = d.storecode
GROUP BY 1;
-- 
-- SELECT d.storetype1, mobile FROM 
-- (SELECT mobile, enrolledstore AS store
-- FROM program_single_view WHERE enrolledon BETWEEN '2024-02-01' AND '2025-05-31'
-- AND `total transactions` = 0 AND `last shopped date` IS NULL AND enrolledstore NOT LIKE '%demo%'
-- GROUP BY 1)a 
-- JOIN store_master d
-- ON a.store = d.storecode
-- GROUP BY 1;

SELECT * FROM program_single_view WHERE mobile ='6000032938'; -- Corporate


SELECT COUNT(a.mobile) FROM 
(SELECT mobile, enrolledstore AS store
FROM program_single_view WHERE enrolledon BETWEEN '2024-03-01' AND '2025-06-30'
AND `total transactions` = 0 AND `last shopped date` IS NULL AND enrolledstore NOT LIKE '%demo%'
AND enrolledstore NOT LIKE '%corporate%'
AND mobile IN (SELECT DISTINCT mobile FROM member_report WHERE smsreachability='true')
GROUP BY 1)a 
WHERE store = 'Ecom'; -- 60311


SELECT * FROM dummy.harish_campus_need_upto_25_5;
 
 SELECT * FROM program_single_view WHERE mobile ='6000107028';  -- corporate
 
 
 
 
SELECT d.storetype1, COUNT(a.mobile) FROM 
(SELECT mobile, enrolledstore AS store
FROM program_single_view WHERE enrolledon BETWEEN '2025-04-01' AND '2025-06-30'
AND `total transactions` = 0 AND `last shopped date` IS NULL AND enrolledstore NOT LIKE '%demo%'
AND enrolledstore NOT LIKE '%corporate%'
AND mobile IN (SELECT DISTINCT mobile FROM member_report WHERE smsreachability='true')
GROUP BY 1)a 
JOIN store_master d
ON a.store = d.storecode
GROUP BY 1;

SELECT COUNT(a.mobile) FROM 
(SELECT mobile, enrolledstore AS store
FROM program_single_view WHERE enrolledon BETWEEN '2025-04-01' AND '2025-06-30'
AND `total transactions` = 0 AND `last shopped date` IS NULL AND enrolledstore NOT LIKE '%demo%'
AND enrolledstore NOT LIKE '%corporate%' 
AND mobile IN (SELECT DISTINCT mobile FROM member_report WHERE smsreachability='true')
GROUP BY 1)a 
WHERE store = 'Ecom'; -- 13624 
 
 
 SELECT * FROM store_master;


SELECT b.storetype1,COUNT(DISTINCT mobile) FROM member_report a JOIN store_master b ON a.enrolledstorecode=b.storecode
WHERE 
-- enrolledstorecode='ecom' and 
enrolledstorecode NOT LIKE '%demo%' AND enrolledstorecode NOT LIKE '%corporate%' 
-- and dateofbirth IS NULL
-- OR gender IS NULL
-- OR email IS NULL
GROUP BY 1;

SELECT storetype1,enrolledstorecode FROM member_report a JOIN store_master b ON a.enrolledstorecode=b.storecode
WHERE 
-- enrolledstorecode='ecom' and 
enrolledstorecode NOT LIKE '%demo%' AND enrolledstorecode NOT LIKE '%corporate%' 
GROUP BY 1,2

