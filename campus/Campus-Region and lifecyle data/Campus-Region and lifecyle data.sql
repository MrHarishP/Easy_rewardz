
WITH base AS (
SELECT mobile,region,storecode,lpaasstore,DATEDIFF('2025-05-31',MAX(txndate))recency 
FROM txn_report_accrual_redemption a JOIN store_master b USING(storecode)
WHERE txndate <= '2025-05-31'
AND storecode NOT LIKE '%demo%'
AND billno NOT LIKE '%test%'
AND billno NOT LIKE '%roll%'
AND storecode NOT IN ('Corporate','demo')
AND storetype1 = 'Not Identified'
AND mobile IN (SELECT DISTINCT mobile FROM member_report WHERE smsreachability='true')
AND amount>0 

GROUP BY 1,2)

SELECT region,
CASE 
      WHEN recency <= 365 THEN 'active'
      WHEN recency BETWEEN 366 AND 730 THEN 'dormant'
      WHEN recency > 730 THEN 'lapsed'
END AS recency,
storecode,lpaasstore,
COUNT(DISTINCT mobile)customer FROM base 
GROUP BY 1,2;

SELECT storetype1,lpaasstore,region,storecode FROM store_master ;

SELECT DISTINCT rfm_segment FROM fact_customer_rfm
