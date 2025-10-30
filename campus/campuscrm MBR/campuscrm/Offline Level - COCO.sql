SET @startdate = DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-01');
SET @enddate = LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH));
SELECT @startdate,@enddate;


SET @startdate_1m = DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 2 MONTH), '%Y-%m-01');
SET @enddate_1m = LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 2 MONTH));

SELECT @startdate_1m,@ENDDATE_1M ;


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
FROM(
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
  a JOIN store_master b USING(storecode)
   WHERE TxnDate BETWEEN @startdate AND @enddate
    AND storecode NOT IN ('Demo','ecom','corporate')
    AND billno NOT LIKE '%test%' 
    AND billno NOT LIKE '%roll%' AND amount>0
    AND storetype1 LIKE '%coco%'
--     and mobile in (select distinct mobile from member_report)
  GROUP BY mobile, TxnMonth, TxnYear)a GROUP BY 1,2
  UNION 
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
FROM(
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
  a JOIN store_master b USING(storecode)
 WHERE TxnDate BETWEEN @startdate_1m AND @enddate_1m
    AND storecode NOT IN ('Demo','ecom','corporate')
    AND billno NOT LIKE '%test%' 
    AND billno NOT LIKE '%roll%' AND amount>0
    AND storetype1 LIKE '%coco%'
--     and mobile in (select distinct mobile from member_report)
  GROUP BY mobile, TxnMonth, TxnYear)a GROUP BY 1,2
  UNION 
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
FROM(
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
  a JOIN store_master b USING(storecode)
   WHERE TxnDate BETWEEN @startdate- INTERVAL 1 YEAR AND @enddate- INTERVAL 1 YEAR
    AND storecode NOT IN ('Demo','ecom','corporate')
    AND billno NOT LIKE '%test%' 
    AND billno NOT LIKE '%roll%' AND a.amount>0
    AND storetype1 LIKE '%coco%'
--     and mobile in (select distinct mobile from member_report)
  GROUP BY mobile, TxnMonth, TxnYear)a GROUP BY 1,2;

  
  
  
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
ROUND(SUM(CASE WHEN minf > 1 THEN sales END) / NULLIF(COUNT(CASE WHEN minf > 1 THEN mobile END), 0), 2) AS `Repeat Customer's AMV`
FROM(
  SELECT 
    mobile,
    TxnMonth,
    TxnYear,
    SUM(Amount) AS sales,
    COUNT(DISTINCT UniqueBillNo) AS bills,
    MAX(frequencycount) AS maxf, 
    MIN(frequencycount) AS minf
 FROM txn_report_accrual_redemption 
  a JOIN store_master b USING(storecode)
   WHERE TxnDate BETWEEN '2025-06-01' AND '2025-06-30'
    AND storecode NOT IN ('Demo','ecom','corporate')
    AND billno NOT LIKE '%test%' 
    AND billno NOT LIKE '%roll%' AND a.amount>0
--     AND storetype1 LIKE '%coco%'
AND storecode ='CAPLLMLK'
  GROUP BY mobile, TxnMonth, TxnYear)a GROUP BY 1,2 ; 
  
  
  
--   QC
  
SELECT COUNT(DISTINCT mobile)CUSTOMER,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills 
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2024-09-01' AND '2024-09-30' AND amount>0 
AND billno NOT LIKE '%roll%' AND billno NOT LIKE '%test%' 
AND storecode NOT IN ('Demo','ecom','corporate')
AND mobile IN (SELECT DISTINCT mobile FROM member_report)
AND storecode IN (SELECT storecode FROM store_master WHERE storetype1='coco');




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
AND modifiedstorecode IN (SELECT DISTINCT storecode FROM store_master WHERE storetype1= 'COCO')
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
AND modifiedstorecode IN (SELECT DISTINCT storecode FROM store_master WHERE storetype1= 'COCO')
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
AND modifiedstorecode IN (SELECT DISTINCT storecode FROM store_master WHERE storetype1= 'COCO')
AND insertiondate<CURDATE()

SELECT COUNT(DISTINCT mobile)CUSTOMER,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills 
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2025-08-01' AND '2025-08-31' AND amount>0 
AND billno NOT LIKE '%roll%' AND billno NOT LIKE '%test%' 
AND storecode NOT IN ('Demo','ecom','corporate')
AND mobile IN (SELECT DISTINCT mobile FROM member_report)
AND storecode IN (SELECT storecode FROM store_master WHERE storetype1 ='coco');



SELECT COUNT(DISTINCT mobile)CUSTOMER,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills 
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2025-06-01' AND '2025-06-30' AND amount>0 
AND billno NOT LIKE '%roll%' AND billno NOT LIKE '%test%' 
AND storecode NOT IN ('Demo','ecom','corporate')
AND storecode IN (SELECT storecode FROM store_master WHERE storetype1 ='fofo');


SELECT storetype1,storecode,lpaasstore FROM store_master
GROUP BY 1,2
WHERE storecode = 'CAPLGDUK'