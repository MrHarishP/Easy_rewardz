SELECT gender,COUNT(DISTINCT mobile)customer,AVG(customerage)avg_age FROM(
SELECT 
CASE 
WHEN gender='male' THEN 'male'
WHEN gender='female' THEN 'female'
ELSE 'Unmapped' END gender,
mobile,customerage
FROM txn_report_accrual_redemption JOIN member_report USING(mobile)
WHERE txndate>='2025-02-01'
GROUP BY 1,2)a
GROUP BY 1#32467,32359


SELECT 
CASE 
WHEN gender='male' THEN 'male'
WHEN gender='female' THEN 'female'
ELSE 'Unmapped' END gender,
COUNT(DISTINCT mobile)customer,AVG(customerage)avg_age
FROM txn_report_accrual_redemption JOIN member_report USING(mobile)
WHERE txndate>='2025-02-01'
GROUP BY 1;



SELECT 
CASE 
	WHEN gender='male' THEN 'male'
	WHEN gender='female' THEN 'female'
ELSE 'Unmapped' END gender,
CASE 
	WHEN customerage>=0 AND customerage<=18 THEN '0-18'
	WHEN customerage>18 AND customerage<=35 THEN '19-35'
	WHEN customerage>36 AND customerage<=60 THEN '36-60'
	WHEN customerage>60 THEN '60+'
END age_bucket,
COUNT(DISTINCT mobile)customer
FROM txn_report_accrual_redemption JOIN member_report USING(mobile)
WHERE txndate>='2025-02-01'
GROUP BY 1,2;

