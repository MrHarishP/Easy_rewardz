-- find those customer whos birthday is in march andthere details
-- Please Share the Birthday data for campus with the below columns for March 2025
-- Name
-- Date of Birth
-- Mobile number
-- Store Code
-- Store name
-- City

SELECT mobile,CONCAT(firstname,' ',lastname)`full name`,DATE(dateofbirth),enrolledstorecode,enrolledstore,city FROM member_report a
JOIN store_master b ON a.enrolledstorecode=b.storecode
WHERE MONTHNAME(dateofbirth) ='March'
GROUP BY 1;


-- QC
SELECT dateofbirth FROM member_report
WHERE mobile ='9811119412'

-- another details with lapsed points and lapsing date
-- Please share the Points expiry report for Mango and Nautica for February 2025
-- Name
-- Mobile number
-- Store code
-- Store Name
-- City
-- Lapsing Points
-- Lapsing Date




WITH lapsed_data AS(
SELECT mobile,SUM(pointslapsed)lapsed_points,lapsingdate FROM `lapse_report`
WHERE lapsingdate BETWEEN '2025-02-01' AND '2025-02-28'
GROUP BY 1),
detail AS(
SELECT mobile,CONCAT(firstname,' ',lastname)NAME,enrolledstorecode,enrolledstore,city FROM member_report a
JOIN store_master b ON a.enrolledstorecode=b.storecode
GROUP BY 1)
SELECT mobile,NAME,enrolledstorecode,enrolledstore,city,lapsed_points,lapsingdate FROM lapsed_data a
JOIN detail b USING(mobile)
GROUP BY 1;

-- QC
SELECT DISTINCT lapsingdate FROM lapse_report
WHERE mobile='9412317393'
AND lapsingdate BETWEEN '2025-02-01' AND '2025-02-28'


-- another way to do this 
SELECT a.mobile,Firstname,Lastname,Enrolledstorecode,Enrolledstore,Lapsingdate,SUM(PointsLapsing),city FROM Member_report a
JOIN lapse_report b
ON a.mobile = b.mobile
JOIN store_master c
ON a.Enrolledstorecode = c.storecode
WHERE lapsingdate BETWEEN '2025-02-01' AND '2025-02-28' AND Enrolledstorecode NOT LIKE '%demo%'
GROUP BY 1; 
