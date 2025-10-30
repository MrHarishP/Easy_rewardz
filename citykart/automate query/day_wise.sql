

SET @startdate= '2025-03-01';
SET @enddate= LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH));

SELECT @startdate,@enddate;

-- day wise 
SELECT days_wise,
COUNT(DISTINCT mobile)customers,
SUM(sales)sales,
SUM(bills)bills FROM (
SELECT CASE WHEN DAYNAME(txndate) NOT IN ('saturday','sunday') THEN 'weekdays'
WHEN DAYNAME(txndate) IN ('saturday','sunday') THEN 'weekends' 
END 'days_wise',
mobile,
SUM(amount) sales,
COUNT(DISTINCT UniqueBillNo) AS bills
FROM txn_report_accrual_redemption 
WHERE TxnDate BETWEEN @startdate AND @enddate 
AND storecode <> 'demo' AND amount>0
 AND (DAYNAME(txndate) NOT IN ('saturday','sunday')
 OR (DAYNAME(txndate) IN ('saturday','sunday')))
GROUP BY 1,2)a
GROUP BY 1;
