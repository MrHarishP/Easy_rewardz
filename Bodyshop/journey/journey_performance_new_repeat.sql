
SELECT COUNT(DISTINCT clientid),COUNT(DISTINCT CASE WHEN a.frequencycount=1 THEN clientid END)NEW,
COUNT(DISTINCT CASE WHEN b.frequencycount>1 THEN clientid END)new_to_repeat,
SUM(a.amount)sales,COUNT(DISTINCT a.uniquebillno)bills
FROM txn_report_accrual_redemption a JOIN txn_report_accrual_redemption b USING(clientid)
WHERE a.txndate BETWEEN '2025-04-26' AND '2025-05-26'
;


WITH NEW AS (
SELECT 
CASE 
WHEN txndate BETWEEN '2025-04-26' AND '2025-05-26' THEN '26-apr-25 to 26-may-25'
WHEN txndate BETWEEN '2025-06-26' AND '2025-07-26' THEN ' 26-jun-25 to 26-jul-25' END 'period',
clientid
FROM txn_report_accrual_redemption 
WHERE ((txndate BETWEEN '2025-04-26' AND '2025-05-26') OR 
(txndate BETWEEN '2025-06-26' AND '2025-07-26'))
AND frequencycount=1
GROUP BY 1,2
)
SELECT PERIOD,
COUNT(DISTINCT CASE WHEN PERIOD='26-apr-25 to 26-may-25' AND frequencycount>1 THEN clientid END )customers ,
COUNT(DISTINCT CASE WHEN PERIOD=' 26-jun-25 to 26-jul-25' AND frequencycount>1 THEN clientid END )customers 
FROM NEW a JOIN txn_report_accrual_redemption b USING(clientid)
WHERE ((txndate BETWEEN '2025-04-26' AND '2025-05-26') OR 
(txndate BETWEEN '2025-06-26' AND '2025-07-26'))
AND frequencycount>1
GROUP BY 1;



##########################################use this #############################3


SET @startdate='2025-05-26';

SELECT @startdate,DATE_SUB(@startdate, INTERVAL 82 DAY);'2025-03-05'

SELECT 
COUNT(DISTINCT clientid)customers
FROM txn_report_accrual_redemption 
WHERE (txndate BETWEEN '2025-06-26' AND '2025-09-16')


WITH NEW AS (
SELECT 
DISTINCT clientid
FROM txn_report_accrual_redemption 
WHERE (txndate BETWEEN '2025-03-05' AND '2025-05-26') 
AND frequencycount=1
)
SELECT  COUNT(DISTINCT clientid)customers 
FROM NEW a JOIN txn_report_accrual_redemption b USING(clientid)
WHERE (txndate BETWEEN '2025-03-05' AND '2025-05-26')
AND frequencycount>1;



WITH NEW AS (
SELECT 
DISTINCT clientid
FROM txn_report_accrual_redemption 
WHERE (txndate BETWEEN '2025-06-26' AND '2025-07-26') 
AND frequencycount=1
)
SELECT  COUNT(DISTINCT clientid)customers 
FROM NEW a JOIN txn_report_accrual_redemption b USING(clientid)
WHERE (txndate BETWEEN '2025-06-26' AND '2025-07-26')
AND frequencycount>1;



SELECT COUNT(DISTINCT mobile) FROM program_single_view;#1398222

SELECT COUNT(DISTINCT mobile) FROM member_report;#1398236

SELECT COUNT(DISTINCT mobile) FROM txn_report_accrual_redemption;#318964

SHOW PROCESSLIST;

SELECT 3746/60
