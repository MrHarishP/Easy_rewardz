SELECT DISTINCT CouponOfferCode 
FROM (
    SELECT DISTINCT CouponOfferCode
    FROM coupon_offer_report
    WHERE UsedDate BETWEEN '2025-06-01' AND '2025-06-30' AND redeemedstore NOT IN ('demo','corporate')
    
    UNION 
    
    SELECT DISTINCT CouponOfferCode
    FROM coupon_offer_report
    WHERE IssuedDate BETWEEN '2025-06-01' AND '2025-06-30' AND issuedstore NOT IN ('demo','corporate')
) AS A;

SELECT CouponOfferCode,COUNT(*)Issued
FROM coupon_offer_report
WHERE issueddate BETWEEN '2025-06-01' AND '2025-06-30'
AND issuedstore NOT IN ('demo','corporate')
GROUP BY 1;


-- QC
SELECT CouponOfferCode,COUNT(*)Issued
FROM coupon_offer_report
WHERE issueddate BETWEEN '2025-06-01' AND '2025-06-30'
AND issuedstore NOT IN ('demo','corporate')
AND CouponOfferCode='FDTHR15160526'
GROUP BY 1;
 
 
SELECT 
CouponOfferCode,
COUNT(couponcode)CouponsRedeemed,
COUNT(DISTINCT issuedmobile)Coupon_Redeemers, 
 SUM(discount)discount,
 SUM(b.amount)RedemptionSale 
FROM coupon_offer_report a JOIN txn_Report_accrual_Redemption b ON a.billno=b.modifiedbillno 
WHERE useddate BETWEEN '2025-08-01' AND '2025-08-31' AND couponstatus = 'Used' 
AND redeemedstorecode NOT IN ('demo','corporate') 
GROUP BY 1; 




-- QC
SELECT 
CouponOfferCode,
COUNT(couponcode)CouponsRedeemed,
COUNT(DISTINCT issuedmobile)Coupon_Redeemers, 
 SUM(discount)discount,
 SUM(b.amount)RedemptionSale 
FROM coupon_offer_report a JOIN txn_Report_accrual_Redemption b ON a.billno=b.modifiedbillno 
WHERE useddate BETWEEN '2025-06-01' AND '2025-06-30' AND couponstatus = 'Used' 
AND redeemedstorecode NOT IN ('demo','corporate') 
AND CouponOfferCode ='FDTHR25080426'
GROUP BY 1; 


-- use thise 
SELECT CouponOfferCode, narration
FROM (
    SELECT CouponOfferCode, narration
    FROM `campuscrm`.coupon_offer_report
    WHERE UsedDate BETWEEN '2025-09-01' AND '2025-09-30' 
        AND redeemedstore NOT IN ('demo','corporate') GROUP BY 1
    
    UNION
    
    SELECT CouponOfferCode, narration
    FROM `campuscrm`.coupon_offer_report
    WHERE IssuedDate BETWEEN '2025-09-01' AND '2025-09-30' 
        AND issuedstore NOT IN ('demo','corporate') GROUP BY 1
) AS combined_data
GROUP BY CouponOfferCode, narration;

SELECT CouponOfferCode,COUNT(*)Issued
FROM `campuscrm`.coupon_offer_report
WHERE issueddate BETWEEN  '2025-09-01' AND '2025-09-30'
AND issuedstore NOT IN ('demo','corporate')
GROUP BY 1;


SELECT CouponOfferCode,
COUNT(couponcode)CouponsRedeemed,
COUNT(DISTINCT issuedmobile)Coupon_Redeemers, 
 SUM(discount)discount,
 SUM(b.amount)RedemptionSale 
FROM `campuscrm`.coupon_offer_report a 
JOIN `campuscrm`.txn_Report_accrual_Redemption b ON a.billno=b.modifiedbillno 
WHERE useddate BETWEEN '2025-09-01' AND '2025-09-30' 
AND couponstatus = 'Used' 
AND redeemedstorecode NOT IN ('demo','corporate') 
GROUP BY 1;
