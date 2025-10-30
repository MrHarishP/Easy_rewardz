##########################################################################################################

SET @startdate= '2025-03-01';
SET @enddate= LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH));
SET @startdate_1y= DATE_SUB(@startdate, INTERVAL 1 YEAR);
SET @enddate_1y= DATE_SUB(@enddate,INTERVAL 1 YEAR);
SELECT @startdate,@enddate,@startdate_1y,@enddate_1y;


-- year on year 
SELECT CONCAT(LEFT(MONTHNAME(txndate),3),(RIGHT(YEAR(txndate),2)))Month_name,
COUNT(DISTINCT mobile)Customer,SUM(amount)Sales,COUNT(DISTINCT uniquebillno)Bills 
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN @startdate AND @enddate 
AND amount>0 AND storecode <> 'demo' 
GROUP BY 1 
UNION
SELECT CONCAT(LEFT(MONTHNAME(txndate),3),(RIGHT(YEAR(txndate),2)))Month_name,
COUNT(DISTINCT mobile)Customer,SUM(amount)Sales,COUNT(DISTINCT uniquebillno)Bills 
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN @startdate_1y AND @enddate_1y 
AND amount>0 AND storecode <> 'demo' 
GROUP BY 1;



##########################################################################################################
-- current year
SET @startdate= '2025-03-01';
SET @enddate= LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH));
SELECT @startdate,@enddate;

-- year on year 
SELECT CONCAT(LEFT(MONTHNAME(txndate),3),(RIGHT(YEAR(txndate),2)))Month_name,
COUNT(DISTINCT mobile)Customer,SUM(amount)Sales,COUNT(DISTINCT uniquebillno)Bills 
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN @startdate AND @enddate 
AND amount>0 AND storecode <> 'demo' 
GROUP BY 1 



-- last year
SET @startdate= '2025-03-01';
SET @enddate= LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH));
SET @startdate_1y= DATE_SUB(@startdate, INTERVAL 1 YEAR);
SET @enddate_1y= DATE_SUB(@enddate,INTERVAL 1 YEAR);
SELECT @startdate,@enddate,@startdate_1y,@enddate_1y;
SELECT CONCAT(LEFT(MONTHNAME(txndate),3),(RIGHT(YEAR(txndate),2)))Month_name,
COUNT(DISTINCT mobile)Customer,SUM(amount)Sales,COUNT(DISTINCT uniquebillno)Bills 
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN @startdate_1y AND @enddate_1y 
AND amount>0 AND storecode <> 'demo' 
GROUP BY 1;


-- __________________________________________________-end____________________




