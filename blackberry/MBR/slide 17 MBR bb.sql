

-- slide 17 
WITH points_data AS(

SELECT 'Overall_CY_Month' AS Rewards,
SUM(a.pointscollected)`Total Transaction Points Issued`,
-- SUM(b.pointscollected)`Total Bonus Points Issued`,
SUM(a.pointsspent)`Total Points Redeemed`,
COUNT(DISTINCT a.mobile)`Total Customers`,
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN a.mobile END )`Point Redeemers`,
SUM(a.pointsspent) AS `Value of Points Redeemed`,
SUM( CASE WHEN a.pointsspent>0 THEN a.amount END)`Point Redemption Sales`,
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN a.uniquebillno END)`Point Redemption Bills`
FROM dummy.CY_txn_data a 
-- LEFT JOIN txn_report_flat_accrual b USING(mobile)
WHERE  a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND storecode <> 'demo'

UNION
SELECT  'Overall_CY_YTM' AS Rewards,
SUM(a.pointscollected)`Total Transaction Points Issued`,
-- SUM(b.pointscollected)`Total Bonus Points Issued`,
SUM(a.pointsspent)`Total Points Redeemed`,
COUNT(DISTINCT a.mobile)`Total Customers`,
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN a.mobile END )`Point Redeemers`,
SUM(a.pointsspent) AS `Value of Points Redeemed`,
SUM( CASE WHEN a.pointsspent>0 THEN a.amount END)`Point Redemption Sales`,
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN a.uniquebillno END)`Point Redemption Bills`
FROM dummy.CY_txn_data a 
-- LEFT JOIN txn_report_flat_accrual b USING(mobile)
WHERE  a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND storecode <> 'demo'

UNION
SELECT 'MVC_CY_Month' AS Rewards,
SUM(a.pointscollected)`Total Transaction Points Issued`,
-- SUM(b.pointscollected)`Total Bonus Points Issued`,
SUM(a.pointsspent)`Total Points Redeemed`,
COUNT(DISTINCT a.mobile)`Total Customers`,
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN a.mobile END )`Point Redeemers`,
SUM(a.pointsspent) AS `Value of Points Redeemed`,
SUM( CASE WHEN a.pointsspent>0 THEN a.amount END)`Point Redemption Sales`,
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN a.uniquebillno END)`Point Redemption Bills`
FROM dummy.CY_txn_data a 
-- LEFT JOIN txn_report_flat_accrual b ON a.mobile=b.mobile 
LEFT JOIN member_report c ON a.mobile=c.mobile
WHERE tier LIKE '%MVC%' AND  a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND storecode <> 'demo'

UNION
SELECT CASE
--  WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'MVC_CY_Month'
WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'MVC_CY_YTM' 
END Rewards,
SUM(a.pointscollected)`Total Transaction Points Issued`,
-- SUM(b.pointscollected)`Total Bonus Points Issued`,
SUM(a.pointsspent)`Total Points Redeemed`,
COUNT(DISTINCT a.mobile)`Total Customers`,
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN a.mobile END )`Point Redeemers`,
SUM(a.pointsspent) AS `Value of Points Redeemed`,
SUM( CASE WHEN a.pointsspent>0 THEN a.amount END)`Point Redemption Sales`,
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN a.uniquebillno END)`Point Redemption Bills`
FROM dummy.CY_txn_data a 
-- LEFT JOIN txn_report_flat_accrual b ON a.mobile=b.mobile 
LEFT JOIN member_report c ON a.mobile=c.mobile
WHERE tier LIKE '%MVC%' AND  a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND storecode <> 'demo'
 ),
bonus_points AS(
SELECT 
'Overall_CY_Month' AS Rewards,SUM(pointscollected)`Total Bonus Points Issued` FROM txn_report_flat_accrual 
WHERE txndate BETWEEN '2025-04-01' AND '2025-04-30' 
UNION
SELECT 
'Overall_CY_YTM' AS Rewards,SUM(pointscollected)`Total Bonus Points Issued` FROM txn_report_flat_accrual 
WHERE txndate BETWEEN '2025-04-01' AND '2025-04-30'
UNION
SELECT 
'MVC_CY_Month' AS Rewards,SUM(pointscollected)`Total Bonus Points Issued` FROM txn_report_flat_accrual LEFT JOIN member_report
USING(mobile)
WHERE txndate BETWEEN '2025-04-01' AND '2025-04-30' AND tier LIKE '%mvc%'
UNION
SELECT 
'MVC_CY_YTM' AS Rewards,SUM(pointscollected)`Total Bonus Points Issued` FROM txn_report_flat_accrual LEFT JOIN member_report
USING(mobile)
WHERE txndate BETWEEN '2025-04-01' AND '2025-04-30' AND tier LIKE '%mvc%'


)
SELECT a.Rewards,`Total Transaction Points Issued`,`Total Bonus Points Issued`,`Total Points Redeemed`,
`Total Customers`,`Point Redeemers`,`Value of Points Redeemed`,`Point Redemption Sales`,`Point Redemption Bills`
FROM points_data a JOIN bonus_points b USING(Rewards)