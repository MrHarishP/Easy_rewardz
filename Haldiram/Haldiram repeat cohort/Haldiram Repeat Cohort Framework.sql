-- another way of doing this task 
-- repeart cohort

WITH base_cusotmer AS (SELECT DISTINCT mobile,txndate FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2024-05-01' AND '2025-06-30' AND frequencycount=1
)
SELECT YEAR(a.txndate)firsttxnyear,MONTHNAME(a.txndate)firsttxnmonth,
YEAR(b.txndate)SubsequentTxnyear,MONTHNAME(b.txndate)SubsequentTxnmonth,COUNT(DISTINCT a.mobile)customer FROM base_cusotmer a
LEFT JOIN txn_report_accrual_redemption b ON a.mobile=b.mobile
WHERE b.txndate BETWEEN '2024-05-01'AND '2025-06-30' AND frequencycount>1
GROUP BY 1,2,3,4;

###########################################################################################
-- repeat cohort
SELECT a.txnmonth firsttxnmonth,b.txnmonth 'Subsequent Txn month',
COUNT(DISTINCT a.mobile) AS customer 
FROM txn_report_accrual_redemption AS a
JOIN txn_report_accrual_redemption AS b ON a.mobile=b.mobile
WHERE a.frequencyCount=1 AND b.frequencyCount>1 
AND a.txndate BETWEEN '2024-05-01'AND '2025-04-30'
GROUP BY 1,2;



###################################################################################################
-- mom new customer
SELECT txnyear,txnmonth,COUNT(DISTINCT CASE WHEN minfc=1 AND maxfc=1 THEN mobile END )'one timer',
COUNT(DISTINCT CASE WHEN minfc=1 AND maxfc>1 THEN mobile END)'new repeater',
COUNT(DISTINCT CASE WHEN minfc=1 AND maxfc=1 THEN mobile END)+COUNT(DISTINCT CASE WHEN minfc=1 AND maxfc>1 THEN mobile END) 'new customer'
FROM(
SELECT mobile,txnmonth,txnyear,MAX(frequencycount)maxfc,MIN(frequencycount)minfc FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2024-05-01' AND '2025-03-31'
GROUP BY 1)a
GROUP BY 1,2
ORDER BY 1,2;



#############################################################################
-- one timer
SELECT txnmonth,COUNT(DISTINCT mobile)cutomer,SUM(sales)sales,SUM(bills)bills FROM (
SELECT mobile,txnyear,txnmonth,MAX(frequencycount)maxfc,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2024-05-01' AND '2024-03-31'
GROUP BY 1)a
WHERE maxfc=1 
GROUP BY 1;

SELECT YEAR(dat), MONTHNAME(dat), COUNT(DISTINCT mobile) FROM 
(SELECT mobile, MIN(txndate) AS dat, MAX(frequencycount) maxf FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2024-05-01' AND '2025-03-31'
GROUP BY 1) c 
WHERE maxf = 1
GROUP BY 1,2;





