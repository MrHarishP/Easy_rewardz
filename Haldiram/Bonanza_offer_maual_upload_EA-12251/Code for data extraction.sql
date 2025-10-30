-- select * from dummy.haldirams_segment_25_07_28;
-- SELECT * FROM dummy.haldirams_segment_07_28;
-- Select a.Mobile, a.amount, a.uniquebillno, a.pointscollected, a.storecode, b.segment_id 
-- from txn_report_accrual_redemption a
-- join dummy.haldirams_segment_07_28 b on a.mobile = b.mobile
-- where a.amount >599 and a.txndate between '2025-07-26' and '2025-07-27' and a.storecode <> 'demo';
-- 
-- alter table dummy.haldirams_segment_07_28  add index mb(mobile);
-- 
-- SELECT 
--     a.Mobile,     a.uniquebillno, 
--     a.amount,
--     a.pointscollected, 
--     a.txndate,
--     a.storecode, 
--     b.segment_id 
-- FROM 
--     txn_report_accrual_redemption a
-- INNER JOIN 
--     dummy.haldirams_segment_07_28 b 
--     ON a.mobile = b.mobile
-- WHERE 
--     a.amount > 599 
--     AND a.txndate = '2025-08-01'  -- safer for date range
--     AND a.storecode NOT LIKE '%demo%'
--     group by 1,2;
--     
    
    
--  Query tpo be used 

SELECT 
a.Mobile, a.modifiedbillno, 
a.pointscollected,
DATE_ADD(CURDATE(), INTERVAL 21 DAY) AS Validity ,
CONCAT(a.modifiedbillno,' -2X Bonus') AS bill,
a.storecode, 
'2X Bonus Points Campaign_26Jul25' AS Narration
FROM 
txn_report_accrual_redemption a
INNER JOIN 
dummy.haldirams_segment_07_28 b 
ON a.mobile = b.mobile
WHERE 
a.amount > 599
AND a.txndate = '2025-08-10'  -- change date daily
AND a.storecode NOT LIKE '%demo%'
AND a.storecode <>'ecom'
GROUP BY 1,2;




#############################################

SELECT 
a.Mobile, a.modifiedbillno, 
a.pointscollected,
DATE_ADD(CURDATE(), INTERVAL 21 DAY) AS Validity ,
CONCAT(a.modifiedbillno,' -2X Bonus') AS bill,
a.storecode, 
'2X Bonus Points Campaign_26Jul25' AS Narration,insertiondate
FROM 
txn_report_accrual_redemption a
INNER JOIN 
dummy.haldirams_segment_07_28 b 
ON a.mobile = b.mobile
WHERE 
a.amount > 599
AND a.txndate = '2025-08-21'  -- change date daily
AND a.storecode NOT LIKE '%demo%'
AND a.storecode <>'ecom'
GROUP BY 1,2;