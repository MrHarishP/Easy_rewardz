SET @CurrentmonthStartdate = DATE_SUB(DATE_FORMAT(CURDATE(), '%Y-%m-01'), INTERVAL 1 MONTH);
SET @Currentmonthenddate= LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH));
SET @lastmonth_startdate= DATE_SUB(DATE_FORMAT(CURDATE(), '%Y-%m-01'), INTERVAL 2 MONTH);
SET @lastmonth_enddate= LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 2 MONTH));
SET @lastyear_startdate= DATE_SUB(DATE_FORMAT(CURDATE(), '%Y-%m-01'), INTERVAL 13 MONTH);
SET @lastyear_enddate= LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 13 MONTH));
SELECT @CurrentmonthStartdate,@Currentmonthenddate,@lastmonth_startdate,@lastmonth_enddate,@lastyear_startdate,@lastyear_enddate;
-- 
-- -- this is for test and this and uncomment below codes  
-- SET @cur_date= '2025-11-19';
-- SET @CurrentmonthStartdate = DATE_SUB(DATE_FORMAT(@cur_date, '%Y-%m-01'), INTERVAL 1 MONTH);
-- SET @Currentmonthenddate= LAST_DAY(DATE_SUB(@cur_date, INTERVAL 1 MONTH));
-- SET @lastmonth_startdate= DATE_SUB(DATE_FORMAT(@cur_date, '%Y-%m-01'), INTERVAL 2 MONTH);
-- SET @lastmonth_enddate= LAST_DAY(DATE_SUB(@cur_date, INTERVAL 2 MONTH));
-- 
-- SELECT @CurrentmonthStartdate,@Currentmonthenddate,@lastmonth_startdate,@lastmonth_enddate;

-- Reward analysis

-- issued 
WITH isused AS (
SELECT CASE WHEN issueddate BETWEEN @lastmonth_startdate AND @lastmonth_enddate  
THEN CONCAT(LEFT(MONTHNAME(issueddate),3),'-',RIGHT(YEAR(issueddate),2)) 
WHEN issueddate BETWEEN @CurrentmonthStartdate AND @Currentmonthenddate 
THEN CONCAT(LEFT(MONTHNAME(issueddate),3),'-',RIGHT(YEAR(issueddate),2)) END PERIOD,
COUNT(*)Issued
FROM coupon_offer_report
WHERE ((issueddate BETWEEN @lastmonth_startdate AND @lastmonth_enddate)
OR (issueddate BETWEEN @CurrentmonthStartdate AND @Currentmonthenddate))
AND issuedstore NOT IN('demo','Corporate','Whatsapp','DummyStore') 
GROUP BY 1),

redeemed AS (
SELECT 
CASE WHEN useddate BETWEEN @lastmonth_startdate AND @lastmonth_enddate 
THEN CONCAT(LEFT(MONTHNAME(useddate),3),'-',RIGHT(YEAR(useddate),2)) 
WHEN useddate BETWEEN @CurrentmonthStartdate AND @Currentmonthenddate 
THEN CONCAT(LEFT(MONTHNAME(useddate),3),'-',RIGHT(YEAR(useddate),2)) END PERIOD,
COUNT(couponcode)CouponsRedeemed,
COUNT(DISTINCT issuedmobile)Coupon_Redeemers, 
SUM(discount)discount,
SUM(b.amount)RedemptionSale 
FROM coupon_offer_report a 
JOIN txn_Report_accrual_Redemption b 
ON a.billno=b.modifiedbillno 
WHERE ((useddate BETWEEN @lastmonth_startdate AND @lastmonth_enddate)
OR(useddate BETWEEN @CurrentmonthStartdate AND @Currentmonthenddate))
AND couponstatus = 'Used' 
AND redeemedstorecode NOT IN('demo','Corporate','Whatsapp','DummyStore') 
GROUP BY 1),

txndata AS (
SELECT 
CASE WHEN txndate BETWEEN @lastmonth_startdate AND @lastmonth_enddate 
THEN CONCAT(LEFT(MONTHNAME(txndate),3),'-',RIGHT(YEAR(txndate),2)) 
WHEN txndate BETWEEN @CurrentmonthStartdate AND @Currentmonthenddate 
THEN CONCAT(LEFT(MONTHNAME(txndate),3),'-',RIGHT(YEAR(txndate),2)) END PERIOD,
COUNT(DISTINCT mobile)Total_customers,SUM(amount)Loyalty_sales FROM txn_Report_accrual_Redemption
WHERE ((txndate BETWEEN @lastmonth_startdate AND @lastmonth_enddate)
OR (txndate BETWEEN @CurrentmonthStartdate AND @Currentmonthenddate ))
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
discount AS 'Value of coupons redeemed',
RedemptionSale AS 'Coupon Redemption Sales',
Loyalty_sales AS 'Total Loyalty Sales',
RedemptionSale/Loyalty_sales AS 'Coupon Redemption Sale as % of Loyalty Sales'
FROM isused a JOIN redeemed b ON a.period=b.period
JOIN txndata c ON a.period=c.period;
