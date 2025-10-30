SELECT
COUNT(DISTINCT mobile)enrollment FROM member_report
WHERE modifiedenrolledon BETWEEN '2024-06-01' AND '2024-08-31'
AND enrolledstorecode NOT IN ('demo', 'qrcode')
AND insertiondate<='2025-09-02';
-- _______________________snapshort_______________________________enrollment____________
WITH enrollment AS (
SELECT 
CASE 
WHEN modifiedenrolledon BETWEEN '2025-06-01' AND '2025-08-31' THEN '1Jun25-31Aug25'
WHEN modifiedenrolledon BETWEEN '2025-03-01' AND '2025-05-31' THEN '1Mar25-31May25'
WHEN modifiedenrolledon BETWEEN '2024-06-01' AND '2024-08-31' THEN '1Jun24-31Aug24'
END PERIOD,
COUNT(DISTINCT mobile)enrollment FROM member_report
WHERE ((modifiedenrolledon BETWEEN '2025-06-01' AND '2025-08-31') OR
(modifiedenrolledon BETWEEN '2025-03-01' AND '2025-05-31')
OR (modifiedenrolledon BETWEEN '2024-06-01' AND '2024-08-31'))
AND enrolledstorecode NOT IN ('demo', 'qrcode')
AND insertiondate<='2025-09-02'
GROUP BY 1),

-- _______________________snapshort_______________________________txndate____________ 
txn AS (
SELECT 
CASE WHEN txndate BETWEEN '2025-06-01' AND '2025-08-31' THEN '1Jun25-31Aug25'
WHEN txndate BETWEEN '2025-03-01' AND '2025-05-31' THEN '1Mar25-31May25'
WHEN txndate BETWEEN '2024-06-01' AND '2024-08-31' THEN '1Jun24-31Aug24'
END PERIOD,
COUNT(DISTINCT storecode)store_count,
SUM(amount)loyalty_sales,
SUM(CASE WHEN frequencycount>1 THEN amount END )repeater_sales,
COUNT(DISTINCT uniquebillno)loyalty_bills,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN uniquebillno END)repeater_bills,
COUNT(DISTINCT mobile)Transacted_Customers,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN mobile END)repeater,
COUNT(DISTINCT CASE WHEN pointsspent>1 THEN mobile END)Redeemers,
SUM(pointscollected)points_issued,
SUM(pointsspent)Points_Redeemed,
SUM(pointsspent)/NULLIF(SUM(pointscollected),0)Earn_Burn_Ratio,
SUM(amount)/COUNT(DISTINCT mobile)AMV,
SUM(CASE WHEN frequencycount>1 THEN amount END)/NULLIF(COUNT(DISTINCT CASE WHEN frequencycount>1 THEN  mobile END),0)Repeater_AMV,
SUM(amount)/COUNT(DISTINCT uniquebillno)ATV,
SUM(CASE WHEN frequencycount>1 THEN amount END)/COUNT(DISTINCT CASE WHEN frequencycount>1 THEN  uniquebillno END)Repeater_ATV
FROM txn_report_accrual_redemption
WHERE ((txndate BETWEEN '2025-06-01' AND '2025-08-31')OR 
(txndate BETWEEN '2025-03-01' AND '2025-05-31')OR 
(txndate BETWEEN '2024-06-01' AND '2024-08-31'))
AND storecode NOT LIKE '%demo%' 
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
AND insertiondate<='2025-09-02' AND amount>0
GROUP BY 1),


-- _______________________snapshort_______________________________visit____________ 
visit AS (
SELECT PERIOD,
SUM(visit)/COUNT(DISTINCT mobile)avg_visit,
SUM(CASE WHEN visit>1 THEN visit END)repeater_visit,
SUM(visit)visit FROM(
SELECT 
CASE 
WHEN txndate BETWEEN '2025-06-01' AND '2025-08-31' THEN '1Jun25-31Aug25'
WHEN txndate BETWEEN '2025-03-01' AND '2025-05-31' THEN '1Mar25-31May25'
WHEN txndate BETWEEN '2024-06-01' AND '2024-08-31' THEN '1Jun24-31Aug24'
END PERIOD,
mobile,COUNT(DISTINCT txndate)visit
FROM txn_report_accrual_redemption
WHERE ((txndate BETWEEN '2025-06-01' AND '2025-08-31')OR 
(txndate BETWEEN '2025-03-01' AND '2025-05-31')OR 
(txndate BETWEEN '2024-06-01' AND '2024-08-31'))
AND storecode NOT LIKE '%demo%' 
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
AND insertiondate<='2025-09-02' AND amount>0
GROUP BY 1,2)a
GROUP BY 1),

-- _______________________snapshort_______________________________Sku____________ 

sku AS (
SELECT PERIOD,
SUM(qty)/SUM(bills)UPT,SUM(sales)/SUM(qty)ASP FROM (
SELECT 
CASE 
WHEN modifiedtxndate BETWEEN '2025-06-01' AND '2025-08-31' THEN '1Jun25-31Aug25'
WHEN modifiedtxndate BETWEEN '2025-03-01' AND '2025-05-31' THEN '1Mar25-31May25'
WHEN modifiedtxndate BETWEEN '2024-06-01' AND '2024-08-31' THEN '1Jun24-31Aug24'
END PERIOD,
txnmappedmobile,SUM(itemqty)qty,COUNT(DISTINCT uniquebillno)bills,SUM(itemnetamount)sales 
FROM sku_report_loyalty
WHERE ((modifiedtxndate BETWEEN '2025-06-01' AND '2025-08-31')OR 
(modifiedtxndate BETWEEN '2025-03-01' AND '2025-05-31')OR 
(modifiedtxndate BETWEEN '2024-06-01' AND '2024-08-31'))
AND modifiedstorecode NOT LIKE '%demo%' 
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
AND insertiondate<='2025-09-02' AND itemnetamount>0
GROUP BY 1,2)a
GROUP BY 1),


-- _______________________snapshort_______________________________nonloyalty____________ 

nonloyalty AS (
SELECT 
CASE 
WHEN modifiedtxndate BETWEEN '2025-06-01' AND '2025-08-31' THEN '1Jun25-31Aug25'
WHEN modifiedtxndate BETWEEN '2025-03-01' AND '2025-05-31' THEN '1Mar25-31May25'
WHEN modifiedtxndate BETWEEN '2024-06-01' AND '2024-08-31' THEN '1Jun24-31Aug24'
END PERIOD,
COUNT(DISTINCT uniquebillno)nonloyalty_bills,SUM(itemnetamount)nonloyalty_sales 
FROM sku_report_nonloyalty
WHERE ((modifiedtxndate BETWEEN '2025-06-01' AND '2025-08-31')OR 
(modifiedtxndate BETWEEN '2025-03-01' AND '2025-05-31')OR 
(modifiedtxndate BETWEEN '2024-06-01' AND '2024-08-31'))
AND modifiedstorecode NOT LIKE '%demo%' 
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
AND insertiondate<='2025-09-02' AND itemnetamount>0
GROUP BY 1)

-- _______________________snapshort_______________________________summary____________ 
SELECT a.period,
a.store_count,
a.loyalty_sales,
repeater_sales,
a.loyalty_bills,
a.repeater_bills,
b.enrollment,
a.Transacted_Customers,
a.repeater,
a.Redeemers,
a.points_issued,
a.Points_Redeemed,
a.Earn_Burn_Ratio,
a.AMV,
a.Repeater_AMV,
a.ATV,
a.Repeater_ATV,
c.avg_visit,
d.UPT,d.ASP,
e.nonloyalty_sales,
e.nonloyalty_bills,
c.visit,c.repeater_visit
FROM txn a JOIN enrollment b ON a.period=b.period
JOIN visit c ON a.period=c.period
JOIN sku d ON a.period=d.period
JOIN nonloyalty e ON a.period=e.period;



SELECT COUNT(DISTINCT storecode)storecode,
SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills,
SUM(pointsspent)redeemed,SUM(pointscollected)isused 
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2024-06-01' AND '2024-08-31' 
AND storecode NOT LIKE '%demo%' 
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
AND insertiondate<='2025-09-02' AND amount>0;

-- ___________________________snapshort latency____________________ 

SELECT PERIOD,
AVG(latency)latency FROM(
SELECT 
CASE 
WHEN txndate BETWEEN '2025-06-01' AND '2025-08-31' THEN '1Jun25-31Aug25'
WHEN txndate BETWEEN '2025-03-01' AND '2025-05-31' THEN '1Mar25-31May25'
WHEN txndate BETWEEN '2024-06-01' AND '2024-08-31' THEN '1Jun24-31Aug24'
END PERIOD,
mobile,DATEDIFF(MAX(txndate),MIN(txndate))/NULLIF((COUNT(DISTINCT txndate)-1),0) latency 
FROM txn_report_accrual_redemption
WHERE ((txndate BETWEEN '2025-06-01' AND '2025-08-31')OR 
(txndate BETWEEN '2025-03-01' AND '2025-05-31')OR 
(txndate BETWEEN '2024-06-01' AND '2024-08-31'))
AND storecode NOT LIKE '%demo%' 
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
AND insertiondate<='2025-09-02' AND amount>0
GROUP BY 1,2)a
GROUP BY 1;
-- _______________________snapshort_______________________________end____________ 



INSERT INTO dummy.ovearll_storecode_24_25_txn_overall
WITH store_25_jun_aug AS (
SELECT DISTINCT storecode  
FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2025-03-01' AND '2025-08-31'
AND storecode NOT LIKE '%demo%'
AND billno NOT LIKE '%test%'
AND billno NOT LIKE '%roll%'
AND storecode NOT IN ('Corporate')
-- AND storecode NOT LIKE '%ecom%'
),

store_24_jun_aug AS (
SELECT DISTINCT storecode 
FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2024-06-01' AND '2024-08-31'
AND storecode NOT LIKE '%demo%'
AND billno NOT LIKE '%test%'
AND billno NOT LIKE '%roll%'
AND storecode NOT IN ('Corporate')
-- AND storecode NOT LIKE '%ecom%'
)

SELECT a.storecode FROM store_25_jun_aug a JOIN store_24_jun_aug b ON a.storecode=b.storecode;#134


ALTER TABLE  dummy.ovearll_storecode_24_25_txn_overall ADD INDEX a(storecode);

SELECT storecode FROM dummy.ovearll_storecode_24_25_txn_overall


INSERT INTO dummy.enrolledstore_overall_24_25_overall
WITH store_25 AS (
SELECT DISTINCT EnrolledStoreCode  FROM member_report
WHERE ModifiedEnrolledOn BETWEEN '2025-03-01' AND '2025-08-31'
AND EnrolledStoreCode NOT LIKE '%demo%'
AND EnrolledStoreCode NOT LIKE '%test%'
AND EnrolledStoreCode NOT LIKE '%roll%'
AND EnrolledStoreCode NOT IN ('Corporate')
-- AND EnrolledStoreCode NOT LIKE '%ecom%'
),
store_24 AS (
SELECT DISTINCT EnrolledStoreCode  FROM member_report
WHERE ModifiedEnrolledOn BETWEEN '2024-06-01' AND '2024-08-31'
AND EnrolledStoreCode NOT LIKE '%demo%'
AND EnrolledStoreCode NOT LIKE '%test%'
AND EnrolledStoreCode NOT LIKE '%roll%'
AND EnrolledStoreCode NOT IN ('Corporate')
-- AND EnrolledStoreCode NOT LIKE '%ecom%' 
)
SELECT EnrolledStoreCode FROM store_25 a JOIN store_24 b USING(EnrolledStoreCode)#132

ALTER TABLE  dummy.enrolledstore_overall_24_25_overall ADD INDEX a(EnrolledStoreCode);
SELECT * FROM dummy.enrolledstore_overall_24_25_overall;


INSERT INTO dummy.sku_non_loyalty_25_24_base_overall
WITH store_25 AS (
SELECT DISTINCT ModifiedStoreCode FROM sku_report_nonloyalty
WHERE modifiedtxndate BETWEEN '2025-03-01' AND '2025-08-31'
AND ModifiedStoreCode NOT LIKE '%demo%'
AND ModifiedBillNo NOT LIKE '%test%'
AND ModifiedBillNo NOT LIKE '%roll%'
AND ModifiedStoreCode NOT IN ('Corporate')
-- AND ModifiedStoreCode NOT LIKE '%ecom%'
),
store_24 AS (
SELECT DISTINCT ModifiedStoreCode FROM sku_report_nonloyalty
WHERE modifiedtxndate BETWEEN '2024-06-01' AND '2024-08-31'
AND ModifiedStoreCode NOT LIKE '%demo%'
AND ModifiedBillNo NOT LIKE '%test%'
AND ModifiedBillNo NOT LIKE '%roll%'
AND ModifiedStoreCode NOT IN ('Corporate')
-- AND ModifiedStoreCode NOT LIKE '%ecom%'
)
SELECT ModifiedStoreCode FROM store_25 a JOIN store_24 b USING(ModifiedStoreCode);#133

ALTER TABLE dummy.sku_non_loyalty_25_24_base_overall ADD INDEX a(ModifiedStoreCode);

SELECT * FROM dummy.sku_non_loyalty_25_24_base_overall;




INSERT INTO dummy.sku_loyalty_25_24_base_overall

WITH store_25 AS (
SELECT DISTINCT ModifiedStoreCode FROM sku_report_loyalty
WHERE modifiedtxndate BETWEEN '2025-03-01' AND '2025-08-31'
AND ModifiedStoreCode NOT LIKE '%demo%'
AND ModifiedBillNo NOT LIKE '%test%'
AND ModifiedBillNo NOT LIKE '%roll%'
AND ModifiedStoreCode NOT IN ('Corporate')
-- AND ModifiedStoreCode NOT LIKE '%ecom%'
),
store_24 AS (
SELECT DISTINCT ModifiedStoreCode FROM sku_report_loyalty
WHERE modifiedtxndate BETWEEN '2024-06-01' AND '2024-08-31'
AND ModifiedStoreCode NOT LIKE '%demo%'
AND ModifiedBillNo NOT LIKE '%test%'
AND ModifiedBillNo NOT LIKE '%roll%'
AND ModifiedStoreCode NOT IN ('Corporate')
-- AND ModifiedStoreCode NOT LIKE '%ecom%'
)
SELECT ModifiedStoreCode FROM store_25 a JOIN store_24 b USING(ModifiedStoreCode);#132


ALTER TABLE dummy.sku_loyalty_25_24_base_overall ADD INDEX a(ModifiedStoreCode);

SELECT * FROM dummy.sku_loyalty_25_24_base_overall;


-- _______________________snapshortL2L_______________________________enrollment____________
WITH enrollment AS (
SELECT 
CASE 
WHEN modifiedenrolledon BETWEEN '2025-06-01' AND '2025-08-31' THEN '1Jun25-31Aug25'
WHEN modifiedenrolledon BETWEEN '2025-03-01' AND '2025-05-31' THEN '1Mar25-31May25'
WHEN modifiedenrolledon BETWEEN '2024-06-01' AND '2024-08-31' THEN '1Jun24-31Aug24'
END PERIOD,
COUNT(DISTINCT mobile)enrollment FROM member_report a JOIN dummy.enrolledstore_overall_24_25_overall b USING(enrolledstorecode)
WHERE ((modifiedenrolledon BETWEEN '2025-06-01' AND '2025-08-31') OR
(modifiedenrolledon BETWEEN '2025-03-01' AND '2025-05-31')
OR (modifiedenrolledon BETWEEN '2024-06-01' AND '2024-08-31'))
AND enrolledstorecode NOT IN ('demo', 'qrcode')
-- and enrolledstorecode in (select distinct enrolledstorecode from dummy.enrolledstore_overall_24_25_overall)
AND insertiondate<='2025-09-02'
GROUP BY 1),

-- _______________________snapshortL2L_______________________________txndate____________ 
txn AS (
SELECT 
CASE WHEN txndate BETWEEN '2025-06-01' AND '2025-08-31' THEN '1Jun25-31Aug25'
WHEN txndate BETWEEN '2025-03-01' AND '2025-05-31' THEN '1Mar25-31May25'
WHEN txndate BETWEEN '2024-06-01' AND '2024-08-31' THEN '1Jun24-31Aug24'
END PERIOD,
COUNT(DISTINCT storecode)store_count,
SUM(amount)loyalty_sales,
SUM(CASE WHEN frequencycount>1 THEN amount END )repeater_sales,
COUNT(DISTINCT uniquebillno)loyalty_bills,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN uniquebillno END)repeater_bills,
COUNT(DISTINCT mobile)Transacted_Customers,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN mobile END)repeater,
COUNT(DISTINCT CASE WHEN pointsspent>1 THEN mobile END)Redeemers,
SUM(pointscollected)points_issued,
SUM(pointsspent)Points_Redeemed,
SUM(pointsspent)/NULLIF(SUM(pointscollected),0)Earn_Burn_Ratio,
SUM(amount)/COUNT(DISTINCT mobile)AMV,
SUM(CASE WHEN frequencycount>1 THEN amount END)/NULLIF(COUNT(DISTINCT CASE WHEN frequencycount>1 THEN  mobile END),0)Repeater_AMV,
SUM(amount)/COUNT(DISTINCT uniquebillno)ATV,
SUM(CASE WHEN frequencycount>1 THEN amount END)/COUNT(DISTINCT CASE WHEN frequencycount>1 THEN  uniquebillno END)Repeater_ATV
FROM txn_report_accrual_redemption a JOIN dummy.ovearll_storecode_24_25_txn_overall b USING(storecode)
WHERE ((txndate BETWEEN '2025-06-01' AND '2025-08-31')OR 
(txndate BETWEEN '2025-03-01' AND '2025-05-31')OR 
(txndate BETWEEN '2024-06-01' AND '2024-08-31'))
AND storecode NOT LIKE '%demo%' 
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
AND insertiondate<='2025-09-02' AND amount>0
-- and storecode in (select distinct storecode from dummy.ovearll_storecode_24_25_txn_overall)
GROUP BY 1),


-- _______________________snapshortL2L_______________________________visit____________ 
visit AS (
SELECT PERIOD,
SUM(visit)/COUNT(DISTINCT mobile)avg_visit,
SUM(CASE WHEN visit>1 THEN visit END)repeater_visit,
SUM(visit)visit FROM(
SELECT 
CASE 
WHEN txndate BETWEEN '2025-06-01' AND '2025-08-31' THEN '1Jun25-31Aug25'
WHEN txndate BETWEEN '2025-03-01' AND '2025-05-31' THEN '1Mar25-31May25'
WHEN txndate BETWEEN '2024-06-01' AND '2024-08-31' THEN '1Jun24-31Aug24'
END PERIOD,
mobile,COUNT(DISTINCT txndate)visit
FROM
txn_report_accrual_redemption a JOIN dummy.ovearll_storecode_24_25_txn_overall b USING(storecode)
WHERE ((txndate BETWEEN '2025-06-01' AND '2025-08-31')OR 
(txndate BETWEEN '2025-03-01' AND '2025-05-31')OR 
(txndate BETWEEN '2024-06-01' AND '2024-08-31'))
AND storecode NOT LIKE '%demo%' 
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
AND insertiondate<='2025-09-02' AND amount>0
-- AND storecode IN (SELECT DISTINCT storecode FROM dummy.ovearll_storecode_24_25_txn_overall)
GROUP BY 1,2)a
GROUP BY 1),

-- _______________________snapshortL2L_______________________________Sku____________ 

sku AS (
SELECT PERIOD,
SUM(qty)/SUM(bills)UPT,SUM(sales)/SUM(qty)ASP FROM (
SELECT 
CASE 
WHEN modifiedtxndate BETWEEN '2025-06-01' AND '2025-08-31' THEN '1Jun25-31Aug25'
WHEN modifiedtxndate BETWEEN '2025-03-01' AND '2025-05-31' THEN '1Mar25-31May25'
WHEN modifiedtxndate BETWEEN '2024-06-01' AND '2024-08-31' THEN '1Jun24-31Aug24'
END PERIOD,
txnmappedmobile,SUM(itemqty)qty,COUNT(DISTINCT uniquebillno)bills,SUM(itemnetamount)sales 
FROM sku_report_loyalty a JOIN dummy.sku_loyalty_25_24_base_overall b USING(modifiedstorecode)
WHERE ((modifiedtxndate BETWEEN '2025-06-01' AND '2025-08-31')OR 
(modifiedtxndate BETWEEN '2025-03-01' AND '2025-05-31')OR 
(modifiedtxndate BETWEEN '2024-06-01' AND '2024-08-31'))
AND modifiedstorecode NOT LIKE '%demo%' 
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
-- and modifiedstorecode in (select distinct modifiedstorecode from dummy.sku_loyalty_25_24_base_overall)
AND insertiondate<='2025-09-02' AND itemnetamount>0
GROUP BY 1,2)a
GROUP BY 1),


-- _______________________snapshortL2L_______________________________nonloyalty____________ 

nonloyalty AS (
SELECT 
CASE 
WHEN modifiedtxndate BETWEEN '2025-06-01' AND '2025-08-31' THEN '1Jun25-31Aug25'
WHEN modifiedtxndate BETWEEN '2025-03-01' AND '2025-05-31' THEN '1Mar25-31May25'
WHEN modifiedtxndate BETWEEN '2024-06-01' AND '2024-08-31' THEN '1Jun24-31Aug24'
END PERIOD,
COUNT(DISTINCT uniquebillno)nonloyalty_bills,SUM(itemnetamount)nonloyalty_sales 
FROM sku_report_nonloyalty a JOIN dummy.sku_non_loyalty_25_24_base_overall b USING(modifiedstorecode)
WHERE ((modifiedtxndate BETWEEN '2025-06-01' AND '2025-08-31')OR 
(modifiedtxndate BETWEEN '2025-03-01' AND '2025-05-31')OR 
(modifiedtxndate BETWEEN '2024-06-01' AND '2024-08-31'))
AND modifiedstorecode NOT LIKE '%demo%' 
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
-- and modifiedstorecode in (select distinct modifiedstorecode from dummy.sku_non_loyalty_25_24_base_overall)
AND insertiondate<='2025-09-02' AND itemnetamount>0
GROUP BY 1)

-- _______________________snapshortL2L_______________________________summary____________ 
SELECT a.period,
a.store_count,
a.loyalty_sales,
a.repeater_sales,
a.loyalty_bills,
a.repeater_bills,
b.enrollment,
a.Transacted_Customers,
a.repeater,
a.Redeemers,
a.points_issued,
a.Points_Redeemed,
a.Earn_Burn_Ratio,
a.AMV,
a.Repeater_AMV,
a.ATV,
a.Repeater_ATV,
c.avg_visit,
d.UPT,d.ASP,
e.nonloyalty_sales,
e.nonloyalty_bills,
c.visit,c.repeater_visit
FROM txn a JOIN enrollment b ON a.period=b.period
JOIN visit c ON a.period=c.period
JOIN sku d ON a.period=d.period
JOIN nonloyalty e ON a.period=e.period;

-- QC

SELECT COUNT(DISTINCT storecode)storecode,
SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills,
SUM(pointsspent)redeemed,SUM(pointscollected)isused 
FROM txn_report_accrual_redemption a JOIN dummy.ovearll_storecode_24_25_txn_overall b USING(storecode)
WHERE txndate BETWEEN '2024-06-01' AND '2024-08-31' 
AND storecode NOT LIKE '%demo%' 
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
AND insertiondate<='2025-09-02' AND amount>0;

SELECT
COUNT(DISTINCT uniquebillno)nonloyalty_bills,SUM(itemnetamount)nonloyalty_sales 
FROM sku_report_nonloyalty a JOIN dummy.sku_non_loyalty_25_24_base_overall b USING(modifiedstorecode)
WHERE modifiedtxndate BETWEEN '2025-03-01' AND '2025-05-31'
AND modifiedstorecode NOT LIKE '%demo%' 
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
-- and modifiedstorecode in (select distinct modifiedstorecode from dummy.sku_non_loyalty_25_24_base_overall)
AND insertiondate<='2025-09-02' AND itemnetamount>0;




SELECT PERIOD,
AVG(latency)latency FROM(
SELECT 
CASE 
WHEN txndate BETWEEN '2025-06-01' AND '2025-08-31' THEN '1Jun25-31Aug25'
WHEN txndate BETWEEN '2025-03-01' AND '2025-05-31' THEN '1Mar25-31May25'
WHEN txndate BETWEEN '2024-06-01' AND '2024-08-31' THEN '1Jun24-31Aug24'
END PERIOD,
mobile,DATEDIFF(MAX(txndate),MIN(txndate))/NULLIF((COUNT(DISTINCT txndate)-1),0) latency 
FROM txn_report_accrual_redemption a JOIN dummy.ovearll_storecode_24_25_txn_overall b USING(storecode)
WHERE ((txndate BETWEEN '2025-06-01' AND '2025-08-31')OR 
(txndate BETWEEN '2025-03-01' AND '2025-05-31')OR 
(txndate BETWEEN '2024-06-01' AND '2024-08-31'))
AND storecode NOT LIKE '%demo%' 
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
AND insertiondate<='2025-09-02' AND amount>0
GROUP BY 1,2)a
GROUP BY 1;

-- _______________________snapshortL2L_______________________________end______________________________

-- ___________________________________________MOM KPIS_______________________________enrollment________start_________________________ 

-- Execution Time : 1 hr 18 min
WITH enrollment AS (
SELECT   
CASE 
        WHEN modifiedenrolledon BETWEEN '2024-06-01' AND '2024-08-31' THEN 'Q1'
        WHEN modifiedenrolledon BETWEEN '2024-09-01' AND '2024-11-30' THEN 'Q2'
        WHEN modifiedenrolledon BETWEEN '2024-12-01' AND '2025-02-28' THEN 'Q3'
        WHEN modifiedenrolledon BETWEEN '2025-03-01' AND '2025-05-31' THEN 'Q4'
        WHEN modifiedenrolledon BETWEEN '2025-06-01' AND '2025-08-31' THEN 'Q5'
    END AS QUARTER,
-- enrolledmonth txnmonth,enrolledyear txnyear,
COUNT(DISTINCT mobile)enrollment 
FROM member_report 
WHERE modifiedenrolledon BETWEEN '2024-05-01' AND '2025-08-31'
AND enrolledstorecode NOT IN ('demo', 'qrcode')
-- and enrolledstorecode in (select distinct enrolledstorecode from dummy.enrolledstore_overall_24_25_overall)
AND insertiondate<='2025-09-02'
GROUP BY 1
ORDER BY 1),
-- ___________________________________________MOM KPIS_______________________________txn_________________________________
-- MOM KPI
txn AS (
SELECT 
QUARTER,
-- TxnMonth, TxnYear,
COUNT(Mobile)Transacting_Customers,
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
AVG(visits)avg_visit,
SUM(visits)total_visit,
SUM(CASE WHEN maxf>1 THEN visits END )repeater_visit,
SUM(points_collected) AS Transaction_Points_issued,
SUM(redeemed) AS Points_redeemed,
SUM(redeemer) redeemers,
SUM(redemption_sales) AS redemption_sales,
SUM(redemption_bills) AS redemption_bills
FROM (SELECT Mobile,  
CASE 
        WHEN txndate BETWEEN '2024-06-01' AND '2024-08-31' THEN 'Q1'
        WHEN txndate BETWEEN '2024-09-01' AND '2024-11-30' THEN 'Q2'
        WHEN txndate BETWEEN '2024-12-01' AND '2025-02-28' THEN 'Q3'
        WHEN txndate BETWEEN '2025-03-01' AND '2025-05-31' THEN 'Q4'
        WHEN txndate BETWEEN '2025-06-01' AND '2025-08-31' THEN 'Q5'
    END AS QUARTER,
-- TxnMonth,TxnYear,
SUM(Amount) AS sales,COUNT(DISTINCT (UniqueBillNo)) AS bills,
MAX(frequencycount) AS maxf, MIN(frequencycount) AS minf,COUNT(DISTINCT txndate) visits,
SUM(pointscollected) AS Points_collected,SUM(pointsspent) AS Redeemed,
COUNT(DISTINCT CASE WHEN pointsspent>0 THEN mobile END) AS redeemer,
COUNT(DISTINCT CASE WHEN pointsspent>0 THEN uniquebillno END) AS redemption_bills,
SUM(CASE WHEN pointsspent>0 THEN amount END) AS redemption_sales
FROM `haldirams`.txn_report_accrual_redemption 
WHERE TxnDate BETWEEN  '2024-05-01' AND '2025-08-31'
AND storecode NOT LIKE '%demo%' 
AND storecode NOT LIKE '%corporate%'
AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND amount>0
AND insertiondate<='2025-09-02'
GROUP BY 1,2)a GROUP BY 1
ORDER BY 1),

-- ___________________________________________MOM KPIS_______________________________store_________________________________ 
store AS (
SELECT   
CASE 
        WHEN txndate BETWEEN '2024-06-01' AND '2024-08-31' THEN 'Q1'
        WHEN txndate BETWEEN '2024-09-01' AND '2024-11-30' THEN 'Q2'
        WHEN txndate BETWEEN '2024-12-01' AND '2025-02-28' THEN 'Q3'
        WHEN txndate BETWEEN '2025-03-01' AND '2025-05-31' THEN 'Q4'
        WHEN txndate BETWEEN '2025-06-01' AND '2025-08-31' THEN 'Q5'
    END AS QUARTER,
-- txnmonth,txnyear,
COUNT(DISTINCT storecode) storecode 
FROM `haldirams`.txn_report_accrual_redemption 
WHERE TxnDate BETWEEN  '2024-05-01' AND '2025-08-31'
AND storecode NOT LIKE '%demo%' 
AND storecode NOT LIKE '%corporate%'
AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND insertiondate<='2025-09-02'
GROUP BY 1)

SELECT  
a.Quarter,
-- a.txnmonth,a.txnyear,
storecode,enrollment,Transacting_Customers,
OneTimer,Repeater,onetimer_Sales,Repeat_Sales,
sales,onetimer_Bills,Repeat_Bills,bills,ATV,Repeat_ATV,
avg_visit,total_visit,repeater_visit,
Transaction_Points_issued,Points_redeemed,redeemers,redemption_sales,
redemption_bills FROM txn a JOIN enrollment b USING(QUARTER)
JOIN store c ON a.QUARTER=c.QUARTER AND a.QUARTER=c.QUARTER
ORDER BY 1
;

SELECT SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills,SUM(pointscollected)issued,SUM(pointsspent)spend 
FROM `haldirams`.txn_report_accrual_redemption 
WHERE TxnDate BETWEEN  '2025-06-01' AND '2025-08-31'
AND storecode NOT LIKE '%demo%' 
AND storecode NOT LIKE '%corporate%'
AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND insertiondate<='2025-09-02';

-- ___________________________________________MOM KPIS_______________________________enrollment________end_________________________ 

-- -- ___________________________________Store Wise______________________________start_____________________
-- SELECT brand,storecode,LpaasStore,COUNT(DISTINCT mobile) customers,
-- COUNT(CASE WHEN maxf>1 THEN mobile END) repeaters,
-- SUM(sales) sales,
-- SUM(CASE WHEN maxf>1 THEN sales END) repeater_sales,
-- SUM(bills) bills,
-- SUM(CASE WHEN maxf>1 THEN bills END) repeater_bills,
-- SUM(Points_collected)issued,
-- SUM(Redeemed) redeemed,
-- SUM(visit)total_visit,
-- SUM(CASE WHEN maxf>1 THEN visit END)repeater_visit
-- FROM
-- (SELECT mobile,b.brand,storecode,LpaasStore,SUM(Amount) AS sales,COUNT(DISTINCT (UniqueBillNo)) AS bills,
-- MAX(frequencycount) AS maxf, MIN(frequencycount) AS minf,
-- SUM(pointscollected) AS Points_collected,SUM(pointsspent) AS Redeemed,COUNT(DISTINCT txndate,mobile)visit
-- FROM txn_report_accrual_redemption  a LEFT JOIN store_master b
-- USING(storecode)
-- WHERE TxnDate BETWEEN '2025-06-01' AND '2025-08-31'
-- AND storecode NOT LIKE '%corporate%'
-- AND storecode NOT LIKE '%demo%'
-- AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%')
-- ___________________________________Store Wise______________________________start_____________________
-- Execution Time : 28 min 11 sec
SELECT brand,storecode,LpaasStore,city,region,state,COUNT(DISTINCT mobile) customers,
COUNT(CASE WHEN maxf>1 THEN mobile END) repeaters,
SUM(sales) sales,
SUM(CASE WHEN maxf>1 THEN sales END) repeater_sales,
SUM(bills) bills,
SUM(CASE WHEN maxf>1 THEN bills END) repeater_bills,
SUM(Points_collected)issued,
SUM(Redeemed) redeemed,
SUM(visit)total_visit,
SUM(CASE WHEN maxf>1 THEN visit END)repeater_visit
FROM
(SELECT mobile,b.brand,storecode,LpaasStore,city,region,state,SUM(Amount) AS sales,COUNT(DISTINCT (UniqueBillNo)) AS bills,
MAX(frequencycount) AS maxf, MIN(frequencycount) AS minf,
SUM(pointscollected) AS Points_collected,SUM(pointsspent) AS Redeemed,COUNT(DISTINCT txndate,mobile)visit
FROM txn_report_accrual_redemption  a LEFT JOIN store_master b
USING(storecode)
WHERE TxnDate BETWEEN '2025-06-01' AND '2025-08-31'
AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND storecode NOT LIKE '%corporate%'
AND storecode NOT LIKE '%demo%'
AND amount>0
AND a.insertiondate<='2025-09-02'
GROUP BY 1,2,3)c
GROUP BY 1,2;
AND amount>0
AND a.insertiondate<='2025-09-02'
GROUP BY 1,2,3)c
GROUP BY 1,2;



SELECT storecode,SUM(amount)sales,COUNT(DISTINCT (UniqueBillNo)) AS bills,SUM(pointscollected) AS Points_collected,SUM(pointsspent) AS Redeemed
FROM  txn_report_accrual_redemption  
WHERE TxnDate BETWEEN '2025-06-01' AND '2025-08-31'
AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND amount>0
AND storecode = 'RO515'
AND insertiondate<='2025-09-02'
GROUP BY 1;
-- ___________________________________Store Wise______________________________end_____________________

-- ___________________________________brand Wise______________________________start_____________________


#############################
-- Brand Wise
SELECT 
-- brand,
COUNT(DISTINCT storecode) stores,
COUNT(DISTINCT mobile) customers,SUM(sales) sales,
SUM(bills) bills,SUM(Points_collected) issued,SUM(Redeemed) redeemed,
COUNT(DISTINCT CASE WHEN maxf>1 THEN mobile END)repeart,
SUM(CASE WHEN maxf>1 THEN sales END )repeater_sales,
SUM(CASE WHEN maxf>1 THEN bills END )repeater_bills,
SUM(visit)total_visit,
SUM(CASE WHEN maxf>1 THEN visit END)repeater_visit
FROM
(SELECT mobile,storecode,b.brand,SUM(Amount) AS sales,COUNT(DISTINCT (UniqueBillNo)) AS bills,
MAX(frequencycount) AS maxf, MIN(frequencycount) AS minf,
SUM(pointscollected) AS Points_collected,SUM(pointsspent) AS Redeemed,
COUNT(DISTINCT txndate,mobile)visit
FROM txn_report_accrual_redemption  a JOIN store_master b
USING(storecode)
WHERE TxnDate BETWEEN '2025-06-01' AND '2025-08-31'
AND storecode NOT LIKE '%demo%'
AND storecode NOT LIKE '%corporate%'
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
AND amount>0
AND a.insertiondate<='2025-09-02'
GROUP BY 1,2,3)c
GROUP BY 1
;
-- ___________________________________brand Wise______________________________End_____________________



-- Loyalty Sales & Loyalty Bills from txn table
SELECT txnmonth,
-- CASE WHEN storecode='ecom' THEN "online" ELSE "offline" END AS storetype,
COUNT(DISTINCT uniquebillno) loyaltybills,SUM(amount) loyaltysales
FROM txn_report_accrual_redemption 
WHERE TxnDate BETWEEN '2025-06-01' AND '2025-08-31'
AND insertiondate<='2025-09-02'
AND storecode NOT LIKE '%demo%' 
AND storecode NOT LIKE '%corporate%' 
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
GROUP BY 1,2;

-- Overall
SELECT 
MONTHNAME(txndate) MONTH, 
'Overall' storetype,
COUNT(DISTINCT uniquebillno) loyaltybills,SUM(amount) loyaltysales
FROM txn_report_accrual_redemption 
WHERE TxnDate BETWEEN '2025-06-01' AND '2025-08-31'
AND insertiondate< '2025-09-02'
AND storecode NOT LIKE '%demo%' 
AND storecode NOT LIKE '%corporate%' 
AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
GROUP BY 1;

-- NonLoyalty Sales  Non Loyalty bills
SELECT MONTHNAME(modifiedtxndate) MONTH,-- 
CASE WHEN modifiedstorecode='ecom' THEN "online" ELSE "offline" END AS storetype,
COUNT(DISTINCT uniquebillno) Nonloyaltybills,SUM(itemnetamount) Nonloyaltysales
FROM Sku_report_nonloyalty 
WHERE modifiedTxnDate BETWEEN '2025-06-01' AND '2025-08-31'
AND insertiondate< '2025-08-06'
AND modifiedstorecode NOT LIKE 'demo' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
GROUP BY 1
,
2;

-- ________________________________________________________________________________________________________



-- Day Wise 
SELECT 
-- PERIOD,
-- day,	
COUNT(DISTINCT txnmappedmobile) customers,
SUM(sales) AS sales,
COUNT(CASE WHEN maxf>1 THEN txnmappedmobile END) repeaters,
SUM(itemqty) itemqty,
SUM(CASE WHEN maxf>1 THEN sales END) repeater_sales,
SUM(bills) bills,
SUM(sales)/SUM(itemqty) AS ASP
FROM
(SELECT 
-- CASE 
-- 	WHEN DAYNAME(modifiedtxndate) IN ('saturday','sunday') THEN 'weekend'
-- 	WHEN DAYNAME(modifiedtxndate) NOT IN ('saturday','sunday') THEN 'weekdays' 
-- END PERIOD,
txnmappedmobile,DAYNAME(modifiedtxndate) DAY,
MAX(frequencycount) AS maxf, 
MIN(frequencycount) AS minf,
SUM(itemqty) AS itemqty,
COUNT(DISTINCT UniqueBillNo) AS bills,
SUM(itemnetamount) sales
FROM `haldirams`.Sku_report_loyalty 
WHERE modifiedTxnDate BETWEEN '2025-06-01' AND '2025-08-31' 
AND modifiedstorecode NOT LIKE '%demo%' 
AND modifiedstorecode NOT LIKE '%corporate%' 
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
-- AND ((DAYNAME(modifiedtxndate) NOT IN ('saturday','sunday'))
-- OR (DAYNAME(modifiedtxndate) IN ('saturday','sunday')))
AND insertiondate<='2025-09-02'
GROUP BY 1,2)b
GROUP BY 1;


-- ________________________________________________________________________end_____________________________


-- ____________________________________________ATV Band ____________________________________________



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
WHERE insertiondate<='2025-09-02'
AND txndate BETWEEN '2025-06-01' AND '2025-08-31'
AND storecode NOT LIKE '%demo%'
AND storecode NOT LIKE '%corporate%'
AND amount>0
AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
GROUP BY 1)a
GROUP BY 1
ORDER BY ATV;

-- ____________________________________________ATV Band ____________________________________________end _________________


####################################################################################################################
-- _____________________________________Category Level_______________________________start
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
WHERE modifiedTxnDate BETWEEN '2025-06-01' AND '2025-08-31' 
AND storecode NOT LIKE '%demo%'
AND storecode NOT LIKE '%corporate%' 
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
GROUP BY 1,2)b
GROUP BY 1;
####################################################################################################################
-- _____________________________________Category Level_______________________________ends



-- ________________________________________mom new customer____________________________start___________
SELECT txnyear,txnmonth,COUNT(DISTINCT CASE WHEN minfc=1 AND maxfc=1 THEN mobile END )'one timer',
COUNT(DISTINCT CASE WHEN minfc=1 AND maxfc>1 THEN mobile END)'new repeater',
COUNT(DISTINCT CASE WHEN minfc=1 AND maxfc=1 THEN mobile END)+COUNT(DISTINCT CASE WHEN minfc=1 AND maxfc>1 THEN mobile END) 'new customer'
FROM(
SELECT mobile,txnmonth,txnyear,MAX(frequencycount)maxfc,MIN(frequencycount)minfc 
FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2024-05-01' AND '2025-08-31'
AND storecode NOT LIKE '%demo%'
AND storecode NOT LIKE '%corporate%' 
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
GROUP BY 1)a
GROUP BY 1,2
ORDER BY 1,2;
-- ________________________________________mom new customer____________________________end___________

-- 12 month running 

-- ______________________________________________repeart cohort___________________start___________________
-- Execution Time : 55 min 36 sec
-- 12 month running 

SELECT * FROM dummy.hr_sept_aug25_NewCustomer_Cohort_Till
-- repeart cohort
DELETE FROM dummy.hr_sept_aug25_NewCustomer_Cohort_Till;
INSERT INTO dummy.hr_sept_aug25_NewCustomer_Cohort_Till
SELECT mobile,MIN(txndate)FirstDate
FROM txn_report_accrual_redemption a
WHERE txndate<='2025-08-31'
GROUP BY 1;#7185917
 
 
DELETE FROM dummy.hr_sept_aug25_NewCustomer_Cohort_Data_sep24_aug25;
INSERT INTO dummy.hr_sept_aug25_NewCustomer_Cohort_Data_sep24_aug25
SELECT * FROM dummy.hr_sept_aug25_NewCustomer_Cohort_Till 
WHERE FirstDate BETWEEN '2024-09-01' AND '2025-08-31';#4987653
 
ALTER TABLE dummy.hr_sept_aug25_NewCustomer_Cohort_Data_sep24_aug25 ADD INDEX mobile(mobile);
 
 
SELECT YEAR(a.firstdate)txnyear,MONTHNAME(a.FirstDate)`monthname`,YEAR(b.txndate)SubsequentTxnyear,
MONTHNAME(b.txndate)SubsequentTxnmonth,COUNT(DISTINCT a.mobile)Customer
FROM dummy.hr_sept_aug25_NewCustomer_Cohort_Data_sep24_aug25 a JOIN txn_report_accrual_redemption  b
ON a.mobile=b.mobile
WHERE b.txndate<='2025-08-31'
#AND 
#Min_f=1  #New_Customer
#Min_f=1 and Max_f=1  #New_Customer(One-Timer)
#Min_f=1 AND Max_f>1#New_Customer(More Than One Time
GROUP BY 1,2,3,4;

-- QC
SELECT CONCAT(MONTHNAME(FirstDate),YEAR(FirstDate))PERIOD,
COUNT(DISTINCT mobile) FROM dummy.hr_sept_aug25_NewCustomer_Cohort_Till
GROUP BY 1;



SELECT mobile,MIN(txndate) FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2025-08-01' AND '2025-08-31'
GROUP BY 1
-- ______________________________________________repeart cohort___________________end___________________

-- ______________________________________________Points distribution___________________start___________________

SELECT 
CASE 
WHEN points=0 THEN '0'
WHEN points>0 AND points<=25 THEN '1-25'
WHEN points>25 AND points<=50 THEN '26-50'
WHEN points>50 AND points<=100 THEN '50-100'
WHEN points>100 AND points<=200 THEN '100-200'
WHEN points>200 AND points<=500 THEN '200-500'
WHEN points>500 AND points<=1000 THEN '500-1000'
WHEN points>1000 THEN '>1000' END points_slab,COUNT(DISTINCT mobile)customers FROM(
SELECT mobile,SUM(availablepoints)points FROM member_report
WHERE insertiondate<='2025-09-02'
AND enrolledstorecode NOT IN ('demo', 'qrcode')
GROUP BY 1)a
GROUP BY 1;

-- ______________________________________________Points distribution___________________end___________________

lifecycle

WITH vintage AS (
SELECT mobile,DATEDIFF('2025-08-31',modifiedenrolledon)vintage FROM member_report
WHERE modifiedenrolledon<='2025-08-31' 
AND enrolledstorecode NOT IN ('demo', 'qrcode')
AND insertiondate<='2025-09-02'
GROUP BY 1),

recency AS (
SELECT mobile,DATEDIFF('2025-8-31',MAX(txndate))recency,COUNT(DISTINCT txndate,mobile)visit
FROM txn_report_accrual_redemption
WHERE txndate <='2025-08-31'
AND storecode NOT LIKE '%demo%'
AND storecode NOT LIKE '%corporate%'
AND amount>0
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
AND insertiondate <='2025-09-02'
GROUP BY 1
)

SELECT 
CASE 
WHEN vintage<=30 AND recency<=30 THEN 'new'
WHEN recency <=90 AND visit<=2 THEN 'Grow'
WHEN recency <=90 AND visit>=3 THEN 'stable'
WHEN recency >90 AND recency<=180 THEN 'decline'
WHEN recency >180 AND recency<=210 THEN 'recently lapsed'
WHEN recency >210 AND recency<=240 THEN 'Lapsed'
WHEN recency >240 THEN 'Long Lapsed' END segment,
COUNT(DISTINCT mobile)customers FROM recency LEFT JOIN vintage USING(mobile)
GROUP BY 1;

INSERT INTO dummy.vintage_aug_25
SELECT mobile,DATEDIFF('2025-08-31',modifiedenrolledon)vintage FROM member_report
WHERE modifiedenrolledon<='2025-08-31' 
AND enrolledstorecode NOT IN ('demo', 'qrcode')
AND insertiondate<='2025-09-02' 
GROUP BY 1;#7195339

INSERT INTO dummy.recency_aug_15
SELECT mobile,DATEDIFF('2025-8-31',MAX(txndate))recency,COUNT(DISTINCT txndate,mobile)visit
FROM txn_report_accrual_redemption
WHERE txndate <='2025-08-31'
AND storecode NOT LIKE '%demo%'
AND storecode NOT LIKE '%corporate%'
AND amount>0
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
AND insertiondate <='2025-09-02' 
GROUP BY 1;#7185353


SELECT 
CASE 
WHEN vintage<=30 AND recency<=30 THEN 'new'
WHEN recency <=90 AND visit<=2 THEN 'Grow'
WHEN recency <=90 AND visit>=3 THEN 'stable'
WHEN recency >90 AND recency<=180 THEN 'decline'
WHEN recency >180 AND recency<=210 THEN 'recently lapsed'
WHEN recency >210 AND recency<=240 THEN 'Lapsed'
WHEN recency >240 THEN 'Long Lapsed' END segment,
COUNT(DISTINCT mobile)customers FROM dummy.recency_aug_15 LEFT JOIN dummy.vintage_aug_25 USING(mobile)
GROUP BY 1;
-- ____________________________________________lifecycle_________________________end________________


-- ___________________________________________ Drop rate___________________________________________start_________________


WITH base AS  (
SELECT mobile,COUNT(DISTINCT txndate)visit,SUM(amount)sales,SUM(pointsspent)points_spent FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2025-06-01' AND '2025-08-31'
AND storecode NOT LIKE '%demo%'
AND storecode NOT LIKE '%corporate%'
AND amount>0
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
AND insertiondate <='2025-09-02' 
GROUP BY 1)

SELECT CASE WHEN visit<=10 THEN visit ELSE '10+' END visit_tag,
COUNT(DISTINCT mobile)customers,SUM(sales)sales,
COUNT(DISTINCT CASE WHEN points_spent>0 THEN mobile END)redeemers
FROM base
GROUP BY 1 ORDER BY visit;




WITH base AS  (
SELECT mobile,
COUNT(DISTINCT uniquebillno)bills,
COUNT(DISTINCT txndate)visit,
SUM(amount)sales,
SUM(pointsspent)points_spent,
SUM(CASE WHEN pointsspent>0 THEN amount END)redemption_sales,
COUNT(DISTINCT CASE WHEN pointsspent>0 THEN uniquebillno END)redemption_bills
FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2025-06-01' AND '2025-08-31'
AND storecode NOT LIKE '%demo%'
AND storecode NOT LIKE '%corporate%'
AND amount>0
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
AND insertiondate <='2025-09-02' 
GROUP BY 1)

SELECT mobile,visit,
SUM(sales)sales,
SUM(bills)bills,
COUNT(DISTINCT CASE WHEN points_spent>0 THEN mobile END)redeemers,
SUM(points_spent)points_spent,
-- sum(case when points_spent>0  then sales end)
SUM(redemption_sales)redemption_sales,
-- SUM(CASE WHEN points_spent>0  THEN bills END)
SUM(redemption_bills)redemption_bills
FROM base 
WHERE visit>10
GROUP BY 1,2;




WITH base AS  (
SELECT mobile,
COUNT(DISTINCT uniquebillno)bills,
COUNT(DISTINCT txndate)visit,
SUM(amount)sales,
SUM(pointsspent)points_spent,
SUM(CASE WHEN pointsspent>0 THEN amount END)redemption_sales,
COUNT(DISTINCT CASE WHEN pointsspent>0 THEN uniquebillno END)redemption_bills
FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2025-06-01' AND '2025-08-31'
AND storecode NOT LIKE '%demo%'
AND storecode NOT LIKE '%corporate%'
AND amount>0
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
AND insertiondate <='2025-09-02' 
GROUP BY 1)
 
SELECT mobile,visit,sales,bills,
CASE WHEN points_spent>0 THEN "1" END AS redeemers,
points_spent,
-- sum(case when points_spent>0  then sales end)
redemption_sales,
-- SUM(CASE WHEN points_spent>0  THEN bills END)
redemption_bills
FROM base 
WHERE visit>10;

-- ____________________________________________MOM____points__________________________start_____________________

WITH txn AS (
SELECT CONCAT(LEFT(MONTHNAME(txndate),3),RIGHT(YEAR(txndate),2))PERIOD,
SUM(pointscollected)pointsissued,SUM(pointsspent)pointsredeemed FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2024-05-01' AND '2025-09-19'
AND storecode NOT LIKE '%demo%'
AND storecode NOT LIKE '%corporate%'
AND amount>0
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
AND insertiondate <='2025-09-02' 
GROUP BY 1
ORDER BY txndate
),
lapsed AS (
SELECT CONCAT(LEFT(MONTHNAME(lapsingdate),3),RIGHT(YEAR(lapsingdate),2))PERIOD,
SUM(pointslapsed)pointslapsed FROM lapse_report
WHERE lapsingdate BETWEEN '2024-05-01' AND '2025-09-19'
-- AND storecode NOT LIKE '%demo%'
-- AND storecode NOT LIKE '%corporate%'
-- AND amount>0
-- AND billno NOT LIKE '%test%' 
-- AND billno NOT LIKE '%roll%'
AND insertiondate <='2025-09-02' 
GROUP BY 1
ORDER BY lapsingdate
),
flat AS (
SELECT CONCAT(LEFT(MONTHNAME(txndate),3),RIGHT(YEAR(txndate),2))PERIOD,
SUM(pointscollected)bonus_points FROM `txn_report_flat_accrual`
WHERE txndate BETWEEN '2024-05-01' AND '2025-09-19'
AND storecode NOT LIKE '%demo%'
AND storecode NOT LIKE '%corporate%'
-- AND amount>0
-- AND billno NOT LIKE '%test%' 
-- AND billno NOT LIKE '%roll%'
AND insertiondate <='2025-09-02' 
GROUP BY 1
ORDER BY txndate
)
SELECT a.period,pointsissued,pointsredeemed,pointslapsed,bonus_points
FROM txn a LEFT JOIN lapsed b ON a.period=b.period 
LEFT JOIN flat c ON a.period=c.period
GROUP BY 1;

SELECT * FROM `txn_report_flat_accrual`;
SELECT SUM(pointslapsed) FROM lapse_report
WHERE txndate BETWEEN '2024-10-01' AND '2024-10-31'
AND storecode NOT LIKE '%demo%'
AND storecode NOT LIKE '%corporate%'
-- AND amount>0
-- AND billno NOT LIKE '%test%' 
-- AND billno NOT LIKE '%roll%'
AND insertiondate <='2025-09-02' ;

SELECT SUM(pointscollected)pointsissued,SUM(pointsspent)pointsredeemed FROM txn_report_accrual_redemption
WHERE txndate >='2024-05-01' 
AND storecode NOT LIKE '%demo%'
AND storecode NOT LIKE '%corporate%'
AND amount>0
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
AND insertiondate <='2025-09-02' ;


-- ______________________current points avaliable_______________________
 
SELECT COUNT(DISTINCT CASE WHEN availablepoints>0 THEN mobile END) customers,
SUM( CASE WHEN availablepoints>0 THEN availablepoints END) availablepoints
FROM member_report
WHERE modifiedenrolledon <='2025-09-19'
AND enrolledstorecode NOT IN ('demo', 'qrcode')
AND insertiondate<='2025-09-02';

-- _________________________________________MOM_______points______________end_______________________


SELECT time_bucket,COUNT(DISTINCT txnmappedmobile),SUM(visit)visit FROM(
SELECT CONCAT(LPAD(HOUR(modifiedtxntime), 2, '0'), ':00-', 
           LPAD(HOUR(modifiedtxntime)+1, 2, '0'), ':00') AS time_bucket,
 txnmappedmobile,COUNT(DISTINCT txndate,txnmappedmobile)visit FROM sku_report_loyalty
WHERE modifiedtxndate='2025-08-10'
GROUP BY 1,2)a 
GROUP BY 1

SELECT MAX(modifiedtxntime),MIN(modifiedtxntime) FROM sku_report_loyalty
WHERE modifiedtxndate='2025-08-11'
GROUP BY 1;#2025-09-04

SELECT modifiedtxntime,COUNT(DISTINCT txnmappedmobile) FROM txn_report_accrual_redemption

SELECT * FROM item_master;







####################################################################################################################
-- _____________________________________Category item description Level_______________________________start
SELECT itemdescription,categoryname,departmentname,
COUNT(DISTINCT txnmappedmobile) customers,
SUM(sales) AS sales,
SUM(itemqty) itemqty,
SUM(bills) bills,
SUM(visit)/COUNT(DISTINCT txnmappedmobile)visit,
COUNT(DISTINCT CASE WHEN maxf>1 THEN txnmappedmobile END)repeater,
SUM(CASE WHEN maxf>1 THEN sales END)repeater_sales,
SUM(CASE WHEN maxf>1 THEN bills END)repeater_bills,
SUM(CASE WHEN maxf>1 THEN itemqty END)repeater_qty,
SUM(CASE WHEN maxf>1 THEN visit END)/COUNT(DISTINCT CASE WHEN maxf>1 THEN txnmappedmobile END)repeater_visit,
AVG(latency)
FROM
(SELECT txnmappedmobile,categoryname,itemdescription,departmentname,
SUM(Frequencycount)maxf,
SUM(itemqty) AS itemqty,
COUNT(DISTINCT UniqueBillNo) AS bills,
SUM(itemnetamount) sales,
DATEDIFF(MAX(modifiedtxndate),MIN(modifiedtxndate))/NULLIF((COUNT(DISTINCT modifiedtxndate)-1),0)latency,
COUNT(DISTINCT txnmappedmobile,modifiedtxndate)visit
FROM `haldirams`.Sku_report_loyalty  a LEFT JOIN item_master b
USING(uniqueitemcode)
WHERE modifiedTxnDate BETWEEN '2025-06-01' AND '2025-08-31' 
AND storecode NOT LIKE '%demo%'
AND storecode NOT LIKE '%corporate%' 
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
AND a.insertiondate<='2025-09-02'
GROUP BY 1,2)b
GROUP BY 1;


-- _____________________________end _____________________________________



-- ________________________________________time cohort start ______________________________________--

SELECT time_range,DESCRIPTION,
COUNT(DISTINCT txnmappedmobile) customers,
SUM(sales) AS sales,
SUM(itemqty) itemqty,
SUM(bills) bills,
SUM(visit)/COUNT(DISTINCT txnmappedmobile)visit,
COUNT(DISTINCT CASE WHEN maxf>1 THEN txnmappedmobile END)repeater,
SUM(CASE WHEN maxf>1 THEN sales END)repeater_sales,
SUM(CASE WHEN maxf>1 THEN bills END)repeater_bills,
SUM(CASE WHEN maxf>1 THEN itemqty END)repeater_qty,
SUM(CASE WHEN maxf>1 THEN visit END)/COUNT(DISTINCT CASE WHEN maxf>1 THEN txnmappedmobile END)repeater_visit,
AVG(latency)
FROM (
SELECT txnmappedmobile,CASE 
        WHEN HOUR(modifiedtxntime) BETWEEN 9 AND 11 THEN '9-11 AM'
        WHEN HOUR(modifiedtxntime) BETWEEN 11 AND 13 THEN '11 AM-1 PM'
        WHEN HOUR(modifiedtxntime) BETWEEN 13 AND 16 THEN '1-4 PM'
        WHEN HOUR(modifiedtxntime) BETWEEN 16 AND 20 THEN '4-8 PM'
        WHEN HOUR(modifiedtxntime) BETWEEN 20 AND 23 THEN '8-11 PM'
        ELSE 'Other'
    END AS time_range,
    CASE 
        WHEN HOUR(modifiedtxntime) BETWEEN 9 AND 11 THEN 'Breakfast'
        WHEN HOUR(modifiedtxntime) BETWEEN 11 AND 13 THEN 'Brunch'
        WHEN HOUR(modifiedtxntime) BETWEEN 13 AND 16 THEN 'Lunch'
        WHEN HOUR(modifiedtxntime) BETWEEN 16 AND 20 THEN 'Snack Time'
        WHEN HOUR(modifiedtxntime) BETWEEN 20 AND 23 THEN 'Dinner'
        ELSE 'Other'
    END AS DESCRIPTION,
SUM(Frequencycount)maxf,
SUM(itemqty) AS itemqty,
COUNT(DISTINCT UniqueBillNo) AS bills,
SUM(itemnetamount) sales,
DATEDIFF(MAX(modifiedtxndate),MIN(modifiedtxndate))/NULLIF((COUNT(DISTINCT modifiedtxndate)-1),0)latency,
COUNT(DISTINCT txnmappedmobile,modifiedtxndate)visit
FROM `haldirams`.Sku_report_loyalty  a LEFT JOIN item_master b
USING(uniqueitemcode)
WHERE modifiedTxnDate BETWEEN '2025-06-01' AND '2025-08-31' 
AND storecode NOT LIKE '%demo%'
AND storecode NOT LIKE '%corporate%' 
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
AND a.insertiondate<='2025-09-02'
GROUP BY 1,2,3
ORDER BY modifiedtxntime,modifiedtxndate)a
GROUP BY 1,2
ORDER BY 1,2;
-- _________________________________________________end ______________________________________________


-- ________________________________________time cohort start mom ______________________________________--

SELECT time_range,DESCRIPTION,txnmonth,
COUNT(DISTINCT txnmappedmobile) customers,
SUM(sales) AS sales,
SUM(itemqty) itemqty,
SUM(bills) bills,
SUM(visit)/COUNT(DISTINCT txnmappedmobile)visit,
COUNT(DISTINCT CASE WHEN maxf>1 THEN txnmappedmobile END)repeater,
SUM(CASE WHEN maxf>1 THEN sales END)repeater_sales,
SUM(CASE WHEN maxf>1 THEN bills END)repeater_bills,
SUM(CASE WHEN maxf>1 THEN itemqty END)repeater_qty,
SUM(CASE WHEN maxf>1 THEN visit END)/COUNT(DISTINCT CASE WHEN maxf>1 THEN txnmappedmobile END)repeater_visit,
AVG(latency)
FROM (
SELECT txnmappedmobile,CASE 
        WHEN HOUR(modifiedtxntime) BETWEEN 9 AND 11 THEN '9-11 AM'
        WHEN HOUR(modifiedtxntime) BETWEEN 11 AND 13 THEN '11 AM-1 PM'
        WHEN HOUR(modifiedtxntime) BETWEEN 13 AND 16 THEN '1-4 PM'
        WHEN HOUR(modifiedtxntime) BETWEEN 16 AND 20 THEN '4-8 PM'
        WHEN HOUR(modifiedtxntime) BETWEEN 20 AND 23 THEN '8-11 PM'
        ELSE 'Other'
    END AS time_range,
    CASE 
        WHEN HOUR(modifiedtxntime) BETWEEN 9 AND 11 THEN 'Breakfast'
        WHEN HOUR(modifiedtxntime) BETWEEN 11 AND 13 THEN 'Brunch'
        WHEN HOUR(modifiedtxntime) BETWEEN 13 AND 16 THEN 'Lunch'
        WHEN HOUR(modifiedtxntime) BETWEEN 16 AND 20 THEN 'Snack Time'
        WHEN HOUR(modifiedtxntime) BETWEEN 20 AND 23 THEN 'Dinner'
        ELSE 'Other'
    END AS DESCRIPTION,txnmonth,
SUM(Frequencycount)maxf,
SUM(itemqty) AS itemqty,
COUNT(DISTINCT UniqueBillNo) AS bills,
SUM(itemnetamount) sales,
DATEDIFF(MAX(modifiedtxndate),MIN(modifiedtxndate))/NULLIF((COUNT(DISTINCT modifiedtxndate)-1),0)latency,
COUNT(DISTINCT txnmappedmobile,modifiedtxndate)visit
FROM `haldirams`.Sku_report_loyalty  a LEFT JOIN item_master b
USING(uniqueitemcode)
WHERE modifiedTxnDate BETWEEN '2025-06-01' AND '2025-08-31' 
AND storecode NOT LIKE '%demo%'
AND storecode NOT LIKE '%corporate%' 
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
AND a.insertiondate<='2025-09-02'
GROUP BY 1,2,3,4
ORDER BY modifiedtxntime,modifiedtxndate)a
GROUP BY 1,2,3
ORDER BY 1,2,3;

-- ________________________________________time cohort end ______________________________________--




-- ________________________________________time cohort start source,cat,itemdesc ______________________________________--

SELECT time_range,DESCRIPTION,SOURCE,itemdescription,categoryname,
COUNT(DISTINCT txnmappedmobile) customers,
SUM(sales) AS sales,
SUM(itemqty) itemqty,
SUM(bills) bills,
SUM(visit)/COUNT(DISTINCT txnmappedmobile)visit,
COUNT(DISTINCT CASE WHEN maxf>1 THEN txnmappedmobile END)repeater,
SUM(CASE WHEN maxf>1 THEN sales END)repeater_sales,
SUM(CASE WHEN maxf>1 THEN bills END)repeater_bills,
SUM(CASE WHEN maxf>1 THEN itemqty END)repeater_qty,
SUM(CASE WHEN maxf>1 THEN visit END)/COUNT(DISTINCT CASE WHEN maxf>1 THEN txnmappedmobile END)repeater_visit,
AVG(latency)
FROM (
SELECT txnmappedmobile,CASE 
        WHEN HOUR(modifiedtxntime) BETWEEN 9 AND 11 THEN '9-11 AM'
        WHEN HOUR(modifiedtxntime) BETWEEN 11 AND 13 THEN '11 AM-1 PM'
        WHEN HOUR(modifiedtxntime) BETWEEN 13 AND 16 THEN '1-4 PM'
        WHEN HOUR(modifiedtxntime) BETWEEN 16 AND 20 THEN '4-8 PM'
        WHEN HOUR(modifiedtxntime) BETWEEN 20 AND 23 THEN '8-11 PM'
        ELSE 'Other'
    END AS time_range,
    CASE 
        WHEN HOUR(modifiedtxntime) BETWEEN 9 AND 11 THEN 'Breakfast'
        WHEN HOUR(modifiedtxntime) BETWEEN 11 AND 13 THEN 'Brunch'
        WHEN HOUR(modifiedtxntime) BETWEEN 13 AND 16 THEN 'Lunch'
        WHEN HOUR(modifiedtxntime) BETWEEN 16 AND 20 THEN 'Snack Time'
        WHEN HOUR(modifiedtxntime) BETWEEN 20 AND 23 THEN 'Dinner'
        ELSE 'Other'
    END AS DESCRIPTION,
SOURCE,itemdescription,categoryname,
SUM(Frequencycount)maxf,
SUM(itemqty) AS itemqty,
COUNT(DISTINCT UniqueBillNo) AS bills,
SUM(itemnetamount) sales,
DATEDIFF(MAX(modifiedtxndate),MIN(modifiedtxndate))/NULLIF((COUNT(DISTINCT modifiedtxndate)-1),0)latency,
COUNT(DISTINCT txnmappedmobile,modifiedtxndate)visit
FROM `haldirams`.Sku_report_loyalty  a LEFT JOIN item_master b
USING(uniqueitemcode)
WHERE modifiedTxnDate BETWEEN '2025-06-01' AND '2025-08-31' 
AND storecode NOT LIKE '%demo%'
AND storecode NOT LIKE '%corporate%' 
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
AND a.insertiondate<='2025-09-02'
GROUP BY 1,2,3,4,5
ORDER BY modifiedtxntime,modifiedtxndate)a
GROUP BY 1,2,3,4
ORDER BY 1,2,3;

 
-- ________________________________________time cohort end ______________________________________--



-- ________________________________________time cohort start source ______________________________________--

SELECT time_range,DESCRIPTION,SOURCE,
COUNT(DISTINCT txnmappedmobile) customers,
SUM(sales) AS sales,
SUM(itemqty) itemqty,
SUM(bills) bills,
SUM(visit)/COUNT(DISTINCT txnmappedmobile)visit,
COUNT(DISTINCT CASE WHEN maxf>1 THEN txnmappedmobile END)repeater,
SUM(CASE WHEN maxf>1 THEN sales END)repeater_sales,
SUM(CASE WHEN maxf>1 THEN bills END)repeater_bills,
SUM(CASE WHEN maxf>1 THEN itemqty END)repeater_qty,
SUM(CASE WHEN maxf>1 THEN visit END)/COUNT(DISTINCT CASE WHEN maxf>1 THEN txnmappedmobile END)repeater_visit,
AVG(latency)
FROM (
SELECT txnmappedmobile,CASE 
        WHEN HOUR(modifiedtxntime) BETWEEN 9 AND 11 THEN '9-11 AM'
        WHEN HOUR(modifiedtxntime) BETWEEN 11 AND 13 THEN '11 AM-1 PM'
        WHEN HOUR(modifiedtxntime) BETWEEN 13 AND 16 THEN '1-4 PM'
        WHEN HOUR(modifiedtxntime) BETWEEN 16 AND 20 THEN '4-8 PM'
        WHEN HOUR(modifiedtxntime) BETWEEN 20 AND 23 THEN '8-11 PM'
        ELSE 'Other'
    END AS time_range,
    CASE 
        WHEN HOUR(modifiedtxntime) BETWEEN 9 AND 11 THEN 'Breakfast'
        WHEN HOUR(modifiedtxntime) BETWEEN 11 AND 13 THEN 'Brunch'
        WHEN HOUR(modifiedtxntime) BETWEEN 13 AND 16 THEN 'Lunch'
        WHEN HOUR(modifiedtxntime) BETWEEN 16 AND 20 THEN 'Snack Time'
        WHEN HOUR(modifiedtxntime) BETWEEN 20 AND 23 THEN 'Dinner'
        ELSE 'Other'
    END AS DESCRIPTION,
SOURCE,
SUM(Frequencycount)maxf,
SUM(itemqty) AS itemqty,
COUNT(DISTINCT UniqueBillNo) AS bills,
SUM(itemnetamount) sales,
DATEDIFF(MAX(modifiedtxndate),MIN(modifiedtxndate))/NULLIF((COUNT(DISTINCT modifiedtxndate)-1),0)latency,
COUNT(DISTINCT txnmappedmobile,modifiedtxndate)visit
FROM `haldirams`.Sku_report_loyalty  a LEFT JOIN item_master b
USING(uniqueitemcode)
WHERE modifiedTxnDate BETWEEN '2025-06-01' AND '2025-08-31' 
AND storecode NOT LIKE '%demo%'
AND storecode NOT LIKE '%corporate%' 
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
AND a.insertiondate<='2025-09-02'
GROUP BY 1,2,3
ORDER BY modifiedtxntime,modifiedtxndate)a
GROUP BY 1,2,3
ORDER BY 1,2,3;
-- _______________________________________________end _______________________________________________

-- ________________________________________time cohort start cat,itemdesc ______________________________________--

SELECT time_range,DESCRIPTION,itemdescription,categoryname,
COUNT(DISTINCT txnmappedmobile) customers,
SUM(sales) AS sales,
SUM(itemqty) itemqty,
SUM(bills) bills,
SUM(visit)/COUNT(DISTINCT txnmappedmobile)visit,
COUNT(DISTINCT CASE WHEN maxf>1 THEN txnmappedmobile END)repeater,
SUM(CASE WHEN maxf>1 THEN sales END)repeater_sales,
SUM(CASE WHEN maxf>1 THEN bills END)repeater_bills,
SUM(CASE WHEN maxf>1 THEN itemqty END)repeater_qty,
SUM(CASE WHEN maxf>1 THEN visit END)/COUNT(DISTINCT CASE WHEN maxf>1 THEN txnmappedmobile END)repeater_visit,
AVG(latency)
FROM (
SELECT txnmappedmobile,CASE 
        WHEN HOUR(modifiedtxntime) BETWEEN 9 AND 11 THEN '9-11 AM'
        WHEN HOUR(modifiedtxntime) BETWEEN 11 AND 13 THEN '11 AM-1 PM'
        WHEN HOUR(modifiedtxntime) BETWEEN 13 AND 16 THEN '1-4 PM'
        WHEN HOUR(modifiedtxntime) BETWEEN 16 AND 20 THEN '4-8 PM'
        WHEN HOUR(modifiedtxntime) BETWEEN 20 AND 23 THEN '8-11 PM'
        ELSE 'Other'
    END AS time_range,
    CASE 
        WHEN HOUR(modifiedtxntime) BETWEEN 9 AND 11 THEN 'Breakfast'
        WHEN HOUR(modifiedtxntime) BETWEEN 11 AND 13 THEN 'Brunch'
        WHEN HOUR(modifiedtxntime) BETWEEN 13 AND 16 THEN 'Lunch'
        WHEN HOUR(modifiedtxntime) BETWEEN 16 AND 20 THEN 'Snack Time'
        WHEN HOUR(modifiedtxntime) BETWEEN 20 AND 23 THEN 'Dinner'
        ELSE 'Other'
    END AS DESCRIPTION,
itemdescription,categoryname,
SUM(Frequencycount)maxf,
SUM(itemqty) AS itemqty,
COUNT(DISTINCT UniqueBillNo) AS bills,
SUM(itemnetamount) sales,
DATEDIFF(MAX(modifiedtxndate),MIN(modifiedtxndate))/NULLIF((COUNT(DISTINCT modifiedtxndate)-1),0)latency,
COUNT(DISTINCT txnmappedmobile,modifiedtxndate)visit
FROM `haldirams`.Sku_report_loyalty  a LEFT JOIN item_master b
USING(uniqueitemcode)
WHERE modifiedTxnDate BETWEEN '2025-06-01' AND '2025-08-31' 
AND storecode NOT LIKE '%demo%'
AND storecode NOT LIKE '%corporate%' 
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
AND a.insertiondate<='2025-09-02'
GROUP BY 1,2,3,4
ORDER BY modifiedtxntime,modifiedtxndate)a
GROUP BY 1,2,3
ORDER BY 1,2,3;



SELECT * FROM dummy.haldiram_customer_summary;
