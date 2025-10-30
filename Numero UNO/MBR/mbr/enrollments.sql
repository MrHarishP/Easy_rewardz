SET @startdate = DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-01');
SET @enddate = LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH));
SET @startdate_1 = DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 2 MONTH), '%Y-%m-01');
SET @enddate_1 = LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 2 MONTH));
SET @startdate_1y = DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 13 MONTH), '%Y-%m-01');
SET @enddate_1y = LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 13 MONTH));



SELECT @startdate,@enddate,@startdate_1,@enddate_1,@startdate_1y,@enddate_1y;

SELECT CONCAT(MONTHNAME(modifiedenrolledon),YEAR(modifiedenrolledon)) AS PERIOD,
COUNT(DISTINCT CASE WHEN enrolledstorecode IN ('ECOM','corporate') THEN mobile END) AS 'ECOM',
COUNT(DISTINCT CASE WHEN enrolledstorecode NOT IN ('ECOM','corporate') THEN mobile END) AS 'OFFLINE',
COUNT(DISTINCT mobile) AS Over_All 
FROM `numerouno`.member_report 
WHERE enrolledstorecode NOT LIKE '%demo%'
AND modifiedenrolledon BETWEEN  @startdate_1y AND @enddate_1y
UNION
-- Prev Month MBR
SELECT CONCAT(MONTHNAME(modifiedenrolledon),YEAR(modifiedenrolledon)) AS PERIOD,
COUNT(DISTINCT CASE WHEN enrolledstorecode IN ('ECOM','corporate') THEN mobile END) AS 'ECOM',
COUNT(DISTINCT CASE WHEN enrolledstorecode NOT IN ('ECOM','corporate') THEN mobile END) AS 'OFFLINE',
COUNT(DISTINCT mobile) AS Over_All 
FROM `numerouno`.member_report 
WHERE enrolledstorecode NOT LIKE '%demo%'
AND modifiedenrolledon BETWEEN  @startdate_1 AND @enddate_1
UNION
-- current MBR
SELECT CONCAT(MONTHNAME(modifiedenrolledon),YEAR(modifiedenrolledon)) AS PERIOD,
COUNT(DISTINCT CASE WHEN enrolledstorecode IN ('ECOM','corporate') THEN mobile END) AS 'ECOM',
COUNT(DISTINCT CASE WHEN enrolledstorecode NOT IN ('ECOM','corporate') THEN mobile END) AS 'OFFLINE',
COUNT(DISTINCT mobile) AS Over_All 
FROM `numerouno`.member_report 
WHERE enrolledstorecode NOT LIKE '%demco%'
AND modifiedenrolledon BETWEEN @startdate AND @enddate
AND insertiondate<CURDATE();

SELECT * FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2025-08-01' AND '2025-08-31';

SELECT * FROM member_report
WHERE modifiedenrolledon BETWEEN '2025-08-01' AND '2025-08-31';

SELECT * FROM `txn_report_flat_accrual`
WHERE txndate BETWEEN '2025-08-01' AND '2025-08-31';
