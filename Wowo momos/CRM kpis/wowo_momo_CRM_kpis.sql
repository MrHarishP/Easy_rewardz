-- for snapshort L2L
CREATE TABLE dummy.txn_l2l_storecode_24_25 
WITH base_25 AS (
SELECT DISTINCT storecode FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2025-01-01' AND '2025-09-30'
AND storecode NOT LIKE '%demo%' 
AND BillNo NOT LIKE '%test%' 
AND BillNo NOT LIKE '%roll%'
AND amount > 0 ),

base_24 AS (
SELECT DISTINCT storecode FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2024-01-01' AND '2024-09-30'
AND storecode NOT LIKE '%demo%' 
AND BillNo NOT LIKE '%test%' 
AND BillNo NOT LIKE '%roll%'
AND amount > 0 )

SELECT DISTINCT storecode FROM base_24 a JOIN base_25 b USING(storecode)#655

SELECT * FROM member_report LIMIT 10

CREATE TABLE dummy.txn_l2l_enrolledstorecode_24_25 
WITH base_25 AS (
SELECT DISTINCT enrolledstorecode FROM member_report 
WHERE modifiedenrolledon BETWEEN '2025-01-01' AND '2025-09-30'
AND EnrolledStorecode NOT  LIKE '%demo%'
 AND EnrolledStorecode NOT  LIKE '%test%'),

base_24 AS (
SELECT DISTINCT enrolledstorecode FROM member_report 
WHERE modifiedenrolledon BETWEEN '2024-01-01' AND '2024-09-30'
AND EnrolledStorecode NOT  LIKE '%demo%'
 AND EnrolledStorecode NOT  LIKE '%test%')

SELECT DISTINCT enrolledstorecode FROM base_24 a JOIN base_25 b USING(enrolledstorecode)#638


CREATE TABLE dummy.txn_l2l_enrolledstorecode_24_25 
WITH base_25 AS (
SELECT DISTINCT enrolledstorecode FROM member_report 
WHERE modifiedenrolledon BETWEEN '2025-01-01' AND '2025-09-30'
AND EnrolledStorecode NOT  LIKE '%demo%'
 AND EnrolledStorecode NOT  LIKE '%test%'),

base_24 AS (
SELECT DISTINCT enrolledstorecode FROM member_report 
WHERE modifiedenrolledon BETWEEN '2024-01-01' AND '2024-09-30'
AND EnrolledStorecode NOT  LIKE '%demo%'
 AND EnrolledStorecode NOT  LIKE '%test%')

SELECT DISTINCT enrolledstorecode FROM base_24 a JOIN base_25 b USING(enrolledstorecode)#638

CREATE TABLE dummy.sku_non_loyalty_l2l
WITH base_24 AS (
SELECT DISTINCT modifiedstorecode FROM sku_report_nonloyalty 
WHERE modifiedtxndate BETWEEN'2024-01-01' AND '2024-09-30'
AND itemnetamount>0),
base_25 AS (
SELECT DISTINCT modifiedstorecode FROM sku_report_nonloyalty 
WHERE modifiedtxndate BETWEEN'2025-01-01' AND '2025-09-30'
AND itemnetamount>0)

SELECT DISTINCT modifiedstorecode FROM base_24 a JOIN  base_25 b USING(modifiedstorecode);#649



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
 AND enrolledstorecode IN (SELECT DISTINCT enrolledstorecode FROM dummy.txn_l2l_enrolledstorecode_24_25)
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
WHEN txndate BETWEEN '2025-01-01' AND '2025-03-31' THEN '2025-01-01 AND 2025-03-31'
WHEN txndate BETWEEN '2025-04-01' AND '2025-06-30' THEN '2025-04-01 AND 2025-06-30'
WHEN txndate BETWEEN '2025-07-01' AND '2025-09-30' THEN '2025-07-01 AND 2025-09-30' 
END PERIOD,
mobile,
SUM(amount) AS sales,
COUNT(DISTINCT UniqueBillNo) AS bills,
MAX(FrequencyCount) AS maxf,
MIN(FrequencyCount) AS minf,
COUNT(DISTINCT txndate) AS visit
-- datediff(max(txndate),min(txndate))/nullif((count(distinct txndate),-1),0)latency
FROM txn_report_accrual_redemption 
WHERE ((txndate  BETWEEN '2025-01-01' AND '2025-03-31') 
OR (txndate BETWEEN '2025-04-01' AND '2025-06-30')
OR (txndate BETWEEN '2025-07-01' AND '2025-09-30'))
AND storecode NOT LIKE '%demo%' 
AND BillNo NOT LIKE '%test%' 
AND BillNo NOT LIKE '%roll%'
AND storecode IN (SELECT DISTINCT storecode FROM dummy.txn_l2l_storecode_24_25 )
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
WHEN txndate BETWEEN '2025-01-01' AND '2025-03-31' THEN '2025-01-01 AND 2025-03-31'
WHEN txndate BETWEEN '2025-04-01' AND '2025-06-30' THEN '2025-04-01 AND 2025-06-30'
WHEN txndate BETWEEN '2025-07-01' AND '2025-09-30' THEN '2025-07-01 AND 2025-09-30' 
END PERIOD,
mobile,DATEDIFF(MAX(txndate),MIN(txndate))/NULLIF((COUNT(DISTINCT txndate)-1),0)latency 
FROM txn_report_accrual_redemption
WHERE ((txndate  BETWEEN '2025-01-01' AND '2025-03-31') 
OR (txndate BETWEEN '2025-04-01' AND '2025-06-30')
OR (txndate BETWEEN '2025-07-01' AND '2025-09-30'))
AND storecode NOT LIKE '%demo%' 
AND BillNo NOT LIKE '%test%' 
AND BillNo NOT LIKE '%roll%'
AND storecode IN (SELECT DISTINCT storecode FROM dummy.txn_l2l_storecode_24_25 )
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
WHEN txndate BETWEEN '2025-01-01' AND '2025-03-31' THEN '2025-01-01 AND 2025-03-31'
WHEN txndate BETWEEN '2025-04-01' AND '2025-06-30' THEN '2025-04-01 AND 2025-06-30'
WHEN txndate BETWEEN '2025-07-01' AND '2025-09-30' THEN '2025-07-01 AND 2025-09-30' 
END PERIOD,
SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills FROM txn_report_accrual_redemption 
WHERE ((txndate  BETWEEN '2025-01-01' AND '2025-03-31') 
OR (txndate BETWEEN '2025-04-01' AND '2025-06-30')
OR (txndate BETWEEN '2025-07-01' AND '2025-09-30'))
AND storecode NOT LIKE '%demo%' 
AND BillNo NOT LIKE '%test%' 
AND BillNo NOT LIKE '%roll%'
AND storecode IN (SELECT DISTINCT storecode FROM dummy.txn_l2l_storecode_24_25 )
AND amount > 0 
GROUP BY 1
UNION
SELECT 
CASE 
WHEN modifiedtxndate BETWEEN '2025-01-01' AND '2025-03-31' THEN '2025-01-01 AND 2025-03-31'
WHEN modifiedtxndate BETWEEN '2025-04-01' AND '2025-06-30' THEN '2025-04-01 AND 2025-06-30'
WHEN modifiedtxndate BETWEEN '2025-07-01' AND '2025-09-30' THEN '2025-07-01 AND 2025-09-30' 
END PERIOD,
SUM(itemnetamount)sales,COUNT(DISTINCT UniqueBillNo)bills
FROM sku_report_nonloyalty 
WHERE ((modifiedtxndate BETWEEN '2025-01-01' AND '2025-03-31')
OR (modifiedtxndate BETWEEN '2025-04-01' AND '2025-06-30')
OR (modifiedtxndate BETWEEN'2025-07-01' AND '2025-09-30'))
AND itemnetamount>0
AND modifiedstorecode IN (SELECT DISTINCT modifiedstorecode FROM dummy.sku_non_loyalty_l2l )
GROUP BY 1)a GROUP BY 1;


SELECT 
CASE 
WHEN modifiedtxndate BETWEEN '2025-01-01' AND '2025-03-31' THEN '2025-01-01 AND 2025-03-31'
WHEN modifiedtxndate BETWEEN '2025-04-01' AND '2025-06-30' THEN '2025-04-01 AND 2025-06-30'
WHEN modifiedtxndate BETWEEN '2025-07-01' AND '2025-09-30' THEN '2025-07-01 AND 2025-09-30' 
END PERIOD,
SUM(itemnetamount)nonloyaltysales,COUNT(DISTINCT UniqueBillNo)nonloyaltbills
FROM sku_report_nonloyalty 
WHERE ((modifiedtxndate BETWEEN '2025-01-01' AND '2025-03-31')
OR (modifiedtxndate BETWEEN '2025-04-01' AND '2025-06-30')
OR (modifiedtxndate BETWEEN'2025-07-01' AND '2025-09-30'))
AND itemnetamount>0
AND modifiedstorecode IN (SELECT DISTINCT modifiedstorecode FROM dummy.sku_non_loyalty_l2l )
GROUP BY 1;


SELECT 
CASE 
WHEN txndate BETWEEN '2025-01-01' AND '2025-03-31' THEN '2025-01-01 AND 2025-03-31'
WHEN txndate BETWEEN '2025-04-01' AND '2025-06-30' THEN '2025-04-01 AND 2025-06-30'
WHEN txndate BETWEEN '2025-07-01' AND '2025-09-30' THEN '2025-07-01 AND 2025-09-30' 
END PERIOD,
SUM(amount)loyaltsales,COUNT(DISTINCT uniquebillno)loyaltbills FROM txn_report_accrual_redemption 
WHERE ((txndate  BETWEEN '2025-01-01' AND '2025-03-31') 
OR (txndate BETWEEN '2025-04-01' AND '2025-06-30')
OR (txndate BETWEEN '2025-07-01' AND '2025-09-30'))
AND storecode NOT LIKE '%demo%' 
AND BillNo NOT LIKE '%test%' 
AND BillNo NOT LIKE '%roll%'
AND storecode IN (SELECT DISTINCT storecode FROM dummy.txn_l2l_storecode_24_25 )
AND amount > 0 
GROUP BY 1;

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
GROUP BY 1,2)a GROUP BY 1;


SELECT CASE WHEN visit<=10 THEN visit ELSE '10+' END visit_tag,COUNT(DISTINCT mobile)customer,SUM(sales)sales 
FROM(
SELECT mobile,COUNT(DISTINCT txndate)visit,SUM(amount)sales 
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2024-07-01' AND '2024-09-30'
AND storecode NOT LIKE '%demo%' 
AND BillNo NOT LIKE '%test%' 
AND BillNo NOT LIKE '%roll%'
AND amount > 0
GROUP BY 1)a
GROUP BY 1 ORDER BY visit;



SELECT 
CASE 
WHEN atv>0 AND atv<=100 THEN '<100'
WHEN atv>100 AND atv<=150 THEN '100-150'
WHEN atv>150 AND atv<=200 THEN '150-200'
WHEN atv>200 AND atv<=250 THEN '200-250'
WHEN atv>250 AND atv<=300 THEN '250-300'
WHEN atv>300 AND atv<=350 THEN '300-350'
WHEN atv>350 AND atv<=400 THEN '350-400'
WHEN atv>400 AND atv<=450 THEN '400-450'
WHEN atv>450 AND atv<=500 THEN '450-500'
WHEN atv>500 AND atv<=700 THEN '500-700'
WHEN atv>700 THEN '700+' END atv_band,COUNT(DISTINCT mobile)customer,
SUM(sales)sales,SUM(bills)bills,
SUM(sales)/SUM(bills)atv,
SUM(sales)/COUNT(DISTINCT mobile)amv
FROM(
SELECT mobile,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills,
SUM(amount)/COUNT(DISTINCT uniquebillno)ATV 
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2024-07-01' AND '2024-09-30'
AND storecode NOT LIKE '%demo%' 
AND BillNo NOT LIKE '%test%' 
AND BillNo NOT LIKE '%roll%'
AND amount > 0
GROUP BY 1)a 
GROUP BY 1
ORDER BY atv;



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
      
 ALTER TABLE dummy.wowmomos_all_customers ADD INDEX mobile(mobile),ADD COLUMN recency VARCHAR(200),ADD COLUMN visit VARCHAR(100);

-- LIFECYCLE BASED SEGMENTATION
 
UPDATE dummy.wowmomos_all_customers a JOIN(
SELECT mobile,
        DATEDIFF('2025-09-30',MAX(txndate))recency,
        COUNT(DISTINCT txndate)visit  
    FROM txn_report_accrual_redemption 
    WHERE storecode NOT LIKE '%demo%' 
      AND BillNo NOT LIKE '%test%' 
      AND BillNo NOT LIKE '%roll%'
  
    GROUP BY 1)b USING(mobile)
SET a.recency=b.recency,a.visit=b.visit;  #6537673
    
        
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
dummy.wowmomos_all_customers ADD COLUMN Customer_Segment VARCHAR(20);
 
UPDATE 
dummy.wowmomos_all_customers
SET Customer_Segment=
CASE 
WHEN Recency <= 30 THEN  'New'
-- vintage <=90 AND  
WHEN recency <= 90 AND  visit <= 2 THEN 'Grow'
WHEN Recency <= 90 AND visit >= 3 THEN 'Stable'
WHEN Recency > 90 AND Recency<= 180 THEN 'Declining'
WHEN  Recency > 180 AND Recency<= 210 THEN 'Recently Lapsed'
WHEN  Recency > 210 AND Recency<= 240 THEN 'Lapsed'
WHEN  Recency > 240 THEN 'Long Lapsed' END ;#6500891
 
 
 UPDATE 
dummy.wowmomos_all_customers
SET Customer_Segment='ent'
WHERE customer_segment IS NULL;#7462808

 SELECT Customer_Segment,COUNT(DISTINCT mobile)customer FROM dummy.wowomomo_LIFECYCLE_BASED_SEGMENTATION
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
dummy.wowmomos_all_customers MODIFY COLUMN Customer_Type VARCHAR(200);#14000481

UPDATE dummy.wowmomos_all_customers
SET Customer_Type =
-- ='Lapsed' WHERE  Customer_Segment='Long Lapsed';
CASE 
    WHEN Customer_Segment IN ('New', 'Grow', 'Stable') THEN 'Active'
    WHEN Customer_Segment IN ('Declining') THEN 'Dormant'
    WHEN Customer_Segment IN ('Recently Lapsed', 'Lapsed','Long Lapsed') THEN 'Lapsed'
    WHEN Customer_Segment = 'ent' THEN 'Enrolled and not transcated'
END;1#4000481
 
 
SELECT Customer_Type,Customer_Segment,COUNT(mobile) FROM 
dummy.wowmomos_all_customers  
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
    GROUP BY mobile)
SELECT 
CASE 
WHEN atv>0 AND atv<=100 THEN '<100'
WHEN atv>100 AND atv<=150 THEN '100-150'
WHEN atv>150 AND atv<=200 THEN '150-200'
WHEN atv>200 AND atv<=250 THEN '200-250'
WHEN atv>250 AND atv<=300 THEN '250-300'
WHEN atv>300 AND atv<=350 THEN '300-350'
WHEN atv>350 AND atv<=400 THEN '350-400'
WHEN atv>400 AND atv<=450 THEN '400-450'
WHEN atv>450 AND atv<=500 THEN '450-500'
WHEN atv>500 AND atv<=700 THEN '500-700'
WHEN atv>700 THEN '700+' END atv_band,
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





FIRST CREATE TABLE THEN INSERT DATA INTO that TABLE

CREATE TABLE dummy.storecode (
storecode VARCHAR(200))


LOAD DATA LOCAL INFILE "D:\\OneDrive - EasyRewardz Software Services Private Limited\\North\\Wowo momos\\storecode.csv"
INTO TABLE  dummy.storecode
CHARACTER SET 'latin1'
FIELDS ESCAPED BY '\\' 
TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES;#101

SELECT * FROM program_single_view;


CREATE TABLE
SELECT mobile,
MAX(frequencycount) AS max_f,
MIN(frequencycount) AS min_f,
SUM(amount)sales,
COUNT(DISTINCT uniquebillno)bills,
SUM(amount)/COUNT(DISTINCT uniquebillno) atv,
DATEDIFF('2025-09-30',MAX(txndate))Recency 
FROM txn_report_accrual_redemption a 
WHERE storecode IN (SELECT DISTINCT storecode FROM program_single_view 
WHERE `last shopped store` IN (SELECT DISTINCT storecode FROM dummy.storecode) 
)
GROUP BY 1;
SELECT * FROM dummy.customer_base_till_sept_25

INSERT INTO dummy.customer_base_till_sept_25
SELECT storecode,mobile,
MAX(frequencycount) AS max_f,
MIN(frequencycount) AS min_f,
SUM(amount) AS sales,
COUNT(DISTINCT uniquebillno) AS bills,
SUM(amount)/COUNT(DISTINCT uniquebillno) AS atv,
DATEDIFF('2025-09-30',MAX(txndate)) AS Recency 
FROM txn_report_accrual_redemption a 
WHERE txndate <='2025-09-30'
AND storecode IN (
    SELECT DISTINCT storecode 
--     COLLATE utf8mb4_unicode_ci 
    FROM program_single_view 
    WHERE `last shopped store` COLLATE utf8mb4_unicode_ci 
          IN (SELECT DISTINCT storecode COLLATE utf8mb4_unicode_ci 
              FROM dummy.storecode)
) 
GROUP BY 1,2 LIMIT 100;




INSERT INTO dummy.customer_base_till_sept_25
SELECT 
    a.storecode,
    a.mobile,
    MAX(a.frequencycount) AS max_f,
    MIN(a.frequencycount) AS min_f,
    SUM(a.amount) AS sales,
    COUNT(DISTINCT a.uniquebillno) AS bills,
    ROUND(SUM(a.amount) / COUNT(DISTINCT a.uniquebillno), 2) AS atv,
    DATEDIFF('2025-09-30', MAX(a.txndate)) AS Recency
FROM txn_report_accrual_redemption a
JOIN (
    SELECT DISTINCT p.`last shopped store`
    FROM program_single_view p
    JOIN dummy.storecode d 
      ON p.`last shopped store` COLLATE utf8mb4_unicode_ci = d.storecode 
) s ON a.storecode = s.`last shopped store`
WHERE a.txndate <= '2025-09-30'
GROUP BY a.mobile;


        INSERT INTO dummy.customer_base_till_sept_25 (
    storecode, 
    mobile, 
    max_f, 
    min_f, 
    sales, 
    bills, 
    atv, 
    Recency
)
SELECT 
    a.storecode,
    a.mobile,
    MAX(a.frequencycount) AS max_f,
    MIN(a.frequencycount) AS min_f,
    SUM(a.amount) AS sales,
    COUNT(DISTINCT a.uniquebillno) AS bills,
    ROUND(SUM(a.amount) / COUNT(DISTINCT a.uniquebillno), 2) AS atv,
    DATEDIFF('2025-09-30', MAX(a.txndate)) AS Recency
FROM txn_report_accrual_redemption a
JOIN (
    SELECT DISTINCT p.`last shopped store` COLLATE utf8mb4_unicode_ci AS storecode
    FROM program_single_view p
    JOIN dummy.storecode d 
      ON p.`last shopped store` COLLATE utf8mb4_unicode_ci = d.storecode COLLATE utf8mb4_unicode_ci
) s ON a.storecode COLLATE utf8mb4_unicode_ci = s.storecode
WHERE a.txndate <= '2025-09-30'
GROUP BY a.mobile,a.storecode;#146759


ALTER TABLE dummy.customer_base_till_sept_25 ADD INDEX mobile(mobile),ADD COLUMN customer_type VARCHAR(200);

UPDATE dummy.customer_base_till_sept_25 a JOIN(
SELECT 
    a.mobile,
    MAX(a.frequencycount) AS max_f,
    MIN(a.frequencycount) AS min_f,
    SUM(a.amount) AS sales,
    COUNT(DISTINCT a.uniquebillno) AS bills,
    ROUND(SUM(a.amount) / COUNT(DISTINCT a.uniquebillno), 2) AS atv,
    DATEDIFF('2025-09-30', MAX(a.txndate)) AS Recency
FROM txn_report_accrual_redemption a
WHERE txndate <='2025-09-30'
GROUP BY 1)b USING(mobile)
SET a.max_f=b.min_f,a.sales=b.sales,a.bills=b.bills,a.atv=b.atv,a.Recency=b.Recency;#142703

SELECT * FROM dummy.customer_base_till_sept_25;


WITH base AS (
SELECT mobile,
MAX(frequencycount) AS max_f,
MIN(frequencycount) AS min_f,
DATEDIFF('2025-09-30', MAX(a.txndate)) AS Recency
FROM txn_report_accrual_redemption a
WHERE txndate <='2025-09-30'
GROUP BY 1),
mobile AS (
SELECT mobile,storecode,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills  
FROM txn_report_accrual_redemption a
WHERE txndate <='2025-09-30'
GROUP BY 1,2)

SELECT storecode,
CASE 
WHEN a.recency>0 AND a.recency<=15  AND max_f=1 THEN '0-15'
WHEN a.recency>15 AND a.recency<=30  AND max_f=1 THEN '15-30'
WHEN a.recency>30 AND a.recency<=60  AND max_f=1 THEN '30-60'
WHEN a.recency>60 AND max_f=1 THEN '>60' END AS onetimer_rececy,
CASE 
WHEN a.recency>0 AND a.recency<=15  AND max_f>1 THEN '0-15'
WHEN a.recency>15 AND a.recency<=30  AND max_f>1 THEN '15-30'
WHEN a.recency>30 AND a.recency<=60  AND max_f>1 THEN '30-60'
WHEN a.recency>60 AND max_f=1 THEN '>60' END AS repeater_rececy,

COUNT(DISTINCT CASE WHEN max_f=1 THEN a.mobile END)onetimer,
COUNT(DISTINCT CASE WHEN max_f>1 THEN a.mobile ELSE 'null' END)repeater,
SUM(CASE WHEN max_f=1 THEN sales END)onetimer_sales,
SUM(CASE WHEN max_f>1 THEN sales ELSE 'null' END)repeater_sales,
SUM(CASE WHEN max_f=1 THEN bills END)onetimer_bills,
SUM(CASE WHEN max_f>1 THEN bills ELSE 'null' END)repeater_bills
FROM base a JOIN mobile b USING(mobile)
JOIN program_single_view c ON a.mobile=c.mobile 
WHERE `last shopped store` COLLATE utf8mb4_unicode_ci IN (
SELECT storecode FROM dummy.storecode d )
GROUP BY 1,2,3;


SHOW PROCESSLIST;


SELECT 328/60;


FROM program_single_view c 
    WHERE  last_shopped_store IN (
    'JAI001','MUM109','MUM107','PUN032','PUN033','BAN111','DEL158','BAN112','CHE110',
    'BAN110','PUB005','HYD059','ODI036','ASM009','NAG002','KOL286','KER017','KOT002',
    'KOL287','KOL267','KOL279','GUJ016','MDP019','BAN117','DEL161','DEL162','KOL290',
    'HYD058','KER019','HYD061','AGR003','HUB001','JAI005','KER020','DEL160','AGR001',
    'AMR001','PUN037','HYD060','DEL163','BAN116','AGR002','KOL291','PUB006','MUM111',
    'BAN119','ASM011','BAN118','ASM012','ASM010','DEL168','PUN036','DEL166','KOL278',
    'PUN038','DEL165','AMR002','DEL169','HYD062','KOL292','JAM001','PUB007','MUM112',
    'JAI006','VIS002','DEL167','VIJ002','KOL288','CHE111','KOL293','DEL170','KOL295',
    'HYD065','DIM001','VIJ003','KER023','KER021','DEL173','HUB002','GAN001','GAN002',
    'KOL297','DEL171','HYD057','COI009','JAI007','DEL176','HYD067','AMR003','PUN040',
    'KOL296','JAM002','BIH014','JAL009','BIH013','AMR004','DEL179','GOA017','BAR001',
    'HYD068','COI010'
) 
AND `last shopped date`<=  '2025-09-30'
GROUP BY 1;



#####################################
-- ________________________use this query for segemnet data which is for specific storecode_____________________ 
WITH TABLE1 AS
(SELECT
Mobile,
`last shopped store`,
Recency,
`Total Visits`,
1_year_sales,
1_year_bills
FROM program_single_view
WHERE `last shopped store` IN ('JAI001','MUM109','MUM107','PUN032','PUN033','BAN111','DEL158','BAN112','CHE110',
    'BAN110','PUB005','HYD059','ODI036','ASM009','NAG002','KOL286','KER017','KOT002',
    'KOL287','KOL267','KOL279','GUJ016','MDP019','BAN117','DEL161','DEL162','KOL290',
    'HYD058','KER019','HYD061','AGR003','HUB001','JAI005','KER020','DEL160','AGR001',
    'AMR001','PUN037','HYD060','DEL163','BAN116','AGR002','KOL291','PUB006','MUM111',
    'BAN119','ASM011','BAN118','ASM012','ASM010','DEL168','PUN036','DEL166','KOL278',
    'PUN038','DEL165','AMR002','DEL169','HYD062','KOL292','JAM001','PUB007','MUM112',
    'JAI006','VIS002','DEL167','VIJ002','KOL288','CHE111','KOL293','DEL170','KOL295',
    'HYD065','DIM001','VIJ003','KER023','KER021','DEL173','HUB002','GAN001','GAN002',
    'KOL297','DEL171','HYD057','COI009','JAI007','DEL176','HYD067','AMR003','PUN040',
    'KOL296','JAM002','BIH014','JAL009','BIH013','AMR004','DEL179','GOA017','BAR001',
    'HYD068','COI010')
)

SELECT `last shopped store`,
CASE
WHEN recency>0 AND recency<=90 THEN '0-90'
WHEN recency>90 AND recency<=180 THEN '90-180' 
WHEN recency>240 AND recency<=270 THEN '180-270'
WHEN recency>270 AND recency<=360 THEN '270-360'
WHEN recency>360 THEN '>360' END recency,
CASE WHEN `Total Visits` = 1 THEN 'ONETIMER' ELSE 'REPEAER' END AS customer_type,
COUNT(DISTINCT mobile) AS cusotmer_count, 
SUM(1_year_sales) AS 1_year_sales,
SUM(1_year_bills) AS 1_year_bills
FROM TABLE1
GROUP BY 1,2,3
;




################

SELECT
Mobile,`last shopped date`,
`last shopped store`,
Recency,
`Total Visits`,
1_year_sales,
1_year_bills
FROM program_single_view a 
WHERE `last shopped store` IN ('JAI001','MUM109','MUM107','PUN032','PUN033','BAN111','DEL158','BAN112','CHE110',
    'BAN110','PUB005','HYD059','ODI036','ASM009','NAG002','KOL286','KER017','KOT002',
    'KOL287','KOL267','KOL279','GUJ016','MDP019','BAN117','DEL161','DEL162','KOL290',
    'HYD058','KER019','HYD061','AGR003','HUB001','JAI005','KER020','DEL160','AGR001',
    'AMR001','PUN037','HYD060','DEL163','BAN116','AGR002','KOL291','PUB006','MUM111',
    'BAN119','ASM011','BAN118','ASM012','ASM010','DEL168','PUN036','DEL166','KOL278',
    'PUN038','DEL165','AMR002','DEL169','HYD062','KOL292','JAM001','PUB007','MUM112',
    'JAI006','VIS002','DEL167','VIJ002','KOL288','CHE111','KOL293','DEL170','KOL295',
    'HYD065','DIM001','VIJ003','KER023','KER021','DEL173','HUB002','GAN001','GAN002',
    'KOL297','DEL171','HYD057','COI009','JAI007','DEL176','HYD067','AMR003','PUN040',
    'KOL296','JAM002','BIH014','JAL009','BIH013','AMR004','DEL179','GOA017','BAR001',
    'HYD068','COI010');
    
   #####################################
-- ________________________use this query for segemnet data which is for specific storecode_____________________end_________  
    
    SELECT mobile, MAX(txndate)max_date FROM txn_report_accrual_redemption
    WHERE mobile IN (
'6001569917',
'6001978939',
'6003533965',
'6009170725',
'6239456321',
'6261166895',
'6263243104',
'6283637316',
'6289641021',
'6000915855',
'6001447161',
'6001508316',
'6001599534',
'6003354401',
'6005215213',
'6009172870',
'6200714414',
'6235877665',
'6239844332',
'6241578935',
'6280032349',
'6280157652',
'6283850977',
'6002336517',
'6003095805',
'6003672956',
'6006548792',
'6026874984',
'6162346454',
'6200693496',
'6230113651',
'6238950323',
'6281476354',
'6290251318',
'6000029621',
'6000259013',
'6000644854',
'6001662179',
'6001896909',
'6002501765',
'6002761508',
'6003011085',
'6003184985',
'6205355117',
'6281070696',
'6289319824',
'6001952043',
'6002165324',
'6205190608',
'6239132820',
'6246542462',
'6254789132',
'6259835469',
'6280535566',
'6280549963',
'6281732509',
'6281817585',
'6283676672',
'6289846501',
'6290062143',
'6290070415',
'6290101622',
'6294530380',
'6302578941',
'6304037571',
'6306321548',
'6309420338',
'6321564541',
'6321930000',
'6357562232',
'6367152151',
'6291743412',
'6292146519',
'6294019470',
'6296009369',
'6296221039',
'6301155311',
'6346783457',
'6352454857',
'6363792876',
'6365216545',
'6378068487',
'6378585355',
'6290776121',
'6291423455',
'6291618708',
'6294554855',
'6296038589',
'6297481792',
'6303165707',
'6304043053',
'6305433911',
'6306746400',
'6314445454',
'6341528963',
'6366204614',
'6367791599',
'6374748563',
'6378945333',
'6379115572',
'6382252205',
'6395662988'
)GROUP BY 1;


SELECT * FROM txn_report_accrual_redemption
WHERE mobile ='9711003030'


###################

SELECT `last shopped store`,
COUNT(DISTINCT CASE WHEN `total visits` = 1 THEN mobile END )onetimer,
COUNT(DISTINCT CASE WHEN `total visits` > 1 THEN mobile END )repeater,
SUM(CASE WHEN `total visits` = 1 THEN `Total spends`END )onetimer_sales,
SUM(CASE WHEN `total visits` > 1 THEN `Total spends`END )repeater_sales,
SUM(CASE WHEN `total visits` = 1 THEN `total transactions`END )onetimer_bills,
SUM(CASE WHEN `total visits` > 1 THEN `total transactions`END )repeater_bills
FROM program_single_view c 
    WHERE  c.`last shopped store` IN (
    'JAI001','MUM109','MUM107','PUN032','PUN033','BAN111','DEL158','BAN112','CHE110',
    'BAN110','PUB005','HYD059','ODI036','ASM009','NAG002','KOL286','KER017','KOT002',
    'KOL287','KOL267','KOL279','GUJ016','MDP019','BAN117','DEL161','DEL162','KOL290',
    'HYD058','KER019','HYD061','AGR003','HUB001','JAI005','KER020','DEL160','AGR001',
    'AMR001','PUN037','HYD060','DEL163','BAN116','AGR002','KOL291','PUB006','MUM111',
    'BAN119','ASM011','BAN118','ASM012','ASM010','DEL168','PUN036','DEL166','KOL278',
    'PUN038','DEL165','AMR002','DEL169','HYD062','KOL292','JAM001','PUB007','MUM112',
    'JAI006','VIS002','DEL167','VIJ002','KOL288','CHE111','KOL293','DEL170','KOL295',
    'HYD065','DIM001','VIJ003','KER023','KER021','DEL173','HUB002','GAN001','GAN002',
    'KOL297','DEL171','HYD057','COI009','JAI007','DEL176','HYD067','AMR003','PUN040',
    'KOL296','JAM002','BIH014','JAL009','BIH013','AMR004','DEL179','GOA017','BAR001',
    'HYD068','COI010'
)GROUP BY 1;#228403

SELECT * FROM program_single_view


SELECT `last shopped store`,
CASE
WHEN recency>0 AND recency<=15 THEN '0-15'
WHEN recency>15 AND recency<=30 THEN '15-30' 
WHEN recency>30 AND recency<=60 THEN '30-60'
WHEN recency>60 THEN '>60' END recency,COUNT(DISTINCT mobile)
FROM program_single_view c 
    WHERE  c.`last shopped store` IN (
    'JAI001','MUM109','MUM107','PUN032','PUN033','BAN111','DEL158','BAN112','CHE110',
    'BAN110','PUB005','HYD059','ODI036','ASM009','NAG002','KOL286','KER017','KOT002',
    'KOL287','KOL267','KOL279','GUJ016','MDP019','BAN117','DEL161','DEL162','KOL290',
    'HYD058','KER019','HYD061','AGR003','HUB001','JAI005','KER020','DEL160','AGR001',
    'AMR001','PUN037','HYD060','DEL163','BAN116','AGR002','KOL291','PUB006','MUM111',
    'BAN119','ASM011','BAN118','ASM012','ASM010','DEL168','PUN036','DEL166','KOL278',
    'PUN038','DEL165','AMR002','DEL169','HYD062','KOL292','JAM001','PUB007','MUM112',
    'JAI006','VIS002','DEL167','VIJ002','KOL288','CHE111','KOL293','DEL170','KOL295',
    'HYD065','DIM001','VIJ003','KER023','KER021','DEL173','HUB002','GAN001','GAN002',
    'KOL297','DEL171','HYD057','COI009','JAI007','DEL176','HYD067','AMR003','PUN040',
    'KOL296','JAM002','BIH014','JAL009','BIH013','AMR004','DEL179','GOA017','BAR001',
    'HYD068','COI010'
)
AND `total visits` >1
GROUP BY 1;#228403





SELECT storecode,
COUNT(DISTINCT CASE WHEN frequencycount=1 THEN mobile END)onetimer,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN mobile END)repeater,
SUM(CASE WHEN frequencycount=1 THEN amount END)onetimer_sales,
SUM(CASE WHEN frequencycount>1 THEN amount END)repeater_sales,
COUNT(DISTINCT CASE WHEN frequencycount=1 THEN uniquebillno END)onetimer_bills,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN uniquebillno END)repeater_bills
FROM txn_report_accrual_redemption 
WHERE storecode IN (
    'JAI001','MUM109','MUM107','PUN032','PUN033','BAN111','DEL158','BAN112','CHE110',
    'BAN110','PUB005','HYD059','ODI036','ASM009','NAG002','KOL286','KER017','KOT002',
    'KOL287','KOL267','KOL279','GUJ016','MDP019','BAN117','DEL161','DEL162','KOL290',
    'HYD058','KER019','HYD061','AGR003','HUB001','JAI005','KER020','DEL160','AGR001',
    'AMR001','PUN037','HYD060','DEL163','BAN116','AGR002','KOL291','PUB006','MUM111',
    'BAN119','ASM011','BAN118','ASM012','ASM010','DEL168','PUN036','DEL166','KOL278',
    'PUN038','DEL165','AMR002','DEL169','HYD062','KOL292','JAM001','PUB007','MUM112',
    'JAI006','VIS002','DEL167','VIJ002','KOL288','CHE111','KOL293','DEL170','KOL295',
    'HYD065','DIM001','VIJ003','KER023','KER021','DEL173','HUB002','GAN001','GAN002',
    'KOL297','DEL171','HYD057','COI009','JAI007','DEL176','HYD067','AMR003','PUN040',
    'KOL296','JAM002','BIH014','JAL009','BIH013','AMR004','DEL179','GOA017','BAR001',
    'HYD068','COI010'
)
GROUP BY 1;


SELECT storecode,
CASE
WHEN recency>0 AND recency<=15 THEN '0-15'
WHEN recency>15 AND recency<=30 THEN '15-30' 
WHEN recency>30 AND recency<=60 THEN '30-60'
WHEN recency>60 THEN '>60' END recency,
COUNT(DISTINCT CASE WHEN frequencycount=1 THEN mobile END)onetimer,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN mobile END)repeater
FROM txn_report_accrual_redemption a JOIN dummy.wowmomo_mobile_level b USING(mobile)
WHERE storecode IN (
    'JAI001','MUM109','MUM107','PUN032','PUN033','BAN111','DEL158','BAN112','CHE110',
    'BAN110','PUB005','HYD059','ODI036','ASM009','NAG002','KOL286','KER017','KOT002',
    'KOL287','KOL267','KOL279','GUJ016','MDP019','BAN117','DEL161','DEL162','KOL290',
    'HYD058','KER019','HYD061','AGR003','HUB001','JAI005','KER020','DEL160','AGR001',
    'AMR001','PUN037','HYD060','DEL163','BAN116','AGR002','KOL291','PUB006','MUM111',
    'BAN119','ASM011','BAN118','ASM012','ASM010','DEL168','PUN036','DEL166','KOL278',
    'PUN038','DEL165','AMR002','DEL169','HYD062','KOL292','JAM001','PUB007','MUM112',
    'JAI006','VIS002','DEL167','VIJ002','KOL288','CHE111','KOL293','DEL170','KOL295',
    'HYD065','DIM001','VIJ003','KER023','KER021','DEL173','HUB002','GAN001','GAN002',
    'KOL297','DEL171','HYD057','COI009','JAI007','DEL176','HYD067','AMR003','PUN040',
    'KOL296','JAM002','BIH014','JAL009','BIH013','AMR004','DEL179','GOA017','BAR001',
    'HYD068','COI010'
)
GROUP BY 1,2;

SET @enddate = '2025-09-30';
SET @startdate = DATE_SUB(@enddate ,INTERVAL 1 YEAR);

SELECT @startdate,@enddate;

SELECT `last shopped store`,
COUNT(DISTINCT CASE WHEN `total visits` = 1 AND `last shopped date` BETWEEN '2024-09-30' AND '2025-09-30' THEN mobile END )1_year_onetimer,
COUNT(DISTINCT CASE WHEN `total visits` > 1 AND `last shopped date` BETWEEN '2024-09-30' AND '2025-09-30' THEN mobile END )1_year_repeater,
SUM(CASE WHEN `total visits` = 1 THEN `1_year_sales` END )1_year_onetimer_sales,
SUM(CASE WHEN `total visits` > 1 THEN `1_year_sales` END )1_year_repeater_sales,
SUM(CASE WHEN `total visits` = 1 THEN 1_year_bills END )1_year_onetimer_bills,
SUM(CASE WHEN `total visits` > 1 THEN 1_year_bills END )1_year_repeater_bills
FROM program_single_view c 
    WHERE  c.`last shopped store` IN (
    'JAI001','MUM109','MUM107','PUN032','PUN033','BAN111','DEL158','BAN112','CHE110',
    'BAN110','PUB005','HYD059','ODI036','ASM009','NAG002','KOL286','KER017','KOT002',
    'KOL287','KOL267','KOL279','GUJ016','MDP019','BAN117','DEL161','DEL162','KOL290',
    'HYD058','KER019','HYD061','AGR003','HUB001','JAI005','KER020','DEL160','AGR001',
    'AMR001','PUN037','HYD060','DEL163','BAN116','AGR002','KOL291','PUB006','MUM111',
    'BAN119','ASM011','BAN118','ASM012','ASM010','DEL168','PUN036','DEL166','KOL278',
    'PUN038','DEL165','AMR002','DEL169','HYD062','KOL292','JAM001','PUB007','MUM112',
    'JAI006','VIS002','DEL167','VIJ002','KOL288','CHE111','KOL293','DEL170','KOL295',
    'HYD065','DIM001','VIJ003','KER023','KER021','DEL173','HUB002','GAN001','GAN002',
    'KOL297','DEL171','HYD057','COI009','JAI007','DEL176','HYD067','AMR003','PUN040',
    'KOL296','JAM002','BIH014','JAL009','BIH013','AMR004','DEL179','GOA017','BAR001',
    'HYD068','COI010'
)GROUP BY 1;#228403
##########################


SELECT `last shopped store`,
COUNT(DISTINCT CASE WHEN `total visits` = 1 THEN mobile END )1_year_onetimer,
COUNT(DISTINCT CASE WHEN `total visits` > 1 THEN mobile END )1_year_repeater,
SUM(CASE WHEN `total visits` = 1  THEN  `Total spends`END )1_year_onetimer_sales,
SUM(CASE WHEN `total visits` > 1  THEN `Total spends`END )1_year_repeater_sales,
SUM(CASE WHEN `total visits` = 1  THEN `total transactions`END )1_year_onetimer_bills,
SUM(CASE WHEN `total visits` > 1  THEN `total transactions`END )1_year_repeater_bills
FROM program_single_view c 
    WHERE  c.`last shopped store` IN (
    'JAI001','MUM109','MUM107','PUN032','PUN033','BAN111','DEL158','BAN112','CHE110',
    'BAN110','PUB005','HYD059','ODI036','ASM009','NAG002','KOL286','KER017','KOT002',
    'KOL287','KOL267','KOL279','GUJ016','MDP019','BAN117','DEL161','DEL162','KOL290',
    'HYD058','KER019','HYD061','AGR003','HUB001','JAI005','KER020','DEL160','AGR001',
    'AMR001','PUN037','HYD060','DEL163','BAN116','AGR002','KOL291','PUB006','MUM111',
    'BAN119','ASM011','BAN118','ASM012','ASM010','DEL168','PUN036','DEL166','KOL278',
    'PUN038','DEL165','AMR002','DEL169','HYD062','KOL292','JAM001','PUB007','MUM112',
    'JAI006','VIS002','DEL167','VIJ002','KOL288','CHE111','KOL293','DEL170','KOL295',
    'HYD065','DIM001','VIJ003','KER023','KER021','DEL173','HUB002','GAN001','GAN002',
    'KOL297','DEL171','HYD057','COI009','JAI007','DEL176','HYD067','AMR003','PUN040',
    'KOL296','JAM002','BIH014','JAL009','BIH013','AMR004','DEL179','GOA017','BAR001',
    'HYD068','COI010'
) 
AND `last shopped date` BETWEEN '2024-09-30' AND '2025-09-30'
GROUP BY 1;#228403
#########################

SET @enddate = '2025-09-30';
SET @startdate = DATE_SUB(@enddate ,INTERVAL 1YEAR);
SET @startdate1 = DATE_ADD(@startdate,INTERVAL 3 MONTH);
SELECT @startdate,@enddate,@startdate1;

SET @enddate = '2025-09-30';
SET @startdate = DATE_SUB(@enddate , INTERVAL 9 MONTH);
SET @startdate1 = DATE_ADD(@startdate, INTERVAL 3 MONTH);
SELECT @startdate, @enddate, @startdate1;



SELECT `last shopped store`,
CASE
WHEN recency>0 AND recency<=30 THEN '0-30'
WHEN recency>30 AND recency<=60 THEN '30-60' 
WHEN recency>60 AND recency<=90 THEN '60-90'
WHEN recency>90 AND recency<=120 THEN '90-120'
WHEN recency>120 AND recency<=150 THEN '120-150'
WHEN recency>150 AND recency<=180 THEN '150-180'
WHEN recency>180 AND recency<=210 THEN '180-210'
WHEN recency>210 AND recency<=240 THEN '210-240'
WHEN recency>240 AND recency<=270 THEN '240-270'
WHEN recency>270 AND recency<=300 THEN '270-300'
WHEN recency>300 AND recency<=330 THEN '300-330'
WHEN recency>330 AND recency<=360 THEN '330-360'
WHEN recency>360 THEN '>360' END recency,
COUNT(DISTINCT CASE WHEN `total visits` = 1  THEN mobile END )onetimer,
COUNT(DISTINCT CASE WHEN `total visits` > 1  THEN mobile END )repeater,
SUM(CASE WHEN `total visits` = 1  THEN  `Total spends`END )onetimer_sales,
SUM(CASE WHEN `total visits` > 1  THEN `Total spends`END )repeater_sales,
SUM(CASE WHEN `total visits` = 1  THEN `total transactions`END )onetimer_bills,
SUM(CASE WHEN `total visits` > 1  THEN `total transactions`END )repeater_bills
FROM program_single_view c 
    WHERE  c.`last shopped store` IN (
    'JAI001','MUM109','MUM107','PUN032','PUN033','BAN111','DEL158','BAN112','CHE110',
    'BAN110','PUB005','HYD059','ODI036','ASM009','NAG002','KOL286','KER017','KOT002',
    'KOL287','KOL267','KOL279','GUJ016','MDP019','BAN117','DEL161','DEL162','KOL290',
    'HYD058','KER019','HYD061','AGR003','HUB001','JAI005','KER020','DEL160','AGR001',
    'AMR001','PUN037','HYD060','DEL163','BAN116','AGR002','KOL291','PUB006','MUM111',
    'BAN119','ASM011','BAN118','ASM012','ASM010','DEL168','PUN036','DEL166','KOL278',
    'PUN038','DEL165','AMR002','DEL169','HYD062','KOL292','JAM001','PUB007','MUM112',
    'JAI006','VIS002','DEL167','VIJ002','KOL288','CHE111','KOL293','DEL170','KOL295',
    'HYD065','DIM001','VIJ003','KER023','KER021','DEL173','HUB002','GAN001','GAN002',
    'KOL297','DEL171','HYD057','COI009','JAI007','DEL176','HYD067','AMR003','PUN040',
    'KOL296','JAM002','BIH014','JAL009','BIH013','AMR004','DEL179','GOA017','BAR001',
    'HYD068','COI010'
) 
-- and `last shopped date` BETWEEN '2024-12-01' AND '2025-03-31'
GROUP BY 1,2
ORDER BY recency;#228403

SELECT MIN(txndate),MAX(txndate)FROM txn_report_accrual_redemption;



SELECT `last shopped store`,
COUNT(DISTINCT CASE WHEN `total visits` = 1 THEN mobile END )1_year_onetimer,
COUNT(DISTINCT CASE WHEN `total visits` > 1 THEN mobile END )1_year_repeater,
SUM(CASE WHEN `total visits` = 1  THEN  `Total spends`END )1_year_onetimer_sales,
SUM(CASE WHEN `total visits` > 1  THEN `Total spends`END )1_year_repeater_sales,
SUM(CASE WHEN `total visits` = 1  THEN `total transactions`END )1_year_onetimer_bills,
SUM(CASE WHEN `total visits` > 1  THEN `total transactions`END )1_year_repeater_bills
FROM program_single_view c 
    WHERE  c.`last shopped store` IN (
    'JAI001','MUM109','MUM107','PUN032','PUN033','BAN111','DEL158','BAN112','CHE110',
    'BAN110','PUB005','HYD059','ODI036','ASM009','NAG002','KOL286','KER017','KOT002',
    'KOL287','KOL267','KOL279','GUJ016','MDP019','BAN117','DEL161','DEL162','KOL290',
    'HYD058','KER019','HYD061','AGR003','HUB001','JAI005','KER020','DEL160','AGR001',
    'AMR001','PUN037','HYD060','DEL163','BAN116','AGR002','KOL291','PUB006','MUM111',
    'BAN119','ASM011','BAN118','ASM012','ASM010','DEL168','PUN036','DEL166','KOL278',
    'PUN038','DEL165','AMR002','DEL169','HYD062','KOL292','JAM001','PUB007','MUM112',
    'JAI006','VIS002','DEL167','VIJ002','KOL288','CHE111','KOL293','DEL170','KOL295',
    'HYD065','DIM001','VIJ003','KER023','KER021','DEL173','HUB002','GAN001','GAN002',
    'KOL297','DEL171','HYD057','COI009','JAI007','DEL176','HYD067','AMR003','PUN040',
    'KOL296','JAM002','BIH014','JAL009','BIH013','AMR004','DEL179','GOA017','BAR001',
    'HYD068','COI010'
) 
AND `last shopped date`<=  '2025-09-30'
GROUP BY 1;#228403


SELECT mobile,txndate,storecode,RANK() PARTITION BY txndate ORDER BY storecode ranks FROM txn_report_accrual_redemption;

SELECT 
mobile,
txndate,
storecode,
RANK() OVER (PARTITION BY txndate ORDER BY storecode) AS ranks
FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2024-9-30' AND '2025-08-31';

INSERT INTO dummy.mobile_level_data
SELECT mobile,MIN(txndate)first_txndate,MAX(txndate)max_txn_date,MIN(frequencycount)minf,MAX(frequencycount)maxf 
FROM txn_report_accrual_redemption
WHERE txndate <='2025-08-31' GROUP BY 1;

ALTER TABLE dummy.mobile_level_data ADD INDEX mobile(mobile),ADD COLUMN sales FLOAT,ADD COLUMN bills VARCHAR(100);

ALTER TABLE dummy.mobile_level_data ADD COLUMN last_shopped_store VARCHAR(100);


UPDATE dummy.mobile_level_data a JOIN (
SELECT DISTINCT mobile,txndate,storecode FROM txn_report_accrual_redemption
WHERE txndate <='2025-08-31')b ON a.mobile=b.mobile AND a.max_txn_date=b.txndate
SET a.last_shopped_store=b.storecode;#6537673

ALTER TABLE dummy.mobile_level_data ADD COLUMN recency VARCHAR(100);

UPDATE dummy.mobile_level_data a JOIN (
SELECT mobile,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills,DATEDIFF('2025-08-31',MAX(txndate))recency 
FROM txn_report_accrual_redemption
WHERE txndate <='2025-08-31'
GROUP BY 1)b USING(mobile)
SET a.sales=b.sales,a.bills=b.bills,a.recency=b.recency;#6537673

SELECT * FROM dummy.mobile_level_data;

ALTER TABLE dummy.mobile_level_data ADD COLUMN onetimer_sales FLOAT,ADD COLUMN repeater_sales FLOAT,
ADD COLUMN 1_year_onetimer_sales FLOAT,ADD COLUMN 1_year_repeater_sales FLOAT ;

ALTER TABLE dummy.mobile_level_data ADD COLUMN onetimer_bills VARCHAR(100),ADD COLUMN repeater_bills VARCHAR(100);


UPDATE dummy.mobile_level_data a JOIN (
SELECT mobile,
SUM(CASE WHEN frequencycount=1 THEN amount END)onetimer_sales,
SUM(CASE WHEN frequencycount>1 THEN amount END)repeater_sales,

COUNT(DISTINCT CASE WHEN frequencycount=1 THEN uniquebillno END)Onetimer_bills,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN uniquebillno END)repeater_bills
FROM txn_report_accrual_redemption
WHERE txndate <='2025-08-31'
GROUP BY 1)b USING(mobile)
SET a.onetimer_sales=b.onetimer_sales,a.repeater_sales=b.repeater_sales,a.Onetimer_bills=b.Onetimer_bills,a.repeater_bills=b.repeater_bills;#6537673


ALTER TABLE dummy.mobile_level_data  ADD COLUMN 1_year_onetimer_bills VARCHAR(100),ADD COLUMN 1_year_repeater_bills VARCHAR(100);

UPDATE dummy.mobile_level_data a JOIN (
SELECT mobile,
SUM(CASE WHEN frequencycount=1 THEN amount END)1_year_onetimer_sales,
SUM(CASE WHEN frequencycount>1 THEN amount END)1_year_repeater_sales,

COUNT(DISTINCT CASE WHEN frequencycount=1 THEN uniquebillno END)1_year_onetimer_bills,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN uniquebillno END)1_year_repeater_bills
FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2024-09-01' AND '2025-08-31'
GROUP BY 1)b USING(mobile)
SET a.1_year_onetimer_sales=b.1_year_onetimer_sales,
a.1_year_repeater_sales=b.1_year_repeater_sales,
a.1_year_onetimer_bills=b.1_year_onetimer_bills,
a.1_year_repeater_bills=b.1_year_repeater_bills;#4311407


ALTER TABLE dummy.mobile_level_data ADD COLUMN customer_type VARCHAR(100);

UPDATE dummy.mobile_level_data a JOIN (
SELECT mobile,
CASE 
WHEN frequencycount=1 THEN '1year_onetimer'
WHEN frequencycount>1 THEN '1year_repeater' END customer_type FROM 
txn_report_accrual_redemption
WHERE txndate BETWEEN '2024-09-01' AND '2025-08-31'
GROUP BY 1)b USING(mobile)
SET a.customer_type=b.customer_type;#4311407


SELECT last_shopped_store,customer_type,COUNT(DISTINCT mobile)customer FROM dummy.mobile_level_data
WHERE  last_shopped_store IN (
    'JAI001','MUM109','MUM107','PUN032','PUN033','BAN111','DEL158','BAN112','CHE110',
    'BAN110','PUB005','HYD059','ODI036','ASM009','NAG002','KOL286','KER017','KOT002',
    'KOL287','KOL267','KOL279','GUJ016','MDP019','BAN117','DEL161','DEL162','KOL290',
    'HYD058','KER019','HYD061','AGR003','HUB001','JAI005','KER020','DEL160','AGR001',
    'AMR001','PUN037','HYD060','DEL163','BAN116','AGR002','KOL291','PUB006','MUM111',
    'BAN119','ASM011','BAN118','ASM012','ASM010','DEL168','PUN036','DEL166','KOL278',
    'PUN038','DEL165','AMR002','DEL169','HYD062','KOL292','JAM001','PUB007','MUM112',
    'JAI006','VIS002','DEL167','VIJ002','KOL288','CHE111','KOL293','DEL170','KOL295',
    'HYD065','DIM001','VIJ003','KER023','KER021','DEL173','HUB002','GAN001','GAN002',
    'KOL297','DEL171','HYD057','COI009','JAI007','DEL176','HYD067','AMR003','PUN040',
    'KOL296','JAM002','BIH014','JAL009','BIH013','AMR004','DEL179','GOA017','BAR001',
    'HYD068','COI010'
) 
GROUP BY 1,2;

SELECT last_shopped_store,SUM(1_year_onetimer_sales)1_year_onetimer_sales,
SUM(1_year_repeater_sales)1_year_repeater_sales,
SUM(1_year_onetimer_bills)1_year_onetimer_bills,SUM(1_year_repeater_bills)1_year_repeater_bills  
FROM dummy.mobile_level_data
WHERE  last_shopped_store IN (
    'JAI001','MUM109','MUM107','PUN032','PUN033','BAN111','DEL158','BAN112','CHE110',
    'BAN110','PUB005','HYD059','ODI036','ASM009','NAG002','KOL286','KER017','KOT002',
    'KOL287','KOL267','KOL279','GUJ016','MDP019','BAN117','DEL161','DEL162','KOL290',
    'HYD058','KER019','HYD061','AGR003','HUB001','JAI005','KER020','DEL160','AGR001',
    'AMR001','PUN037','HYD060','DEL163','BAN116','AGR002','KOL291','PUB006','MUM111',
    'BAN119','ASM011','BAN118','ASM012','ASM010','DEL168','PUN036','DEL166','KOL278',
    'PUN038','DEL165','AMR002','DEL169','HYD062','KOL292','JAM001','PUB007','MUM112',
    'JAI006','VIS002','DEL167','VIJ002','KOL288','CHE111','KOL293','DEL170','KOL295',
    'HYD065','DIM001','VIJ003','KER023','KER021','DEL173','HUB002','GAN001','GAN002',
    'KOL297','DEL171','HYD057','COI009','JAI007','DEL176','HYD067','AMR003','PUN040',
    'KOL296','JAM002','BIH014','JAL009','BIH013','AMR004','DEL179','GOA017','BAR001',
    'HYD068','COI010'
) 
GROUP BY 1;


SELECT last_shopped_store,
CASE
WHEN recency>0 AND recency<=90 THEN '0-90'
WHEN recency>90 AND recency<=180 THEN '90-180' 
WHEN recency>240 AND recency<=270 THEN '180-270'
WHEN recency>270 AND recency<=360 THEN '270-360'
WHEN recency>360 THEN '>360' END recency,
SUM(1_year_onetimer_sales)1_year_onetimer_sales,
SUM(1_year_repeater_sales)1_year_repeater_sales,
SUM(1_year_onetimer_bills)1_year_onetimer_bills,SUM(1_year_repeater_bills)1_year_repeater_bills  
FROM dummy.mobile_level_data
WHERE  last_shopped_store IN (
    'JAI001','MUM109','MUM107','PUN032','PUN033','BAN111','DEL158','BAN112','CHE110',
    'BAN110','PUB005','HYD059','ODI036','ASM009','NAG002','KOL286','KER017','KOT002',
    'KOL287','KOL267','KOL279','GUJ016','MDP019','BAN117','DEL161','DEL162','KOL290',
    'HYD058','KER019','HYD061','AGR003','HUB001','JAI005','KER020','DEL160','AGR001',
    'AMR001','PUN037','HYD060','DEL163','BAN116','AGR002','KOL291','PUB006','MUM111',
    'BAN119','ASM011','BAN118','ASM012','ASM010','DEL168','PUN036','DEL166','KOL278',
    'PUN038','DEL165','AMR002','DEL169','HYD062','KOL292','JAM001','PUB007','MUM112',
    'JAI006','VIS002','DEL167','VIJ002','KOL288','CHE111','KOL293','DEL170','KOL295',
    'HYD065','DIM001','VIJ003','KER023','KER021','DEL173','HUB002','GAN001','GAN002',
    'KOL297','DEL171','HYD057','COI009','JAI007','DEL176','HYD067','AMR003','PUN040',
    'KOL296','JAM002','BIH014','JAL009','BIH013','AMR004','DEL179','GOA017','BAR001',
    'HYD068','COI010'
) 
GROUP BY 1,2
ORDER BY recency;



SELECT last_shopped_store,
CASE
WHEN recency>0 AND recency<=90 THEN '0-90'
WHEN recency>90 AND recency<=180 THEN '90-180' 
WHEN recency>240 AND recency<=270 THEN '180-270'
WHEN recency>270 AND recency<=360 THEN '270-360'
WHEN recency>360 THEN '>360' END recency,customer_type,COUNT(DISTINCT mobile)cusotmer 
FROM dummy.mobile_level_data
WHERE  last_shopped_store IN (
    'JAI001','MUM109','MUM107','PUN032','PUN033','BAN111','DEL158','BAN112','CHE110',
    'BAN110','PUB005','HYD059','ODI036','ASM009','NAG002','KOL286','KER017','KOT002',
    'KOL287','KOL267','KOL279','GUJ016','MDP019','BAN117','DEL161','DEL162','KOL290',
    'HYD058','KER019','HYD061','AGR003','HUB001','JAI005','KER020','DEL160','AGR001',
    'AMR001','PUN037','HYD060','DEL163','BAN116','AGR002','KOL291','PUB006','MUM111',
    'BAN119','ASM011','BAN118','ASM012','ASM010','DEL168','PUN036','DEL166','KOL278',
    'PUN038','DEL165','AMR002','DEL169','HYD062','KOL292','JAM001','PUB007','MUM112',
    'JAI006','VIS002','DEL167','VIJ002','KOL288','CHE111','KOL293','DEL170','KOL295',
    'HYD065','DIM001','VIJ003','KER023','KER021','DEL173','HUB002','GAN001','GAN002',
    'KOL297','DEL171','HYD057','COI009','JAI007','DEL176','HYD067','AMR003','PUN040',
    'KOL296','JAM002','BIH014','JAL009','BIH013','AMR004','DEL179','GOA017','BAR001',
    'HYD068','COI010'
) 
GROUP BY 1,2,3
ORDER BY recency;

SELECT MIN(txndate), MAX(txndate) 
FROM txn_report_accrual_redemption;

SELECT * FROM dummy.mobile_level_data;
########################################3

SELECT `last shopped store`,
COUNT(DISTINCT CASE WHEN `total visits` = 1 THEN mobile END )onetimer,
COUNT(DISTINCT CASE WHEN `total visits` > 1 THEN mobile END )repeater,
SUM(CASE WHEN `total visits` = 1 THEN `Total spends`END )onetimer_sales,
SUM(CASE WHEN `total visits` > 1 THEN `Total spends`END )repeater_sales,
SUM(CASE WHEN `total visits` = 1 THEN `total transactions`END )onetimer_bills,
SUM(CASE WHEN `total visits` > 1 THEN `total transactions`END )repeater_bills
FROM program_single_view c 
    WHERE  c.`last shopped store` IN (
    'JAI001','MUM109','MUM107','PUN032','PUN033','BAN111','DEL158','BAN112','CHE110',
    'BAN110','PUB005','HYD059','ODI036','ASM009','NAG002','KOL286','KER017','KOT002',
    'KOL287','KOL267','KOL279','GUJ016','MDP019','BAN117','DEL161','DEL162','KOL290',
    'HYD058','KER019','HYD061','AGR003','HUB001','JAI005','KER020','DEL160','AGR001',
    'AMR001','PUN037','HYD060','DEL163','BAN116','AGR002','KOL291','PUB006','MUM111',
    'BAN119','ASM011','BAN118','ASM012','ASM010','DEL168','PUN036','DEL166','KOL278',
    'PUN038','DEL165','AMR002','DEL169','HYD062','KOL292','JAM001','PUB007','MUM112',
    'JAI006','VIS002','DEL167','VIJ002','KOL288','CHE111','KOL293','DEL170','KOL295',
    'HYD065','DIM001','VIJ003','KER023','KER021','DEL173','HUB002','GAN001','GAN002',
    'KOL297','DEL171','HYD057','COI009','JAI007','DEL176','HYD067','AMR003','PUN040',
    'KOL296','JAM002','BIH014','JAL009','BIH013','AMR004','DEL179','GOA017','BAR001',
    'HYD068','COI010'
)GROUP BY 1;#228403

SELECT * FROM program_single_view


SELECT `last shopped store`,
CASE
WHEN recency>0 AND recency<=15 THEN '0-15'
WHEN recency>15 AND recency<=30 THEN '15-30' 
WHEN recency>30 AND recency<=60 THEN '30-60'
WHEN recency>60 THEN '>60' END recency,COUNT(DISTINCT mobile)
FROM program_single_view c 
    WHERE  c.`last shopped store` IN (
    'JAI001','MUM109','MUM107','PUN032','PUN033','BAN111','DEL158','BAN112','CHE110',
    'BAN110','PUB005','HYD059','ODI036','ASM009','NAG002','KOL286','KER017','KOT002',
    'KOL287','KOL267','KOL279','GUJ016','MDP019','BAN117','DEL161','DEL162','KOL290',
    'HYD058','KER019','HYD061','AGR003','HUB001','JAI005','KER020','DEL160','AGR001',
    'AMR001','PUN037','HYD060','DEL163','BAN116','AGR002','KOL291','PUB006','MUM111',
    'BAN119','ASM011','BAN118','ASM012','ASM010','DEL168','PUN036','DEL166','KOL278',
    'PUN038','DEL165','AMR002','DEL169','HYD062','KOL292','JAM001','PUB007','MUM112',
    'JAI006','VIS002','DEL167','VIJ002','KOL288','CHE111','KOL293','DEL170','KOL295',
    'HYD065','DIM001','VIJ003','KER023','KER021','DEL173','HUB002','GAN001','GAN002',
    'KOL297','DEL171','HYD057','COI009','JAI007','DEL176','HYD067','AMR003','PUN040',
    'KOL296','JAM002','BIH014','JAL009','BIH013','AMR004','DEL179','GOA017','BAR001',
    'HYD068','COI010'
)
AND `total visits` >1
GROUP BY 1;#228403





SELECT storecode,
COUNT(DISTINCT CASE WHEN frequencycount=1 THEN mobile END)onetimer,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN mobile END)repeater,
SUM(CASE WHEN frequencycount=1 THEN amount END)onetimer_sales,
SUM(CASE WHEN frequencycount>1 THEN amount END)repeater_sales,
COUNT(DISTINCT CASE WHEN frequencycount=1 THEN uniquebillno END)onetimer_bills,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN uniquebillno END)repeater_bills
FROM txn_report_accrual_redemption 
WHERE storecode IN (
    'JAI001','MUM109','MUM107','PUN032','PUN033','BAN111','DEL158','BAN112','CHE110',
    'BAN110','PUB005','HYD059','ODI036','ASM009','NAG002','KOL286','KER017','KOT002',
    'KOL287','KOL267','KOL279','GUJ016','MDP019','BAN117','DEL161','DEL162','KOL290',
    'HYD058','KER019','HYD061','AGR003','HUB001','JAI005','KER020','DEL160','AGR001',
    'AMR001','PUN037','HYD060','DEL163','BAN116','AGR002','KOL291','PUB006','MUM111',
    'BAN119','ASM011','BAN118','ASM012','ASM010','DEL168','PUN036','DEL166','KOL278',
    'PUN038','DEL165','AMR002','DEL169','HYD062','KOL292','JAM001','PUB007','MUM112',
    'JAI006','VIS002','DEL167','VIJ002','KOL288','CHE111','KOL293','DEL170','KOL295',
    'HYD065','DIM001','VIJ003','KER023','KER021','DEL173','HUB002','GAN001','GAN002',
    'KOL297','DEL171','HYD057','COI009','JAI007','DEL176','HYD067','AMR003','PUN040',
    'KOL296','JAM002','BIH014','JAL009','BIH013','AMR004','DEL179','GOA017','BAR001',
    'HYD068','COI010'
)
GROUP BY 1;


SELECT storecode,
CASE
WHEN recency>0 AND recency<=15 THEN '0-15'
WHEN recency>15 AND recency<=30 THEN '15-30' 
WHEN recency>30 AND recency<=60 THEN '30-60'
WHEN recency>60 THEN '>60' END recency,
COUNT(DISTINCT CASE WHEN frequencycount=1 THEN mobile END)onetimer,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN mobile END)repeater
FROM txn_report_accrual_redemption a JOIN dummy.wowmomo_mobile_level b USING(mobile)
WHERE storecode IN (
    'JAI001','MUM109','MUM107','PUN032','PUN033','BAN111','DEL158','BAN112','CHE110',
    'BAN110','PUB005','HYD059','ODI036','ASM009','NAG002','KOL286','KER017','KOT002',
    'KOL287','KOL267','KOL279','GUJ016','MDP019','BAN117','DEL161','DEL162','KOL290',
    'HYD058','KER019','HYD061','AGR003','HUB001','JAI005','KER020','DEL160','AGR001',
    'AMR001','PUN037','HYD060','DEL163','BAN116','AGR002','KOL291','PUB006','MUM111',
    'BAN119','ASM011','BAN118','ASM012','ASM010','DEL168','PUN036','DEL166','KOL278',
    'PUN038','DEL165','AMR002','DEL169','HYD062','KOL292','JAM001','PUB007','MUM112',
    'JAI006','VIS002','DEL167','VIJ002','KOL288','CHE111','KOL293','DEL170','KOL295',
    'HYD065','DIM001','VIJ003','KER023','KER021','DEL173','HUB002','GAN001','GAN002',
    'KOL297','DEL171','HYD057','COI009','JAI007','DEL176','HYD067','AMR003','PUN040',
    'KOL296','JAM002','BIH014','JAL009','BIH013','AMR004','DEL179','GOA017','BAR001',
    'HYD068','COI010'
)
GROUP BY 1,2;

SET @enddate = '2025-09-30';
SET @startdate = DATE_SUB(@enddate ,INTERVAL 1 YEAR);

SELECT @startdate,@enddate;

SELECT `last shopped store`,
COUNT(DISTINCT CASE WHEN `total visits` = 1 AND `last shopped date` BETWEEN '2024-09-30' AND '2025-09-30' THEN mobile END )1_year_onetimer,
COUNT(DISTINCT CASE WHEN `total visits` > 1 AND `last shopped date` BETWEEN '2024-09-30' AND '2025-09-30' THEN mobile END )1_year_repeater,
SUM(CASE WHEN `total visits` = 1 THEN `1_year_sales` END )1_year_onetimer_sales,
SUM(CASE WHEN `total visits` > 1 THEN `1_year_sales` END )1_year_repeater_sales,
SUM(CASE WHEN `total visits` = 1 THEN 1_year_bills END )1_year_onetimer_bills,
SUM(CASE WHEN `total visits` > 1 THEN 1_year_bills END )1_year_repeater_bills
FROM program_single_view c 
    WHERE  c.`last shopped store` IN (
    'JAI001','MUM109','MUM107','PUN032','PUN033','BAN111','DEL158','BAN112','CHE110',
    'BAN110','PUB005','HYD059','ODI036','ASM009','NAG002','KOL286','KER017','KOT002',
    'KOL287','KOL267','KOL279','GUJ016','MDP019','BAN117','DEL161','DEL162','KOL290',
    'HYD058','KER019','HYD061','AGR003','HUB001','JAI005','KER020','DEL160','AGR001',
    'AMR001','PUN037','HYD060','DEL163','BAN116','AGR002','KOL291','PUB006','MUM111',
    'BAN119','ASM011','BAN118','ASM012','ASM010','DEL168','PUN036','DEL166','KOL278',
    'PUN038','DEL165','AMR002','DEL169','HYD062','KOL292','JAM001','PUB007','MUM112',
    'JAI006','VIS002','DEL167','VIJ002','KOL288','CHE111','KOL293','DEL170','KOL295',
    'HYD065','DIM001','VIJ003','KER023','KER021','DEL173','HUB002','GAN001','GAN002',
    'KOL297','DEL171','HYD057','COI009','JAI007','DEL176','HYD067','AMR003','PUN040',
    'KOL296','JAM002','BIH014','JAL009','BIH013','AMR004','DEL179','GOA017','BAR001',
    'HYD068','COI010'
)GROUP BY 1;#228403
##########################


SELECT `last shopped store`,
COUNT(DISTINCT CASE WHEN `total visits` = 1 THEN mobile END )1_year_onetimer,
COUNT(DISTINCT CASE WHEN `total visits` > 1 THEN mobile END )1_year_repeater,
SUM(CASE WHEN `total visits` = 1  THEN  `Total spends`END )1_year_onetimer_sales,
SUM(CASE WHEN `total visits` > 1  THEN `Total spends`END )1_year_repeater_sales,
SUM(CASE WHEN `total visits` = 1  THEN `total transactions`END )1_year_onetimer_bills,
SUM(CASE WHEN `total visits` > 1  THEN `total transactions`END )1_year_repeater_bills
FROM program_single_view c 
    WHERE  c.`last shopped store` IN (
    'JAI001','MUM109','MUM107','PUN032','PUN033','BAN111','DEL158','BAN112','CHE110',
    'BAN110','PUB005','HYD059','ODI036','ASM009','NAG002','KOL286','KER017','KOT002',
    'KOL287','KOL267','KOL279','GUJ016','MDP019','BAN117','DEL161','DEL162','KOL290',
    'HYD058','KER019','HYD061','AGR003','HUB001','JAI005','KER020','DEL160','AGR001',
    'AMR001','PUN037','HYD060','DEL163','BAN116','AGR002','KOL291','PUB006','MUM111',
    'BAN119','ASM011','BAN118','ASM012','ASM010','DEL168','PUN036','DEL166','KOL278',
    'PUN038','DEL165','AMR002','DEL169','HYD062','KOL292','JAM001','PUB007','MUM112',
    'JAI006','VIS002','DEL167','VIJ002','KOL288','CHE111','KOL293','DEL170','KOL295',
    'HYD065','DIM001','VIJ003','KER023','KER021','DEL173','HUB002','GAN001','GAN002',
    'KOL297','DEL171','HYD057','COI009','JAI007','DEL176','HYD067','AMR003','PUN040',
    'KOL296','JAM002','BIH014','JAL009','BIH013','AMR004','DEL179','GOA017','BAR001',
    'HYD068','COI010'
) 
AND `last shopped date` BETWEEN '2024-09-30' AND '2025-09-30'
GROUP BY 1;#228403
#########################

SET @enddate = '2025-09-30';
SET @startdate = DATE_SUB(@enddate ,INTERVAL 1YEAR);
SET @startdate1 = DATE_ADD(@startdate,INTERVAL 3 MONTH);
SELECT @startdate,@enddate,@startdate1;

SET @enddate = '2025-09-30';
SET @startdate = DATE_SUB(@enddate , INTERVAL 9 MONTH);
SET @startdate1 = DATE_ADD(@startdate, INTERVAL 3 MONTH);
SELECT @startdate, @enddate, @startdate1;



SELECT `last shopped store`,
CASE
WHEN recency>0 AND recency<=30 THEN '0-30'
WHEN recency>30 AND recency<=60 THEN '30-60' 
WHEN recency>60 AND recency<=90 THEN '60-90'
WHEN recency>90 AND recency<=120 THEN '90-120'
WHEN recency>120 AND recency<=150 THEN '120-150'
WHEN recency>150 AND recency<=180 THEN '150-180'
WHEN recency>180 AND recency<=210 THEN '180-210'
WHEN recency>210 AND recency<=240 THEN '210-240'
WHEN recency>240 AND recency<=270 THEN '240-270'
WHEN recency>270 AND recency<=300 THEN '270-300'
WHEN recency>300 AND recency<=330 THEN '300-330'
WHEN recency>330 AND recency<=360 THEN '330-360'
WHEN recency>360 THEN '>360' END recency,
COUNT(DISTINCT CASE WHEN `total visits` = 1  THEN mobile END )onetimer,
COUNT(DISTINCT CASE WHEN `total visits` > 1  THEN mobile END )repeater,
SUM(CASE WHEN `total visits` = 1  THEN  `Total spends`END )onetimer_sales,
SUM(CASE WHEN `total visits` > 1  THEN `Total spends`END )repeater_sales,
SUM(CASE WHEN `total visits` = 1  THEN `total transactions`END )onetimer_bills,
SUM(CASE WHEN `total visits` > 1  THEN `total transactions`END )repeater_bills
FROM program_single_view c 
    WHERE  c.`last shopped store` IN (
    'JAI001','MUM109','MUM107','PUN032','PUN033','BAN111','DEL158','BAN112','CHE110',
    'BAN110','PUB005','HYD059','ODI036','ASM009','NAG002','KOL286','KER017','KOT002',
    'KOL287','KOL267','KOL279','GUJ016','MDP019','BAN117','DEL161','DEL162','KOL290',
    'HYD058','KER019','HYD061','AGR003','HUB001','JAI005','KER020','DEL160','AGR001',
    'AMR001','PUN037','HYD060','DEL163','BAN116','AGR002','KOL291','PUB006','MUM111',
    'BAN119','ASM011','BAN118','ASM012','ASM010','DEL168','PUN036','DEL166','KOL278',
    'PUN038','DEL165','AMR002','DEL169','HYD062','KOL292','JAM001','PUB007','MUM112',
    'JAI006','VIS002','DEL167','VIJ002','KOL288','CHE111','KOL293','DEL170','KOL295',
    'HYD065','DIM001','VIJ003','KER023','KER021','DEL173','HUB002','GAN001','GAN002',
    'KOL297','DEL171','HYD057','COI009','JAI007','DEL176','HYD067','AMR003','PUN040',
    'KOL296','JAM002','BIH014','JAL009','BIH013','AMR004','DEL179','GOA017','BAR001',
    'HYD068','COI010'
) 
-- and `last shopped date` BETWEEN '2024-12-01' AND '2025-03-31'
GROUP BY 1,2
ORDER BY recency;#228403

SELECT MIN(txndate),MAX(txndate)FROM txn_report_accrual_redemption;



SELECT `last shopped store`,
COUNT(DISTINCT CASE WHEN `total visits` = 1 THEN mobile END )1_year_onetimer,
COUNT(DISTINCT CASE WHEN `total visits` > 1 THEN mobile END )1_year_repeater,
SUM(CASE WHEN `total visits` = 1  THEN  `Total spends`END )1_year_onetimer_sales,
SUM(CASE WHEN `total visits` > 1  THEN `Total spends`END )1_year_repeater_sales,
SUM(CASE WHEN `total visits` = 1  THEN `total transactions`END )1_year_onetimer_bills,
SUM(CASE WHEN `total visits` > 1  THEN `total transactions`END )1_year_repeater_bills
FROM program_single_view c 
    WHERE  c.`last shopped store` IN (
    'JAI001','MUM109','MUM107','PUN032','PUN033','BAN111','DEL158','BAN112','CHE110',
    'BAN110','PUB005','HYD059','ODI036','ASM009','NAG002','KOL286','KER017','KOT002',
    'KOL287','KOL267','KOL279','GUJ016','MDP019','BAN117','DEL161','DEL162','KOL290',
    'HYD058','KER019','HYD061','AGR003','HUB001','JAI005','KER020','DEL160','AGR001',
    'AMR001','PUN037','HYD060','DEL163','BAN116','AGR002','KOL291','PUB006','MUM111',
    'BAN119','ASM011','BAN118','ASM012','ASM010','DEL168','PUN036','DEL166','KOL278',
    'PUN038','DEL165','AMR002','DEL169','HYD062','KOL292','JAM001','PUB007','MUM112',
    'JAI006','VIS002','DEL167','VIJ002','KOL288','CHE111','KOL293','DEL170','KOL295',
    'HYD065','DIM001','VIJ003','KER023','KER021','DEL173','HUB002','GAN001','GAN002',
    'KOL297','DEL171','HYD057','COI009','JAI007','DEL176','HYD067','AMR003','PUN040',
    'KOL296','JAM002','BIH014','JAL009','BIH013','AMR004','DEL179','GOA017','BAR001',
    'HYD068','COI010'
) 
AND `last shopped date`<=  '2025-09-30'
GROUP BY 1;#228403


SELECT mobile,txndate,storecode,RANK() PARTITION BY txndate ORDER BY storecode ranks FROM txn_report_accrual_redemption;

SELECT 
mobile,
txndate,
storecode,
RANK() OVER (PARTITION BY txndate ORDER BY storecode) AS ranks
FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2024-9-30' AND '2025-08-31';

INSERT INTO dummy.mobile_level_data
SELECT mobile,MIN(txndate)first_txndate,MAX(txndate)max_txn_date,MIN(frequencycount)minf,MAX(frequencycount)maxf 
FROM txn_report_accrual_redemption
WHERE txndate <='2025-08-31' GROUP BY 1;

ALTER TABLE dummy.mobile_level_data ADD INDEX mobile(mobile),ADD COLUMN sales FLOAT,ADD COLUMN bills VARCHAR(100);

ALTER TABLE dummy.mobile_level_data ADD COLUMN last_shopped_store VARCHAR(100);


UPDATE dummy.mobile_level_data a JOIN (
SELECT DISTINCT mobile,txndate,storecode FROM txn_report_accrual_redemption
WHERE txndate <='2025-08-31')b ON a.mobile=b.mobile AND a.max_txn_date=b.txndate
SET a.last_shopped_store=b.storecode;#6537673

ALTER TABLE dummy.mobile_level_data ADD COLUMN recency VARCHAR(100);

UPDATE dummy.mobile_level_data a JOIN (
SELECT mobile,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills,DATEDIFF('2025-08-31',MAX(txndate))recency 
FROM txn_report_accrual_redemption
WHERE txndate <='2025-08-31'
GROUP BY 1)b USING(mobile)
SET a.sales=b.sales,a.bills=b.bills,a.recency=b.recency;#6537673

SELECT * FROM dummy.mobile_level_data;

ALTER TABLE dummy.mobile_level_data ADD COLUMN onetimer_sales FLOAT,ADD COLUMN repeater_sales FLOAT,
ADD COLUMN 1_year_onetimer_sales FLOAT,ADD COLUMN 1_year_repeater_sales FLOAT ;

ALTER TABLE dummy.mobile_level_data ADD COLUMN onetimer_bills VARCHAR(100),ADD COLUMN repeater_bills VARCHAR(100);


UPDATE dummy.mobile_level_data a JOIN (
SELECT mobile,
SUM(CASE WHEN frequencycount=1 THEN amount END)onetimer_sales,
SUM(CASE WHEN frequencycount>1 THEN amount END)repeater_sales,

COUNT(DISTINCT CASE WHEN frequencycount=1 THEN uniquebillno END)Onetimer_bills,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN uniquebillno END)repeater_bills
FROM txn_report_accrual_redemption
WHERE txndate <='2025-08-31'
GROUP BY 1)b USING(mobile)
SET a.onetimer_sales=b.onetimer_sales,a.repeater_sales=b.repeater_sales,a.Onetimer_bills=b.Onetimer_bills,a.repeater_bills=b.repeater_bills;#6537673


ALTER TABLE dummy.mobile_level_data  ADD COLUMN 1_year_onetimer_bills VARCHAR(100),ADD COLUMN 1_year_repeater_bills VARCHAR(100);

UPDATE dummy.mobile_level_data a JOIN (
SELECT mobile,
SUM(CASE WHEN frequencycount=1 THEN amount END)1_year_onetimer_sales,
SUM(CASE WHEN frequencycount>1 THEN amount END)1_year_repeater_sales,

COUNT(DISTINCT CASE WHEN frequencycount=1 THEN uniquebillno END)1_year_onetimer_bills,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN uniquebillno END)1_year_repeater_bills
FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2024-09-01' AND '2025-08-31'
GROUP BY 1)b USING(mobile)
SET a.1_year_onetimer_sales=b.1_year_onetimer_sales,
a.1_year_repeater_sales=b.1_year_repeater_sales,
a.1_year_onetimer_bills=b.1_year_onetimer_bills,
a.1_year_repeater_bills=b.1_year_repeater_bills;#4311407


ALTER TABLE dummy.mobile_level_data ADD COLUMN customer_type VARCHAR(100);

UPDATE dummy.mobile_level_data a JOIN (
SELECT mobile,
CASE 
WHEN frequencycount=1 THEN '1year_onetimer'
WHEN frequencycount>1 THEN '1year_repeater' END customer_type FROM 
txn_report_accrual_redemption
WHERE txndate BETWEEN '2024-09-01' AND '2025-08-31'
GROUP BY 1)b USING(mobile)
SET a.customer_type=b.customer_type;#4311407


SELECT last_shopped_store,customer_type,COUNT(DISTINCT mobile)customer FROM dummy.mobile_level_data
WHERE  last_shopped_store IN (
    'JAI001','MUM109','MUM107','PUN032','PUN033','BAN111','DEL158','BAN112','CHE110',
    'BAN110','PUB005','HYD059','ODI036','ASM009','NAG002','KOL286','KER017','KOT002',
    'KOL287','KOL267','KOL279','GUJ016','MDP019','BAN117','DEL161','DEL162','KOL290',
    'HYD058','KER019','HYD061','AGR003','HUB001','JAI005','KER020','DEL160','AGR001',
    'AMR001','PUN037','HYD060','DEL163','BAN116','AGR002','KOL291','PUB006','MUM111',
    'BAN119','ASM011','BAN118','ASM012','ASM010','DEL168','PUN036','DEL166','KOL278',
    'PUN038','DEL165','AMR002','DEL169','HYD062','KOL292','JAM001','PUB007','MUM112',
    'JAI006','VIS002','DEL167','VIJ002','KOL288','CHE111','KOL293','DEL170','KOL295',
    'HYD065','DIM001','VIJ003','KER023','KER021','DEL173','HUB002','GAN001','GAN002',
    'KOL297','DEL171','HYD057','COI009','JAI007','DEL176','HYD067','AMR003','PUN040',
    'KOL296','JAM002','BIH014','JAL009','BIH013','AMR004','DEL179','GOA017','BAR001',
    'HYD068','COI010'
) 
GROUP BY 1,2;

SELECT last_shopped_store,SUM(1_year_onetimer_sales)1_year_onetimer_sales,
SUM(1_year_repeater_sales)1_year_repeater_sales,
SUM(1_year_onetimer_bills)1_year_onetimer_bills,SUM(1_year_repeater_bills)1_year_repeater_bills  
FROM dummy.mobile_level_data
WHERE  last_shopped_store IN (
    'JAI001','MUM109','MUM107','PUN032','PUN033','BAN111','DEL158','BAN112','CHE110',
    'BAN110','PUB005','HYD059','ODI036','ASM009','NAG002','KOL286','KER017','KOT002',
    'KOL287','KOL267','KOL279','GUJ016','MDP019','BAN117','DEL161','DEL162','KOL290',
    'HYD058','KER019','HYD061','AGR003','HUB001','JAI005','KER020','DEL160','AGR001',
    'AMR001','PUN037','HYD060','DEL163','BAN116','AGR002','KOL291','PUB006','MUM111',
    'BAN119','ASM011','BAN118','ASM012','ASM010','DEL168','PUN036','DEL166','KOL278',
    'PUN038','DEL165','AMR002','DEL169','HYD062','KOL292','JAM001','PUB007','MUM112',
    'JAI006','VIS002','DEL167','VIJ002','KOL288','CHE111','KOL293','DEL170','KOL295',
    'HYD065','DIM001','VIJ003','KER023','KER021','DEL173','HUB002','GAN001','GAN002',
    'KOL297','DEL171','HYD057','COI009','JAI007','DEL176','HYD067','AMR003','PUN040',
    'KOL296','JAM002','BIH014','JAL009','BIH013','AMR004','DEL179','GOA017','BAR001',
    'HYD068','COI010'
) 
GROUP BY 1;


SELECT last_shopped_store,
CASE
WHEN recency>0 AND recency<=90 THEN '0-90'
WHEN recency>90 AND recency<=180 THEN '90-180' 
WHEN recency>240 AND recency<=270 THEN '180-270'
WHEN recency>270 AND recency<=360 THEN '270-360'
WHEN recency>360 THEN '>360' END recency,
SUM(1_year_onetimer_sales)1_year_onetimer_sales,
SUM(1_year_repeater_sales)1_year_repeater_sales,
SUM(1_year_onetimer_bills)1_year_onetimer_bills,SUM(1_year_repeater_bills)1_year_repeater_bills  
FROM dummy.mobile_level_data
WHERE  last_shopped_store IN (
    'JAI001','MUM109','MUM107','PUN032','PUN033','BAN111','DEL158','BAN112','CHE110',
    'BAN110','PUB005','HYD059','ODI036','ASM009','NAG002','KOL286','KER017','KOT002',
    'KOL287','KOL267','KOL279','GUJ016','MDP019','BAN117','DEL161','DEL162','KOL290',
    'HYD058','KER019','HYD061','AGR003','HUB001','JAI005','KER020','DEL160','AGR001',
    'AMR001','PUN037','HYD060','DEL163','BAN116','AGR002','KOL291','PUB006','MUM111',
    'BAN119','ASM011','BAN118','ASM012','ASM010','DEL168','PUN036','DEL166','KOL278',
    'PUN038','DEL165','AMR002','DEL169','HYD062','KOL292','JAM001','PUB007','MUM112',
    'JAI006','VIS002','DEL167','VIJ002','KOL288','CHE111','KOL293','DEL170','KOL295',
    'HYD065','DIM001','VIJ003','KER023','KER021','DEL173','HUB002','GAN001','GAN002',
    'KOL297','DEL171','HYD057','COI009','JAI007','DEL176','HYD067','AMR003','PUN040',
    'KOL296','JAM002','BIH014','JAL009','BIH013','AMR004','DEL179','GOA017','BAR001',
    'HYD068','COI010'
) 
GROUP BY 1,2
ORDER BY recency;



SELECT last_shopped_store,
CASE
WHEN recency>0 AND recency<=90 THEN '0-90'
WHEN recency>90 AND recency<=180 THEN '90-180' 
WHEN recency>240 AND recency<=270 THEN '180-270'
WHEN recency>270 AND recency<=360 THEN '270-360'
WHEN recency>360 THEN '>360' END recency,customer_type,COUNT(DISTINCT mobile)cusotmer 
FROM dummy.mobile_level_data
WHERE  last_shopped_store IN (
    'JAI001','MUM109','MUM107','PUN032','PUN033','BAN111','DEL158','BAN112','CHE110',
    'BAN110','PUB005','HYD059','ODI036','ASM009','NAG002','KOL286','KER017','KOT002',
    'KOL287','KOL267','KOL279','GUJ016','MDP019','BAN117','DEL161','DEL162','KOL290',
    'HYD058','KER019','HYD061','AGR003','HUB001','JAI005','KER020','DEL160','AGR001',
    'AMR001','PUN037','HYD060','DEL163','BAN116','AGR002','KOL291','PUB006','MUM111',
    'BAN119','ASM011','BAN118','ASM012','ASM010','DEL168','PUN036','DEL166','KOL278',
    'PUN038','DEL165','AMR002','DEL169','HYD062','KOL292','JAM001','PUB007','MUM112',
    'JAI006','VIS002','DEL167','VIJ002','KOL288','CHE111','KOL293','DEL170','KOL295',
    'HYD065','DIM001','VIJ003','KER023','KER021','DEL173','HUB002','GAN001','GAN002',
    'KOL297','DEL171','HYD057','COI009','JAI007','DEL176','HYD067','AMR003','PUN040',
    'KOL296','JAM002','BIH014','JAL009','BIH013','AMR004','DEL179','GOA017','BAR001',
    'HYD068','COI010'
) 
GROUP BY 1,2,3
ORDER BY recency;

SELECT MIN(txndate), MAX(txndate) 
FROM txn_report_accrual_redemption;

SELECT * FROM dummy.mobile_level_data

