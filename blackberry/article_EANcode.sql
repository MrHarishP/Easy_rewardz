SELECT * FROM sku_report_loyalty LIMIT 10;




CREATE TABLE dummy.harish_blackberrys_ARTICLE_EAN_REP_18_MAR_25 (
    Articalno VARCHAR(100),
    Brand VARCHAR(50),
    EANcode VARCHAR(200)
);

SELECT * FROM dummy.harish_blackberrys_ARTICLE_EAN_REP_18_MAR_25 LIMIT 100; 




LOAD DATA LOCAL INFILE "C:\\Users\\intern_dataanalyst3\\Downloads\\article\\Article_EANcode.csv"
INTO TABLE  dummy.harish_blackberrys_ARTICLE_EAN_REP_18_MAR_25
CHARACTER SET 'latin1'
FIELDS ESCAPED BY '\\' 
TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES; #321173


ALTER TABLE dummy.harish_blackberrys_ARTICLE_EAN_REP_18_MAR_25 ADD INDEX EANcode(EANcode);

ALTER TABLE dummy.harish_blackberrys_ARTICLE_EAN_REP_18_MAR_25 ADD COLUMN customers_count VARCHAR(250), 
ADD COLUMN bills VARCHAR(100),ADD COLUMN sales DECIMAL(50,4);

ALTER TABLE dummy.harish_blackberrys_ARTICLE_EAN_REP_18_MAR_25 ADD COLUMN qty VARCHAR(50)
SELECT * FROM dummy.harish_blackberrys_ARTICLE_EAN_REP_18_MAR_25


UPDATE dummy.harish_blackberrys_ARTICLE_EAN_REP_18_MAR_25 a JOIN (
SELECT EANcode,COUNT(DISTINCT txnmappedmobile)customers_count,SUM(bills)bills,SUM(sales)sales,SUM(qty)qty FROM(
SELECT txnmappedmobile,EANcode,COUNT(DISTINCT uniquebillno)bills,SUM(itemnetamount)sales,SUM(itemqty)qty 
FROM sku_report_loyalty a JOIN dummy.harish_blackberrys_ARTICLE_EAN_REP_18_MAR_25 b ON a.UniqueItemcode=b.EANcode
WHERE modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31'
GROUP BY 1,2)a
GROUP BY 1) b ON a.EANcode=b.EANcode
SET a.customers_count=b.customers_count,a.bills=b.bills,a.sales=b.sales,a.qty=b.qty; #64039




SELECT DISTINCT uniqueitemcode FROM sku_report_loyalty
WHERE modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31'


SELECT * FROM dummy.harish_blackberrys_ARTICLE_EAN_REP_18_MAR_25;

SELECT * FROM sku_report_loyalty 
WHERE uniqueitemcode='8909114001076'




SELECT COUNT(DISTINCT txnmappedmobile)customer,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills,
SUM(itemqty)qty FROM sku_report_loyalty
WHERE modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31';



SELECT COUNT(DISTINCT txnmappedmobile)customer,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills,
SUM(itemqty)qty,SUM(itemnetamount)/COUNT(DISTINCT uniquebillno)atv FROM sku_report_loyalty
WHERE modifiedtxndate BETWEEN '2025-03-01' AND '2025-03-31';


