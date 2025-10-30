###################################-- new customers of categoryname of top 20 start ###########################
WITH newcustomer AS 
(SELECT categoryname,txnmappedmobile,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills,SUM(itemqty)item
-- SUM(itemnetamount)/COUNT(DISTINCT uniquebillno)atv,SUM(itemnetamount)/COUNT(DISTINCT txnmappedmobile)amv,SUM(itemqty)/SUM(itemnetamount)
FROM sku_report_loyalty JOIN item_master USING(uniqueitemcode)
WHERE modifiedtxndate BETWEEN '2024-11-01' AND '2025-04-15' AND frequencycount=1
GROUP BY 1,2)
SELECT categoryname,COUNT(DISTINCT txnmappedmobile)customer,SUM(sales)sales,SUM(bills)bills,SUM(item)total_qty
FROM newcustomer
GROUP BY 1
ORDER BY categoryname LIMIT 20;

###################################-- new customers of categoryname of top 20 end ###########################

########################################-- new to repeat of categoryname of top 20 start##############################
WITH newcustomer AS 
(SELECT categoryname,txnmappedmobile,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills,SUM(itemqty)item
-- SUM(itemnetamount)/COUNT(DISTINCT uniquebillno)atv,SUM(itemnetamount)/COUNT(DISTINCT txnmappedmobile)amv,SUM(itemqty)/SUM(itemnetamount)
FROM sku_report_loyalty JOIN item_master USING(uniqueitemcode)
WHERE modifiedtxndate BETWEEN '2024-11-01' AND '2025-04-15' AND frequencycount=1
GROUP BY 1,2),
new_to_repeat AS (
SELECT categoryname,txnmappedmobile,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills,SUM(itemqty)item
-- SUM(itemnetamount)/COUNT(DISTINCT uniquebillno)atv,SUM(itemnetamount)/COUNT(DISTINCT txnmappedmobile)amv,SUM(itemqty)/SUM(itemnetamount)
FROM sku_report_loyalty JOIN item_master USING(uniqueitemcode)
WHERE modifiedtxndate BETWEEN '2024-11-01' AND '2025-04-15' 
AND frequencycount=2 AND txnmappedmobile IN (SELECT DISTINCT txnmappedmobile FROM newcustomer)
GROUP BY 1,2)
SELECT categoryname,COUNT(DISTINCT txnmappedmobile)customers,SUM(sales)sales,SUM(bills)bills,SUM(item)total_item
FROM new_to_repeat
GROUP BY 1
ORDER BY categoryname LIMIT 20;

########################################-- new to repeat of categoryname of top 20 end##############################

########################-- repeat to repeat of categoryname of top 20 start ##########################

WITH newcustomer AS 
(SELECT categoryname,txnmappedmobile,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills,SUM(itemqty)item
-- SUM(itemnetamount)/COUNT(DISTINCT uniquebillno)atv,SUM(itemnetamount)/COUNT(DISTINCT txnmappedmobile)amv,SUM(itemqty)/SUM(itemnetamount)
FROM sku_report_loyalty JOIN item_master USING(uniqueitemcode)
WHERE modifiedtxndate BETWEEN '2024-11-01' AND '2025-04-15' AND frequencycount=1
GROUP BY 1,2),
new_to_repeat AS (
SELECT categoryname,txnmappedmobile,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills,SUM(itemqty)item
-- SUM(itemnetamount)/COUNT(DISTINCT uniquebillno)atv,SUM(itemnetamount)/COUNT(DISTINCT txnmappedmobile)amv,SUM(itemqty)/SUM(itemnetamount)
FROM sku_report_loyalty JOIN item_master USING(uniqueitemcode)
WHERE modifiedtxndate BETWEEN '2024-11-01' AND '2025-04-15' 
AND frequencycount=2 AND txnmappedmobile IN (SELECT DISTINCT txnmappedmobile FROM newcustomer)
GROUP BY 1,2),
repeat_to_repeat AS(
SELECT categoryname,txnmappedmobile,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills,SUM(itemqty)item
-- SUM(itemnetamount)/COUNT(DISTINCT uniquebillno)atv,SUM(itemnetamount)/COUNT(DISTINCT txnmappedmobile)amv,SUM(itemqty)/SUM(itemnetamount)
FROM sku_report_loyalty JOIN item_master USING(uniqueitemcode)
WHERE modifiedtxndate BETWEEN '2024-11-01' AND '2025-04-15' 
AND frequencycount>2 AND txnmappedmobile IN (SELECT DISTINCT txnmappedmobile FROM new_to_repeat)
GROUP BY 1,2
)
SELECT categoryname,COUNT(DISTINCT txnmappedmobile)customers,SUM(sales)sales,SUM(bills)bills,SUM(item)total_qty,SUM(sales)/SUM(bills)bills,
SUM(sales)/COUNT(DISTINCT txnmappedmobile)amv,SUM(sales)/SUM(item)asp
FROM repeat_to_repeat
GROUP BY 1
ORDER BY categoryname LIMIT 20;
########################-- repeat to repeat of categoryname of top 20 end ##########################



###################################-- new customers of subcategoryname of top 20 start ###########################
WITH newcustomer AS 
(SELECT subcategoryname,txnmappedmobile,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills,SUM(itemqty)item
-- SUM(itemnetamount)/COUNT(DISTINCT uniquebillno)atv,SUM(itemnetamount)/COUNT(DISTINCT txnmappedmobile)amv,SUM(itemqty)/SUM(itemnetamount)
FROM sku_report_loyalty JOIN item_master USING(uniqueitemcode)
WHERE modifiedtxndate BETWEEN '2024-11-01' AND '2025-04-15' AND frequencycount=1
GROUP BY 1,2)
SELECT subcategoryname,COUNT(DISTINCT txnmappedmobile)customer,SUM(sales)sales,SUM(bills)bills,SUM(item)total_qty
FROM newcustomer
GROUP BY 1
ORDER BY subcategoryname LIMIT 20;

###################################-- new customers of subcategoryname of top 20 end ###########################

########################################-- new to repeat of subcategoryname of top 20 start ##############################
WITH newcustomer AS 
(SELECT subcategoryname,txnmappedmobile,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills,SUM(itemqty)item
-- SUM(itemnetamount)/COUNT(DISTINCT uniquebillno)atv,SUM(itemnetamount)/COUNT(DISTINCT txnmappedmobile)amv,SUM(itemqty)/SUM(itemnetamount)
FROM sku_report_loyalty JOIN item_master USING(uniqueitemcode)
WHERE modifiedtxndate BETWEEN '2024-11-01' AND '2025-04-15' AND frequencycount=1
GROUP BY 1,2),
new_to_repeat AS (
SELECT subcategoryname,txnmappedmobile,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills,SUM(itemqty)item
-- SUM(itemnetamount)/COUNT(DISTINCT uniquebillno)atv,SUM(itemnetamount)/COUNT(DISTINCT txnmappedmobile)amv,SUM(itemqty)/SUM(itemnetamount)
FROM sku_report_loyalty JOIN item_master USING(uniqueitemcode)
WHERE modifiedtxndate BETWEEN '2024-11-01' AND '2025-04-15' 
AND frequencycount=2 AND txnmappedmobile IN (SELECT DISTINCT txnmappedmobile FROM newcustomer)
GROUP BY 1,2)
SELECT subcategoryname,COUNT(DISTINCT txnmappedmobile)customers,SUM(sales)sales,SUM(bills)bills,SUM(item)total_item
FROM new_to_repeat
GROUP BY 1
ORDER BY subcategoryname LIMIT 20;
########################################-- new to repeat of subcategoryname of top 20 end ##############################

########################-- repeat to repeat of subcategoryname of top 20 start  ##########################

WITH newcustomer AS 
(SELECT subcategoryname,txnmappedmobile,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills,SUM(itemqty)item
-- SUM(itemnetamount)/COUNT(DISTINCT uniquebillno)atv,SUM(itemnetamount)/COUNT(DISTINCT txnmappedmobile)amv,SUM(itemqty)/SUM(itemnetamount)
FROM sku_report_loyalty JOIN item_master USING(uniqueitemcode)
WHERE modifiedtxndate BETWEEN '2024-11-01' AND '2025-04-15' AND frequencycount=1
GROUP BY 1,2),
new_to_repeat AS (
SELECT subcategoryname,txnmappedmobile,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills,SUM(itemqty)item
-- SUM(itemnetamount)/COUNT(DISTINCT uniquebillno)atv,SUM(itemnetamount)/COUNT(DISTINCT txnmappedmobile)amv,SUM(itemqty)/SUM(itemnetamount)
FROM sku_report_loyalty JOIN item_master USING(uniqueitemcode)
WHERE modifiedtxndate BETWEEN '2024-11-01' AND '2025-04-15' 
AND frequencycount=2 AND txnmappedmobile IN (SELECT DISTINCT txnmappedmobile FROM newcustomer)
GROUP BY 1,2),
repeat_to_repeat AS(
SELECT subcategoryname,txnmappedmobile,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills,SUM(itemqty)item
-- SUM(itemnetamount)/COUNT(DISTINCT uniquebillno)atv,SUM(itemnetamount)/COUNT(DISTINCT txnmappedmobile)amv,SUM(itemqty)/SUM(itemnetamount)
FROM sku_report_loyalty JOIN item_master USING(uniqueitemcode)
WHERE modifiedtxndate BETWEEN '2024-11-01' AND '2025-04-15' 
AND frequencycount>2 AND txnmappedmobile IN (SELECT DISTINCT txnmappedmobile FROM new_to_repeat)
GROUP BY 1,2
)
SELECT subcategoryname,COUNT(DISTINCT txnmappedmobile)customers,SUM(sales)sales,SUM(bills)bills,SUM(item)total_qty,SUM(sales)/SUM(bills)bills,
SUM(sales)/COUNT(DISTINCT txnmappedmobile)amv,SUM(sales)/SUM(item)asp
FROM repeat_to_repeat
GROUP BY 1
ORDER BY subcategoryname LIMIT 20;
########################-- repeat to repeat of subcategoryname of top 20 start  ##########################
