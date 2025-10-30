-- ENT customers vintage mean who days gap between current date and modifiedenrolledon 
WITH customer_base AS (
SELECT mobile,vintage FROM (
SELECT mobile,DATEDIFF('2025-03-24',modifiedenrolledon)vintage FROM member_report 
WHERE modifiedenrolledon<='2025-03-24' 
AND mobile NOT IN (SELECT DISTINCT mobile FROM txn_report_accrual_redemption WHERE txndate<='2025-03-24')
GROUP BY 1)a
WHERE vintage <=90
GROUP BY 1)
SELECT a.mobile,vintage,enrolledstore,`last shopped store`,store_type 
FROM customer_base a LEFT JOIN program_single_view b ON a.mobile=b.mobile 
LEFT JOIN dummy.camp_coco_fofo_store c ON b.enrolledstore=c.storecode  
GROUP BY 1;









-- main code 
-- ENT customers vintage mean who days gap between current date and modifiedenrolledon 
CREATE TABLE dummy.harish_campus_campaign_data_for_apr_25
SELECT mobile,vintage,enrolledstorecode,store_type FROM (
SELECT mobile,DATEDIFF('2025-03-24',modifiedenrolledon)vintage,enrolledstorecode,store_type 
FROM member_report a LEFT JOIN dummy.camp_coco_fofo_store b ON a.enrolledstorecode=b.storecode 
WHERE modifiedenrolledon<='2025-03-24' 
AND mobile NOT IN (SELECT DISTINCT mobile FROM txn_report_accrual_redemption WHERE txndate<='2025-03-24')
GROUP BY 1,3,4)a
WHERE vintage <=90
GROUP BY 1; #33156 row(s) affected



SELECT * FROM dummy.harish_campus_campaign_data_for_apr_25

UPDATE dummy.harish_campus_campaign_data_for_apr_25 a
JOIN dummy.camp_coco_fofo_store b ON a.enrolledstorecode=b.storecode
SET a.store_type ='Ecom'
WHERE enrolledstorecode ='Ecom' AND a.store_type IN('null','#N/A');#12347

UPDATE dummy.harish_campus_campaign_data_for_apr_25 a
JOIN dummy.camp_coco_fofo_store b ON a.enrolledstorecode=b.storecode
SET a.store_type ='Corporate'
WHERE enrolledstorecode ='Corporate' AND a.store_type IN('null','#N/A');#13502


-- QC
SELECT * FROM member_report
WHERE mobile="6200944238";

SELECT * FROM dummy.camp_coco_fofo_store 
WHERE storecode = 'CAPLPNM';

SELECT * FROM txn_report_accrual_redemption
WHERE mobile ='6264646470';
-- main code end 

-- ent customer in given time of period 
CREATE TABLE dummy.harish_campus_campaign_ent_apr_25
SELECT mobile,enrolledstorecode,store_type FROM member_report a LEFT JOIN dummy.camp_coco_fofo_store b ON a.enrolledstorecode=b.storecode
WHERE mobile NOT IN (SELECT DISTINCT mobile FROM txn_report_accrual_redemption WHERE txndate BETWEEN '2024-01-01' AND '2025-03-24' AND billno NOT LIKE '%test%' AND storecode NOT LIKE 'demo')
AND modifiedenrolledon BETWEEN '2024-01-01' AND '2025-03-24'AND storecode NOT LIKE 'demo' 
GROUP BY 1;#295028

UPDATE dummy.harish_campus_campaign_ent_apr_25 a
JOIN dummy.camp_coco_fofo_store b ON a.enrolledstorecode=b.storecode
SET a.store_type ='Ecom'
WHERE enrolledstorecode ='Ecom' AND  a.store_type IN ('Null','#N/A');#63537

UPDATE dummy.harish_campus_campaign_ent_apr_25 a
JOIN dummy.camp_coco_fofo_store b ON a.enrolledstorecode=b.storecode
SET a.store_type ='Corporate'
WHERE enrolledstorecode ='Corporate' AND  a.store_type IN ('Null','#N/A');#201968



SELECT * FROM txn_report_accrual_redemption WHERE txndate BETWEEN '2024-01-01' AND '2025-03-24' AND mobile IN ('7007121859','7357986341',
'8319863828',
'9302770279',
'9559343550',
'9827973727',
'9834526313',
'9860096295',
'9927167009'
)



-- QC
SELECT * FROM member_report
WHERE mobile="6005055194";

SELECT * FROM dummy.camp_coco_fofo_store 
WHERE storecode = 'CAPLSRYN';

SELECT * FROM txn_report_accrual_redemption
WHERE mobile ='6005055194';