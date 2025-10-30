CREATE TABLE dummy.BROD_BROD_1941_targeted_customer
(mobile INT);

ALTER TABLE dummy.BROD_BROD_1941_targeted_customer
MODIFY mobile VARCHAR(100)
campaigncode VARCHAR (250),mobile VARCHAR(100)

SELECT mobile FROM dummy.BROD_BROD_1941_targeted_customer a JOIN dummy.BROD_BROD_1941_1690_1697_targeted_cutomers b USING(mobile)


SELECT COUNT(DISTINCT mobile) FROM dummy.BROD_BROD_1941_1690_1697_targeted_cutomers
GROUP BY 1;

LOAD DATA LOCAL INFILE  "D:\\OneDrive - EasyRewardz Software Services Private Limited\\North\\campus\\check campaign performance\\BROD_BROD_1941_targeted_cutomers.csv" 
INTO TABLE dummy.BROD_BROD_1941_targeted_customer
CHARACTER SET 'latin1'
FIELDS ESCAPED BY '\\' 
TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;


SELECT * FROM dummy.BROD_BROD_1941_targeted_customer

WITH txn_data AS (
SELECT 'BROD_BROD_1941' tag,COUNT(DISTINCT mobile)mobile,SUM(sales)sales,SUM(bills)bills,SUM(visit)visit FROM(
SELECT mobile,SUM(a.amount)sales,COUNT(DISTINCT uniquebillno)bills,
COUNT(DISTINCT txndate)visit 
FROM txn_report_accrual_redemption a
WHERE txndate BETWEEN '2025-08-09' AND '2025-08-16' 
-- and a.amount>0
AND mobile IN (SELECT mobile FROM dummy.BROD_BROD_1941_targeted_customer)
GROUP BY 1)a),

coupon_data AS (
SELECT 'BROD_BROD_1941' tag,COUNT(DISTINCT redeemedmobile)Redeemers,
SUM(amount)redemption_sales,COUNT(DISTINCT billno)redemptionbill,COUNT(DISTINCT couponcode)couponcode
FROM coupon_offer_report
WHERE useddate BETWEEN '2025-08-01' AND '2025-08-17' AND couponstatus='used' AND amount>0
AND issuedmobile IN(SELECT DISTINCT mobile FROM dummy.BROD_BROD_1941_targeted_customer)
)

SELECT tag,mobile,sales,bills,visit,redeemers,redemption_sales,redemptionbill,couponcode FROM txn_data a JOIN coupon_data b USING(tag)
#################################################################################################



SELECT *
FROM coupon_offer_report a WHERE useddate BETWEEN '2025-08-09' AND '2025-08-16'
AND redeemedmobile IN (SELECT mobile FROM dummy.BROD_BROD_1941_targeted_customer)


SELECT 
COUNT(DISTINCT issuedmobile)Redeemers, 
COUNT(couponcode)CouponsRedeemed, SUM(b.amount)RedemptionSale, 
COUNT(modifiedbillno) redemptionbills, SUM(discount)discount 
FROM coupon_offer_report a JOIN txn_Report_accrual_Redemption b ON a.billno=b.modifiedbillno 
WHERE useddate BETWEEN '2025-08-09' AND '2025-08-16' AND couponstatus = 'Used' 
AND redeemedstorecode<>'demo' 
AND redeemedmobile IN (SELECT mobile FROM dummy.BROD_BROD_1941_targeted_customer)




SELECT DISTINCT mobile,txndate,amount,uniquebillno FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2025-08-09' AND '2025-08-16' AND mobile = '9714177755'


###############################################################

CREATE TABLE dummy.BROD_BROD_1690_targeted_customer
(mobile VARCHAR(100));

SELECT * FROM dummy.BROD_BROD_1690_targeted_customer

LOAD DATA LOCAL INFILE  "D:\\OneDrive - EasyRewardz Software Services Private Limited\\North\\campus\\check campaign performance\\BROD_BROD_1690_targeted_customers.csv" 
INTO TABLE dummy.BROD_BROD_1690_targeted_customer
CHARACTER SET 'latin1'
FIELDS ESCAPED BY '\\' 
TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;#168



WITH txn_data AS (
SELECT 'BROD_BROD_1690' tag,COUNT(DISTINCT mobile)mobile,SUM(sales)sales,SUM(bills)bills,SUM(visit)visit FROM(
SELECT mobile,SUM(a.amount)sales,COUNT(DISTINCT uniquebillno)bills,
COUNT(DISTINCT txndate)visit 
FROM txn_report_accrual_redemption a
WHERE txndate BETWEEN '2025-06-06' AND '2025-06-13' 
-- and a.amount>0
AND mobile IN (SELECT mobile FROM dummy.BROD_BROD_1690_targeted_customer)
GROUP BY 1)a),

coupon_data AS (
SELECT 'BROD_BROD_1690' tag,COUNT(DISTINCT redeemedmobile)Redeemers,
SUM(amount)redemption_sales,COUNT(DISTINCT billno)redemptionbill,COUNT(DISTINCT couponcode)couponcode
FROM coupon_offer_report
WHERE useddate BETWEEN '2025-06-06' AND '2025-06-13' AND couponstatus='used' AND amount>0
AND issuedmobile IN(SELECT DISTINCT mobile FROM dummy.BROD_BROD_1690_targeted_customer)
)

SELECT tag,mobile,sales,bills,visit,redeemers,redemption_sales,redemptionbill,couponcode FROM txn_data a JOIN coupon_data b USING(tag)



###############################################################################


CREATE TABLE dummy.BROD_BROD_1697_targeted_customer
(mobile VARCHAR(100));



LOAD DATA LOCAL INFILE  "D:\\OneDrive - EasyRewardz Software Services Private Limited\\North\\campus\\check campaign performance\\BROD_BROD_1697_targeted_customers.csv"
INTO TABLE dummy.BROD_BROD_1697_targeted_customer
CHARACTER SET 'latin1'
FIELDS ESCAPED BY '\\' 
TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;#96



WITH txn_data AS (
SELECT 'BROD_BROD_1697' tag,COUNT(DISTINCT mobile)mobile,SUM(sales)sales,SUM(bills)bills,SUM(visit)visit FROM(
SELECT mobile,SUM(a.amount)sales,COUNT(DISTINCT uniquebillno)bills,
COUNT(DISTINCT txndate)visit 
FROM txn_report_accrual_redemption a
WHERE txndate BETWEEN '2025-06-13' AND '2025-06-20' 
-- and a.amount>0
AND mobile IN (SELECT mobile FROM dummy.BROD_BROD_1697_targeted_customer)
GROUP BY 1)a),

coupon_data AS (
SELECT 'BROD_BROD_1697' tag,COUNT(DISTINCT redeemedmobile)Redeemers,
SUM(amount)redemption_sales,COUNT(DISTINCT billno)redemptionbill,COUNT(DISTINCT couponcode)couponcode
FROM coupon_offer_report
WHERE useddate BETWEEN '2025-06-13' AND '2025-06-20' AND couponstatus='used' AND amount>0
AND issuedmobile IN(SELECT DISTINCT mobile FROM dummy.BROD_BROD_1697_targeted_customer)
)

SELECT tag,mobile,sales,bills,visit,redeemers,redemption_sales,redemptionbill,couponcode FROM txn_data a JOIN coupon_data b USING(tag);


#################################################################################

CREATE TABLE dummy.BROD_BROD_1941_1690_1697_targeted_cutomers
(campaigncode VARCHAR (250),mobile VARCHAR(100));




LOAD DATA LOCAL INFILE  "D:\\OneDrive - EasyRewardz Software Services Private Limited\\North\\campus\\check campaign performance\\BROD_BROD_1941_1690_1697_targeted_cutomers.csv"
INTO TABLE dummy.BROD_BROD_1941_1690_1697_targeted_cutomers
CHARACTER SET 'latin1'
FIELDS ESCAPED BY '\\' 
TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;#373167




############################




SELECT 'BROD_BROD_1941' tag,mobile,SUM(sales)sales,SUM(bills)bills,SUM(visit)visit FROM(
SELECT mobile,SUM(a.amount)sales,COUNT(DISTINCT uniquebillno)bills,
COUNT(DISTINCT txndate)visit 
FROM txn_report_accrual_redemption a
WHERE txndate BETWEEN '2025-08-09' AND '2025-08-16' 
-- and a.amount>0
AND mobile IN (SELECT DISTINCT mobile FROM dummy.BROD_BROD_1941_1690_1697_targeted_cutomers WHERE campaigncode='BROD_BROD_1941')
GROUP BY 1)a
GROUP BY 1,2



WITH txn_data AS (
SELECT 'BROD_BROD_1941' tag,COUNT(DISTINCT mobile)mobile,SUM(sales)sales,SUM(bills)bills,SUM(visit)visit FROM(
SELECT mobile,SUM(a.amount)sales,COUNT(DISTINCT uniquebillno)bills,
COUNT(DISTINCT txndate)visit 
FROM txn_report_accrual_redemption a
WHERE txndate BETWEEN '2025-08-09' AND '2025-08-16' 
-- and a.amount>0
AND mobile IN (SELECT DISTINCT mobile FROM dummy.BROD_BROD_1941_1690_1697_targeted_cutomers WHERE campaigncode='BROD_BROD_1941')
GROUP BY 1)a),

coupon_data AS (
SELECT 'BROD_BROD_1941' tag,COUNT(DISTINCT redeemedmobile)Redeemers,
SUM(amount)redemption_sales,COUNT(DISTINCT billno)redemptionbill,COUNT(DISTINCT couponcode)couponcode
FROM coupon_offer_report
WHERE useddate BETWEEN '2025-08-09' AND '2025-08-16' AND couponstatus='used' 
-- AND amount>0
AND issuedmobile NOT IN(SELECT DISTINCT mobile FROM dummy.BROD_BROD_1941_1690_1697_targeted_cutomers WHERE campaigncode='BROD_BROD_1941')
)
SELECT tag,mobile,sales,bills,visit,redeemers,redemption_sales,redemptionbill,couponcode FROM txn_data a JOIN coupon_data b USING(tag);


WITH txn_data AS (
SELECT 'BROD_BROD_1690' tag,COUNT(DISTINCT mobile)mobile,SUM(sales)sales,SUM(bills)bills,SUM(visit)visit FROM(
SELECT mobile,SUM(a.amount)sales,COUNT(DISTINCT uniquebillno)bills,
COUNT(DISTINCT txndate)visit 
FROM txn_report_accrual_redemption a
WHERE txndate BETWEEN '2025-06-06' AND '2025-06-13' 
-- and a.amount>0
AND mobile IN (SELECT mobile FROM dummy.BROD_BROD_1941_1690_1697_targeted_cutomers WHERE campaigncode='BROD_BROD_1690')
GROUP BY 1)a),

coupon_data AS (
SELECT 'BROD_BROD_1690' tag,COUNT(DISTINCT redeemedmobile)Redeemers,
SUM(amount)redemption_sales,COUNT(DISTINCT billno)redemptionbill,COUNT(DISTINCT couponcode)couponcode
FROM coupon_offer_report
WHERE useddate BETWEEN '2025-06-06' AND '2025-06-13' AND couponstatus='used' AND amount>0
AND issuedmobile IN(SELECT DISTINCT mobile FROM dummy.BROD_BROD_1941_1690_1697_targeted_cutomers WHERE campaigncode='BROD_BROD_1690')
)

SELECT tag,mobile,sales,bills,visit,redeemers,redemption_sales,redemptionbill,couponcode FROM txn_data a JOIN coupon_data b USING(tag);


WITH txn_data AS (
SELECT 'BROD_BROD_1697' tag,COUNT(DISTINCT mobile)mobile,SUM(sales)sales,SUM(bills)bills,SUM(visit)visit FROM(
SELECT mobile,SUM(a.amount)sales,COUNT(DISTINCT uniquebillno)bills,
COUNT(DISTINCT txndate)visit 
FROM txn_report_accrual_redemption a
WHERE txndate BETWEEN '2025-06-13' AND '2025-06-20' 
-- and a.amount>0
AND mobile IN (SELECT mobile FROM dummy.BROD_BROD_1941_1690_1697_targeted_cutomers WHERE campaigncode='BROD_BROD_1697')
GROUP BY 1)a),

coupon_data AS (
SELECT 'BROD_BROD_1697' tag,COUNT(DISTINCT redeemedmobile)Redeemers,
SUM(amount)redemption_sales,COUNT(DISTINCT billno)redemptionbill,COUNT(DISTINCT couponcode)couponcode
FROM coupon_offer_report
WHERE useddate BETWEEN '2025-06-13' AND '2025-06-20' AND couponstatus='used' AND amount>0
AND issuedmobile IN(SELECT DISTINCT mobile FROM dummy.BROD_BROD_1941_1690_1697_targeted_cutomers WHERE campaigncode='BROD_BROD_1697')
)

SELECT tag,mobile,sales,bills,visit,redeemers,redemption_sales,redemptionbill,couponcode FROM txn_data a JOIN coupon_data b USING(tag);









INSERT INTO dummy.BROD_BROD_1941_mapped_txn
SELECT DISTINCT mobile
FROM txn_report_accrual_redemption a
WHERE txndate BETWEEN '2025-08-09' AND '2025-08-16' 
-- and a.amount>0
AND mobile IN (SELECT DISTINCT mobile FROM dummy.BROD_BROD_1941_1690_1697_targeted_cutomers WHERE campaigncode='BROD_BROD_1941') ;



SELECT * FROM dummy.BROD_BROD_1941_targeted_customer a RIGHT JOIN dummy.BROD_BROD_1941_mapped_txn b USING(mobile)
WHERE b.mobile IS NULL ;


SELECT * FROM dummy.BROD_BROD_1941_mapped_txn


SELECT mobile,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2025-08-09' AND '2025-08-16' AND mobile IN ('7211111813',
'9760946332',
'9824766477'
)
GROUP BY 1;



-- date level 
SELECT 
    txndate AS 'Date',
    COUNT(DISTINCT uniquebillno) AS bills,
    COUNT(DISTINCT mobile) AS customers,
    SUM(amount) AS sales,
    COUNT(DISTINCT CASE WHEN DATEDIFF(insertiondate, txndate) = 0 THEN uniquebillno END) AS 'Bill Counts - updated on the same day',
    COUNT(DISTINCT CASE WHEN DATEDIFF(insertiondate, txndate) = 1 THEN uniquebillno END) AS 'Bill Counts - updated on +1 day',
    COUNT(DISTINCT CASE WHEN DATEDIFF(insertiondate, txndate) = 2 THEN uniquebillno END) AS 'Bill Counts - updated on +2 day',
    COUNT(DISTINCT CASE WHEN DATEDIFF(insertiondate, txndate) = 3 THEN uniquebillno END) AS 'Bill Counts - updated on +3 day',
    COUNT(DISTINCT CASE WHEN DATEDIFF(insertiondate, txndate) = 4 THEN uniquebillno END) AS 'Bill Counts - updated on +4 day',
    COUNT(DISTINCT CASE WHEN DATEDIFF(insertiondate, txndate) = 5 THEN uniquebillno END) AS 'Bill Counts - updated on +5 day',
    COUNT(DISTINCT CASE WHEN DATEDIFF(insertiondate, txndate) > 5 THEN uniquebillno END) AS 'Bill Counts - updated on >5 day'

FROM (
    SELECT DISTINCT 
        mobile, txndate, uniquebillno, amount, insertiondate
    FROM txn_report_accrual_redemption
    WHERE txndate BETWEEN '2025-07-01' AND '2025-08-20'
) a
GROUP BY 1
ORDER BY txndate;

