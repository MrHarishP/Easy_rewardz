####################################################################################################################
####################################################################################################################
-- ATV Band 
SELECT CASE WHEN ATV <=250 THEN 'upto 250'
WHEN ATV>250 AND ATV <=500 THEN '250-500'
WHEN ATV>500 AND ATV <=750 THEN '500-750'
WHEN ATV>750 AND ATV<=1000 THEN '750-1000'
WHEN ATV>1000 AND ATV<=1250 THEN '1000-1250'
WHEN ATV>1250 AND ATV<=1500 THEN '1250-1500'
WHEN ATV>1500 AND ATV<=1750 THEN '1500-1750'
WHEN ATV>1750 AND ATV<=2000 THEN '1750-2000'
WHEN ATV>2000 AND ATV<=2250 THEN '2000-2250'
WHEN ATV>2250 AND ATV<=2500 THEN '2250-2500'
WHEN ATV>2500 THEN 'more than 2500'
END AS ATV_band,COUNT(mobile)AS customers,SUM(bills) AS bills,SUM(sales) AS sales
FROM (
SELECT mobile,COUNT(DISTINCT uniquebillno) AS bills,SUM(amount) AS sales,
SUM(amount)/COUNT(DISTINCT uniquebillno) AS ATV
FROM `haldirams`.txn_report_accrual_redemption
WHERE insertiondate<'2025-10-15'
AND txndate BETWEEN '2025-09-01' AND '2025-09-30'
AND storecode<>'demo'
AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
GROUP BY 1)a
GROUP BY 1
ORDER BY ATV;


-- QC
SELECT COUNT(DISTINCT uniquebillno) AS bills,SUM(amount) AS sales,
SUM(amount)/COUNT(DISTINCT uniquebillno) AS ATV
FROM `haldirams`.txn_report_accrual_redemption
WHERE insertiondate<'2025-10-15'
AND txndate BETWEEN '2025-09-01' AND '2025-09-30'
AND storecode<>'demo'
AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%';



##
WITH customer_atv AS (
    SELECT 
        mobile,
        COUNT(DISTINCT uniquebillno) AS bills,
        SUM(amount) AS sales,
        SUM(amount) / COUNT(DISTINCT uniquebillno) AS ATV
    FROM haldirams.txn_report_accrual_redemption
    WHERE 
        insertiondate < '2025-08-06'
        AND txndate BETWEEN '2025-07-01' AND '2025-07-31'
        AND storecode <> 'demo'
        AND billno NOT LIKE '%test%' 
        AND billno NOT LIKE '%roll%'
    GROUP BY mobile
),
banded_customers AS (
    SELECT 
        CASE 
            WHEN ATV <= 250 THEN 'upto 250'
            WHEN ATV <= 500 THEN '250-500'
            WHEN ATV <= 750 THEN '500-750'
            WHEN ATV <= 1000 THEN '750-1000'
            WHEN ATV <= 1250 THEN '1000-1250'
            WHEN ATV <= 1500 THEN '1250-1500'
            WHEN ATV <= 1750 THEN '1500-1750'
            WHEN ATV <= 2000 THEN '1750-2000'
            WHEN ATV <= 2250 THEN '2000-2250'
            WHEN ATV <= 2500 THEN '2250-2500'
            ELSE 'more than 2500'
        END AS ATV_band,
        mobile,
        bills,
        sales
    FROM customer_atv
)
SELECT 
    ATV_band,
    COUNT(mobile) AS customers,
    SUM(bills) AS bills,
    SUM(sales) AS sales
FROM banded_customers
GROUP BY ATV_band
ORDER BY ATV_band 
;





#############################
-- Brand Wise
SELECT brand,
COUNT(DISTINCT storecode) stores,
COUNT(DISTINCT mobile) customers,SUM(sales) sales,
SUM(bills) bills,SUM(Points_collected) issued,SUM(Redeemed) redeemed
FROM
(SELECT mobile,storecode,b.brand,SUM(Amount) AS sales,COUNT(DISTINCT (UniqueBillNo)) AS bills,
MAX(frequencycount) AS maxf, MIN(frequencycount) AS minf,
SUM(pointscollected) AS Points_collected,SUM(pointsspent) AS Redeemed
FROM txn_report_accrual_redemption  a JOIN store_master b
USING(storecode)
WHERE TxnDate BETWEEN '2025-09-01' AND '2025-09-30'
AND storecode<>'demo'
AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND a.insertiondate<'2025-10-15'
GROUP BY 1,2,3)c
GROUP BY 1;

-- QC
SELECT SUM(pointscollected)issued,SUM(pointsspent)redeemed FROM txn_report_accrual_redemption  
WHERE TxnDate BETWEEN '2025-09-01' AND '2025-09-30'
AND storecode<>'demo'
AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND insertiondate<'2025-10-15'

##
SELECT 
    c.brand,
    COUNT(DISTINCT c.storecode) AS stores,
    COUNT(DISTINCT c.mobile) AS customers,
    SUM(c.sales) AS sales,
    SUM(c.bills) AS bills,
    SUM(c.Points_collected) AS issued,
    SUM(c.Redeemed) AS redeemed
FROM (
    SELECT 
        a.mobile,
        a.storecode,
        b.brand,
        SUM(a.Amount) AS sales,
        COUNT(DISTINCT a.UniqueBillNo) AS bills,
        MAX(a.frequencycount) AS maxf,
        MIN(a.frequencycount) AS minf,
        SUM(a.pointscollected) AS Points_collected,
        SUM(a.pointsspent) AS Redeemed
    FROM txn_report_accrual_redemption a
    JOIN store_master b ON a.storecode = b.storecode
    WHERE a.TxnDate BETWEEN '2025-03-01' AND '2025-03-31'
      AND a.storecode <> 'demo'
      AND a.billno NOT LIKE '%test%'
      AND a.billno NOT LIKE '%roll%'
      AND a.insertiondate < '2025-04-07'
    GROUP BY a.mobile, a.storecode, b.brand
) AS c
GROUP BY c.brand;




-- Overall
SELECT COUNT(DISTINCT storecode) stores,COUNT(DISTINCT mobile) customers,SUM(sales) sales,
SUM(bills) bills,SUM(Points_collected) issued,SUM(Redeemed) redeemed
FROM
(SELECT mobile,storecode,b.brand,SUM(Amount) AS sales,COUNT(DISTINCT (UniqueBillNo)) AS bills,
MAX(frequencycount) AS maxf, MIN(frequencycount) AS minf,
SUM(pointscollected) AS Points_collected,SUM(pointsspent) AS Redeemed
FROM txn_report_accrual_redemption  a JOIN store_master b
USING(storecode)
WHERE TxnDate BETWEEN '2025-09-01' AND '2025-09-30'
AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND a.insertiondate<'2025-10-15' AND storecode<>'demo'
GROUP BY 1,2,3)c;

#####################################################################################################################


-- Loyalty Sales & Loyalty Bills from txn table
SELECT MONTHNAME(txndate) MONTH,CASE WHEN storecode='ecom' THEN "online" ELSE "offline" END AS storetype,
COUNT(DISTINCT uniquebillno) loyaltybills,SUM(amount) loyaltysales
FROM txn_report_accrual_redemption 
WHERE TxnDate BETWEEN '2025-08-01' AND '2025-09-30'
AND insertiondate< '2025-10-15'
AND storecode NOT LIKE 'demo' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
GROUP BY 1,2;

-- Overall
SELECT MONTHNAME(txndate) MONTH, 'Overall'storetype,
COUNT(DISTINCT uniquebillno) loyaltybills,SUM(amount) loyaltysales
FROM txn_report_accrual_redemption 
WHERE TxnDate BETWEEN '2025-08-01' AND '2025-09-30'
AND insertiondate< '2025-10-15'
AND storecode NOT LIKE 'demo' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
GROUP BY 1;

-- NonLoyalty Sales  Non Loyalty bills
SELECT MONTHNAME(modifiedtxndate) MONTH,-- 
CASE WHEN modifiedstorecode='ecom' THEN "online" ELSE "offline" END AS storetype,
COUNT(DISTINCT uniquebillno) Nonloyaltybills,SUM(itemnetamount) Nonloyaltysales
FROM Sku_report_nonloyalty 
WHERE modifiedTxnDate BETWEEN '2025-08-01' AND '2025-09-30'
AND insertiondate< '2025-10-15'
AND modifiedstorecode NOT LIKE 'demo' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
GROUP BY 1
,
2;



###################################################################################################################

-- MOM KPI
SELECT TxnMonth, TxnYear,COUNT(Mobile)Transacting_Customers,
COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN Mobile END)OneTimer,
COUNT(DISTINCT CASE WHEN maxf>1 THEN Mobile END) Repeater,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END) AS onetimer_Sales,
SUM(CASE WHEN maxf>1 THEN sales END) AS Repeat_Sales,
SUM(sales)sales,
SUM(CASE WHEN maxf=1 AND minf=1 THEN bills END) AS onetimer_Bills,
SUM(CASE WHEN maxf>1 THEN bills END) AS Repeat_Bills,
SUM(bills) AS bills,
SUM(sales)/SUM(bills) AS ATV,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END)/SUM(CASE WHEN maxf=1 AND minf=1 THEN bills END) Onetimer_ATV,
SUM(CASE WHEN maxf>1 THEN sales END)/SUM(CASE WHEN maxf>1 THEN bills END) AS Repeat_ATV,
AVG(visits),
SUM(points_collected) AS Transaction_Points_issued,SUM(redeemed) AS Points_redeemed,
SUM(redeemer) redeemers,
SUM(redemption_sales) AS redemption_sales,
SUM(redemption_bills) AS redemption_bills
FROM (SELECT Mobile, TxnMonth,TxnYear ,SUM(Amount) AS sales,COUNT(DISTINCT (UniqueBillNo)) AS bills,
MAX(frequencycount) AS maxf, MIN(frequencycount) AS minf,COUNT(DISTINCT txndate) visits,
SUM(pointscollected) AS Points_collected,SUM(pointsspent) AS Redeemed,
COUNT(DISTINCT CASE WHEN pointsspent>0 THEN mobile END) AS redeemer,
COUNT(DISTINCT CASE WHEN pointsspent>0 THEN uniquebillno END) AS redemption_bills,
SUM(CASE WHEN pointsspent>0 THEN amount END) AS redemption_sales
FROM `haldirams`.txn_report_accrual_redemption 
WHERE TxnDate BETWEEN  '2024-08-01' AND '2025-09-30'
AND storecode NOT LIKE '%demo%' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
GROUP BY 1,2,3)a GROUP BY 1,2;


-- Store Count
SELECT MONTHNAME(txndate)MONTH,YEAR(txndate)YEAR ,COUNT(DISTINCT storecode) stores FROM 
`haldirams`.txn_report_accrual_redemption 
WHERE TxnDate BETWEEN  '2024-08-01' AND '2025-09-30'
AND storecode NOT LIKE '%demo%' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
GROUP BY 1,2;

-- Enrollments
SELECT MONTHNAME(modifiedenrolledon)MONTH,YEAR(modifiedenrolledon)YEAR,COUNT(mobile) FROM member_report
WHERE modifiedenrolledon BETWEEN  '2024-08-01' AND '2025-09-30'
AND enrolledstorecode NOT IN ('demo','qrcode')
GROUP BY 1,2;


####################################################################################################################
-- -- Overall day on Day
SELECT 
DAY,
COUNT(DISTINCT txnmappedmobile) customers,
SUM(sales) AS sales,
COUNT(CASE WHEN maxf>1 THEN txnmappedmobile END) repeaters,
SUM(itemqty) itemqty,
SUM(CASE WHEN maxf>1 THEN sales END) repeater_sales,
SUM(bills) bills,
SUM(sales)/SUM(itemqty) AS ASP
FROM
(SELECT txnmappedmobile,DAYNAME(modifiedtxndate) DAY,
MAX(frequencycount) AS maxf, 
MIN(frequencycount) AS minf,
SUM(itemqty) AS itemqty,
COUNT(DISTINCT UniqueBillNo) AS bills,
SUM(itemnetamount) sales
FROM `haldirams`.Sku_report_loyalty 
WHERE modifiedTxnDate BETWEEN '2025-09-01' AND '2025-09-30' 
AND storecode NOT LIKE '%demo%' 
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
 AND DAYNAME(modifiedtxndate) NOT IN ('saturday','sunday')
GROUP BY 1,2)b
GROUP BY 1
;

-- Day Wise 
SELECT 
PERIOD,	
COUNT(DISTINCT txnmappedmobile) customers,
SUM(sales) AS sales,
COUNT(CASE WHEN maxf>1 THEN txnmappedmobile END) repeaters,
SUM(itemqty) itemqty,
SUM(CASE WHEN maxf>1 THEN sales END) repeater_sales,
SUM(bills) bills,
SUM(sales)/SUM(itemqty) AS ASP
FROM
(SELECT 
CASE 
	WHEN DAYNAME(modifiedtxndate) IN ('saturday','sunday') THEN 'weekend'
	WHEN DAYNAME(modifiedtxndate) NOT IN ('saturday','sunday') THEN 'weekdays' 
END PERIOD,
txnmappedmobile,DAYNAME(modifiedtxndate) DAY,
MAX(frequencycount) AS maxf, 
MIN(frequencycount) AS minf,
SUM(itemqty) AS itemqty,
COUNT(DISTINCT UniqueBillNo) AS bills,
SUM(itemnetamount) sales
FROM `haldirams`.Sku_report_loyalty 
WHERE modifiedTxnDate BETWEEN '2025-09-01' AND '2025-09-30' 
AND storecode NOT LIKE '%demo%' 
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
AND ((DAYNAME(modifiedtxndate) NOT IN ('saturday','sunday'))
OR (DAYNAME(modifiedtxndate) IN ('saturday','sunday')))
AND insertiondate<'2025-10-15'
GROUP BY 1,2,3)b
GROUP BY 1;




-- day wise overall
-- Day Wise
SELECT 
COUNT(DISTINCT txnmappedmobile) customers,
SUM(sales) AS sales,
COUNT(CASE WHEN maxf>1 THEN txnmappedmobile END) repeaters,
SUM(itemqty) itemqty,
SUM(CASE WHEN maxf>1 THEN sales END) repeater_sales,
SUM(bills) bills,
SUM(sales)/SUM(itemqty) AS ASP
FROM
(SELECT 
txnmappedmobile,DAYNAME(modifiedtxndate) DAY,
MAX(frequencycount) AS maxf, 
MIN(frequencycount) AS minf,
SUM(itemqty) AS itemqty,
COUNT(DISTINCT UniqueBillNo) AS bills,
SUM(itemnetamount) sales
FROM `haldirams`.Sku_report_loyalty 
WHERE modifiedTxnDate BETWEEN '2025-09-01' AND '2025-09-30' 
AND storecode NOT LIKE '%demo%' 
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
-- AND (DAYNAME(modifiedtxndate) NOT IN ('saturday','sunday'))
-- and (DAYNAME(modifiedtxndate) IN ('saturday','sunday'))
AND insertiondate<'2025-10-15'
GROUP BY 1,2)b;

####################################################################################################################

-- Store Wise
SELECT brand,storecode,LpaasStore,COUNT(DISTINCT mobile) customers,
COUNT(CASE WHEN maxf>1 THEN mobile END) repeaters,
SUM(sales) sales,
SUM(CASE WHEN maxf>1 THEN sales END) repeater_sales,
SUM(bills) bills,SUM(Points_collected) issued,SUM(Redeemed) redeemed
FROM
(SELECT mobile,b.brand,storecode,LpaasStore,SUM(Amount) AS sales,COUNT(DISTINCT (UniqueBillNo)) AS bills,
MAX(frequencycount) AS maxf, MIN(frequencycount) AS minf,
SUM(pointscollected) AS Points_collected,SUM(pointsspent) AS Redeemed
FROM txn_report_accrual_redemption  a LEFT JOIN store_master b
USING(storecode)
WHERE TxnDate BETWEEN '2025-09-01' AND '2025-09-30'
AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND a.insertiondate<'2025-10-15'
GROUP BY 1,2,3)c
GROUP BY 1,2;





WITH store_wise AS
(SELECT mobile,b.brand,storecode,LpaasStore,SUM(Amount) AS sales,COUNT(DISTINCT (UniqueBillNo)) AS bills,
MAX(frequencycount) AS maxf, MIN(frequencycount) AS minf,
SUM(pointscollected) AS Points_collected,SUM(pointsspent) AS Redeemed
FROM txn_report_accrual_redemption  a LEFT JOIN store_master b
USING(storecode)
WHERE TxnDate BETWEEN '2025-06-01' AND '2025-06-30'
AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND a.insertiondate<'2025-07-04'
GROUP BY 1,2,3)
SELECT brand,storecode,LpaasStore,COUNT(DISTINCT mobile) customers,
COUNT(CASE WHEN maxf>1 THEN mobile END) repeaters,
SUM(sales) sales,
SUM(CASE WHEN maxf>1 THEN sales END) repeater_sales,
SUM(bills) bills,SUM(Points_collected) issued,SUM(Redeemed) redeemed
FROM store_wise GROUP BY 1,2;









####################################################################################################################
-- Category Level
SELECT categoryname,departmentname,
COUNT(DISTINCT txnmappedmobile) customers,
SUM(sales) AS sales,
SUM(itemqty) itemqty,
SUM(bills) bills
FROM
(SELECT txnmappedmobile,categoryname,departmentname,
SUM(itemqty) AS itemqty,
COUNT(DISTINCT UniqueBillNo) AS bills,
SUM(itemnetamount) sales
FROM `haldirams`.Sku_report_loyalty  a LEFT JOIN item_master b
USING(uniqueitemcode)
WHERE modifiedTxnDate BETWEEN '2025-09-01' AND '2025-09-30' 
AND storecode NOT LIKE '%demo%' 
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
AND a.insertiondate<'2025-10-15'
GROUP BY 1,2)b
GROUP BY 1;

####################################################################################################################
-- duration of rolling 6 months 

INSERT INTO dummy.HR_Dump_sept25_harish
SELECT mobile,txndate,frequencycount,SUM(amount)sales,COUNT(DISTINCT uniquebillno) bills,
SUM(amount)/COUNT(DISTINCT uniquebillno)
AS ATV
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2025-04-01' AND '2025-09-30'
AND storecode NOT LIKE '%demo%' 
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
AND amount>0 AND insertiondate<'2025-10-15' 
GROUP BY 1,2,3; -- #8629718

SELECT COUNT(*) FROM dummy.HR_Dump_sept25_harish;

ALTER TABLE dummy.HR_Dump_sept25_harish ADD INDEX a(mobile);

SELECT 
CASE WHEN a.ATV > 0 AND a.ATV<=100 THEN "1-100" 
WHEN a.ATV > 100 AND a.ATV<=200 THEN "101-200"
WHEN a.ATV > 200 AND a.ATV<=300 THEN "200-300"
WHEN a.ATV > 300 AND a.ATV<=400 THEN "300-400"
WHEN a.ATV > 400 AND a.ATV<=500 THEN "400-500" 
WHEN a.ATV > 500 AND a.ATV<=600 THEN "500-600" 
WHEN a.ATV > 600 AND a.ATV<=700 THEN "600-700" 
WHEN a.ATV > 700 AND a.ATV<=800 THEN "700-800" 
WHEN a.ATV > 800 AND a.ATV<=900 THEN "800-900" 
WHEN a.ATV > 900 AND a.ATV<=1000 THEN "900-1000" 
WHEN a.ATV > 1000 THEN ">1000"  
END AS 1st_visit_ATV_bucket,
CASE WHEN b.ATV > 0 AND b.ATV<=100 THEN "1-100" 
WHEN b.ATV > 100 AND b.ATV<=200 THEN "101-200"
WHEN b.ATV > 200 AND b.ATV<=300 THEN "200-300"
WHEN b.ATV > 300 AND b.ATV<=400 THEN "300-400"
WHEN b.ATV > 400 AND b.ATV<=500 THEN "400-500" 
WHEN b.ATV > 500 AND b.ATV<=600 THEN "500-600" 
WHEN b.ATV > 600 AND b.ATV<=700 THEN "600-700" 
WHEN b.ATV > 700 AND b.ATV<=800 THEN "700-800" 
WHEN b.ATV > 800 AND b.ATV<=900 THEN "800-900" 
WHEN b.ATV > 900 AND b.ATV<=1000 THEN "900-1000" 
WHEN b.ATV > 1000 THEN ">1000"  
END AS 2nd_visit_ATV_bucket,
COUNT(DISTINCT mobile) customers  FROM 
dummy.HR_Dump_sept25_harish a JOIN dummy.HR_Dump_sept25_harish b
USING(mobile)
WHERE a.frequencycount=1 AND b.frequencycount=2
GROUP BY 1,2
ORDER BY a.atv;

##########################################################################################
-- 12 month running 

-- repeart cohort
DELETE FROM dummy.hr_sept25_NewCustomer_Cohort_Till_harish;
INSERT INTO dummy.hr_sept25_NewCustomer_Cohort_Till_harish
SELECT mobile,MIN(txndate)FirstDate
FROM txn_report_accrual_redemption a
WHERE txndate<='2025-09-30' 
GROUP BY 1;#7542125
 

 
DELETE FROM dummy.hr_sept25_NewCustomer_Cohort_Data_24_25_harish;
INSERT INTO dummy.hr_sept25_NewCustomer_Cohort_Data_24_25_harish
SELECT * FROM dummy.hr_sept25_NewCustomer_Cohort_Till_harish 
WHERE FirstDate BETWEEN '2024-10-01' AND '2025-09-30' ;#4819223
 
ALTER TABLE dummy.hr_sept25_NewCustomer_Cohort_Data_24_25_harish ADD INDEX mobile(mobile);
 
 
SELECT YEAR(a.firstdate)txnyear,MONTHNAME(a.FirstDate)`monthname`,YEAR(b.txndate)SubsequentTxnyear,
MONTHNAME(b.txndate)SubsequentTxnmonth,COUNT(DISTINCT a.mobile)Customer
FROM dummy.hr_sept25_NewCustomer_Cohort_Data_24_25_harish a JOIN txn_report_accrual_redemption  b
ON a.mobile=b.mobile
WHERE b.txndate<='2025-09-30'
#AND 
#Min_f=1  #New_Customer
#Min_f=1 and Max_f=1  #New_Customer(One-Timer)
#Min_f=1 AND Max_f>1#New_Customer(More Than One Time
GROUP BY 1,2,3,4;

-- QC
SELECT CONCAT(MONTHNAME(FirstDate),YEAR(FirstDate))PERIOD,
COUNT(DISTINCT mobile) FROM dummy.hr_sept25_NewCustomer_Cohort_Till_harish
GROUP BY 1;

SELECT COUNT(DISTINCT mobile) FROM txn_report_accrual_redemption  
WHERE txndate BETWEEN '2025-01-01' AND '2025-01-31' AND frequencycount=1

##########################################################################################
-- 
-- -- Month and Daywise KPI
-- SELECT month,day,
-- COUNT(DISTINCT mobile) customers,
-- COUNT(CASE WHEN maxf>1 THEN mobile END) repeaters,
-- SUM(sales) AS sales,
-- SUM(CASE WHEN maxf>1 THEN sales END) repeater_sales,
-- SUM(bills) bills,
-- SUM(CASE WHEN maxf>1 THEN bills END) repeater_bills,
-- SUM(points_collected) AS Transaction_Points_issued,SUM(redeemed) AS Points_redeemed,
-- SUM(redeemer) redeemers,
-- SUM(redemption_sales) AS redemption_sales,
-- SUM(redemption_bills) AS redemption_bills
-- FROM
-- (SELECT mobile,monthname(txndate) month,DAYNAME(txndate) DAY,
-- MAX(frequencycount) AS maxf, 
-- MIN(frequencycount) AS minf,
-- COUNT(DISTINCT UniqueBillNo) AS bills,
-- SUM(amount) sales,
-- SUM(pointscollected) AS Points_collected,SUM(pointsspent) AS Redeemed,
-- COUNT(DISTINCT CASE WHEN pointsspent>0 THEN mobile END) AS redeemer,
-- COUNT(DISTINCT CASE WHEN pointsspent>0 THEN uniquebillno END) AS redemption_bills,
-- SUM(CASE WHEN pointsspent>0 THEN amount END) AS redemption_sales
-- FROM `haldirams`.txn_report_accrual_redemption 
-- WHERE TxnDate BETWEEN '2024-05-07' AND '2024-11-30' 
-- AND storecode NOT LIKE '%demo%' 
-- AND billno NOT LIKE '%test%' 
-- AND billno NOT LIKE '%roll%'
-- -- and DAYNAME(modifiedtxndate) not in ('saturday','sunday')
-- -- and DAYNAME(modifiedtxndate) in ('saturday','sunday')
-- GROUP BY 1,2,3)b
-- group by 1,2;




####################################################################################

###################################################################################################
-- mom new customer
SELECT txnyear,txnmonth,COUNT(DISTINCT CASE WHEN minfc=1 AND maxfc=1 THEN mobile END )'one timer',
COUNT(DISTINCT CASE WHEN minfc=1 AND maxfc>1 THEN mobile END)'new repeater',
COUNT(DISTINCT CASE WHEN minfc=1 AND maxfc=1 THEN mobile END)+COUNT(DISTINCT CASE WHEN minfc=1 AND maxfc>1 THEN mobile END) 'new customer'
FROM(
SELECT mobile,txnmonth,txnyear,MAX(frequencycount)maxfc,MIN(frequencycount)minfc FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2024-08-01' AND '2025-09-30'
GROUP BY 1)a
GROUP BY 1,2
ORDER BY 1,2;

SELECT COUNT(DISTINCT CASE WHEN minfc=1 AND maxfc=1 THEN mobile END )'one timer',
COUNT(DISTINCT CASE WHEN minfc=1 AND maxfc>1 THEN mobile END)'new repeater',
COUNT(DISTINCT CASE WHEN minfc=1 AND maxfc=1 THEN mobile END)+COUNT(DISTINCT CASE WHEN minfc=1 AND maxfc>1 THEN mobile END) 'new customer'
FROM(
SELECT mobile,txnmonth,txnyear,MAX(frequencycount)maxfc,MIN(frequencycount)minfc FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2025-09-01' AND '2025-09-30'
GROUP BY 1)a
GROUP BY 1,2

SELECT COUNT(DISTINCT mobile) FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2025-09-01' AND '2025-09-30' AND frequencycount=1;


##############################################################################################

WITH 
-- Main transaction data
txn_data AS (
    SELECT 
        Mobile, 
        TxnMonth,
        TxnYear, 
        SUM(Amount) AS sales,
        COUNT(DISTINCT UniqueBillNo) AS bills,
        MAX(frequencycount) AS maxf, 
        MIN(frequencycount) AS minf,
        COUNT(DISTINCT txndate) visits,
        SUM(pointscollected) AS Points_collected,
        SUM(pointsspent) AS Redeemed,
        COUNT(DISTINCT CASE WHEN pointsspent > 0 THEN mobile END) AS redeemer,
        COUNT(DISTINCT CASE WHEN pointsspent > 0 THEN uniquebillno END) AS redemption_bills,
        SUM(CASE WHEN pointsspent > 0 THEN amount END) AS redemption_sales
    FROM `haldirams`.txn_report_accrual_redemption 
    WHERE TxnDate BETWEEN '2024-06-01' AND '2025-07-31'
    AND storecode NOT LIKE '%demo%' 
    AND billno NOT LIKE '%test%' 
    AND billno NOT LIKE '%roll%'
    AND insertiondate<'2025-08-06'
    GROUP BY 1, 2, 3
),

-- Store count data
store_counts AS (
    SELECT 
        MONTHNAME(txndate) AS MONTH,
        COUNT(DISTINCT storecode) AS stores
    FROM `haldirams`.txn_report_accrual_redemption 
    WHERE TxnDate BETWEEN '2024-06-01' AND '2025-07-31'
    AND storecode NOT LIKE '%demo%' 
    AND billno NOT LIKE '%test%' 
    AND billno NOT LIKE '%roll%'
    AND insertiondate<'2025-08-06'
    GROUP BY 1
),

-- Enrollment data
enrollment_data AS (
    SELECT 
        MONTHNAME(modifiedenrolledon) AS MONTH,
        COUNT(mobile) AS enrollments
    FROM member_report
    WHERE modifiedenrolledon BETWEEN '2024-06-01' AND '2025-07-31'
    AND enrolledstorecode NOT IN ('demo', 'qrcode')
    AND insertiondate<'2025-08-06'
    GROUP BY 1
),

-- Aggregated transaction metrics
txn_metrics AS (
    SELECT 
        TxnMonth, 
        TxnYear,
        COUNT(Mobile) AS Transacting_Customers,
        COUNT(DISTINCT CASE WHEN maxf = 1 AND minf = 1 THEN Mobile END) AS OneTimer,
        COUNT(DISTINCT CASE WHEN maxf > 1 THEN Mobile END) AS Repeater,
        SUM(CASE WHEN maxf = 1 AND minf = 1 THEN sales END) AS onetimer_Sales,
        SUM(CASE WHEN maxf > 1 THEN sales END) AS Repeat_Sales,
        SUM(sales) AS sales,
        SUM(CASE WHEN maxf = 1 AND minf = 1 THEN bills END) AS onetimer_Bills,
        SUM(CASE WHEN maxf > 1 THEN bills END) AS Repeat_Bills,
        SUM(bills) AS bills,
        SUM(sales)/SUM(bills) AS ATV,
        SUM(CASE WHEN maxf = 1 AND minf = 1 THEN sales END)/NULLIF(SUM(CASE WHEN maxf = 1 AND minf = 1 THEN bills END), 0) AS Onetimer_ATV,
        SUM(CASE WHEN maxf > 1 THEN sales END)/NULLIF(SUM(CASE WHEN maxf > 1 THEN bills END), 0) AS Repeat_ATV,
        AVG(visits) AS avg_visits,
        SUM(Points_collected) AS Transaction_Points_issued,
        SUM(Redeemed) AS Points_redeemed,
        SUM(redeemer) AS redeemers,
        SUM(redemption_sales) AS redemption_sales,
        SUM(redemption_bills) AS redemption_bills
    FROM txn_data 
    GROUP BY 1, 2
)

-- Final combined output
SELECT 
tm.TxnYear,
tm.TxnMonth,
    COALESCE(sc.stores, 0) AS stores,
    COALESCE(ed.enrollments, 0) AS Enrollments,
    tm.Transacting_Customers,
    tm.OneTimer,
    tm.Repeater,
    tm.onetimer_Sales,
    tm.Repeat_Sales,
    tm.sales,
    tm.onetimer_Bills,
    tm.Repeat_Bills,
    tm.bills,
    tm.ATV,
    tm.Onetimer_ATV,
    tm.Repeat_ATV,
    tm.avg_visits AS AVG_visits,
    tm.Transaction_Points_issued,
    tm.Points_redeemed,
    tm.redeemers,
    tm.redemption_sales,
    tm.redemption_bills
FROM txn_metrics tm
LEFT JOIN store_counts sc ON tm.TxnMonth = sc.MONTH
LEFT JOIN enrollment_data ed ON tm.TxnMonth = ed.MONTH
GROUP BY 1,2
ORDER BY 
  -- CASE tm.TxnMonth
--     WHEN 'May' THEN 1
--         WHEN 'June' THEN 2
--         WHEN 'July' THEN 3
--         WHEN 'August' THEN 4
--         WHEN 'September' THEN 5
--         WHEN 'October' THEN 6
--         WHEN 'November' THEN 7
--         WHEN 'December' THEN 8
--         WHEN 'January' THEN 9
--         WHEN 'February' THEN 10
--         ELSE 10
--     END,
    tm.TxnYear;

SELECT SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills
FROM `haldirams`.txn_report_accrual_redemption 
    WHERE TxnDate BETWEEN '2024-06-01' AND '2025-07-31'
    AND storecode NOT LIKE '%demo%' 
    AND billno NOT LIKE '%test%' 
    AND billno NOT LIKE '%roll%'
    AND insertiondate<'2025-08-06';
    
