WITH classified AS (
  SELECT
    a.mobile,
    a.pointscollected,
    b.pointscollected AS bonus_points,
    a.pointsspent,
    a.amount,
    a.uniquebillno
  FROM
    dummy.CY_txn_data AS a
    LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master AS c
      ON a.storecode = c.storecode
    JOIN txn_report_flat_accrual b 
      ON a.mobile = b.mobile 
      JOIN member_report m ON m.mobile = a.mobile
  WHERE
    a.txndate BETWEEN '2025-04-01' AND '2025-04-30'
    AND a.storecode <> 'demo' 
    AND m.tier='MVC' AND amount>0
)

SELECT
  'Overall_CY_Month_All'                                 AS Rewards,
  SUM(pointscollected)                                   AS `Total Transaction Points Issued`,
  SUM(bonus_points)                                      AS `Total Bonus Points Issued`,
  SUM(pointsspent)                                       AS `Total Points Redeemed`,
  COUNT(DISTINCT mobile)                                 AS `Total Customers`,
  COUNT(DISTINCT CASE WHEN pointsspent > 0 THEN mobile END)
                                                         AS `Point Redeemers`,
  SUM(pointsspent)                                       AS `Value of Points Redeemed`,
  SUM(CASE WHEN pointsspent > 0 THEN amount ELSE 0 END)  AS `Point Redemption Sales`,
  COUNT(DISTINCT CASE WHEN pointsspent > 0 THEN uniquebillno END)
                                                         AS `Point Redemption Bills`
FROM classified

 UNION ALL

 SELECT
  'Overall_CY_Month_All'            AS Rewards,
  SUM(pointscollected),
  SUM(bonus_points),
  SUM(pointsspent),
  COUNT(DISTINCT mobile),
  COUNT(DISTINCT CASE WHEN pointsspent > 0 THEN mobile END),
  SUM(pointsspent),
  SUM(CASE WHEN pointsspent > 0 THEN amount ELSE 0 END),
  COUNT(DISTINCT CASE WHEN pointsspent > 0 THEN uniquebillno END)
FROM classified
 
ORDER BY 
  CASE WHEN Rewards = 'Overall_CY_Month_All' THEN 2 ELSE 1 END,
  Rewards;


















-- slide 18 




WITH classified AS (
  SELECT
    a.mobile,
    a.pointscollected,
	b.pointscollected AS bonus_points,
    a.pointsspent,
    a.amount,
    a.uniquebillno,
    CASE 
      WHEN c.storetype LIKE '%COCO%' 
        THEN 'Overall_CY_Month_COCO'
      WHEN c.storetype LIKE '%FOFO%' 
        THEN 'Overall_CY_Month_FOFO'
      WHEN UPPER(a.storecode) = 'ECOM' 
        THEN 'Overall_CY_Month_Online'
      ELSE 
        'Overall_CY_Month_rest'
    END AS Rewards
  FROM
    dummy.CY_txn_data AS a
    LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master AS c
      ON a.storecode = c.storecode
--     JOIN member_report m ON m.mobile = a.mobile
    JOIN txn_report_flat_accrual b ON a.mobile=b.mobile 
--     AND m.tier = 'MVC'  
  WHERE
    a.txndate    BETWEEN '2025-04-01' AND '2025-04-30'
    AND a.storecode <> 'demo'
)
 
SELECT
  Rewards,
  SUM(pointscollected)                                  AS `Total Transaction Points Issued`,
   SUM(bonus_points)                                  AS `Total Bonus Points Issued`,
  SUM(pointsspent)                                      AS `Total Points Redeemed`,
  COUNT(DISTINCT mobile)                                AS `Total Customers`,
  COUNT(DISTINCT CASE WHEN pointsspent > 0 THEN mobile END)
                                                        AS `Point Redeemers`,
  SUM(pointsspent)                                      AS `Value of Points Redeemed`,
  SUM(CASE WHEN pointsspent > 0 THEN amount ELSE 0 END) AS `Point Redemption Sales`,
  COUNT(DISTINCT CASE WHEN pointsspent > 0 THEN uniquebillno END)
                                                        AS `Point Redemption Bills`
FROM classified
GROUP BY Rewards
 
UNION ALL
 
SELECT
  'Overall_CY_Month_All'            AS Rewards,
  SUM(pointscollected),
  SUM(bonus_points),
  SUM(pointsspent),
  COUNT(DISTINCT mobile),
  COUNT(DISTINCT CASE WHEN pointsspent > 0 THEN mobile END),
  SUM(pointsspent),
  SUM(CASE WHEN pointsspent > 0 THEN amount ELSE 0 END),
  COUNT(DISTINCT CASE WHEN pointsspent > 0 THEN uniquebillno END)
FROM classified
 
ORDER BY 
  CASE WHEN Rewards = 'Overall_CY_Month_All' THEN 2 ELSE 1 END,
  Rewards;






































SELECT
  CASE 
    WHEN c.storetype LIKE '%COCO%' THEN 'Overall_CY_Month_COCO'
    WHEN c.storetype LIKE '%FOFO%' THEN 'Overall_CY_Month_FOFO'
    WHEN UPPER(a.storecode) IN ('ECOM') THEN 'Overall_CY_Month_Online'
    ELSE 'Overall_CY_Month_rest'
  END AS `Rewards`,
  SUM(a.pointscollected)  AS `Total Transaction Points Issued`,
  SUM(a.pointsspent)      AS `Total Points Redeemed`,
  COUNT(DISTINCT a.mobile)AS `Total Customers`,
  COUNT(DISTINCT CASE WHEN a.pointsspent > 0 THEN a.mobile END)
                                       AS `Point Redeemers`,
  SUM(a.pointsspent)                   AS `Value of Points Redeemed`,
  SUM(CASE WHEN a.pointsspent > 0 THEN a.amount ELSE 0 END)
                                       AS `Point Redemption Sales`,
  COUNT(DISTINCT CASE WHEN a.pointsspent > 0 THEN a.uniquebillno END)
                                       AS `Point Redemption Bills`
FROM
  dummy.CY_txn_data AS a
  LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master AS c
    ON a.storecode = c.storecode
WHERE
  a.txndate    BETWEEN '2025-04-01' AND '2025-04-30'
  AND a.storecode <> 'demo' AND (c.storetype LIKE '%COCO%' OR c.storetype LIKE '%FOFO%') OR a.storecode = 'Ecom'
GROUP BY
  `Rewards`;






-- slide 18 
WITH points_data AS (
SELECT
CASE 
    WHEN c.storetype LIKE '%COCO%' THEN 'Overall_CY_Month_COCO'
    WHEN c.storetype LIKE '%FOFO%' THEN 'Overall_CY_Month_FOFO'
    WHEN UPPER(a.storecode) IN ('ECOM') THEN 'Overall_CY_Month_Online'
    ELSE 'Overall_CY_Month_rest'
  END AS `Rewards`,
SUM(a.pointscollected)`Total Transaction Points Issued`,
-- SUM(b.pointscollected)`Total Bonus Points Issued`,
SUM(a.pointsspent)`Total Points Redeemed`,
COUNT(DISTINCT a.mobile)`Total Customers`,
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN a.mobile END )`Point Redeemers`,
SUM(a.pointsspent) AS `Value of Points Redeemed`,
SUM( CASE WHEN a.pointsspent>0 THEN a.amount ELSE 0 END)`Point Redemption Sales`,
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN a.uniquebillno END)`Point Redemption Bills`
FROM dummy.CY_txn_data a 
-- LEFT JOIN txn_report_flat_accrual b ON a.mobile=b.mobile 
LEFT JOIN  dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.storecode=c.storecode 
WHERE a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND a.storecode <> 'demo' 
AND (c.storetype LIKE '%COCO%' OR c.storetype LIKE '%FOFO%') OR a.storecode = 'Ecom'
GROUP BY 1



UNION
SELECT CASE 
WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'Overall_CY_Month_Overall'
END 'Rewards',
SUM(a.pointscollected)`Total Transaction Points Issued`,
-- SUM(b.pointscollected)`Total Bonus Points Issued`,
SUM(a.pointsspent)`Total Points Redeemed`,
COUNT(DISTINCT a.mobile)`Total Customers`,
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN a.mobile END )`Point Redeemers`,
SUM(a.pointsspent) AS `Value of Points Redeemed`,
SUM( CASE WHEN a.pointsspent>0 THEN a.amount ELSE 0 END)`Point Redemption Sales`,
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN a.uniquebillno END)`Point Redemption Bills`
FROM dummy.CY_txn_data a 
-- LEFT JOIN txn_report_flat_accrual b ON a.mobile=b.mobile 
LEFT JOIN  dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.storecode=c.storecode 
WHERE a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND a.storecode <> 'demo'
GROUP BY 1
UNION
-- cy YTM
SELECT
CASE WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE'%coco%' THEN 'Overall_CY_YTM_COCO'
WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE '%FoFo%' THEN 'Overall_CY_YTM_FOFO'
WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND a.storecode = 'ecom' THEN 'Overall_CY_YTM_Online'
WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'Overall_CY_YTM_Overall' 
END 'Rewards',
SUM(a.pointscollected)`Total Transaction Points Issued`,
-- SUM(b.pointscollected)`Total Bonus Points Issued`,
SUM(a.pointsspent)`Total Points Redeemed`,
COUNT(DISTINCT a.mobile)`Total Customers`,
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN a.mobile END )`Point Redeemers`,
SUM(a.pointsspent) AS `Value of Points Redeemed`,
SUM( CASE WHEN a.pointsspent>0 THEN a.amount ELSE 0 END)`Point Redemption Sales`,
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN a.uniquebillno END)`Point Redemption Bills`
FROM dummy.CY_txn_data a 
-- LEFT JOIN txn_report_flat_accrual b ON a.mobile=b.mobile 
LEFT JOIN  dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.storecode=c.storecode 
WHERE a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND a.storecode <> 'demo'
GROUP BY 1
UNION
SELECT CASE
WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'Overall_CY_YTM_Overall' END 'Rewards',
SUM(a.pointscollected)`Total Transaction Points Issued`,
-- SUM(b.pointscollected)`Total Bonus Points Issued`,
SUM(a.pointsspent)`Total Points Redeemed`,
COUNT(DISTINCT a.mobile)`Total Customers`,
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN a.mobile END )`Point Redeemers`,
SUM(a.pointsspent) AS `Value of Points Redeemed`,
SUM( CASE WHEN a.pointsspent>0 THEN a.amount ELSE 0 END)`Point Redemption Sales`,
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN a.uniquebillno END)`Point Redemption Bills`
FROM dummy.CY_txn_data a 
-- LEFT JOIN txn_report_flat_accrual b ON a.mobile=b.mobile 
LEFT JOIN  dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.storecode=c.storecode 
WHERE a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND a.storecode <> 'demo'
GROUP BY 1
UNION
-- for mvc cy month 
SELECT
CASE WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE'%coco%' THEN 'MVC_CY_Month_COCO'
WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE '%FoFo%' THEN 'MVC_CY_Month_FOFO'
WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND a.storecode = 'ecom' THEN 'MVC_CY_Month_Online'
WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'MVC_CY_Month_rest' END 'Rewards',
SUM(a.pointscollected)`Total Transaction Points Issued`,
-- ,SUM(b.pointscollected)`Total Bonus Points Issued`,
SUM(a.pointsspent)`Total Points Redeemed`,
COUNT(DISTINCT a.mobile)`Total Customers`,
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN a.mobile END )`Point Redeemers`,
SUM(a.pointsspent) AS `Value of Points Redeemed`,
SUM( CASE WHEN a.pointsspent>0 THEN a.amount ELSE 0 END)`Point Redemption Sales`,
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN a.uniquebillno END)`Point Redemption Bills`
FROM dummy.CY_txn_data a 
-- LEFT JOIN txn_report_flat_accrual b ON a.mobile=b.mobile 
LEFT JOIN  dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.storecode=c.storecode 
LEFT JOIN member_report d ON a.mobile=d.mobile
WHERE a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND d.tier LIKE '%MVC%' AND a.storecode <> 'demo'
GROUP BY 1
UNION
SELECT CASE
WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'MVC_CY_Month_Overall' END 'Rewards',
SUM(a.pointscollected)`Total Transaction Points Issued`,
-- ,SUM(b.pointscollected)`Total Bonus Points Issued`,
SUM(a.pointsspent)`Total Points Redeemed`,
COUNT(DISTINCT a.mobile)`Total Customers`,
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN a.mobile END )`Point Redeemers`,
SUM(a.pointsspent) AS `Value of Points Redeemed`,
SUM( CASE WHEN a.pointsspent>0 THEN a.amount ELSE 0 END)`Point Redemption Sales`,
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN a.uniquebillno END)`Point Redemption Bills`
FROM dummy.CY_txn_data a 
-- LEFT JOIN txn_report_flat_accrual b ON a.mobile=b.mobile 
LEFT JOIN  dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.storecode=c.storecode 
LEFT JOIN member_report d ON a.mobile=d.mobile
WHERE a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND d.tier LIKE '%MVC%' AND a.storecode <> 'demo'
GROUP BY 1
UNION
-- for mvc cy YTM
SELECT
CASE WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE'%coco%' THEN 'MVC_CY_YTM_COCO'
WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE '%FoFo%' THEN 'MVC_CY_YTM_FOFO'
WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND a.storecode = 'ecom' THEN 'MVC_CY_YTM_Online'
WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'MVC_CY_YTM_rest' END 'Rewards',
SUM(a.pointscollected)`Total Transaction Points Issued`,
-- SUM(b.pointscollected)`Total Bonus Points Issued`,
SUM(a.pointsspent)`Total Points Redeemed`,
COUNT(DISTINCT a.mobile)`Total Customers`,
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN a.mobile END )`Point Redeemers`,
SUM(a.pointsspent) AS `Value of Points Redeemed`,
SUM( CASE WHEN a.pointsspent>0 THEN a.amount ELSE 0 END)`Point Redemption Sales`,
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN a.uniquebillno END)`Point Redemption Bills`
FROM dummy.CY_txn_data a 
-- LEFT JOIN txn_report_flat_accrual b ON a.mobile=b.mobile 
LEFT JOIN  dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.storecode=c.storecode 
LEFT JOIN member_report d ON a.mobile=d.mobile
WHERE a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND d.tier LIKE '%MVC%' AND a.storecode <> 'demo'
GROUP BY 1
UNION
SELECT CASE 
WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'MVC_CY_YTM_Overall' END 'Rewards',
SUM(a.pointscollected)`Total Transaction Points Issued`,
-- SUM(b.pointscollected)`Total Bonus Points Issued`,
SUM(a.pointsspent)`Total Points Redeemed`,
COUNT(DISTINCT a.mobile)`Total Customers`,
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN a.mobile END )`Point Redeemers`,
SUM(a.pointsspent) AS `Value of Points Redeemed`,
SUM( CASE WHEN a.pointsspent>0 THEN a.amount ELSE 0 END)`Point Redemption Sales`,
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN a.uniquebillno END)`Point Redemption Bills`
FROM dummy.CY_txn_data a 
-- LEFT JOIN txn_report_flat_accrual b ON a.mobile=b.mobile 
LEFT JOIN  dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.storecode=c.storecode 
LEFT JOIN member_report d ON a.mobile=d.mobile
WHERE a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND d.tier LIKE '%MVC%' AND a.storecode <> 'demo'
GROUP BY 1),
bonus_points AS (
SELECT
CASE WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE'%coco%' THEN 'Overall_CY_Month_COCO'
WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE '%FoFo%' THEN 'Overall_CY_Month_FOFO'
WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND a.storecode = 'ecom' THEN 'Overall_CY_Month_Online'
WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'Overall_CY_Month_rest'
END 'Rewards',
SUM(pointscollected)`Total Bonus Points Issued`
FROM  txn_report_flat_accrual a
LEFT JOIN  dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.storecode=c.storecode 
WHERE a.txndate BETWEEN '2025-04-01' AND '2025-04-30'
GROUP BY 1
UNION
SELECT CASE 
WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'Overall_CY_Month_Overall'
END 'Rewards',
SUM(pointscollected)`Total Bonus Points Issued`
FROM  txn_report_flat_accrual a
LEFT JOIN  dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.storecode=c.storecode 
WHERE a.txndate BETWEEN '2025-04-01' AND '2025-04-30'
GROUP BY 1
UNION
-- cy YTM
SELECT
CASE WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE'%coco%' THEN 'Overall_CY_YTM_COCO'
WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE '%FoFo%' THEN 'Overall_CY_YTM_FOFO'
WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND a.storecode = 'ecom' THEN 'Overall_CY_YTM_Online'
WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'Overall_CY_YTM_Overall' 
END 'Rewards',
SUM(pointscollected)`Total Bonus Points Issued`
FROM  txn_report_flat_accrual a
LEFT JOIN  dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.storecode=c.storecode 
WHERE a.txndate BETWEEN '2025-04-01' AND '2025-04-30'
GROUP BY 1
UNION
SELECT CASE
WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'Overall_CY_YTM_Overall' END 'Rewards',
SUM(pointscollected)`Total Bonus Points Issued`
FROM  txn_report_flat_accrual a
LEFT JOIN  dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.storecode=c.storecode 
WHERE a.txndate BETWEEN '2025-04-01' AND '2025-04-30'
GROUP BY 1
UNION
-- for mvc cy month 
SELECT
CASE WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE'%coco%' THEN 'MVC_CY_Month_COCO'
WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE '%FoFo%' THEN 'MVC_CY_Month_FOFO'
WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND a.storecode = 'ecom' THEN 'MVC_CY_Month_Online'
WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'MVC_CY_Month_rest' END 'Rewards',
SUM(pointscollected)`Total Bonus Points Issued`
FROM  txn_report_flat_accrual a
LEFT JOIN  dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.storecode=c.storecode 
LEFT JOIN member_report d ON a.mobile=d.mobile
WHERE a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND d.tier LIKE '%MVC%'
GROUP BY 1
UNION
SELECT CASE
WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'MVC_CY_Month_Overall' END 'Rewards',
SUM(pointscollected)`Total Bonus Points Issued`
FROM  txn_report_flat_accrual a
LEFT JOIN member_report d ON a.mobile=d.mobile
LEFT JOIN  dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.storecode=c.storecode 
WHERE a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND d.tier LIKE '%MVC%'
GROUP BY 1
UNION
-- for mvc cy YTM
SELECT
CASE WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE'%coco%' THEN 'MVC_CY_YTM_COCO'
WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE '%FoFo%' THEN 'MVC_CY_YTM_FOFO'
WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND a.storecode = 'ecom' THEN 'MVC_CY_YTM_Online'
WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'MVC_CY_YTM_rest' END 'Rewards',
SUM(pointscollected)`Total Bonus Points Issued`
FROM  txn_report_flat_accrual a 
LEFT JOIN member_report d ON a.mobile=d.mobile
LEFT JOIN  dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.storecode=c.storecode 
WHERE a.txndate BETWEEN '2025-04-01' AND '2025-04-30' AND d.tier LIKE '%MVC%'
GROUP BY 1
UNION
SELECT CASE 
WHEN a.txndate BETWEEN '2025-04-01' AND '2025-04-30' THEN 'MVC_CY_YTM_Overall' END 'Rewards',
SUM(pointscollected)`Total Bonus Points Issued`
FROM  txn_report_flat_accrual a 
LEFT JOIN member_report d ON a.mobile=d.mobile
LEFT JOIN  dummy.Updated_BlackBerrys_Tagging_Store_master c ON a.storecode=c.storecode 
WHERE a.txndate BETWEEN '2025-04-01' AND '2025-04-30'
AND d.tier LIKE '%MVC%'
GROUP BY 1
)

SELECT a.Rewards,`Total Transaction Points Issued`,`Total Bonus Points Issued`,`Total Points Redeemed`,
`Total Customers`,`Value of Points Redeemed`,`Point Redemption Sales`,`Point Redemption Bills`
FROM points_data a JOIN bonus_points b USING(Rewards)