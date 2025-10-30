
SELECT COUNT(Mobile) FROM member_report
WHERE ModifiedEnrolledOn BETWEEN '2025-04-01' AND '2025-06-30'
    AND EnrolledStoreCode NOT LIKE '%demo%'
    AND EnrolledStoreCode NOT LIKE '%test%'
    AND EnrolledStoreCode NOT LIKE '%roll%'
    AND EnrolledStoreCode NOT IN ('Corporate')
    AND EnrolledStoreCode  LIKE '%ecom%';
    
    
    
    
    
SELECT SUM(itemnetamount),COUNT(DISTINCT uniquebillno)bills FROM sku_report_nonloyalty
WHERE modifiedtxndate  BETWEEN '2023-04-01' AND '2023-06-30'
AND modifiedstorecode NOT LIKE '%demo%'
      AND modifiedbillno NOT LIKE '%test%'
      AND modifiedbillno NOT LIKE '%roll%'
      AND modifiedstorecode NOT IN ('Corporate')
      AND modifiedstorecode NOT LIKE '%ecom%'
      AND modifiedstorecode NOT LIKE (SELECT StoreCode FROM store_master WHERE StoreType1 LIKE '%coco%');
     -- 
--       and  modifiedstorecode in (SELECT StoreCode  FROM store_master WHERE StoreType1='fofo')
--       AND modifiedstorecode NOT LIKE '%ecom%' 
      AND itemnetamount > 0;
    
    
 SELECT MOBILE,offerredemptionsales
 FROM `responders_data`  
 WHERE CONTACTDATE BETWEEN '2025-07-01' AND '2025-07-31'
 AND MOBILE='7320913326';
    
    
    