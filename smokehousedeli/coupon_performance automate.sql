SET @CurrentmonthStartdate = DATE_SUB(DATE_FORMAT(CURDATE(), '%Y-%m-01'), INTERVAL 1 MONTH);
SET @Currentmonthenddate= LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH));
SELECT @CurrentmonthStartdate,@Currentmonthenddate;

##################
-- COUPON PERFORMANCE

WITH cpupon_code AS (
SELECT DISTINCT CouponOfferCode 
FROM (
    SELECT DISTINCT CouponOfferCode
    FROM coupon_offer_report
    WHERE UsedDate BETWEEN @CurrentmonthStartdate AND @Currentmonthenddate
    
    UNION 
    
    SELECT DISTINCT CouponOfferCode
    FROM coupon_offer_report
    WHERE IssuedDate BETWEEN @CurrentmonthStartdate AND @Currentmonthenddate
) AS A),

issued AS (
SELECT CouponOfferCode,
COUNT(*)Issued
FROM coupon_offer_report a JOIN cpupon_code b USING(CouponOfferCode)
WHERE issueddate BETWEEN @CurrentmonthStartdate AND @Currentmonthenddate
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
WHERE useddate BETWEEN @CurrentmonthStartdate AND @Currentmonthenddate
AND couponstatus = 'Used' 
AND redeemedstorecode NOT IN('demo','Corporate','Whatsapp','DummyStore') 
GROUP BY 1)

SELECT a.CouponOfferCode,
Issued,CouponsRedeemed,CouponsRedeemed/Issued AS 'REDEMPTION RATE (%)​',Coupon_Redeemers,
RedemptionSale,
discount,discount/RedemptionSale AS '% OF DISC.​' 
FROM cpupon_code a LEFT JOIN issued b ON a.CouponOfferCode=b.CouponOfferCode
LEFT JOIN redeemed c ON a.CouponOfferCode=c.CouponOfferCode
ORDER BY issued DESC;
