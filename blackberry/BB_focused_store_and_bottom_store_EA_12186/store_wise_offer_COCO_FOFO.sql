CREATE TABLE dummy.blackberrys_store_wise_offer
(StoreName VARCHAR(50),SAPCode VARCHAR(20),Communication VARCHAR(60));

SELECT * FROM dummy.blackberrys_store_wise_offer;

LOAD DATA LOCAL INFILE 
"D:\\OneDrive - EasyRewardz Software Services Private Limited\\Desktop\\bb_store_wise_offer.csv"
INTO TABLE dummy.blackberrys_store_wise_offer
FIELDS ESCAPED BY '\\'
TERMINATED BY ','
ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;



ALTER TABLE dummy.blackberrys_store_wise_offer ADD INDEX a(SAPCode);

SELECT * FROM dummy.blackberrys_tier_Onam_Rakhi;


INSERT INTO dummy.blackberrys_tier_Onam_Rakhi(mobile,`last shopped store`,Recency,Communication,tier)
WITH base_data AS
(SELECT 
a.mobile,
a.`last shopped store`,
a.Recency ,
b.Communication
FROM `blackberrys`.program_single_view a JOIN dummy.blackberrys_store_wise_offer b
ON a.`last shopped store`=b.SAPCode)
SELECT a.*,b.tier FROM base_data a JOIN member_report b USING(mobile);#1714805



ALTER TABLE  dummy.blackberrys_tier_Onam_Rakhi ADD COLUMN Segments VARCHAR(20);



SELECT * FROM dummy.blackberrys_tier_Onam_Rakhi WHERE Segments='mvc';




UPDATE dummy.blackberrys_tier_Onam_Rakhi 
SET Segments='MVC'
WHERE tier='mvc';
#135111


 

UPDATE dummy.blackberrys_tier_Onam_Rakhi 
SET Segments='Active'
WHERE TIER='Active' AND Recency BETWEEN 0 AND 365 
AND Segments IS NULL;#425772

UPDATE dummy.blackberrys_tier_Onam_Rakhi
SET Segments='Reactivation 13-24 M'
WHERE Recency BETWEEN 366 AND 730 
AND Segments IS NULL;#341467




UPDATE dummy.blackberrys_tier_Onam_Rakhi
SET Segments='Reactivation 25-36'
WHERE Recency BETWEEN 731 AND 1095 
AND Segments IS NULL;#295195



UPDATE dummy.blackberrys_tier_Onam_Rakhi
SET Segments='Dormant<=12 months'
WHERE Segments IS NULL
AND Recency BETWEEN 0 AND 365
AND tier='Dormant';#1474

``


SELECT Segments ,COUNT(DISTINCT mobile) FROM dummy.blackberrys_tier_Onam_Rakhi GROUP BY 1;#1714804 
WHERE Communication='Rest of India B2 get 40';
GROUP BY 1;

SELECT * FROM program_single_view WHERE 
`last shopped store` IN ('1200289',
'1200290',
'1200291') AND recency BETWEEN 366 AND 730;



CREATE TABLE dummy.Focussed_Stores_25_08_05
(StoreName VARCHAR(60),	SAPCode VARCHAR(20),Region VARCHAR(20), TYPE VARCHAR(20),Offers VARCHAR(20),`Focussed Store List` VARCHAR(60));


LOAD DATA LOCAL INFILE "D:\\OneDrive - EasyRewardz Software Services Private Limited\\Desktop\\bb_f_s.csv"
INTO TABLE dummy.Focussed_Stores_25_08_05 
FIELDS ESCAPED BY '\\'
TERMINATED BY ','
ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

SELECT * FROM dummy.Focussed_Stores_25_08_05 ;

ALTER TABLE  dummy.blackberrys_tier_Onam_Rakhi ADD INDEX a(`last shopped store`);

ALTER TABLE  dummy.Focussed_Stores_25_08_05 ADD INDEX a(SAPCode);

INSERT INTO dummy.bb_Focussed_store_and_Bottom_Stores
SELECT 
a.mobile,
a.`last shopped store` last_shopped_store,
b.Offers, 
b.`Focussed Store List` Focussed_Store_List
FROM dummy.blackberrys_tier_Onam_Rakhi a JOIN dummy.Focussed_Stores_25_08_05 b
ON a.`last shopped store`=b.SAPCode ;#152780



SELECT * FROM dummy.bb_Focussed_store_and_Bottom_Stores;
ALTER TABLE dummy.bb_Focussed_store_and_Bottom_Stores CHANGE Focussed_Store_List Store_List VARCHAR(200);



CREATE TABLE dummy.Bottom_Store_25_08_05
(StoreName VARCHAR(60),	SAPCode VARCHAR(20),Region VARCHAR(20), TYPE VARCHAR(20),Offers VARCHAR(20),`Bottom Store List` VARCHAR(60));


LOAD DATA LOCAL INFILE "D:\\OneDrive - EasyRewardz Software Services Private Limited\\Desktop\\bb_bs.csv"
INTO TABLE dummy.Bottom_Store_25_08_05 
FIELDS ESCAPED BY '\\'
TERMINATED BY ','
ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;


SELECT * FROM dummy.Bottom_Store_25_08_05;
ALTER TABLE dummy.Bottom_Store_25_08_05 ADD INDEX a(SAPCode);


SELECT * FROM dummy.bb_Focussed_store_and_Bottom_Stores;#152780

INSERT INTO dummy.bb_Focussed_store_and_Bottom_Stores
SELECT 
a.mobile,
a.`last shopped store` last_shopped_store,
b.Offers, 
b.`Bottom Store List` Store_List 
FROM dummy.blackberrys_tier_Onam_Rakhi a JOIN dummy.Bottom_Store_25_08_05 b
ON a.`last shopped store`=b.SAPCode ;#60456





SELECT * FROM dummy.bb_Focussed_store_and_Bottom_Stores;

ALTER TABLE dummy.bb_Focussed_store_and_Bottom_Stores ADD COLUMN Segment_Name VARCHAR(200);

UPDATE   dummy.bb_Focussed_store_and_Bottom_Stores 
SET Segment_Name='Focussed Stores + B1G1'
WHERE Offers ='B1G1' AND Store_List='Focussed Stores';
#35812

UPDATE dummy.bb_Focussed_store_and_Bottom_Stores 
SET Segment_Name='Focussed Stores + B2 get G40'
WHERE Offers='B1-30,B2-40' AND Store_List='Focussed Stores'
#116968



UPDATE dummy.bb_Focussed_store_and_Bottom_Stores 
SET  Segment_Name='Bottom Stores + B1G1'
WHERE Offers LIKE '%B1G1%' AND Segment_Name IS NULL;#30073


UPDATE dummy.bb_Focussed_store_and_Bottom_Stores 
SET Segment_Name='Bottom Stores + B2 get G40'
WHERE Offers='B1-30,B2-40' AND Segment_Name IS NULL;
#30383


SELECT Segment_Name,COUNT(DISTINCT mobile) FROM dummy.bb_Focussed_store_and_Bottom_Stores GROUP BY 1;


SELECT *  FROM dummy.bb_Focussed_store_and_Bottom_Stores 
WHERE Segment_Name='Focussed Stores + B2 get G40';




