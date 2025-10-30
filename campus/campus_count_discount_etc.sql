-- storecode 
-- 2023-2024 txn store count and remove demo
# 2023
SELECT storecode FROM (
SELECT mobile,storecode FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2023-01-01' AND '2023-12-31' AND storecode NOT LIKE 'demo'AND billno NOT LIKE '%test%'
GROUP BY 1,2)a
GROUP BY 1;
# 2024
SELECT storecode FROM (
SELECT mobile,storecode FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2024-01-01' AND '2024-12-31' AND storecode NOT LIKE 'demo'AND billno NOT LIKE '%test%'
GROUP BY 1,2)a
GROUP BY 1;

-- total discount given in 2023  from coupon offer report  
SELECT SUM(discount)total_discount FROM (
SELECT issuedmobile,SUM(discount)discount FROM coupon_offer_report 
WHERE useddate BETWEEN '2023-01-01' AND '2023-12-31' AND couponstatus='used' AND redeemedstorecode NOT LIKE 'demo'
GROUP BY 1)a;

-- total discount given in 2024 from coupon offer report  
SELECT SUM(discount)total_discount FROM (
SELECT issuedmobile,SUM(discount)discount FROM coupon_offer_report 
WHERE useddate BETWEEN '2024-01-01' AND '2024-12-31' AND couponstatus='used' AND redeemedstorecode NOT LIKE 'demo'
GROUP BY 1)a;

-- total discount given in 2023 from sku_report loyalty  
SELECT SUM(discount)total_discount FROM (
SELECT txnmappedmobile,SUM(itemdiscountamount)discount FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2023-01-01' AND '2023-12-31' AND storecode NOT LIKE 'demo' AND itemdiscountamount IS NOT NULL
GROUP BY 1)a;

-- total discount given in 2024 from sku_report loyalty  
SELECT SUM(discount)total_discount FROM (
SELECT txnmappedmobile,SUM(itemdiscountamount)discount FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2024-01-01' AND '2024-12-31' AND storecode NOT LIKE 'demo' AND itemdiscountamount IS NOT NULL
GROUP BY 1)a;

-- emails 
-- 2023 
SELECT mobile,email,enrolledstore,`last shopped store` FROM  program_single_view 
WHERE email IS NOT NULL 
GROUP BY 1,2,3,4;

-- 2024
SELECT mobile,email,enrolledstore,`last shopped store` FROM  program_single_view 
WHERE enrolledon BETWEEN '2024-01-01' AND '2024-12-31' AND email IS NOT NULL 
GROUP BY 1,2;


--  who enrolled on corporate but txn on other store
-- 2023
SELECT mobile,b.enrolledstorecode,storecode,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills,MAX(frequencycount) FROM txn_report_accrual_redemption a JOIN member_report b USING(mobile)
WHERE txndate BETWEEN '2023-01-01' AND '2023-12-31' AND b.enrolledstorecode LIKE 'corporate' AND b.enrolledstorecode NOT LIKE 'demo'
GROUP BY 1;

--  who enrolled on corporate but txn on other store
-- 2024
SELECT mobile,b.enrolledstorecode,storecode,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills,MAX(frequencycount)frequencycount FROM txn_report_accrual_redemption a JOIN member_report b USING(mobile)
WHERE txndate BETWEEN '2024-01-01' AND '2024-12-31' AND b.enrolledstorecode LIKE "corporate"
GROUP BY 1;
-- QC
SELECT mobile,b.enrolledstorecode,storecode,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills,MAX(frequencycount)frequencycount FROM txn_report_accrual_redemption a JOIN member_report b USING(mobile)
WHERE txndate BETWEEN '2023-01-01' AND '2023-12-31' AND b.enrolledstorecode LIKE "corporate" AND mobile = '6206239987'
GROUP BY 1;


-- count of customer who enrolled on corporate store
-- 2023
SELECT modifiedenrolledon,COUNT(DISTINCT mobile)customer FROM member_report 
WHERE enrolledstorecode LIKE 'corporate' AND enrolledstorecode NOT LIKE 'demo'
GROUP BY 1;

-- QC
SELECT modifiedenrolledon, mobile customer FROM member_report 
WHERE enrolledstorecode LIKE 'corporate' AND enrolledstorecode NOT LIKE 'demo'
AND modifiedenrolledon='2024-09-13'
GROUP BY 1,2;





SELECT * FROM program_single_view
WHERE mobile ='6000043691'

SELECT * FROM member_report
WHERE mobile ='6000043691'

SELECT * FROM txn_report_accrual_redemption 
WHERE mobile ='6000043691'