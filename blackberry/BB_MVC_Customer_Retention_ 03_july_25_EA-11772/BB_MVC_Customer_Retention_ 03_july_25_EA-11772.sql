INSERT INTO dummy.mvc_customer_base 
SELECT DISTINCT mobile,tier FROM member_report a JOIN sku_report_loyalty b ON a.mobile=b.txnmappedmobile
WHERE modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31' AND tier = 'MVC' AND itemnetamount>0
AND modifiedstorecode <> 'demo' AND modifiedstorecode <> 'corporate' ;#110873 out of these txn in april,aprl may and aprl,may,june 


SELECT COUNT(DISTINCT txnmappedmobile)customer FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2025-04-01' AND '2025-04-30'
AND txnmappedmobile IN (SELECT  txnmappedmobile FROM dummy.mvc_customer_base) AND  itemnetamount>0
AND modifiedstorecode <> 'demo' AND modifiedstorecode <> 'corporate';#57665
 
 
SELECT COUNT(DISTINCT txnmappedmobile)customer FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2025-04-01' AND '2025-05-31'
AND txnmappedmobile IN (SELECT  txnmappedmobile FROM dummy.mvc_customer_base) AND  itemnetamount>0
AND modifiedstorecode <> 'demo' AND modifiedstorecode <> 'corporate';#104161

 SELECT COUNT(DISTINCT txnmappedmobile)customer FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2025-04-01' AND '2025-06-30'
AND txnmappedmobile IN (SELECT  txnmappedmobile FROM dummy.mvc_customer_base) AND  itemnetamount>0
AND modifiedstorecode <> 'demo' AND modifiedstorecode <> 'corporate';#139728


 SELECT COUNT(DISTINCT txnmappedmobile)customer FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2025-05-01' AND '2025-05-31'
AND txnmappedmobile IN (SELECT  txnmappedmobile FROM dummy.mvc_customer_base) AND  itemnetamount>0
AND modifiedstorecode <> 'demo' AND modifiedstorecode <> 'corporate';#51057

SELECT 51057+57665 =108722

SELECT 10238/110873 

SELECT 108722-104161=4561;
SELECT COUNT(DISTINCT mobile) FROM dummy.mvc_customer_base 

SELECT COUNT(DISTINCT mobile)customer FROM dummy.mvc_customer_base a JOIN  sku_report_loyalty b ON a.mobile =b.txnmappedmobile
WHERE modifiedtxndate BETWEEN '2025-04-01' AND '2025-04-30'
-- AND txnmappedmobile IN (SELECT  txnmappedmobile FROM dummy.mvc_customer_base) AND  itemnetamount>0
AND modifiedstorecode <> 'demo' AND modifiedstorecode <> 'corporate';#10238

SELECT COUNT(DISTINCT mobile)customer FROM dummy.mvc_customer_base a JOIN  sku_report_loyalty b ON a.mobile =b.txnmappedmobile
WHERE modifiedtxndate BETWEEN '2025-04-01' AND '2025-05-31'
-- AND txnmappedmobile IN (SELECT  txnmappedmobile FROM dummy.mvc_customer_base) AND  itemnetamount>0
AND modifiedstorecode <> 'demo' AND modifiedstorecode <> 'corporate';#16980


SELECT COUNT(DISTINCT mobile)customer FROM dummy.mvc_customer_base a JOIN  sku_report_loyalty b ON a.mobile =b.txnmappedmobile
WHERE modifiedtxndate BETWEEN '2025-04-01' AND '2025-06-30'
-- AND txnmappedmobile IN (SELECT  txnmappedmobile FROM dummy.mvc_customer_base) AND  itemnetamount>0
AND modifiedstorecode <> 'demo' AND modifiedstorecode <> 'corporate';#23159





SELECT DISTINCT segments FROM dummy.Blackberry_Jun25_Campaign_Segments



SELECT segments,COUNT(*) FROM dummy.Blackberry_Jun25_Campaign_Segments
GROUP BY 1;

-- for june 
WITH base AS(
SELECT DISTINCT globaltestcontrol,a.mobile,a.segments FROM dummy.Blackberry_Jun25_Campaign_Segments a JOIN member_report b USING(mobile)#1786210
)
SELECT globaltestcontrol,segments,mobile,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills 
FROM base a JOIN sku_report_loyalty b ON a.mobile=b.txnmappedmobile 
WHERE modifiedtxndate BETWEEN '2025-06-01' AND '2025-06-30' AND modifiedstorecode <> 'demo' AND modifiedstorecode <> 'corporate'
GROUP BY 1,2,3;




-- Base table for may25 campaign - dummy.BB_Campaign_Base_Apr24_Mar25_Dnyanesh_30_04_2025
-- table for segcon use - dummy.BB_Campaign_Dnyanesh_30_04_2025_Final_Base_May25


SELECT * FROM dummy.BB_Campaign_Base_Apr24_Mar25_Dnyanesh_30_04_2025;#1098470

SELECT segments,COUNT(*) FROM dummy.BB_Campaign_Dnyanesh_30_04_2025_Final_Base_May25
GROUP  BY 1;#1098470

WITH base AS(
SELECT DISTINCT globaltestcontrol,a.mobile,a.segments 
FROM dummy.BB_Campaign_Dnyanesh_30_04_2025_Final_Base_May25 a JOIN member_report b USING(mobile)#1786210
)
SELECT globaltestcontrol,segments,mobile,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills 
FROM base a JOIN sku_report_loyalty b ON a.mobile=b.txnmappedmobile 
WHERE modifiedtxndate BETWEEN '2025-05-01' AND '2025-05-31' AND modifiedstorecode <> 'demo' AND modifiedstorecode <> 'corporate'
GROUP BY 1,2,3;