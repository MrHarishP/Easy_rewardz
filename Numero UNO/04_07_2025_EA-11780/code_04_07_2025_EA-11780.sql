-- numero uno
-- Top 5 tagging stores

SELECT storecode,COUNT(DISTINCT mobile)customers,SUM(bills)bills FROM(
SELECT mobile,storecode,COUNT(DISTINCT uniquebillno)bills FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2025-06-01' AND '2025-06-30' AND amount>0 AND storecode <> 'demo'
GROUP BY 1,2)a
GROUP BY 1
ORDER BY bills DESC LIMIT 5;


SELECT storecode ,COUNT(DISTINCT uniquebillno)bills FROM 
txn_report_accrual_redemption
WHERE txndate BETWEEN '2025-06-01' AND '2025-06-30' AND amount>0 AND storecode <> 'demo'
GROUP BY 1
ORDER BY bills DESC LIMIT 5;

SELECT storecode,COUNT(DISTINCT uniquebillno)bills,COUNT(DISTINCT mobile)customer FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2025-06-01' AND '2025-06-30' AND storecode = 1419;

-- Top 5 stores with highest sales

SELECT storecode,SUM(sales)sales,COUNT(DISTINCT mobile)customers FROM (
SELECT mobile,storecode,SUM(amount)sales FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2025-06-01' AND '2025-06-30' AND amount>0 AND storecode <> 'demo'
GROUP BY 1,2)a
GROUP BY 1
ORDER BY sales DESC 
LIMIT 5;

SELECT storecode ,SUM(amount)sales FROM 
txn_report_accrual_redemption
WHERE txndate BETWEEN '2025-06-01' AND '2025-06-30' AND amount>0 AND storecode <> 'demo'
GROUP BY 1
ORDER BY sales DESC LIMIT 5;

-- Top 5 loyalty/repeat sales stores

SELECT storecode,CASE WHEN maxf>1 THEN sales END repeatsales FROM (
SELECT mobile,storecode,MIN(frequencycount)minf,MAX(frequencycount)maxf,SUM(amount)sales FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2025-06-01' AND '2025-06-30' AND amount>0 AND storecode <> 'demo'
GROUP BY 1,2)a
GROUP BY 1
ORDER BY sales DESC LIMIT 5;






INSERT INTO  dummy.mobilelevel 
SELECT mobile,MIN(frequencycount)minf,MAX(frequencycount)maxf FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2025-06-01' AND '2025-06-30' AND amount>0 AND storecode <> 'demo' 
GROUP BY 1;#23199

CREATE TABLE dummy.store_mobile
SELECT mobile,storecode,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2025-06-01' AND '2025-06-30' AND amount>0 AND storecode <> 'demo' 
GROUP BY 1,2;#23429


SELECT storecode,SUM(sales),SUM(CASE WHEN STATUS='Repeater' THEN sales END)Repeater_sales,
SUM(CASE WHEN STATUS='onetimer' THEN sales END)Onetimer_sales FROM 
((SELECT mobile,storecode,sales,bills FROM dummy.store_mobile)a JOIN 
(SELECT mobile,CASE WHEN maxf=1 THEN 'onetimer' ELSE 'Repeater' END AS STATUS FROM 
dummy.mobilelevel 
GROUP BY 1,2)b
USING(mobile))a
GROUP BY 1;


-- QC
SELECT storecode,SUM(sales),SUM(CASE WHEN STATUS='Repeater' THEN sales END)Repeater_sales,
SUM(CASE WHEN STATUS='onetimer' THEN sales END)Onetimer_sales FROM 
((SELECT mobile,storecode,sales,bills FROM dummy.store_mobile)a JOIN 
(SELECT mobile,CASE WHEN maxf=1 THEN 'onetimer' ELSE 'Repeater' END AS STATUS FROM 
dummy.mobilelevel 
GROUP BY 1,2)b
ON a.mobile=b.mobile)
GROUP BY 1;

SELECT SUM(amount)sales FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2025-06-01' AND '2025-06-30' AND amount>0 AND storecode <> 'demo'

SELECT storecode,MIN(txndate),MAX(txndate) FROM txn_report_accrual_redemption 
WHERE storecode IN ('939',
'702',
'826')
GROUP BY 1

SELECT storecode,frequencycount FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2025-06-01' AND '2025-06-30' AND amount>0 AND  storecode IN ('939',
'702',
'826')  GROUP BY 1


SELECT storecode,COUNT(*) FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2025-06-01' AND '2025-06-30' AND amount>0 AND  storecode IN ('939',
'702',
'826')  GROUP BY 1

SELECT * FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2025-06-01' AND '2025-06-30' AND amount>0 AND  storecode IN ('826')