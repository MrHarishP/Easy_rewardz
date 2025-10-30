SELECT * FROM `responders_data`;


SELECT MONTHNAME(modifiedtxndate)MONTH,
YEAR(modifiedtxndate)YEAR,
COUNT(DISTINCT txnmappedmobile)customers,
SUM(itemnetamount)sales,
COUNT(DISTINCT uniquebillno)bills,
SUM(itemqty)qty  FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2025-04-01' AND '2025-06-30'
AND txnmappedmobile COLLATE utf8mb4_unicode_ci IN (SELECT DISTINCT mobile FROM responders_data
WHERE contactdate BETWEEN '2025-04-01' AND '2025-06-30') 
GROUP BY 1,2;

SELECT COUNT(DISTINCT txnmappedmobile)customers,
SUM(itemnetamount)sales,
COUNT(DISTINCT uniquebillno)bills,
SUM(itemqty)qty  FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2025-04-01' AND '2025-06-30'
AND txnmappedmobile COLLATE utf8mb4_unicode_ci IN (SELECT DISTINCT mobile FROM responders_data
WHERE contactdate BETWEEN '2025-04-01' AND '2025-06-30');





-- responders,sales, bills,redemption sales,discount

SELECT MONTHNAME(txndate)MONTH,COUNT(DISTINCT mobile)customer,COUNT(DISTINCT uniquebillno)bills,SUM(amount)sales 
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2025-04-01' AND '2025-06-30' AND amount>0
GROUP BY 1;



SELECT MONTHNAME(txndate)MONTH, COUNT(DISTINCT mobile)customers,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills
FROM txn_report_accrual_redemption  
WHERE txndate BETWEEN '2025-04-01' AND '2025-06-30' 
AND mobile COLLATE utf8mb4_unicode_ci IN (SELECT DISTINCT mobile FROM responders_data
WHERE contactdate BETWEEN '2025-04-01' AND '2025-06-30')
GROUP BY 1;



SELECT MONTHNAME(modifiedtxndate)MONTH,COUNT(DISTINCT txnmappedmobile)customer,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills
FROM sku_report_loyalty  
WHERE modifiedtxndate BETWEEN '2025-04-01' AND '2025-06-30' 
AND txnmappedmobile COLLATE utf8mb4_unicode_ci IN (SELECT DISTINCT mobile FROM responders_data
WHERE contactdate BETWEEN '2025-04-01' AND '2025-06-30')
GROUP BY 1;

SELECT MONTHNAME(contactdate)MONTH,COUNT(DISTINCT mobile)customers,SUM(sales)sales,SUM(billcount)bills 
FROM responders_data 
WHERE contactdate BETWEEN '2025-04-01' AND '2025-06-30' 
GROUP BY 1;

SELECT COUNT(DISTINCT mobile)customers,SUM(sales)sales,SUM(billcount)bills FROM responders_data
WHERE contactdate BETWEEN '2025-04-01' AND '2025-04-30';#1517

SELECT COUNT(DISTINCT mobile)customers,SUM(sales)sales,SUM(billcount)bills FROM responders_data
WHERE contactdate BETWEEN '2025-05-01' AND '2025-05-31';#7522

SELECT COUNT(DISTINCT mobile)customers,SUM(sales)sales,SUM(billcount)bills FROM responders_data
WHERE contactdate BETWEEN '2025-06-01' AND '2025-06-30';#7824
