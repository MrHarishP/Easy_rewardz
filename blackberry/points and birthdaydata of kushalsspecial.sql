SELECT * FROM member_report LIMIT 10;
SELECT * FROM txn_report_flat_accrual LIMIT 10;
SELECT * FROM coupon_offer_report LIMIT 10;
SELECT * FROM lapse_report LIMIT 10;
SELECT * FROM txn_report_accrual_redemption LIMIT 10;


--  lapsing points of april month 25
WITH lap_member_25 AS (
SELECT a.mobile,CONCAT(firstname,' ',lastname)NAME, a.enrolledstore,a.availablepoints Available_Points,
SUM(b.pointslapsing)lapsing_points,lapsingdate AS expiry 
FROM member_report a JOIN  lapse_report b ON a.mobile=b.mobile 
WHERE lapsingdate BETWEEN '2025-04-01' AND '2025-04-30' 
GROUP BY 1
),
last_store AS (
SELECT a.mobile,store FROM(
SELECT mobile,MAX(txndate)last_txndate FROM txn_report_accrual_redemption 
GROUP BY 1)a JOIN txn_report_accrual_redemption b ON  a.mobile=b.mobile AND last_txndate=txndate
WHERE a.mobile IN (SELECT DISTINCT mobile FROM lap_member_25)
GROUP BY 1,2
),
sales AS (
SELECT mobile,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills FROM txn_report_accrual_redemption 
WHERE mobile IN (SELECT DISTINCT mobile FROM lap_member_25 )
GROUP BY 1)
SELECT a.mobile,NAME,enrolledstore AS 'Registered Store Name',store'Last Transacted Store Name',
SUM(sales)'total spend',SUM(bills)'total txn',
Available_Points'Available Points',
lapsing_points'Points Expiring in this Month',
expiry FROM lap_member_25 a JOIN last_store b ON a.mobile=b.mobile JOIN sales c ON a.mobile=c.mobile
GROUP BY 1;





SELECT * FROM txn_report_accrual_redemption 
WHERE mobile = '6265217199';

SELECT * FROM member_report
WHERE mobile='6265217199';


SELECT  * FROM LAPSE_REPORT 
WHERE MOBILE = '6000460190';


WITH dob_april AS (
SELECT mobile,CONCAT(firstname,' ',lastname)NAME, enrolledstore,DATE(dateofbirth)DOB,totaltxn,totalspend FROM member_report 
WHERE MONTH(dateofbirth) = 4
GROUP BY 1),
last_store AS(
SELECT a.mobile,store FROM (
SELECT mobile,MAX(txndate)last_txn FROM txn_report_accrual_redemption 
WHERE mobile IN (SELECT DISTINCT mobile FROM dob_april)
GROUP BY 1)a JOIN txn_report_accrual_redemption b ON a.mobile=b.mobile AND last_txn=txndate
GROUP BY 1,2)

SELECT mobile,NAME,enrolledstore,store'last txn store',dob,totaltxn,totalspend FROM dob_april a JOIN last_store b USING(mobile)
GROUP BY 1;




