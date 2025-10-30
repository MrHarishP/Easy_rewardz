CREATE TABLE dummy.blackberrys_segments_data (
    segmentid INT,
    mobile BIGINT,
    segmentname VARCHAR(100),
    email VARCHAR(100),
    emailsubscribe BOOLEAN
);

SELECT * FROM dummy.blackberrys_segments_data LIMIT 100; 




LOAD DATA LOCAL INFILE "C:\\Users\\intern_dataanalyst3\\Downloads\\blackberrys_segments 2\\blackberrys_segments.csv"
INTO TABLE  dummy.blackberrys_segments_data
CHARACTER SET 'latin1'
FIELDS ESCAPED BY '\\' 
TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES; #1538087 row(s) affected, 65535 warning(s)


ALTER TABLE dummy.blackberrys_segments_data ADD INDEX mobile(mobile);

UPDATE dummy.blackberrys_segments_data a
JOIN member_report b USING(mobile)
SET a.email=b.Email,
a.emailsubscribe=b.EmailSubscribe;#1538087


SELECT * FROM dummy.blackberrys_segments_data;

SELECT segmentname,segmentid,COUNT(DISTINCT mobile )customers,COUNT(DISTINCT CASE WHEN email IS NOT NULL THEN  email END)email_available,
COUNT(DISTINCT CASE WHEN email IS NOT NULL AND emailsubscribe=1 THEN email END )emailsubscribe 
FROM dummy.blackberrys_segments_data
GROUP BY 1;









'9991938439','9999037999','9878077131','9996420188'



SELECT COUNT(*) FROM member_report a JOIN dummy.blackberrys_segments_data b USING(mobile) WHERE b.email IS NOT NULL AND b.emailsubscribe=1 