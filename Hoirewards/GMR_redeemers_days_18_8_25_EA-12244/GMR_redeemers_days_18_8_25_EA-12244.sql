SELECT mobile,SUM(amount)AS spend,frequencycount,SUM(pointsspent)pointsspend,
COUNT(DISTINCT uniquebillno) AS TotalBills
FROM `hoirewards`.`txn_report_accrual_redemption`
WHERE txndate <='2025-08-17'
GROUP BY 1
HAVING pointsspend>0;


WITH base AS (
SELECT mobile,txndate,SUM(amount)AS spend,frequencycount,SUM(pointsspent)pointsspend,
COUNT(DISTINCT uniquebillno) AS TotalBills
FROM `hoirewards`.`txn_report_accrual_redemption`
WHERE txndate <='2025-08-17'
GROUP BY 1,2)
SELECT DISTINCT mobile FROM base 
WHERE 
-- pointsspend>0 AND 
totalbills>5 #10
UNION
SELECT DISTINCT mobile FROM (
SELECT DISTINCT mobile,
CONCAT(1 + DATEDIFF(txndate,'2024-12-23')) DIV 7 AS week_num,
'2024-12-23' + INTERVAL (DATEDIFF(txndate,'2024-12-23') DIV 7) WEEK AS week_start,
SUM(amount)totalspend,COUNT(DISTINCT txndate)visits,
COUNT(DISTINCT CONCAT(txndate,modifiedbillno,storecode)) AS TotalBills,
SUM(pointsspent)pointsspend
FROM txn_report_accrual_redemption 
WHERE txndate<='2025-08-17'
GROUP BY 1,2)a
WHERE  totalbills>20 
-- AND pointsspend>0
;