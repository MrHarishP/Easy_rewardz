#############################################################################################
-- mom from mar to june25


SELECT MONTHNAME(txndate)MOM,
COUNT(DISTINCT mobile)customers,
SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills,
SUM(amount)/COUNT(DISTINCT mobile)AMV 
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2025-03-01' AND '2025-08-31' 
AND amount>0 AND storecode <> 'demo'
GROUP BY 1
ORDER BY txndate;

-- QC
SELECT COUNT(DISTINCT mobile)customers,
SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills 
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2025-08-01' AND '2025-08-31' 
AND amount>0 AND storecode <> 'demo';

#############################################################################################
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
WHERE txndate BETWEEN '2025-03-01' AND '2025-08-31' 
AND amount>0 AND storecode <> 'demo'
GROUP BY 1;
-- QC

-- select mobile,frequencycount,sum(amount)sales,count(distinct uniquebillno)bills 
-- from txn_report_accrual_redemption 
-- WHERE txndate BETWEEN '2025-03-01' AND '2025-08-31' 
-- AND amount>0 AND storecode <> 'demo' AND frequencycount is null
-- group by 1;
-- 
-- select count(*) from program_single_view
-- where `total visits` = 0; #6402200
-- 
-- 
-- select count(*) from sku_report_loyalty 
-- where modifiedtxndate BETWEEN '2025-03-01' AND '2025-08-31' 
-- AND itemnetamount>0 AND modifiedstorecode <> 'demo' AND frequencycount IS NULL

SELECT COUNT(DISTINCT mobile),SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills 
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2025-03-01' AND '2025-07-31' 
AND amount>0 AND storecode <> 'demo' AND frequencycount>1;

##########################################################################################################
-- year on year 
SELECT CONCAT(LEFT(MONTHNAME(txndate),3),(RIGHT(YEAR(txndate),2)))Month_name,
COUNT(DISTINCT mobile)Customer,SUM(amount)Sales,COUNT(DISTINCT uniquebillno)Bills 
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2025-03-01' AND '2025-08-31' 
AND amount>0 AND storecode <> 'demo' 
GROUP BY 1 
UNION
SELECT CONCAT(LEFT(MONTHNAME(txndate),3),(RIGHT(YEAR(txndate),2)))Month_name,
COUNT(DISTINCT mobile)Customer,SUM(amount)Sales,COUNT(DISTINCT uniquebillno)Bills 
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2024-03-01' AND '2024-08-31' 
AND amount>0 AND storecode <> 'demo' 
GROUP BY 1;

-- QC
SELECT COUNT(DISTINCT mobile)customers,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills 
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2024-03-01' AND '2024-07-31' 
AND amount>0 AND storecode <> 'demo';

###############################################################################################################

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
WHERE TxnDate BETWEEN '2025-03-01' AND '2025-08-31' 
AND storecode <> 'demo' AND amount>0
 AND (DAYNAME(txndate) NOT IN ('saturday','sunday')
 OR (DAYNAME(txndate) IN ('saturday','sunday')))
GROUP BY 1,2)a
GROUP BY 1;




-- QC



SELECT 
SUM(amount) sales,
COUNT(DISTINCT UniqueBillNo) AS bills
FROM txn_report_accrual_redemption 
WHERE TxnDate BETWEEN '2025-03-01' AND '2025-07-31' 
AND storecode <> 'demo' AND amount>0
--  AND (DAYNAME(txndate) NOT IN ('saturday','sunday'))
--  OR 
AND (DAYNAME(txndate) IN ('saturday','sunday'))
;

######################################################################################################################
-- bill banding

SELECT 
CASE
	WHEN atv>=0 AND atv<=150 THEN '0-150'
	WHEN atv>150 AND atv<=300 THEN '150-300'
	WHEN atv>300 AND atv<=450 THEN '300-450'
	WHEN atv>450 AND atv<=600 THEN '450-600'
	WHEN atv>600 AND atv<=750 THEN '600-750'
	WHEN atv>750 AND atv<=900 THEN '750-900'
	WHEN atv>900 AND atv<=1050 THEN '900-1050'
	WHEN atv>1050 THEN '>1050' END atv_band,
	COUNT(DISTINCT mobile)cusotmer,
	SUM(sales)sales,SUM(bills)bills 
FROM (
SELECT mobile,SUM(amount)/COUNT(DISTINCT uniquebillno)atv,
SUM(amount)sales,
COUNT(DISTINCT uniquebillno)bills 
FROM txn_report_accrual_redemption 
WHERE TxnDate BETWEEN '2025-03-01' AND '2025-08-31' 
AND storecode <> 'demo' AND amount>0
GROUP BY 1)a
GROUP BY 1
ORDER BY atv;





-- QC


SELECT COUNT(DISTINCT mobile)cusotmer,
	SUM(sales)sales,SUM(bills)bills 
FROM (
SELECT mobile,SUM(amount)/COUNT(DISTINCT uniquebillno)atv,
SUM(amount)sales,
COUNT(DISTINCT uniquebillno)bills 
FROM txn_report_accrual_redemption 
WHERE TxnDate BETWEEN '2025-03-01' AND '2025-07-31' 
AND storecode <> 'demo' AND amount>0
GROUP BY 1)a
WHERE atv>450 AND atv<=600;
######################################################################################################
-- lifecycle


SELECT 
CASE 
	WHEN recency>=0 AND recency<=365 THEN 'active'
	WHEN recency>365 AND recency<=730 THEN 'dormant'
	WHEN recency>730 THEN 'lapsed' END 'tag',
	COUNT(DISTINCT mobile)customers,SUM(sales)sales,SUM(bills)bills FROM( 
SELECT mobile,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills,
DATEDIFF('2025-08-31',MAX(txndate))recency
FROM txn_report_accrual_redemption 
WHERE txndate <= '2025-08-31' 
AND storecode <> 'demo' AND amount>0
GROUP BY 1)a
GROUP BY 1;

INSERT INTO dummy.lifecycle_25
SELECT mobile,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills,
DATEDIFF('2025-08-31',MAX(txndate))recency
FROM txn_report_accrual_redemption 
WHERE txndate <= '2025-08-31' 
AND storecode <> 'demo' AND amount>0 
GROUP BY 1;#10048684

SELECT 
CASE 
	WHEN recency>=0 AND recency<=365 THEN 'active'
	WHEN recency>365 AND recency<=730 THEN 'dormant'
	WHEN recency>730 THEN 'lapsed' END 'tag',
	COUNT(DISTINCT mobile)customers,SUM(sales)sales,SUM(bills)bills 
FROM dummy.lifecycle_25
GROUP BY 1
-- QC
SELECT SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills FROM txn_report_accrual_redemption
WHERE txndate <= '2025-07-31' 
AND storecode <> 'demo' AND amount>0;



###################################################################################

-- bill wise for 1year

SELECT CASE WHEN bills<=6 THEN bills ELSE '6+' END bill_wise,
COUNT(DISTINCT mobile)customer,SUM(sales)sales,SUM(bills)bills FROM (
SELECT mobile,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills
-- DATEDIFF('2025-06-30',MAX(txndate))recency
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2024-08-01'  AND '2025-08-31' 
AND storecode <> 'demo' AND amount>0
GROUP BY 1)a
GROUP BY 1;



INSERT INTO dummy.bill_wise_24_25
SELECT mobile,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills
-- DATEDIFF('2025-06-30',MAX(txndate))recency
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2024-09-01'  AND '2025-08-31' 
AND storecode <> 'demo' AND amount>0 
GROUP BY 1;#6004880

SELECT CASE WHEN bills<=6 THEN bills ELSE '6+' END bill_wise,
COUNT(DISTINCT mobile)customer,SUM(sales)sales,SUM(bills)bills FROM 
dummy.bill_wise_24_25
GROUP BY 1;
-- bill wise for perticular duration


SELECT CASE WHEN bills<=6 THEN bills ELSE '6+' END bill_wise,
COUNT(DISTINCT mobile)customer,SUM(sales)sales,SUM(bills)bills FROM (
SELECT mobile,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills
-- DATEDIFF('2025-06-30',MAX(txndate))recency
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2025-03-01'  AND '2025-07-31' 
AND storecode <> 'demo' AND amount>0
GROUP BY 1)a
GROUP BY 1;


INSERT INTO dummy.bill_wise_25
SELECT mobile,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills
-- DATEDIFF('2025-06-30',MAX(txndate))recency
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2025-03-01'  AND '2025-08-31' 
AND storecode <> 'demo' AND amount>0 
GROUP BY 1;#3882967


SELECT CASE WHEN bills<=6 THEN bills ELSE '6+' END bill_wise,
COUNT(DISTINCT mobile)customer,SUM(sales)sales,SUM(bills)bills FROM 
dummy.bill_wise_25
GROUP BY 1;

SELECT COUNT(DISTINCT mobile)customer,SUM(sales)sales,SUM(bills)bills 
FROM (
SELECT mobile,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills
-- DATEDIFF('2025-06-30',MAX(txndate))recency
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2024-08-01'  AND '2025-07-31' 
AND storecode <> 'demo' AND amount>0
GROUP BY 1)a
WHERE bills=1;

###################################################################################




-- visit wise 


SELECT CASE WHEN visit<=6 THEN visit ELSE '6+' END visit,
COUNT(DISTINCT mobile)customer,SUM(sales)sales,SUM(bills)bills FROM (
SELECT mobile,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills,
COUNT(DISTINCT txndate,mobile)visit
-- DATEDIFF('2025-06-30',MAX(txndate))recency
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2025-03-01'  AND '2025-08-31' 
AND storecode <> 'demo' AND amount>0
GROUP BY 1)a
GROUP BY 1;


-- QC
SELECT COUNT(DISTINCT mobile)customer,SUM(sales)sales,SUM(bills) FROM (
SELECT mobile,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills,
COUNT(DISTINCT txndate,mobile)visit
-- DATEDIFF('2025-06-30',MAX(txndate))recency
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2025-03-01'  AND '2025-06-30' 
AND storecode <> 'demo' AND amount>0
GROUP BY 1)a
WHERE visit>6

####################################################################################################