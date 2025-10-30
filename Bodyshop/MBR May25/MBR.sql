-- 
-- -- non loyalty sales and bills 
-- WITH non_loyalty AS (
-- SELECT CASE WHEN modifiedtxndate BETWEEN '2024-05-01' AND '2024-05-31' THEN 'May-24'
-- WHEN modifiedtxndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'Apr-25'
-- WHEN modifiedtxndate BETWEEN '2025-05-01' AND '2025-05-31' THEN 'May-25' END AS `period`
-- -- CASE WHEN modifiedstorecode = '3011' THEN 'online' 
-- -- WHEN modifiedstorecode <> '3011' THEN  'offline' END CHANNEL
-- ,SUM(itemnetamount)nonloyalty_sales,COUNT(DISTINCT uniquebillno)non_loyaltybills
-- FROM sku_report_nonloyalty 
-- WHERE ((modifiedtxndate BETWEEN '2024-05-01' AND '2024-05-31') 
-- OR (modifiedtxndate BETWEEN '2025-04-01' AND '2025-04-30') 
-- OR (modifiedtxndate BETWEEN '2025-05-01' AND '2025-05-31'))
-- AND itemnetamount>0
-- -- AND ((modifiedstorecode = '3011')
-- -- OR (modifiedstorecode <> '3011'))
-- AND modifiedstorecode NOT LIKE '%demo%'
-- AND modifiedbillno NOT LIKE '%brn%'
-- AND modifiedbillno NOT LIKE '%roll%'
-- AND modifiedbillno NOT LIKE '%test%'
-- AND insertiondate <= '2025-06-15'
-- GROUP BY 1),
-- 
-- -- total sales 
-- total_sales AS (
-- SELECT `period`,SUM(sales)totalsales,SUM(bills)totalbills FROM ( 
-- SELECT CASE WHEN txndate BETWEEN '2024-05-01' AND '2024-05-31' THEN 'May-24'
-- WHEN txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'Apr-25'
-- WHEN txndate BETWEEN '2025-05-01' AND '2025-05-31' THEN 'May-25' END `period`,
--  SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills FROM txn_report_accrual_redemption 
-- WHERE ((txndate BETWEEN '2024-05-01' AND '2024-05-31')
-- OR (txndate BETWEEN '2025-04-01' AND '2025-04-30')
-- OR (txndate BETWEEN '2025-05-01' AND '2025-05-31'))
--  AND amount>0
-- AND billno NOT LIKE '%brn%'
-- AND billno NOT LIKE '%roll%'
-- AND billno NOT LIKE '%test%'
-- AND storecode NOT LIKE '%demo%'
-- -- AND storecode <> '3011'
-- AND insertiondate <= '2025-06-15'
-- GROUP BY 1
-- UNION
-- SELECT CASE WHEN modifiedtxndate BETWEEN '2024-05-01' AND '2024-05-31' THEN 'May-24'
-- WHEN modifiedtxndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'Apr-25'
-- WHEN modifiedtxndate BETWEEN '2025-05-01' AND '2025-05-31' THEN 'May-25' END `period`,
-- SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills
-- FROM sku_report_nonloyalty 
-- WHERE ((modifiedtxndate BETWEEN '2024-05-01' AND '2024-05-31')
-- OR (modifiedtxndate BETWEEN '2025-04-01' AND '2025-04-30')
-- OR (modifiedtxndate BETWEEN '2025-05-01' AND '2025-05-31'))
-- AND itemnetamount>0
-- AND modifiedstorecode NOT LIKE '%demo%'
-- AND modifiedbillno NOT LIKE '%brn%'
-- AND modifiedbillno NOT LIKE '%roll%'
-- AND modifiedbillno NOT LIKE '%test%'
-- -- AND modifiedstorecode <> '3011'
-- AND insertiondate <= '2025-06-15'
-- GROUP BY 1)a
-- GROUP BY 1),
-- 
-- loyalty_data AS(
-- -- loyalty data
-- SELECT `period`
-- ,COUNT(DISTINCT clientid)`Total Transactors`,
-- COUNT(DISTINCT CASE WHEN minf=1 AND maxf=1 THEN clientid END)`New/Onetimer Customers`,
-- COUNT(DISTINCT CASE WHEN maxf>1 THEN clientid END)`Repeat Customers`,
-- SUM(sales)`Loyalty Sales`,
-- SUM(CASE WHEN minf=1 AND maxf=1 THEN sales END)`New/Onetimer Sales`, 
-- SUM(CASE WHEN maxf>1 THEN sales END)`Repeat Sales`,
-- SUM(bills)`Loyalty Bills`,
-- SUM(CASE WHEN minf=1 AND maxf=1 THEN bills END)`New/Onetimer Bills`, 
-- SUM(CASE WHEN maxf>1 THEN bills END)`Repeat Bills`,
-- SUM(sales)/SUM(bills)Atv,SUM(sales)/COUNT(DISTINCT clientid)AMV,
-- SUM(visit)/COUNT(DISTINCT clientid)avg_visit,
-- COUNT(DISTINCT CASE WHEN points_redeemed>0 THEN clientid END)AS `Point Redeeemers`,
-- SUM( CASE WHEN points_redeemed>0 THEN sales END) AS `Pointn Redemption Sales`,
-- SUM(points_issued)`Points Issued`,SUM(points_redeemed)`Points Redeemed`
-- FROM (
-- SELECT CASE WHEN txndate BETWEEN '2024-05-01' AND '2024-05-31' THEN 'May-24'
-- WHEN txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'Apr-25'
-- WHEN txndate BETWEEN '2025-05-01' AND '2025-05-31' THEN 'May-25' END AS`period`,clientid,MAX(frequencycount)maxf,MIN(frequencycount)minf,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills,
-- COUNT(DISTINCT clientid,txndate)visit,SUM(pointscollected)points_issued,SUM(pointsspent)points_redeemed 
-- FROM txn_report_accrual_redemption 
-- WHERE ((txndate BETWEEN '2024-05-01' AND '2024-05-31') 
-- OR (txndate BETWEEN '2025-04-01' AND '2025-04-30') 
-- OR (txndate BETWEEN '2025-05-01' AND '2025-05-31'))
-- AND amount>0
-- AND storecode NOT LIKE '%demo%'
-- AND billno NOT LIKE '%brn%'
-- AND billno NOT LIKE '%roll%'
-- AND billno NOT LIKE '%test%'
-- AND insertiondate <= '2025-06-15'
-- GROUP BY 1,2 ORDER BY txndate)a
-- GROUP BY 1 ORDER BY `period`)
-- 
-- SELECT a.`period`,`Total Transactors`,`New/Onetimer Customers`,`Repeat Customers`,totalsales,`Loyalty Sales`,`New/Onetimer Sales`,
-- `Repeat Sales`,totalbills,`Loyalty Bills`,`New/Onetimer Bills`,`Repeat Bills`,Atv,AMV,avg_visit,`Point Redeeemers`,`Pointn Redemption Sales`,
-- `Points Issued`,`Points Redeemed`,nonloyalty_sales,non_loyaltybills
-- FROM loyalty_data a JOIN total_sales b ON a.`period`=b.`period`
-- JOIN non_loyalty c ON a.`period`=c.`period`
-- GROUP BY 1;

SELECT * FROM txn_report_accrual_redemption;
SELECT * FROM member_report;

-- enrollement channel wise 
SELECT CASE WHEN modifiedenrolledon BETWEEN '2024-05-01' AND '2024-05-31' THEN 'May-24'
WHEN modifiedenrolledon BETWEEN '2025-04-01' AND '2025-04-30' THEN 'Apr-25'
WHEN modifiedenrolledon BETWEEN '2025-05-01' AND '2025-05-31' THEN 'May-25' END AS`period`,
CASE WHEN enrolledstorecode = '3011' THEN 'online' ELSE 'offline' END AS channel_name,
COUNT(DISTINCT clientid)enrolled FROM member_report 
WHERE ((modifiedenrolledon BETWEEN '2024-05-01' AND '2024-05-31')
OR (modifiedenrolledon BETWEEN '2025-04-01' AND '2025-04-30')
OR (modifiedenrolledon BETWEEN '2025-05-01' AND '2025-05-31'))
AND ((enrolledstorecode = '3011')
OR (enrolledstorecode <> '3011'))
AND enrolledstorecode NOT LIKE '%demo%'
GROUP BY 1,2;

-- enrollement overall
SELECT CASE WHEN modifiedenrolledon BETWEEN '2024-05-01' AND '2024-05-31' THEN 'May-24'
WHEN modifiedenrolledon BETWEEN '2025-04-01' AND '2025-04-30' THEN 'Apr-25'
WHEN modifiedenrolledon BETWEEN '2025-05-01' AND '2025-05-31' THEN 'May-25' END AS`period`,
-- CASE WHEN enrolledstorecode = '3011' THEN 'online' ELSE 'offline' END AS channel_name,
COUNT(DISTINCT clientid)enrolled FROM member_report 
WHERE ((modifiedenrolledon BETWEEN '2024-05-01' AND '2024-05-31')
OR (modifiedenrolledon BETWEEN '2025-04-01' AND '2025-04-30')
OR (modifiedenrolledon BETWEEN '2025-05-01' AND '2025-05-31'))
-- AND ((enrolledstorecode = '3011')
-- OR (enrolledstorecode <> '3011'))
AND enrolledstorecode NOT LIKE '%demo%'
GROUP BY 1;



SELECT 'May24'tag,SUM(itemnetamount)nonloyalty_sales,COUNT(DISTINCT uniquebillno)nonLoyaltybills
FROM sku_report_nonloyalty 
WHERE modifiedtxndate BETWEEN '2024-05-01' AND '2024-05-31'
AND itemnetamount>0
AND modifiedstorecode NOT LIKE '%demo%'
AND modifiedbillno NOT LIKE '%brn%'
AND modifiedbillno NOT LIKE '%roll%'
AND modifiedbillno NOT LIKE '%test%'
AND insertiondate <= '2025-06-15'
UNION
SELECT 'Apr25'tag,SUM(itemnetamount)nonloyalty_sales,COUNT(DISTINCT uniquebillno)nonLoyaltybills
FROM sku_report_nonloyalty 
WHERE modifiedtxndate BETWEEN '2025-04-01' AND '2025-04-30'
AND itemnetamount>0
AND modifiedstorecode NOT LIKE '%demo%'
AND modifiedbillno NOT LIKE '%brn%'
AND modifiedbillno NOT LIKE '%roll%'
AND modifiedbillno NOT LIKE '%test%'
AND insertiondate <= '2025-06-15'
UNION
SELECT 'may25'tag,SUM(itemnetamount)nonloyalty_sales,COUNT(DISTINCT uniquebillno)nonLoyaltybills
FROM sku_report_nonloyalty 
WHERE modifiedtxndate BETWEEN '2025-05-01' AND '2025-05-31'
AND itemnetamount>0
AND modifiedstorecode NOT LIKE '%demo%'
AND modifiedbillno NOT LIKE '%brn%'
AND modifiedbillno NOT LIKE '%roll%'
AND modifiedbillno NOT LIKE '%test%'
AND insertiondate <= '2025-06-15';



-- non loyalty sales and bills 

SELECT CASE WHEN modifiedtxndate BETWEEN '2024-05-01' AND '2024-05-31' THEN 'may-24'
WHEN modifiedtxndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'Apr-25'
WHEN modifiedtxndate BETWEEN '2025-05-01' AND '2025-05-31' THEN 'may-25' END AS `period`,
CASE WHEN modifiedstorecode = '3011' THEN 'online' 
WHEN modifiedstorecode <> '3011' THEN  'offline' END CHANNEL
,SUM(itemnetamount)nonloyalty_sales,COUNT(DISTINCT uniquebillno)bills
FROM sku_report_nonloyalty 
WHERE ((modifiedtxndate BETWEEN '2024-05-01' AND '2024-05-31') 
OR (modifiedtxndate BETWEEN '2025-04-01' AND '2025-04-30') 
OR (modifiedtxndate BETWEEN '2025-05-01' AND '2025-05-31'))
AND itemnetamount>0
AND ((modifiedstorecode = '3011')
OR (modifiedstorecode <> '3011'))
AND modifiedstorecode NOT LIKE '%demo%'
AND modifiedbillno NOT LIKE '%brn%'
AND modifiedbillno NOT LIKE '%roll%'
AND modifiedbillno NOT LIKE '%test%'
AND insertiondate <= '2025-06-15'
GROUP BY 1,2;






SELECT CASE WHEN txndate BETWEEN '2024-05-01' AND '2024-05-31' THEN 'may24'
WHEN txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'apr25'
WHEN txndate BETWEEN '2025-05-01' AND '2025-05-31' THEN 'may25' END AS`period`
,COUNT(DISTINCT clientid)`Total Transactors` FROM txn_report_accrual_redemption 
WHERE ((txndate BETWEEN '2024-05-01' AND '2024-05-31') 
OR (txndate BETWEEN '2025-04-01' AND '2025-04-30')
OR (txndate BETWEEN '2025-05-01' AND '2025-05-31'))
AND amount>0
GROUP BY 1

SELECT COUNT(DISTINCT clientid)FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2025-05-01' AND '2025-05-31' AND  amount>0;

-- total sales 

SELECT `period`,SUM(sales)sales,SUM(bills)bills FROM ( 
SELECT CASE WHEN txndate BETWEEN '2024-05-01' AND '2024-05-31' THEN 'may24'
WHEN txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'apr25'
WHEN txndate BETWEEN '2025-05-01' AND '2025-05-31' THEN 'may25' END `period`,
 SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills FROM txn_report_accrual_redemption 
WHERE ((txndate BETWEEN '2024-05-01' AND '2024-05-31')
OR (txndate BETWEEN '2025-04-01' AND '2025-04-30')
OR (txndate BETWEEN '2025-05-01' AND '2025-05-31'))
 AND amount>0
AND billno NOT LIKE '%brn%'
AND billno NOT LIKE '%roll%'
AND billno NOT LIKE '%test%'
AND storecode NOT LIKE '%demo%'
AND storecode <> '3011'
AND insertiondate <= '2025-06-15'
GROUP BY 1
UNION
SELECT CASE WHEN modifiedtxndate BETWEEN '2024-05-01' AND '2024-05-31' THEN 'may24'
WHEN modifiedtxndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'apr25'
WHEN modifiedtxndate BETWEEN '2025-05-01' AND '2025-05-31' THEN 'may25' END `period`,
SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills
FROM sku_report_nonloyalty 
WHERE ((modifiedtxndate BETWEEN '2024-05-01' AND '2024-05-31')
OR (modifiedtxndate BETWEEN '2025-04-01' AND '2025-04-30')
OR (modifiedtxndate BETWEEN '2025-05-01' AND '2025-05-31'))
AND itemnetamount>0
AND modifiedstorecode NOT LIKE '%demo%'
AND modifiedbillno NOT LIKE '%brn%'
AND modifiedbillno NOT LIKE '%roll%'
AND modifiedbillno NOT LIKE '%test%'
AND modifiedstorecode <> '3011'
AND insertiondate <= '2025-06-15'
GROUP BY 1)a
GROUP BY 1;

-- loyalty data
SELECT `period`
,COUNT(DISTINCT clientid)`Total Transactors`,
COUNT(DISTINCT CASE WHEN minf=1 AND maxf=1 THEN clientid END)`New/Onetimer Customers`,
COUNT(DISTINCT CASE WHEN maxf>1 THEN clientid END)`Repeat Customers`,
SUM(sales)`Loyalty Sales`,
SUM(CASE WHEN minf=1 AND maxf=1 THEN sales END)`New/Onetimer Sales`, 
SUM(CASE WHEN maxf>1 THEN sales END)`Repeat Sales`,
SUM(bills)`Loyalty Bills`,
SUM(CASE WHEN minf=1 AND maxf=1 THEN bills END)`New/Onetimer Bills`, 
SUM(CASE WHEN maxf>1 THEN bills END)`Repeat Bills`,
SUM(sales)/SUM(bills)Atv,SUM(sales)/COUNT(DISTINCT clientid)AMV,
SUM(visit)/COUNT(DISTINCT clientid)avg_visit,
COUNT(DISTINCT CASE WHEN points_redeemed>0 THEN clientid END)AS `Point Redeeemers`,
SUM( CASE WHEN points_redeemed>0 THEN sales END) AS `Pointn Redemption Sales`,
SUM(points_issued)`Points Issued `,SUM(points_redeemed)`Points Redeemed`
FROM (
SELECT CASE WHEN txndate BETWEEN '2024-05-01' AND '2024-05-31' THEN 'May-24'
WHEN txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'Apr-25'
WHEN txndate BETWEEN '2025-05-01' AND '2025-05-31' THEN 'May-25' END AS`period`,clientid,MAX(frequencycount)maxf,MIN(frequencycount)minf,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills,
COUNT(DISTINCT clientid,txndate)visit,SUM(pointscollected)points_issued,SUM(pointsspent)points_redeemed 
FROM txn_report_accrual_redemption 
WHERE ((txndate BETWEEN '2024-05-01' AND '2024-05-31') 
OR (txndate BETWEEN '2025-04-01' AND '2025-04-30') 
OR (txndate BETWEEN '2025-05-01' AND '2025-05-31'))
AND amount>0
AND storecode NOT LIKE '%demo%'
AND billno NOT LIKE '%brn%'
AND billno NOT LIKE '%roll%'
AND billno NOT LIKE '%test%'
AND insertiondate <= '2025-06-15'
GROUP BY 1,2 ORDER BY txndate)a
GROUP BY 1 ORDER BY `period`;



-- online/offline

-- loyalty data
SELECT `period`
,COUNT(DISTINCT clientid)`Total Transactors`,
COUNT(DISTINCT CASE WHEN minf=1 AND maxf=1 THEN clientid END)`New/Onetimer Customers`,
COUNT(DISTINCT CASE WHEN maxf>1 THEN clientid END)`Repeat Customers`,
SUM(sales)`Loyalty Sales`,
SUM(CASE WHEN minf=1 AND maxf=1 THEN sales END)`New/Onetimer Sales`, 
SUM(CASE WHEN maxf>1 THEN sales END)`Repeat Sales`,
SUM(bills)`Loyalty Bills`,
SUM(CASE WHEN minf=1 AND maxf=1 THEN bills END)`New/Onetimer Bills`, 
SUM(CASE WHEN maxf>1 THEN bills END)`Repeat Bills`,
SUM(sales)/SUM(bills)Atv,SUM(sales)/COUNT(DISTINCT clientid)AMV,
SUM(visit)/COUNT(DISTINCT clientid)avg_visit,
COUNT(DISTINCT CASE WHEN points_redeemed>0 THEN clientid END)AS `Point Redeeemers`,
SUM( CASE WHEN points_redeemed>0 THEN sales END) AS `Pointn Redemption Sales`,
SUM(points_issued)`Points Issued `,SUM(points_redeemed)`Points Redeemed`
FROM (
SELECT CASE WHEN txndate BETWEEN '2024-05-01' AND '2024-05-31' THEN 'May-24'
WHEN txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'Apr-25'
WHEN txndate BETWEEN '2025-05-01' AND '2025-05-31' THEN 'May-25' END AS`period`,clientid,MAX(frequencycount)maxf,MIN(frequencycount)minf,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills,
COUNT(DISTINCT clientid,txndate)visit,SUM(pointscollected)points_issued,SUM(pointsspent)points_redeemed 
FROM txn_report_accrual_redemption 
WHERE ((txndate BETWEEN '2024-05-01' AND '2024-05-31') 
OR (txndate BETWEEN '2025-04-01' AND '2025-04-30') 
OR (txndate BETWEEN '2025-05-01' AND '2025-05-31'))
AND amount>0
AND storecode NOT LIKE '%demo%'
AND billno NOT LIKE '%brn%'
AND billno NOT LIKE '%roll%'
AND billno NOT LIKE '%test%'
-- AND storecode = '3011' #whenever you want to pull online data then uncomment this and comment below line 
AND storecode <> '3011'
AND insertiondate <= '2025-06-15'
GROUP BY 1,2 ORDER BY txndate)a
GROUP BY 1 ORDER BY `period`;






-- QC
SELECT SUM(pointsspent),SUM(pointscollected) FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2025-05-01' AND '2025-05-31'
AND amount>0
AND storecode NOT LIKE '%demo%'
AND billno NOT LIKE '%brn%'
AND billno NOT LIKE '%roll%'
AND billno NOT LIKE '%test%'
AND storecode <> '3011'
AND insertiondate <= '2025-06-15';


SELECT SUM(amount),COUNT(DISTINCT uniquebillno) FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2025-05-01' AND '2025-05-31'
AND amount>0
AND storecode NOT LIKE '%demo%'
AND billno NOT LIKE '%brn%'
AND billno NOT LIKE '%roll%'
AND billno NOT LIKE '%test%'
AND storecode = '3011'
AND insertiondate <= '2025-06-15';



-- online offline
-- slide 4 and rewards data 
WITH txn_data AS (
SELECT 
	CASE 
WHEN txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'Apr-24'
WHEN txndate BETWEEN '2025-05-01' AND '2025-05-31' THEN 'May-25' END AS`period`,
	CASE 
WHEN storecode ='3011' THEN 'Online'
WHEN storecode <> '3011' THEN 'Offline' END AS store_type,
COUNT(DISTINCT clientid)transacted_customer,
SUM(pointscollected)`Total Transaction Points Issued`,SUM(pointsspent)`Total Points Redeemed`,
COUNT(DISTINCT CASE WHEN pointsspent>0 THEN clientid END)`Point Redeemers`,
SUM(CASE WHEN pointsspent>0 THEN amount END)`Point Redemption Sales`
FROM txn_report_accrual_redemption 
WHERE ((txndate BETWEEN '2025-04-01' AND '2025-04-30') 
OR (txndate BETWEEN '2025-05-01' AND '2025-05-31'))
AND ((storecode ='3011')
OR (storecode <>'3011'))
AND amount>0
AND storecode NOT LIKE '%demo%'
AND billno NOT LIKE '%brn%'
AND billno NOT LIKE '%roll%'
AND billno NOT LIKE '%test%'
AND insertiondate <= '2025-06-15'
GROUP BY 1,2),
flat_data AS (
SELECT 
CASE 
WHEN txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'Apr-24'
WHEN txndate BETWEEN '2025-05-01' AND '2025-05-31' THEN 'May-25' END AS`period`,
	CASE 
WHEN storecode ='3011' THEN 'Online'
WHEN storecode <> '3011' THEN 'Offline' END AS store_type,
SUM(pointscollected)`Total Bonus Points Issued` 
FROM txn_report_flat_accrual 
WHERE ((txndate BETWEEN '2025-04-01' AND '2025-04-30') 
OR (txndate BETWEEN '2025-05-01' AND '2025-05-31'))
AND ((storecode ='3011')
OR (storecode <>'3011'))
-- AND amount>0
AND storecode NOT LIKE '%demo%'
AND billno NOT LIKE '%brn%'
AND billno NOT LIKE '%roll%'
AND billno NOT LIKE '%test%'
AND insertiondate <= '2025-06-15'
GROUP BY 1,2),
issued_coupon AS (
SELECT 
	CASE 
WHEN issueddate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'Apr-24'
WHEN issueddate BETWEEN '2025-05-01' AND '2025-05-31' THEN 'May-25' END AS`period`,
	CASE 
WHEN issuedstore ='3011' THEN 'Online'
WHEN issuedstore <> '3011' THEN 'Offline' END AS store_type,
COUNT(*)`Total Coupons Issued`
FROM coupon_offer_report 
WHERE ((issueddate BETWEEN '2025-04-01' AND '2025-04-30')
OR (issueddate BETWEEN '2025-05-01' AND '2025-05-31'))
AND ((issuedstore ='3011')
OR (issuedstore <> '3011'))
AND issuedstore NOT LIKE  '%demo%'
AND billno NOT LIKE '%brn%'
AND billno NOT LIKE '%roll%'
AND billno NOT LIKE '%test%'
AND insertiondate <= '2025-06-15'
GROUP BY 1,2),
coupon_data AS (
SELECT CASE 
WHEN useddate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'Apr-24'
WHEN useddate BETWEEN '2025-05-01' AND '2025-05-31' THEN 'May-25' END AS`period`,
	CASE 
WHEN redeemedstorecode ='3011' THEN 'Online'
WHEN redeemedstorecode <> '3011' THEN 'Offline' END AS store_type
,COUNT(couponoffercode)`Total Coupons Redeemed`,
COUNT(DISTINCT redeemedmobile)`Coupon Redeemers`,
SUM(discount)`Value of Coupon's Redeemed`,
SUM(amount)`Coupon Redemption Sale`
FROM coupon_offer_report
WHERE ((useddate BETWEEN '2025-04-01' AND '2025-04-30')
OR (useddate BETWEEN '2025-05-01' AND '2025-05-31'))
AND ((redeemedstorecode = '3011') 
OR (redeemedstorecode <> '3011'))
AND couponstatus ='used'
AND redeemedstorecode NOT LIKE '%demo%'
AND billno NOT LIKE '%brn%'
AND billno NOT LIKE '%roll%'
AND billno NOT LIKE '%test%'
AND insertiondate <= '2025-06-15'
GROUP BY 1,2
)
SELECT a.`period`,a.store_type,transacted_customer,`Total Transaction Points Issued`,`Total Bonus Points Issued`,`Total Points Redeemed`,`Point Redeemers`,`Point Redemption Sales`,`Total Coupons Issued`,`Total Coupons Redeemed`,`Coupon Redeemers`,`Value of Coupon's Redeemed`,`Coupon Redemption Sale`
FROM txn_data a JOIN flat_data b ON a.period=b.period AND a.store_type=b.store_type
JOIN issued_coupon c ON a.period=c.period AND a.store_type=c.store_type
JOIN coupon_data d ON a.period=d.period AND a.store_type=d.store_type
GROUP BY 1,2;


-- QC
SELECT SUM(pointscollected) FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2025-04-01' AND '2025-04-30'  
AND amount>0 
AND storecode NOT LIKE '%demo%'
AND billno NOT LIKE '%brn%'
AND billno NOT LIKE '%roll%'
AND billno NOT LIKE '%test%'
-- and storecode <> '3011'
AND storecode = '3011'
AND insertiondate <= '2025-06-15';

SELECT SUM(amount) FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2025-04-01' AND '2025-04-30'  
AND amount>0 
AND pointsspent>0
AND storecode NOT LIKE '%demo%'
AND billno NOT LIKE '%brn%'
AND billno NOT LIKE '%roll%'
AND billno NOT LIKE '%test%'
-- and storecode <> '3011'
AND storecode = '3011'
AND insertiondate <= '2025-06-15';


SELECT COUNT(*) FROM coupon_offer_report 
WHERE issueddate BETWEEN '2025-04-01' AND '2025-04-30'  
AND amount>0
-- AND issuedstore ='3011'
-- and issuedstore <> '3011'
AND issuedstore NOT LIKE '%demo%'
AND billno NOT LIKE '%brn%'
AND billno NOT LIKE '%roll%'
AND billno NOT LIKE '%test%'
AND insertiondate <= '2025-06-15';


SELECT COUNT(couponoffercode) FROM coupon_offer_report 
WHERE useddate BETWEEN '2025-04-01' AND '2025-04-30'  
AND amount>0
AND issuedstore ='3011'
-- and issuedstore <> '3011'
AND redeemedstorecode NOT LIKE '%demo%'
AND billno NOT LIKE '%brn%'
AND billno NOT LIKE '%roll%'
AND billno NOT LIKE '%test%'
AND insertiondate <= '2025-06-15';



SELECT COUNT(discount) FROM coupon_offer_report 
WHERE useddate BETWEEN '2025-04-01' AND '2025-04-30'  
AND amount>0 AND couponstatus='used'
AND issuedstore ='3011'
-- and issuedstore <> '3011'
AND redeemedstorecode NOT LIKE '%demo%'
AND billno NOT LIKE '%brn%'
AND billno NOT LIKE '%roll%'
AND billno NOT LIKE '%test%'
AND insertiondate <= '2025-06-15';


-- overall
-- slide 4 and rewards data 
WITH txn_data AS (
SELECT 
	CASE 
WHEN txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'Apr-24'
WHEN txndate BETWEEN '2025-05-01' AND '2025-05-31' THEN 'May-25' END AS`period`,
	-- CASE 
-- WHEN storecode ='3011' THEN 'Online'
-- WHEN storecode <> '3011' THEN 'Offline' END AS store_type,
COUNT(DISTINCT clientid)transacted_customer,
SUM(pointscollected)`Total Transaction Points Issued`,SUM(pointsspent)`Total Points Redeemed`,
COUNT(DISTINCT CASE WHEN pointsspent>0 THEN clientid END)`Point Redeemers`,
SUM(CASE WHEN pointsspent>0 THEN amount END)`Point Redemption Sales`
FROM txn_report_accrual_redemption 
WHERE ((txndate BETWEEN '2025-04-01' AND '2025-04-30') 
OR (txndate BETWEEN '2025-05-01' AND '2025-05-31'))
-- AND ((storecode ='3011')
-- OR (storecode <>'3011'))
AND amount>0
AND storecode NOT LIKE '%demo%'
AND billno NOT LIKE '%brn%'
AND billno NOT LIKE '%roll%'
AND billno NOT LIKE '%test%'
AND insertiondate <= '2025-06-15'
GROUP BY 1),
flat_data AS (
SELECT 
CASE 
WHEN txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'Apr-24'
WHEN txndate BETWEEN '2025-05-01' AND '2025-05-31' THEN 'May-25' END AS`period`,
	-- CASE 
-- WHEN storecode ='3011' THEN 'Online'
-- WHEN storecode <> '3011' THEN 'Offline' END AS store_type,
SUM(pointscollected)`Total Bonus Points Issued` 
FROM txn_report_flat_accrual 
WHERE ((txndate BETWEEN '2025-04-01' AND '2025-04-30') 
OR (txndate BETWEEN '2025-05-01' AND '2025-05-31'))
-- AND ((storecode ='3011')
-- OR (storecode <>'3011'))
-- AND amount>0
AND storecode NOT LIKE '%demo%'
AND billno NOT LIKE '%brn%'
AND billno NOT LIKE '%roll%'
AND billno NOT LIKE '%test%'
AND insertiondate <= '2025-06-15'
GROUP BY 1),
issued_coupon AS (
SELECT 
	CASE 
WHEN issueddate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'Apr-24'
WHEN issueddate BETWEEN '2025-05-01' AND '2025-05-31' THEN 'May-25' END AS`period`,
	-- CASE 
-- WHEN issuedstore ='3011' THEN 'Online'
-- WHEN issuedstore <> '3011' THEN 'Offline' END AS store_type,
COUNT(*)`Total Coupons Issued`
FROM coupon_offer_report 
WHERE ((issueddate BETWEEN '2025-04-01' AND '2025-04-30')
OR (issueddate BETWEEN '2025-05-01' AND '2025-05-31'))
-- AND ((issuedstore ='3011')
-- OR (issuedstore <> '3011'))
AND issuedstore NOT LIKE '%demo%'
AND billno NOT LIKE '%brn%'
AND billno NOT LIKE '%roll%'
AND billno NOT LIKE '%test%'
AND insertiondate <= '2025-06-15'
GROUP BY 1),
coupon_data AS (
SELECT CASE 
WHEN useddate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'Apr-24'
WHEN useddate BETWEEN '2025-05-01' AND '2025-05-31' THEN 'May-25' END AS`period`,
	-- CASE 
-- WHEN redeemedstorecode ='3011' THEN 'Online'
-- WHEN redeemedstorecode <> '3011' THEN 'Offline' END AS store_type,
COUNT(couponoffercode)`Total Coupons Redeemed`,
COUNT(DISTINCT redeemedmobile)`Coupon Redeemers`,
SUM(discount)`Value of Coupon's Redeemed`,
SUM(amount)`Coupon Redemption Sale`
FROM coupon_offer_report
WHERE ((useddate BETWEEN '2025-04-01' AND '2025-04-30')
OR (useddate BETWEEN '2025-05-01' AND '2025-05-31'))
-- AND ((redeemedstorecode = '3011') 
-- OR (redeemedstorecode <> '3011'))
AND couponstatus ='used'
AND redeemedstorecode NOT LIKE '%demo%'
AND billno NOT LIKE '%brn%'
AND billno NOT LIKE '%roll%'
AND billno NOT LIKE '%test%'
AND insertiondate <= '2025-06-15'
GROUP BY 1
)
SELECT a.`period`,transacted_customer,`Total Transaction Points Issued`,`Total Bonus Points Issued`,`Total Points Redeemed`,`Point Redeemers`,`Point Redemption Sales`,`Total Coupons Issued`,`Total Coupons Redeemed`,`Coupon Redeemers`,`Value of Coupon's Redeemed`,`Coupon Redemption Sale`
FROM txn_data a JOIN flat_data b ON a.period=b.period 
JOIN issued_coupon c ON a.period=c.period 
JOIN coupon_data d ON a.period=d.period 
GROUP BY 1;


-- Atv band 

SELECT 
      CASE 
    WHEN Atv > 0 AND Atv <= 500 THEN '0-500'
    WHEN Atv > 500 AND Atv <= 1000 THEN '500-1000'
    WHEN Atv > 1000 AND Atv <= 1500 THEN '1000-1500'
    WHEN Atv > 1500 AND Atv <= 2000 THEN '1500-2000'
    WHEN Atv > 2000 AND Atv <= 2500 THEN '2000-2500'
    WHEN Atv > 2500 AND Atv <= 3000 THEN '2500-3000'
    WHEN Atv > 3000 AND Atv <= 3500 THEN '3000-3500'
    WHEN Atv > 3500 AND Atv <= 4000 THEN '3500-4000'
    WHEN Atv > 4000 THEN '>4000' END `Atv Band`,
COUNT(DISTINCT clientid)customers,
SUM(bills)bills,SUM(sales)sales,
SUM(sales)/SUM(bills)ATV,
SUM(sales)/COUNT(DISTINCT clientid)AMV
FROM (
SELECT clientid,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills,SUM(amount)/COUNT(DISTINCT uniquebillno)Atv
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2025-05-01' AND '2025-05-31'
AND amount>0 
AND storecode NOT LIKE '%demo%'
AND billno NOT LIKE '%brn%'
AND billno NOT LIKE '%roll%'
AND billno NOT LIKE '%test%'
AND insertiondate <= '2025-06-15'
GROUP BY 1)a
GROUP BY 1 ORDER BY Atv;

-- QC
SELECT CASE WHEN atv>0 AND atv<=500 THEN '0-500'END `period` ,COUNT(DISTINCT clientid)customer,SUM(sales),SUM(bills)  FROM (
SELECT  clientid ,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills,SUM(amount)/COUNT(DISTINCT uniquebillno)atv FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2025-05-01' AND '2025-05-31'
AND amount>0 
AND storecode NOT LIKE '%demo%'
AND billno NOT LIKE '%brn%'
AND billno NOT LIKE '%roll%'
AND billno NOT LIKE '%test%'
AND insertiondate <= '2025-06-15'
GROUP BY 1)a
GROUP BY 1;


SELECT tier, clientid FROM member_report GROUP BY 1,2;
SELECT * FROM member_report
WHERE clientid IN ('1000009960',
'1000009966',
'1231420589',
'1232530157',
'8658403530',
'1000009906',
'1000009957',
'1230780195',
'1230840667',
'1231120735');

-- tier wise redemeed data 
SELECT b.tier,MONTH(useddate)MONTH,COUNT(DISTINCT redeemedmobile)redeemers,COUNT(couponoffercode)coupon_redemeed,
SUM(amount)redeemption_sales,COUNT(DISTINCT billno)redemption_bills,SUM(discount)discount 
FROM coupon_offer_report a JOIN member_report b ON a.redeemedmobile=b.mobile 
WHERE useddate BETWEEN '2025-05-01' AND '2025-05-31'
AND amount>0 AND  redeemedstorecode NOT LIKE '%demo%'
AND billno NOT LIKE '%brn%'
AND billno NOT LIKE '%roll%'
AND billno NOT LIKE '%test%'
AND a.insertiondate <= '2025-06-15'
GROUP BY 1,2;


-- tier wise issued data 
SELECT a.tier,MONTH(issueddate)MONTH,COUNT(*)issued FROM coupon_offer_report a JOIN member_report b ON a.issuedmobile=b.mobile 
WHERE issueddate BETWEEN '2025-05-01' AND '2025-05-31'
AND amount>0 AND  issuedstore NOT LIKE '%demo%'
AND billno NOT LIKE '%brn%'
AND billno NOT LIKE '%roll%'
AND billno NOT LIKE '%test%'
AND a.insertiondate <= '2025-06-15'
GROUP BY 1,2;

SELECT b.tier,MONTH(txndate)MONTH,COUNT(DISTINCT clientid)customers,SUM(a.pointscollected)pointscollected,SUM(a.pointsspent)pointsspent 
FROM txn_report_accrual_redemption a JOIN member_report b USING(clientid)
WHERE txndate BETWEEN '2025-05-01' AND '2025-05-31'
AND amount>0 
AND storecode NOT LIKE '%demo%'
AND billno NOT LIKE '%brn%'
AND billno NOT LIKE '%roll%'
AND billno NOT LIKE '%test%'
AND a.insertiondate <= '2025-06-15'
GROUP BY 1,2;


-- QC
SELECT COUNT(DISTINCT redeemedmobile)redeemers,SUM(amount),SUM(discount) FROM coupon_offer_report 
WHERE useddate BETWEEN '2025-05-01' AND '2025-05-31'
AND amount>0 AND  issuedstore NOT LIKE '%demo%'
AND billno NOT LIKE '%brn%'
AND billno NOT LIKE '%roll%'
AND billno NOT LIKE '%test%'
AND insertiondate <= '2025-06-15';

-- tier wise bonus points naration 
SELECT tier,narration,SUM(pointscollected)points_issued FROM txn_report_flat_accrual a JOIN member_report b USING(clientid)
WHERE txndate BETWEEN '2025-05-01' AND '2025-05-31' 
-- and amount>0
AND billno NOT LIKE '%brn%'
AND billno NOT LIKE '%roll%'
AND billno NOT LIKE '%test%'
AND a.insertiondate <= '2025-06-15'
AND storecode NOT LIKE '%like%'
GROUP BY 1,2;


SELECT * FROM txn_report_flat_accrual a JOIN member_report b ON a.clientid=b.clientid
WHERE txndate BETWEEN '2025-05-01' AND '2025-05-31' 
SELECT * FROM txn_report_flat_accrual