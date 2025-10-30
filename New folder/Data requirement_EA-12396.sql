


CREATE TABLE dummy.dump_till_31_aug_25
SELECT * FROM `txn_report_accrual_redemption`
WHERE ServerDateTime <='2025-08-31' 
AND storecode NOT LIKE '%demo%'
AND storecode NOT LIKE '%test%'
UNION
SELECT * FROM `txn_report_accrual_redemption_registered` 
WHERE ServerDateTime <='2025-08-31' 
AND storecode NOT LIKE '%demo%'
AND storecode NOT LIKE '%test%';#563349




SELECT CONCAT(LEFT(MONTHNAME(ServerDateTime),3),RIGHT(YEAR(ServerDateTime),2))PERIOD,
COUNT(DISTINCT b.mobile)mobile,SUM(amount)sales 
FROM dummy.enrolled_till_31aug_25 a JOIN dummy.dump_till_31_aug_25 b 
ON a.mobile=b.mobile 
-- and a.first_date=b.ServerDateTime
WHERE ServerDateTime BETWEEN '2025-04-01' AND '2025-08-31'
AND ServerDateTime > first_date
GROUP BY 1
ORDER BY ServerDateTime;

SELECT 
CONCAT(LEFT(MONTHNAME(ServerDateTime),3),RIGHT(YEAR(ServerDateTime),2))PERIOD,
COUNT(DISTINCT b.mobile)mobile,SUM(amount)sales 
FROM dummy.enrolled_till_31aug_25 a JOIN dummy.dump_till_31_aug_25 b 
ON a.mobile=b.mobile 
-- and a.first_date=b.ServerDateTime
WHERE ServerDateTime BETWEEN '2025-04-01' AND '2025-08-31'
AND ServerDateTime > first_date
GROUP BY 1;



SELECT COUNT(DISTINCT mobile)customer FROM dummy.enrolled_till_31aug_25
WHERE first_date BETWEEN '2025-04-01' AND '2025-08-31';


SELECT COUNT(DISTINCT mobile)customer FROM member_report
WHERE modifiedenrolledon BETWEEN '2025-04-01' AND '2025-08-31';


SELECT mobile,ServerDateTime,UniqueBillNo,FrequencyCount,PointsCollected,PointsSpent,amount,ModifiedBillNo
FROM `txn_report_accrual_redemption` WHERE ServerDateTime BETWEEN '2025-08-01' AND '2025-08-31' 
AND storecode NOT LIKE '%demo%'
AND storecode NOT LIKE '%test%';#29901



SELECT * FROM member_report;

CREATE TABLE dummy.enrolled_datatill_31_aug_25
SELECT DISTINCT mobile,modifiedenrolledon FROM 
`havellshappiness`.member_report
 WHERE ModifiedEnrolledOn <='2025-08-31'
 AND enrolledstore NOT LIKE '%demo%'
 UNION
 SELECT DISTINCT mobile,modifiedenrolledon FROM 
`havellshappiness`.`member_report_registered`
 WHERE ModifiedEnrolledOn <='2025-08-31'
 AND enrolledstore NOT LIKE '%demo%';#424159
 
 
 SELECT COUNT(DISTINCT mobile)EnrolledOn FROM 
`havellshappiness`.member_report
 WHERE ModifiedEnrolledOn BETWEEN '2025-08-01' AND '2025-08-31'
AND enrolledstore NOT LIKE '%demo%'
UNION 
SELECT COUNT(DISTINCT mobile)EnrolledOn FROM 
`havellshappiness`.`member_report_registered`
WHERE ModifiedEnrolledOn BETWEEN '2025-08-01' AND '2025-08-31'
AND enrolledstore NOT LIKE '%demo%')
 
SELECT MIN(ModifiedEnrolledOn) FROM member_report;


SELECT MONTHNAME(modifiedenrolledon)months,COUNT(DISTINCT mobile)customer FROM 
`havellshappiness`.member_report
WHERE ModifiedEnrolledOn BETWEEN '2025-04-01' AND '2025-08-31'
AND enrolledstore NOT LIKE '%demo%'GROUP BY 1
ORDER BY ModifiedEnrolledOn ;#216443

 SELECT 
--  MONTHNAME(modifiedenrolledon)months,
 COUNT(DISTINCT mobile)customer FROM dummy.enrolled_datatill_31_aug_25
 WHERE modifiedenrolledon BETWEEN '2024-04-01' AND '2025-03-31'
 GROUP BY 1
 ORDER BY ModifiedEnrolledOn;
 
 
 
 SELECT 
--  monthname(ServerDateTime)month,
 COUNT(DISTINCT mobile)repearter_customer,SUM(amount)sales 
 FROM dummy.dump_till_31_aug_25 a JOIN dummy.enrolled_datatill_31_aug_25 USING(mobile)
 WHERE ServerDateTime BETWEEN '2024-04-01' AND '2025-03-31'
 AND ServerDateTime > modifiedenrolledon 
 GROUP BY 1
 ORDER BY ServerDateTime;
 
SELECT * FROM `skuofferlog_itemstatus`;
 
