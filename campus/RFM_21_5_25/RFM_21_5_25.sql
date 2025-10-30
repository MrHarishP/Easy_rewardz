-- SELECT CASE WHEN (ab.rfm_active +ab.rfm_dormant+ab.rfm_lapse) >0  AND (ab.rfm_active +ab.rfm_dormant+ab.rfm_lapse) <=3 THEN '0-3'
-- WHEN (ab.rfm_active +ab.rfm_dormant+ab.rfm_lapse) >3 AND (ab.rfm_active +ab.rfm_dormant+ab.rfm_lapse) <=6 THEN '4-6'
-- WHEN (ab.rfm_active +ab.rfm_dormant+ab.rfm_lapse) >6 AND (ab.rfm_active +ab.rfm_dormant+ab.rfm_lapse) <=9 THEN '7-9'
-- WHEN (ab.rfm_active +ab.rfm_dormant+ab.rfm_lapse) >9 AND (ab.rfm_active +ab.rfm_dormant+ab.rfm_lapse) <=12 THEN '9-12'
-- WHEN (ab.rfm_active +ab.rfm_dormant+ab.rfm_lapse) >12 AND (ab.rfm_active +ab.rfm_dormant+ab.rfm_lapse) <=15 THEN '13-15'
-- END AS rfm_bucket, 



##################################################-- for coco --################################ 
SELECT ab.rfm_segment,ab.activity_segment, COUNT(ab.mobile), SUM( ab.`Total Spends`) sales, 
SUM(ab.`Total Transactions`) bills, SUM(`1_year_sales`) 1_year_sales ,SUM(`1_year_bills`) 1_year_bills
FROM fact_customer_rfm ab
JOIN program_single_view psv ON ab.mobile COLLATE utf8mb4_0900_ai_ci = psv.mobile
LEFT JOIN dummy.camp_coco_fofo_store b ON psv.`last shopped store` = b.storecode
WHERE ab.recency > 30 AND b.store_type = 'COCO' AND psv.`last shopped store` NOT IN ('ecom', 'demo')
GROUP BY 1,2;




##################################################-- for fofo --################################ 
SELECT ab.rfm_segment,ab.activity_segment, COUNT(ab.mobile), SUM( ab.`Total Spends`) sales, 
SUM(ab.`Total Transactions`) bills, SUM(`1_year_sales`) 1_year_sales ,SUM(`1_year_bills`) 1_year_bills
FROM fact_customer_rfm ab
JOIN program_single_view psv ON ab.mobile COLLATE utf8mb4_0900_ai_ci = psv.mobile
LEFT JOIN dummy.camp_coco_fofo_store b ON psv.`last shopped store` = b.storecode
WHERE ab.recency > 30 AND b.store_type = 'FOFO' AND psv.`last shopped store` NOT IN ('ecom', 'demo')
GROUP BY 1,2;




##################################################-- for ecom --################################ 
SELECT ab.rfm_segment,ab.activity_segment, COUNT(ab.mobile), SUM( ab.`Total Spends`) sales, 
SUM(ab.`Total Transactions`) bills, SUM(`1_year_sales`) 1_year_sales ,SUM(`1_year_bills`) 1_year_bills
FROM fact_customer_rfm ab
JOIN program_single_view psv ON ab.mobile COLLATE utf8mb4_0900_ai_ci = psv.mobile
LEFT JOIN dummy.camp_coco_fofo_store b ON psv.`last shopped store` = b.storecode
WHERE ab.recency > 30 AND psv.`last shopped store` = 'ecom'
GROUP BY 1,2;




##################################################-- overall --################################ 
SELECT ab.rfm_segment,ab.activity_segment, COUNT(ab.mobile), SUM( ab.`Total Spends`) sales, 
SUM(ab.`Total Transactions`) bills, SUM(`1_year_sales`) 1_year_sales ,SUM(`1_year_bills`) 1_year_bills
FROM fact_customer_rfm ab
JOIN program_single_view psv ON ab.mobile COLLATE utf8mb4_0900_ai_ci = psv.mobile
LEFT JOIN dummy.camp_coco_fofo_store b ON psv.`last shopped store` = b.storecode
WHERE ab.recency > 30 AND psv.`last shopped store` <> 'demo'
GROUP BY 1,2;
