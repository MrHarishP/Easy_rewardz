-- slide 14
-- coupon data 
WITH issued AS (
SELECT 
CASE WHEN issueddate BETWEEN '2025-04-01' AND '2025-04-30' THEN  'Overall_CY_Month' END 'Rewards',COUNT(couponoffercode)`Total Coupons Issued`
FROM coupon_offer_report 
WHERE issueddate BETWEEN '2025-04-01' AND '2025-04-30' 
AND couponstatus = 'issued'
GROUP BY 1
UNION
SELECT 
CASE WHEN issueddate BETWEEN '2025-04-01' AND '2025-04-30' THEN  'Overall_CY_YTM' END 'Rewards',COUNT(couponoffercode)`Total Coupons Issued`
FROM coupon_offer_report 
WHERE issueddate BETWEEN '2025-04-01' AND '2025-04-30' 
AND couponstatus = 'issued'
GROUP BY 1
UNION
SELECT 
CASE WHEN issueddate BETWEEN '2025-04-01' AND '2025-04-30' THEN  'MVC_CY_Month' END 'Rewards',COUNT(couponoffercode)`Total Coupons Issued`
FROM coupon_offer_report a JOIN member_report b ON a.issuedmobile=b.mobile
WHERE issueddate BETWEEN '2025-04-01' AND '2025-04-30' 
AND couponstatus = 'issued' 
AND b.tier LIKE '%MVC%' 
GROUP BY 1
UNION
SELECT 
CASE WHEN issueddate BETWEEN '2025-04-01' AND '2025-04-30'  THEN  'MVC_CY_YTM' END 'Rewards',COUNT(couponoffercode)`Total Coupons Issued`
FROM coupon_offer_report a JOIN member_report b ON a.issuedmobile=b.mobile
WHERE issueddate BETWEEN '2025-04-01' AND '2025-04-30' 
AND couponstatus = 'issued' AND b.tier LIKE '%MVC%'
GROUP BY 1),
CY_cytm AS (
 SELECT 
      CASE 
         WHEN useddate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'Overall_CY_Month' END AS Rewards,
      COUNT(CASE WHEN couponstatus = 'used' THEN couponoffercode END) AS `Total Coupons Redeemed`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN redeemedmobile END) AS `Coupon Redeemers`,
      SUM(CASE WHEN couponstatus = 'used' THEN amount END) AS `Coupon Redemption Sales`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN billno END) AS `Coupon Redemption Bills`,
      SUM(discount)`Value of coupon Redeemed`
    FROM coupon_offer_report a 
    WHERE useddate BETWEEN '2025-04-01' AND '2025-04-30'
    GROUP BY 1
    UNION
     SELECT 
      CASE 
         WHEN useddate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'Overall_CY_YTM' END AS Rewards,
      COUNT(CASE WHEN couponstatus = 'used' THEN couponoffercode END) AS `Total Coupons Redeemed`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN redeemedmobile END) AS `Coupon Redeemers`,
      SUM(CASE WHEN couponstatus = 'used' THEN amount END) AS `Coupon Redemption Sales`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN billno END) AS `Coupon Redemption Bills`,
      SUM(discount)`Value of coupon Redeemed`
    FROM coupon_offer_report a 
    WHERE useddate BETWEEN '2025-04-01' AND '2025-04-30'
    GROUP BY 1
    UNION
    SELECT 
      CASE 
         WHEN useddate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'MVC_CY_Month' END AS Rewards,
      COUNT(CASE WHEN couponstatus = 'used' THEN couponoffercode END) AS `Total Coupons Redeemed`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN redeemedmobile END) AS `Coupon Redeemers`,
      SUM(CASE WHEN couponstatus = 'used' THEN amount END) AS `Coupon Redemption Sales`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN billno END) AS `Coupon Redemption Bills`,
      SUM(discount)`Value of coupon Redeemed`
    FROM coupon_offer_report a 
    JOIN member_report c ON a.redeemedmobile = c.mobile
    WHERE useddate BETWEEN '2025-04-01' AND '2025-04-30' AND c.tier LIKE 'MVC'
    GROUP BY 1
    UNION
     SELECT 
      CASE 
         WHEN useddate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'MVC_CY_YTM' END AS Rewards,
      COUNT(CASE WHEN couponstatus = 'used' THEN couponoffercode END) AS `Total Coupons Redeemed`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN redeemedmobile END) AS `Coupon Redeemers`,
      SUM(CASE WHEN couponstatus = 'used' THEN amount END) AS `Coupon Redemption Sales`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN billno END) AS `Coupon Redemption Bills`,
      SUM(discount)`Value of coupon Redeemed`
    FROM coupon_offer_report a 
    JOIN member_report c ON a.redeemedmobile=c.mobile
    WHERE useddate BETWEEN '2025-04-01' AND '2025-04-30' AND c.tier LIKE 'MVC'
    GROUP BY 1),
    total_customer AS(
        SELECT 
	CASE 
	WHEN txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'Overall_CY_Month' END AS Rewards,
	COUNT(DISTINCT mobile) AS `Total Customers` 
FROM dummy.CY_txn_data 
WHERE txndate BETWEEN '2025-04-01' AND '2025-04-30' 
GROUP BY 1
	UNION 
	    SELECT 
	CASE 
	WHEN txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'Overall_CY_YTM' END AS Rewards,
	COUNT(DISTINCT mobile) AS `Total Customers` 
FROM dummy.CY_txn_data 
WHERE txndate BETWEEN '2025-04-01' AND '2025-04-30' 
GROUP BY 1
	UNION
 SELECT 
	CASE 
	WHEN txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'MVC_CY_Month' END AS Rewards,
	COUNT(DISTINCT a.mobile) AS `Total Customers` 
FROM dummy.CY_txn_data a
JOIN member_report c ON a.mobile = c.mobile
WHERE txndate BETWEEN '2025-04-01' AND '2025-04-30' AND c.tier LIKE 'MVC'
GROUP BY 1
UNION 
SELECT 
	CASE 
	WHEN txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'MVC_CY_YTM' END AS Rewards,
	COUNT(DISTINCT a.mobile) AS `Total Customers` 
FROM dummy.CY_txn_data a
JOIN member_report c ON a.mobile=c.mobile
    WHERE txndate BETWEEN '2025-04-01' AND '2025-04-30' AND c.tier LIKE 'MVC'
    GROUP BY 1)
    SELECT a.Rewards,`Total Coupons Issued`,`Total Coupons Redeemed`,
    `Total Customers`,
    `Coupon Redeemers`,`Coupon Redemption Sales`,`Coupon Redemption Bills`,
    `Value of coupon Redeemed`
     FROM  issued a JOIN CY_cytm b ON a.Rewards=b.Rewards
     JOIN total_customer c ON a.rewards=c.rewards
     GROUP BY 1;