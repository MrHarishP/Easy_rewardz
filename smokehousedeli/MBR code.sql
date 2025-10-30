
-- for L2L

-- txndata
WITH base_25_loy AS  (
SELECT DISTINCT storecode FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2025-09-01' AND '2025-10-31'
AND storecode NOT IN('demo','Corporate','Whatsapp','DummyStore') 
AND BillNo NOT LIKE '%test%' 
AND BillNo NOT LIKE '%roll%'
-- AND amount > 0 
),

base_24_loy AS (
SELECT DISTINCT storecode FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2024-10-01' AND '2024-10-31'
AND storecode NOT IN('demo','Corporate','Whatsapp','DummyStore') 
AND BillNo NOT LIKE '%test%' 
AND BillNo NOT LIKE '%roll%'
-- AND amount > 0 
),
LTL_store_loy AS (
SELECT DISTINCT storecode FROM base_24_loy a JOIN base_25_loy b USING(storecode)#7
),

txn_data AS (
SELECT PERIOD, COUNT(DISTINCT mobile)Transacting_customer,
COUNT(DISTINCT CASE WHEN minf=1 AND maxf=1 THEN mobile END)New_one_timer,
COUNT(DISTINCT CASE WHEN minf=1 AND maxf>1 THEN mobile END)New_Repeater,
COUNT(DISTINCT CASE WHEN minf>1 THEN mobile END)Old_Repeater,
SUM(sales)Loyalty_sales,
SUM(CASE WHEN minf=1 AND maxf=1 THEN sales END)new_one_timer_sales,
SUM(CASE WHEN minf=1 AND maxf>1 THEN sales END)new_Repeater_sales,
SUM(CASE WHEN minf>1  THEN sales END)Old_Repeater_sales,
SUM(bills)Loyalty_bills,
SUM(CASE WHEN minf=1 AND maxf=1 THEN bills END)new_one_timer_bills,
SUM(CASE WHEN minf=1 AND maxf>1 THEN bills END)new_Repeater_bills,
SUM(CASE WHEN minf>1  THEN bills END)Old_Repeater_bills,
SUM(sales)/SUM(bills)ABV,
SUM(CASE WHEN minf=1 AND maxf=1 THEN sales END)/SUM(CASE WHEN minf=1 AND maxf=1 THEN bills END)New_one_timer_abv,
SUM(CASE WHEN minf=1 AND maxf>1 THEN sales END)/SUM(CASE WHEN minf=1 AND maxf>1 THEN bills END)New_repeater_abv,
SUM(CASE WHEN minf>1 THEN sales END)/SUM(CASE WHEN minf>1 THEN bills END)Old_repeater_abv,
SUM(sales)/COUNT(DISTINCT mobile)AMV,
SUM(CASE WHEN minf=1 AND maxf=1 THEN sales END)/COUNT(DISTINCT CASE WHEN minf=1 AND maxf=1 THEN mobile END)New_one_timer_AMV,
SUM(CASE WHEN minf=1 AND maxf>1 THEN sales END)/COUNT(DISTINCT CASE WHEN minf=1 AND maxf>1 THEN mobile END)New_Repeater_AMV,
SUM(CASE WHEN minf>1 THEN sales END)/COUNT(DISTINCT CASE WHEN minf>1 THEN mobile END)Old_Repeater_AMV
FROM(
SELECT mobile,
CASE WHEN txndate BETWEEN '2024-10-01' AND '2024-10-31' 
THEN CONCAT(LEFT(MONTHNAME(txndate),3),RIGHT(YEAR(txndate),2))
WHEN txndate BETWEEN '2025-09-01' AND '2025-09-30'
THEN CONCAT(LEFT(MONTHNAME(txndate),3),RIGHT(YEAR(txndate),2))
WHEN txndate BETWEEN '2025-10-01' AND '2025-10-31' 
THEN CONCAT(LEFT(MONTHNAME(txndate),3),RIGHT(YEAR(txndate),2))
END PERIOD,
SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills,
MIN(frequencycount)minf,MAX(frequencycount)maxf 
FROM txn_report_accrual_redemption 
WHERE ((txndate BETWEEN '2024-10-01' AND '2024-10-31')
OR (txndate BETWEEN '2025-09-01' AND '2025-09-30')
OR (txndate BETWEEN '2025-10-01' AND '2025-10-31'))
AND storecode NOT IN('demo','Corporate','Whatsapp','DummyStore') 
AND BillNo NOT LIKE '%test%' 
AND BillNo NOT LIKE '%roll%'
-- AND amount > 0
AND storecode IN (SELECT DISTINCT storecode FROM LTL_store_loy)
GROUP BY 1,2)a 
GROUP BY 1),
-- enrollmnet
 base_25_enr AS (
SELECT DISTINCT enrolledstorecode FROM member_report 
WHERE modifiedenrolledon BETWEEN '2025-09-01' AND '2025-10-31'
AND EnrolledStorecode NOT IN('demo','Corporate','Whatsapp','DummyStore') 
 AND EnrolledStorecode NOT  LIKE '%test%'),

base_24_enr AS (
SELECT DISTINCT enrolledstorecode FROM member_report 
WHERE modifiedenrolledon BETWEEN '2024-10-01' AND '2024-10-31'
AND EnrolledStorecode NOT IN('demo','Corporate','Whatsapp','DummyStore') 
 AND EnrolledStorecode NOT  LIKE '%test%'),

enrolled_ltl_store AS (
SELECT DISTINCT enrolledstorecode FROM base_24_enr a JOIN base_25_enr b USING(enrolledstorecode))
,
enrollment AS (
SELECT 
CASE WHEN modifiedenrolledon BETWEEN '2024-10-01' AND '2024-10-31' 
THEN CONCAT(LEFT(MONTHNAME(modifiedenrolledon),3),RIGHT(YEAR(modifiedenrolledon),2))
WHEN modifiedenrolledon BETWEEN '2025-09-01' AND '2025-09-30'
THEN CONCAT(LEFT(MONTHNAME(modifiedenrolledon),3),RIGHT(YEAR(modifiedenrolledon),2))
WHEN modifiedenrolledon BETWEEN '2025-10-01' AND '2025-10-31' 
THEN CONCAT(LEFT(MONTHNAME(modifiedenrolledon),3),RIGHT(YEAR(modifiedenrolledon),2))
END PERIOD,
COUNT(DISTINCT mobile)Enrollment FROM member_report
WHERE 
((modifiedenrolledon BETWEEN '2024-10-01' AND '2024-10-31')
OR (modifiedenrolledon BETWEEN '2025-09-01' AND '2025-09-30')
OR (modifiedenrolledon BETWEEN '2025-10-01' AND '2025-10-31'))
AND EnrolledStorecode NOT IN('demo','Corporate','Whatsapp','DummyStore') 
AND EnrolledStorecode NOT  LIKE '%test%'
AND enrolledstorecode IN (SELECT DISTINCT enrolledstorecode FROM enrolled_ltl_store)
GROUP BY 1
),

-- nonloyalty data 
 base_24_nonloyalty AS (
SELECT DISTINCT ModifiedStoreCode FROM sku_report_nonloyalty 
WHERE modifiedtxndate BETWEEN'2024-10-01' AND '2024-10-31'
AND ModifiedStoreCode NOT IN('demo','Corporate','Whatsapp','DummyStore') 
-- AND itemnetamount>0
),
base_25_nonloyalty AS (
SELECT DISTINCT ModifiedStoreCode FROM sku_report_nonloyalty 
WHERE modifiedtxndate BETWEEN'2025-09-01' AND '2025-10-31'
AND ModifiedStoreCode NOT IN('demo','Corporate','Whatsapp','DummyStore') 
-- AND itemnetamount>0
),
non_loyalty_ltl_store AS (
SELECT DISTINCT ModifiedStoreCode FROM base_24_nonloyalty a JOIN base_25_nonloyalty b USING(ModifiedStoreCode)
),

non_loyalty_data AS ( 
SELECT 
CASE WHEN modifiedtxndate BETWEEN '2024-10-01' AND '2024-10-31' 
THEN CONCAT(LEFT(MONTHNAME(modifiedtxndate),3),RIGHT(YEAR(modifiedtxndate),2))
WHEN modifiedtxndate BETWEEN '2025-09-01' AND '2025-09-30'
THEN CONCAT(LEFT(MONTHNAME(modifiedtxndate),3),RIGHT(YEAR(modifiedtxndate),2))
WHEN modifiedtxndate BETWEEN '2025-10-01' AND '2025-10-31' 
THEN CONCAT(LEFT(MONTHNAME(modifiedtxndate),3),RIGHT(YEAR(modifiedtxndate),2))
END PERIOD,
SUM(itemnetamount)NONloyalty_sales,COUNT(DISTINCT uniquebillno)nonloyalty_bills 
FROM sku_report_nonloyalty 
WHERE 
((modifiedtxndate BETWEEN'2024-10-01' AND '2024-10-31')
OR(modifiedtxndate BETWEEN'2025-09-01' AND '2025-09-30')
OR (modifiedtxndate BETWEEN'2025-10-01' AND '2025-10-31'))
-- AND itemnetamount>0 
AND ModifiedStoreCode IN (SELECT DISTINCT ModifiedStoreCode FROM non_loyalty_ltl_store)
GROUP BY 1
)
-- ,
-- -- coupon data issued
--  base_24_coupon AS (
-- SELECT DISTINCT issuedstore FROM coupon_offer_report 
-- WHERE issueddate BETWEEN'2024-10-01' AND '2024-10-31'
-- AND issuedstore NOT IN ('demo','Corporate','Whatsapp','DummyStore')
-- AND amount>0),
-- base_25_coupon AS (
-- SELECT DISTINCT issuedstore FROM coupon_offer_report 
-- WHERE issueddate BETWEEN'2025-09-01' AND '2025-10-31'
-- AND amount>0
-- and issuedstore not in ('demo','Corporate','Whatsapp','DummyStore')),
-- Coupon_ltl_store AS (
-- SELECT DISTINCT issuedstore FROM base_24_coupon a JOIN base_25_coupon b USING(issuedstore)
-- )
-- ,
-- 
-- issued_coupon as (
-- SELECT 
-- CASE WHEN issueddate BETWEEN '2024-10-01' AND '2024-10-31' 
-- THEN CONCAT(LEFT(MONTHNAME(issueddate),3),RIGHT(YEAR(issueddate),2))
-- WHEN issueddate BETWEEN '2025-09-01' AND '2025-09-30'
-- THEN CONCAT(LEFT(MONTHNAME(issueddate),3),RIGHT(YEAR(issueddate),2))
-- WHEN issueddate BETWEEN '2025-10-01' AND '2025-10-31' 
-- THEN CONCAT(LEFT(MONTHNAME(issueddate),3),RIGHT(YEAR(issueddate),2))
-- END PERIOD,COUNT(*)Issued
-- FROM coupon_offer_report
-- WHERE ((issueddate BETWEEN'2024-10-01' AND '2024-10-31')
-- OR(issueddate BETWEEN'2025-09-01' AND '2025-09-30')
-- OR (issueddate BETWEEN'2025-10-01' AND '2025-10-31'))
-- AND issuedstore NOT IN ('demo','Corporate','Whatsapp','DummyStore')
-- and issuedstore in (select distinct issuedstore from Coupon_ltl_store)
-- group by 1
-- )
-- ,
-- 
-- -- coupon data redemed 
--  base_24_coupon_redeemed AS (
-- SELECT DISTINCT redeemedstore FROM coupon_offer_report 
-- WHERE useddate BETWEEN'2024-10-01' AND '2024-10-31'
-- AND redeemedstore NOT IN ('demo','Corporate','Whatsapp','DummyStore')
-- and couponstatus='used'
-- AND amount>0),
-- base_25_coupon_redeemed AS (
-- SELECT DISTINCT redeemedstore FROM coupon_offer_report 
-- WHERE useddate BETWEEN'2025-09-01' AND '2025-10-31'
-- AND amount>0
-- and couponstatus='used'
-- AND redeemedstore NOT IN ('demo','Corporate','Whatsapp','DummyStore')),
-- Coupon_ltl_store_redeemed AS (
-- SELECT DISTINCT redeemedstore FROM base_24_coupon_redeemed a JOIN base_25_coupon_redeemed b USING(redeemedstore)
-- )
-- ,
-- 
-- redeemed_coupon AS (
-- SELECT CASE WHEN useddate BETWEEN '2024-10-01' AND '2024-10-31' 
-- THEN CONCAT(LEFT(MONTHNAME(useddate),3),RIGHT(YEAR(useddate),2))
-- WHEN useddate BETWEEN '2025-09-01' AND '2025-09-30'
-- THEN CONCAT(LEFT(MONTHNAME(useddate),3),RIGHT(YEAR(useddate),2))
-- WHEN useddate BETWEEN '2025-10-01' AND '2025-10-31' 
-- THEN CONCAT(LEFT(MONTHNAME(useddate),3),RIGHT(YEAR(useddate),2))
-- END PERIOD,
-- COUNT(couponcode)CouponsRedeemed
-- FROM coupon_offer_report
-- WHERE ((useddate BETWEEN'2024-10-01' AND '2024-10-31')
-- OR(useddate BETWEEN'2025-09-01' AND '2025-09-30')
-- OR (useddate BETWEEN'2025-10-01' AND '2025-10-31'))
-- AND redeemedstore NOT IN ('demo','Corporate','Whatsapp','DummyStore')
-- AND redeemedstore IN (SELECT DISTINCT redeemedstore FROM Coupon_ltl_store_redeemed)
-- group by 1
-- )

SELECT 
    a.period,
    b.Enrollment,
    a.Transacting_customer,
    a.New_one_timer,
    a.New_Repeater,
    a.Old_Repeater,
    (a.Loyalty_sales + IFNULL(c.nonloyalty_sales,0)) AS Total_sales,
    a.Loyalty_sales,
    a.new_one_timer_sales,
    a.new_Repeater_sales,
    a.Old_Repeater_sales,
    (a.Loyalty_bills + IFNULL(c.nonloyalty_bills,0)) AS Total_bills,
    a.Loyalty_bills,
    a.new_one_timer_bills,
    a.new_Repeater_bills,
    a.Old_Repeater_bills,
    a.ABV,
    a.New_one_timer_abv,
    a.New_repeater_abv,
    a.Old_repeater_abv,
    a.AMV,
    a.New_one_timer_AMV,
    a.New_Repeater_AMV,
    a.Old_Repeater_AMV
    -- ,
--     d.Issued AS coupon_issued
--     e.CouponsRedeemed
FROM txn_data a
LEFT JOIN enrollment b USING (PERIOD)
LEFT JOIN non_loyalty_data c ON a.period = c.period
-- JOIN issued_coupon d ON a.period = d.period
-- JOIN redeemed_coupon e ON a.period = e.period
GROUP BY 1;


-- Reward analysis

-- issued 
WITH isused AS (
SELECT CASE WHEN issueddate BETWEEN '2025-08-01' AND '2025-08-31' 
THEN CONCAT(LEFT(MONTHNAME(issueddate),3),'-',RIGHT(YEAR(issueddate),2)) 
WHEN issueddate BETWEEN '2025-09-01' AND '2025-09-30' 
THEN CONCAT(LEFT(MONTHNAME(issueddate),3),'-',RIGHT(YEAR(issueddate),2)) END PERIOD,
COUNT(*)Issued
FROM coupon_offer_report
WHERE ((issueddate BETWEEN '2025-08-01' AND '2025-08-31')
OR (issueddate BETWEEN '2025-09-01' AND '2025-09-30'))
AND issuedstore NOT IN('demo','Corporate','Whatsapp','DummyStore') 
GROUP BY 1),

redeemed AS (
SELECT 
CASE WHEN useddate BETWEEN '2025-08-01' AND '2025-08-31' 
THEN CONCAT(LEFT(MONTHNAME(useddate),3),'-',RIGHT(YEAR(useddate),2)) 
WHEN useddate BETWEEN '2025-09-01' AND '2025-09-30' 
THEN CONCAT(LEFT(MONTHNAME(useddate),3),'-',RIGHT(YEAR(useddate),2)) END PERIOD,
COUNT(couponcode)CouponsRedeemed,
COUNT(DISTINCT issuedmobile)Coupon_Redeemers, 
SUM(discount)discount,
SUM(b.amount)RedemptionSale 
FROM coupon_offer_report a 
JOIN txn_Report_accrual_Redemption b 
ON a.billno=b.modifiedbillno 
WHERE ((useddate BETWEEN '2025-08-01' AND '2025-08-31')
OR(useddate BETWEEN '2025-09-01' AND '2025-09-30'))
AND couponstatus = 'Used' 
AND redeemedstorecode NOT IN('demo','Corporate','Whatsapp','DummyStore') 
GROUP BY 1),

txndata AS (
SELECT 
CASE WHEN txndate BETWEEN '2025-08-01' AND '2025-08-31' 
THEN CONCAT(LEFT(MONTHNAME(txndate),3),'-',RIGHT(YEAR(txndate),2)) 
WHEN txndate BETWEEN '2025-09-01' AND '2025-09-30' 
THEN CONCAT(LEFT(MONTHNAME(txndate),3),'-',RIGHT(YEAR(txndate),2)) END PERIOD,
COUNT(DISTINCT mobile)Total_customers,SUM(amount)Loyalty_sales FROM txn_Report_accrual_Redemption
WHERE ((txndate BETWEEN '2025-08-01' AND '2025-08-31')
OR (txndate BETWEEN '2025-09-01' AND '2025-09-30'))
AND storecode NOT IN('demo','Corporate','Whatsapp','DummyStore') 
-- and amount>0
GROUP BY 1
)

SELECT a.period,
Issued AS 'Total Coupons issued',
CouponsRedeemed AS 'Total coupons redeemed',
CouponsRedeemed/Issued AS 'Coupon Redemption Rate (Redeemed Coupons/Issued Coupons)',
Total_customers AS 'Total customers',
Coupon_Redeemers AS 'Coupon Redeemers',
Coupon_Redeemers/Total_customers AS '% Coupon Redeemers',
RedemptionSale AS 'Coupon Redemption Sales',
Loyalty_sales AS 'Total Loyalty Sales'
FROM isused a JOIN redeemed b ON a.period=b.period
JOIN txndata c ON a.period=c.period;

##################
-- COUPON PERFORMANCE

WITH cpupon_code AS (
SELECT DISTINCT CouponOfferCode 
FROM (
    SELECT DISTINCT CouponOfferCode
    FROM coupon_offer_report
    WHERE UsedDate BETWEEN '2025-09-01' AND '2025-09-30'
    
    UNION 
    
    SELECT DISTINCT CouponOfferCode
    FROM coupon_offer_report
    WHERE IssuedDate BETWEEN '2025-09-01' AND '2025-09-30'
) AS A),

issued AS (
SELECT CouponOfferCode,
COUNT(*)Issued
FROM coupon_offer_report a JOIN cpupon_code b USING(CouponOfferCode)
WHERE issueddate BETWEEN '2025-09-01' AND '2025-09-30'
AND issuedstore NOT IN('demo','Corporate','Whatsapp','DummyStore') 
GROUP BY 1),
redeemed AS (
SELECT CouponOfferCode,
COUNT(couponcode)CouponsRedeemed,
COUNT(DISTINCT issuedmobile)Coupon_Redeemers, 
SUM(discount)discount,
SUM(b.amount)RedemptionSale 
FROM coupon_offer_report a 
JOIN txn_Report_accrual_Redemption b 
ON a.billno=b.modifiedbillno 
WHERE useddate BETWEEN '2025-09-01' AND '2025-09-30'
AND couponstatus = 'Used' 
AND redeemedstorecode NOT IN('demo','Corporate','Whatsapp','DummyStore') 
GROUP BY 1)

SELECT a.CouponOfferCode,
Issued,CouponsRedeemed,CouponsRedeemed/Issued'REDEMPTION RATE (%)​',Coupon_Redeemers,
RedemptionSale,
discount,discount/RedemptionSale '% OF DISC.​' 
FROM cpupon_code a LEFT JOIN issued b ON a.CouponOfferCode=b.CouponOfferCode
LEFT JOIN redeemed c ON a.CouponOfferCode=c.CouponOfferCode;



-- _________________________________________ TIER MIGRATION work on it _____________________________
WITH current_customer AS (
SELECT CurrentTier,
COUNT(DISTINCT mobile)cur_count 
FROM tier_report_log 
WHERE TierStartDate<='2025-09-30'
GROUP BY 1),

at_migration AS (
SELECT CurrentTier,
COUNT(DISTINCT mobile)migration
FROM tier_report_log 
WHERE TierStartDate<='2025-08-28'
GROUP BY 1)

SELECT CurrentTier,
cur_count AS 'Current Customer Count​',
IFNULL(migration,0) AS 'At the time of Migration​',
IFNULL(cur_count-migration,0) AS 'New Enrolment in the tier​',
IFNULL(
    (IFNULL(cur_count,0) - IFNULL(migration,0)) / 
    NULLIF(IFNULL(cur_count,0),0),
0) AS `% New Customer​`

FROM current_customer a LEFT JOIN at_migration b USING(CurrentTier)
GROUP BY 1;


-- _____________________________________COUPON CONSUMPTION OVERVIEW_________________________

WITH tier_issued AS (
SELECT 
tier,
COUNT(*)Issued
FROM coupon_offer_report
WHERE issueddate BETWEEN '2025-09-01' AND '2025-09-30'
-- and issuedstore <> 'demo'
AND issuedstore NOT IN('demo','Corporate','Whatsapp','DummyStore')
GROUP BY 1),

tier_redeemed AS (
SELECT 
a.tier,
COUNT(couponcode)CouponsRedeemed,
COUNT(DISTINCT issuedmobile)Coupon_Redeemers, 
 SUM(discount)discount,
 SUM(b.amount)RedemptionSale 
FROM coupon_offer_report a JOIN txn_Report_accrual_Redemption b 
ON a.billno=b.modifiedbillno 
WHERE useddate BETWEEN '2025-09-01' AND '2025-09-30' 
AND couponstatus = 'Used' 
-- AND redeemedstorecode <> 'demo'
AND redeemedstorecode NOT IN('demo','Corporate','Whatsapp','DummyStore') 
GROUP BY 1)

SELECT a.tier AS 'Tier name',
Issued AS 'Coupon issued',
CouponsRedeemed AS 'COUPON REDEEMED',
IFNULL(CouponsRedeemed/Issued,0) AS 'REDEMPTION RATE',
Coupon_Redeemers AS 'REDEEMERS',
RedemptionSale AS 'REDEMPTION SALES',
discount AS Discount,
discount/RedemptionSale AS '% DISCOUNT'
FROM tier_issued a LEFT JOIN tier_redeemed b USING (tier);

-- ___________________________________TIER WISE SPEND OVERVIEW__________________________________

SELECT 
tiername,
COUNT(DISTINCT mobile) AS Transactor,
SUM(amount) AS Sales,
COUNT(DISTINCT UniqueBillNo) AS bills,
SUM(amount)/COUNT(DISTINCT mobile)AMV,
SUM(amount)/COUNT(DISTINCT UniqueBillNo) ATV,
COUNT(DISTINCT UniqueBillNo) / COUNT(DISTINCT mobile) AS visit
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2025-09-01' AND '2025-09-30'
AND storecode NOT IN('demo','Corporate','Whatsapp','DummyStore')
GROUP BY tiername;

-- _____________________________________ATV BAND WISE DISTRIBUTION OF CUSTOMER, SALES AND BILLS IN THE CURRENT MONTH​

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
WHERE txndate BETWEEN '2025-09-01' AND '2025-09-30'
AND storecode NOT IN('demo','Corporate','Whatsapp','DummyStore')
AND BillNo NOT LIKE '%test%' 
AND BillNo NOT LIKE '%roll%'
-- AND amount > 0
GROUP BY 1)a 
GROUP BY 1
ORDER BY atv;


-- DAY WISE ANALYSIS – FOR CURRENT MONTH

SELECT days,COUNT(DISTINCT mobile)customer_count,
SUM(sales)sales,SUM(bills)bills,SUM(sales)/SUM(bills)ATV,SUM(sales)/COUNT(DISTINCT mobile)AMV 
FROM (
SELECT mobile,DAYNAME(txndate)days,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills,
SUM(amount)/COUNT(DISTINCT uniquebillno)ATV 
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2025-09-01' AND '2025-09-30'
AND storecode NOT IN('demo','Corporate','Whatsapp','DummyStore') 
AND BillNo NOT LIKE '%test%' 
AND BillNo NOT LIKE '%roll%'
-- AND amount > 0
GROUP BY 1
ORDER BY txndate)a
GROUP BY 1;


-- STORE WISE PERFORMANCE, OCT’25, Part 1​

SELECT storecode,lpaasstore,
COUNT(DISTINCT mobile)customer_count,
SUM(sales)sales,SUM(bills)bills,SUM(sales)/SUM(bills)ATV,SUM(sales)/COUNT(DISTINCT mobile)AMV 
FROM (
SELECT mobile,storecode,lpaasstore,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills,
SUM(amount)/COUNT(DISTINCT uniquebillno)ATV 
FROM txn_report_accrual_redemption a LEFT JOIN store_master b USING(storecode)
WHERE txndate BETWEEN '2025-09-01' AND '2025-09-30'
AND storecode NOT IN('demo','Corporate','Whatsapp','DummyStore') 
AND BillNo NOT LIKE '%test%' 
AND BillNo NOT LIKE '%roll%'
-- AND amount > 0
GROUP BY 1)a
GROUP BY 1;

-- STORE WISE PERFORMANCE, OCT’25, Part 12

WITH txn_data AS (
SELECT storecode,lpaasstore,COUNT(DISTINCT mobile)Total_customer,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN mobile END)Repeat_customer,
SUM(amount)sales,
SUM(CASE WHEN frequencycount>1 THEN Amount END)Repeat_sales,
COUNT(DISTINCT uniquebillno)bills,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN uniquebillno END)Repeat_Bills,
SUM(amount)/COUNT(DISTINCT uniquebillno)ATV 
FROM txn_report_accrual_redemption a LEFT JOIN store_master b USING(storecode)
WHERE txndate BETWEEN '2025-09-01' AND '2025-09-30'
AND storecode NOT IN('demo','Corporate','Whatsapp','DummyStore') 
AND BillNo NOT LIKE '%test%' 
AND BillNo NOT LIKE '%roll%'
-- AND amount > 0
GROUP BY 1),

redeemd AS (
SELECT b.storecode,
COUNT(couponcode)CouponsRedeemed,
-- COUNT(DISTINCT issuedmobile)Coupon_Redeemers, 
-- SUM(discount)discount,
SUM(b.amount)RedemptionSale 
FROM coupon_offer_report a 
JOIN txn_Report_accrual_Redemption b 
ON a.billno=b.modifiedbillno 
JOIN store_master c ON b.storecode=c.storecode
WHERE useddate BETWEEN '2025-09-01' AND '2025-09-30'
AND couponstatus = 'Used' 
AND redeemedstorecode NOT IN('demo','Corporate','Whatsapp','DummyStore') 
GROUP BY 1)

SELECT a.storecode,lpaasstore,Total_customer,
Repeat_customer,Repeat_customer/Total_customer AS 'Repeat customer %',
sales,Repeat_sales,Repeat_sales/sales AS 'Repeat sales %',
bills,Repeat_bills,Repeat_bills/bills AS 'Repeat bills %',
CouponsRedeemed,RedemptionSale,RedemptionSale/sales AS 'Redemption sales %'
FROM txn_data a JOIN redeemd b USING(storecode);



-- life cycle segment


INSERT INTO dummy.shd_lifecycle_base_harish
SELECT  DISTINCT mobile FROM (
SELECT mobile FROM member_report WHERE modifiedenrolledon <='2025-09-30' 
AND enrolledstorecode NOT IN('demo','Corporate','Whatsapp','DummyStore')
UNION
SELECT  DISTINCT mobile
FROM txn_report_accrual_redemption 
WHERE storecode NOT IN('demo','Corporate','Whatsapp','DummyStore')
AND BillNo NOT LIKE '%test%' 
AND txndate <='2025-09-30'
AND BillNo NOT LIKE '%roll%')a;#330691
      
           
 ALTER TABLE dummy.shd_lifecycle_base_harish ADD INDEX mobile(mobile),ADD COLUMN recency VARCHAR(200),ADD COLUMN visit VARCHAR(100);

-- LIFECYCLE BASED SEGMENTATION
 
UPDATE dummy.shd_lifecycle_base_harish a JOIN(
SELECT mobile,
DATEDIFF('2025-09-30',MAX(txndate))recency,
COUNT(DISTINCT txndate)visit  
FROM txn_report_accrual_redemption 
WHERE storecode NOT IN('demo','Corporate','Whatsapp','DummyStore')
AND BillNo NOT LIKE '%test%' 
AND BillNo NOT LIKE '%roll%'
GROUP BY 1)b USING(mobile)
SET a.recency=b.recency,a.visit=b.visit;  #152812

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
 
 SELECT * FROM dummy.shd_lifecycle_base_harish
 
ALTER TABLE dummy.shd_lifecycle_base_harish ADD COLUMN Customer_Segment VARCHAR(20);
 
UPDATE 
dummy.shd_lifecycle_base_harish
SET Customer_Segment=
CASE 
WHEN Recency <= 30 THEN  'New'
-- vintage <=90 AND  
WHEN recency <= 90 AND  visit <= 2 THEN 'Grow'
WHEN Recency <= 90 AND visit >= 3 THEN 'Stable'
WHEN Recency > 90 AND Recency<= 180 THEN 'Declining'
WHEN  Recency > 180 AND Recency<= 210 THEN 'Recently Lapsed'
WHEN  Recency > 210 AND Recency<= 240 THEN 'Lapsed'
WHEN  Recency > 240 THEN 'Long Lapsed' END ;#152812
 
 
 UPDATE 
dummy.shd_lifecycle_base_harish
SET Customer_Segment='ent'
WHERE customer_segment IS NULL;#177879

 SELECT Customer_Segment,COUNT(DISTINCT mobile)customer FROM dummy.shd_lifecycle_base_harish
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
dummy.shd_lifecycle_base_harish ADD COLUMN Customer_Type VARCHAR(200);#14000481

SELECT * FROM dummy.shd_lifecycle_base_harish

UPDATE dummy.shd_lifecycle_base_harish
SET Customer_Type =
-- ='Lapsed' WHERE  Customer_Segment='Long Lapsed';
CASE 
    WHEN Customer_Segment IN ('New', 'Grow', 'Stable') THEN 'Active'
    WHEN Customer_Segment IN ('Declining') THEN 'Dormant'
    WHEN Customer_Segment IN ('Recently Lapsed', 'Lapsed','Long Lapsed') THEN 'Lapsed'
    WHEN Customer_Segment = 'ent' THEN 'Enrolled and not transcated'
END;1#1278143
 
 
SELECT Customer_Type,Customer_Segment,COUNT(mobile) FROM 
dummy.shd_lifecycle_base_harish  
-- where EnrolledStore not  LIKE '%demo%'
GROUP BY 1,2
ORDER BY 1,2;
 
