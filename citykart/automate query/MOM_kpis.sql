SET @startdate= '2025-03-01';
SET @enddate= LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH));

SELECT @startdate,@enddate;

-- mom from mar to june25


SELECT MONTHNAME(txndate)MOM,
COUNT(DISTINCT mobile)customers,
SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills,
SUM(amount)/COUNT(DISTINCT mobile)AMV 
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN @startdate AND @enddate
AND amount>0 AND storecode <> 'demo'
GROUP BY 1
ORDER BY txndate;

-- QC
SELECT COUNT(DISTINCT mobile)customers,
SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills 
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2025-08-01' AND '2025-08-31' 
AND amount>0 AND storecode <> 'demo';