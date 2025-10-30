SELECT CONCAT(LEFT(MONTHNAME(modifiedtxndate), 3), RIGHT(YEAR(modifiedtxndate), 2)) AS PERIOD
,COUNT(DISTINCT txnmappedmobile)customers,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills 
FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2024-07-16' AND '2025-07-16' AND frequencycount=1
AND modifiedstorecode <> 'demo' AND modifiedstorecode <> 'corporate' AND itemnetamount>0
GROUP BY 1
ORDER BY PERIOD;




SELECT CONCAT(LEFT(MONTHNAME(txndate), 3), RIGHT(YEAR(txndate), 2)) AS PERIOD
,COUNT(DISTINCT mobile)customers,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills 
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2024-07-16' AND '2025-07-16' AND frequencycount=1
AND storecode <> 'demo' AND storecode <> 'corporate' AND amount>0
GROUP BY 1
ORDER BY PERIOD;

SELECT COUNT(DISTINCT mobile)customer,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills 
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2024-08-01' AND '2024-08-31' AND frequencycount=1
AND storecode <> 'demo' AND storecode <> 'corporate' AND amount>0