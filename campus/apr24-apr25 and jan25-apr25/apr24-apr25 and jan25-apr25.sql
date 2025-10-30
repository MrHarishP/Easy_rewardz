-- select * from dummy.`camp_coco_fofo_store`
-- where storecode = 'ecom';online storetype 


CREATE TABLE dummy.harish_campus_need_upto_25_5(
SELECT store_type,mobile FROM member_report a JOIN dummy.`camp_coco_fofo_store` b ON a.enrolledstorecode=b.storecode 
WHERE mobile NOT IN (SELECT mobile FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2024-02-01' AND '2025-04-24' AND storecode NOT LIKE 'demo')
AND enrolledstorecode NOT LIKE 'demo'
AND modifiedenrolledon BETWEEN '2024-02-01' AND '2025-04-24'
GROUP BY 1,2);#293688
SELECT store_type,COUNT(DISTINCT mobile)customer FROM dummy.harish_campus_need_upto_25_5
GROUP BY 1;



CREATE TABLE dummy.harish_campus_need_an25_apr25_upto_25_5(
SELECT store_type,mobile FROM member_report a JOIN dummy.`camp_coco_fofo_store` b ON a.enrolledstorecode=b.storecode 
WHERE mobile NOT IN (SELECT mobile FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2025-01-01' AND '2025-04-24' AND storecode NOT LIKE 'demo')
AND enrolledstorecode NOT LIKE 'demo'
AND modifiedenrolledon BETWEEN '2025-01-01' AND '2025-04-24'
GROUP BY 1,2
);#35542
SELECT store_type,COUNT(DISTINCT mobile)customer FROM dummy.harish_campus_need_an25_apr25_upto_25_5
GROUP BY 1;


-- birthday table 
CREATE TABLE dummy.harish_bday_may_25(
SELECT store_type,mobile 
FROM member_report a JOIN  dummy.`camp_coco_fofo_store` b ON a.enrolledstorecode=b.storecode 
WHERE MONTHNAME(dateofbirth)='may' AND store_type IN ('coco','fofo','online')
GROUP BY 1,2);#14509

SELECT store_type,COUNT(DISTINCT mobile)customer FROM dummy.harish_bday_may_25
GROUP BY 1;


-- email data form this table 
SELECT COUNT(DISTINCT mobile) FROM dummy.campuscrm_email_id_data;


SELECT COUNT(DISTINCT mobile) FROM member_report 
WHERE email IS NOT NULL OR email !=' '



SELECT mobile,`last shopped store`,storecode,store_type 
FROM program_single_view a JOIN dummy.`camp_coco_fofo_store` b ON a.`last shopped store`=b.storecode 
WHERE mobile NOT IN (SELECT mobile FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2025-01-01' AND '2025-04-24' AND storecode NOT LIKE 'demo')
AND `last shopped store` NOT LIKE 'demo'
AND `last shopped date` BETWEEN '2025-01-01' AND '2025-04-24'
GROUP BY 1;


SELECT store_type,COUNT(DISTINCT mobile)Mobile FROM program_single_view a JOIN dummy.`camp_coco_fofo_store` b ON a.`last shopped store`=b.storecode 
WHERE mobile NOT IN (SELECT mobile FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2025-01-01' AND '2025-04-24' AND storecode NOT LIKE 'demo')
AND `last shopped store` NOT LIKE 'demo'
AND enrolledon BETWEEN '2025-01-01' AND '2025-04-24'
GROUP BY 1

SELECT store_type,Mobile FROM program_single_view a JOIN dummy.`camp_coco_fofo_store` b ON a.`last shopped store`=b.storecode 
WHERE mobile NOT IN (SELECT mobile FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2025-01-01' AND '2025-04-24' AND storecode NOT LIKE 'demo')
AND `last shopped store` NOT LIKE 'demo'
AND enrolledon BETWEEN '2025-01-01' AND '2025-04-24'
GROUP BY 1,2



-- jan 25 to apr 25 from program single view 
SELECT store_type,COUNT(DISTINCT Mobile)mobile 
FROM program_single_view a JOIN dummy.`camp_coco_fofo_store` b ON a.`last shopped store`=b.storecode 
WHERE `last shopped store` NOT LIKE 'demo' AND `total transactions`
AND enrolledon BETWEEN '2025-01-01' AND '2025-04-24'
GROUP BY 1;

SELECT store_type,mobile 
FROM program_single_view a JOIN dummy.`camp_coco_fofo_store` b ON a.`last shopped store`=b.storecode 
WHERE `last shopped store` NOT LIKE 'demo' AND `total transactions`
AND enrolledon BETWEEN '2025-01-01' AND '2025-04-24'
GROUP BY 1,2;

SELECT * FROM txn_report_accrual_redemption 
WHERE mobile IN ()




SELECT * FROM program_single_view LIMIT 10

SELECT * FROM program_single_view;
SELECT * FROM dummy.`camp_coco_fofo_store`;