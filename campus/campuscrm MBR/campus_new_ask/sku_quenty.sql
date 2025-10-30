SELECT SUM(ItemQty) AS qty FROM SKU_REPORT_LOYALTY WHERE MODIFIEDTXNDATE BETWEEN 
'2025-04-01' AND '2025-06-30'
      AND modifiedstorecode NOT LIKE '%demo%'
      AND modifiedbillno NOT LIKE '%test%'
      AND modifiedbillno NOT LIKE '%roll%'
      AND modifiedstorecode NOT IN ('Corporate')



FROM member_report WHERE ModifiedEnrolledOn  BETWEEN '2025-04-01' AND '2025-06-30'
AND EnrolledStoreCode NOT LIKE '%demo%'
AND EnrolledStoreCode NOT LIKE '%test%'
AND EnrolledStoreCode NOT LIKE '%Corporate%'
AND EnrolledStoreCode  LIKE '%ecom%';

SELECT COUNT(DISTINCT mobile) FROM txn_report_accrual_redemption WHERE txndate BETWEEN '2025-04-01' AND '2025-06-30'
 AND storecode NOT LIKE '%demo%'
      AND billno NOT LIKE '%test%'
      AND billno NOT LIKE '%roll%'
      AND storecode NOT LIKE '%Corporate%'
      AND amount > 0