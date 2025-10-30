SELECT
modifiedstorecode,storetype1,COUNT(DISTINCT txnmappedmobile)customer,COUNT(DISTINCT uniquebillno)bills,
SUM(itemnetamount)sales,COUNT(DISTINCT CASE WHEN frequencycount>1 THEN txnmappedmobile END)repeaters,
SUM(CASE WHEN frequencycount>1 THEN itemnetamount END)repeater_sales,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN uniquebillno END)repeater_bills 
FROM sku_report_loyalty a LEFT JOIN store_master b ON a.modifiedstorecode=b.storecode
WHERE txndate BETWEEN '2024-04-01' AND '2025-03-31' AND itemnetamount>0 AND modifiedstorecode <> 'demo'
GROUP BY 1;

SELECT SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills,
SUM(CASE WHEN frequencycount>1 THEN itemnetamount END)repeater_sales,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN uniquebillno END)repeater_bills 
FROM sku_report_loyalty 
--  a LEFT JOIN store_master b ON a.modifiedstorecode=b.storecode
WHERE txndate BETWEEN '2024-04-01' AND '2025-03-31' 
AND itemnetamount>0 AND modifiedstorecode <> 'demo'
AND modifiedstorecode ='1003'
