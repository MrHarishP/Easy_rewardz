-- Offline Level



SET @startdate = DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-01');
SET @enddate = LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH));

SELECT @startdate,@enddate;

SET @startdate_1m = DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 2 MONTH), '%Y-%m-01');
SET @enddate_1m = LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 2 MONTH));
SELECT @startdate_1m, @enddate_1m;	
	
	
-- 	current month mbr
SELECT TxnMonth, TxnYear,
  COUNT(DISTINCT mobile) AS `Transacting Customer`,
  COUNT(DISTINCT CASE WHEN minf = 1 THEN mobile END) AS `New Customers`,
  COUNT(DISTINCT CASE WHEN maxf = 1 AND minf = 1 THEN mobile END) AS `New Onetimer`,
  COUNT(DISTINCT CASE WHEN maxf > 1 AND minf = 1 THEN mobile END) AS `New_Repeater`,
  COUNT(DISTINCT CASE WHEN minf > 1 THEN mobile END) AS `Repeat Customers (Existing)`,
  SUM(sales) AS `Loyalty Sales`,
  SUM(CASE WHEN minf = 1 THEN sales END) AS `New Customer's Sales`,
  SUM(CASE WHEN minf > 1 THEN sales END) AS `Repeat Customer's Sales`,
  SUM(bills) AS `Loyalty Bills`,
  SUM(CASE WHEN minf = 1 THEN bills END) AS `New Customer's Bills`,
  SUM(CASE WHEN minf > 1 THEN bills END) AS `Repeat Customer's Bills`,
  ROUND(SUM(sales) / NULLIF(SUM(bills), 0), 2) AS `Overall ATV`,
  ROUND(SUM(CASE WHEN minf = 1 THEN sales END) / NULLIF(SUM(CASE WHEN minf = 1 THEN bills END), 0), 2) AS `New Customers ATV`,
  ROUND(SUM(CASE WHEN minf > 1 THEN sales END) / NULLIF(SUM(CASE WHEN minf > 1 THEN bills END), 0), 2) AS `Repeat Customers ATV`,
ROUND(SUM(sales) / NULLIF(COUNT(mobile), 0), 2) AS `Overall AMV`,
ROUND(SUM(CASE WHEN minf = 1 THEN sales END) / NULLIF(COUNT(CASE WHEN minf = 1 THEN mobile END), 0), 2) AS `New Customer's AMV`,
ROUND(SUM(CASE WHEN minf > 1 THEN sales END) / NULLIF(COUNT(CASE WHEN minf > 1 THEN mobile END), 0), 2) AS `Repeat Customer's AMV`,
AVG(frequencycount)overall_frequencycount

FROM (
  SELECT 
    mobile,
    TxnMonth,
    TxnYear,
    SUM(Amount) AS sales,
    COUNT(DISTINCT UniqueBillNo) AS bills,
    MAX(frequencycount) AS maxf, 
    MIN(frequencycount) AS minf,
    COUNT(DISTINCT frequencycount)frequencycount
  FROM txn_report_accrual_redemption 
  WHERE TxnDate BETWEEN @startdate AND @enddate
--   AND mobile IN (SELECT mobile FROM member_report)
    AND storecode NOT IN ('Demo','ecom','corporate')
    AND billno NOT LIKE '%test%' 
    AND billno NOT LIKE '%roll%' AND amount>0
  GROUP BY mobile, TxnMonth, TxnYear
) a GROUP BY 1,2
UNION 
-- previous month mbr
SELECT 
TxnMonth, TxnYear,
  COUNT(DISTINCT mobile) AS `Transacting Customer`,
  COUNT(DISTINCT CASE WHEN minf = 1 THEN mobile END) AS `New Customers`,
  COUNT(DISTINCT CASE WHEN maxf = 1 AND minf = 1 THEN mobile END) AS `New Onetimer`,
  COUNT(DISTINCT CASE WHEN maxf > 1 AND minf = 1 THEN mobile END) AS `New_Repeater`,
  COUNT(DISTINCT CASE WHEN minf > 1 THEN mobile END) AS `Repeat Customers (Existing)`,
  SUM(sales) AS `Loyalty Sales`,
  SUM(CASE WHEN minf = 1 THEN sales END) AS `New Customer's Sales`,
  SUM(CASE WHEN minf > 1 THEN sales END) AS `Repeat Customer's Sales`,
  SUM(bills) AS `Loyalty Bills`,
  SUM(CASE WHEN minf = 1 THEN bills END) AS `New Customer's Bills`,
  SUM(CASE WHEN minf > 1 THEN bills END) AS `Repeat Customer's Bills`,
  ROUND(SUM(sales) / NULLIF(SUM(bills), 0), 2) AS `Overall ATV`,
  ROUND(SUM(CASE WHEN minf = 1 THEN sales END) / NULLIF(SUM(CASE WHEN minf = 1 THEN bills END), 0), 2) AS `New Customers ATV`,
  ROUND(SUM(CASE WHEN minf > 1 THEN sales END) / NULLIF(SUM(CASE WHEN minf > 1 THEN bills END), 0), 2) AS `Repeat Customers ATV`,
ROUND(SUM(sales) / NULLIF(COUNT(mobile), 0), 2) AS `Overall AMV`,
ROUND(SUM(CASE WHEN minf = 1 THEN sales END) / NULLIF(COUNT(CASE WHEN minf = 1 THEN mobile END), 0), 2) AS `New Customer's AMV`,
ROUND(SUM(CASE WHEN minf > 1 THEN sales END) / NULLIF(COUNT(CASE WHEN minf > 1 THEN mobile END), 0), 2) AS `Repeat Customer's AMV`,
AVG(frequencycount)overall_frequencycount
FROM (
  SELECT 
    mobile,
    TxnMonth,
    TxnYear,
    SUM(Amount) AS sales,
    COUNT(DISTINCT UniqueBillNo) AS bills,
    MAX(frequencycount) AS maxf, 
    MIN(frequencycount) AS minf,
    COUNT(DISTINCT frequencycount)frequencycount
  FROM txn_report_accrual_redemption 
  WHERE TxnDate BETWEEN @startdate_1m  AND @enddate_1m
--   AND mobile IN (SELECT mobile FROM member_report)
    AND storecode NOT IN ('Demo','ecom','corporate')
    AND billno NOT LIKE '%test%' 
    AND billno NOT LIKE '%roll%'AND amount>0
  GROUP BY mobile, TxnMonth, TxnYear
) a GROUP BY 1,2
UNION 
-- preivous year mbr month
SELECT TxnMonth, TxnYear,
  COUNT(DISTINCT mobile) AS `Transacting Customer`,
  COUNT(DISTINCT CASE WHEN minf = 1 THEN mobile END) AS `New Customers`,
  COUNT(DISTINCT CASE WHEN maxf = 1 AND minf = 1 THEN mobile END) AS `New Onetimer`,
  COUNT(DISTINCT CASE WHEN maxf > 1 AND minf = 1 THEN mobile END) AS `New_Repeater`,
  COUNT(DISTINCT CASE WHEN minf > 1 THEN mobile END) AS `Repeat Customers (Existing)`,
  SUM(sales) AS `Loyalty Sales`,
  SUM(CASE WHEN minf = 1 THEN sales END) AS `New Customer's Sales`,
  SUM(CASE WHEN minf > 1 THEN sales END) AS `Repeat Customer's Sales`,
  SUM(bills) AS `Loyalty Bills`,
  SUM(CASE WHEN minf = 1 THEN bills END) AS `New Customer's Bills`,
  SUM(CASE WHEN minf > 1 THEN bills END) AS `Repeat Customer's Bills`,
  ROUND(SUM(sales) / NULLIF(SUM(bills), 0), 2) AS `Overall ATV`,
  ROUND(SUM(CASE WHEN minf = 1 THEN sales END) / NULLIF(SUM(CASE WHEN minf = 1 THEN bills END), 0), 2) AS `New Customers ATV`,
  ROUND(SUM(CASE WHEN minf > 1 THEN sales END) / NULLIF(SUM(CASE WHEN minf > 1 THEN bills END), 0), 2) AS `Repeat Customers ATV`,
ROUND(SUM(sales) / NULLIF(COUNT(mobile), 0), 2) AS `Overall AMV`,
ROUND(SUM(CASE WHEN minf = 1 THEN sales END) / NULLIF(COUNT(CASE WHEN minf = 1 THEN mobile END), 0), 2) AS `New Customer's AMV`,
ROUND(SUM(CASE WHEN minf > 1 THEN sales END) / NULLIF(COUNT(CASE WHEN minf > 1 THEN mobile END), 0), 2) AS `Repeat Customer's AMV`,
AVG(frequencycount)overall_frequencycount
FROM (
  SELECT 
    mobile,
    TxnMonth,
    TxnYear,
    SUM(Amount) AS sales,
    COUNT(DISTINCT UniqueBillNo) AS bills,
    MAX(frequencycount) AS maxf, 
    MIN(frequencycount) AS minf,
    COUNT(DISTINCT frequencycount)frequencycount
  FROM txn_report_accrual_redemption  
  WHERE TxnDate BETWEEN @startdate - INTERVAL 1 YEAR AND @enddate - INTERVAL 1 YEAR
    AND storecode NOT IN ('Demo','ecom','corporate')
--     AND mobile IN (SELECT mobile FROM member_report)
    AND billno NOT LIKE '%test%' 
    AND billno NOT LIKE '%roll%'AND amount>0
    AND insertiondate<CURDATE()
  GROUP BY mobile, TxnMonth, TxnYear
) a GROUP BY 1,2;



-- non loyalty sales
SELECT 'sept-24' tag,
COUNT(DISTINCT uniquebillno)nonloyalty_bills,SUM(itemnetamount)NOn_loyalty_sales
FROM sku_report_nonloyalty
WHERE modifiedtxndate BETWEEN '2024-09-01' AND '2024-09-30'
AND modifiedstorecode NOT LIKE '%demo%'
AND modifiedbillno NOT LIKE '%test%'
AND modifiedbillno NOT LIKE '%roll%'
AND modifiedstorecode NOT IN ('Corporate')
AND modifiedstorecode NOT LIKE '%ecom%'
AND itemnetamount>0
UNION 
SELECT 'Aug-25',
COUNT(DISTINCT uniquebillno)nonloyalty_bills,SUM(itemnetamount)NOn_loyalty_sales
FROM sku_report_nonloyalty
WHERE modifiedtxndate BETWEEN '2025-08-01' AND '2025-08-31'
AND modifiedstorecode NOT LIKE '%demo%'
AND modifiedbillno NOT LIKE '%test%'
AND modifiedbillno NOT LIKE '%roll%'
AND modifiedstorecode NOT IN ('Corporate')
AND modifiedstorecode NOT LIKE '%ecom%'
AND itemnetamount>0
UNION
SELECT 'sept-25',
COUNT(DISTINCT uniquebillno)nonloyalty_bills,SUM(itemnetamount)NOn_loyalty_sales
FROM sku_report_nonloyalty
WHERE modifiedtxndate BETWEEN '2025-09-01' AND '2025-09-30'
AND modifiedstorecode NOT LIKE '%demo%'
AND modifiedbillno NOT LIKE '%test%'
AND modifiedbillno NOT LIKE '%roll%'
AND modifiedstorecode NOT IN ('Corporate')
AND modifiedstorecode NOT LIKE '%ecom%'
AND itemnetamount>0
AND insertiondate<CURDATE()

-- QC
SELECT COUNT(DISTINCT mobile)CUSTOMER,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills 
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2025-08-01' AND '2025-08-31' AND amount>0 
AND mobile IN (SELECT DISTINCT mobile FROM member_report)
AND storecode NOT LIKE '%demo%' AND billno NOT LIKE '%roll%' AND billno NOT LIKE '%test%' 
AND storecode <> 'ecom';






SELECT DISTINCT b.storecode,storetype1 FROM store_master a JOIN txn_report_accrual_redemption b USING(storecode)
WHERE TxnDate BETWEEN '2025-06-01' AND '2025-06-30'
AND storecode NOT IN ('Demo','ecom','corporate')
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'AND amount>0






SELECT COUNT(DISTINCT mobile)CUSTOMER,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills 
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2025-06-01' AND '2025-06-30' AND amount>0 
AND storecode NOT LIKE '%demo%' AND billno NOT LIKE '%roll%' AND billno NOT LIKE '%test%' 
AND storecode <> 'ecom'
AND storecode ='CAPLLMLK';


















SELECT * FROM store_master WHERE city ='gandhidham';

WITH txn AS
(SELECT  mobile 
FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2025-05-31'-INTERVAL 1 YEAR AND '2025-05-31'
AND amount>0 GROUP BY 1),

WITH store_data AS
(SELECT StoreCode,StoreType1 FROM store_master ),
 psv AS
(SELECT mobile,`last shopped store`,PreferredStore FROM program_single_view 
WHERE `Last Shopped Date` BETWEEN '2025-05-31'-INTERVAL 1 YEAR AND '2025-05-31'
AND `last shopped store`<>PreferredStore)
SELECT a* ,b.StoreType1 FROM store_data a LEFT JOIN psv b
ON a.`last shopped store`=b.StoreCode;


SELECT * FROM program_single_view

WITH store_data AS (
    SELECT StoreCode, StoreType1 FROM store_master
)
,psv AS (
    SELECT mobile,EnrolledStore, `last shopped store` 
    FROM program_single_view 
    WHERE `Last Shopped Date` BETWEEN DATE_SUB('2025-05-31', INTERVAL 1 YEAR) AND '2025-05-31'
    AND EnrolledStore<>`last shopped store`
 )
--  ,customer as(
 SELECT 
    psv.*, 
    store_data.StoreType1 
FROM psv
LEFT JOIN store_data 
    ON psv.EnrolledStore = store_data.StoreCode
--     )select StoreType1,count(mobile) from customer group by 1 ;
    
    
