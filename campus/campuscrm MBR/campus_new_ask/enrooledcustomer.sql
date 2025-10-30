-- 1st July'22 - 30th June'23
SELECT 
COUNT(mobile) 
FROM member_report WHERE ModifiedEnrolledOn  BETWEEN '2023-04-01' AND '2023-06-30'
AND EnrolledStoreCode NOT LIKE '%demo%'
AND EnrolledStoreCode NOT LIKE '%test%'
AND EnrolledStoreCode NOT IN ('Corporate');

-- 1st July'23 - 30th June'24

SELECT 
COUNT(mobile) 
FROM member_report WHERE ModifiedEnrolledOn  BETWEEN '2023-07-01' AND '2024-06-30'
AND EnrolledStoreCode NOT LIKE '%demo%'
AND EnrolledStoreCode NOT LIKE '%test%'
AND EnrolledStoreCode NOT IN ('Corporate');#729362

-- 1st July'24 - 30th June'25
SELECT 
COUNT(mobile) 
FROM member_report WHERE ModifiedEnrolledOn  BETWEEN '2024-07-01' AND '2025-06-30'
AND EnrolledStoreCode NOT LIKE '%demo%'
AND EnrolledStoreCode NOT LIKE '%test%'
AND EnrolledStoreCode NOT IN ('Corporate');#769640

-- 1st Apr'25 - 30th June'25


SELECT 
COUNT(mobile) 
FROM member_report WHERE ModifiedEnrolledOn  BETWEEN '2025-04-01' AND '2025-06-30'
AND EnrolledStoreCode NOT LIKE '%demo%'
AND EnrolledStoreCode NOT LIKE '%test%'
AND EnrolledStoreCode NOT IN ('Corporate');#769640

-- 1st Apr'25 - 30th June'25
SELECT 
COUNT(mobile) 
FROM member_report 
WHERE ModifiedEnrolledOn  BETWEEN '2025-04-01' AND '2025-06-30'
AND EnrolledStoreCode NOT LIKE '%demo%'
AND EnrolledStoreCode NOT LIKE '%test%';


-- ______________Offline____________

SELECT 
COUNT(mobile) 
FROM member_report WHERE ModifiedEnrolledOn  BETWEEN '2022-07-01' AND '2023-06-30'
AND EnrolledStoreCode NOT LIKE '%demo%'
AND EnrolledStoreCode NOT LIKE '%test%'
AND EnrolledStoreCode<>'ecom'  ;

