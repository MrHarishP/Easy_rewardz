-- fy22-23

SELECT CASE 
WHEN frequencycount=1 THEN txnmappedmobile END onetimer
CASE 
WHEN frequencycount>2 THEN txnmappedmobile END repeater
COUNT(DISTINCT txnmappedmobile)mobile FROM dummy.bb_new_repeat_Fy22_23 a JOIN sku_report_loyalty b USING(txnmappedmobile)
WHERE modifiedtxndate BETWEEN '2022-04-01' AND '2023-03-31'
GROUP BY 1 ;

SELECT COUNT(DISTINCT CASE 
WHEN frequencycount=1 THEN txnmappedmobile END )onetimer,
COUNT(DISTINCT CASE 
WHEN frequencycount>2 THEN txnmappedmobile END )repeater FROM 
sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2023-03-01' AND '2024-04-30'
AND itemnetamount>0
AND modifiedstorecode <> 'demo'
AND Txnmappedmobile NOT IN (SELECT mobile FROM probable_fraud_customer) ;
-- GROUP BY 1;


SELECT COUNT(DISTINCT CASE WHEN minf=1 AND maxf=1 THEN txnmappedmobile END )
+ COUNT(DISTINCT CASE WHEN minf=1 AND maxf>1 THEN txnmappedmobile END )onetimer,
COUNT(DISTINCT CASE WHEN minf>1 THEN txnmappedmobile END )repeater
FROM(
SELECT txnmappedmobile,MIN(frequencycount)minf,MAX(frequencycount)maxf,
DATEDIFF('2023-04-30',MAX(modifiedtxndate))recency,dayssincelastvisit 
FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2022-03-01' AND '2023-04-30'
AND itemnetamount>0
AND modifiedstorecode <> 'demo'
AND Txnmappedmobile NOT IN (SELECT mobile FROM probable_fraud_customer) 
GROUP BY 1)a

SELECT COUNT(DISTINCT txnmappedmobile) FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2024-01-01' AND '2024-12-31'
AND itemnetamount>0
AND modifiedstorecode <> 'demo'
AND Txnmappedmobile NOT IN (SELECT mobile FROM probable_fraud_customer)

#################################

INSERT INTO dummy.bb_new_repeat_Fy22_23
SELECT txnmappedmobile,MIN(frequencycount)minf,MAX(frequencycount)maxf,
DATEDIFF('2023-03-31',MAX(modifiedtxndate))recency,dayssincelastvisit 
FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2022-04-01' AND '2023-03-31'
AND itemnetamount>0
AND modifiedstorecode <> 'demo'
AND Txnmappedmobile NOT IN (SELECT mobile FROM probable_fraud_customer) 
GROUP BY 1;#563235

ALTER TABLE dummy.bb_new_repeat_Fy22_23 ADD INDEX mobile(txnmappedmobile);


ALTER TABLE dummy.bb_new_repeat_Fy22_23 ADD COLUMN new_repeat VARCHAR(200);


UPDATE dummy.bb_new_repeat_Fy22_23 a
SET a.new_repeat='new'
WHERE minf=1;#417035

UPDATE dummy.bb_new_repeat_Fy22_23 a
SET a.new_repeat='repeat'
WHERE new_repeat IS NULL;#146200

ALTER TABLE dummy.bb_new_repeat_Fy22_23 ADD COLUMN new_repeat_b VARCHAR(200);


UPDATE dummy.bb_new_repeat_Fy22_23
SET new_repeat_b = 'new' 
WHERE new_repeat='new' AND maxf=1;

UPDATE dummy.bb_new_repeat_Fy22_23
SET new_repeat_b = 'repeater' 
WHERE new_repeat='new' AND maxf>1;#84219

-- UPDATE dummy.bb_new_repeat_Fy22_23
-- SET new_repeat_b = 'new' 
-- WHERE new_repeat_b='new_repeat';#347173


SELECT * FROM dummy.bb_new_repeat_Fy22_23
WHERE new_repeat = 'new'
 AND new_repeat_b IS NULL;
 
 
UPDATE dummy.bb_new_repeat_Fy22_23
SET new_repeat_b = 'Last_year_new_this_repeater' 
WHERE new_repeat='repeat' AND txnmappedmobile IN (
SELECT DISTINCT txnmappedmobile 
FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2021-04-01' AND '2022-03-31'
AND itemnetamount>0
AND modifiedstorecode <> 'demo'
AND Txnmappedmobile NOT IN (SELECT mobile FROM probable_fraud_customer) 
AND frequencycount=1);#50793

-- UPDATE dummy.bb_new_repeat_Fy22_23
-- SET new_repeat_b = 'Last_year_repeart_this_repeater' 
-- WHERE new_repeat='repeat' and new_repeat_b is null;



UPDATE dummy.bb_new_repeat_Fy22_23
SET new_repeat_b = 'Last_year_repeat_this_repeater' 
WHERE new_repeat='repeat' AND txnmappedmobile IN (
SELECT DISTINCT txnmappedmobile 
FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2021-04-01' AND '2022-03-31'
AND itemnetamount>0
AND modifiedstorecode <> 'demo'
AND Txnmappedmobile NOT IN (SELECT mobile FROM probable_fraud_customer) 
AND frequencycount>1);#55288


SELECT * FROM dummy.bb_new_repeat_Fy22_23
WHERE new_repeat_b IS NULL;



UPDATE dummy.bb_new_repeat_Fy22_23
SET new_repeat_b = 'Past Transactors (13-24M)' 
WHERE new_repeat='repeat'  
AND txnmappedmobile IN (SELECT txnmappedmobile FROM(
(SELECT DISTINCT txnmappedmobile 
FROM dummy.bb_new_repeat_Fy22_23 
WHERE dayssincelastvisit BETWEEN 366 AND 730))a);#38807

UPDATE dummy.bb_new_repeat_Fy22_23
SET new_repeat_b = 'Customers txn. > 24 months (Reactivation)' 
WHERE new_repeat='repeat'  
AND txnmappedmobile IN (SELECT txnmappedmobile FROM(
(SELECT DISTINCT txnmappedmobile 
FROM dummy.bb_new_repeat_Fy22_23 
WHERE dayssincelastvisit >730))a);#30555


SELECT new_repeat,new_repeat_b,COUNT(DISTINCT txnmappedmobile) FROM dummy.bb_new_repeat_Fy22_23 GROUP BY 1,2;



#####################################################################################

SELECT * FROM dummy.bb_new_repeatFy23_24
-- fy23-24
INSERT INTO dummy.bb_new_repeatFy23_24
SELECT txnmappedmobile,MIN(frequencycount)minf,MAX(frequencycount)maxf,
DATEDIFF('2024-04-30',MAX(modifiedtxndate))recency,dayssincelastvisit 
FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2023-03-01' AND '2024-04-30'
AND itemnetamount>0
AND modifiedstorecode <> 'demo'
AND Txnmappedmobile NOT IN (SELECT mobile FROM probable_fraud_customer)
GROUP BY 1;#653897

ALTER TABLE dummy.bb_new_repeatFy23_24 ADD INDEX mobile(txnmappedmobile);


ALTER TABLE dummy.bb_new_repeatFy23_24 ADD COLUMN new_repeat VARCHAR(200);


UPDATE dummy.bb_new_repeatFy23_24 a
SET a.new_repeat='new'
WHERE minf=1;#452085

UPDATE dummy.bb_new_repeatFy23_24 a
SET a.new_repeat='repeat'
WHERE new_repeat IS NULL;#201812

ALTER TABLE dummy.bb_new_repeatFy23_24 ADD COLUMN new_repeat_b VARCHAR(200);


UPDATE dummy.bb_new_repeatFy23_24
SET new_repeat_b = 'new' 
WHERE new_repeat='new' AND maxf=1;#373499


-- UPDATE dummy.bb_new_repeatFy23_24
-- SET new_repeat_b = 'new' 
-- WHERE new_repeat_b='new_repeat';#389917

UPDATE dummy.bb_new_repeatFy23_24
SET new_repeat_b = 'repeater' 
WHERE new_repeat='new' AND maxf>1;#78586




SELECT * FROM dummy.bb_new_repeatFy23_24
WHERE new_repeat = 'new'
 AND new_repeat_b IS NULL
 
 
UPDATE dummy.bb_new_repeatFy23_24
SET new_repeat_b = 'Last_year_new_this_repeater' 
WHERE new_repeat='repeat' AND txnmappedmobile IN (
SELECT DISTINCT txnmappedmobile 
FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2022-03-01' AND '2023-04-30'
AND itemnetamount>0
AND modifiedstorecode <> 'demo'
AND Txnmappedmobile NOT IN (SELECT mobile FROM probable_fraud_customer) 
AND frequencycount=1);#68148

-- UPDATE dummy.bb_new_repeatFy23_24
-- SET new_repeat_b = 'Last_year_repeart_this_repeater' 
-- WHERE new_repeat='repeat' and new_repeat_b is null;



UPDATE dummy.bb_new_repeatFy23_24
SET new_repeat_b = 'Last_year_repeat_this_repeater' 
WHERE new_repeat='repeat' AND txnmappedmobile IN (
SELECT DISTINCT txnmappedmobile 
FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2022-03-01' AND '2023-04-30'
AND itemnetamount>0
AND modifiedstorecode <> 'demo'
AND Txnmappedmobile NOT IN (SELECT mobile FROM probable_fraud_customer) 
AND frequencycount>1);#105520


SELECT * FROM dummy.bb_new_repeatFy23_24
WHERE new_repeat_b IS NULL;



UPDATE dummy.bb_new_repeatFy23_24
SET new_repeat_b = 'Past Transactors (13-24M)' 
WHERE new_repeat='repeat'  
AND txnmappedmobile IN (SELECT txnmappedmobile FROM(
(SELECT DISTINCT txnmappedmobile 
FROM dummy.bb_new_repeatFy23_24 
WHERE dayssincelastvisit BETWEEN 366 AND 730))a);#60325

UPDATE dummy.bb_new_repeatFy23_24
SET new_repeat_b = 'Customers txn. > 24 months (Reactivation)' 
WHERE new_repeat='repeat'  
AND txnmappedmobile IN (SELECT txnmappedmobile FROM(
(SELECT DISTINCT txnmappedmobile 
FROM dummy.bb_new_repeatFy23_24 
WHERE dayssincelastvisit >730))a);#45462


SELECT new_repeat,new_repeat_b,COUNT(DISTINCT txnmappedmobile) FROM dummy.bb_new_repeatFy23_24 GROUP BY 1,2;

########################################################


-- fy24-25


INSERT INTO dummy.bb_new_repeat_Fy24_25
SELECT txnmappedmobile,MIN(frequencycount)minf,MAX(frequencycount)maxf,
DATEDIFF('2025-03-31',MAX(modifiedtxndate))recency,dayssincelastvisit 
FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31'
AND itemnetamount>0
AND modifiedstorecode <> 'demo'
AND Txnmappedmobile NOT IN (SELECT mobile FROM probable_fraud_customer)
GROUP BY 1;#610365

ALTER TABLE dummy.bb_new_repeat_Fy24_25 ADD INDEX mobile(txnmappedmobile);


ALTER TABLE dummy.bb_new_repeat_Fy24_25 ADD COLUMN new_repeat VARCHAR(200);


UPDATE dummy.bb_new_repeat_Fy24_25 a
SET a.new_repeat='new'
WHERE minf=1;#387581

UPDATE dummy.bb_new_repeat_Fy24_25 a
SET a.new_repeat='repeat'
WHERE new_repeat IS NULL;#222784

ALTER TABLE dummy.bb_new_repeat_Fy24_25 ADD COLUMN new_repeat_b VARCHAR(200);


UPDATE dummy.bb_new_repeat_Fy24_25
SET new_repeat_b = 'new' 
WHERE new_repeat='new' AND maxf=1;#324392


-- UPDATE dummy.bb_new_repeat_Fy24_25
-- SET new_repeat_b = 'new' 
-- WHERE new_repeat_b='new_repeat';#389917

UPDATE dummy.bb_new_repeat_Fy24_25
SET new_repeat_b = 'repeater' 
WHERE new_repeat='new' AND maxf>1;#63189




SELECT * FROM dummy.bb_new_repeat_Fy24_25
WHERE new_repeat = 'new'
 AND new_repeat_b IS NULL;
 
 
UPDATE dummy.bb_new_repeat_Fy24_25
SET new_repeat_b = 'Last_year_new_this_repeater' 
WHERE new_repeat='repeat' AND txnmappedmobile IN (
SELECT DISTINCT txnmappedmobile 
FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2023-04-01' AND '2024-03-31'
AND itemnetamount>0
AND modifiedstorecode <> 'demo'
AND Txnmappedmobile NOT IN (SELECT mobile FROM probable_fraud_customer) 
AND frequencycount=1);#59922

-- UPDATE dummy.bb_new_repeat_Fy24_25
-- SET new_repeat_b = 'Last_year_repeart_this_repeater' 
-- WHERE new_repeat='repeat' and new_repeat_b is null;



UPDATE dummy.bb_new_repeat_Fy24_25
SET new_repeat_b = 'Last_year_repeat_this_repeater' 
WHERE new_repeat='repeat' AND txnmappedmobile IN (
SELECT DISTINCT txnmappedmobile 
FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2023-04-01' AND '2024-03-31'
AND itemnetamount>0
AND modifiedstorecode <> 'demo'
AND Txnmappedmobile NOT IN (SELECT mobile FROM probable_fraud_customer) 
AND frequencycount>1);#92115


SELECT * FROM dummy.bb_new_repeat_Fy24_25
WHERE new_repeat_b IS NULL;



UPDATE dummy.bb_new_repeat_Fy24_25
SET new_repeat_b = 'Past Transactors (13-24M)' 
WHERE new_repeat='repeat'  
AND txnmappedmobile IN (SELECT txnmappedmobile FROM(
(SELECT DISTINCT txnmappedmobile 
FROM dummy.bb_new_repeat_Fy24_25 
WHERE dayssincelastvisit BETWEEN 366 AND 730))a);#59259

UPDATE dummy.bb_new_repeat_Fy24_25
SET new_repeat_b = 'Customers txn. > 24 months (Reactivation)' 
WHERE new_repeat='repeat'  
AND txnmappedmobile IN (SELECT txnmappedmobile FROM(
(SELECT DISTINCT txnmappedmobile 
FROM dummy.bb_new_repeat_Fy24_25 
WHERE dayssincelastvisit >730))a);#54511


SELECT new_repeat,new_repeat_b,COUNT(DISTINCT txnmappedmobile) FROM dummy.bb_new_repeat_Fy24_25 GROUP BY 1,2;


#######################################################


-- jan-dec25
INSERT INTO dummy.bb_new_repeat_jan_dec_25
SELECT txnmappedmobile,MIN(frequencycount)minf,MAX(frequencycount)maxf,
DATEDIFF('2022-12-31',MAX(modifiedtxndate))recency,dayssincelastvisit 
FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2022-01-01' AND '2022-12-31'
AND itemnetamount>0
AND modifiedstorecode <> 'demo'
AND Txnmappedmobile NOT IN (SELECT mobile FROM probable_fraud_customer) 
GROUP BY 1;#536993

ALTER TABLE dummy.bb_new_repeat_jan_dec_25 ADD INDEX mobile(txnmappedmobile);


ALTER TABLE dummy.bb_new_repeat_jan_dec_25 ADD COLUMN new_repeat VARCHAR(200);


UPDATE dummy.bb_new_repeat_jan_dec_25 a
SET a.new_repeat='new'
WHERE minf=1;#407330

UPDATE dummy.bb_new_repeat_jan_dec_25 a
SET a.new_repeat='repeat'
WHERE new_repeat IS NULL;#129663

ALTER TABLE dummy.bb_new_repeat_jan_dec_25 ADD COLUMN new_repeat_b VARCHAR(200);


UPDATE dummy.bb_new_repeat_jan_dec_25
SET new_repeat_b = 'new' 
WHERE new_repeat='new' AND maxf=1;#340514


-- UPDATE dummy.bb_new_repeat_jan_dec_25
-- SET new_repeat_b = 'new' 
-- WHERE new_repeat_b='new_repeat';#389917

UPDATE dummy.bb_new_repeat_jan_dec_25
SET new_repeat_b = 'repeater' 
WHERE new_repeat='new' AND maxf>1;#66816




SELECT * FROM dummy.bb_new_repeat_jan_dec_25
WHERE new_repeat = 'new'
 AND new_repeat_b IS NULL;
 
 
UPDATE dummy.bb_new_repeat_jan_dec_25
SET new_repeat_b = 'Last_year_new_this_repeater' 
WHERE new_repeat='repeat' AND txnmappedmobile IN (
SELECT DISTINCT txnmappedmobile 
FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2021-01-01' AND '2021-12-31'
AND itemnetamount>0
AND modifiedstorecode <> 'demo'
AND Txnmappedmobile NOT IN (SELECT mobile FROM probable_fraud_customer) 
AND frequencycount=1);#45983

-- UPDATE dummy.bb_new_repeat_jan_dec_25
-- SET new_repeat_b = 'Last_year_repeart_this_repeater' 
-- WHERE new_repeat='repeat' and new_repeat_b is null;



UPDATE dummy.bb_new_repeat_jan_dec_25
SET new_repeat_b = 'Last_year_repeat_this_repeater' 
WHERE new_repeat='repeat' AND txnmappedmobile IN (
SELECT DISTINCT txnmappedmobile 
FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2021-01-01' AND '2021-12-31'
AND itemnetamount>0
AND modifiedstorecode <> 'demo'
AND Txnmappedmobile NOT IN (SELECT mobile FROM probable_fraud_customer) 
AND frequencycount>1);#49110


SELECT * FROM dummy.bb_new_repeat_jan_dec_25
WHERE new_repeat_b IS NULL;



UPDATE dummy.bb_new_repeat_jan_dec_25
SET new_repeat_b = 'Past Transactors (13-24M)' 
WHERE new_repeat='repeat'  
AND txnmappedmobile IN (SELECT txnmappedmobile FROM(
(SELECT DISTINCT txnmappedmobile 
FROM dummy.bb_new_repeat_jan_dec_25 
WHERE dayssincelastvisit BETWEEN 366 AND 730))a);#33429

UPDATE dummy.bb_new_repeat_jan_dec_25
SET new_repeat_b = 'Customers txn. > 24 months (Reactivation)' 
WHERE new_repeat='repeat'  
AND txnmappedmobile IN (SELECT txnmappedmobile FROM(
(SELECT DISTINCT txnmappedmobile 
FROM dummy.bb_new_repeat_jan_dec_25 
WHERE dayssincelastvisit >730))a);#28320


SELECT new_repeat,new_repeat_b,COUNT(DISTINCT txnmappedmobile) FROM dummy.bb_new_repeat_jan_dec_25 GROUP BY 1,2;


############################################


-- jan-dec23


INSERT INTO dummy.bb_new_repeat_jan_dec_23
SELECT txnmappedmobile,MIN(frequencycount)minf,MAX(frequencycount)maxf,
DATEDIFF('2023-12-31',MAX(modifiedtxndate))recency,dayssincelastvisit 
FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2023-01-01' AND '2023-12-31'
AND itemnetamount>0
AND modifiedstorecode <> 'demo'
AND Txnmappedmobile NOT IN (SELECT mobile FROM probable_fraud_customer) 
GROUP BY 1;#576235

ALTER TABLE dummy.bb_new_repeat_jan_dec_23 ADD INDEX mobile(txnmappedmobile);


ALTER TABLE dummy.bb_new_repeat_jan_dec_23 ADD COLUMN new_repeat VARCHAR(200);


UPDATE dummy.bb_new_repeat_jan_dec_23 a
SET a.new_repeat='new'
WHERE minf=1;#395329

UPDATE dummy.bb_new_repeat_jan_dec_23 a
SET a.new_repeat='repeat'
WHERE new_repeat IS NULL;#180906

ALTER TABLE dummy.bb_new_repeat_jan_dec_23 ADD COLUMN new_repeat_b VARCHAR(200);


UPDATE dummy.bb_new_repeat_jan_dec_23
SET new_repeat_b = 'new' 
WHERE new_repeat='new' AND maxf=1;#330991


-- UPDATE dummy.bb_new_repeat_jan_dec_23
-- SET new_repeat_b = 'new' 
-- WHERE new_repeat_b='new_repeat';#389917

UPDATE dummy.bb_new_repeat_jan_dec_23
SET new_repeat_b = 'repeater' 
WHERE new_repeat='new' AND maxf>1;#64338




SELECT * FROM dummy.bb_new_repeat_jan_dec_23
WHERE new_repeat = 'new'
 AND new_repeat_b IS NULL;
 
 
UPDATE dummy.bb_new_repeat_jan_dec_23
SET new_repeat_b = 'Last_year_new_this_repeater' 
WHERE new_repeat='repeat' AND txnmappedmobile IN (
SELECT DISTINCT txnmappedmobile 
FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2022-01-01' AND '2022-12-31'
AND itemnetamount>0
AND modifiedstorecode <> 'demo'
AND Txnmappedmobile NOT IN (SELECT mobile FROM probable_fraud_customer) 
AND frequencycount=1);#62836

-- UPDATE dummy.bb_new_repeat_jan_dec_23
-- SET new_repeat_b = 'Last_year_repeart_this_repeater' 
-- WHERE new_repeat='repeat' and new_repeat_b is null;



UPDATE dummy.bb_new_repeat_jan_dec_23
SET new_repeat_b = 'Last_year_repeat_this_repeater' 
WHERE new_repeat='repeat' AND txnmappedmobile IN (
SELECT DISTINCT txnmappedmobile 
FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2022-01-01' AND '2022-12-31'
AND itemnetamount>0
AND modifiedstorecode <> 'demo'
AND Txnmappedmobile NOT IN (SELECT mobile FROM probable_fraud_customer) 
AND frequencycount>1);#74329


SELECT * FROM dummy.bb_new_repeat_jan_dec_23
WHERE new_repeat_b IS NULL;



UPDATE dummy.bb_new_repeat_jan_dec_23
SET new_repeat_b = 'Past Transactors (13-24M)' 
WHERE new_repeat='repeat'  
AND txnmappedmobile IN (SELECT txnmappedmobile FROM(
(SELECT DISTINCT txnmappedmobile 
FROM dummy.bb_new_repeat_jan_dec_23 
WHERE dayssincelastvisit BETWEEN 366 AND 730))a);#51887

UPDATE dummy.bb_new_repeat_jan_dec_23
SET new_repeat_b = 'Customers txn. > 24 months (Reactivation)' 
WHERE new_repeat='repeat'  
AND txnmappedmobile IN (SELECT txnmappedmobile FROM(
(SELECT DISTINCT txnmappedmobile 
FROM dummy.bb_new_repeat_jan_dec_23 
WHERE dayssincelastvisit >730))a);#37147


SELECT new_repeat,new_repeat_b,COUNT(DISTINCT txnmappedmobile) FROM dummy.bb_new_repeat_jan_dec_23 GROUP BY 1,2;


###########################################################


-- jan-dec24


INSERT INTO dummy.bb_new_repeat_jan_dec24
SELECT txnmappedmobile,MIN(frequencycount)minf,MAX(frequencycount)maxf,
DATEDIFF('2024-12-31',MAX(modifiedtxndate))recency,dayssincelastvisit 
FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2024-01-01' AND '2024-12-31'
AND itemnetamount>0
AND modifiedstorecode <> 'demo'
AND Txnmappedmobile NOT IN (SELECT mobile FROM probable_fraud_customer)
GROUP BY 1;#626442

ALTER TABLE dummy.bb_new_repeat_jan_dec24 ADD INDEX mobile(txnmappedmobile);


ALTER TABLE dummy.bb_new_repeat_jan_dec24 ADD COLUMN new_repeat VARCHAR(200);


UPDATE dummy.bb_new_repeat_jan_dec24 a
SET a.new_repeat='new'
WHERE minf=1;#408703

UPDATE dummy.bb_new_repeat_jan_dec24 a
SET a.new_repeat='repeat'
WHERE new_repeat IS NULL;#217739

ALTER TABLE dummy.bb_new_repeat_jan_dec24 ADD COLUMN new_repeat_b VARCHAR(200);


UPDATE dummy.bb_new_repeat_jan_dec24
SET new_repeat_b = 'new' 
WHERE new_repeat='new' AND maxf=1;#340950


-- UPDATE dummy.bb_new_repeat_jan_dec24
-- SET new_repeat_b = 'new' 
-- WHERE new_repeat_b='new_repeat';#389917

UPDATE dummy.bb_new_repeat_jan_dec24
SET new_repeat_b = 'repeater' 
WHERE new_repeat='new' AND maxf>1;#67753




SELECT * FROM dummy.bb_new_repeat_jan_dec24
WHERE new_repeat = 'new'
 AND new_repeat_b IS NULL;
 
 
UPDATE dummy.bb_new_repeat_jan_dec24
SET new_repeat_b = 'Last_year_new_this_repeater' 
WHERE new_repeat='repeat' AND txnmappedmobile IN (
SELECT DISTINCT txnmappedmobile 
FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2023-01-01' AND '2023-12-31'
AND itemnetamount>0
AND modifiedstorecode <> 'demo'
AND Txnmappedmobile NOT IN (SELECT mobile FROM probable_fraud_customer) 
AND frequencycount=1);#61779

-- UPDATE dummy.bb_new_repeat_jan_dec24
-- SET new_repeat_b = 'Last_year_repeart_this_repeater' 
-- WHERE new_repeat='repeat' and new_repeat_b is null;



UPDATE dummy.bb_new_repeat_jan_dec24
SET new_repeat_b = 'Last_year_repeat_this_repeater' 
WHERE new_repeat='repeat' AND txnmappedmobile IN (
SELECT DISTINCT txnmappedmobile 
FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2023-01-01' AND '2023-12-31'
AND itemnetamount>0
AND modifiedstorecode <> 'demo'
AND Txnmappedmobile NOT IN (SELECT mobile FROM probable_fraud_customer) 
AND frequencycount>1);#91443


SELECT * FROM dummy.bb_new_repeat_jan_dec24
WHERE new_repeat_b IS NULL;



UPDATE dummy.bb_new_repeat_jan_dec24
SET new_repeat_b = 'Past Transactors (13-24M)' 
WHERE new_repeat='repeat'  
AND txnmappedmobile IN (SELECT txnmappedmobile FROM(
(SELECT DISTINCT txnmappedmobile 
FROM dummy.bb_new_repeat_jan_dec24 
WHERE dayssincelastvisit BETWEEN 366 AND 730))a);#64182

UPDATE dummy.bb_new_repeat_jan_dec24
SET new_repeat_b = 'Customers txn. > 24 months (Reactivation)' 
WHERE new_repeat='repeat'  
AND txnmappedmobile IN (SELECT txnmappedmobile FROM(
(SELECT DISTINCT txnmappedmobile 
FROM dummy.bb_new_repeat_jan_dec24 
WHERE dayssincelastvisit >730))a);#54439


SELECT new_repeat,new_repeat_b,COUNT(DISTINCT txnmappedmobile) FROM dummy.bb_new_repeat_jan_dec24 GROUP BY 1,2;


####################################################