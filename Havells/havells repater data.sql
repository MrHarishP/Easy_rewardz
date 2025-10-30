SELECT * FROM member_report LIMIT 0, 1000; 
SELECT * FROM member_report_log LIMIT 0, 1000;

SHOW FULL TABLES FROM `havellshappiness` WHERE table_type = 'BASE TABLE'; 

SELECT * FROM member_report LIMIT 0, 1000; 

 SELECT * FROM `havells_member_report_registered` LIMIT 0, 1000; 
 
SELECT * FROM `member_report_registered` LIMIT 0, 1000; 
 
SELECT * FROM `txn_report_accrual_redemption` LIMIT 0, 1000; 

 SELECT * FROM `txn_report_accrual_redemption_registered` LIMIT 0, 1000; 
 SELECT * FROM `sku_report_loyalty` LIMIT 0, 1000; 
 SELECT * FROM `skuofferlog_itemstatus` LIMIT 0, 1000; 
SELECT * FROM `temp_sku_nonloyalty_to_loyalty`;  LIMIT 0, 1000; 

SELECT * FROM `temp_sku_nonloyalty_to_loyalty` LIMIT 0, 1000; 
SELECT * FROM `sku_report_loyalty` LIMIT 0, 1000; 
SELECT * FROM `sku_basket` LIMIT 0, 1000; 
SELECT * FROM `skuofferlog_itemstatus` LIMIT 0, 1000; 
SELECT * FROM `member_report_registered` LIMIT 0, 1000; 
 SELECT * FROM `sku_report_loyalty` LIMIT 0, 1000; 
SELECT * FROM `sku_basket` LIMIT 0, 1000; 
 
SELECT COUNT(DISTINCT mobile)EnrolledOn FROM `havellshappiness`.member_report 
WHERE ModifiedEnrolledOn BETWEEN '2024-04-01' AND '2025-03-31' AND enrolledstore NOT LIKE '%demo%' ; 

SELECT * FROM member_report LIMIT 0, 1000; 

SELECT DISTINCT mobile,modifiedenrolledon FROM `havellshappiness`.member_report
 WHERE ModifiedEnrolledOn BETWEEN '2024-04-01' AND '2025-03-31' AND enrolledstore NOT LIKE '%demo%' LIMIT 0, 1000; 

SELECT DISTINCT mobile,modifiedenrolledon FROM `havellshappiness`.member_report 
WHERE ModifiedEnrolledOn BETWEEN '2024-04-01' AND '2025-03-31' AND enrolledstore NOT LIKE '%demo%'; 


SELECT * FROM `txn_report_accrual_redemption` 
WHERE ServerDateTime BETWEEN '2024-04-01' AND '2025-08-31' 
AND storecode NOT LIKE '%demo%' AND storecode NOT LIKE '%test%' LIMIT 0, 1000; 

SELECT * FROM `txn_report_accrual_redemption` 
WHERE ServerDateTime BETWEEN '2024-04-01' AND '2025-08-31' 
AND storecode NOT LIKE '%demo%' AND storecode NOT LIKE '%test%'; 


SELECT * FROM `txn_report_accrual_redemption` 
WHERE ServerDateTime BETWEEN '2024-04-01' AND '2025-08-31' AND storecode NOT LIKE '%demo%' 
AND storecode NOT LIKE '%test%' 
UNION 
SELECT * FROM `txn_report_accrual_redemption_registered` 
WHERE ServerDateTime BETWEEN '2025-08-01' AND '2025-08-31' 
AND storecode NOT LIKE '%demo%' AND storecode NOT LIKE '%test%' LIMIT 0, 1000; 



SELECT * FROM `txn_report_accrual_redemption`
 WHERE ServerDateTime BETWEEN '2024-04-01' AND '2025-08-31' AND storecode NOT LIKE '%demo%' AND storecode NOT LIKE '%test%' 
 UNION 
 SELECT * FROM `txn_report_accrual_redemption_registered` 
 WHERE ServerDateTime BETWEEN '2025-08-01' AND '2025-08-31' 
 AND storecode NOT LIKE '%demo%' AND storecode NOT LIKE '%test%'; 


/*[17-Sep 16:10:48][160 ms]*/ 
SELECT mobile,MIN(ServerDateTime)first_date FROM `txn_report_accrual_redemption` 
WHERE ServerDateTime BETWEEN '2025-08-01' AND '2025-08-31' AND storecode NOT LIKE '%demo%' 
AND storecode NOT LIKE '%test%' GROUP BY 1 LIMIT 0, 1000; 



/*[17-Sep 16:10:52][136 ms]*/ 
SELECT mobile,MIN(ServerDateTime)first_date 
FROM `txn_report_accrual_redemption` 
WHERE ServerDateTime BETWEEN '2025-08-01' AND '2025-08-31' 
AND storecode NOT LIKE '%demo%' AND storecode NOT LIKE '%test%' GROUP BY 1; 

/*[17-Sep 16:11:06][49 ms]*/ 
SELECT mobile,MIN(ServerDateTime)first_date FROM `txn_report_accrual_redemption` 
WHERE ServerDateTime <='2025-08-31' AND storecode NOT LIKE '%demo%' AND storecode NOT LIKE '%test%' 
GROUP BY 1 LIMIT 0, 1000; 


/*[17-Sep 16:11:11][554 ms]*/ 
SELECT mobile,MIN(ServerDateTime)first_date FROM `txn_report_accrual_redemption` 
WHERE ServerDateTime <='2025-08-31' AND storecode NOT LIKE '%demo%' AND storecode NOT LIKE '%test%' 
GROUP BY 1; 

/*[17-Sep 16:13:38][219 ms]*/ 

CREATE TABLE dummy.enrolled SELECT mobile,MIN(ServerDateTime)first_date 
FROM `txn_report_accrual_redemption` WHERE ServerDateTime <='2025-08-31' 
AND storecode NOT LIKE '%demo%' AND storecode NOT LIKE '%test%' AND 1=0 
GROUP BY 1; 

/*[17-Sep 16:13:56][4203 ms]*/ 
INSERT INTO dummy.enrolled SELECT mobile,MIN(ServerDateTime)first_date 
FROM `txn_report_accrual_redemption` 
WHERE ServerDateTime <='2025-08-31' AND storecode NOT LIKE '%demo%' 
AND storecode NOT LIKE '%test%' GROUP BY 1; 


/*[17-Sep 16:16:11][157 ms] SQLyog reconnected */ 

/*[17-Sep 16:16:37][25448 ms]*/ 
CREATE TABLE dummy.dump SELECT * FROM `txn_report_accrual_redemption` 
WHERE ServerDateTime <='2025-08-31' AND storecode NOT LIKE '%demo%' AND storecode NOT LIKE '%test%' 
UNION 
SELECT * FROM `txn_report_accrual_redemption_registered` 
WHERE ServerDateTime <='2025-08-31' AND storecode NOT LIKE '%demo%' AND storecode NOT LIKE '%test%' AND 1=0; 


/*[17-Sep 16:17:39][26382 ms]*/ 
CREATE TABLE dummy.dump_till_31_aug_25 
SELECT * FROM `txn_report_accrual_redemption` 
WHERE ServerDateTime <='2025-08-31' AND storecode NOT LIKE '%demo%' 
AND storecode NOT LIKE '%test%' 
UNION 
SELECT * FROM `txn_report_accrual_redemption_registered` 
WHERE ServerDateTime <='2025-08-31' AND storecode NOT LIKE '%demo%' 
AND storecode NOT LIKE '%test%'; 


/*[17-Sep 16:18:56][496 ms] SQLyog reconnected */ 
/*[17-Sep 16:19:02][6136 ms]*/ 
CREATE TABLE dummy.enrolled_till_31aug_25 
SELECT mobile,MIN(ServerDateTime)first_date FROM dummy.dump_till_31_aug_25 
WHERE ServerDateTime <='2025-08-31' AND storecode NOT LIKE '%demo%' 
AND storecode NOT LIKE '%test%' GROUP BY 1; 

 
/*[17-Sep 16:31:02][33 ms]*/ 
SELECT COUNT(DISTINCT mobile)mobile,SUM(amount)sales 
FROM dummy.enrolled_till_31aug_25 a JOIN dummy.dump_till_31_aug_25 b ON a.mobile=b.mobile AND a.first_date=b.ServerDateTime 
WHERE ServerDateTime BETWEEN '2024-04-01' AND '2025-03-31' LIMIT 0, 1000; 

/*[17-Sep 16:31:30][850 ms]*/ 
SELECT COUNT(DISTINCT b.mobile)mobile,SUM(amount)sales 
FROM dummy.enrolled_till_31aug_25 a JOIN dummy.dump_till_31_aug_25 b ON a.mobile=b.mobile AND a.first_date=b.ServerDateTime 
WHERE ServerDateTime BETWEEN '2024-04-01' AND '2025-03-31' AND ServerDateTime > first_date LIMIT 0, 1000; 

/*[17-Sep 16:31:59][1369 ms]*/ 
SELECT COUNT(DISTINCT b.mobile)mobile,SUM(amount)sales FROM dummy.enrolled_till_31aug_25 a JOIN dummy.dump_till_31_aug_25 b ON a.mobile=b.mobile 
WHERE ServerDateTime BETWEEN '2024-04-01' AND '2025-03-31' 
AND ServerDateTime > first_date LIMIT 0, 1000; 

/*[17-Sep 16:45:55][2278 ms]*/ 
SELECT CONCAT(LEFT(MONTHNAME(ServerDateTime),3),RIGHT(YEAR(ServerDateTime),2))PERIOD, 
COUNT(DISTINCT b.mobile)mobile,SUM(amount)sales FROM dummy.enrolled_till_31aug_25 a JOIN dummy.dump_till_31_aug_25 b ON a.mobile=b.mobile 
WHERE ServerDateTime BETWEEN '2024-04-01' AND '2025-03-31' 
AND ServerDateTime > first_date 
GROUP BY 1 LIMIT 0, 1000; 


/*[17-Sep 16:46:38][1403 ms]*/ 
SELECT CONCAT(LEFT(MONTHNAME(ServerDateTime),3),RIGHT(YEAR(ServerDateTime),2))PERIOD,
COUNT(DISTINCT b.mobile)mobile,SUM(amount)sales FROM dummy.enrolled_till_31aug_25 a JOIN dummy.dump_till_31_aug_25 b ON a.mobile=b.mobile 
WHERE ServerDateTime BETWEEN '2025-04-01' AND '2025-08-31' 
AND ServerDateTime > first_date GROUP BY 1 LIMIT 0, 1000;

 
/*[17-Sep 16:47:09][1474 ms]*/ 
SELECT CONCAT(LEFT(MONTHNAME(ServerDateTime),3),RIGHT(YEAR(ServerDateTime),2))PERIOD, 
COUNT(DISTINCT b.mobile)mobile,SUM(amount)sales 
FROM dummy.enrolled_till_31aug_25 a JOIN dummy.dump_till_31_aug_25 b ON a.mobile=b.mobile 
WHERE ServerDateTime BETWEEN '2025-04-01' AND '2025-08-31' AND ServerDateTime > first_date 
GROUP BY 1 
ORDER BY ServerDateTime LIMIT 0, 1000;

 
/*[17-Sep 16:48:52][321 ms] SQLyog reconnected */ 
/*[17-Sep 16:48:54][2127 ms]*/ 

SELECT COUNT(DISTINCT b.mobile)mobile,SUM(amount)sales 
FROM dummy.enrolled_till_31aug_25 a JOIN dummy.dump_till_31_aug_25 b ON a.mobile=b.mobile 
WHERE ServerDateTime BETWEEN '2025-04-01' AND '2025-08-31' AND ServerDateTime > first_date LIMIT 0, 1000; 
/*[17-Sep 16:50:23][576 ms]*/ SELECT COUNT(DISTINCT mobile)customer FROM dummy.enrolled_till_31aug_25 
WHERE first_date BETWEEN '2025-04-01' AND '2025-08-31' LIMIT 0, 1000; 


/*[17-Sep 16:51:00][1474 ms]*/ 

SELECT COUNT(DISTINCT mobile)customer FROM member_report 
WHERE modifiedenrolledon BETWEEN '2025-04-01' AND '2025-08-31' LIMIT 0, 1000; 



SELECT * FROM member_report LIMIT 0, 1000; 
/*[17-Sep 17:00:01][50 ms]*/ 

SELECT DISTINCT mobile,modifiedenrolledon 
FROM `havellshappiness`.member_report 
WHERE ModifiedEnrolledOn <='2025-03-31' 
AND enrolledstore NOT LIKE '%demo%' LIMIT 0, 1000; 


/*[17-Sep 17:00:05][1093 ms]*/ 

SELECT DISTINCT mobile,modifiedenrolledon 
FROM `havellshappiness`.member_report 
WHERE ModifiedEnrolledOn <='2025-03-31' AND enrolledstore NOT LIKE '%demo%'; 


/*[17-Sep 17:01:01][2739 ms]*/ 

CREATE TABLE dummy.enrolled_data 
SELECT DISTINCT mobile,modifiedenrolledon FROM `havellshappiness`.member_report 
WHERE ModifiedEnrolledOn <='2025-03-31' AND enrolledstore NOT LIKE '%demo%'; 

/*[17-Sep 17:01:37][51 ms]*/ 
SELECT * FROM dummy.dump_till_31_aug_25 LIMIT 0, 1000; 

/*[17-Sep 17:02:38][883 ms]*/ 

SELECT COUNT(DISTINCT mobile)customer FROM dummy.enrolled_data 
WHERE modifiedenrolledon BETWEEN '2024-04-01' AND '2025-03-31' LIMIT 0, 1000; 


/*[17-Sep 17:03:45][184 ms] SQLyog reconnected */ 

/*[17-Sep 17:03:46][994 ms]*/ SELECT COUNT(DISTINCT mobile)customer 
FROM `havellshappiness`.member_report WHERE ModifiedEnrolledOn 
BETWEEN '2024-04-01' AND '2025-03-31' AND enrolledstore NOT LIKE '%demo%' LIMIT 0, 1000; 


/*[17-Sep 17:03:46][35 ms]*/ #216443 ; 

/*[17-Sep 17:04:07][45 ms]*/ 
SELECT MIN (ModifiedEnrolledOn) FROM member_report LIMIT 0, 1000; 


/*[17-Sep 17:04:15][37 ms]*/ 

SELECT MIN(ModifiedEnrolledOn) FROM member_report LIMIT 0, 1000; 


/*[17-Sep 17:09:28][2018 ms]*/ 
SELECT COUNT(DISTINCT mobile)customer FROM dummy.enrolled_data 
WHERE modifiedenrolledon BETWEEN '2024-04-01' AND '2025-03-31' LIMIT 0, 1000; 


/*[17-Sep 17:09:40][603 ms]*/ 
SELECT COUNT(DISTINCT mobile)customer FROM dummy.enrolled_data 
WHERE modifiedenrolledon BETWEEN '2024-04-01' AND '2025-04-30' LIMIT 0, 1000; 


/*[17-Sep 17:10:04][1288 ms]*/ 

SELECT COUNT(DISTINCT mobile)customer FROM `havellshappiness`.member_report 
WHERE ModifiedEnrolledOn BETWEEN '2024-04-01' AND '2025-04-30' 
AND enrolledstore NOT LIKE '%demo%' LIMIT 0, 1000; 


/*[17-Sep 17:10:04][38 ms]*/ #216443 ; 
/*[17-Sep 17:10:27][1448 ms]*/ 

SELECT COUNT(DISTINCT mobile)customer FROM `havellshappiness`.member_report 
WHERE ModifiedEnrolledOn BETWEEN '2024-04-01' AND '2025-05-30' 
AND enrolledstore NOT LIKE '%demo%' LIMIT 0, 1000; 


/*[17-Sep 17:10:27][29 ms]*/ #216443 ; 


/*[17-Sep 17:10:41][1323 ms]*/ 

SELECT COUNT(DISTINCT mobile)customer FROM `havellshappiness`.member_report 
WHERE ModifiedEnrolledOn BETWEEN '2024-04-01' AND '2025-05-31' AND enrolledstore NOT LIKE '%demo%' LIMIT 0, 1000; 


/*[17-Sep 17:10:41][32 ms]*/ #216443 ; 
/*[17-Sep 17:10:56][1628 ms]*/ 

SELECT COUNT(DISTINCT mobile)customer 
FROM `havellshappiness`.member_report 
WHERE ModifiedEnrolledOn BETWEEN '2024-04-01' AND '2025-06-30' 
AND enrolledstore NOT LIKE '%demo%' LIMIT 0, 1000; 


/*[17-Sep 17:10:57][33 ms]*/ #216443 ; 
/*[17-Sep 17:11:13][1810 ms]*/ 

SELECT COUNT(DISTINCT mobile)customer 
FROM `havellshappiness`.member_report WHERE ModifiedEnrolledOn BETWEEN '2024-04-01' AND '2025-07-31' 
AND enrolledstore NOT LIKE '%demo%' LIMIT 0, 1000; 


/*[17-Sep 17:11:13][136 ms]*/ #216443 ; 


/*[17-Sep 17:11:27][2283 ms]*/ 

SELECT COUNT(DISTINCT mobile)customer FROM `havellshappiness`.member_report 
WHERE ModifiedEnrolledOn BETWEEN '2024-04-01' AND '2025-08-31' 
AND enrolledstore NOT LIKE '%demo%' LIMIT 0, 1000; 


/*[17-Sep 17:11:27][199 ms]*/ #216443 ; 


/*[17-Sep 17:12:07][515 ms]*/ 

SELECT COUNT(DISTINCT mobile)customer FROM dummy.enrolled_data LIMIT 0, 1000; 


/*[17-Sep 17:13:02][1317 ms]*/ 

SELECT MONTHNAME(modifiedenrolledon),COUNT(DISTINCT mobile)customer 
FROM `havellshappiness`.member_report 
WHERE ModifiedEnrolledOn BETWEEN '2025-04-01' AND '2025-08-31' 
AND enrolledstore NOT LIKE '%demo%' 
GROUP BY 1 LIMIT 0, 1000; 



/*[17-Sep 17:13:43][296 ms]*/ 

SELECT MONTHNAME(modifiedenrolledon),COUNT(DISTINCT mobile)customer 
FROM `havellshappiness`.member_report WHERE ModifiedEnrolledOn BETWEEN '2025-04-01' AND '2025-04-30'
 AND enrolledstore NOT LIKE '%demo%'
 GROUP BY 1 LIMIT 0, 1000; 
 
 
/*[17-Sep 17:13:43][45 ms]*/ #216443 ; 

/*[17-Sep 17:14:12][223 ms]*/ 

SELECT MONTHNAME(modifiedenrolledon),COUNT(DISTINCT mobile)customer 
FROM `havellshappiness`.member_report WHERE ModifiedEnrolledOn BETWEEN '2025-04-01' AND '2025-04-30' 
AND enrolledstore NOT LIKE '%demo%' 
GROUP BY 1 ORDER BY ModifiedEnrolledOn LIMIT 0, 1000; 





/*[17-Sep 17:14:16][274 ms]*/ 

SELECT MONTHNAME(modifiedenrolledon),COUNT(DISTINCT mobile)customer 
FROM `havellshappiness`.member_report 
WHERE ModifiedEnrolledOn BETWEEN '2025-04-01' AND '2025-04-30' 
AND enrolledstore NOT LIKE '%demo%' 
GROUP BY 1 ORDER BY ModifiedEnrolledOn LIMIT 0, 1000; 
/*[17-Sep 17:14:23][750 ms]*/ 

SELECT MONTHNAME(modifiedenrolledon),COUNT(DISTINCT mobile)customer 
FROM `havellshappiness`.member_report WHERE ModifiedEnrolledOn BETWEEN '2025-04-01' AND '2025-08-31' 
AND enrolledstore NOT LIKE '%demo%'
GROUP BY 1 ORDER BY ModifiedEnrolledOn LIMIT 0, 1000; 


/*[17-Sep 17:14:37][823 ms]*/ 
SELECT MONTHNAME(modifiedenrolledon)months,COUNT(DISTINCT mobile)customer 
FROM `havellshappiness`.member_report WHERE ModifiedEnrolledOn BETWEEN '2025-04-01' AND '2025-08-31' 
AND enrolledstore NOT LIKE '%demo%'GROUP BY 1 ORDER BY ModifiedEnrolledOn LIMIT 0, 1000; 


/*[17-Sep 17:14:37][32 ms]*/ #216443 ; 

/*[17-Sep 17:16:04][810 ms]*/ 

SELECT MONTHNAME(modifiedenrolledon)months, COUNT(DISTINCT mobile)customer 
FROM dummy.enrolled_data WHERE modifiedenrolledon BETWEEN '2024-04-01' AND '2025-08-31' LIMIT 0, 1000; 


/*[17-Sep 17:16:29][245 ms]*/ 

SELECT MONTHNAME(modifiedenrolledon)months, COUNT(DISTINCT mobile)customer 
FROM dummy.enrolled_data WHERE modifiedenrolledon BETWEEN '2025-04-01' AND '2025-08-31' 
GROUP BY 1 ORDER BY ModifiedEnrolledOn LIMIT 0, 1000; 


/*[17-Sep 17:16:40][308 ms]*/ 

SELECT MONTHNAME(modifiedenrolledon)months, COUNT(DISTINCT mobile)customer 
FROM dummy.enrolled_data WHERE modifiedenrolledon BETWEEN '2025-04-01' AND '2025-08-31' 
GROUP BY 1 ORDER BY ModifiedEnrolledOn LIMIT 0, 1000; 


/*[17-Sep 17:17:18][4947 ms]*/ 

CREATE TABLE dummy.enrolled_data_till_31_aug_25 
SELECT DISTINCT mobile,modifiedenrolledon 
FROM `havellshappiness`.member_report WHERE ModifiedEnrolledOn <='2025-08-31' AND enrolledstore NOT LIKE '%demo%'; 


/*[17-Sep 17:17:18][31 ms]*/ #216443 ; 
/*[17-Sep 17:19:43][226 ms] SQLyog reconnected */ 
/*[17-Sep 17:19:45][1933 ms]*/ 

SELECT MONTHNAME(modifiedenrolledon)months, COUNT(DISTINCT mobile)customer 
FROM dummy.enrolled_data_till_31_aug_25 WHERE modifiedenrolledon BETWEEN '2025-04-01' AND '2025-08-31' 
GROUP BY 1 ORDER BY ModifiedEnrolledOn LIMIT 0, 1000; 


/*[17-Sep 17:22:13][191 ms] SQLyog reconnected */ 
/*[17-Sep 17:22:13][32 ms]*/ 

SELECT * FROM dummy.dump_till_31_aug_25 LIMIT 0, 1000; 


/*[17-Sep 17:26:57][255 ms] SQLyog reconnected */ 
/*[17-Sep 17:26:57][36 ms]*/ 

SELECT COUNT(DISTINCT mobile)repearter_customer,SUM(amount)sales 
FROM dummy.dump_till_31_aug_25 a JOIN dummy.enrolled_data_till_31_aug_25 USING(mobile) 
WHERE ServerDateTime BETWEEN '2024-04-01' AND '2025-03-31' 
AND ServerDateTime > first_date LIMIT 0, 1000; 



/*[17-Sep 17:27:09][34 ms]*/ 

SELECT COUNT(DISTINCT mobile)repearter_customer,SUM(amount)sales 
FROM dummy.dump_till_31_aug_25 a JOIN dummy.enrolled_data_till_31_aug_25 USING(mobile)
 WHERE ServerDateTime BETWEEN '2024-04-01' AND '2025-03-31'
  AND ServerDateTime > modifiedenrolledon 
 GROUP BY 1 LIMIT 0, 1000; 
 
 
 /*[17-Sep 17:27:17][3004 ms]*/ 
 
 SELECT COUNT(DISTINCT mobile)repearter_customer,SUM(amount)sales 
 FROM dummy.dump_till_31_aug_25 a JOIN dummy.enrolled_data_till_31_aug_25 USING(mobile) 
 WHERE ServerDateTime BETWEEN '2024-04-01' AND '2025-03-31' AND ServerDateTime > modifiedenrolledon LIMIT 0, 1000; 
 
 
/*[17-Sep 17:28:36][2416 ms]*/ 
SELECT MONTHNAME(ServerDateTime)MONTH,COUNT(DISTINCT mobile)repearter_customer,SUM(amount)sales 
FROM dummy.dump_till_31_aug_25 a JOIN dummy.enrolled_data_till_31_aug_25 USING(mobile) 
WHERE ServerDateTime BETWEEN '2025-04-01' AND '2025-08-31' AND ServerDateTime > modifiedenrolledon 
GROUP BY 1 LIMIT 0, 1000;

 
/*[17-Sep 17:28:51][1674 ms]*/ 
SELECT MONTHNAME(ServerDateTime)MONTH,COUNT(DISTINCT mobile)repearter_customer,SUM(amount)sales 
FROM dummy.dump_till_31_aug_25 a JOIN dummy.enrolled_data_till_31_aug_25 USING(mobile) 
WHERE ServerDateTime BETWEEN '2025-04-01' AND '2025-08-31' AND ServerDateTime > modifiedenrolledon 
GROUP BY 1 ORDER BY ServerDateTime LIMIT 0, 1000; 



/*[17-Sep 17:47:18][4582 ms]*/
 SELECT DISTINCT mobile,modifiedenrolledon 
 FROM `havellshappiness`.`member_report_registered` 
 WHERE ModifiedEnrolledOn <='2025-08-31' AND enrolledstore NOT LIKE '%demo%' LIMIT 0, 1000; 
 
 
 
/*[17-Sep 17:47:21][391 ms]*/ 
SELECT DISTINCT mobile,modifiedenrolledon 
FROM `havellshappiness`.`member_report_registered` 
WHERE ModifiedEnrolledOn <='2025-08-31' AND enrolledstore NOT LIKE '%demo%'; 


/*[17-Sep 17:47:38][2047 ms]*/ 

SELECT DISTINCT mobile,modifiedenrolledon FROM `havellshappiness`.member_report 
WHERE ModifiedEnrolledOn <='2025-08-31' AND enrolledstore NOT LIKE '%demo%' 

UNION 

SELECT DISTINCT mobile,modifiedenrolledon FROM `havellshappiness`.`member_report_registered` 
WHERE ModifiedEnrolledOn <='2025-08-31' AND enrolledstore NOT LIKE '%demo%' LIMIT 0, 1000; 


/*[17-Sep 17:47:45][3531 ms]*/ 

SELECT DISTINCT mobile,modifiedenrolledon FROM `havellshappiness`.member_report 
WHERE ModifiedEnrolledOn <='2025-08-31' AND enrolledstore NOT LIKE '%demo%' 

UNION 

SELECT DISTINCT mobile,modifiedenrolledon FROM `havellshappiness`.`member_report_registered` 
WHERE ModifiedEnrolledOn <='2025-08-31' AND enrolledstore NOT LIKE '%demo%'; 


/*[17-Sep 17:48:07][201 ms] SQLyog reconnected */ 


/*[17-Sep 17:48:14][6481 ms]*/ 

CREATE TABLE dummy.enrolled_datatill_31_aug_25 
SELECT DISTINCT mobile,modifiedenrolledon FROM `havellshappiness`.member_report 
WHERE ModifiedEnrolledOn <='2025-08-31' AND enrolledstore NOT LIKE '%demo%' 

UNION 

SELECT DISTINCT mobile,modifiedenrolledon FROM `havellshappiness`.`member_report_registered` 
WHERE ModifiedEnrolledOn <='2025-08-31' AND enrolledstore NOT LIKE '%demo%';

 
/*[17-Sep 17:48:14][31 ms]*/ #414280 ; 
/*[17-Sep 17:48:32][1904 ms]*/ 

SELECT MONTHNAME(ServerDateTime)MONTH,COUNT(DISTINCT mobile)repearter_customer,SUM(amount)sales 
FROM dummy.dump_till_31_aug_25 a JOIN dummy.enrolled_datatill_31_aug_25 USING(mobile) 
WHERE ServerDateTime BETWEEN '2025-04-01' AND '2025-08-31' AND ServerDateTime > modifiedenrolledon 
GROUP BY 1 ORDER BY ServerDateTime LIMIT 0, 1000; 


/*[17-Sep 17:49:40][1866 ms]*/ 

SELECT COUNT(DISTINCT mobile)repearter_customer,SUM(amount)sales 
FROM dummy.dump_till_31_aug_25 a JOIN dummy.enrolled_datatill_31_aug_25 USING(mobile) 
WHERE ServerDateTime BETWEEN '2024-04-01' AND '2025-03-31' AND ServerDateTime > modifiedenrolledon LIMIT 0, 1000; 

/*[17-Sep 17:50:20][726 ms]*/

 SELECT MONTHNAME(modifiedenrolledon)months, COUNT(DISTINCT mobile)customer 
 FROM dummy.enrolled_datatill_31_aug_25 WHERE modifiedenrolledon BETWEEN '2025-04-01' AND '2025-08-31' 
 GROUP BY 1 ORDER BY ModifiedEnrolledOn LIMIT 0, 1000; 
 
 
/*[17-Sep 17:51:01][802 ms]*/ 

SELECT COUNT(DISTINCT mobile)customer FROM dummy.enrolled_datatill_31_aug_25 
WHERE modifiedenrolledon BETWEEN '2024-04-01' AND '2025-03-31' LIMIT 0, 1000; 
/*[17-Sep 18:09:48][195 ms] SQLyog reconnected */ 
/*[17-Sep 18:09:49][705 ms]*/ 

SELECT MAX(ServerDateTime) FROM dummy.dump_till_31_aug_25 LIMIT 0, 1000; 