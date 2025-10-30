-- slide 17 overall 
-- without bonus points
WITH classified AS (
  SELECT
    a.mobile,
    a.pointscollected,
--     b.pointscollected as points_bonus,
    a.pointsspent,
    a.amount,
    a.uniquebillno,
    -- CASE 
--       WHEN c.storetype LIKE '%COCO%' 
--         THEN 'Overall_CY_Month_COCO'
--       WHEN c.storetype LIKE '%FOFO%' 
--         THEN 'Overall_CY_Month_FOFO'
--       WHEN UPPER(a.storecode) = 'ECOM' 
--         THEN 'Overall_CY_Month_Online'
--       ELSE 
        'MVC_CY_Month_ALL'
--     END
     AS Rewards
  FROM
    dummy.CY_txn_data AS a
    LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master AS c
      ON a.storecode = c.storecode
--       left JOIN txn_report_flat_accrual b 
--       ON a.mobile = b.mobile
    JOIN member_report m ON m.mobile = a.mobile AND m.tier = 'MVC'  
  WHERE
    a.txndate    BETWEEN '2025-04-01' AND '2025-04-30'
    AND a.storecode <> 'demo'
)
 
SELECT
  Rewards,
  SUM(pointscollected)                                  AS `Total Transaction Points Issued`,
--   SUM(points_bonus)                                  	AS `Total Bonus Points Issued`,
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
  'MVC_CY_Month_All'            AS Rewards,
  SUM(pointscollected),
--   SUM(points_bonus),
  SUM(pointsspent),
  COUNT(DISTINCT mobile),
  COUNT(DISTINCT CASE WHEN pointsspent > 0 THEN mobile END),
  SUM(pointsspent),
  SUM(CASE WHEN pointsspent > 0 THEN amount ELSE 0 END),
  COUNT(DISTINCT CASE WHEN pointsspent > 0 THEN uniquebillno END)
FROM classified
 
ORDER BY 
  CASE WHEN Rewards = 'MVC_CY_Month_All' THEN 2 ELSE 1 END,
  Rewards;
  
  
--   with bonus points
  


WITH classified AS (
  SELECT
    a.mobile,

    a.pointscollected AS points_bonus,
    
    -- CASE 
--       WHEN c.storetype LIKE '%COCO%' 
--         THEN 'Overall_CY_Month_COCO'
--       WHEN c.storetype LIKE '%FOFO%' 
--         THEN 'Overall_CY_Month_FOFO'
--       WHEN UPPER(a.storecode) = 'ECOM' 
--         THEN 'Overall_CY_Month_Online'
--       ELSE 
        'MVC_CY_Month_ALL'
--     END
     AS Rewards
  FROM
     txn_report_flat_accrual AS a
    LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master AS c
      ON a.storecode = c.storecode
--       left JOIN txn_report_flat_accrual b 
--       ON a.mobile = b.mobile
    JOIN member_report m ON m.mobile = a.mobile AND m.tier = 'MVC'  
  WHERE
    a.txndate    BETWEEN '2025-04-01' AND '2025-04-30'
    AND a.storecode <> 'demo'
)
 
SELECT
  Rewards,

  SUM(points_bonus)                                  	AS `Total Bonus Points Issued`
                                                       
FROM classified
GROUP BY Rewards
 
UNION ALL
 
SELECT
  'MVC_CY_Month_All'            AS Rewards,
  
  SUM(points_bonus)
  
FROM classified
 
ORDER BY 
  CASE WHEN Rewards = 'MVC_CY_Month_All' THEN 2 ELSE 1 END,
  Rewards;
  











  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
--   without bonus points
  WITH classified AS (
  SELECT
    a.mobile,
    a.pointscollected,
--     b.pointscollected as bonus_points,
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
    END
     AS Rewards
  FROM
    dummy.CY_txn_data AS a
    LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master AS c
      ON a.storecode = c.storecode
       -- left JOIN txn_report_flat_accrual b 
--       ON a.mobile = b.mobile
--     JOIN member_report m ON m.mobile = a.mobile AND m.tier = 'MVC'  
  WHERE
    a.txndate    BETWEEN '2025-04-01' AND '2025-04-30'
    AND a.storecode <> 'demo'
)
 
SELECT
  Rewards,
  SUM(pointscollected)                                  AS `Total Transaction Points Issued`,
--   SUM(bonus_points)                                  	AS `Total Bonus Points Issued`,
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
--   SUM(bonus_points),
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
  
  
  
  
WITH classified AS (
  SELECT
    a.mobile,
    b.pointscollected AS bonus_points,
    CASE 
      WHEN c.storetype LIKE '%COCO%' 
        THEN 'Overall_CY_Month_COCO'
      WHEN c.storetype LIKE '%FOFO%' 
        THEN 'Overall_CY_Month_FOFO'
      WHEN UPPER(a.storecode) = 'ECOM' 
        THEN 'Overall_CY_Month_Online'
      ELSE 
        'Overall_CY_Month_rest'
    END
     AS Rewards
  FROM
    dummy.CY_txn_data AS a
    LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master AS c
      ON a.storecode = c.storecode
       -- left JOIN txn_report_flat_accrual b 
--       ON a.mobile = b.mobile
--     JOIN member_report m ON m.mobile = a.mobile AND m.tier = 'MVC'  
  WHERE
    a.txndate    BETWEEN '2025-04-01' AND '2025-04-30'
    AND a.storecode <> 'demo'
)
 
SELECT
  Rewards,
  SUM(pointscollected)                                  AS `Total Transaction Points Issued`,
--   SUM(bonus_points)                                  	AS `Total Bonus Points Issued`,
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
--   SUM(bonus_points),
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
    
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  SELECT SUM(pointsspent) FROM dummy.CY_txn_data
  WHERE
    txndate    BETWEEN '2025-04-01' AND '2025-04-30';#7057561.00
    
    
    
    
      SELECT SUM(pointsspent) FROM txn_report_accrual_redemption
  WHERE
    txndate    BETWEEN '2025-04-01' AND '2025-04-30' AND storecode<> 'demo' ;#7210022.00
    
    
    SELECT * FROM txn_report_flat_accrual;
    
    
    
    
    
    
    
    
    
    
--     slide 18 without bnous points
      WITH classified AS (
  SELECT
    a.mobile,
    a.pointscollected,
--     b.pointscollected AS bonus_points,
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
    END
     AS Rewards
  FROM
    dummy.CY_txn_data AS a
    LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master AS c
      ON a.storecode = c.storecode
--        LEFT JOIN txn_report_flat_accrual b 
--       ON a.mobile = b.mobile
    JOIN member_report m ON m.mobile = a.mobile AND m.tier = 'MVC'  
  WHERE
    a.txndate    BETWEEN '2025-04-01' AND '2025-04-30'
--     AND a.storecode <> 'demo'
)
 
SELECT
  Rewards,
  SUM(pointscollected)                                  AS `Total Transaction Points Issued`,
--   SUM(bonus_points)                                  	AS `Total Bonus Points Issued`,
  SUM(pointsspent)                                      AS `Total Points Redeemed`,
  COUNT(DISTINCT mobile)                                AS `Total Customers`,
  COUNT(DISTINCT CASE WHEN pointsspent > 0 THEN mobile END)
                                                        AS `Point Redeemers`,
  SUM(pointsspent)                                      AS `Value of Points Redeemed`,
  SUM(CASE WHEN pointsspent > 0 THEN amount ELSE 0 END) AS `Point Redemption Sales`,
  COUNT(DISTINCT CASE WHEN pointsspent > 0 THEN uniquebillno END)
-- --                                                         AS `Point Redemption Bills`
FROM classified
GROUP BY Rewards
 
UNION ALL
 
SELECT
  'Overall_CY_Month_All'            AS Rewards,
  SUM(pointscollected),
--   SUM(bonus_points),
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
  
  
  
  
  
      
      WITH classified AS (
  SELECT
    a.mobile,

    a.pointscollected AS bonus_points,
    CASE 
      WHEN c.storetype LIKE '%COCO%' 
        THEN 'Overall_CY_Month_COCO'
      WHEN c.storetype LIKE '%FOFO%' 
        THEN 'Overall_CY_Month_FOFO'
      WHEN UPPER(a.storecode) = 'ECOM' 
        THEN 'Overall_CY_Month_Online'
      ELSE 
        'Overall_CY_Month_rest'
    END
     AS Rewards
  FROM
    txn_report_flat_accrual AS a
    LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master AS c
      ON a.storecode = c.storecode
       -- EFT JOIN txn_report_flat_accrual b 
--       ON a.mobile = b.mobile
    JOIN member_report m ON m.mobile = a.mobile AND m.tier = 'MVC'  
  WHERE
    a.txndate    BETWEEN '2025-04-01' AND '2025-04-30'
    AND a.storecode <> 'demo'
)
 
SELECT
  Rewards,
  SUM(bonus_points)                                  	AS `Total Bonus Points Issued`
FROM classified
GROUP BY Rewards
 
UNION ALL
 
SELECT
  'Overall_CY_Month_All'            AS Rewards,
  SUM(bonus_points) AS `Total Bonus Points Issued`
FROM classified
 
ORDER BY 
  CASE WHEN Rewards = 'Overall_CY_Month_All' THEN 2 ELSE 1 END,
  Rewards;
  
  
  
  
   SELECT SUM(pointscollected) FROM txn_report_flat_accrual a LEFT JOIN member_report b USING(mobile) 
  WHERE txndate BETWEEN '2025-04-01' AND '2025-04-30' AND b.tier='MVC'
    AND storecode <> 'demo';#14837.00
  
  
  SELECT SUM(pointscollected) FROM txn_report_flat_accrual a
  LEFT JOIN dummy.Updated_BlackBerrys_Tagging_Store_master AS c
      ON a.storecode = c.storecode
  WHERE txndate BETWEEN '2025-04-01' AND '2025-04-30' AND storetype LIKE '%FOFO%'
    AND a.storecode <> 'demo';#16512.00