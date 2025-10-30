SELECT * FROM member_report LIMIT 100;
SELECT * FROM txn_report_accrual_redemption LIMIT 100;
SELECT * FROM sku_report_loyalty LIMIT 100;
SELECT * FROM sku_report_nonloyalty LIMIT 100;
SELECT * FROM coupon_offer_report LIMIT 100;
SELECT * FROM lapse_report LIMIT 100 ;
SELECT * FROM program_single_view LIMIT 100;

-- over all 
SELECT a.globaltestcontrol,COUNT(DISTINCT b.mobile)customer,
SUM(`Total spends`)/SUM(`Total Transactions`)atv,SUM(`Total spends`)/COUNT(DISTINCT mobile)amv,
AVG(`total visits`)avg_visits,SUM(`Total quantity poly excluded`)/SUM(`Total Transactions`)upt,
SUM(`Points spent`)PointsRedemption,SUM(couponRedeemed)CouponRedemption
FROM member_report a JOIN program_single_view b USING(mobile) 
WHERE a.globaltestcontrol IS NOT NULL 
-- and `Last shopped date` BETWEEN '2022-04-01' AND '2025-03-31'
GROUP BY 1;

-- QC
SELECT a.globaltestcontrol,COUNT(DISTINCT b.mobile)customer FROM member_report a JOIN program_single_view b USING(mobile) 
WHERE a.globaltestcontrol IS NOT NULL
GROUP BY 1;

-- 12 month active customer and repeater
SELECT a.globaltestcontrol,COUNT(DISTINCT b.mobile)activecustomer12M,
COUNT(DISTINCT CASE WHEN `Total visits`>1 THEN b.mobile END)repeater12M FROM member_report a JOIN program_single_view b USING(mobile)
WHERE a.globaltestcontrol IS NOT NULL AND `Last shopped date` BETWEEN '2024-04-01' AND '2025-03-31'
GROUP BY 1;

-- overaall customer for mvc tier
SELECT a.globaltestcontrol,COUNT(DISTINCT b.mobile)customer
FROM member_report a JOIN program_single_view b USING(mobile) 
WHERE a.globaltestcontrol IS NOT NULL AND  tiername LIKE 'MVC' 
GROUP BY 1;

-- tier name of MVC
SELECT a.globaltestcontrol,
SUM(`Total spends`)/SUM(`Total Transactions`)atv,SUM(`Total spends`)/COUNT(DISTINCT mobile)amv,
AVG(`total visits`)avg_visits,SUM(`Total quantity poly excluded`)/SUM(`Total Transactions`)upt,
SUM(`Points spent`)PointsRedemption,SUM(couponRedeemed)CouponRedemption
FROM member_report a JOIN program_single_view b USING(mobile) 
WHERE a.globaltestcontrol IS NOT NULL AND  tiername LIKE 'MVC' AND `Last shopped date` BETWEEN '2024-04-01' AND '2025-03-31'
GROUP BY 1;

-- 12 month active customer and repeater for tier name of MVC
SELECT a.globaltestcontrol,COUNT(DISTINCT b.mobile)activecustomer12M,
COUNT(DISTINCT CASE WHEN `Total visits`>1 THEN b.mobile END)repeater12M FROM member_report a JOIN program_single_view b USING(mobile)
WHERE a.globaltestcontrol IS NOT NULL AND `Last shopped date` BETWEEN '2024-04-01' AND '2025-03-31' AND tiername LIKE 'MVC'
GROUP BY 1;

-- overall tier active 
SELECT a.globaltestcontrol,COUNT(DISTINCT b.mobile)customer
FROM member_report a JOIN program_single_view b USING(mobile) 
WHERE a.globaltestcontrol IS NOT NULL AND  tiername LIKE 'active' 
GROUP BY 1;


-- tier name of active
SELECT a.globaltestcontrol,
SUM(`Total spends`)/SUM(`Total Transactions`)atv,SUM(`Total spends`)/COUNT(DISTINCT mobile)amv,
AVG(`total visits`)avg_visits,SUM(`Total quantity poly excluded`)/SUM(`Total Transactions`)upt,
SUM(`Points spent`)PointsRedemption,SUM(couponRedeemed)CouponRedemption
FROM member_report a JOIN program_single_view b USING(mobile) 
WHERE a.globaltestcontrol IS NOT NULL AND  tiername LIKE 'active' AND `Last shopped date` BETWEEN '2023-04-01' AND '2025-03-31'
GROUP BY 1;

-- 12 month active customer and repeater for tier name of active
SELECT a.globaltestcontrol,COUNT(DISTINCT b.mobile)activecustomer12M,
COUNT(DISTINCT CASE WHEN `Total visits`>1 THEN b.mobile END)repeater12M FROM member_report a JOIN program_single_view b USING(mobile)
WHERE a.globaltestcontrol IS NOT NULL AND `Last shopped date` BETWEEN '2024-04-01' AND '2025-03-31' AND tiername LIKE 'active'
GROUP BY 1;


-- tier name of dormant
SELECT a.globaltestcontrol,COUNT(DISTINCT b.mobile)customer,
SUM(`Total spends`)/SUM(`Total Transactions`)atv,SUM(`Total spends`)/COUNT(DISTINCT mobile)amv,
AVG(`total visits`)avg_visits,SUM(`Total quantity poly excluded`)/SUM(`Total Transactions`)upt,
SUM(`Points spent`)PointsRedemption,SUM(couponRedeemed)CouponRedemption
FROM member_report a JOIN program_single_view b USING(mobile) 
WHERE a.globaltestcontrol IS NOT NULL AND  tiername LIKE 'dormant'
GROUP BY 1;

-- 12 month active customer and repeater for tier name of dormant
SELECT a.globaltestcontrol,COUNT(DISTINCT b.mobile)activecustomer12M,
COUNT(DISTINCT CASE WHEN `Total visits`>1 THEN b.mobile END)repeater12M FROM member_report a JOIN program_single_view b USING(mobile)
WHERE a.globaltestcontrol IS NOT NULL AND `Last shopped date` BETWEEN '2024-04-01' AND '2025-03-31' AND tiername LIKE 'dormant'
GROUP BY 1;



SELECT b.globaltestcontrol,AVG(`average basket size`)upt FROM program_single_view a JOIN member_report b USING(mobile)
WHERE b.globaltestcontrol IS NOT NULL
GROUP BY 1


SELECT b.globaltestcontrol,SUM(itemqty)/COUNT(DISTINCT uniquebillno)upt FROM sku_report_loyalty a JOIN member_report b ON a.txnmappedmobile=b.mobile
WHERE b.globaltestcontrol IS NOT NULL
GROUP BY 1



SELECT DISTINCT globaltestcontrol FROM member_report 

