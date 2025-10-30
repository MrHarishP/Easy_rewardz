-- ask 1
SELECT COUNT(*) FROM 
(SELECT mobile,MAX(txndate)max_txn FROM txn_report_accrual_redemption 
GROUP BY 1)a
WHERE max_txn BETWEEN '2022-05-01' AND '2023-04-30';

-- ask 1 re
CREATE TABLE dummy.harish_re_active_apr23
WITH cte AS (SELECT * FROM 
(SELECT mobile,MAX(txndate)max_txn FROM txn_report_accrual_redemption 
GROUP BY 1)a
WHERE max_txn BETWEEN '2022-05-01' AND '2023-04-30'
),
sale AS (
SELECT mobile,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2022-05-01' AND '2023-04-30'
GROUP BY 1)
SELECT a.mobile,SUM(sales)sales,SUM(bills)bills FROM cte a JOIN sale b USING(mobile)
GROUP BY 1;#406554


-- ask2
CREATE TABLE dummy.harish_re_active_befor22
WITH base_1 AS (
  SELECT txnmappedmobile
  FROM (
    SELECT txnmappedmobile, MAX(modifiedtxndate) AS max_txn
    FROM sku_report_loyalty 
    GROUP BY txnmappedmobile
  ) a
  WHERE max_txn < '2022-04-01'
)
SELECT 
  txnmappedmobile AS mobile,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills
FROM sku_report_loyalty 
JOIN base_1 USING(txnmappedmobile)
WHERE itemnetamount > 0 
  AND itemqty >= 1
  AND (
    (itemdiscountamount / itemmrp) * 100 >= 40
    OR MONTH(modifiedtxndate) = 6
    OR MONTH(modifiedtxndate) = 7
  )
  AND modifiedstorecode <> 'demo'
  GROUP BY 1;#252075
  
  
  
  
 