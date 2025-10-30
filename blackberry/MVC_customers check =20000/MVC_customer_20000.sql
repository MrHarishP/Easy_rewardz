INSERT INTO dummy.mvc_base
SELECT mobile,tier FROM member_report WHERE tier = 'MVC';#147264



ALTER TABLE dummy.mvc_base ADD INDEX mobile(mobile),ADD COLUMN visit INT;

UPDATE dummy.mvc_base a JOIN (
SELECT mobile,COUNT(DISTINCT txndate)visit FROM txn_report_accrual_redemption
WHERE txndate BETWEEN DATE_SUB('2025-06-22', INTERVAL 12 MONTH) AND '2025-06-22'
GROUP BY 1)b USING(mobile)
SET a.visit =b.visit;#109447




SELECT COUNT(*) FROM dummy.mvc_base  WHERE visit=1;#47436

SELECT COUNT(*) FROM dummy.mvc_base  WHERE visit>1;#62011 select 47436+62011+37817

SELECT COUNT(*) FROM dummy.mvc_base  WHERE visit IS NULL;#37817

SELECT CASE WHEN frequencycount=1 THEN 'onetimer'
WHEN frequencycount>1 THEN 'repeater' ELSE 'not required' END tag, mobile,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills 
FROM dummy.mvc_base a LEFT JOIN txn_report_accrual_redemption b USING(mobile)
WHERE txndate BETWEEN DATE_SUB('2025-06-22', INTERVAL 12 MONTH) AND '2025-06-22'
GROUP BY 1,2;


SELECT CASE WHEN frequencycount=1 THEN 'onetimer' 
WHEN frequencycount>1 THEN 'repeater' END tag,mobile,SUM(sales)sales,SUM(bills)bills FROM (
SELECT mobile,frequencycount,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills FROM dummy.mvc_base a LEFT JOIN txn_report_accrual_redemption b USING(mobile)
WHERE txndate BETWEEN DATE_SUB('2025-06-22', INTERVAL 12 MONTH) AND '2025-06-22'
GROUP BY 1)a
WHERE sales>=20000
GROUP BY 2;

WITH base AS (
SELECT mobile,frequencycount,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills FROM dummy.mvc_base a LEFT JOIN txn_report_accrual_redemption b USING(mobile)
WHERE txndate BETWEEN DATE_SUB('2025-06-22', INTERVAL 12 MONTH) AND '2025-06-22'
GROUP BY 1)

SELECT CASE WHEN frequencycount=1 THEN 'onetimer' 
 WHEN frequencycount>1 THEN 'repeater' END tag,mobile,SUM(sales)sales,SUM(bills)bills FROM base 
 WHERE sales>=20000
 GROUP BY 2;

SELECT * FROM txn_report_accrual_redemption
WHERE mobile = '6000083945'

SELECT mobile,MIN(modifiedtxndate),MAX(modifiedtxndate),SUM(itemnetamount)sales FROM dummy.mvc_base a LEFT JOIN sku_report_loyalty b ON a.mobile=b.txnmappedmobile
WHERE modifiedtxndate BETWEEN DATE_SUB('2025-06-22', INTERVAL 12 MONTH) AND '2025-06-22' AND visit IS NULL
GROUP BY 1;

SELECT COUNT(DISTINCT mobile) FROM (
SELECT mobile,SUM(amount)sales FROM dummy.mvc_base a LEFT JOIN txn_report_accrual_redemption b USING(mobile)
WHERE txndate BETWEEN DATE_SUB('2025-06-22', INTERVAL 12 MONTH) AND '2025-06-22' 
-- AND visit IS NULL
GROUP BY 1
HAVING sales>=20000)a;



SELECT COUNT(DISTINCT CASE WHEN minf=1 AND maxf=1 THEN mobile END) 'onetimer',
COUNT(DISTINCT  CASE WHEN maxf>1 THEN mobile END )'repearter' FROM (
SELECT mobile,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills,MIN(frequencycount)minf,MAX(frequencycount)maxf
FROM dummy.mvc_base a LEFT JOIN txn_report_accrual_redemption b USING(mobile)
WHERE txndate BETWEEN DATE_SUB('2025-06-22', INTERVAL 12 MONTH) AND '2025-06-22'
GROUP BY 1)a;





SELECT CASE WHEN minf=1 AND maxf=1 THEN 'onetimer'
WHEN maxf>1 THEN 'repearter' END tag,mobile,SUM(sales)sales,SUM(bills)bills FROM (
SELECT mobile,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills,MIN(frequencycount)minf,MAX(frequencycount)maxf
FROM dummy.mvc_base a LEFT JOIN txn_report_accrual_redemption b USING(mobile)
WHERE txndate BETWEEN DATE_SUB('2025-06-22', INTERVAL 12 MONTH) AND '2025-06-22'
GROUP BY 1)a
WHERE sales>=20000
GROUP BY 1,2;


SELECT CASE WHEN minf=1 AND maxf=1 THEN 'onetimer'
WHEN minf=1 AND maxf>1 THEN 'new repearter'
WHEN minf>1 THEN 'old repearter'
END tag,mobile,SUM(sales)sales,SUM(bills)bills FROM (
SELECT mobile,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills,MIN(frequencycount)minf,MAX(frequencycount)maxf
FROM dummy.mvc_base a LEFT JOIN txn_report_accrual_redemption b USING(mobile)
GROUP BY 1)a
GROUP BY 1,2;
