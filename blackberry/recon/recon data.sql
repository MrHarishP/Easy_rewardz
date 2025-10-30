SELECT * FROM rawitem_recon;

STR_TO_DATE(billdate,'%d-%b-%y');
 
SELECT COUNT(DISTINCT customermobile)customer,SUM(billedprice)billedsales,COUNT(DISTINCT billno)bills FROM rawitem_recon
WHERE billdate BETWEEN '01-apr-24' AND '22-jun-24' AND billedprice>0 AND storecode <> 'demo';



SELECT CONCAT(MONTHNAME(STR_TO_DATE(billdate, '%d-%b-%y')),' ',YEAR(STR_TO_DATE(billdate, '%d-%b-%y'))) AS `month_year`,
remarks,ROUND(SUM(billedprice),0) Sales,COUNT(DISTINCT billno)bills FROM rawitem_Recon 
WHERE STR_TO_DATE(billdate,'%d-%b-%y') BETWEEN '2024-04-01' AND '2025-06-22' AND billedprice>0 AND storecode <> 'demo'
GROUP BY 1,2;


-- recon
SELECT  
CONCAT(MONTHNAME(STR_TO_DATE(billdate, '%d-%b-%y')),' ',YEAR(STR_TO_DATE(billdate, '%d-%b-%y'))) AS `month_year`,
COUNT(DISTINCT customermobile)customer,SUM(billedprice)billedsales,COUNT(DISTINCT billno)bills FROM rawitem_recon
WHERE STR_TO_DATE(billdate,'%d-%b-%y') BETWEEN '2024-04-01' AND '2025-06-22' AND billedprice>0 AND storecode <> 'demo'
GROUP BY 1
ORDER BY 1;


-- loyatly
SELECT CONCAT(MONTHNAME(modifiedtxndate),'',YEAR(modifiedtxndate))month_year,COUNT(DISTINCT txnmappedmobile)customer,
SUM(itemnetamount)loyalty_sales,COUNT(DISTINCT uniquebillno)loyalty_bills 
FROM sku_report_loyalty
WHERE modifiedtxndate BETWEEN '2024-04-01' AND '2025-06-22' AND itemnetamount>0 AND modifiedstorecode <> 'demo'
GROUP BY 1;


-- nonloyalty
SELECT CONCAT(MONTHNAME(modifiedtxndate),'',YEAR(modifiedtxndate))month_year,SUM(itemnetamount)nonloyalty_sales,
COUNT(DISTINCT uniquebillno)nonloyalty_bills 
FROM sku_report_nonloyalty
WHERE modifiedtxndate BETWEEN '2024-04-01' AND '2025-06-22' AND itemnetamount>0 AND modifiedstorecode <> 'demo'
GROUP BY 1;

-- txn date
SELECT CONCAT(MONTHNAME(txndate),'',YEAR(txndate))month_year,COUNT(DISTINCT mobile)customer,SUM(amount)txnsale,
COUNT(DISTINCT uniquebillno)txnbill 
FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2024-04-01' AND '2025-06-22' AND amount>0 AND storecode <> 'demo'
GROUP BY 1;