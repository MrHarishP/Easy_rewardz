SET @startdate_1y = DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 13 MONTH), '%Y-%m-01');
SET @enddate_1y = LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 13 MONTH));
-- SELECT @startdate_1y,@enddate_1y;


SET @startdate_1m = DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 2 MONTH), '%Y-%m-01');
SET @enddate_1m = LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 2 MONTH));
-- SELECT @startdate_1m,@ENDDATE_1M ;

SET @startdate = DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-01');
SET @enddate = LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH));
-- select @startdate,@enddate;

## Enrollments
-- Prev year current MBR
SELECT CONCAT(MONTHNAME(modifiedenrolledon),YEAR(modifiedenrolledon)) AS PERIOD,
COUNT(DISTINCT CASE WHEN enrolledstorecode IN ('ECOM') THEN mobile END) AS 'ECOM',
COUNT(DISTINCT CASE WHEN enrolledstorecode NOT IN ('ECOM') THEN mobile END) AS 'OFFLINE',
COUNT(DISTINCT mobile) AS Over_All 
FROM `purelife`.member_report 
WHERE enrolledstorecode NOT LIKE '%demo%'
AND modifiedenrolledon BETWEEN  @startdate_1y AND @enddate_1y
AND mobile NOT IN ('8360605410','9899021077','9953602260','9910024512','7417295255','9811015405','9559796666')
UNION
-- Prev Month MBR
SELECT CONCAT(MONTHNAME(modifiedenrolledon),YEAR(modifiedenrolledon)) AS PERIOD,
COUNT(DISTINCT CASE WHEN enrolledstorecode IN ('ECOM') THEN mobile END) AS 'ECOM',
COUNT(DISTINCT CASE WHEN enrolledstorecode NOT IN ('ECOM') THEN mobile END) AS 'OFFLINE',
COUNT(DISTINCT mobile) AS Over_All 
FROM purelife.member_report 
WHERE enrolledstorecode NOT LIKE '%demo%'
AND modifiedenrolledon BETWEEN  @startdate_1m AND @ENDDATE_1M 
AND mobile NOT IN ('8360605410','9899021077','9953602260','9910024512','7417295255','9811015405','9559796666')
UNION
-- current MBR
SELECT CONCAT(MONTHNAME(modifiedenrolledon),YEAR(modifiedenrolledon)) AS PERIOD,
COUNT(DISTINCT CASE WHEN enrolledstorecode IN ('ECOM') THEN mobile END) AS 'ECOM',
COUNT(DISTINCT CASE WHEN enrolledstorecode NOT IN ('ECOM') THEN mobile END) AS 'OFFLINE',
COUNT(DISTINCT mobile) AS Over_All 
FROM purelife.member_report 
WHERE enrolledstorecode NOT LIKE '%demo%'
AND modifiedenrolledon BETWEEN @startdate AND @enddate
AND mobile NOT IN ('8360605410','9899021077','9953602260','9910024512','7417295255','9811015405','9559796666')
AND insertiondate<'2025-08-07';
