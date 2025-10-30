
CREATE TABLE dummy.repeater_recency
SELECT mobile,`total spends`,`Total Transactions`,
AvailablePoints,recency,latency,latency/NULLIF(recency,0) AS propensity,
1_year_sales,1_year_bills 
FROM program_single_view
-- where `Total Visits`>1

;#select 7476715 - 7446694

ALTER TABLE dummy.repeater_recency ADD INDEX mobile(mobile),ADD COLUMN last_shopped_date DATE,ADD COLUMN last_shopped_store VARCHAR(200);

UPDATE dummy.repeater_recency a JOIN program_single_view b USING(mobile)
SET a.last_shopped_date=b.`last shopped date`,
a.last_shopped_store=b.`last shopped store`;#7446694
ALTER TABLE dummy.repeater_recency ADD COLUMN `Total Visits` VARCHAR(200);

UPDATE dummy.repeater_recency a JOIN program_single_view b USING(mobile)
SET a.`Total Visits`=b.`Total Visits`;#7476715


SELECT * FROM dummy.repeater_recency 

SELECT CASE WHEN propensity >=0.8 THEN 'High'
WHEN propensity <0.8 AND propensity>=0.6 THEN 'Medium'
WHEN propensity <0.6 THEN 'Low' END propensity,
CASE
WHEN AvailablePoints<=50 THEN '<50'
WHEN AvailablePoints>50 AND AvailablePoints<=100 THEN '50-100'
WHEN AvailablePoints>100 THEN '100' END AvailablePoints,COUNT(DISTINCT mobile)customer,SUM(`total spends`)sales,SUM(`Total Transactions`)bills,SUM(1_year_sales)1_sales,
SUM(1_year_bills)1_bills
FROM dummy.repeater_recency
WHERE `Total Visits`>1 AND recency<=180
GROUP BY 1,2;



SELECT CASE WHEN `Total Visits`<=2 THEN `Total Visits` END visit,COUNT(DISTINCT mobile) FROM dummy.repeater_recency 
GROUP BY 1

SELECT COUNT(DISTINCT mobile) FROM dummy.repeater_recency 
WHERE last_shopped_date BETWEEN '2024-10-13' AND '2024-11-03'
AND `Total Visits`>1 AND recency>180;#66941

SELECT *  FROM dummy.repeater_recency

SELECT COUNT(DISTINCT mobile) FROM dummy.repeater_recency 
WHERE `Total Visits`>1 AND recency>180
AND AvailablePoints<50
AND mobile NOT IN (SELECT DISTINCT mobile FROM dummy.repeater_recency WHERE last_shopped_date BETWEEN '2024-10-13' AND '2024-11-03');#697489


SELECT COUNT(DISTINCT mobile) FROM dummy.repeater_recency 
WHERE 
-- last_shopped_date BETWEEN '2024-10-13' AND '2024-11-03'
-- AND 
`Total Visits`>1 AND recency>180
AND AvailablePoints>=50
AND mobile NOT IN (SELECT DISTINCT mobile FROM dummy.repeater_recency WHERE last_shopped_date BETWEEN '2024-10-13' AND '2024-11-03');#66933



SELECT COUNT(DISTINCT mobile) FROM dummy.repeater_recency 
WHERE last_shopped_date BETWEEN '2024-10-13' AND '2024-11-03'
AND `Total Visits`=1 AND recency>180;#66941

SELECT *  FROM dummy.repeater_recency;

SELECT COUNT(DISTINCT mobile) FROM dummy.repeater_recency 
WHERE `Total Visits`=1 AND recency>180
AND AvailablePoints<50
AND mobile NOT IN (SELECT DISTINCT mobile FROM dummy.repeater_recency WHERE last_shopped_date BETWEEN '2024-10-13' AND '2024-11-03');#697489


SELECT COUNT(DISTINCT mobile) FROM dummy.repeater_recency 
WHERE 
-- last_shopped_date BETWEEN '2024-10-13' AND '2024-11-03'
-- AND 
`Total Visits`=1 AND recency>180
AND AvailablePoints>=50
AND mobile NOT IN (SELECT DISTINCT mobile FROM dummy.repeater_recency WHERE last_shopped_date BETWEEN '2024-10-13' AND '2024-11-03');#66933



SELECT COUNT(DISTINCT mobile) FROM dummy.repeater_recency 
WHERE 
-- last_shopped_date BETWEEN '2024-10-13' AND '2024-11-03'
-- AND 
`Total Visits`=1 AND recency<=180
AND AvailablePoints>=50
AND mobile NOT IN (SELECT DISTINCT mobile FROM dummy.repeater_recency WHERE last_shopped_date BETWEEN '2024-10-13' AND '2024-11-03');#66933

SELECT COUNT(DISTINCT mobile) FROM dummy.repeater_recency 
WHERE 
-- last_shopped_date BETWEEN '2024-10-13' AND '2024-11-03'
-- AND 
`Total Visits`=1 AND recency<=180
AND AvailablePoints<50
AND mobile NOT IN (SELECT DISTINCT mobile FROM dummy.repeater_recency WHERE last_shopped_date BETWEEN '2024-10-13' AND '2024-11-03');#66933




SELECT 
    COUNT(DISTINCT a.mobile) AS customers
FROM txn_report_accrual_redemption a
JOIN dummy.hr_Details_of_comp_new_outlet_23sep2025_Prakriti_1 b 
     ON a.storecode = b.outlet_code
WHERE 
a.txndate <= '2025-09-21'
  AND 
  a.storecode NOT LIKE '%demo%'
  AND a.billno NOT LIKE '%test%'
  AND a.billno NOT LIKE '%roll%'
  AND a.storecode NOT LIKE '%Corporate%'
  AND b.type = 'Highways'
  -- AND a.mobile NOT IN (
--         SELECT DISTINCT a2.mobile
--         FROM txn_report_accrual_redemption a2
--         JOIN dummy.hr_Details_of_comp_new_outlet_23sep2025_Prakriti b2 
--              ON a2.storecode = b2.outlet_code
--         WHERE 
--         a2.txndate <= '2025-09-21'
--           AND 
--           b2.type <> 'Highways'
--     )
;



#########################
INSERT INTO dummy.highy_nonhighyway

    SELECT 
        a.mobile,
        MAX(CASE WHEN b.type = 'Highways' THEN 1 ELSE 0 END) AS shopped_highways,
        MAX(CASE WHEN b.type <> 'Highways' THEN 1 ELSE 0 END) AS shopped_non_highways
    FROM txn_report_accrual_redemption a
    JOIN dummy.hr_Details_of_comp_new_outlet_23sep2025_Prakriti_1 b 
         ON a.storecode = b.outlet_code
    WHERE a.txndate <= '2025-09-21'
      AND a.storecode NOT LIKE '%demo%'
      AND a.billno NOT LIKE '%test%'
      AND a.billno NOT LIKE '%roll%'
      AND a.storecode NOT LIKE '%Corporate%' 
    GROUP BY a.mobile;#7268190

SELECT COUNT(*) AS customers
FROM dummy.highy_nonhighyway
WHERE shopped_highways = 1
  AND shopped_non_highways = 0;

###############################################

SELECT * FROM dummy.hr_Details_of_comp_new_outlet_23sep2025_Prakriti;


SELECT 
    COUNT(DISTINCT a.mobile) AS customers
FROM txn_report_accrual_redemption a
JOIN dummy.hr_Details_of_comp_new_outlet_23sep2025_Prakriti_1 b 
     ON a.storecode = b.outlet_code
WHERE 
a.txndate <= '2025-09-21'
  AND a.storecode NOT LIKE '%demo%'
  AND a.billno NOT LIKE '%test%'
  AND a.billno NOT LIKE '%roll%'
  AND a.storecode NOT LIKE '%Corporate%'
  AND a.mobile IN (
        -- customers who shopped at Highways
        SELECT DISTINCT a1.mobile
        FROM txn_report_accrual_redemption a1
        JOIN dummy.hr_Details_of_comp_new_outlet_23sep2025_Prakriti_1 b1 
             ON a1.storecode = b1.outlet_code
        WHERE a1.txndate <= '2025-09-21'
          AND b1.type = 'Highways'
    )
  AND a.mobile IN (
        -- customers who shopped at Non-Highways
        SELECT DISTINCT a2.mobile
        FROM txn_report_accrual_redemption a2
        JOIN dummy.hr_Details_of_comp_new_outlet_23sep2025_Prakriti_1 b2 
             ON a2.storecode = b2.outlet_code
        WHERE a2.txndate <= '2025-09-21'
          AND b2.type <> 'Highways'
    );#P2_=824442

 
 
 
--  e. How many of those customers didn't come after Oct'24
-- f. How many of them did repeat again

INSERT INTO dummy.oct_data
SELECT DISTINCT mobile FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2024-10-01' AND '2024-10-31'
AND storecode NOT LIKE '%demo%'
AND billno NOT LIKE '%test%'
AND billno NOT LIKE '%roll%'
AND storecode NOT LIKE '%Corporate%';#1083755
  

SELECT  COUNT(DISTINCT mobile)customer,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills 
FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2024-10-01' AND '2024-10-31'
AND storecode NOT LIKE '%demo%'
AND billno NOT LIKE '%test%'
AND billno NOT LIKE '%roll%'
AND storecode NOT LIKE '%Corporate%'
AND mobile NOT IN (
        SELECT DISTINCT b.mobile
        FROM txn_report_accrual_redemption b
        WHERE txndate > '2024-10-31'
          AND storecode NOT LIKE '%demo%'
          AND billno NOT LIKE '%test%'
          AND billno NOT LIKE '%roll%'
          AND storecode NOT LIKE '%Corporate%')
  ;
  
  
  SELECT * FROM dummy.oct_data a JOIN txn_report_accrual_redemption b ;
  ###################################################
  
  
  
  WITH festival_shoppers AS (
    SELECT DISTINCT mobile
    FROM txn_report_accrual_redemption a JOIN
    WHERE txndate BETWEEN '2024-10-01' AND '2024-11-03'
),
base AS (
    SELECT 
        p.mobile,
        p.recency,
        p.latency,
        b.availablepoints,
        p.`Total visits`,
        p.`Total Spends`,
        p.`Total Transactions`,
        b.smsreachability,
        n.mobile AS festival_flag,
        -- Precompute propensity safely
        CASE 
            WHEN p.`Total visits` = 1 THEN 0
            ELSE p.latency / NULLIF(p.recency,0)
        END AS propensity
    FROM program_single_view p
    JOIN member_report b USING(mobile)
    LEFT JOIN festival_shoppers n ON p.mobile = n.mobile
    WHERE p.`last shopped store` NOT IN ('demo','corporate') AND p.enrolledstore NOT IN ('demo','corporate') 
      AND b.smsreachability = 'True'
      AND p.`last shopped store` IN (SELECT outlet_code FROM dummy.hr_Details_of_comp_new_outlet_23sep2025_Prakriti WHERE `new/old`='comp')
)
SELECT * FROM dummy.hr_Details_of_comp_new_outlet_23sep2025_Prakriti
SELECT 
    CASE 
        WHEN recency >=0 AND recency<=30 THEN '0-30'
        WHEN recency >30 AND recency<=45 THEN '31-45'
        WHEN recency >45 AND recency<=60 THEN '46-60'
        WHEN recency >60 AND recency<=90 THEN '61-90'
        WHEN recency >90 AND recency<=180 THEN '91-180'
        WHEN recency >180 AND recency<=365 THEN '181-365' 
        WHEN recency>365 THEN '>365'
    END recency_bucket,

    CASE 
        WHEN availablepoints =0 THEN '0'
        WHEN availablepoints>0 AND availablepoints <=25 THEN '0-25'
        WHEN availablepoints>25 AND availablepoints<=50 THEN '25-50'
        WHEN availablepoints>50 AND availablepoints<=100 THEN '50-100'
        WHEN availablepoints>100 AND availablepoints<=200 THEN '100-200'
        WHEN availablepoints>200 AND availablepoints<=500 THEN '200-500'
        WHEN availablepoints>500 AND availablepoints<=1000 THEN '500-1000'
        WHEN availablepoints>1000 THEN '>1000'
    END Available_Points,

    CASE 
        WHEN `Total visits` = 1 THEN 'onetimer' 
        WHEN `Total visits` > 1 THEN 'repeater' 
    END AS frequency,

    CASE 
        WHEN `Total visits` = 1 THEN '0'
        WHEN propensity >= 0.8 THEN 'High'
        WHEN propensity <0.8 AND propensity >=0.6 THEN 'Medium'
        WHEN propensity < 0.6 THEN 'Low'
    END AS propensity_bucket,

    CASE 
        WHEN festival_flag IS NOT NULL THEN 1 ELSE 0 
    END AS festival_flag,

    COUNT(DISTINCT mobile) AS customer,
    SUM(`Total Spends`) AS sales,
    SUM(`Total Transactions`) AS bills
FROM base
GROUP BY 1,2,3,4,5;






##############################



CREATE TABLE dummy.only_highway_customer
SELECT 
   a.mobile,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills,
   DATEDIFF('2025-09-21',MAX(txndate))recency,CASE WHEN frequencycount>1 THEN 'repeater' ELSE 'ontimer' END
    FROM txn_report_accrual_redemption a
JOIN dummy.hr_Details_of_comp_new_outlet_23sep2025_Prakriti_1 b 
     ON a.storecode = b.outlet_code
WHERE 
a.txndate <= '2025-09-21'
  AND a.storecode NOT LIKE '%demo%'
  AND a.billno NOT LIKE '%test%'
  AND a.billno NOT LIKE '%roll%'
  AND a.storecode NOT LIKE '%Corporate%'
  AND a.mobile IN (
        -- customers who shopped at Highways
        SELECT DISTINCT a1.mobile
        FROM txn_report_accrual_redemption a1
        JOIN dummy.hr_Details_of_comp_new_outlet_23sep2025_Prakriti_1 b1 
             ON a1.storecode = b1.outlet_code
        WHERE a1.txndate <= '2025-09-21'
          AND b1.type = 'Highways'
    )
  AND a.mobile IN (
        -- customers who shopped at Non-Highways
        SELECT DISTINCT a2.mobile
        FROM txn_report_accrual_redemption a2
        JOIN dummy.hr_Details_of_comp_new_outlet_23sep2025_Prakriti_1 b2 
             ON a2.storecode = b2.outlet_code
        WHERE a2.txndate <= '2025-09-21'
          AND b2.type <> 'Highways'
    );
    
    
    
 CREATE TABLE dummy.only_highywayshoppers_1  
    SELECT 
    mobile,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills,DATEDIFF('2025-09-21',MAX(txndate))recency,
    CASE WHEN frequencycount>1 THEN 'repeater' ELSE 'onetimer' END customer_type
FROM txn_report_accrual_redemption a
JOIN dummy.hr_Details_of_comp_new_outlet_23sep2025_Prakriti_1 b 
     ON a.storecode = b.outlet_code
WHERE a.txndate <='2025-09-21'
  AND a.storecode NOT LIKE '%demo%'
  AND a.billno NOT LIKE '%test%'
  AND a.billno NOT LIKE '%roll%'
  AND a.storecode NOT LIKE '%Corporate%'
  AND a.mobile NOT IN (
        -- exclude anyone who also shopped at Non-Highways
        SELECT DISTINCT a2.mobile
        FROM txn_report_accrual_redemption a2
        JOIN dummy.hr_Details_of_comp_new_outlet_23sep2025_Prakriti_1 b2 
             ON a2.storecode = b2.outlet_code
        WHERE a2.txndate <='2025-09-21'
          AND b2.type <> 'Highways'
    )
  AND b.type = 'Highways'
  GROUP BY 1;



SELECT * FROM dummy.oct_24_base b
WHERE b.mobile NOT IN (
    SELECT DISTINCT mobile
    FROM txn_report_accrual_redemption
    WHERE txndate > '2024-10-31'
      AND storecode NOT LIKE '%demo%' 
      AND billno NOT LIKE '%test%' 
      AND billno NOT LIKE '%roll%'
      AND storecode NOT LIKE '%Corporate%'
);


ALTER TABLE dummy.oct_24_base ADD INDEX mobile(mobile),ADD COLUMN last_shopped_date VARCHAR(100),ADD COLUMN last_shopped_store VARCHAR(100);


UPDATE dummy.oct_24_base a JOIN (
SELECT  mobile,MAX(txndate)last_shopped_date FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2024-10-01' AND '2024-10-31'
GROUP BY 1)b USING(mobile)
SET a.last_shopped_date=b.last_shopped_date;#1083755

UPDATE dummy.oct_24_base a JOIN txn_report_accrual_redemption b ON a.mobile=b.mobile AND a.last_shopped_date=b.txndate
SET a.last_shopped_store=b.storecode
WHERE txndate BETWEEN '2024-10-01' AND '2024-10-31';#1083755

ALTER TABLE dummy.oct_24_base ADD COLUMN itemdescription VARCHAR(200),ADD COLUMN categoryname VARCHAR(100);
ALTER TABLE dummy.oct_24_base ADD COLUMN uniqueitemcode VARCHAR(200);


SELECT DISTINCT txnmappedmobile,uniquebillno 
FROM sku_report_loyalty a JOIN dummy.oct_24_base b 
ON b.last_shopped_store=b.modifiedstorecode AND b.last_shopped_date=a.modifiedtxndate
WHERE modifiedtxndate BETWEEN '2024-10-01' AND '2024-10-31'




WITH  base_data AS
(SELECT DISTINCT mobile
FROM `haldirams`.txn_report_accrual_redemption a JOIN 
dummy.hr_Details_of_comp_new_outlet_23sep2025_Prakriti b 
ON a.storecode=b.Outlet_Code
WHERE txndate BETWEEN '2024-10-01' AND '2024-10-31'
-- AND b.`New/old`='Comp'
AND storecode NOT LIKE '%demo%' 
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
AND storecode NOT LIKE '%Corporate%'
),
txn_base AS
(
SELECT DISTINCT mobile FROM txn_report_accrual_redemption WHERE 
txndate >'2024-10-31'
AND storecode NOT LIKE '%demo%' 
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
AND storecode NOT LIKE '%Corporate%')
 -- 
-- SELECT COUNT(DISTINCT mobile) FROM base_data
-- where mobile not in (select mobile from  txn_base);
SELECT COUNT(DISTINCT a.mobile) FROM base_data a JOIN  
txn_base b
USING(mobile);

SELECT COUNT(*) FROM dummy.oct_24_base a 

INSERT INTO dummy.didnot_repeat 
SELECT DISTINCT mobile FROM dummy.oct_24_base
WHERE mobile NOT IN (
SELECT DISTINCT mobile FROM txn_report_accrual_redemption 
WHERE txndate >'2024-10-31'
AND storecode NOT LIKE '%demo%' 
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
AND storecode NOT LIKE '%Corporate%'
)#396043

ALTER TABLE dummy.didnot_repeat  ADD INDEX mobile(mobile),ADD COLUMN sales FLOAT,ADD COLUMN bills INT

UPDATE dummy.didnot_repeat a JOIN (
SELECT mobile,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2024-10-01' AND '2024-10-31'
AND storecode NOT LIKE '%demo%' 
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
AND storecode NOT LIKE '%Corporate%'
GROUP BY 1)b USING(mobile)
SET a.sales=b.sales,a.bills=b.bills;#396043


WITH base AS (
SELECT txnmappedmobile,uniqueitemcode,itemdescription,categoryname,itemnetamount,uniquebillno,itemqty 
FROM sku_report_loyalty a JOIN item_master b USING(uniqueitemcode)
WHERE modifiedtxndate BETWEEN '2024-10-01' AND '2024-10-31'
AND modifiedstorecode NOT LIKE '%demo%' 
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
AND modifiedstorecode NOT LIKE '%Corporate%'
AND txnmappedmobile IN (SELECT DISTINCT mobile FROM dummy.didnot_repeat)
)
SELECT itemdescription,COUNT(DISTINCT txnmappedmobile)customers,
SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills ,SUM(itemqty)qty
FROM base
GROUP BY 1;



    SELECT 
    COUNT(DISTINCT mobile)customer
FROM txn_report_accrual_redemption a
JOIN dummy.hr_Details_of_comp_new_outlet_23sep2025_Prakriti_1 b 
     ON a.storecode = b.outlet_code
WHERE a.txndate <='2025-09-21'
  AND a.storecode NOT LIKE '%demo%'
  AND a.billno NOT LIKE '%test%'
  AND a.billno NOT LIKE '%roll%'
  AND a.storecode NOT LIKE '%Corporate%'
  AND a.mobile NOT IN (
        -- exclude anyone who also shopped at Non-Highways
        SELECT DISTINCT a2.mobile
        FROM txn_report_accrual_redemption a2
        JOIN dummy.hr_Details_of_comp_new_outlet_23sep2025_Prakriti_1 b2 
             ON a2.storecode = b2.outlet_code
        WHERE a2.txndate <='2025-09-21'
          AND b2.type <> 'Highways'
    )
  AND b.type = 'Highways';

