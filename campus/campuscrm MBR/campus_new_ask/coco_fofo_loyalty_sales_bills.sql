SELECT 
MONTHNAME(modifiedtxndate)`month`,
COUNT(DISTINCT txnmappedmobile)customer,
SUM(itemnetamount)amount,
COUNT(DISTINCT uniquebillno)bills,
SUM(ItemQty)qty
FROM `campuscrm`.sku_report_loyalty a 
JOIN `campuscrm`.member_report b 
ON a.txnmappedmobile = b.mobile
WHERE modifiedtxndate BETWEEN '2025-01-01' AND '2025-06-30'
AND modifiedstorecode NOT LIKE '%demo%'
AND modifiedbillno NOT LIKE '%test%'
AND modifiedbillno NOT LIKE '%roll%'
AND modifiedstorecode NOT IN ('Corporate')
AND modifiedstorecode NOT LIKE '%ecom%'
AND modifiedstorecode IN (SELECT StoreCode FROM store_master WHERE StoreType1 LIKE '%coco%')
AND itemnetamount > 0 
GROUP BY 1;

WITH base_data AS
(SELECT a.mobile,a.EnrolledStoreCode,b.StoreType1 FROM member_report a LEFT JOIN store_master b
ON a.EnrolledStore=b.StoreCode
AND EnrolledStoreCode NOT LIKE '%demo%'
AND EnrolledStoreCode NOT LIKE '%test%')
SELECT StoreType1,COUNT(mobile) FROM base_data GROUP BY 1 ;



(SELECT a.mobile,a.EnrolledStore,b.StoreType1
 FROM program_single_view a LEFT JOIN store_master b
 ON a.EnrolledStore=b.StoreCode);
 
 
 
 
 
 
 
 
 
 
 
 
 
 
SELECT 
MONTHNAME(txndate)`month`,
COUNT(DISTINCT mobile)customer,
SUM(amount)amount,
COUNT(DISTINCT uniquebillno)bills
FROM `campuscrm`.txn_report_accrual_redemption  
WHERE txndate BETWEEN '2025-01-01' AND '2025-06-30'
AND storecode NOT LIKE '%demo%'
AND billno NOT LIKE '%test%'
AND billno NOT LIKE '%roll%'
AND storecode NOT IN ('Corporate')
AND storecode LIKE '%ecom%'
AND amount>0 
GROUP BY 1; 

SELECT * FROM txn_report_accrual_redemption WHERE txndate BETWEEN '2025-01-01' AND '2025-06-30'
AND  storecode LIKE '%ecom%' 
AND storecode NOT LIKE '%demo%'
AND billno NOT LIKE '%test%'
AND billno NOT LIKE '%roll%'
AND storecode NOT IN ('Corporate')
AND amount>0;
 
 
 
 
 
 
    