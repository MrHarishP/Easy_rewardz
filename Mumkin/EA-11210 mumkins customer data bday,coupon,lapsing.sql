-- birthday data for april 2025 
SELECT mobile, DATE_FORMAT(dateofbirth, '%d-%b-%Y')'date of birth ',firstname,lastname,enrolledstore FROM member_report 
WHERE MONTH(dateofbirth) =4
GROUP BY 1;
-- QC
SELECT mobile,DAY(dateofbirth), enrolledstore FROM member_report 
WHERE MONTH(dateofbirth) = 4 AND mobile = '7048194986'
GROUP BY 1;

-- coupon expire data 
SELECT issuedmobile,CONCAT(Firstname,' ',lastname)customer_name,couponoffercode,DATE_FORMAT(expirydate,'%d-%b-%Y')expirydate,enrolledstore 
FROM coupon_offer_report a JOIN member_report b ON a.issuedmobile=b.mobile
WHERE expirydate BETWEEN '2025-04-01' AND '2025-04-30' AND couponstatus='issued'
GROUP BY 1,2,3,4;


-- QC
SELECT issuedmobile,couponoffercode,expirydate,issueddate FROM coupon_offer_report 
WHERE expirydate BETWEEN '2025-04-01' AND '2025-04-30' AND couponstatus='issued' AND issuedmobile = '7014617160'
GROUP BY 1,2



-- QC
SELECT issuedmobile,couponoffercode,DAY(expirydate) FROM coupon_offer_report 
WHERE expirydate BETWEEN '2025-04-01' AND '2025-04-30' AND couponstatus='issued' AND issuedmobile ='9911809649'
GROUP BY 1;
-- QC
SELECT mobile,enrolledstore FROM member_report 
WHERE mobile ='9352765630'
GROUP BY 1;


-- lapse points data 

SELECT mobile,SUM(pointslapsing)Points,CONCAT(firstname,' ',lastname)customer_name,enrolledstore FROM lapse_report a JOIN member_report b USING(mobile)
WHERE lapsingdate BETWEEN '2025-04-01' AND '2025-04-30' AND pointslapsing>0
GROUP BY 1;

-- QC
SELECT mobile,SUM(pointslapsed),SUM(pointscollected),SUM(pointsspent) FROM lapse_report 
WHERE lapsingdate BETWEEN '2025-04-01' AND '2025-04-30' AND mobile = '6260772861'
GROUP BY 1;


-- recency data  60 to 365
WITH recency_data AS (
SELECT mobile,CONCAT(firstname,' ',lastname)customer_name,b.enrolledstore,
SUM(b.availablePoints) points_available,DATEDIFF('2025-03-24',MAX(txndate))recency
FROM txn_report_accrual_redemption a JOIN member_report b USING(mobile)
GROUP BY 1)
SELECT * FROM recency_data WHERE recency BETWEEN 60 AND 365 ;


-- recency data >365
WITH recency_data AS (
SELECT mobile,CONCAT(firstname,' ',lastname)customer_name,b.enrolledstore,
SUM(b.availablePoints) points_available,DATEDIFF('2025-03-24',MAX(txndate))recency
FROM txn_report_accrual_redemption a JOIN member_report b USING(mobile)
GROUP BY 1)
SELECT * FROM recency_data WHERE recency>365 ;

-- QC
SELECT mobile,recency FROM(
SELECT mobile,DATEDIFF('2025-03-24',MAX(txndate))recency FROM txn_report_accrual_redemption 
GROUP BY 1)a
WHERE recency BETWEEN 60 AND 365 AND mobile = '9829087044'
GROUP BY 1;


