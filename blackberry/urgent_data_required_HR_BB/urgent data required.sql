


SELECT PERIOD,SUM(sales)Loyalty_sales,
SUM(CASE WHEN minf=1 AND maxf=1 THEN sales END)+SUM(CASE WHEN minf=1 AND maxf>1 THEN sales END)new_customer_sales,
SUM(CASE WHEN minf>1 THEN sales END)Repeat_customer_sales,
COUNT(DISTINCT mobile)Total_customer,
COUNT(DISTINCT  CASE WHEN minf=1 AND maxf=1 THEN mobile END)+COUNT(DISTINCT CASE WHEN minf=1 AND maxf>1 THEN mobile END)new_customer,
COUNT(DISTINCT CASE WHEN minf>1 THEN mobile END)Repeat_customer
FROM(
SELECT mobile,CASE 
WHEN txndate BETWEEN '2024-10-01' AND '2024-11-03' THEN 'LY'
WHEN txndate BETWEEN '2025-09-20' AND '2025-10-23' THEN 'TY' END PERIOD,
MIN(frequencycount)minf,MAX(frequencycount)maxf,
SUM(amount)sales
FROM txn_report_accrual_redemption 
WHERE ((txndate BETWEEN '2024-10-01' AND '2024-11-03') 
OR (txndate BETWEEN '2025-09-20' AND '2025-10-23'))
AND storecode <> 'demo'
AND storecode <> 'corporate'
AND amount>0
GROUP BY 1,2)a GROUP BY 1;




SELECT CASE 
WHEN modifiedtxndate BETWEEN '2024-10-01' AND '2024-11-03' THEN 'LY'
WHEN modifiedtxndate BETWEEN '2025-09-20' AND '2025-10-23' THEN 'TY' END PERIOD,
SUM(itemnetamount)nonloyalty_sales
FROM sku_report_nonloyalty 
WHERE ((modifiedtxndate BETWEEN '2024-10-01' AND '2024-11-03') 
OR (modifiedtxndate BETWEEN '2025-09-20' AND '2025-10-23'))
AND modifiedstorecode <> 'demo'
AND modifiedstorecode <> 'corporate'
AND itemnetamount>0
GROUP BY 1;




WITH base AS (
SELECT mobile,CASE 
WHEN txndate BETWEEN '2024-10-01' AND '2024-11-03' THEN 'LY'
WHEN txndate BETWEEN '2025-09-20' AND '2025-10-23' THEN 'TY' END PERIOD,
MIN(frequencycount)minf,MAX(frequencycount)maxf,
SUM(amount)sales
FROM txn_report_accrual_redemption 
WHERE ((txndate BETWEEN '2024-10-01' AND '2024-11-03') 
OR (txndate BETWEEN '2025-09-20' AND '2025-10-23'))
AND storecode <> 'demo'
AND storecode <> 'corporate'
AND amount>0
GROUP BY 1,2)
 SELECT PERIOD,SUM(sales)Loyalty_sales,
SUM(CASE WHEN minf=1 AND maxf=1 THEN sales END)+SUM(CASE WHEN minf=1 AND maxf>1 THEN sales END)new_customer_sales,
SUM(CASE WHEN minf>1 THEN sales END)Repeat_customer_sales,
COUNT(DISTINCT mobile)Total_customer,
COUNT(DISTINCT  CASE WHEN minf=1 AND maxf=1 THEN mobile END)+COUNT(DISTINCT CASE WHEN minf=1 AND maxf>1 THEN mobile END)new_customer,
COUNT(DISTINCT CASE WHEN minf>1 THEN mobile END)Repeat_customer
FROM base 
GROUP BY 1;


SELECT txndate,COUNT(uniquebillno) FROM txn_report_accrual_redemption
GROUP BY 1


