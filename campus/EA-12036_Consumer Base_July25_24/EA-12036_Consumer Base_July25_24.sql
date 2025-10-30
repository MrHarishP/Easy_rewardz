#######################################################################################################
-- main query 
CREATE TABLE dummy.campus_EA_12036_july_25
SELECT 
CASE 
	WHEN city IN('Delhi','Gurgaon','Gurugram','Faridabad',
		'Ghaziabad','Noida','Delhi NCR')  THEN 'delhi ncr' 
	WHEN city IN ('Pune','Mumbai',
	'Aurangabad','Nagpur','Kalyan','Nashik','Panvel',
	'CHANDRAPUR','Satara','Baramati','Solapur') 
	THEN 'Maharashtra' 
END city,
storetype1,a.mobile mobile FROM txn_report_accrual_redemption a 
JOIN program_single_view b ON a.mobile=b.mobile AND a.storecode =b.`last shopped store`
JOIN store_master c ON a.storecode=c.storecode
WHERE txndate <='2025-04-30' AND storetype1 IN ('coco','fofo') AND city IN ('Pune','Mumbai',
	'Aurangabad','Nagpur','Kalyan','Nashik','Panvel',
	'CHANDRAPUR','Satara','Baramati','Solapur','Delhi','Gurgaon','Gurugram','Faridabad',
		'Ghaziabad','Noida','Delhi NCR')
AND a.mobile IN (SELECT DISTINCT mobile FROM member_report WHERE smsreachability='true')
-- AND a.mobile COLLATE utf8mb4_0900_ai_ci  NOT IN (SELECT mobile FROM `responders_data`
-- WHERE contactdate >= '2025-07-01') AND b.`last shopped store` NOT IN ('demo','corporate') 	
GROUP BY 1,2,3;

-- this table is created so use this for that time otherwise not same logic or query is used in this table which is created in above 
ALTER TABLE dummy.campus_EA_12036_july_25_1 ADD INDEX mobile(mobile); 


SHOW PROCESSLIST;

KILL 10445652;

SELECT * FROM dummy.campus_EA_12036_july_25_1;

-- remove from DND customre who are not in sms reacheability 
SELECT city,storetype1,COUNT(DISTINCT mobile)customer FROM dummy.campus_EA_12036_july_25_1
WHERE mobile IN (SELECT DISTINCT mobile FROM member_report WHERE smsreachability='true')
-- AND mobile COLLATE utf8mb4_0900_ai_ci  NOT IN (SELECT mobile FROM `responders_data`
-- WHERE contactdate >= '2025-07-01')
GROUP BY 1,2;


SELECT mobile,DATEDIFF(MAX(txndate),MIN(txndate))/ISNULL((COUNT(DISTINCT txndate)-1),0)latency
FROM txn_report_accrual_redemption 
GROUP BY 1