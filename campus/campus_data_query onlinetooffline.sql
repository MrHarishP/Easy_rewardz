
#latency over all 
-- set @startdate='2023-01-01',@enddate='2023-12-31';
-- SET @startdate='2024-01-01',@enddate='2024-12-31';
-- SET @startdate='2024-01-01',@enddate='2024-03-31';
-- SET @startdate='2024-04-01',@enddate='2024-06-30';
-- SET @startdate='2024-07-01',@enddate='2024-09-30';
-- SET @startdate='2024-10-01',@enddate='2024-12-31';


SELECT AVG(latency) FROM (
SELECT txnmappedmobile,DATEDIFF(MAX(modifiedtxndate),MIN(modifiedtxndate))/NULLIF((COUNT(DISTINCT modifiedtxndate)-1),0)latency FROM sku_report_loyalty
WHERE modifiedtxndate BETWEEN @startdate AND @enddate
GROUP BY 1)a 




#2nd male customer sales and female customer sale
-- cy 2024
SELECT SUM(male_sale) sales FROM (
SELECT txnmappedmobile,SUM(itemnetamount)male_sale FROM sku_report_loyalty a
JOIN member_report b ON a.txnmappedmobile=b.mobile
WHERE gender LIKE 'Male%' AND txndate BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY 1)a;

-- over all 
SELECT SUM(male_sale) sales FROM (
SELECT txnmappedmobile,SUM(itemnetamount)male_sale FROM sku_report_loyalty a
JOIN member_report b ON a.txnmappedmobile=b.mobile
WHERE gender LIKE 'Male%' 
GROUP BY 1)a;


SELECT SUM(male_sale) sales FROM (
SELECT txnmappedmobile,SUM(itemnetamount)male_sale FROM sku_report_loyalty a
JOIN member_report b ON a.txnmappedmobile=b.mobile
WHERE gender LIKE 'female%' AND txndate BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY 1)a;

-- over all 
SELECT SUM(male_sale) sales FROM (
SELECT txnmappedmobile,SUM(itemnetamount)male_sale FROM sku_report_loyalty a
JOIN member_report b ON a.txnmappedmobile=b.mobile
WHERE gender LIKE 'female%' 
GROUP BY 1)a;


#gender product sale

-- #gents sales overall sale
SELECT SUM(sale)gents_sale FROM (
SELECT txnmappedmobile,SUM(itemnetamount)sale FROM sku_report_loyalty a
JOIN item_master b USING(uniqueitemcode)
WHERE gender LIKE 'gents'
GROUP BY 1)a;
-- ladies overall sale
SELECT SUM(sale)ladies_sale FROM (
SELECT txnmappedmobile,SUM(itemnetamount)sale FROM sku_report_loyalty a
JOIN item_master b USING(uniqueitemcode)
WHERE gender LIKE 'ladies'
GROUP BY 1)a;

-- males cy sale
SELECT SUM(sale)gents_sale FROM (
SELECT txnmappedmobile,SUM(itemnetamount)sale FROM sku_report_loyalty a
JOIN item_master b USING(uniqueitemcode)
WHERE gender LIKE 'gents' AND modifiedtxndate BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY 1)a;

-- female cy sales
SELECT SUM(sale)ladies_sale FROM (
SELECT txnmappedmobile,SUM(itemnetamount)sale FROM sku_report_loyalty  a
JOIN item_master b USING(uniqueitemcode)
WHERE gender LIKE 'ladies' AND modifiedtxndate BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY 1)a;


-- customer who shifted offline to online
WITH ecomdate AS
(SELECT DISTINCT mobile,txndate,storecode,txncount FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2024-01-01' AND '2024-12-31'
)
 
SELECT COUNT(DISTINCT mobile ) customer FROM ecomdate a
JOIN ecomdate b USING(mobile) WHERE a.storecode ='ecom' AND b.storecode!='ecom' AND a.txncount<b.txncount


-- customer who txn offline after shifted on online 

WITH overalldata AS
(SELECT DISTINCT mobile,txndate,storecode,txncount FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2024-01-01' AND '2024-12-31'
),
ecomtostore AS(
SELECT DISTINCT mobile FROM overalldata a
JOIN overalldata b USING(mobile) WHERE a.storecode ='ecom' AND b.storecode !='ecom' AND a.txncount<b.txncount
),
storetoecom AS(
SELECT DISTINCT mobile FROM overalldata a
JOIN overalldata b USING(mobile) WHERE a.storecode !='ecom' AND b.storecode ='ecom' AND a.txncount<b.txncount
)
SELECT COUNT(DISTINCT mobile) AS offline_txn_count
FROM storetoecom
WHERE mobile IN ( SELECT DISTINCT mobile FROM ecomtostore);


-- QC
SELECT storecode,MAX(txndate) FROM txn_report_accrual_redemption 
WHERE mobile ='6002257625'









-- online to offline 
WITH ecomdate AS
(SELECT DISTINCT mobile,txndate,storecode,txncount FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2024-01-01' AND '2024-12-31'
)
SELECT COUNT(DISTINCT mobile ) customer FROM ecomdate a
JOIN ecomdate b USING(mobile) WHERE a.storecode !='ecom' AND b.storecode='ecom' AND a.txncount<b.txncount



-- customer txn online after shifted to offline

WITH overalldata AS
(SELECT DISTINCT mobile,txndate,storecode,txncount FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2024-01-01' AND '2024-12-31'
),
ecomtostore AS(
SELECT DISTINCT mobile FROM overalldata a
JOIN overalldata b USING(mobile) WHERE a.storecode ='ecom' AND b.storecode !='ecom' AND a.txncount<b.txncount
),
storetoecom AS(
SELECT DISTINCT mobile FROM overalldata a
JOIN overalldata b USING(mobile) WHERE a.storecode !='ecom' AND b.storecode ='ecom' AND a.txncount<b.txncount
)
SELECT COUNT(DISTINCT mobile) AS offline_txn_count
FROM  ecomtostore
WHERE mobile IN ( SELECT DISTINCT mobile FROM storetoecom);


-- QC
SELECT storecode FROM txn_report_accrual_redemption 
WHERE mobile ='9039973098'
AND txndate BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY 1
-- enrolled but not transaction
SELECT COUNT(DISTINCT mobile)customer FROM member_report 
WHERE mobile NOT IN (SELECT mobile FROM txn_report_accrual_redemption GROUP BY 1)
-- group by 1;


#enrolled but not txn year and store wise 
SELECT YEAR(modifiedenrolledon)enrolledyear,enrolledstorecode,COUNT(DISTINCT mobile)customers FROM member_report 
WHERE mobile NOT IN (SELECT mobile FROM txn_report_accrual_redemption GROUP BY 1)
GROUP BY 1,2;