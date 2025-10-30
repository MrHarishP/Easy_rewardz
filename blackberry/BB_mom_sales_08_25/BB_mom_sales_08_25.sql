WITH loyalty AS (
SELECT CONCAT(LEFT(MONTHNAME(modifiedtxndate),3),'-',RIGHT(YEAR(modifiedtxndate),2))PERIOD,
SUM(itemnetamount)loyalty_sales,COUNT(DISTINCT uniquebillno)loyalty_bills 
FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2023-03-01' AND '2023-03-31'
AND modifiedstorecode <> 'demo' AND modifiedstorecode <> 'corporate'
AND itemnetamount>0
GROUP BY 1),

nonloyalty AS (
SELECT CONCAT(LEFT(MONTHNAME(modifiedtxndate),3),'-',RIGHT(YEAR(modifiedtxndate),2))PERIOD,
SUM(itemnetamount)non_loyalty_sales,COUNT(DISTINCT uniquebillno)non_loyalty_bills 
FROM sku_report_nonloyalty 
WHERE modifiedtxndate BETWEEN '2023-01-01' AND '2023-01-31'
AND modifiedstorecode <> 'demo' AND modifiedstorecode <> 'corporate' AND itemnetamount>0
GROUP BY 1)

SELECT 
PERIOD,
SUM(loyalty_sales)loyalty_sales,SUM(loyalty_bills)loyalty_bills,
SUM(non_loyalty_sales)non_loyalty_sales,SUM(non_loyalty_bills)non_loyalty_bills,
SUM(loyalty_sales + non_loyalty_sales)total_sales,SUM(loyalty_bills + non_loyalty_bills)total_bills
FROM loyalty a JOIN nonloyalty b USING(PERIOD)
GROUP BY 1;


SELECT MIN(modifiedtxndate) FROM sku_report_loyalty