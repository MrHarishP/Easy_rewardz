-- over all 
SELECT a.globaltestcontrol,COUNT(DISTINCT b.mobile)customer,
SUM(`Total spends`)/SUM(`Total Transactions`)atv,SUM(`Total spends`)/COUNT(DISTINCT mobile)amv,
AVG(`total visits`)avg_visits,SUM(`Total quantity poly excluded`)/SUM(`Total Transactions`)upt,
SUM(`Points spent`)PointsRedemption,SUM(couponRedeemed)CouponRedemption
FROM member_report a JOIN program_single_view b USING(mobile) 
WHERE a.globaltestcontrol IS NOT NULL 
AND `last shopped store` NOT IN ('demo','corporate')
-- and `Last shopped date` BETWEEN '2022-04-01' AND '2025-03-31'
GROUP BY 1;



-- QC
SELECT a.globaltestcontrol,COUNT(DISTINCT b.mobile)customer 
FROM member_report a JOIN program_single_view b USING(mobile) 
WHERE a.globaltestcontrol IS NOT NULL
AND `last shopped store` NOT IN ('demo','corporate')
GROUP BY 1;

-- 12 month active customer and repeater
SELECT a.globaltestcontrol,COUNT(DISTINCT b.mobile)activecustomer12M,
COUNT(DISTINCT CASE WHEN `Total visits`>1 THEN b.mobile END)repeater12M 
FROM member_report a JOIN program_single_view b USING(mobile)
WHERE a.globaltestcontrol IS NOT NULL AND `Last shopped date` BETWEEN '2024-07-01' AND '2025-06-30'
AND `last shopped store` NOT IN ('demo','corporate')
GROUP BY 1;


SELECT * FROM program_single_view;
