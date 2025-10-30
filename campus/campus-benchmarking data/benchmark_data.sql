SELECT 
MONTHNAME(txndate)MONTH,
COUNT(DISTINCT mobile)winback FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2025-01-01' AND '2025-08-31'
AND dayssincelastvisit>365
-- AND itemnetamount>0
AND storecode <> 'demo'
GROUP BY 1
ORDER BY txndate;

SELECT 
COUNT(DISTINCT mobile)total_customer,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN mobile END) repeater,
COUNT(DISTINCT CASE WHEN frequencycount=1 THEN mobile END) onetimer,
SUM(amount)sales
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2024-01-01' AND '2024-08-31'
-- AND dayssincelastvisit>730
-- AND itemnetamount>0
AND storecode <> 'demo'
-- GROUP BY 1,2
ORDER BY txndate;

SELECT 
YEAR(txndate)YEAR,MONTHNAME(txndate)months,
COUNT(DISTINCT mobile)total_customer,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN mobile END) repeater,
COUNT(DISTINCT CASE WHEN frequencycount=1 THEN mobile END) onetimer,
SUM(amount)sales
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2025-01-01' AND '2025-08-31'
-- AND dayssincelastvisit>730
-- AND itemnetamount>0
AND storecode <> 'demo'
GROUP BY 1,2
ORDER BY txndate;


SELECT 
YEAR(modifiedtxndate)YEAR,MONTHNAME(modifiedtxndate)months,
SUM(itemnetamount)nonloyalty_sales
FROM sku_report_nonloyalty 
WHERE modifiedtxndate BETWEEN '2025-01-01' AND '2025-08-31'
-- AND dayssincelastvisit>730
-- AND itemnetamount>0
AND modifiedstorecode <> 'demo'
GROUP BY 1,2
ORDER BY modifiedtxndate;

SELECT 
-- YEAR(modifiedtxndate)YEAR,MONTHNAME(modifiedtxndate)months,
SUM(itemnetamount)nonloyalty_sales
FROM sku_report_nonloyalty 
WHERE modifiedtxndate BETWEEN '2025-01-01' AND '2025-08-31'
-- AND dayssincelastvisit>730
-- AND itemnetamount>0
AND modifiedstorecode <> 'demo'
-- GROUP BY 1,2
ORDER BY modifiedtxndate;