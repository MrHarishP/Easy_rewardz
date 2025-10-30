SELECT 
MONTHNAME(useddate)mom,
COUNT(couponcode)CouponsRedeemed,
COUNT(DISTINCT issuedmobile)Coupon_Redeemers, 
 SUM(discount)discount,
 SUM(b.amount)RedemptionSale 
FROM coupon_offer_report a JOIN txn_Report_accrual_Redemption b ON a.billno=b.modifiedbillno 
WHERE useddate BETWEEN '2025-07-01' AND '2025-07-23' AND couponstatus = 'Used' 
AND redeemedstorecode NOT IN ('demo','corporate') 
GROUP BY 1; 


SELECT 
MONTHNAME(useddate)mom,
COUNT(couponcode)CouponsRedeemed,
COUNT(DISTINCT issuedmobile)Coupon_Redeemers, 
 SUM(discount)discount,
 SUM(b.itemnetamount)RedemptionSale 
FROM coupon_offer_report a  JOIN sku_report_loyalty b ON a.billno=b.modifiedbillno 
WHERE useddate BETWEEN '2025-04-01' AND '2025-07-23' AND couponstatus = 'Used' 
AND redeemedstorecode NOT IN ('demo','corporate') 
GROUP BY 1; 


SELECT 
MONTHNAME(useddate)mom,
couponcode CouponsRedeemed,a.narration,
COUNT(DISTINCT issuedmobile)Coupon_Redeemers, 
 SUM(discount)discount,
 SUM(b.amount)RedemptionSale 
FROM coupon_offer_report a  JOIN txn_Report_accrual_Redemption b ON a.billno=b.modifiedbillno 
WHERE useddate BETWEEN '2025-07-01' AND '2025-07-23' AND couponstatus = 'Used' 
AND redeemedstorecode NOT IN ('demo','corporate') 
GROUP BY 1,2; 



SELECT 
MONTHNAME(useddate)mom,
COUNT(couponcode)CouponsRedeemed,
COUNT(DISTINCT issuedmobile)Coupon_Redeemers, 
 SUM(discount)discount,
 SUM(b.amount)RedemptionSale 
FROM coupon_offer_report a JOIN txn_Report_accrual_Redemption b ON a.billno=b.modifiedbillno AND issuedmobile=mobile
WHERE useddate BETWEEN '2025-07-01' AND '2025-07-23' AND couponstatus = 'Used' 
AND redeemedstorecode NOT IN ('demo','corporate') 
GROUP BY 1; 



SELECT COUNT(couponcode)CouponsRedeemed,SUM(discount)
FROM coupon_offer_report a  
-- JOIN txn_Report_accrual_Redemption b ON a.billno=b.modifiedbillno 
WHERE useddate BETWEEN '2025-07-01' AND '2025-07-23' AND couponstatus = 'Used' 
AND redeemedstorecode NOT IN ('demo','corporate') 

SELECT *  FROM coupon_offer_report