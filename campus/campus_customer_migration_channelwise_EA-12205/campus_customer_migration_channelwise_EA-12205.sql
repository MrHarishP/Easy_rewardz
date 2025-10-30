
WITH base_period AS (
SELECT 
mobile,
MAX(CASE WHEN storecode = 'ecom' THEN 1 ELSE 0 END) AS online_flag,
MAX(CASE WHEN storecode <> 'ecom' THEN 1 ELSE 0 END) AS offline_flag
FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2025-04-01' AND '2025-07-31'
AND storecode NOT LIKE '%demo%'
AND billno NOT LIKE '%test%'
AND billno NOT LIKE '%roll%'
AND storecode NOT IN ('Corporate')
AND amount > 0
GROUP BY 1
)
-- select count(distinct mobile)customer from base_period
SELECT
    CASE 
        WHEN online_flag = 1 AND offline_flag = 0 THEN 'Online Only'
        WHEN online_flag = 0 AND offline_flag = 1 THEN 'Offline Only'
        WHEN online_flag = 1 AND offline_flag = 1 THEN 'Omni'
        ELSE 'No Activity'
    END AS customer_type,
COUNT(DISTINCT mobile)customer 
FROM base_period
GROUP BY 1;



SELECT * FROM dummy.customer_base_fy_24_25;





################################################################################

WITH base_period AS (
    SELECT 
        mobile,
        MAX(CASE WHEN storecode = 'ecom' THEN 1 ELSE 0 END) AS online_flag,
        MAX(CASE WHEN storecode <> 'ecom' THEN 1 ELSE 0 END) AS offline_flag
    FROM txn_report_accrual_redemption
    WHERE txndate BETWEEN '2024-04-01' AND '2025-03-31'
      AND storecode NOT LIKE '%demo%'
      AND billno NOT LIKE '%test%'
      AND billno NOT LIKE '%roll%'
      AND storecode NOT IN ('Corporate')
      AND amount > 0
    GROUP BY 1
),
next_period AS (
    SELECT 
        mobile,
        MAX(CASE WHEN storecode = 'ecom' THEN 1 ELSE 0 END) AS online_flag,
        MAX(CASE WHEN storecode <> 'ecom' THEN 1 ELSE 0 END) AS offline_flag
    FROM txn_report_accrual_redemption
    WHERE txndate BETWEEN '2025-04-01' AND '2025-07-31'
      AND storecode NOT LIKE '%demo%'
      AND billno NOT LIKE '%test%'
      AND billno NOT LIKE '%roll%'
      AND storecode NOT IN ('Corporate')
      AND amount > 0
    GROUP BY 1
),
base_segment AS (
    SELECT
        mobile,
        CASE 
            WHEN online_flag = 1 AND offline_flag = 0 THEN 'Online Only'
            WHEN online_flag = 0 AND offline_flag = 1 THEN 'Offline Only'
            WHEN online_flag = 1 AND offline_flag = 1 THEN 'Omni'
            ELSE 'No Activity' 
        END AS base_channel
    FROM base_period
)
SELECT
    base_channel,
    COUNT(DISTINCT b.mobile) AS base_customers,
    SUM(CASE WHEN base_channel = 'Offline Only' AND n.online_flag = 1 AND n.offline_flag = 0 THEN 1 ELSE 0 END) AS offline_to_online,
    SUM(CASE WHEN base_channel = 'Online Only' AND n.online_flag = 0 AND n.offline_flag = 1 THEN 1 ELSE 0 END) AS online_to_offline,
    SUM(CASE WHEN base_channel = 'Omni' AND n.online_flag = 1 AND n.offline_flag = 1 THEN 1 ELSE 0 END) AS omni_to_omni
FROM base_segment b
LEFT JOIN next_period n ON b.mobile = n.mobile
GROUP BY 1;

################################################################################################

-- From the above base - customers who transacted only offline till Mar'25, but transacted online b/w Apr'25 - July'25
-- From the above base - customers who transacted only online till Mar'25, but transacted offline b/w Apr'25 - July'25 
-- From the above base - customers who transacted omni till Mar'25, and transacted omni again b/w Apr'25 - July'25


    SELECT 
        COUNT(DISTINCT mobile)
    FROM txn_report_accrual_redemption
    WHERE txndate BETWEEN '2025-04-01' AND '2025-07-31'
      AND storecode NOT LIKE '%demo%'
      AND billno NOT LIKE '%test%'
      AND billno NOT LIKE '%roll%'
      AND storecode NOT IN ('Corporate')
--       and storecode <> 'ecom'
      AND amount > 0
      AND mobile IN (SELECT mobile FROM dummy.customer_base_fy_24_25 WHERE customer_type= 'omni')
    GROUP BY 1
    
    #############
  --   select mobile,GROUP_CONCAT(DISTINCT storecode)Online from txn_report_accrual_redemption
--    WHERE txndate BETWEEN '2025-04-01' AND '2025-07-31'
--       AND storecode NOT LIKE '%demo%'
--       AND billno NOT LIKE '%test%'
--       AND billno NOT LIKE '%roll%'
--       AND storecode NOT IN ('Corporate') and mobile in(select distinct mobile from (
--     select mobile,group_concat(distinct storecode)Online from txn_report_accrual_redemption
--    where txndate BETWEEN '2024-04-01' AND '2025-03-31'
--       AND storecode NOT LIKE '%demo%'
--       AND billno NOT LIKE '%test%'
--       AND billno NOT LIKE '%roll%'
--       AND storecode NOT IN ('Corporate')
--       group by 1 having Online='Ecom')a)
--       group by 1 having Online<>'Ecom'
--       
--       
--       
--       SELECT mobile,GROUP_CONCAT(DISTINCT storecode)Online FROM txn_report_accrual_redemption
--    WHERE txndate BETWEEN '2025-04-01' AND '2025-07-31'
--       AND storecode NOT LIKE '%demo%'
--       AND billno NOT LIKE '%test%'
--      AND amount > 0
--       AND billno NOT LIKE '%roll%'
--       AND storecode NOT IN ('Corporate') AND mobile IN(SELECT DISTINCT mobile FROM (
--     SELECT mobile,GROUP_CONCAT(DISTINCT storecode)Online FROM txn_report_accrual_redemption
--    WHERE txndate BETWEEN '2024-04-01' AND '2025-03-31'
--       AND storecode NOT LIKE '%demo%'
--       AND billno NOT LIKE '%test%'
--       AND billno NOT LIKE '%roll%'
--       AND storecode NOT IN ('Corporate') AND amount > 0
--       GROUP BY 1 HAVING Online='Ecom')a)
--       GROUP BY 1 HAVING Online='Ecom'
      
############################################################################################


WITH dormant_customers AS (
    SELECT 
        mobile
    FROM (
        SELECT 
            mobile,
            DATEDIFF('2025-03-31', MAX(txndate)) AS recency
        FROM campuscrm.txn_report_accrual_redemption
        WHERE txndate <= '2025-03-31'
          AND storecode NOT LIKE '%demo%'
          AND billno NOT LIKE '%test%'
          AND billno NOT LIKE '%roll%'
          AND storecode NOT IN ('Corporate')
          AND amount > 0
        GROUP BY 1
    ) t
    WHERE recency BETWEEN 366 AND 730
)
,
shopped_next_period AS (
    SELECT DISTINCT 
        mobile,
        storetype1
    FROM txn_report_accrual_redemption 
    JOIN store_master  USING(storecode)
    WHERE txndate BETWEEN '2025-04-01' AND '2025-07-31'
      AND storecode NOT LIKE '%demo%'
      AND billno NOT LIKE '%test%'
      AND billno NOT LIKE '%roll%'
      AND storecode NOT IN ('Corporate')
      AND amount > 0
      AND mobile IN (SELECT mobile FROM dormant_customers)
)
SELECT COUNT(DISTINCT a.mobile)Dormant_base,
b.storetype1,COUNT(DISTINCT b.mobile) 
FROM dormant_customers a LEFT JOIN shopped_next_period b USING(mobile)
GROUP BY 2;

    
    #########################################################################################
    
    
    WITH dormant_customers AS (

        SELECT 
            mobile,
            DATEDIFF('2025-03-31', MAX(txndate)) AS recency
        FROM campuscrm.txn_report_accrual_redemption
        WHERE txndate <= '2025-03-31'
          AND storecode NOT LIKE '%demo%'
          AND billno NOT LIKE '%test%'
          AND billno NOT LIKE '%roll%'
          AND storecode NOT IN ('Corporate')
          AND amount > 0
        GROUP BY 1 
--         having recency BETWEEN 366 AND 730
   
)
SELECT 
CASE 
      WHEN recency <= 365 THEN 'active'
      WHEN recency BETWEEN 366 AND 730 THEN 'dormant'
      WHEN recency > 730 THEN 'lapsed'
END AS lifecycle_3_25,
COUNT(DISTINCT mobile)customer FROM dormant_customers
GROUP BY 1;
customer_base AS (
SELECT 
mobile,
DATEDIFF('2025-03-31', MAX(txndate)) AS recency
FROM campuscrm.txn_report_accrual_redemption
WHERE txndate <= '2025-07-31'
AND storecode NOT LIKE '%demo%'
AND billno NOT LIKE '%test%'
AND billno NOT LIKE '%roll%'
AND storecode NOT IN ('Corporate')
AND amount > 0 AND mobile IN (SELECT DISTINCT mobile FROM dormant_customers)
GROUP BY 1)

SELECT 
CASE 
      WHEN recency <= 365 THEN 'active'
      WHEN recency BETWEEN 366 AND 730 THEN 'dormant'
      WHEN recency > 730 THEN 'lapsed'
END AS lifecycle_3_25,
COUNT(DISTINCT mobile)customer FROM customer_base
GROUP BY 1;


SHOW PROCESSLIST
SELECT 1039/60
#######################3

-- lasped base txn in next period


WITH lapsed_customers AS (
    SELECT 
        mobile
    FROM (
        SELECT 
            mobile,
            DATEDIFF('2025-03-31', MAX(txndate)) AS recency
        FROM campuscrm.txn_report_accrual_redemption
        WHERE txndate <= '2025-03-31'
          AND storecode NOT LIKE '%demo%'
          AND billno NOT LIKE '%test%'
          AND billno NOT LIKE '%roll%'
          AND storecode NOT IN ('Corporate')
          AND amount > 0
        GROUP BY 1
    ) t
    WHERE recency > 730
)
,
shopped_next_period AS (
    SELECT DISTINCT 
        mobile,
        storetype1
    FROM txn_report_accrual_redemption 
    JOIN store_master  USING(storecode)
    WHERE txndate BETWEEN '2025-04-01' AND '2025-07-31'
      AND storecode NOT LIKE '%demo%'
      AND billno NOT LIKE '%test%'
      AND billno NOT LIKE '%roll%'
      AND storecode NOT IN ('Corporate')
      AND amount > 0
      AND mobile IN (SELECT mobile FROM lapsed_customers)
)
SELECT 
b.storetype1,COUNT(DISTINCT b.mobile) 
FROM lapsed_customers a LEFT JOIN shopped_next_period b USING(mobile)
GROUP BY 1;

-- lapsed storetype 

SELECT 
        storetype1,COUNT(DISTINCT mobile)mobile
    FROM (
        SELECT 
            mobile,storecode,
            DATEDIFF('2025-03-31', MAX(txndate)) AS recency
        FROM campuscrm.txn_report_accrual_redemption
        WHERE txndate <= '2025-03-31'
          AND storecode NOT LIKE '%demo%'
          AND billno NOT LIKE '%test%'
          AND billno NOT LIKE '%roll%'
          AND storecode NOT IN ('Corporate')
          AND amount > 0
        GROUP BY 1
    ) a JOIN store_master b USING(storecode)
    WHERE recency > 730
    GROUP BY 1