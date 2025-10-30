

WITH loyalty AS (
SELECT DISTINCT txnmappedmobile,modifiedtxndate,uniquebillno,itemnetamount,itemmrp,itemdiscountamount,storetype1,
itemqty,(itemmrp*itemqty)-itemnetamount AS discount 
FROM sku_report_loyalty a JOIN store_master b ON a.modifiedstorecode = b.storecode
WHERE modifiedtxndate BETWEEN '2023-01-01' AND '2025-07-31' AND itemqty>0 
)

SELECT CONCAT(MONTHNAME(modifiedtxndate),YEAR(modifiedtxndate))PERIOD,storetype1,SUM(itemnetamount)sales,
SUM(discount)discount,COUNT(DISTINCT uniquebillno)bills
FROM loyalty
GROUP BY 1,2;
