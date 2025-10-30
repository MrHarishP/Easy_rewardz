#############################################################################################

SET @startdate= '2025-03-01';
SET @enddate= LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH));

SELECT @startdate,@enddate;

-- customer segmentation
SELECT 
	CASE 
	WHEN frequencycount=1 THEN 'onetimer' 
	WHEN frequencycount>1 THEN 'repeater' 
END 'customer type',
COUNT(DISTINCT mobile)customer,
SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills,
SUM(amount)/COUNT(DISTINCT mobile)AMV 
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN @startdate AND @enddate 
AND amount>0 AND storecode <> 'demo'
GROUP BY 1;