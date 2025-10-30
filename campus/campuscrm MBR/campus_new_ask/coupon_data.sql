SELECT COUNT(*)Issued
FROM coupon_offer_report
WHERE issueddate BETWEEN '2025-04-01' AND '2025-06-30'
AND issuedstore<>'demo'
;



SELECT 
CASE WHEN issuedstore='ecom' THEN "online" ELSE "offline" END AS storetype,
COUNT(*)Issued
FROM coupon_offer_report 
WHERE issueddate BETWEEN '2025-04-01' AND '2025-06-30'
AND issuedstore<>'demo'
GROUP BY 1;





SELECT 
CASE WHEN redeemedstorecode='ecom' THEN "online" ELSE "offline" END AS storetype,
COUNT(couponcode)CouponsRedeemed,
COUNT(DISTINCT issuedmobile)Coupon_Redeemers, 
 SUM(discount)discount,
 SUM(b.amount)RedemptionSale 
FROM coupon_offer_report a JOIN txn_Report_accrual_Redemption b ON a.billno=b.modifiedbillno 
WHERE useddate BETWEEN '2024-04-01' AND '2024-06-30' 
AND couponstatus = 'Used' 
AND redeemedstorecode<>'demo' 
GROUP BY 1; 




SELECT 
useddate,
COUNT(couponcode)CouponsRedeemed,
COUNT(DISTINCT issuedmobile)Coupon_Redeemers, 
 SUM(discount)discount,
 SUM(b.amount)RedemptionSale 
FROM coupon_offer_report a JOIN txn_Report_accrual_Redemption b ON a.billno=b.modifiedbillno 
WHERE useddate BETWEEN '2025-01-01' AND '2025-06-30' 
AND  couponoffercode IN('CAMPBDAY300','CAMPBDAY500')
AND couponstatus = 'Used' 
AND redeemedstorecode<>'demo' ;


SELECT DISTINCT couponoffercode FROM
`campuscrm`. coupon_offer_report 
WHERE useddate BETWEEN '2025-01-01' AND '2025-06-30'
AND issueddate IN('HBD400OFF2000');









SELECT COUNT(DISTINCT mobile),SUM(amount)sales 
FROM txn_report_accrual_redemption WHERE txndate BETWEEN 
'2025-04-01' AND '2025-06-30'
AND storecode NOT LIKE '%demo%'
AND storecode NOT LIKE '%test%'
AND storecode NOT LIKE '%Corporate%'
AND amount>0;


SELECT 
CASE WHEN storecode='ecom' THEN "online" ELSE "offline" END AS storetype,
COUNT(DISTINCT mobile),SUM(amount)sales 
FROM txn_report_accrual_redemption WHERE txndate BETWEEN 
'2025-04-01' AND '2025-06-30'
AND storecode NOT LIKE '%demo%'
AND storecode NOT LIKE '%test%'
AND storecode NOT LIKE '%Corporate%'
AND amount>0
GROUP BY 1;




SELECT DISTINCT couponoffercode FROM `campuscrm`.coupon_offer_report;







-- ____bday_coupon__

SELECT 
YEAR(issueddate),
MONTHNAME(issueddate),
COUNT(*)Issued
FROM coupon_offer_report
WHERE issueddate BETWEEN '2025-01-01' AND '2025-06-30'
AND  couponoffercode  IN('HBD400OFF2000')
AND issuedstore<>'demo'
GROUP BY 1,2;



SELECT DISTINCT couponoffercode FROM coupon_offer_report
WHERE issueddate BETWEEN '2024-01-01' AND '2024-06-30'
AND couponoffercode LIKE '%bd%';

SELECT 
YEAR(useddate),
MONTHNAME(useddate),
COUNT(couponcode)CouponsRedeemed,
COUNT(DISTINCT issuedmobile)Coupon_Redeemers, 
 SUM(discount)discount,
 SUM(b.amount)RedemptionSale 
FROM coupon_offer_report a JOIN txn_Report_accrual_Redemption b ON a.billno=b.modifiedbillno 
WHERE useddate BETWEEN '2025-01-01' AND '2025-06-30' 
AND  couponoffercode IN('HBD400OFF2000')
AND couponstatus = 'Used' 
AND redeemedstorecode<>'demo'
GROUP BY 1,2 ;



SELECT 
YEAR(issueddate),
MONTHNAME(issueddate),
COUNT(*)Issued
FROM coupon_offer_report
WHERE issueddate BETWEEN '2025-01-01' AND '2025-06-30'
AND  couponoffercode  IN('HBD400OFF2000')
AND issuedstore<>'demo'
GROUP BY 1,2;







