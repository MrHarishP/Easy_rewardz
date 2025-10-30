-- SET @CurrentmonthStartdate = DATE_SUB(DATE_FORMAT(CURDATE(), '%Y-%m-01'), INTERVAL 1 MONTH);
-- set @Currentmonthenddate= last_day(Date_sub(curdate(), interval 1 month));
-- SET @lastmonth_startdate= DATE_SUB(DATE_FORMAT(CURDATE(), '%Y-%m-01'), INTERVAL 2 MONTH);
-- SET @lastmonth_enddate= LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 2 MONTH));
-- SET @lastyear_startdate= DATE_SUB(DATE_FORMAT(CURDATE(), '%Y-%m-01'), INTERVAL 13 month);
-- SET @lastyear_enddate= LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 13 month));
-- SELECT @CurrentmonthStartdate,@Currentmonthenddate,@lastmonth_startdate,@lastmonth_enddate,@lastyear_startdate,@lastyear_enddate;

-- this is for test and this and uncomment below codes  
SET @cur_date='2025-11-30';
SET @CurrentmonthStartdate = DATE_SUB(DATE_FORMAT(@cur_date, '%Y-%m-01'), INTERVAL 1 MONTH);
SET @Currentmonthenddate= LAST_DAY(DATE_SUB(@cur_date, INTERVAL 1 MONTH));
SET @lastmonth_startdate= DATE_SUB(DATE_FORMAT(@cur_date, '%Y-%m-01'), INTERVAL 2 MONTH);
SET @lastmonth_enddate= LAST_DAY(DATE_SUB(@cur_date, INTERVAL 2 MONTH));
SET @lastyear_startdate= DATE_SUB(DATE_FORMAT(@cur_date, '%Y-%m-01'), INTERVAL 13 MONTH);
SET @lastyear_enddate= LAST_DAY(DATE_SUB(@cur_date, INTERVAL 13 MONTH));
SELECT @CurrentmonthStartdate,@Currentmonthenddate,@lastmonth_startdate,@lastmonth_enddate,@lastyear_startdate,@lastyear_enddate;


-- txndata
WITH base_25_loy AS  (
SELECT DISTINCT storecode FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN @lastmonth_startdate AND @Currentmonthenddate
AND storecode NOT IN('demo','Corporate','Whatsapp','DummyStore') 
AND BillNo NOT LIKE '%test%' 
AND BillNo NOT LIKE '%roll%'
-- AND amount > 0 
),

base_24_loy AS (
SELECT DISTINCT storecode FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN @lastyear_startdate AND @lastyear_enddate
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
CASE WHEN txndate BETWEEN @lastyear_startdate AND @lastyear_enddate  
THEN CONCAT(LEFT(MONTHNAME(txndate),3),RIGHT(YEAR(txndate),2))
WHEN txndate BETWEEN @lastmonth_startdate AND @lastmonth_enddate
THEN CONCAT(LEFT(MONTHNAME(txndate),3),RIGHT(YEAR(txndate),2))
WHEN txndate BETWEEN @CurrentmonthStartdate AND @Currentmonthenddate 
THEN CONCAT(LEFT(MONTHNAME(txndate),3),RIGHT(YEAR(txndate),2))
END PERIOD,
SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills,
MIN(frequencycount)minf,MAX(frequencycount)maxf 
FROM txn_report_accrual_redemption 
WHERE ((txndate BETWEEN @lastyear_startdate AND @lastyear_enddate)
OR (txndate BETWEEN @lastmonth_startdate AND @lastmonth_enddate)
OR (txndate BETWEEN @CurrentmonthStartdate AND @Currentmonthenddate))
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
WHERE modifiedenrolledon BETWEEN @lastmonth_startdate AND @Currentmonthenddate
AND EnrolledStorecode NOT IN('demo','Corporate','Whatsapp','DummyStore') 
 AND EnrolledStorecode NOT  LIKE '%test%'),

base_24_enr AS (
SELECT DISTINCT enrolledstorecode FROM member_report 
WHERE modifiedenrolledon BETWEEN @lastyear_startdate AND @lastyear_enddate
AND EnrolledStorecode NOT IN('demo','Corporate','Whatsapp','DummyStore') 
 AND EnrolledStorecode NOT  LIKE '%test%'),

enrolled_ltl_store AS (
SELECT DISTINCT enrolledstorecode FROM base_24_enr a JOIN base_25_enr b USING(enrolledstorecode))
,
enrollment AS (
SELECT 
CASE WHEN modifiedenrolledon BETWEEN @lastyear_startdate AND @lastyear_enddate 
THEN CONCAT(LEFT(MONTHNAME(modifiedenrolledon),3),RIGHT(YEAR(modifiedenrolledon),2))
WHEN modifiedenrolledon BETWEEN @lastmonth_startdate AND @lastmonth_enddate
THEN CONCAT(LEFT(MONTHNAME(modifiedenrolledon),3),RIGHT(YEAR(modifiedenrolledon),2))
WHEN modifiedenrolledon BETWEEN @CurrentmonthStartdate AND @Currentmonthenddate  
THEN CONCAT(LEFT(MONTHNAME(modifiedenrolledon),3),RIGHT(YEAR(modifiedenrolledon),2))
END PERIOD,
COUNT(DISTINCT mobile)Enrollment FROM member_report
WHERE 
((modifiedenrolledon BETWEEN @lastyear_startdate AND @lastyear_enddate)
OR (modifiedenrolledon BETWEEN @lastmonth_startdate AND @lastmonth_enddate)
OR (modifiedenrolledon BETWEEN @CurrentmonthStartdate AND @Currentmonthenddate))
AND EnrolledStorecode NOT IN('demo','Corporate','Whatsapp','DummyStore') 
AND EnrolledStorecode NOT  LIKE '%test%'
AND enrolledstorecode IN (SELECT DISTINCT enrolledstorecode FROM enrolled_ltl_store)
GROUP BY 1
),

-- nonloyalty data 
 base_24_nonloyalty AS (
SELECT DISTINCT ModifiedStoreCode FROM sku_report_nonloyalty 
WHERE modifiedtxndate BETWEEN @lastyear_startdate AND @lastyear_enddate
AND ModifiedStoreCode NOT IN('demo','Corporate','Whatsapp','DummyStore') 
-- AND itemnetamount>0
),
base_25_nonloyalty AS (
SELECT DISTINCT ModifiedStoreCode FROM sku_report_nonloyalty 
WHERE modifiedtxndate BETWEEN @lastmonth_startdate AND @Currentmonthenddate
AND ModifiedStoreCode NOT IN('demo','Corporate','Whatsapp','DummyStore') 
-- AND itemnetamount>0
),
non_loyalty_ltl_store AS (
SELECT DISTINCT ModifiedStoreCode FROM base_24_nonloyalty a JOIN base_25_nonloyalty b USING(ModifiedStoreCode)
),

non_loyalty_data AS ( 
SELECT 
CASE WHEN modifiedtxndate BETWEEN @lastyear_startdate AND @lastyear_enddate 
THEN CONCAT(LEFT(MONTHNAME(modifiedtxndate),3),RIGHT(YEAR(modifiedtxndate),2))
WHEN modifiedtxndate BETWEEN @lastmonth_startdate AND @lastmonth_enddate
THEN CONCAT(LEFT(MONTHNAME(modifiedtxndate),3),RIGHT(YEAR(modifiedtxndate),2))
WHEN modifiedtxndate BETWEEN @CurrentmonthStartdate AND @Currentmonthenddate 
THEN CONCAT(LEFT(MONTHNAME(modifiedtxndate),3),RIGHT(YEAR(modifiedtxndate),2))
END PERIOD,
SUM(itemnetamount)NONloyalty_sales,COUNT(DISTINCT uniquebillno)nonloyalty_bills 
FROM sku_report_nonloyalty 
WHERE 
((modifiedtxndate BETWEEN @lastyear_startdate AND @lastyear_enddate)
OR(modifiedtxndate BETWEEN @lastmonth_startdate AND @lastmonth_enddate)
OR (modifiedtxndate BETWEEN @CurrentmonthStartdate AND @Currentmonthenddate))
-- AND itemnetamount>0 
AND ModifiedStoreCode IN (SELECT DISTINCT ModifiedStoreCode FROM non_loyalty_ltl_store)
GROUP BY 1
)
-- ,
-- -- coupon data issued
--  base_24_coupon AS (
-- SELECT DISTINCT issuedstore FROM coupon_offer_report 
-- WHERE issueddate BETWEEN @lastyear_startdate and @lastyear_enddate
-- AND issuedstore NOT IN ('demo','Corporate','Whatsapp','DummyStore')
-- AND amount>0),
-- base_25_coupon AS (
-- SELECT DISTINCT issuedstore FROM coupon_offer_report 
-- WHERE issueddate BETWEEN @lastmonth_startdate AND @Currentmonthenddate
-- AND amount>0
-- and issuedstore not in ('demo','Corporate','Whatsapp','DummyStore')),
-- Coupon_ltl_store AS (
-- SELECT DISTINCT issuedstore FROM base_24_coupon a JOIN base_25_coupon b USING(issuedstore)
-- )
-- ,
-- 
-- issued_coupon as (
-- SELECT 
-- CASE WHEN issueddate BETWEEN @lastyear_startdate and @lastyear_enddate 
-- THEN CONCAT(LEFT(MONTHNAME(issueddate),3),RIGHT(YEAR(issueddate),2))
-- WHEN issueddate BETWEEN @lastmonth_startdate and @lastmonth_enddate
-- THEN CONCAT(LEFT(MONTHNAME(issueddate),3),RIGHT(YEAR(issueddate),2))
-- WHEN issueddate BETWEEN @CurrentmonthStartdate and @Currentmonthenddate 
-- THEN CONCAT(LEFT(MONTHNAME(issueddate),3),RIGHT(YEAR(issueddate),2))
-- END PERIOD,COUNT(*)Issued
-- FROM coupon_offer_report
-- WHERE ((issueddate BETWEEN @lastyear_startdate and @lastyear_enddate)
-- OR(issueddate BETWEEN @lastmonth_startdate and @lastmonth_enddate)
-- OR (issueddate BETWEEN @CurrentmonthStartdate and @Currentmonthenddate))
-- AND issuedstore NOT IN ('demo','Corporate','Whatsapp','DummyStore')
-- and issuedstore in (select distinct issuedstore from Coupon_ltl_store)
-- group by 1
-- )
-- ,
-- 
-- -- coupon data redemed 
--  base_24_coupon_redeemed AS (
-- SELECT DISTINCT redeemedstore FROM coupon_offer_report 
-- WHERE useddate BETWEEN @lastyear_startdate and @lastyear_enddate 
-- AND redeemedstore NOT IN ('demo','Corporate','Whatsapp','DummyStore')
-- and couponstatus='used'
-- AND amount>0),
-- base_25_coupon_redeemed AS (
-- SELECT DISTINCT redeemedstore FROM coupon_offer_report 
-- WHERE useddate BETWEEN @lastmonth_startdate AND @Currentmonthenddate
-- AND amount>0
-- and couponstatus='used'
-- AND redeemedstore NOT IN ('demo','Corporate','Whatsapp','DummyStore')),
-- Coupon_ltl_store_redeemed AS (
-- SELECT DISTINCT redeemedstore FROM base_24_coupon_redeemed a JOIN base_25_coupon_redeemed b USING(redeemedstore)
-- )
-- ,
-- 
-- redeemed_coupon AS (
-- SELECT CASE WHEN useddate BETWEEN @lastyear_startdate and @lastyear_enddate 
-- THEN CONCAT(LEFT(MONTHNAME(useddate),3),RIGHT(YEAR(useddate),2))
-- WHEN useddate BETWEEN @lastmonth_startdate and @lastmonth_enddate
-- THEN CONCAT(LEFT(MONTHNAME(useddate),3),RIGHT(YEAR(useddate),2))
-- WHEN useddate BETWEEN @CurrentmonthStartdate and @Currentmonthenddate 
-- THEN CONCAT(LEFT(MONTHNAME(useddate),3),RIGHT(YEAR(useddate),2))
-- END PERIOD,
-- COUNT(couponcode)CouponsRedeemed
-- FROM coupon_offer_report
-- WHERE ((useddate BETWEEN @lastyear_startdate and @lastyear_enddate)
-- OR(useddate BETWEEN @lastmonth_startdate  @lastmonth_enddate)
-- OR (useddate BETWEEN @CurrentmonthStartdate and @Currentmonthenddate))
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



-- txndata
WITH base_25_loy AS  (
SELECT DISTINCT storecode FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN @lastmonth_startdate AND @Currentmonthenddate
AND storecode NOT IN('demo','Corporate','Whatsapp','DummyStore') 
AND BillNo NOT LIKE '%test%' 
AND BillNo NOT LIKE '%roll%'
-- AND amount > 0 
),

base_24_loy AS (
SELECT DISTINCT storecode FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN @lastyear_startdate AND @lastyear_enddate
AND storecode NOT IN('demo','Corporate','Whatsapp','DummyStore') 
AND BillNo NOT LIKE '%test%' 
AND BillNo NOT LIKE '%roll%'
-- AND amount > 0 
),
LTL_store_loy AS (
SELECT DISTINCT storecode FROM base_24_loy a JOIN base_25_loy b USING(storecode)#7
)
SELECT SUM(amount)sales FROM  txn_report_accrual_redemption 
WHERE txndate BETWEEN '2025-09-01' AND '2025-9-30'
AND storecode NOT IN('demo','Corporate','Whatsapp','DummyStore') 
AND BillNo NOT LIKE '%test%' 
AND BillNo NOT LIKE '%roll%'
-- AND amount > 0
AND storecode IN (SELECT DISTINCT storecode FROM LTL_store_loy)
;


-- nonloyalty data 
 WITH base_24_nonloyalty AS (
SELECT DISTINCT ModifiedStoreCode FROM sku_report_nonloyalty 
WHERE modifiedtxndate BETWEEN @lastyear_startdate AND @lastyear_enddate
AND ModifiedStoreCode NOT IN('demo','Corporate','Whatsapp','DummyStore') 
-- AND itemnetamount>0
),
base_25_nonloyalty AS (
SELECT DISTINCT ModifiedStoreCode FROM sku_report_nonloyalty 
WHERE modifiedtxndate BETWEEN @lastmonth_startdate AND @Currentmonthenddate
AND ModifiedStoreCode NOT IN('demo','Corporate','Whatsapp','DummyStore') 
-- AND itemnetamount>0
),
non_loyalty_ltl_store AS (
SELECT DISTINCT ModifiedStoreCode FROM base_24_nonloyalty a JOIN base_25_nonloyalty b USING(ModifiedStoreCode)
)
SELECT SUM(itemnetamount)NONloyalty_sales,COUNT(DISTINCT uniquebillno)nonloyalty_bills 
FROM sku_report_nonloyalty 
WHERE modifiedtxndate BETWEEN '2025-09-01' AND '2025-9-30'
-- AND itemnetamount>0 
AND ModifiedStoreCode IN (SELECT DISTINCT ModifiedStoreCode FROM non_loyalty_ltl_store)
;



