
 #################################################################################
--   coupon data store wise coco foco online and overall 

-- slide 15

WITH issued AS (
SELECT 
'Overall_CY_Month_COCO' AS 'Rewards',
COUNT(couponoffercode)`Total Coupons Issued`
FROM coupon_offer_report a LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.issuedstore=c.storecode 
WHERE issueddate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE '%coco%' AND couponstatus='issued'
UNION 
SELECT 
'Overall_CY_Month_FOFO' AS 'Rewards',
COUNT(couponoffercode)`Total Coupons Issued`
FROM coupon_offer_report a LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.issuedstore=c.storecode 
WHERE issueddate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE '%fofo%' AND couponstatus='issued'
UNION
SELECT 
'Overall_CY_Month_Online' AS 'Rewards',
COUNT(couponoffercode)`Total Coupons Issued`
FROM coupon_offer_report a 
LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.issuedstore=c.storecode 
WHERE issueddate BETWEEN '2025-04-01' AND '2025-04-30' AND issuedstore ='ecom' AND couponstatus='issued'
UNION 
SELECT 
'Overall_CY_Month_Overall' AS 'Rewards',
COUNT(couponoffercode)`Total Coupons Issued`
FROM coupon_offer_report a LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.issuedstore=c.storecode 
WHERE issueddate BETWEEN '2025-04-01' AND '2025-04-30' AND couponstatus='issued'
UNION 
SELECT 
'Overall_CY_YTM_COCO' AS 'Rewards',
COUNT(couponoffercode)`Total Coupons Issued`
FROM coupon_offer_report a LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.issuedstore=c.storecode 
WHERE issueddate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE '%cOcO%' AND couponstatus='issued'
UNION
SELECT 
'Overall_CY_YTM_FOFO' AS 'Rewards',
COUNT(couponoffercode)`Total Coupons Issued`
FROM coupon_offer_report a LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.issuedstore=c.storecode 
WHERE issueddate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE '%fOfO%' AND couponstatus='issued'
UNION
SELECT 
'Overall_CY_YTM_Online' AS 'Rewards',
COUNT(couponoffercode)`Total Coupons Issued`
FROM coupon_offer_report a 
-- left join dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.issuedstore=c.storecode 
WHERE issueddate BETWEEN '2025-04-01' AND '2025-04-30' AND issuedstore='ecom' AND couponstatus='issued'
UNION
SELECT 
'Overall_CY_YTM_Overall' AS 'Rewards',
COUNT(couponoffercode)`Total Coupons Issued`
FROM coupon_offer_report a 
LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.issuedstore=c.storecode 
WHERE issueddate BETWEEN '2025-04-01' AND '2025-04-30' AND couponstatus='issued'
UNION
SELECT 
'MVC_CY_Month_COCO' AS 'Rewards',
COUNT(couponoffercode)`Total Coupons Issued`
FROM coupon_offer_report a LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.issuedstore=c.storecode 
LEFT JOIN member_report c ON a.issuedmobile=c.mobile
WHERE issueddate BETWEEN '2025-04-01' AND '2025-04-30' AND c.tier ='MVC' AND storetype LIKE '%coco%' AND couponstatus='issued'
UNION
SELECT 
'MVC_CY_Month_FOFO' AS 'Rewards',
COUNT(couponoffercode)`Total Coupons Issued`
FROM coupon_offer_report a LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.issuedstore=c.storecode 
LEFT JOIN member_report c ON a.issuedmobile=c.mobile
WHERE issueddate BETWEEN '2025-04-01' AND '2025-04-30' AND c.tier ='MVC' AND storetype LIKE '%fofo%' AND couponstatus='issued'
UNION
SELECT 
'MVC_CY_Month_Online' AS 'Rewards',
COUNT(couponoffercode)`Total Coupons Issued`
FROM coupon_offer_report a 
LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.issuedstore=c.storecode 
LEFT JOIN member_report c ON a.issuedmobile=c.mobile
WHERE issueddate BETWEEN '2025-04-01' AND '2025-04-30' AND c.tier ='MVC' AND issuedstore = 'ecom' AND couponstatus='issued'
UNION
SELECT 
'MVC_CY_Month_Overall' AS 'Rewards',
COUNT(couponoffercode)`Total Coupons Issued`
FROM coupon_offer_report a LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.issuedstore=c.storecode 
LEFT JOIN member_report c ON a.issuedmobile=c.mobile
WHERE issueddate BETWEEN '2025-04-01' AND '2025-04-30' AND c.tier ='MVC'  AND couponstatus='issued'

UNION
SELECT 
'MVC_CY_YTM_COCO' AS 'Rewards',
COUNT(couponoffercode)`Total Coupons Issued`
FROM coupon_offer_report a LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.issuedstore=c.storecode 
LEFT JOIN member_report c ON a.issuedmobile=c.mobile
WHERE issueddate BETWEEN '2025-04-01' AND '2025-04-30' AND c.tier ='MVC' AND storetype LIKE '%coco%' AND couponstatus='issued'
UNION 
SELECT 
'MVC_CY_YTM_FOFO' AS 'Rewards',
COUNT(couponoffercode)`Total Coupons Issued`
FROM coupon_offer_report a LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.issuedstore=c.storecode 
LEFT JOIN member_report c ON a.issuedmobile=c.mobile
WHERE issueddate BETWEEN '2025-04-01' AND '2025-04-30' AND c.tier ='MVC' AND storetype LIKE '%fofo%' AND couponstatus='issued'
UNION 
SELECT 
'MVC_CY_YTM_Online' AS 'Rewards',
COUNT(couponoffercode)`Total Coupons Issued`
FROM coupon_offer_report a 
LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.issuedstore=c.storecode 
LEFT JOIN member_report c ON a.issuedmobile=c.mobile
WHERE issueddate BETWEEN '2025-04-01' AND '2025-04-30' AND c.tier ='MVC' AND issuedstore = 'ecom' AND couponstatus='issued'
UNION
SELECT 
'MVC_CY_YTM_Overall' AS 'Rewards',
COUNT(couponoffercode)`Total Coupons Issued`
FROM coupon_offer_report a LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.issuedstore=c.storecode 
LEFT JOIN member_report c ON a.issuedmobile=c.mobile
WHERE issueddate BETWEEN '2025-04-01' AND '2025-04-30' AND c.tier ='MVC' AND couponstatus='issued'
 
),
CY_cytm AS (
  SELECT 
      CASE 
         WHEN useddate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'Overall_CY_Month_COCO' END AS Rewards,
      COUNT(CASE WHEN couponstatus = 'used' THEN couponcode END) AS `Total Coupons Redeemed`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN redeemedmobile END) AS `Coupon Redeemers`,
      IFNULL(SUM(CASE WHEN couponstatus = 'used' THEN amount ELSE 0 END),0) AS `Coupon Redemption Sales`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN billno END) AS `Coupon Redemption Bills`,
      IFNULL(SUM(discount),0)`Value of coupon Redeemed`
    FROM coupon_offer_report a LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.redeemedstorecode=c.storecode
    WHERE useddate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE '%coco%'
    AND a.redeemedmobile IN (SELECT mobile FROM dummy.CY_txn_data)
    GROUP BY 1
    UNION
SELECT 
      CASE 
         WHEN useddate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'Overall_CY_Month_FOFO' END AS Rewards,
      COUNT(CASE WHEN couponstatus = 'used' THEN couponcode END) AS `Total Coupons Redeemed`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN redeemedmobile END) AS `Coupon Redeemers`,
      IFNULL(SUM(CASE WHEN couponstatus = 'used' THEN amount ELSE 0 END),0) AS `Coupon Redemption Sales`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN billno END) AS `Coupon Redemption Bills`,
      IFNULL(SUM(discount),0)`Value of coupon Redeemed`
FROM coupon_offer_report a LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.redeemedstorecode=c.storecode
WHERE useddate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE '%fofo%'
AND a.redeemedmobile IN (SELECT mobile FROM dummy.CY_txn_data)
GROUP BY 1

UNION
     SELECT 'Overall_CY_Month_Online' AS Rewards,
      COUNT(CASE WHEN couponstatus = 'used' THEN couponcode END) AS `Total Coupons Redeemed`,
      
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN redeemedmobile END) AS `Coupon Redeemers`,
      IFNULL(SUM(CASE WHEN couponstatus = 'used' THEN amount ELSE 0 END),0) AS `Coupon Redemption Sales`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN billno END) AS `Coupon Redemption Bills`,
      IFNULL(SUM(discount),0)`Value of coupon Redeemed`
    FROM coupon_offer_report a 
    LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.redeemedstorecode=c.storecode
    WHERE useddate BETWEEN '2025-04-01' AND '2025-04-30' AND redeemedstorecode = 'ecom'
    AND a.redeemedmobile IN (SELECT mobile FROM dummy.CY_txn_data)
    UNION
SELECT 
      CASE 
         WHEN useddate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'Overall_CY_Month_Overall' END AS Rewards,
      COUNT(CASE WHEN couponstatus = 'used' THEN couponcode END) AS `Total Coupons Redeemed`,     
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN redeemedmobile END) AS `Coupon Redeemers`,
      IFNULL(SUM(CASE WHEN couponstatus = 'used' THEN amount ELSE 0 END),0) AS `Coupon Redemption Sales`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN billno END) AS `Coupon Redemption Bills`,
      IFNULL(SUM(discount),0)`Value of coupon Redeemed`
    FROM coupon_offer_report a LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.redeemedstorecode=c.storecode
    WHERE useddate BETWEEN '2025-04-01' AND '2025-04-30'
    AND a.redeemedmobile IN (SELECT mobile FROM dummy.CY_txn_data)
    GROUP BY 1
    UNION 
SELECT 
      CASE 
         WHEN useddate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'Overall_CY_YTM_COCO' END AS Rewards,
      COUNT(CASE WHEN couponstatus = 'used' THEN couponcode END) AS `Total Coupons Redeemed`,
      
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN redeemedmobile END) AS `Coupon Redeemers`,
      IFNULL(SUM(CASE WHEN couponstatus = 'used' THEN amount ELSE 0 END),0) AS `Coupon Redemption Sales`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN billno END) AS `Coupon Redemption Bills`,
      IFNULL(SUM(discount),0)`Value of coupon Redeemed`
    FROM coupon_offer_report a LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.redeemedstorecode=c.storecode
    WHERE useddate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE '%coco%'
    AND a.redeemedmobile IN (SELECT mobile FROM dummy.CY_txn_data)
    GROUP BY 1
    UNION
      SELECT 
      CASE 
         WHEN useddate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'Overall_CY_YTM_FOFO' END AS Rewards,
      COUNT(CASE WHEN couponstatus = 'used' THEN couponcode END) AS `Total Coupons Redeemed`,
      
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN redeemedmobile END) AS `Coupon Redeemers`,
      IFNULL(SUM(CASE WHEN couponstatus = 'used' THEN amount ELSE 0 END),0) AS `Coupon Redemption Sales`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN billno END) AS `Coupon Redemption Bills`,
      IFNULL(SUM(discount),0)`Value of coupon Redeemed`
    FROM coupon_offer_report a LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.redeemedstorecode=c.storecode
    WHERE useddate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE '%fofo%'
    AND a.redeemedmobile IN (SELECT mobile FROM dummy.CY_txn_data)
    GROUP BY 1
    UNION
     SELECT 'Overall_CY_YTM_Online' AS Rewards,
      COUNT(CASE WHEN couponstatus = 'used' THEN couponcode END) AS `Total Coupons Redeemed`,
      
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN redeemedmobile END) AS `Coupon Redeemers`,
      IFNULL(SUM(CASE WHEN couponstatus = 'used' THEN amount ELSE 0 END),0) AS `Coupon Redemption Sales`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN billno END) AS `Coupon Redemption Bills`,
      IFNULL(SUM(discount),0)`Value of coupon Redeemed`
    FROM coupon_offer_report a 
    LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.redeemedstorecode=c.storecode
    WHERE useddate BETWEEN '2025-04-01' AND '2025-04-30' AND redeemedstorecode = 'ecom'
    AND a.redeemedmobile IN (SELECT mobile FROM dummy.CY_txn_data)
   
    UNION
      SELECT 
      CASE 
         WHEN useddate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'Overall_CY_YTM_Overall' END AS Rewards,
      COUNT(CASE WHEN couponstatus = 'used' THEN couponcode END) AS `Total Coupons Redeemed`,
      
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN redeemedmobile END) AS `Coupon Redeemers`,
      IFNULL(SUM(CASE WHEN couponstatus = 'used' THEN amount ELSE 0 END),0) AS `Coupon Redemption Sales`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN billno END) AS `Coupon Redemption Bills`,
      IFNULL(SUM(discount),0)`Value of coupon Redeemed`
    FROM coupon_offer_report a LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.redeemedstorecode=c.storecode
    WHERE useddate BETWEEN '2025-04-01' AND '2025-04-30'
    AND a.redeemedmobile IN (SELECT mobile FROM dummy.CY_txn_data)
    GROUP BY 1
    UNION 
    
--     mcv tier wise data 

     SELECT 
      CASE 
         WHEN useddate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'MVC_CY_Month_COCO' END AS Rewards,
      COUNT(CASE WHEN couponstatus = 'used' THEN couponcode END) AS `Total Coupons Redeemed`,
      
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN redeemedmobile END) AS `Coupon Redeemers`,
      IFNULL(SUM(CASE WHEN couponstatus = 'used' THEN amount ELSE 0 END),0) AS `Coupon Redemption Sales`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN billno END) AS `Coupon Redemption Bills`,
      IFNULL(SUM(discount),0)`Value of coupon Redeemed`
    FROM coupon_offer_report a LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.redeemedstorecode=c.storecode
      LEFT JOIN member_report d ON a.redeemedmobile=d.mobile
    WHERE useddate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE '%coco%' AND d.tier = 'MVC'
    AND a.redeemedmobile IN (SELECT mobile FROM dummy.CY_txn_data)
    GROUP BY 1
    UNION
      SELECT 
      CASE 
         WHEN useddate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'MVC_CY_Month_FOFO' END AS Rewards,
      COUNT(CASE WHEN couponstatus = 'used' THEN couponcode END) AS `Total Coupons Redeemed`,
      
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN redeemedmobile END) AS `Coupon Redeemers`,
      IFNULL(SUM(CASE WHEN couponstatus = 'used' THEN amount ELSE 0 END),0) AS `Coupon Redemption Sales`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN billno END) AS `Coupon Redemption Bills`,
      IFNULL(SUM(discount),0)`Value of coupon Redeemed`
    FROM coupon_offer_report a LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.redeemedstorecode=c.storecode
      LEFT JOIN member_report d ON a.redeemedmobile=d.mobile
    WHERE useddate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE '%fofo%' AND d.tier = 'MVC'
    AND a.redeemedmobile IN (SELECT mobile FROM dummy.CY_txn_data)
    GROUP BY 1
    UNION
     SELECT 'MVC_CY_Month_Online' AS Rewards,
      COUNT(CASE WHEN couponstatus = 'used' THEN couponcode END) AS `Total Coupons Redeemed`,
      
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN redeemedmobile END) AS `Coupon Redeemers`,
      IFNULL(SUM(CASE WHEN couponstatus = 'used' THEN amount ELSE '0' END),0) AS `Coupon Redemption Sales`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN billno END) AS `Coupon Redemption Bills`,
      IFNULL(SUM(discount),0)`Value of coupon Redeemed`
    FROM coupon_offer_report a 
    LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.redeemedstorecode=c.storecode
      LEFT JOIN member_report d ON a.redeemedmobile=d.mobile
    WHERE useddate BETWEEN '2025-04-01' AND '2025-04-30' AND redeemedstorecode = 'ecom' AND d.tier = 'MVC'
    AND a.redeemedmobile IN (SELECT mobile FROM dummy.CY_txn_data)
    UNION
      SELECT 
      CASE 
         WHEN useddate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'MVC_CY_Month_Overall' END AS Rewards,
      COUNT(CASE WHEN couponstatus = 'used' THEN couponcode END) AS `Total Coupons Redeemed`,
      
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN redeemedmobile END) AS `Coupon Redeemers`,
      IFNULL(SUM(CASE WHEN couponstatus = 'used' THEN amount ELSE 0 END),0) AS `Coupon Redemption Sales`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN billno END) AS `Coupon Redemption Bills`,
      IFNULL(SUM(discount),0)`Value of coupon Redeemed`
    FROM coupon_offer_report a LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.redeemedstorecode=c.storecode
      LEFT JOIN member_report d ON a.redeemedmobile=d.mobile
    WHERE useddate BETWEEN '2025-04-01' AND '2025-04-30' AND d.tier = 'MVC'
    AND a.redeemedmobile IN (SELECT mobile FROM dummy.CY_txn_data)
    GROUP BY 1
    UNION 
     SELECT 
      CASE 
         WHEN useddate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'MVC_CY_YTM_COCO' END AS Rewards,
      COUNT(CASE WHEN couponstatus = 'used' THEN couponcode END) AS `Total Coupons Redeemed`,
      
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN redeemedmobile END) AS `Coupon Redeemers`,
      IFNULL(SUM(CASE WHEN couponstatus = 'used' THEN amount ELSE 0 END),0) AS `Coupon Redemption Sales`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN billno END) AS `Coupon Redemption Bills`,
      IFNULL(SUM(discount),0)`Value of coupon Redeemed`
    FROM coupon_offer_report a LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.redeemedstorecode=c.storecode
      LEFT JOIN member_report d ON a.redeemedmobile=d.mobile
    WHERE useddate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE '%coco%' AND d.tier = 'MVC'
    AND a.redeemedmobile IN (SELECT mobile FROM dummy.CY_txn_data)
    GROUP BY 1
    UNION
      SELECT 
      CASE 
         WHEN useddate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'MVC_CY_YTM_FOFO' END AS Rewards,
      COUNT(CASE WHEN couponstatus = 'used' THEN couponcode END) AS `Total Coupons Redeemed`,
      
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN redeemedmobile END) AS `Coupon Redeemers`,
      IFNULL(SUM(CASE WHEN couponstatus = 'used' THEN amount ELSE 0 END),0) AS `Coupon Redemption Sales`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN billno END) AS `Coupon Redemption Bills`,
      IFNULL(SUM(discount),0)`Value of coupon Redeemed`
    FROM coupon_offer_report a LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.redeemedstorecode=c.storecode
      LEFT JOIN member_report d ON a.redeemedmobile=d.mobile
    WHERE useddate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE '%fofo%' AND d.tier = 'MVC'
    AND a.redeemedmobile IN (SELECT mobile FROM dummy.CY_txn_data)
    GROUP BY 1
    UNION
     SELECT 'MVC_CY_YTM_Online' AS Rewards,
      COUNT(CASE WHEN couponstatus = 'used' THEN couponcode END) AS `Total Coupons Redeemed`,
      
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN redeemedmobile END) AS `Coupon Redeemers`,
      IFNULL(SUM(CASE WHEN couponstatus = 'used' THEN amount ELSE 0 END),0) AS `Coupon Redemption Sales`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN billno END) AS `Coupon Redemption Bills`,
      IFNULL(SUM(discount),0)`Value of coupon Redeemed`
    FROM coupon_offer_report a 
    LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.redeemedstorecode=c.storecode
      LEFT JOIN member_report d ON a.redeemedmobile=d.mobile
    WHERE useddate BETWEEN '2025-04-01' AND '2025-04-30' AND redeemedstorecode = 'ecom' AND d.tier ='MVC'
    AND a.redeemedmobile IN (SELECT mobile FROM dummy.CY_txn_data)
    UNION
      SELECT 
      CASE 
         WHEN useddate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'MVC_CY_YTM_Overall' END AS Rewards,
      COUNT(CASE WHEN couponstatus = 'used' THEN couponcode END) AS `Total Coupons Redeemed`,
      
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN redeemedmobile END) AS `Coupon Redeemers`,
      IFNULL(SUM(CASE WHEN couponstatus = 'used' THEN amount ELSE 0 END),0) AS `Coupon Redemption Sales`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN billno END) AS `Coupon Redemption Bills`,
      IFNULL(SUM(discount),0)`Value of coupon Redeemed`
    FROM coupon_offer_report a LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.redeemedstorecode=c.storecode
      LEFT JOIN member_report d ON a.redeemedmobile=d.mobile
    WHERE useddate BETWEEN '2025-04-01' AND '2025-04-30' AND d.tier ='MVC'
    AND a.redeemedmobile IN (SELECT mobile FROM dummy.CY_txn_data)
    GROUP BY 1),
    total_customer AS(
        SELECT 
	CASE 
	WHEN txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'Overall_CY_Month_COCO' END AS Rewards,
	COUNT(DISTINCT mobile) AS `Total Customers` 
FROM dummy.CY_txn_data a
LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master b ON a.storecode=b.storecode
WHERE txndate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE '%CoCo%'

GROUP BY 1
	UNION 
 SELECT 
	CASE 
	WHEN txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'Overall_CY_Month_FOFO' END AS Rewards,
	COUNT(DISTINCT mobile) AS `Total Customers` 
FROM dummy.CY_txn_data a
LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master b ON a.storecode=b.storecode
WHERE txndate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE '%FoFo%'

GROUP BY 1
UNION
SELECT 'Overall_CY_Month_Online' AS Rewards,
COUNT(DISTINCT mobile) AS `Total Customers` 
FROM dummy.CY_txn_data a
LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master b ON a.storecode=b.storecode
WHERE txndate BETWEEN '2025-04-01' AND '2025-04-30' AND a.storecode = 'ecom'

UNION 
SELECT 
	CASE 
	WHEN txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'Overall_CY_Month_Overall' END AS Rewards,
	COUNT(DISTINCT mobile) AS `Total Customers` 
FROM dummy.CY_txn_data a
LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master b ON a.storecode=b.storecode
WHERE txndate BETWEEN '2025-04-01' AND '2025-04-30' 


UNION
    SELECT 
	CASE 
	WHEN txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'Overall_CY_YTM_COCO' END AS Rewards,
	COUNT(DISTINCT mobile) AS `Total Customers` 
FROM dummy.CY_txn_data a
LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master b ON a.storecode=b.storecode
WHERE txndate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE '%CoCo%'

GROUP BY 1
	UNION 
 SELECT 
	CASE 
	WHEN txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'Overall_CY_YTM_FOFO' END AS Rewards,
	COUNT(DISTINCT mobile) AS `Total Customers` 
FROM dummy.CY_txn_data a
LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master b ON a.storecode=b.storecode
WHERE txndate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE '%FoFo%'

GROUP BY 1
UNION
SELECT 'Overall_CY_YTM_Online' AS Rewards,
COUNT(DISTINCT mobile) AS `Total Customers` 
FROM dummy.CY_txn_data a
LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master b ON a.storecode=b.storecode
WHERE txndate BETWEEN '2025-04-01' AND '2025-04-30' AND a.storecode = 'ecom'

UNION 
SELECT 
	CASE 
	WHEN txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'Overall_CY_YTM_Overall' END AS Rewards,
	COUNT(DISTINCT mobile) AS `Total Customers` 
FROM dummy.CY_txn_data a
LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master b ON a.storecode=b.storecode
WHERE txndate BETWEEN '2025-04-01' AND '2025-04-30' 


UNION
#tier wise data 
SELECT CASE WHEN txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'MVC_CY_Month_COCO' END AS Rewards,
COUNT(DISTINCT a.mobile) AS `Total Customers`
FROM dummy.CY_txn_data a
LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master b ON a.storecode=b.storecode
LEFT JOIN member_report d ON a.mobile=d.mobile
WHERE txndate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE '%coco%' AND d.tier = 'MVC'

GROUP BY 1
UNION
SELECT CASE WHEN txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'MVC_CY_Month_FOFO' END AS Rewards,
COUNT(DISTINCT a.mobile) AS `Total Customers`
FROM dummy.CY_txn_data a
LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master b ON a.storecode=b.storecode
LEFT JOIN member_report d ON a.mobile=d.mobile
WHERE txndate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE '%FoFo%' AND d.tier = 'MVC'

GROUP BY 1
UNION
SELECT 'MVC_CY_Month_Online' AS Rewards,
COUNT(DISTINCT a.mobile) AS `Total Customers`
FROM dummy.CY_txn_data a
LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master b ON a.storecode=b.storecode
LEFT JOIN member_report d ON a.mobile=d.mobile
WHERE txndate BETWEEN '2025-04-01' AND '2025-04-30' AND a.storecode = 'ecom' AND d.tier = 'MVC'

UNION

SELECT CASE WHEN txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'MVC_CY_Month_Overall' END AS Rewards,
COUNT(DISTINCT a.mobile) AS `Total Customers`
FROM dummy.CY_txn_data a
LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master b ON a.storecode=b.storecode
LEFT JOIN member_report d ON a.mobile=d.mobile
WHERE txndate BETWEEN '2025-04-01' AND '2025-04-30'  AND d.tier = 'MVC'


UNION

SELECT CASE WHEN txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'MVC_CY_Month_COCO' END AS Rewards,
COUNT(DISTINCT a.mobile) AS `Total Customers`
FROM dummy.CY_txn_data a
LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master b ON a.storecode=b.storecode
LEFT JOIN member_report d ON a.mobile=d.mobile
WHERE txndate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE '%coco%' AND d.tier = 'MVC'

GROUP BY 1
UNION
SELECT CASE WHEN txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'MVC_CY_Month_FOFO' END AS Rewards,
COUNT(DISTINCT a.mobile) AS `Total Customers`
FROM dummy.CY_txn_data a
LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master b ON a.storecode=b.storecode
LEFT JOIN member_report d ON a.mobile=d.mobile
WHERE txndate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE '%FoFo%' AND d.tier = 'MVC'

GROUP BY 1
UNION
SELECT 'MVC_CY_Month_Online' AS Rewards,
COUNT(DISTINCT a.mobile) AS `Total Customers`
FROM dummy.CY_txn_data a
LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master b ON a.storecode=b.storecode
LEFT JOIN member_report d ON a.mobile=d.mobile
WHERE txndate BETWEEN '2025-04-01' AND '2025-04-30' AND a.storecode = 'ecom' AND d.tier = 'MVC'

UNION


SELECT CASE WHEN txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'MVC_CY_YTM_COCO' END AS Rewards,
COUNT(DISTINCT a.mobile) AS `Total Customers`
FROM dummy.CY_txn_data a
LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master b ON a.storecode=b.storecode
LEFT JOIN member_report d ON a.mobile=d.mobile
WHERE txndate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE '%coco%' AND d.tier = 'MVC'

GROUP BY 1
UNION
SELECT CASE WHEN txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'MVC_CY_YTM_FOFO' END AS Rewards,
COUNT(DISTINCT a.mobile) AS `Total Customers`
FROM dummy.CY_txn_data a
LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master b ON a.storecode=b.storecode
LEFT JOIN member_report d ON a.mobile=d.mobile
WHERE txndate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE '%FoFo%' AND d.tier = 'MVC'

GROUP BY 1
UNION
SELECT 'MVC_CY_YTM_Online' AS Rewards,
COUNT(DISTINCT a.mobile) AS `Total Customers`
FROM dummy.CY_txn_data a
LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master b ON a.storecode=b.storecode
LEFT JOIN member_report d ON a.mobile=d.mobile
WHERE txndate BETWEEN '2025-04-01' AND '2025-04-30' AND a.storecode = 'ecom' AND d.tier = 'MVC'

UNION
SELECT CASE WHEN txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'MVC_CY_YTM_Overall' END AS Rewards,
COUNT(DISTINCT a.mobile) AS `Total Customers`
FROM dummy.CY_txn_data a
LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master b ON a.storecode=b.storecode
LEFT JOIN member_report d ON a.mobile=d.mobile
WHERE txndate BETWEEN '2025-04-01' AND '2025-04-30'  AND d.tier = 'MVC'

)
    
    SELECT a.Rewards,`Total Coupons Issued`,`Total Coupons Redeemed`,
    `Total Customers`,
    `Coupon Redeemers`,`Coupon Redemption Sales`,`Coupon Redemption Bills`,
    `Value of coupon Redeemed`
     FROM  issued a LEFT JOIN CY_cytm b ON a.Rewards=b.Rewards
     LEFT JOIN total_customer c ON a.Rewards=c.Rewards
     GROUP BY 1;  
#################################################################################################################################

