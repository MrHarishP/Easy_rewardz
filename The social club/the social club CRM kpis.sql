

-- for snapshort L2L
CREATE TABLE dummy.txn_l2l_storecode_24_25_social_club_harish 
WITH base_25 AS (
SELECT DISTINCT storecode FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2025-02-01' AND '2025-09-30'
AND storecode NOT LIKE '%demo%' 
AND BillNo NOT LIKE '%test%' 
AND BillNo NOT LIKE '%roll%'
AND amount > 0 ),

base_24 AS (
SELECT DISTINCT storecode FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2024-02-01' AND '2024-09-30'
AND storecode NOT LIKE '%demo%' 
AND BillNo NOT LIKE '%test%' 
AND BillNo NOT LIKE '%roll%'
AND amount > 0 )

SELECT DISTINCT storecode FROM base_24 a JOIN base_25 b USING(storecode)#51

SELECT * FROM member_report LIMIT 10

CREATE TABLE dummy.txn_l2l_enrolledstorecode_24_25_social_club_harish 
WITH base_25 AS (
SELECT DISTINCT enrolledstorecode FROM member_report 
WHERE modifiedenrolledon BETWEEN '2025-02-01' AND '2025-09-30'
AND EnrolledStorecode NOT  LIKE '%demo%'
 AND EnrolledStorecode NOT  LIKE '%test%'),

base_24 AS (
SELECT DISTINCT enrolledstorecode FROM member_report 
WHERE modifiedenrolledon BETWEEN '2024-02-01' AND '2024-09-30'
AND EnrolledStorecode NOT  LIKE '%demo%'
 AND EnrolledStorecode NOT  LIKE '%test%')

SELECT DISTINCT enrolledstorecode FROM base_24 a JOIN base_25 b USING(enrolledstorecode)#638


SELECT * FROM dummy.sku_non_loyalty_l2l_social_club_harish

CREATE TABLE dummy.sku_non_loyalty_l2l_social_club_harish
WITH base_24 AS (
SELECT DISTINCT modifiedstorecode FROM sku_report_nonloyalty 
WHERE modifiedtxndate BETWEEN'2024-02-01' AND '2024-09-30'
AND itemnetamount>0),
base_25 AS (
SELECT DISTINCT modifiedstorecode FROM sku_report_nonloyalty 
WHERE modifiedtxndate BETWEEN'2025-02-01' AND '2025-09-30'
AND itemnetamount>0)

SELECT DISTINCT modifiedstorecode FROM base_24 a JOIN  base_25 b USING(modifiedstorecode);#26



-- enrolments
-- for both when you want to use L2L then uncomment the storecode in line else run this 

SELECT 
CASE 
WHEN ModifiedEnrolledOn BETWEEN '2025-01-01' AND '2025-03-31' THEN '2025-01-01 AND 2025-03-31'
WHEN ModifiedEnrolledOn BETWEEN '2025-04-01' AND '2025-06-30' THEN '2025-04-01 AND 2025-06-30'
WHEN ModifiedEnrolledOn BETWEEN '2025-07-01' AND '2025-09-30' THEN '2025-07-01 AND 2025-09-30' 
END PERIOD,
COUNT(DISTINCT mobile)enrolments
 FROM member_report 
 WHERE  ((ModifiedEnrolledOn  BETWEEN '2025-01-01' AND '2025-03-31') 
 OR (ModifiedEnrolledOn BETWEEN '2025-04-01' AND '2025-06-30')
 OR (ModifiedEnrolledOn BETWEEN '2025-07-01' AND '2025-09-30'))
 AND EnrolledStore NOT  LIKE '%demo%'
 AND EnrolledStore NOT  LIKE '%test%'
 AND enrolledstorecode IN (SELECT DISTINCT enrolledstorecode FROM dummy.txn_l2l_enrolledstorecode_24_25_social_club_harish)
 GROUP BY 1;
 
 
 
 
--  brand_snapshot-ovrall
--       
-- WITH txn_base AS (
--     SELECT 
--         txnmappedmobile AS Mobile,
--         itemnetamount AS Amount,
--         UniqueBillNo,
--         FrequencyCount,
--         modifiedtxndate,
--         ItemQty
--     FROM `smokehousedeli`.sku_report_loyalty
--     WHERE modifiedtxndate BETWEEN 
-- --   '2025-01-01' AND '2025-03-31'
-- --   '2025-04-01' and '2025-06-30'
-- -- '2025-07-01' and '2025-09-30'
-- --  '2024-01-01' AND '2024-03-31'
-- --  '2024-04-01' and '2024-06-30'
--  '2024-07-01' AND '2024-09-30'
-- -- and modifiedstorecode in 
-- -- (SELECT like_to_like FROM  dummy.smokehousedeli_like_to_like_store_jan_sep_24_25)
--       AND modifiedstorecode NOT LIKE '%demo%' 
--       AND ModifiedBillNo NOT LIKE '%test%' 
--       AND ModifiedBillNo NOT LIKE '%roll%'
-- ), base_data AS (
--     SELECT 
--         mobile,
--         SUM(amount) AS sales,
--         COUNT(DISTINCT UniqueBillNo) AS bills,
--         MAX(FrequencyCount) AS maxf,
--         MIN(FrequencyCount) AS minf,
--         COUNT(DISTINCT modifiedtxndate) AS visit,
--         SUM(ItemQty) AS ItemQty
--     FROM txn_base  
--     WHERE amount > 0 
--     GROUP BY 1
-- )
-- SELECT 
--     SUM(sales) AS loyalty_sales,
--     SUM(CASE WHEN maxf > 1 THEN sales END) AS repeater_sales,
--     SUM(bills) AS loyalty_bills,
--     SUM(CASE WHEN maxf > 1 THEN bills END) AS repeater_bills,
--     COUNT(DISTINCT mobile) AS Transacted_Customers,
--     COUNT(DISTINCT CASE WHEN maxf > 1 THEN Mobile END) AS Repeater,
--     SUM(sales) / COUNT(DISTINCT mobile) AS amv,
--     SUM(CASE WHEN maxf > 1 THEN sales END) /
--       COUNT(DISTINCT CASE WHEN maxf > 1 THEN mobile END) AS Repeat_AMV,
--     SUM(sales) / SUM(bills) AS atv,
--     SUM(CASE WHEN maxf > 1 THEN sales END) /
--       SUM(CASE WHEN maxf > 1 THEN bills END) AS Repeat_atv,
--     AVG(visit) AS Avg_visit,
--     SUM(ItemQty) / SUM(bills) AS UPT,
--     SUM(sales) / SUM(ItemQty) AS asp,
--     AVG (CASE WHEN maxf > 1 THEN visit END) AS Avg_Repeater_visit
-- FROM base_data; 
-- 
-- 
-- select * from txn_report_accrual_redemption;

WITH base AS (
SELECT 
CASE 
WHEN txndate BETWEEN '2024-02-01' AND '2024-03-31' THEN '2024-02-01 AND 2024-03-31'
WHEN txndate BETWEEN '2024-04-01' AND '2024-06-30' THEN '2024-04-01 AND 2024-06-30'
WHEN txndate BETWEEN '2024-07-01' AND '2024-09-30' THEN '2024-07-01 AND 2024-09-30' 
END PERIOD,
mobile,
SUM(amount) AS sales,
COUNT(DISTINCT UniqueBillNo) AS bills,
MAX(FrequencyCount) AS maxf,
MIN(FrequencyCount) AS minf,
COUNT(DISTINCT txndate) AS visit
-- datediff(max(txndate),min(txndate))/nullif((count(distinct txndate),-1),0)latency
FROM txn_report_accrual_redemption 
WHERE ((txndate  BETWEEN '2024-02-01' AND '2024-03-31') 
OR (txndate BETWEEN '2024-04-01' AND '2024-06-30')
OR (txndate BETWEEN '2024-07-01' AND '2024-09-30'))
AND storecode NOT LIKE '%demo%' 
AND BillNo NOT LIKE '%test%' 
AND BillNo NOT LIKE '%roll%'
AND storecode IN (SELECT DISTINCT storecode FROM dummy.txn_l2l_storecode_24_25_social_club_harish )
AND amount > 0 
GROUP BY 1,2)

SELECT PERIOD,
    SUM(sales) AS loyalty_sales,
    SUM(CASE WHEN maxf > 1 THEN sales END) AS repeater_sales,
    SUM(bills) AS loyalty_bills,
    SUM(CASE WHEN maxf > 1 THEN bills END) AS repeater_bills,
    COUNT(DISTINCT mobile) AS Transacted_Customers,
    COUNT(DISTINCT CASE WHEN maxf > 1 THEN Mobile END) AS Repeater,
    SUM(sales) / COUNT(DISTINCT mobile) AS amv,
    SUM(CASE WHEN maxf > 1 THEN sales END) /
      COUNT(DISTINCT CASE WHEN maxf > 1 THEN mobile END) AS Repeat_AMV,
    SUM(sales) / SUM(bills) AS atv,
    SUM(CASE WHEN maxf > 1 THEN sales END) /
      SUM(CASE WHEN maxf > 1 THEN bills END) AS Repeat_atv,
    AVG(visit) AS Avg_visit,
    AVG (CASE WHEN maxf > 1 THEN visit END) AS Avg_Repeater_visit
--     sum(latency)/count(distinct txndate)
--     avg(latency)
FROM base
GROUP BY 1;




-- select sum(amount)sales,count(distinct uniquebillno)bill from txn_report_accrual_redemption 
-- where txndate between '2025-01-01' and '2025-03-31'
-- and amount>0;



WITH base AS (
 SELECT 
CASE 
WHEN txndate BETWEEN '2024-02-01' AND '2024-03-31' THEN '2024-02-01 AND 2024-03-31'
WHEN txndate BETWEEN '2024-04-01' AND '2024-06-30' THEN '2024-04-01 AND 2024-06-30'
WHEN txndate BETWEEN '2024-07-01' AND '2024-09-30' THEN '2024-07-01 AND 2024-09-30' 
END PERIOD,
mobile,DATEDIFF(MAX(txndate),MIN(txndate))/NULLIF((COUNT(DISTINCT txndate)-1),0)latency 
FROM txn_report_accrual_redemption
WHERE ((txndate  BETWEEN '2024-02-01' AND '2024-03-31') 
OR (txndate BETWEEN '2024-04-01' AND '2024-06-30')
OR (txndate BETWEEN '2024-07-01' AND '2024-09-30'))
AND storecode NOT LIKE '%demo%' 
AND BillNo NOT LIKE '%test%' 
AND BillNo NOT LIKE '%roll%'
AND storecode IN (SELECT DISTINCT storecode FROM dummy.txn_l2l_storecode_24_25_social_club_harish )
AND amount > 0 
GROUP BY 1,2)

SELECT PERIOD,AVG(latency)ag_latency FROM base 
GROUP BY 1;


-- non_loyalty

-- 
-- SELECT SUM(itemnetamount)nonloyalty_sales,COUNT(DISTINCT UniqueBillNo)nonloyalty_bills
-- FROM sku_report_nonloyalty 
-- WHERE modifiedtxndate BETWEEN 
-- -- '2025-01-01' AND '2025-03-31'
-- --        '2024-04-01' and '2024-06-30'
-- -- '2024-07-01' and '2024-09-30'


SELECT PERIOD,SUM(sales)total_sales,SUM(bills)total_bills FROM (
SELECT 
CASE 
WHEN txndate BETWEEN '2024-02-01' AND '2024-03-31' THEN '2024-02-01 AND 2024-03-31'
WHEN txndate BETWEEN '2024-04-01' AND '2024-06-30' THEN '2024-04-01 AND 2024-06-30'
WHEN txndate BETWEEN '2024-07-01' AND '2024-09-30' THEN '2024-07-01 AND 2024-09-30' 
END PERIOD,
SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills FROM txn_report_accrual_redemption 
WHERE ((txndate  BETWEEN '2024-02-01' AND '2024-03-31') 
OR (txndate BETWEEN '2024-04-01' AND '2024-06-30')
OR (txndate BETWEEN '2024-07-01' AND '2024-09-30'))
AND storecode NOT LIKE '%demo%' 
AND BillNo NOT LIKE '%test%' 
AND BillNo NOT LIKE '%roll%'
AND storecode IN (SELECT DISTINCT storecode FROM dummy.txn_l2l_storecode_24_25_social_club_harish )
AND amount > 0 
GROUP BY 1
UNION
SELECT 
CASE 
WHEN modifiedtxndate BETWEEN '2024-02-01' AND '2024-03-31' THEN '2024-02-01 AND 2024-03-31'
WHEN modifiedtxndate BETWEEN '2024-04-01' AND '2024-06-30' THEN '2024-04-01 AND 2024-06-30'
WHEN modifiedtxndate BETWEEN '2024-07-01' AND '2024-09-30' THEN '2024-07-01 AND 2024-09-30' 
END PERIOD,
SUM(itemnetamount)sales,COUNT(DISTINCT UniqueBillNo)bills
FROM sku_report_nonloyalty 
WHERE ((modifiedtxndate BETWEEN '2024-02-01' AND '2024-03-31')
OR (modifiedtxndate BETWEEN '2024-04-01' AND '2024-06-30')
OR (modifiedtxndate BETWEEN'2024-07-01' AND '2024-09-30'))
AND itemnetamount>0
AND modifiedstorecode IN (SELECT DISTINCT modifiedstorecode FROM dummy.sku_non_loyalty_l2l_social_club_harish )
GROUP BY 1)a GROUP BY 1;


SELECT 
CASE 
WHEN modifiedtxndate BETWEEN '2024-02-01' AND '2024-03-31' THEN '2024-02-01 AND 2024-03-31'
WHEN modifiedtxndate BETWEEN '2024-04-01' AND '2024-06-30' THEN '2024-04-01 AND 2024-06-30'
WHEN modifiedtxndate BETWEEN '2024-07-01' AND '2024-09-30' THEN '2024-07-01 AND 2024-09-30' 
END PERIOD,
SUM(itemnetamount)nonloyaltysales,COUNT(DISTINCT UniqueBillNo)nonloyaltbills
FROM sku_report_nonloyalty 
WHERE ((modifiedtxndate BETWEEN '2024-02-01' AND '2024-03-31')
OR (modifiedtxndate BETWEEN '2024-04-01' AND '2024-06-30')
OR (modifiedtxndate BETWEEN'2024-07-01' AND '2024-09-30'))
AND itemnetamount>0
AND modifiedstorecode IN (SELECT DISTINCT modifiedstorecode FROM dummy.sku_non_loyalty_l2l_social_club_harish )
GROUP BY 1;


SELECT 
CASE 
WHEN txndate BETWEEN '2024-02-01' AND '2024-03-31' THEN '2024-02-01 AND 2024-03-31'
WHEN txndate BETWEEN '2024-04-01' AND '2024-06-30' THEN '2024-04-01 AND 2024-06-30'
WHEN txndate BETWEEN '2024-07-01' AND '2024-09-30' THEN '2024-07-01 AND 2024-09-30' 
END PERIOD,
SUM(amount)loyaltsales,COUNT(DISTINCT uniquebillno)loyaltbills FROM txn_report_accrual_redemption 
WHERE ((txndate  BETWEEN '2024-02-01' AND '2024-03-31') 
OR (txndate BETWEEN '2024-04-01' AND '2024-06-30')
OR (txndate BETWEEN '2024-07-01' AND '2024-09-30'))
AND storecode NOT LIKE '%demo%' 
AND BillNo NOT LIKE '%test%' 
AND BillNo NOT LIKE '%roll%'
AND storecode IN (SELECT DISTINCT storecode FROM dummy.txn_l2l_storecode_24_25_social_club_harish )
AND amount > 0 
GROUP BY 1;


-- mom 
 SELECT MONTHNAME(txndate)txnmonth,SUM(sales)Total_sales,SUM(CASE WHEN maxf>1 THEN sales END)repeater_sales,
SUM(bills)Total_bills,SUM(CASE WHEN maxf>1 THEN bills END)repeater_bills
FROM(
SELECT mobile,txndate,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills,
MIN(frequencycount)minf,MAX(frequencycount)maxf  
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2024-01-01' AND '2024-09-30'
AND storecode NOT LIKE '%demo%' 
AND BillNo NOT LIKE '%test%' 
AND BillNo NOT LIKE '%roll%'
AND amount > 0
AND storecode IN (SELECT DISTINCT storecode FROM dummy.txn_l2l_storecode_24_25_social_club_harish)
GROUP BY 1,2
ORDER BY txndate)a GROUP BY 1 ORDER BY txndate;


SELECT CASE WHEN visit<=10 THEN visit ELSE '10+' END visit_tag,COUNT(DISTINCT mobile)customer,SUM(sales)sales 
FROM(
SELECT mobile,COUNT(DISTINCT txndate)visit,SUM(amount)sales 
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2025-01-01' AND '2025-09-30'
AND storecode NOT LIKE '%demo%' 
AND BillNo NOT LIKE '%test%' 
AND BillNo NOT LIKE '%roll%'
AND amount > 0
AND storecode IN (SELECT DISTINCT storecode FROM dummy.txn_l2l_storecode_24_25_social_club_harish)
GROUP BY 1)a
GROUP BY 1 ORDER BY visit;



SELECT 
CASE 
    WHEN atv>=0 AND atv <= 1000 THEN '<=1000'
    WHEN atv>1000 AND atv <= 1500 THEN '1000-1500'
    WHEN atv>1500 AND atv <= 2000 THEN '1500-2000'
    WHEN atv>2000 AND atv <= 2500 THEN '2000-2500'
    WHEN atv>2500 AND atv <= 3000 THEN '2500-3000'
    WHEN atv>3000 AND atv <= 4000 THEN '3000-4000'
    WHEN atv>4000 AND atv <= 5000 THEN '4000-5000'
    WHEN atv>5000 AND atv <= 7000 THEN '5000-7000'
    WHEN atv>7000 AND atv <= 10000 THEN '7000-10000'
    WHEN atv>10000 THEN '>10000'
END atv_band,
COUNT(DISTINCT mobile)customer,
SUM(sales)sales,SUM(bills)bills,
SUM(sales)/SUM(bills)atv,
SUM(sales)/COUNT(DISTINCT mobile)amv
FROM(
SELECT mobile,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills,
SUM(amount)/COUNT(DISTINCT uniquebillno)ATV 
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2025-01-01' AND '2025-09-30'
AND storecode NOT LIKE '%demo%' 
AND BillNo NOT LIKE '%test%' 
AND BillNo NOT LIKE '%roll%'
AND amount > 0
AND storecode IN (SELECT DISTINCT storecode FROM dummy.txn_l2l_storecode_24_25_social_club_harish)
GROUP BY 1)a 
GROUP BY 1
ORDER BY atv;


SELECT 
SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills,
SUM(amount)/COUNT(DISTINCT uniquebillno)ATV 
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2025-01-01' AND '2025-09-30'
AND storecode NOT LIKE '%demo%' 
AND BillNo NOT LIKE '%test%' 
AND BillNo NOT LIKE '%roll%'
AND amount > 0
AND storecode IN (SELECT DISTINCT storecode FROM dummy.txn_l2l_storecode_24_25_social_club_harish)



-- select sum(amount)/count(distinct uniquebillno) 
-- FROM txn_report_accrual_redemption 
-- WHERE 
-- -- txndate BETWEEN '2024-04-01' AND '2024-06-30'
-- -- AND 
-- storecode NOT LIKE '%demo%' 
-- AND BillNo NOT LIKE '%test%' 
-- AND BillNo NOT LIKE '%roll%'
-- AND amount > 0
-- AND storecode IN (SELECT DISTINCT storecode FROM dummy.txn_l2l_storecode_24_25_social_club_harish)

-- life cycle segment
SELECT DISTINCT mobile FROM member_report

INSERT INTO dummy.wowmomos_all_customers
SELECT  DISTINCT mobile FROM (
SELECT mobile FROM member_report WHERE modifiedenrolledon <='2025-09-30' 
UNION
SELECT  DISTINCT mobile
FROM txn_report_accrual_redemption 
    WHERE storecode NOT LIKE '%demo%' 
      AND BillNo NOT LIKE '%test%' 
      AND txndate <='2025-09-30'
      AND BillNo NOT LIKE '%roll%')a ;#14000481
      
      
      
      
DELETE FROM dummy.social_club_harish_25;

     
      
INSERT INTO dummy.social_club_harish_25
SELECT  DISTINCT mobile
FROM txn_report_accrual_redemption 
WHERE storecode NOT LIKE '%demo%' 
AND BillNo NOT LIKE '%test%' 
AND txndate <='2025-09-30'
AND storecode IN (SELECT DISTINCT storecode FROM dummy.txn_l2l_storecode_24_25_social_club_harish)
AND BillNo NOT LIKE '%roll%'; #1313634
           
 ALTER TABLE dummy.social_club_harish_25 ADD INDEX mobile(mobile),ADD COLUMN recency VARCHAR(200),ADD COLUMN visit VARCHAR(100);

-- LIFECYCLE BASED SEGMENTATION
 
UPDATE dummy.social_club_harish_25 a JOIN(
SELECT mobile,
        DATEDIFF('2025-09-30',MAX(txndate))recency,
        COUNT(DISTINCT txndate)visit  
    FROM txn_report_accrual_redemption 
    WHERE storecode NOT LIKE '%demo%' 
      AND BillNo NOT LIKE '%test%' 
      AND BillNo NOT LIKE '%roll%'
  
    GROUP BY 1)b USING(mobile)
SET a.recency=b.recency,a.visit=b.visit;  #1278143
    
        
    SELECT * FROM 
    dummy.wowomomo_LIFECYCLE_BASED_SEGMENTATION;
    
    ALTER TABLE 
    dummy.wowomomo_LIFECYCLE_BASED_SEGMENTATION ADD COLUMN vintage VARCHAR(20),ADD INDEX a(mobile);
 
-- insert into dummy.wowomomo_LIFECYCLE_BASED_SEGMENTATION (mobile)
-- SELECT mobile FROM member_report 
-- WHERE modifiedenrolledon<='2025-09-30' 
-- AND mobile NOT IN (SELECT DISTINCT mobile FROM txn_report_accrual_redemption WHERE txndate<='2025-09-30')
-- GROUP BY 1;#7462808
--  -- 
--     UPDATE 
--     dummy.wowomomo_LIFECYCLE_BASED_SEGMENTATION a JOIN vintage_base b
--     USING(mobile)
--     SET a.vintage=b.vintage;    
--     -- 
-- --     INSERT INTO 
-- --     dummy.wowomomo_LIFECYCLE_BASED_SEGMENTATION(mobile,vintage)
--      SELECT mobile,vintage FROM (
-- SELECT mobile,DATEDIFF('2025-09-30',modifiedenrolledon)vintage FROM member_report 
-- WHERE modifiedenrolledon<='2025-09-30' 
-- AND mobile NOT IN (SELECT DISTINCT mobile FROM txn_report_accrual_redemption WHERE txndate<='2025-09-30')
-- GROUP BY 1)a
-- WHERE vintage <=90
-- and EnrolledStore LIKE '%demo%'
-- AND EnrolledStore LIKE '%test%'
-- GROUP BY 1;#111150
 
UPDATE dummy.wowomomo_LIFECYCLE_BASED_SEGMENTATION
  
SELECT * FROM 
dummy.wowomomo_LIFECYCLE_BASED_SEGMENTATION;	
 
ALTER TABLE 
dummy.social_club_harish_25 ADD COLUMN Customer_Segment VARCHAR(20);
 
UPDATE 
dummy.social_club_harish_25
SET Customer_Segment=
CASE 
WHEN Recency <= 30 THEN  'New'
-- vintage <=90 AND  
WHEN recency <= 90 AND  visit <= 2 THEN 'Grow'
WHEN Recency <= 90 AND visit >= 3 THEN 'Stable'
WHEN Recency > 90 AND Recency<= 180 THEN 'Declining'
WHEN  Recency > 180 AND Recency<= 210 THEN 'Recently Lapsed'
WHEN  Recency > 210 AND Recency<= 240 THEN 'Lapsed'
WHEN  Recency > 240 THEN 'Long Lapsed' END ;#1278143
 
 
 UPDATE 
dummy.social_club_harish_25
SET Customer_Segment='ent'
WHERE customer_segment IS NULL;#7462808

 SELECT Customer_Segment,COUNT(DISTINCT mobile)customer FROM dummy.social_club_harish_25
 GROUP BY 1;
--  
-- UPDATE dummy.wowomomo_LIFECYCLE_BASED_SEGMENTATION
-- SET Customer_Segment =CASE 
--     WHEN vintage IS NOT NULL OR Recency <= 30 THEN 'New'
--     WHEN Recency <= 90 AND visit <= 2 THEN 'Grow'
--     WHEN Recency <= 90 AND visit >= 3 THEN 'Stable'
--     WHEN Recency > 90 AND Recency <= 180 THEN 'Declining'
--     WHEN Recency > 180 AND Recency <= 210 THEN 'Recently Lapsed'
--     WHEN Recency > 210 AND Recency <= 240 THEN 'Lapsed'
--     WHEN Recency > 240 THEN 'Long Lapsed'
-- END;#152936
--  
ALTER TABLE 
dummy.social_club_harish_25 ADD COLUMN Customer_Type VARCHAR(200);#14000481

SELECT * FROM dummy.social_club_harish_25

UPDATE dummy.social_club_harish_25
SET Customer_Type =
-- ='Lapsed' WHERE  Customer_Segment='Long Lapsed';
CASE 
    WHEN Customer_Segment IN ('New', 'Grow', 'Stable') THEN 'Active'
    WHEN Customer_Segment IN ('Declining') THEN 'Dormant'
    WHEN Customer_Segment IN ('Recently Lapsed', 'Lapsed','Long Lapsed') THEN 'Lapsed'
    WHEN Customer_Segment = 'ent' THEN 'Enrolled and not transcated'
END;1#1278143
 
 
SELECT Customer_Type,Customer_Segment,COUNT(mobile) FROM 
dummy.social_club_harish_25  
-- where EnrolledStore not  LIKE '%demo%'
GROUP BY 1,2
ORDER BY 1,2;#111150
 

 -- 
-- with base_data as
-- (select * from 
-- dummy.wowomomo_LIFECYCLE_BASED_SEGMENTATION where EnrolledStore  like '%demo%'
-- group by 1,2)
-- select Customer_Segment,Customer_Type,count(mobile) from base_data group by 1;
--  
--  
-- SELECT mobile,EnrolledStore FROM dummy.wowomomo_LIFECYCLE_BASED_SEGMENTATION 
--   a JOIN member_report b
-- USING(mobile)
-- WHERE Customer_Segment='New'
--  
-- ALTER TABLE dummy.wowomomo_LIFECYCLE_BASED_SEGMENTATION ADD COLUMN EnrolledStore VARCHAR(20);
--  
-- UPDATE dummy.wowomomo_LIFECYCLE_BASED_SEGMENTATION a JOIN member_report b
-- USING(mobile)
-- SET a.EnrolledStore=b.EnrolledStorecode
-- WHERE Customer_Segment='New';



SELECT COUNT(DISTINCT mobile)ENT FROM member_report 
WHERE mobile NOT IN (SELECT DISTINCT mobile FROM txn_report_accrual_redemption 
WHERE txndate <='2025-09-30')
AND modifiedenrolledon<='2025-09-30'
AND enrolledstorecode <> 'demo';



-- ONETIMERS DISTRIBUTION BASIS RECECNY AND ATV BAND
-- REPEATERS DISTRIBUTION BASIS RECECNY AND ATV BAND   
 
WITH base_data AS
(SELECT 
        mobile,
        MAX(frequencycount) AS max_f,
        MIN(frequencycount) AS min_f,
        SUM(amount),
        COUNT(DISTINCT uniquebillno)bills,
        SUM(amount)/COUNT(DISTINCT uniquebillno) atv,
        DATEDIFF('2025-09-30',MAX(txndate))Recency  
    FROM txn_report_accrual_redemption 
    WHERE storecode NOT LIKE '%demo%' 
      AND BillNo NOT LIKE '%test%' 
      AND BillNo NOT LIKE '%roll%'
      AND storecode IN (SELECT DISTINCT storecode FROM dummy.txn_l2l_storecode_24_25_social_club_harish)
      AND txndate <='2025-09-30'
    GROUP BY mobile)
SELECT 
CASE 
    WHEN atv>=0 AND atv <= 1000 THEN '<=1000'
    WHEN atv>1000 AND atv <= 1500 THEN '1000-1500'
    WHEN atv>1500 AND atv <= 2000 THEN '1500-2000'
    WHEN atv>2000 AND atv <= 2500 THEN '2000-2500'
    WHEN atv>2500 AND atv <= 3000 THEN '2500-3000'
    WHEN atv>3000 AND atv <= 4000 THEN '3000-4000'
    WHEN atv>4000 AND atv <= 5000 THEN '4000-5000'
    WHEN atv>5000 AND atv <= 7000 THEN '5000-7000'
    WHEN atv>7000 AND atv <= 10000 THEN '7000-10000'
    WHEN atv>10000 THEN '>10000'
END atv_band,
CASE  
    WHEN Recency<0   THEN '<0'
    WHEN Recency BETWEEN 0 AND 30 THEN '0-30'
    WHEN Recency BETWEEN 31 AND 90 THEN '31-90'
    WHEN Recency BETWEEN 91 AND 180 THEN '91-180'
    WHEN Recency BETWEEN 181 AND 365 THEN '181-365'
    WHEN Recency > 365 THEN '365+'
END AS Recency_tag,
CASE WHEN max_f = 1 THEN '0NETIMERS'
WHEN max_f > 1 THEN 'REPEATERS' END customer_tag,
COUNT(mobile) 
FROM base_data GROUP BY 1,2,3
ORDER BY 1,2,3;


SELECT * FROM member_report;


SELECT * FROM `tier_detail_report`


SELECT * FROM program_single_view;


SELECT COUNT(DISTINCT mobile) FROM (
SELECT  mobile,MAX(frequencycount)maxf FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2024-09-01' AND '2024-09-30' 
AND storecode <> 'demo' AND BillNo NOT LIKE '%test%' 
      AND BillNo NOT LIKE '%roll%'
      GROUP BY 1
) a WHERE maxf=1