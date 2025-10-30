-- -- Set the input date as last month (e.g., if today is April 3, it becomes March 3)
-- SET @input_date = DATE_SUB(CURDATE(), INTERVAL 1 MONTH);
-- 
-- -- Get end of the last completed month (i.e., end of input_date's month)
-- SET @enddate_cy_ytm = LAST_DAY(@input_date);
-- 
-- -- Get the same month of last year
-- SET @input_date = DATE_SUB(CURDATE(), INTERVAL 1 MONTH);
-- 
-- -- Set start and end dates for last year's same month
-- SET @startdate_ly_month = DATE_FORMAT(DATE_SUB(@input_date, INTERVAL 1 YEAR), '%Y-%m-01');
-- SET @enddate_ly_month = LAST_DAY(@startdate_ly_month);
-- 
-- -- Output
-- -- SELECT @startdate_ly_month, @enddate_ly_month;
-- 
-- SET @startdate_cy_12M_rolling = DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 12 MONTH), '%Y-%m-01');
-- SET @enddate_cy_12M_rolling = LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH));
-- 
-- select @startdate_cy_12M_rolling ,@enddate_cy_12M_rolling ;
-- 
-- -- Get the April 1st of the CY (based on fiscal year starting in April)
-- SET @startdate_cy_ytm = 
--     CASE 
--         WHEN MONTH(@input_date) >= 4 THEN DATE_FORMAT(@input_date, '%Y-04-01')
--         ELSE DATE_FORMAT(DATE_SUB(@input_date, INTERVAL 1 YEAR), '%Y-04-01')
--     END;
--     
-- -- Last year
-- SET @startdate_ly_ytm= 
--     CASE 
--         WHEN MONTH(@input_date) >= 4 THEN DATE_FORMAT(@input_date, '%Y-%m-01')
--         ELSE DATE_FORMAT(DATE_SUB(@input_date, INTERVAL 2 YEAR), '%Y-%m-01')
--     END;
-- SET @enddate_ly_ytm = LAST_DAY(@input_date);
-- 
-- 
-- 
-- -- 12 month rolling of last year
-- SET @startdate_ly_12M_rolling= 
--     CASE 
--         WHEN MONTH(@input_date) >= 4 THEN DATE_FORMAT(@input_date, '%Y-04-01')
--         ELSE DATE_FORMAT(DATE_SUB(@input_date, INTERVAL 2 YEAR), '%Y-04-01')
--     END;
-- SET @enddate_ly_12M_rolling = CASE 
--         WHEN MONTH(@input_date) >= 4 THEN DATE_FORMAT(@input_date, '%Y-03-31')
--         ELSE DATE_FORMAT(DATE_SUB(@input_date, INTERVAL 1 YEAR), '%Y-03-31')
--     END;
-- 
-- 
-- 
-- -- cy 12 month rolling 
-- -- SET @input_date = DATE_SUB(CURDATE(), INTERVAL 1 MONTH);
-- -- 12 month rolling of last year
-- SET @startdate_cy_12_M_rolling= 
--     CASE 
--         WHEN MONTH(@input_date) >= 4 THEN DATE_FORMAT(@input_date, '%Y-04-01')
--         ELSE DATE_FORMAT(DATE_SUB(@input_date, INTERVAL 1 YEAR), '%Y-04-01')
--     END;
--     
-- SET @enddate_cy_12_M_rolling = CASE 
--         WHEN MONTH(@input_date) >= 4 THEN DATE_FORMAT(@input_date, '%Y-03-31')
--         ELSE DATE_FORMAT(DATE_SUB(@input_date, INTERVAL 0 MONTH), '%Y-03-31')
--     END;
-- -- SELECT @startdate_cy_12_M_rolling,@enddate_cy_12_M_rolling;
--     
-- 
-- 
-- -- set @startdate= curdate() - interval 1 month;
-- SET @startdate_cy = CASE WHEN MONTH(@input_date)>=3 THEN DATE_FORMAT(@input_date,'%Y-03-01')
-- ELSE DATE_FORMAT(DATE_SUB(@input_date,INTERVAL 1 MONTH),'%Y-03-01') END;
-- SET @enddate_cy = LAST_DAY(@startdate_cy);
-- 
-- 
-- 
-- -- Display both values
-- SELECT @startdate_cy_ytm,@enddate_cy_ytm,@startdate_cy,@enddate_cy,
-- @startdate_ly_ytm,@enddate_ly_ytm,@startdate_ly_12M_rolling,@enddate_ly_12M_rolling,
-- @startdate_cy_12_M_rolling,@enddate_cy_12_M_rolling,@startdate_ly_month,@enddate_ly_month;
-- 
-- 
-- 

-- Category Insights for tier wise mvc


-- slide 22 
WITH customer_data AS (
    SELECT txnmappedmobile AS mobile,sub_category
    FROM sku_report_loyalty AS a
    JOIN  dummy.`bb_camp_11_mar_1` b ON a.uniqueitemcode =b.EANCODE JOIN member_report c ON a.txnmappedmobile=c.mobile
    WHERE modifiedtxndate BETWEEN '2024-04-01' AND '2025-04-30'  AND tier LIKE 'MVC' AND sub_category IS NOT NULL
    GROUP BY 1,2 
)
SELECT 
    a.sub_category,
    b.sub_category, 
    COUNT(DISTINCT a.mobile) AS customers
FROM customer_data AS a
JOIN customer_data AS b ON a.mobile=b.mobile
GROUP BY 1,2;
#################################################################################################################################


-- Category Insights for tier wise active 
-- slide 21 
WITH customer_data AS (
    SELECT txnmappedmobile AS mobile,sub_category
    FROM sku_report_loyalty AS a 
    JOIN  dummy.`bb_camp_11_mar_1` b ON a.uniqueitemcode =b.EANCODE JOIN member_report c ON a.txnmappedmobile=c.mobile
    WHERE modifiedtxndate BETWEEN '2024-04-01' AND '2025-04-30'  AND tier LIKE 'active' AND sub_category IS NOT NULL
    GROUP BY 1,2 
)
SELECT 
    a.sub_category,
    b.sub_category, 
    COUNT(DISTINCT a.mobile) AS customers
FROM customer_data AS a
JOIN customer_data AS b ON a.mobile=b.mobile
GROUP BY 1,2;
#################################################################################################################################


-- Category Insights for new  

-- slide 20
WITH customer_data AS (
    SELECT txnmappedmobile AS mobile,sub_category
    FROM sku_report_loyalty AS a 
    JOIN  dummy.`bb_camp_11_mar_1` b ON a.uniqueitemcode =b.EANCODE
    WHERE modifiedtxndate BETWEEN '2024-04-01' AND '2025-04-30'  
    AND frequencycount=1 AND sub_category IS NOT NULL
    GROUP BY 1,2 
)
SELECT 
    a.sub_category,
    b.sub_category, 
    COUNT(DISTINCT a.mobile) AS customers
FROM customer_data AS a
JOIN customer_data AS b ON a.mobile=b.mobile
GROUP BY 1,2;

#################################################################################################################################
-- SELECT * FROM sku_report_loyalty LIMIT 100 240SC1033700186 , 8903016467220



-- 
-- SELECT sub_category,COUNT(DISTINCT txnmappedmobile) 
-- FROM sku_report_loyalty a JOIN dummy.`bb_camp_11_mar_1` b ON a.UniqueItemCode=b.EANCode
-- WHERE modifiedtxndate BETWEEN '2024-03-01' AND '2024-03-31'
-- GROUP BY 1;
-- 
-- 
-- SELECT  * FROM  dummy.Updated_BlackBerrys_Tagging_Store_master;-- (blackberrys store master)
--  
-- SELECT DISTINCT sub_category FROM dummy.`bb_camp_11_mar_1`; --  (blackberrys item master )
-- 
-- 

#################################################################################################################################
-- Category Insights ly,cy,cyltm,12m customer
-- slide 19
SELECT sub_category category,COUNT(DISTINCT CASE WHEN modifiedtxndate BETWEEN '2024-04-01' AND '2024-04-30' THEN txnmappedmobile END)`LY Month`,
COUNT(DISTINCT CASE WHEN modifiedtxndate BETWEEN '2025-04-01' AND '2025-04-30' THEN txnmappedmobile END)`CY Month`,
COUNT(DISTINCT CASE WHEN modifiedtxndate BETWEEN '2024-04-01' AND '2024-04-30' THEN txnmappedmobile END)`LY YTM`,
COUNT(DISTINCT CASE WHEN modifiedtxndate BETWEEN '2025-04-01' AND '2025-04-30' THEN txnmappedmobile END)`CY YTM`,
COUNT(DISTINCT CASE WHEN modifiedtxndate BETWEEN '2023-05-01' AND '2024-04-30' THEN txnmappedmobile END)`12M Rolling LY`,
COUNT(DISTINCT CASE WHEN modifiedtxndate BETWEEN '2024-05-01' AND '2025-04-30' THEN txnmappedmobile END)`12M Rolling CY` 
FROM (
SELECT txnmappedmobile,sub_category,modifiedtxndate 
FROM  sku_report_loyalty a JOIN dummy.`bb_camp_11_mar_1` b  ON a.uniqueitemcode =b.EANCODE
WHERE modifiedtxndate BETWEEN '2023-05-01' AND '2025-04-30'
GROUP BY 1,2,3)a
GROUP BY 1;

#################################################################################################################################


-- select sub_category as category,count(distinct txnmappedmobile)customer 
-- from sku_report_loyalty a join dummy.`bb_camp_11_mar_1` b  ON a.uniqueitemcode =b.EANCODE 
-- where modifiedtxndate between '2024-03-01' and '2024-03-31'
-- group by 1
-- Points-Based Rewards Program Summary (CY Month & CY YTM) store wise coco foco 
-- SELECT  *  FROM  dummy.Updated_BlackBerrys_Tagging_Store_master;

-- slide 18
-- cy 
SELECT
CASE WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE'%coco%' THEN 'Overall_CY_Month_COCO'
WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE '%FoFo%' THEN 'Overall_CY_Month_FOFO'
WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND a.storecode = 'ecom' THEN 'Overall_CY_Month_Online'
WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'Overall_CY_Month_Overall' END 'Rewards',
SUM(a.pointscollected)`Total Transaction Points Issued`,
-- SUM(b.pointscollected)`Total Bonus Points Issued`,
SUM(a.pointsspent)`Total Points Redeemed`,
COUNT(DISTINCT a.mobile)`Total Customers`,
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN a.mobile END )`Point Redeemers`,
SUM(a.pointsspent) AS `Value of Points Redeemed`,
SUM( CASE WHEN a.pointsspent>0 THEN a.amount ELSE 0 END)`Point Redemption Sales`,
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN a.uniquebillno END)`Point Redemption Bills`
FROM txn_report_accrual_redemption a 
-- LEFT JOIN txn_report_flat_accrual b ON a.mobile=b.mobile 
LEFT JOIN  dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.storecode=c.storecode 
WHERE a.txndate BETWEEN '2025-03-01' AND '2025-03-31'
GROUP BY 1
UNION 
-- cy YTM
SELECT
CASE WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE'%coco%' THEN 'Overall_CY_YTM_COCO'
WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE '%FoFo%' THEN 'Overall_CY_YTM_FOFO'
WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND a.storecode = 'ecom' THEN 'Overall_CY_YTM_Online'
WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'Overall_CY_YTM_Overall' END 'Rewards',
SUM(a.pointscollected)`Total Transaction Points Issued`,
-- SUM(b.pointscollected)`Total Bonus Points Issued`,
SUM(a.pointsspent)`Total Points Redeemed`,
COUNT(DISTINCT a.mobile)`Total Customers`,
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN a.mobile END )`Point Redeemers`,
SUM(a.pointsspent) AS `Value of Points Redeemed`,
SUM( CASE WHEN a.pointsspent>0 THEN a.amount ELSE 0 END)`Point Redemption Sales`,
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN a.uniquebillno END)`Point Redemption Bills`
FROM txn_report_accrual_redemption a 
-- LEFT JOIN txn_report_flat_accrual b ON a.mobile=b.mobile 
LEFT JOIN  dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.storecode=c.storecode 
WHERE a.txndate BETWEEN '2025-04-01' AND '2025-04-30'
GROUP BY 1
UNION
-- for mvc cy month 
SELECT
CASE WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE'%coco%' THEN 'MVC_CY_Month_COCO'
WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE '%FoFo%' THEN 'MVC_CY_Month_FOFO'
WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND a.storecode = 'ecom' THEN 'MVC_CY_Month_Online'
WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'MVC_CY_Month_Overall' END 'Rewards',
SUM(a.pointscollected)`Total Transaction Points Issued`,
-- SUM(b.pointscollected)`Total Bonus Points Issued`,
SUM(a.pointsspent)`Total Points Redeemed`,
COUNT(DISTINCT a.mobile)`Total Customers`,
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN a.mobile END )`Point Redeemers`,
SUM(a.pointsspent) AS `Value of Points Redeemed`,
SUM( CASE WHEN a.pointsspent>0 THEN a.amount ELSE 0 END)`Point Redemption Sales`,
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN a.uniquebillno END)`Point Redemption Bills`
FROM txn_report_accrual_redemption a 
-- LEFT JOIN txn_report_flat_accrual b ON a.mobile=b.mobile 
LEFT JOIN  dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.storecode=c.storecode 
LEFT JOIN member_report d ON a.mobile=d.mobile
WHERE a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND d.tier LIKE '%MVC%'
GROUP BY 1
UNION 
-- for mvc cy YTM
SELECT
CASE WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE'%coco%' THEN 'MVC_CY_YTM_COCO'
WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE '%FoFo%' THEN 'MVC_CY_YTM_FOFO'
WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND a.storecode = 'ecom' THEN 'MVC_CY_YTM_Online'
WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'MVC_CY_YTM_Overall' END 'Rewards',
SUM(a.pointscollected)`Total Transaction Points Issued`,
-- SUM(b.pointscollected)`Total Bonus Points Issued`,
SUM(a.pointsspent)`Total Points Redeemed`,
COUNT(DISTINCT a.mobile)`Total Customers`,
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN a.mobile END )`Point Redeemers`,
SUM(a.pointsspent) AS `Value of Points Redeemed`,
SUM( CASE WHEN a.pointsspent>0 THEN a.amount ELSE 0 END)`Point Redemption Sales`,
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN a.uniquebillno END)`Point Redemption Bills`
FROM txn_report_accrual_redemption a 
-- LEFT JOIN txn_report_flat_accrual b ON a.mobile=b.mobile 
LEFT JOIN  dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.storecode=c.storecode 
LEFT JOIN member_report d ON a.mobile=d.mobile
WHERE a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND d.tier LIKE '%MVC%'
GROUP BY 1;


############################################# bonus points
SELECT
CASE WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE'%coco%' THEN 'Overall_CY_Month_COCO'
WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE '%FoFo%' THEN 'Overall_CY_Month_FOFO'
WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND a.storecode = 'ecom' THEN 'Overall_CY_Month_Online'
WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'Overall_CY_Month_Overall' END 'Rewards',

SUM(a.pointscollected)`Total Bonus Points Issued`
FROM txn_report_flat_accrual a 
LEFT JOIN  dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.storecode=c.storecode 
WHERE a.txndate BETWEEN '2025-03-01' AND '2025-03-31'
GROUP BY 1
UNION 
-- cy YTM
SELECT
CASE WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE'%coco%' THEN 'Overall_CY_YTM_COCO'
WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE '%FoFo%' THEN 'Overall_CY_YTM_FOFO'
WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND a.storecode = 'ecom' THEN 'Overall_CY_YTM_Online'
WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'Overall_CY_YTM_Overall' END 'Rewards',

SUM(a.pointscollected)`Total Bonus Points Issued`
FROM txn_report_flat_accrual a 
LEFT JOIN  dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.storecode=c.storecode 
WHERE a.txndate BETWEEN '2025-04-01' AND '2025-04-30'
GROUP BY 1
UNION
-- for mvc cy month 
SELECT
CASE WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE'%coco%' THEN 'MVC_CY_Month_COCO'
WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE '%FoFo%' THEN 'MVC_CY_Month_FOFO'
WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND a.storecode = 'ecom' THEN 'MVC_CY_Month_Online'
WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'MVC_CY_Month_Overall' END 'Rewards',
SUM(pointscollected)`Total Bonus Points Issued`
FROM txn_report_flat_accrual a 
LEFT JOIN  dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.storecode=c.storecode 
LEFT JOIN member_report d ON a.mobile=d.mobile
WHERE a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND d.tier LIKE '%MVC%'
GROUP BY 1
UNION 
-- for mvc cy YTM
SELECT
CASE WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE'%coco%' THEN 'MVC_CY_YTM_COCO'
WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE '%FoFo%' THEN 'MVC_CY_YTM_FOFO'
WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND a.storecode = 'ecom' THEN 'MVC_CY_YTM_Online'
WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'MVC_CY_YTM_Overall' END 'Rewards',
SUM(a.pointscollected)`Total Bonus Points Issued`
FROM txn_report_flat_accrual a 
LEFT JOIN  dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.storecode=c.storecode 
LEFT JOIN member_report d ON a.mobile=d.mobile
WHERE a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND d.tier LIKE '%MVC%'
GROUP BY 1;

##############################################
#################################################################################################################################
-- Points-Based Rewards Program Summary (CY Month & CY YTM)
-- slide 17
SELECT CASE WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'Overall_CY_Month'
WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'Overall_CY_YTM' 
END Rewards,
SUM(a.pointscollected)`Total Transaction Points Issued`,
-- SUM(b.pointscollected)`Total Bonus Points Issued`,
SUM(a.pointsspent)`Total Points Redeemed`,
COUNT(DISTINCT a.mobile)`Total Customers`,
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN a.mobile END )`Point Redeemers`,
SUM(a.pointsspent) AS `Value of Points Redeemed`,
SUM( CASE WHEN a.pointsspent>0 THEN a.amount END)`Point Redemption Sales`,
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN a.uniquebillno END)`Point Redemption Bills`
FROM txn_report_accrual_redemption a 
-- LEFT JOIN txn_report_flat_accrual b USING(mobile)
WHERE  a.txndate BETWEEN '2025-04-01' AND '2025-04-30'
GROUP BY 1
UNION
SELECT CASE WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'MVC_CY_Month'
WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'MVC_CY_YTM' END Rewards,
SUM(a.pointscollected)`Total Transaction Points Issued`,SUM(b.pointscollected)`Total Bonus Points Issued`,
SUM(a.pointsspent)`Total Points Redeemed`,
COUNT(DISTINCT a.mobile)`Total Customers`,
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN a.mobile END )`Point Redeemers`,
SUM(a.pointsspent) AS `Value of Points Redeemed`,
SUM( CASE WHEN a.pointsspent>0 THEN a.amount END)`Point Redemption Sales`,
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN a.uniquebillno END)`Point Redemption Bills`
FROM txn_report_accrual_redemption a 
-- LEFT JOIN txn_report_flat_accrual b ON a.mobile=b.mobile 
LEFT JOIN member_report c ON a.mobile=c.mobile
WHERE tier LIKE '%MVC%' AND  a.txndate BETWEEN '2025-04-01' AND '2025-04-30'
GROUP BY 1;

###################################bonus point
SELECT CASE WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'Overall_CY_Month'
WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'Overall_CY_YTM' 
END Rewards,
SUM(a.pointscollected)`Total Transaction Points Issued`
FROM txn_report_flat_accrual a 
WHERE a.txndate BETWEEN '2025-04-01' AND '2025-04-30'
GROUP BY 1
UNION
SELECT CASE WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'MVC_CY_Month'
WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'MVC_CY_YTM' END Rewards,
SUM(a.pointscollected)`Total Transaction Points Issued`
FROM txn_report_flat_accrual a 
LEFT JOIN member_report c ON a.mobile=c.mobile
WHERE tier LIKE '%MVC%' AND  a.txndate BETWEEN '2025-04-01' AND '2025-04-30'
GROUP BY 1;
#################################################


 #################################################################################
--   coupon data store wise coco foco online and overall 


-- slide 15

WITH issued AS (
SELECT 
'Overall_CY_Month_COCO' AS 'Rewards',
COUNT(couponoffercode)`Total Coupons Issued`
FROM coupon_offer_report a JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.issuedstore=c.storecode 
WHERE issueddate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE '%cOco%'
UNION 
SELECT 
'Overall_CY_Month_FOFO' AS 'Rewards',
COUNT(couponoffercode)`Total Coupons Issued`
FROM coupon_offer_report a JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.issuedstore=c.storecode 
WHERE issueddate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE '%fofo%'
UNION
SELECT 
'Overall_CY_Month_Online' AS 'Rewards',
COUNT(couponoffercode)`Total Coupons Issued`
FROM coupon_offer_report a JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.issuedstore=c.storecode 
WHERE issueddate BETWEEN '2025-04-01' AND '2025-04-30' AND issuedstore ='ecom'
UNION 
SELECT 
'Overall_CY_Month_Overall' AS 'Rewards',
COUNT(couponoffercode)`Total Coupons Issued`
FROM coupon_offer_report a JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.issuedstore=c.storecode 
WHERE issueddate BETWEEN '2025-04-01' AND '2025-04-30'
UNION 
SELECT 
'Overall_CY_YTM_COCO' AS 'Rewards',
COUNT(couponoffercode)`Total Coupons Issued`
FROM coupon_offer_report a JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.issuedstore=c.storecode 
WHERE issueddate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE '%cOcO%'
UNION
SELECT 
'Overall_CY_YTM_FOFO' AS 'Rewards',
COUNT(couponoffercode)`Total Coupons Issued`
FROM coupon_offer_report a JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.issuedstore=c.storecode 
WHERE issueddate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE '%fOfO%'
UNION
SELECT 
'Overall_CY_YTM_Online' AS 'Rewards',
COUNT(couponoffercode)`Total Coupons Issued`
FROM coupon_offer_report a JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.issuedstore=c.storecode 
WHERE issueddate BETWEEN '2025-04-01' AND '2025-04-30' AND storecode='ecom'
UNION
SELECT 
'Overall_CY_YTM_Overall' AS 'Rewards',
COUNT(couponoffercode)`Total Coupons Issued`
FROM coupon_offer_report a JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.issuedstore=c.storecode 
WHERE issueddate BETWEEN '2025-04-01' AND '2025-04-30'
UNION
SELECT 
'MVC_CY_Month_COCO' AS 'Rewards',
COUNT(couponoffercode)`Total Coupons Issued`
FROM coupon_offer_report a JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.issuedstore=c.storecode 
JOIN member_report c ON a.issuedmobile=c.mobile
WHERE issueddate BETWEEN '2025-04-01' AND '2025-04-30' AND c.tier ='MVC' AND storetype LIKE '%coco%'
UNION
SELECT 
'MVC_CY_Month_FOFO' AS 'Rewards',
COUNT(couponoffercode)`Total Coupons Issued`
FROM coupon_offer_report a JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.issuedstore=c.storecode 
JOIN member_report c ON a.issuedmobile=c.mobile
WHERE issueddate BETWEEN '2025-04-01' AND '2025-04-30' AND c.tier ='MVC' AND storetype LIKE '%fofo%'
UNION
SELECT 
'MVC_CY_Month_Online' AS 'Rewards',
COUNT(couponoffercode)`Total Coupons Issued`
FROM coupon_offer_report a JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.issuedstore=c.storecode 
JOIN member_report c ON a.issuedmobile=c.mobile
WHERE issueddate BETWEEN '2025-04-01' AND '2025-04-30' AND c.tier ='MVC' AND storecode = 'ecom'
UNION
SELECT 
'MVC_CY_Month_Overall' AS 'Rewards',
COUNT(couponoffercode)`Total Coupons Issued`
FROM coupon_offer_report a JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.issuedstore=c.storecode 
JOIN member_report c ON a.issuedmobile=c.mobile
WHERE issueddate BETWEEN '2025-04-01' AND '2025-04-30' AND c.tier ='MVC' 

UNION
SELECT 
'MVC_CY_YTM_COCO' AS 'Rewards',
COUNT(couponoffercode)`Total Coupons Issued`
FROM coupon_offer_report a JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.issuedstore=c.storecode 
JOIN member_report c ON a.issuedmobile=c.mobile
WHERE issueddate BETWEEN '2025-04-01' AND '2025-04-30' AND c.tier ='MVC' AND storetype LIKE '%coco%'
UNION 
SELECT 
'MVC_CY_YTM_FOFO' AS 'Rewards',
COUNT(couponoffercode)`Total Coupons Issued`
FROM coupon_offer_report a JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.issuedstore=c.storecode 
JOIN member_report c ON a.issuedmobile=c.mobile
WHERE issueddate BETWEEN '2025-04-01' AND '2025-04-30' AND c.tier ='MVC' AND storetype LIKE '%fofo%'
UNION 
SELECT 
'MVC_CY_YTM_Online' AS 'Rewards',
COUNT(couponoffercode)`Total Coupons Issued`
FROM coupon_offer_report a JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.issuedstore=c.storecode 
JOIN member_report c ON a.issuedmobile=c.mobile
WHERE issueddate BETWEEN '2025-04-01' AND '2025-04-30' AND c.tier ='MVC' AND storecode = 'ecom'
UNION
SELECT 
'MVC_CY_YTM_Overall' AS 'Rewards',
COUNT(couponoffercode)`Total Coupons Issued`
FROM coupon_offer_report a JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.issuedstore=c.storecode 
JOIN member_report c ON a.issuedmobile=c.mobile
WHERE issueddate BETWEEN '2025-04-01' AND '2025-04-30' AND c.tier ='MVC' 
),
CY_cytm AS (
  SELECT 
      CASE 
         WHEN useddate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'Overall_CY_Month_COCO' END AS Rewards,
      COUNT(CASE WHEN couponstatus = 'used' THEN couponoffercode END) AS `Total Coupons Redeemed`,
      COUNT(DISTINCT b.mobile) AS `Total Customers`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN redeemedmobile END) AS `Coupon Redeemers`,
      IFNULL(SUM(CASE WHEN couponstatus = 'used' THEN a.amount ELSE 0 END),0) AS `Coupon Redemption Sales`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN b.billno END) AS `Coupon Redemption Bills`,
      IFNULL(SUM(discount),0)`Value of coupon Redeemed`
    FROM coupon_offer_report a 
      JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.redeemedstorecode=c.storecode
    WHERE useddate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE '%coco%'
    GROUP BY 1
    UNION
      SELECT 
      CASE 
         WHEN useddate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'Overall_CY_Month_FOFO' END AS Rewards,
      COUNT(CASE WHEN couponstatus = 'used' THEN couponoffercode END) AS `Total Coupons Redeemed`,
      COUNT(DISTINCT b.mobile) AS `Total Customers`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN redeemedmobile END) AS `Coupon Redeemers`,
      IFNULL(SUM(CASE WHEN couponstatus = 'used' THEN a.amount ELSE 0 END),0) AS `Coupon Redemption Sales`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN b.billno END) AS `Coupon Redemption Bills`,
      IFNULL(SUM(discount),0)`Value of coupon Redeemed`
    FROM coupon_offer_report a 
    
      JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.redeemedstorecode=c.storecode
    WHERE useddate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE '%fofo%'
    GROUP BY 1
    UNION
     SELECT 'Overall_CY_Month_Online' AS Rewards,
      COUNT(CASE WHEN couponstatus = 'used' THEN couponoffercode END) AS `Total Coupons Redeemed`,
      COUNT(DISTINCT b.mobile) AS `Total Customers`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN redeemedmobile END) AS `Coupon Redeemers`,
      IFNULL(SUM(CASE WHEN couponstatus = 'used' THEN a.amount ELSE 0 END),0) AS `Coupon Redemption Sales`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN b.billno END) AS `Coupon Redemption Bills`,
      IFNULL(SUM(discount),0)`Value of coupon Redeemed`
    FROM coupon_offer_report a 
    
      JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.redeemedstorecode=c.storecode
    WHERE useddate BETWEEN '2025-04-01' AND '2025-04-30' AND redeemedstorecode = 'ecom'
    UNION
      SELECT 
      CASE 
         WHEN useddate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'Overall_CY_Month_Overall' END AS Rewards,
      COUNT(CASE WHEN couponstatus = 'used' THEN couponoffercode END) AS `Total Coupons Redeemed`,
      COUNT(DISTINCT b.mobile) AS `Total Customers`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN redeemedmobile END) AS `Coupon Redeemers`,
      IFNULL(SUM(CASE WHEN couponstatus = 'used' THEN a.amount ELSE 0 END),0) AS `Coupon Redemption Sales`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN b.billno END) AS `Coupon Redemption Bills`,
      IFNULL(SUM(discount),0)`Value of coupon Redeemed`
    FROM coupon_offer_report a 
    
      JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.redeemedstorecode=c.storecode
    WHERE useddate BETWEEN '2025-04-01' AND '2025-04-30'
    GROUP BY 1
    UNION 
     SELECT 
      CASE 
         WHEN useddate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'Overall_CY_YTM_COCO' END AS Rewards,
      COUNT(CASE WHEN couponstatus = 'used' THEN couponoffercode END) AS `Total Coupons Redeemed`,
      COUNT(DISTINCT b.mobile) AS `Total Customers`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN redeemedmobile END) AS `Coupon Redeemers`,
      IFNULL(SUM(CASE WHEN couponstatus = 'used' THEN a.amount ELSE 0 END),0) AS `Coupon Redemption Sales`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN b.billno END) AS `Coupon Redemption Bills`,
      IFNULL(SUM(discount),0)`Value of coupon Redeemed`
    FROM coupon_offer_report a 
    
      JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.redeemedstorecode=c.storecode
    WHERE useddate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE '%coco%'
    GROUP BY 1
    UNION
      SELECT 
      CASE 
         WHEN useddate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'Overall_CY_YTM_FOFO' END AS Rewards,
      COUNT(CASE WHEN couponstatus = 'used' THEN couponoffercode END) AS `Total Coupons Redeemed`,
      COUNT(DISTINCT b.mobile) AS `Total Customers`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN redeemedmobile END) AS `Coupon Redeemers`,
      IFNULL(SUM(CASE WHEN couponstatus = 'used' THEN a.amount ELSE 0 END),0) AS `Coupon Redemption Sales`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN b.billno END) AS `Coupon Redemption Bills`,
      IFNULL(SUM(discount),0)`Value of coupon Redeemed`
    FROM coupon_offer_report a 
    
      JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.redeemedstorecode=c.storecode
    WHERE useddate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE '%fofo%'
    GROUP BY 1
    UNION
     SELECT 'Overall_CY_YTM_Online' AS Rewards,
      COUNT(CASE WHEN couponstatus = 'used' THEN couponoffercode END) AS `Total Coupons Redeemed`,
      COUNT(DISTINCT b.mobile) AS `Total Customers`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN redeemedmobile END) AS `Coupon Redeemers`,
      IFNULL(SUM(CASE WHEN couponstatus = 'used' THEN a.amount ELSE 0 END),0) AS `Coupon Redemption Sales`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN b.billno END) AS `Coupon Redemption Bills`,
      IFNULL(SUM(discount),0)`Value of coupon Redeemed`
    FROM coupon_offer_report a 
    
      JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.redeemedstorecode=c.storecode
    WHERE useddate BETWEEN '2025-04-01' AND '2025-04-30' AND redeemedstorecode = 'ecom'
   
    UNION
      SELECT 
      CASE 
         WHEN useddate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'Overall_CY_YTM_Overall' END AS Rewards,
      COUNT(CASE WHEN couponstatus = 'used' THEN couponoffercode END) AS `Total Coupons Redeemed`,
      COUNT(DISTINCT b.mobile) AS `Total Customers`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN redeemedmobile END) AS `Coupon Redeemers`,
      IFNULL(SUM(CASE WHEN couponstatus = 'used' THEN a.amount ELSE 0 END),0) AS `Coupon Redemption Sales`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN b.billno END) AS `Coupon Redemption Bills`,
      IFNULL(SUM(discount),0)`Value of coupon Redeemed`
    FROM coupon_offer_report a 
    
      JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.redeemedstorecode=c.storecode
    WHERE useddate BETWEEN '2025-04-01' AND '2025-04-30'
    GROUP BY 1
    UNION 
    
--     mcv tier wise data 

     SELECT 
      CASE 
         WHEN useddate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'MVC_CY_Month_COCO' END AS Rewards,
      COUNT(CASE WHEN couponstatus = 'used' THEN couponoffercode END) AS `Total Coupons Redeemed`,
      COUNT(DISTINCT b.mobile) AS `Total Customers`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN redeemedmobile END) AS `Coupon Redeemers`,
      IFNULL(SUM(CASE WHEN couponstatus = 'used' THEN a.amount ELSE 0 END),0) AS `Coupon Redemption Sales`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN b.billno END) AS `Coupon Redemption Bills`,
      IFNULL(SUM(discount),0)`Value of coupon Redeemed`
    FROM coupon_offer_report a 
    
      JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.redeemedstorecode=c.storecode
      JOIN member_report d ON a.redeemedmobile=d.mobile
    WHERE useddate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE '%coco%' AND d.tier = 'MVC'
    GROUP BY 1
    UNION
      SELECT 
      CASE 
         WHEN useddate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'MVC_CY_Month_FOFO' END AS Rewards,
      COUNT(CASE WHEN couponstatus = 'used' THEN couponoffercode END) AS `Total Coupons Redeemed`,
      COUNT(DISTINCT b.mobile) AS `Total Customers`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN redeemedmobile END) AS `Coupon Redeemers`,
      IFNULL(SUM(CASE WHEN couponstatus = 'used' THEN a.amount ELSE 0 END),0) AS `Coupon Redemption Sales`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN b.billno END) AS `Coupon Redemption Bills`,
      IFNULL(SUM(discount),0)`Value of coupon Redeemed`
    FROM coupon_offer_report a 
    
      JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.redeemedstorecode=c.storecode
      JOIN member_report d ON a.redeemedmobile=d.mobile
    WHERE useddate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE '%fofo%' AND d.tier = 'MVC'
    GROUP BY 1
    UNION
     SELECT 'MVC_CY_Month_Online' AS Rewards,
      COUNT(CASE WHEN couponstatus = 'used' THEN couponoffercode END) AS `Total Coupons Redeemed`,
      COUNT(DISTINCT b.mobile) AS `Total Customers`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN redeemedmobile END) AS `Coupon Redeemers`,
      IFNULL(SUM(CASE WHEN couponstatus = 'used' THEN a.amount ELSE '0' END),0) AS `Coupon Redemption Sales`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN b.billno END) AS `Coupon Redemption Bills`,
      IFNULL(SUM(discount),0)`Value of coupon Redeemed`
    FROM coupon_offer_report a 
    
      JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.redeemedstorecode=c.storecode
      JOIN member_report d ON a.redeemedmobile=d.mobile
    WHERE useddate BETWEEN '2025-04-01' AND '2025-04-30' AND redeemedstorecode = 'ecom' AND d.tier = 'MVC'
    UNION
      SELECT 
      CASE 
         WHEN useddate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'MVC_CY_Month_Overall' END AS Rewards,
      COUNT(CASE WHEN couponstatus = 'used' THEN couponoffercode END) AS `Total Coupons Redeemed`,
      COUNT(DISTINCT b.mobile) AS `Total Customers`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN redeemedmobile END) AS `Coupon Redeemers`,
      IFNULL(SUM(CASE WHEN couponstatus = 'used' THEN a.amount ELSE 0 END),0) AS `Coupon Redemption Sales`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN b.billno END) AS `Coupon Redemption Bills`,
      IFNULL(SUM(discount),0)`Value of coupon Redeemed`
    FROM coupon_offer_report a 
    
      JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.redeemedstorecode=c.storecode
      JOIN member_report d ON a.redeemedmobile=d.mobile
    WHERE useddate BETWEEN '2025-04-01' AND '2025-04-30' AND d.tier = 'MVC'
    GROUP BY 1
    UNION 
     SELECT 
      CASE 
         WHEN useddate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'MVC_CY_YTM_COCO' END AS Rewards,
      COUNT(CASE WHEN couponstatus = 'used' THEN couponoffercode END) AS `Total Coupons Redeemed`,
      COUNT(DISTINCT b.mobile) AS `Total Customers`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN redeemedmobile END) AS `Coupon Redeemers`,
      IFNULL(SUM(CASE WHEN couponstatus = 'used' THEN a.amount ELSE 0 END),0) AS `Coupon Redemption Sales`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN b.billno END) AS `Coupon Redemption Bills`,
      IFNULL(SUM(discount),0)`Value of coupon Redeemed`
    FROM coupon_offer_report a 
    
      JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.redeemedstorecode=c.storecode
      JOIN member_report d ON a.redeemedmobile=d.mobile
    WHERE useddate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE '%coco%' AND d.tier = 'MVC'
    GROUP BY 1
    UNION
      SELECT 
      CASE 
         WHEN useddate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'MVC_CY_YTM_FOFO' END AS Rewards,
      COUNT(CASE WHEN couponstatus = 'used' THEN couponoffercode END) AS `Total Coupons Redeemed`,
      COUNT(DISTINCT b.mobile) AS `Total Customers`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN redeemedmobile END) AS `Coupon Redeemers`,
      IFNULL(SUM(CASE WHEN couponstatus = 'used' THEN a.amount ELSE 0 END),0) AS `Coupon Redemption Sales`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN b.billno END) AS `Coupon Redemption Bills`,
      IFNULL(SUM(discount),0)`Value of coupon Redeemed`
    FROM coupon_offer_report a 
    
      JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.redeemedstorecode=c.storecode
      JOIN member_report d ON a.redeemedmobile=d.mobile
    WHERE useddate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE '%fofo%' AND d.tier = 'MVC'
    GROUP BY 1
    UNION
     SELECT 'MVC_CY_YTM_Online' AS Rewards,
      COUNT(CASE WHEN couponstatus = 'used' THEN couponoffercode END) AS `Total Coupons Redeemed`,
      COUNT(DISTINCT b.mobile) AS `Total Customers`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN redeemedmobile END) AS `Coupon Redeemers`,
      IFNULL(SUM(CASE WHEN couponstatus = 'used' THEN a.amount ELSE 0 END),0) AS `Coupon Redemption Sales`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN b.billno END) AS `Coupon Redemption Bills`,
      IFNULL(SUM(discount),0)`Value of coupon Redeemed`
    FROM coupon_offer_report a 
    
      JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.redeemedstorecode=c.storecode
      JOIN member_report d ON a.redeemedmobile=d.mobile
    WHERE useddate BETWEEN '2025-04-01' AND '2025-04-30' AND redeemedstorecode = 'ecom' AND d.tier ='MVC'
    UNION
      SELECT 
      CASE 
         WHEN useddate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'MVC_CY_YTM_Overall' END AS Rewards,
      COUNT(CASE WHEN couponstatus = 'used' THEN couponoffercode END) AS `Total Coupons Redeemed`,
      COUNT(DISTINCT b.mobile) AS `Total Customers`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN redeemedmobile END) AS `Coupon Redeemers`,
      IFNULL(SUM(CASE WHEN couponstatus = 'used' THEN a.amount ELSE 0 END),0) AS `Coupon Redemption Sales`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN b.billno END) AS `Coupon Redemption Bills`,
      IFNULL(SUM(discount),0)`Value of coupon Redeemed`
    FROM coupon_offer_report a 
    
      JOIN dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.redeemedstorecode=c.storecode
      JOIN member_report d ON a.redeemedmobile=d.mobile
    WHERE useddate BETWEEN '2025-04-01' AND '2025-04-30' AND d.tier ='MVC'
    GROUP BY 1)
    SELECT a.Rewards,`Total Coupons Issued`,`Total Coupons Redeemed`,`Total Customers`,
    `Coupon Redeemers`,`Coupon Redemption Sales`,`Coupon Redemption Bills`,
    `Value of coupon Redeemed`
     FROM  issued a JOIN CY_cytm b ON a.Rewards=b.Rewards
     GROUP BY 1;   
#################################################################################################################################

-- SELECT * FROM coupon_offer_report LIMIT 100
-- slide 14
-- coupon data 
WITH issued AS (
SELECT 
CASE WHEN issueddate BETWEEN '2025-04-01' AND '2025-04-30' THEN  'Overall_CY_Month' END 'Rewards',
COUNT(couponoffercode)`Total Coupons Issued`
FROM coupon_offer_report 
WHERE issueddate BETWEEN '2025-04-01' AND '2025-04-30' AND couponstatus = 'issued' 
GROUP BY 1
UNION
SELECT 
CASE WHEN issueddate BETWEEN '2025-04-01' AND '2025-04-30' THEN  'Overall_CY_YTM' END 'Rewards',
COUNT(couponoffercode)`Total Coupons Issued`
FROM coupon_offer_report 
WHERE issueddate BETWEEN '2025-04-01' AND '2025-04-30' AND couponstatus = 'issued' 
GROUP BY 1
UNION
SELECT 
CASE WHEN issueddate BETWEEN '2025-04-01' AND '2025-04-30' AND b.tier LIKE '%MVC%' THEN  'MVC_CY_Month' END 'Rewards',
COUNT(couponoffercode)`Total Coupons Issued`
FROM coupon_offer_report a JOIN member_report b ON a.issuedmobile=b.mobile
WHERE issueddate BETWEEN '2025-04-01' AND '2025-04-30' AND couponstatus = 'issued' 
GROUP BY 1
UNION
SELECT 
CASE WHEN issueddate BETWEEN '2025-04-01' AND '2025-04-30' AND b.tier LIKE '%MVC%' THEN  'MVC_CY_YTM' END 'Rewards',
COUNT(couponoffercode)`Total Coupons Issued`
FROM coupon_offer_report a JOIN member_report b ON a.issuedmobile=b.mobile
WHERE issueddate BETWEEN '2025-04-01' AND '2025-04-30' AND couponstatus = 'issued' 
GROUP BY 1),
CY_cytm AS (
 SELECT 
      CASE 
         WHEN useddate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'Overall_CY_Month' END AS Rewards,
      COUNT(CASE WHEN couponstatus = 'used' THEN couponoffercode END) AS `Total Coupons Redeemed`,
      COUNT(DISTINCT b.mobile) AS `Total Customers`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN redeemedmobile END) AS `Coupon Redeemers`,
      SUM(CASE WHEN couponstatus = 'used' THEN a.amount END) AS `Coupon Redemption Sales`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN b.billno END) AS `Coupon Redemption Bills`,
      SUM(discount)`Value of coupon Redeemed`
    FROM coupon_offer_report a 
    WHERE useddate BETWEEN '2025-04-01' AND '2025-04-30' AND mobile IN ()
    GROUP BY 1
    UNION
SELECT 
CASE 
WHEN useddate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'Overall_CY_YTM' END AS Rewards,
COUNT(CASE WHEN couponstatus = 'used' THEN couponoffercode END) AS `Total Coupons Redeemed`,
COUNT(DISTINCT b.mobile) AS `Total Customers`,
COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN redeemedmobile END) AS `Coupon Redeemers`,
SUM(CASE WHEN couponstatus = 'used' THEN a.amount END) AS `Coupon Redemption Sales`,
COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN b.billno END) AS `Coupon Redemption Bills`,
SUM(discount)`Value of coupon Redeemed`
    FROM coupon_offer_report a 
    WHERE useddate BETWEEN '2025-04-01' AND '2025-04-30' AND 
    GROUP BY 1
    UNION
    SELECT 
      CASE 
         WHEN useddate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'MVC_CY_Month' END AS Rewards,
      COUNT(CASE WHEN couponstatus = 'used' THEN couponoffercode END) AS `Total Coupons Redeemed`,
      COUNT(DISTINCT b.mobile) AS `Total Customers`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN redeemedmobile END) AS `Coupon Redeemers`,
      SUM(CASE WHEN couponstatus = 'used' THEN a.amount END) AS `Coupon Redemption Sales`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN b.billno END) AS `Coupon Redemption Bills`,
      SUM(discount)`Value of coupon Redeemed`
    FROM coupon_offer_report a 
       JOIN member_report c ON a.issuedmobile = c.mobile
    WHERE useddate BETWEEN '2025-04-01' AND '2025-04-30' AND c.tier LIKE 'MVC'
    GROUP BY 1
    UNION
     SELECT 
      CASE 
         WHEN useddate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'MVC_CY_YTM' END AS Rewards,
      COUNT(CASE WHEN couponstatus = 'used' THEN couponoffercode END) AS `Total Coupons Redeemed`,
      COUNT(DISTINCT b.mobile) AS `Total Customers`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN redeemedmobile END) AS `Coupon Redeemers`,
      SUM(CASE WHEN couponstatus = 'used' THEN a.amount END) AS `Coupon Redemption Sales`,
      COUNT(DISTINCT CASE WHEN couponstatus = 'used' THEN b.billno END) AS `Coupon Redemption Bills`,
      SUM(discount)`Value of coupon Redeemed`
    FROM coupon_offer_report a 
    JOIN member_report c ON a.issuedmobile=c.mobile
    WHERE useddate BETWEEN '2025-04-01' AND '2025-04-30' AND c.tier LIKE 'MVC'
    GROUP BY 1)
    SELECT a.Rewards,`Total Coupons Issued`,`Total Coupons Redeemed`,`Total Customers`,
    `Coupon Redeemers`,`Coupon Redemption Sales`,`Coupon Redemption Bills`,
    `Value of coupon Redeemed`
     FROM  issued a JOIN CY_cytm b ON a.Rewards=b.Rewards
     GROUP BY 1; 



-- slide 13 Channel support for program actions


WITH new_member AS(
SELECT 'CO_LY_YTM' AS Metric,COUNT(DISTINCT mobile)`New Member Enrolment (in K)`
FROM member_report a JOIN dummy.Updated_BlackBerrys_Tagging_Store_master b ON a.enrolledstorecode=b.storecode
WHERE modifiedenrolledon BETWEEN '2024-04-01' AND '2024-04-30' AND storetype LIKE '%coco%' 
UNION 
SELECT 'CO_CY_YTM' AS Metric,COUNT(DISTINCT mobile)`New Member Enrolment (in K)`
FROM member_report a JOIN dummy.Updated_BlackBerrys_Tagging_Store_master b ON a.enrolledstorecode=b.storecode
WHERE modifiedenrolledon BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE '%coco%'
UNION
SELECT 'FO_LY_YTM' AS Metric,COUNT(DISTINCT mobile)`New Member Enrolment (in K)`
FROM member_report a JOIN dummy.Updated_BlackBerrys_Tagging_Store_master b ON a.enrolledstorecode=b.storecode
WHERE modifiedenrolledon BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE '%fofo%'
UNION
SELECT 'FO_CY_YTM' AS Metric,COUNT(DISTINCT mobile)`New Member Enrolment (in K)`
FROM member_report a JOIN dummy.Updated_BlackBerrys_Tagging_Store_master b ON a.enrolledstorecode=b.storecode
WHERE modifiedenrolledon BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE '%fofo%'
UNION
SELECT 'BB_LY_YTM' AS Metric,COUNT(DISTINCT mobile)`New Member Enrolment (in K)`
FROM member_report a LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master b ON a.enrolledstorecode=b.storecode
WHERE modifiedenrolledon BETWEEN '2025-04-01' AND '2025-04-30' AND enrolledstorecode = 'ecom'
UNION
SELECT 'BB_CY_YTM' AS Metric,COUNT(DISTINCT mobile)`New Member Enrolment (in K)`
FROM member_report a LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master b ON a.enrolledstorecode=b.storecode
WHERE modifiedenrolledon BETWEEN '2025-04-01' AND '2025-04-30' AND enrolledstorecode = 'ecom'),

-- customer who enrolled and shopped 
Ent AS (

SELECT  'CO_LY_YTM' AS Metric,COUNT(DISTINCT mobile)`New Members who enrolled and shopped (in K)`
FROM member_report a JOIN dummy.Updated_BlackBerrys_Tagging_Store_master b ON a.enrolledstorecode=b.storecode
WHERE modifiedenrolledon BETWEEN '2024-04-01' AND '2024-04-30' AND  storetype LIKE '%coco%'
AND mobile IN (SELECT DISTINCT mobile FROM txn_report_accrual_redemption WHERE txndate BETWEEN '2024-04-01' AND '2024-04-30')
UNION
SELECT  'CO_CY_YTM' AS Metric,COUNT(DISTINCT mobile)`New Members who enrolled and shopped (in K)`
FROM member_report a JOIN dummy.Updated_BlackBerrys_Tagging_Store_master b ON a.enrolledstorecode=b.storecode
WHERE modifiedenrolledon BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE '%coco%'
AND mobile IN (SELECT DISTINCT mobile FROM txn_report_accrual_redemption WHERE txndate BETWEEN '2025-04-01' AND '2025-04-30')
UNION
SELECT  'FO_LY_YTM' AS Metric,COUNT(DISTINCT mobile)`New Members who enrolled and shopped (in K)`
FROM member_report a JOIN dummy.Updated_BlackBerrys_Tagging_Store_master b ON a.enrolledstorecode=b.storecode
WHERE modifiedenrolledon BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE '%fofo%'
AND mobile IN (SELECT DISTINCT mobile FROM txn_report_accrual_redemption WHERE txndate BETWEEN '2025-04-01' AND '2025-04-30')
UNION
SELECT  'FO_CY_YTM' AS Metric,COUNT(DISTINCT mobile)`New Members who enrolled and shopped (in K)`
FROM member_report a JOIN dummy.Updated_BlackBerrys_Tagging_Store_master b ON a.enrolledstorecode=b.storecode
WHERE modifiedenrolledon BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE '%fofo%'
AND mobile IN (SELECT DISTINCT mobile FROM txn_report_accrual_redemption WHERE txndate BETWEEN '2025-04-01' AND '2025-04-30')
UNION
SELECT  'BB_LY_YTM' AS Metric,COUNT(DISTINCT mobile)`New Members who enrolled and shopped (in K)`
FROM member_report a JOIN dummy.Updated_BlackBerrys_Tagging_Store_master b ON a.enrolledstorecode=b.storecode
JOIN sku_report_loyalty c ON a.mobile=c.txnmappedmobile
WHERE modifiedenrolledon BETWEEN  '2024-04-01' AND '2024-04-30' AND modifiedstorecode = 'ecom'
AND mobile IN (SELECT DISTINCT mobile FROM txn_report_accrual_redemption WHERE txndate BETWEEN '2024-04-01' AND '2025-03-31')
UNION
SELECT  'BB_CY_YTM' AS Metric,COUNT(DISTINCT mobile)`New Members who enrolled and shopped (in K)`
FROM member_report a JOIN dummy.Updated_BlackBerrys_Tagging_Store_master b ON a.enrolledstorecode=b.storecode
JOIN sku_report_loyalty c ON a.mobile=c.txnmappedmobile
WHERE modifiedenrolledon BETWEEN '2025-04-01' AND '2025-04-30' AND modifiedstorecode = 'ecom'
AND mobile IN (SELECT DISTINCT mobile FROM txn_report_accrual_redemption WHERE txndate BETWEEN '2025-04-01' AND '2025-03-31')
),
-- other kpis store wise 

 channel_suppose_data AS (
SELECT'CO_LY_YTM' AS Metric,'TBU' AS `Total Invoices / Orders`,COUNT(DISTINCT uniquebillno)`Non-Loyalty Invoices (in K)`,
'TBU' AS `New Member Enrolment Efficiency`,
'TBU' AS `Number of CYR - QR Code Scans`,
'TBU' AS `Number of CYR Coupons Claimed (in K)`,
'TBU' AS `Number of CYR Coupons Redeemed (in K)`,
'TBU' AS `% of QR Code Scans as % of Total Invoices`,
'TBU' AS `% of Coupons Claimed as % of Scans`,
'TBU' AS `% of Coupons redeemed as % of Claimed`,
'TBU' AS `CYR Coupon Value as % of Coupon Invoice Sales`,
'TBU' AS `Number of Referrer Links Created (in K)`,
'TBU' AS `Number of Referee Coupons Redeemed (in K)`,
'TBU' AS `Number of New Customers Acquired (in K)`
FROM sku_report_nonloyalty a JOIN dummy.Updated_BlackBerrys_Tagging_Store_master b ON a.modifiedstorecode=b.storecode
WHERE modifiedtxndate BETWEEN '2024-04-01' AND '2024-04-30' AND storetype LIKE '%coco%' 
GROUP BY 1
UNION
SELECT'CO_CY_YTM' AS Metric,'TBU' AS `Total Invoices / Orders`,COUNT(DISTINCT uniquebillno)`Non-Loyalty Invoices (in K)`,
'TBU' AS `New Member Enrolment Efficiency`,
'TBU' AS `Number of CYR - QR Code Scans`,
'TBU' AS `Number of CYR Coupons Claimed (in K)`,
'TBU' AS `Number of CYR Coupons Redeemed (in K)`,
'TBU' AS `% of QR Code Scans as % of Total Invoices`,
'TBU' AS `% of Coupons Claimed as % of Scans`,
'TBU' AS `% of Coupons redeemed as % of Claimed`,
'TBU' AS `CYR Coupon Value as % of Coupon Invoice Sales`,
'TBU' AS `Number of Referrer Links Created (in K)`,
'TBU' AS `Number of Referee Coupons Redeemed (in K)`,
'TBU' AS `Number of New Customers Acquired (in K)`
FROM sku_report_nonloyalty a JOIN dummy.Updated_BlackBerrys_Tagging_Store_master b ON a.modifiedstorecode=b.storecode
WHERE modifiedtxndate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE '%coco%' 
GROUP BY 1 
UNION
SELECT 'FO_LY_YTM'  AS Metric,'TBU' AS `Total Invoices / Orders`,COUNT(DISTINCT uniquebillno)`Non-Loyalty Invoices (in K)`,
'TBU' AS `New Member Enrolment Efficiency`,
'TBU' AS `Number of CYR - QR Code Scans`,
'TBU' AS `Number of CYR Coupons Claimed (in K)`,
'TBU' AS `Number of CYR Coupons Redeemed (in K)`,
'TBU' AS `% of QR Code Scans as % of Total Invoices`,
'TBU' AS `% of Coupons Claimed as % of Scans`,
'TBU' AS `% of Coupons redeemed as % of Claimed`,
'TBU' AS `CYR Coupon Value as % of Coupon Invoice Sales`,
'TBU' AS `Number of Referrer Links Created (in K)`,
'TBU' AS `Number of Referee Coupons Redeemed (in K)`,
'TBU' AS `Number of New Customers Acquired (in K)`
FROM sku_report_nonloyalty a JOIN dummy.Updated_BlackBerrys_Tagging_Store_master b ON a.modifiedstorecode=b.storecode
WHERE modifiedtxndate BETWEEN '2024-04-01' AND '2024-04-30' AND storetype LIKE '%fofo%'
GROUP BY 1
UNION
SELECT 'fO_CY_YTM' AS Metric,'TBU' AS `Total Invoices / Orders`,COUNT(DISTINCT uniquebillno)`Non-Loyalty Invoices (in K)`,
'TBU' AS `New Member Enrolment Efficiency`,
'TBU' AS `Number of CYR - QR Code Scans`,
'TBU' AS `Number of CYR Coupons Claimed (in K)`,
'TBU' AS `Number of CYR Coupons Redeemed (in K)`,
'TBU' AS `% of QR Code Scans as % of Total Invoices`,
'TBU' AS `% of Coupons Claimed as % of Scans`,
'TBU' AS `% of Coupons redeemed as % of Claimed`,
'TBU' AS `CYR Coupon Value as % of Coupon Invoice Sales`,
'TBU' AS `Number of Referrer Links Created (in K)`,
'TBU' AS `Number of Referee Coupons Redeemed (in K)`,
'TBU' AS `Number of New Customers Acquired (in K)`
FROM sku_report_nonloyalty a JOIN dummy.Updated_BlackBerrys_Tagging_Store_master b ON a.modifiedstorecode=b.storecode
WHERE modifiedtxndate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE '%fofo%'
GROUP BY 1
UNION 
SELECT 
    Metric,
    'TBU' AS `Total Invoices / Orders`,
    0 AS `Non-Loyalty Invoices (in K)`,  -- Since ecom has no data in sku_report_nonloyalty
    'TBU' AS `New Member Enrolment Efficiency`,
    'TBU' AS `Number of CYR - QR Code Scans`,
    'TBU' AS `Number of CYR Coupons Claimed (in K)`,
    'TBU' AS `Number of CYR Coupons Redeemed (in K)`,
    'TBU' AS `% of QR Code Scans as % of Total Invoices`,
    'TBU' AS `% of Coupons Claimed as % of Scans`,
    'TBU' AS `% of Coupons redeemed as % of Claimed`,
    'TBU' AS `CYR Coupon Value as % of Coupon Invoice Sales`,
    'TBU' AS `Number of Referrer Links Created (in K)`,
    'TBU' AS `Number of Referee Coupons Redeemed (in K)`,
    'TBU' AS `Number of New Customers Acquired (in K)`
FROM (
    SELECT 'BB_LY_YTM' AS Metric
    UNION ALL
    SELECT 'BB_CY_YTM' AS Metric
) AS Metrics)
-- summary code 
SELECT a.Metric,`New Member Enrolment (in K)`,`New Members who enrolled and shopped (in K)`,
`Total Invoices / Orders`,`Non-Loyalty Invoices (in K)`,`New Member Enrolment Efficiency`,
`Number of CYR - QR Code Scans`,`Number of CYR Coupons Claimed (in K)`,`Number of CYR Coupons Redeemed (in K)`,
`% of QR Code Scans as % of Total Invoices`,`% of Coupons Claimed as % of Scans`,`% of Coupons redeemed as % of Claimed`,
`CYR Coupon Value as % of Coupon Invoice Sales`,`Number of Referrer Links Created (in K)`,`Number of Referee Coupons Redeemed (in K)`,
`Number of New Customers Acquired (in K)`
FROM new_member a JOIN Ent b ON a.Metric=b.Metric
JOIN channel_suppose_data c ON a.Metric=c.Metric
GROUP BY Metric;


-- slide 16
SELECT * FROM coupon_offer_report;
coupon offer report 

SELECT couponoffercode,COUNT(DISTINCT redeemedmobile)customer,SUM(amount)sales,COUNT(DISTINCT billno)bills FROM coupon_offer_report
WHERE useddate BETWEEN '2025-04-01' AND '2025-04-30'
GROUP BY 1;