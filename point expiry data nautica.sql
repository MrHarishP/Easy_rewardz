SELECT * FROM txn_report_accrual_redemption LIMIT 100;
-- Please share the Loyalty Customer lapsing data  
-- (march and april, customer point getting lapsed) for the entire West region for Nautica, 
-- including their names, contact numbers, store names, and reward points. 

WITH customer_base AS (
SELECT mobile,lapsingdate,SUM(pointslapsing)points_lapsing,CONCAT(firstname,' ',lastname)`name`,enrolledstorecode,
SUM(b.availablePoints)available_Points 
FROM lapse_report a JOIN member_report b USING(mobile)
WHERE lapsingdate BETWEEN '2025-04-01' AND '2025-04-30'
GROUP BY 1,2)
SELECT a.*,region FROM customer_base a LEFT JOIN dummy.priyanshu_myntra_store_mapping b ON a.enrolledstorecode=b.storecode
WHERE Brand = 'nautica' AND region LIKE "west"



WITH lapsing_data AS (
SELECT mobile,lapsingdate,SUM(pointslapsing)points_lapsing FROM lapse_report
WHERE lapsingdate BETWEEN '2025-03-01' AND '2025-04-30'
GROUP BY 1,2),
member_data AS(
SELECT mobile,CONCAT(firstname,' ',lastname)`name`,enrolledstorecode,
SUM(availablePoints)available_Points FROM member_report 
GROUP BY 1,2,3)
SELECT a.mobile,lapsingdate,SUM(points_lapsing)points_lapsing,`name`,enrolledstorecode,
SUM(available_Points)available_Points FROM lapsing_data a JOIN member_data b ON a.mobile=b.mobile 
JOIN dummy.priyanshu_myntra_store_mapping c ON b.enrolledstorecode =c.storecode
WHERE  Brand = 'nautica' AND region LIKE "west"
GROUP BY 1,2;

-- QC

SELECT mobile,lapsingdate,SUM(pointslapsing)points_lapsing FROM lapse_report
WHERE lapsingdate BETWEEN '2025-03-01' AND '2025-04-30' AND mobile ='8481972907'
GROUP BY 1,2;

SELECT mobile,enrolledstorecode,SUM(availablePoints)availablePoints FROM member_report
WHERE mobile='9354341720'
GROUP BY 1,2;

SELECT * FROM member_Report
WHERE mobile ='9354341720'

SELECT * FROM lapse_report
WHERE mobile ='9354341720'


SELECT * FROM txn_report_accrual_redemption 
WHERE mobile ='9354341720'



SELECT DISTINCT region FROM store_master LIMIT 100;
SELECT * FROM lapse_report LIMIT 100;
SELECT * FROM program_single_view LIMIT 100;
SELECT * FROM dummy.priyanshu_myntra_store_mapping c LIMIT 100;
SELECT * FROM member_report LIMIT 100;


SELECT b.mobile,SUM(pointslapsing)points_lapsing,lapsingdate,CONCAT(firstname,' ',lastname)`name`,enrolledstore 
FROM lapse_report a LEFT JOIN member_report b ON a.mobile=b.mobile LEFT JOIN dummy.priyanshu_myntra_store_mapping c ON b.enrolledstore=c.storecode
WHERE lapsingdate BETWEEN '2025-03-01' AND '2025-04-30' AND brand LIKE 'nautica' AND region LIKE 'west' 
GROUP BY 1










SELECT mobile,enrolledstore,storecode FROM member_report a 
LEFT JOIN dummy.priyanshu_myntra_store_mapping b ON a.enrolledstore=b.storecode
-- where region = 'west' and brand ='nautica'
GROUP BY 1,2,3