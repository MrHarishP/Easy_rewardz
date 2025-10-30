CREATE TABLE dummy.harish_blackberrys_EANcode_pos_itemmaster_aprl_5_may_25 (
    EANcode VARCHAR(200)
);
SELECT * FROM dummy.harish_blackberrys_EANcode_pos_itemmaster_aprl_5_may_25 

LOAD DATA LOCAL INFILE "D:\\OneDrive - EasyRewardz Software Services Private Limited\\North\\blackberry\\EANcode\\POS_itemmaster.csv"
INTO TABLE  dummy.harish_blackberrys_EANcode_pos_itemmaster_aprl_5_may_25
CHARACTER SET 'latin1'
FIELDS ESCAPED BY '\\' 
TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES; #346812



ALTER TABLE dummy.harish_blackberrys_EANcode_pos_itemmaster_aprl_5_may_25 ADD INDEX EANcode(EANcode);

ALTER TABLE dummy.harish_blackberrys_EANcode_pos_itemmaster_aprl_5_may_25 ADD COLUMN customers_count VARCHAR(250), 
ADD COLUMN bills VARCHAR(100),ADD COLUMN sales DECIMAL(50,4),ADD COLUMN qty VARCHAR(50);



-- dont use this code for this table dummy.harish_blackberrys_EANcode_pos_itemmaster_aprl_25
UPDATE dummy.harish_blackberrys_EANcode_pos_itemmaster_aprl_5_may_25 a JOIN (
SELECT EANcode,COUNT(DISTINCT txnmappedmobile)customers_count,SUM(bills)bills,SUM(sales)sales,SUM(qty)qty FROM(
SELECT txnmappedmobile,EANcode,COUNT(DISTINCT uniquebillno)bills,SUM(itemnetamount)sales,SUM(itemqty)qty 
FROM sku_report_loyalty a LEFT JOIN dummy.harish_blackberrys_EANcode_pos_itemmaster_aprl_5_may_25 b ON a.UniqueItemcode=b.EANcode
WHERE modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31' AND itemnetamount>0
GROUP BY 1,2)a
GROUP BY 1) b ON a.EANcode=b.EANcode
SET a.customers_count=b.customers_count,a.bills=b.bills,a.sales=b.sales,a.qty=b.qty; #63203


-- use this for this table dummy.harish_blackberrys_EANcode_pos_itemmaster_aprl_25
SELECT EANcode,COUNT(DISTINCT txnmappedmobile)customers_count,SUM(bills)bills,SUM(sales)sales,SUM(qty)qty FROM(
SELECT txnmappedmobile,EANcode,COUNT(DISTINCT uniquebillno)bills,SUM(itemnetamount)sales,SUM(itemqty)qty 
FROM sku_report_loyalty a  JOIN dummy.harish_blackberrys_EANcode_pos_itemmaster_aprl_25 b ON a.UniqueItemcode=b.EANcode
WHERE modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31'
GROUP BY 1,2)a
GROUP BY 1;


-- use this for this table dummy.harish_blackberrys_EANcode_pos_itemmaster_aprl_25
SELECT EANcode,COUNT(DISTINCT txnmappedmobile)customers_count,SUM(bills)bills,SUM(sales)sales,SUM(qty)qty FROM(
SELECT txnmappedmobile,EANcode,COUNT(DISTINCT uniquebillno)bills,SUM(itemnetamount)sales,SUM(itemqty)qty 
FROM sku_report_loyalty a  LEFT JOIN dummy.harish_blackberrys_EANcode_pos_itemmaster_aprl_25 b ON a.UniqueItemcode=b.EANcode
WHERE modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31' AND uniqueitemcode IS NOT NULL
GROUP BY 1,2)a
GROUP BY 1;



SELECT COUNT(*) FROM  sku_report_loyalty a  
LEFT JOIN dummy.harish_blackberrys_EANcode_pos_itemmaster_aprl_25 b ON a.UniqueItemcode=b.EANcode
WHERE modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31' AND uniqueitemcode IS NOT NULL


SELECT COUNT(DISTINCT txnmappedmobile) FROM sku_report_loyalty WHERE uniqueitemcode='8903016001615'
AND modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31'

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


