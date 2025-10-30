SELECT * FROM item_master LIMIT 100;

SELECT categoryname,departmentname,COUNT(DISTINCT txnmappedmobile)customer,SUM(sales)sales,SUM(bills)bills,SUM(itemqty)itemqty 
FROM(
SELECT txnmappedmobile,categoryname,departmentname,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills,
SUM(itemqty)itemqty FROM sku_report_loyalty LEFT JOIN item_master USING(uniqueitemcode)
WHERE modifiedtxndate BETWEEN '2025-03-01' AND '2025-03-31' 
AND storecode NOT LIKE '%demo%' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%role%'
GROUP BY 1,2)a 
GROUP BY 1;




SELECT * FROM member_report LIMIT 10;
SELECT COUNT(*) FROM member_report


SELECT CASE WHEN ap=0 THEN '0' 
WHEN ap>1 AND ap<=50 THEN '1-50'
WHEN ap>51 AND ap<=100 THEN '51-100'
WHEN ap>101 AND ap<=150 THEN '101-150'
WHEN ap>151 AND ap<=200 THEN '151-200'
WHEN ap>201 AND ap<=250 THEN '201-250'
WHEN ap>251 AND ap<=300 THEN '251-300'
WHEN ap>301 AND ap<=350 THEN '301-350'
WHEN ap>351 AND ap<=400 THEN '351-400'
WHEN ap>401 AND ap<=450 THEN '401-450' 
WHEN ap>451 AND ap<=500 THEN '451-500' 
WHEN ap>500 THEN '>500' 
END 'Points bucket',COUNT(DISTINCT mobile)customer FROM ( 
SELECT mobile,SUM(availablepoints) ap FROM member_report
GROUP BY 1)a
GROUP BY 1
ORDER BY ap;



SELECT COUNT(DISTINCT mobile) FROM member_report WHERE availablepoints BETWEEN 0 AND 1



SELECT COUNT(*)FROM member_report WHERE availablepoints>0 AND availablepoints<1



SELECT COUNT(DISTINCT mobile) FROM member_report WHERE availablepoints IS NOT NULL