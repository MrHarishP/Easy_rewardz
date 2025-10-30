SET @insertiondate=CURDATE();
SET @MBRstartdate=DATE_SUB(((@insertiondate-INTERVAL 30 DAY)),INTERVAL DAYOFMONTH((@insertiondate-INTERVAL 30 DAY))-1 DAY),@MBRenddate=LAST_DAY(@insertiondate-INTERVAL 30 DAY);
SET @MBRPREVStartDate=DATE_SUB(@MBRstartdate,INTERVAL DAYOFMONTH(@MBRstartdate - INTERVAL 1 DAY) DAY);
SET @MBRPREVEndDate=LAST_DAY(@MBRPREVStartDate);
SET @MBRPREVYearStartDate=@MBRstartdate- INTERVAL 1 YEAR;
SET @MBRPREVYearEndDate=LAST_DAY(@MBRstartdate- INTERVAL 1 YEAR);

SELECT @MBRstartdate,@MBRenddate,@insertiondate, @MBRPREVStartDate,@MBRPREVEndDate,@MBRPREVYearStartDate,@MBRPREVYearEndDate;

## Enrollments
SET @insertiondate=CURDATE();
SET @MBRstartdate=DATE_SUB(((@insertiondate-INTERVAL 30 DAY)),INTERVAL DAYOFMONTH((@insertiondate-INTERVAL 30 DAY))-1 DAY),@MBRenddate=LAST_DAY(@insertiondate-INTERVAL 30 DAY);
SET @MBRPREVStartDate=DATE_SUB(@MBRstartdate,INTERVAL DAYOFMONTH(@MBRstartdate - INTERVAL 1 DAY) DAY);
SET @MBRPREVEndDate=LAST_DAY(@MBRPREVStartDate);
SET @MBRPREVYearStartDate=@MBRstartdate- INTERVAL 1 YEAR;
SET @MBRPREVYearEndDate=LAST_DAY(@MBRstartdate- INTERVAL 1 YEAR);

-- Prev year current MBR
SELECT CONCAT(MONTHNAME(modifiedenrolledon),YEAR(modifiedenrolledon)) AS PERIOD,
COUNT(DISTINCT CASE WHEN enrolledstorecode = 'ECOM' THEN membershipno END) AS 'ECOM',
COUNT(DISTINCT CASE WHEN enrolledstorecode <> 'ECOM' THEN membershipno END) AS 'OFFLINE',
COUNT(DISTINCT membershipno) AS Over_All 
FROM `forestessentials`.member_report 
WHERE enrolledstorecode NOT LIKE '%demo%'
AND modifiedenrolledon BETWEEN  @MBRPREVYearStartDate AND @MBRPREVYearEndDate
UNION
-- Prev Month MBR
SELECT CONCAT(MONTHNAME(modifiedenrolledon),YEAR(modifiedenrolledon)) AS PERIOD,
COUNT(DISTINCT CASE WHEN enrolledstorecode = 'ECOM' THEN membershipno END) AS 'ECOM',
COUNT(DISTINCT CASE WHEN enrolledstorecode <> 'ECOM' THEN membershipno END) AS 'OFFLINE',
COUNT(DISTINCT membershipno) AS Over_All 
FROM `forestessentials`.member_report 
WHERE enrolledstorecode NOT LIKE '%demo%'
AND modifiedenrolledon BETWEEN  @MBRPREVStartDate AND @MBRPREVEndDate
UNION
-- current MBR
SELECT CONCAT(MONTHNAME(modifiedenrolledon),YEAR(modifiedenrolledon)) AS PERIOD,
COUNT(DISTINCT CASE WHEN enrolledstorecode = 'ECOM' THEN membershipno END) AS 'ECOM',
COUNT(DISTINCT CASE WHEN enrolledstorecode <> 'ECOM' THEN membershipno END) AS 'OFFLINE',
COUNT(DISTINCT membershipno) AS Over_All 
FROM `forestessentials`.member_report 
WHERE enrolledstorecode NOT LIKE '%demo%'
AND modifiedenrolledon BETWEEN @MBRstartdate AND @MBRenddate
AND insertiondate<@insertiondate;



SELECT COUNT(DISTINCT membershipno)customer FROM member_report 
WHERE enrolledstorecode NOT LIKE '%demo%'
AND modifiedenrolledon BETWEEN '2024-09-01' AND '2024-09-30'
AND enrolledstorecode <> 'ecom'
AND insertiondate<'2025-10-06';
