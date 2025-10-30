SELECT MONTHNAME(issueddate),COUNT(*)Issued
FROM coupon_offer_report
WHERE issueddate BETWEEN '2025-08-01' AND '2025-09-30'
AND issuedstore NOT IN ('demo','corporate')
GROUP BY 1;




SELECT 
 CASE WHEN issuedstore='Ecom' THEN "online" ELSE "offline" END AS storetype,
MONTHNAME(issueddate), COUNT(*)Issued
FROM coupon_offer_report 
WHERE issueddate BETWEEN '2025-08-01' AND '2025-09-30'
AND issuedstore NOT IN ('demo','corporate')
GROUP BY 1
,2
;

-- select 
-- MONTHNAME(issueddate), COUNT(*)Issued
-- FROM coupon_offer_report 
-- WHERE issueddate BETWEEN '2025-09-01' AND '2025-09-30'
-- AND issuedstore NOT IN ('demo','corporate')
-- and issuedstore= 'ecom'
-- GROUP BY 1



SELECT 
CASE WHEN redeemedstorecode='ecom' THEN "online" ELSE "offline" END AS storetype,
MONTHNAME(useddate),
COUNT(couponcode)CouponsRedeemed,
COUNT(DISTINCT issuedmobile)Coupon_Redeemers, 
 SUM(discount)discount,
 SUM(b.amount)RedemptionSale 
FROM coupon_offer_report a JOIN txn_Report_accrual_Redemption b ON a.billno=b.modifiedbillno 
WHERE useddate BETWEEN '2025-08-01' AND '2025-09-30' AND couponstatus = 'Used' 
AND redeemedstorecode NOT IN ('demo','corporate') 
GROUP BY 1,2; 



SELECT 
-- CASE WHEN redeemedstorecode='ecom' THEN "online" ELSE "offline" END AS storetype,
MONTHNAME(useddate),
COUNT(couponcode)CouponsRedeemed,
COUNT(DISTINCT issuedmobile)Coupon_Redeemers, 
 SUM(discount)discount,
 SUM(b.amount)RedemptionSale 
FROM coupon_offer_report a JOIN txn_Report_accrual_Redemption b ON a.billno=b.modifiedbillno 
WHERE useddate BETWEEN '2025-08-01' AND '2025-09-30' AND couponstatus = 'Used' 
AND redeemedstorecode NOT IN ('demo','corporate') 
GROUP BY 1
-- ,2
; 
