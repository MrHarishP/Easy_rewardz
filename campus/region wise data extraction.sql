SELECT * FROM dummy.camp_coco_fofo_store a
LEFT JOIN store_master USING(storecode)
WHERE store_type LIKE 'coco';


#Customers who made their first transaction in current financial year and made a transaction in the given time period

-- for january  for coco
WITH base_data AS(
SELECT mobile,region,MAX(txndate)last_txndate,MIN(frequencycount)minfc,MAX(frequencycount)maxfc,frequencycount fc,
COUNT(DISTINCT txndate,mobile)visit,
SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills,c.storecode,txndate 
FROM txn_report_accrual_redemption a LEFT JOIN store_master b USING(storecode)
JOIN dummy.camp_coco_fofo_store c ON a.storecode=c.storecode
WHERE txndate BETWEEN '2024-04-01' AND '2025-01-31' 
AND b.storecode NOT LIKE '%demo%' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND store_type ='coco'
GROUP BY 1,2)
SELECT region,COUNT(DISTINCT CASE WHEN minfc=1 AND maxfc=1 THEN  mobile END)+
COUNT(DISTINCT CASE WHEN minfc=1 AND maxfc>1 THEN  mobile END)new_customer,
COUNT(DISTINCT CASE WHEN minfc=1 AND maxfc=1 THEN mobile END)first_timer,
COUNT(DISTINCT CASE WHEN minfc>1 AND maxfc>1 THEN mobile END)repeater,
SUM(CASE WHEN minfc=1 AND maxfc=1 THEN  sales END)+
SUM(CASE WHEN minfc=1 AND maxfc>1 THEN  sales END)new_customer_revenue,
SUM(CASE WHEN minfc=1 AND maxfc=1 THEN sales END)first_timer_revenue,
SUM(CASE WHEN minfc>1 AND maxfc>1 THEN sales END)repeater_revenue
FROM base_data
WHERE txndate BETWEEN '2025-01-01' AND '2025-01-31'
GROUP BY 1;

###################################333333
-- exisitng sale and customer 
SELECT region,COUNT(DISTINCT mobile)exisiting_customer,SUM(amount)existing_revenue FROM txn_report_accrual_redemption a 
JOIN store_master b ON a.storecode=b.storecode 
WHERE txndate BETWEEN '2025-01-01' AND '2025-01-31'
AND mobile IN (SELECT DISTINCT mobile FROM txn_report_accrual_redemption a JOIN dummy.camp_coco_fofo_store b USING(storecode) WHERE txndate<'2024-04-01' AND frequencycount=1
AND b.storecode NOT LIKE '%demo%' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND store_type ='coco')
GROUP BY 1;
##########################################3



-- for FY 2024-2025 
WITH base_data AS(
SELECT mobile,region,MAX(txndate)last_txndate,MIN(frequencycount)minfc,MAX(frequencycount)maxfc,frequencycount fc,
COUNT(DISTINCT txndate,mobile)visit,
SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills,c.storecode,txndate 
FROM txn_report_accrual_redemption a LEFT JOIN store_master b USING(storecode)
JOIN dummy.camp_coco_fofo_store c ON a.storecode=b.storecode
WHERE txndate BETWEEN '2024-04-01' AND '2025-01-31'
AND b.storecode NOT LIKE '%demo%' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND store_type ='coco'
GROUP BY 1,2)
SELECT region,COUNT(DISTINCT CASE WHEN minfc=1 AND maxfc=1 THEN  mobile END)+
COUNT(DISTINCT CASE WHEN minfc=1 AND maxfc>1 THEN  mobile END)new_customer,
COUNT(DISTINCT CASE WHEN minfc=1 AND maxfc=1 THEN mobile END)first_timer,
COUNT(DISTINCT CASE WHEN minfc>1 AND maxfc>1 THEN mobile END)repeater,
SUM(CASE WHEN minfc=1 AND maxfc=1 THEN  sales END)+
SUM(CASE WHEN minfc=1 AND maxfc>1 THEN  sales END)new_customer_revenue,
SUM(CASE WHEN minfc=1 AND maxfc=1 THEN sales END)first_timer_revenue,
SUM(CASE WHEN minfc>1 AND maxfc>1 THEN sales END)repeater_revenue
FROM base_data
WHERE txndate BETWEEN '2024-04-01' AND '2025-01-31'
GROUP BY 1;


###################################333333
-- exisitng sale and customer 
SELECT region,COUNT(DISTINCT mobile)exisiting_customer,SUM(amount)existing_revenue FROM txn_report_accrual_redemption a LEFT JOIN store_master b USING(storecode)
WHERE txndate BETWEEN '2024-04-01' AND '2025-01-31'
AND mobile IN (SELECT DISTINCT mobile FROM txn_report_accrual_redemption a JOIN dummy.camp_coco_fofo_store b USING(storecode)
WHERE txndate<'2024-04-01' AND frequencycount=1
AND b.storecode NOT LIKE '%demo%' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND store_type ='coco')
GROUP BY 1;
##########################################3








-- for january  for foco
WITH base_data AS(
SELECT mobile,region,MAX(txndate)last_txndate,MIN(frequencycount)minfc,MAX(frequencycount)maxfc,frequencycount fc,
COUNT(DISTINCT txndate,mobile)visit,
SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills,c.storecode,txndate 
FROM txn_report_accrual_redemption a LEFT JOIN store_master b USING(storecode)
JOIN dummy.camp_coco_fofo_store c ON a.storecode=c.storecode
WHERE txndate BETWEEN '2024-04-01' AND '2025-01-31' 
AND b.storecode NOT LIKE '%demo%' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND store_type ='foco'
GROUP BY 1,2)
SELECT region,COUNT(DISTINCT CASE WHEN minfc=1 AND maxfc=1 THEN  mobile END)+
COUNT(DISTINCT CASE WHEN minfc=1 AND maxfc>1 THEN  mobile END)new_customer,
COUNT(DISTINCT CASE WHEN minfc=1 AND maxfc=1 THEN mobile END)first_timer,
COUNT(DISTINCT CASE WHEN minfc>1 AND maxfc>1 THEN mobile END)repeater,
SUM(CASE WHEN minfc=1 AND maxfc=1 THEN  sales END)+
SUM(CASE WHEN minfc=1 AND maxfc>1 THEN  sales END)new_customer_revenue,
SUM(CASE WHEN minfc=1 AND maxfc=1 THEN sales END)first_timer_revenue,
SUM(CASE WHEN minfc>1 AND maxfc>1 THEN sales END)repeater_revenue
FROM base_data
WHERE txndate BETWEEN '2025-01-01' AND '2025-01-31'
GROUP BY 1;

###################################333333
-- exisitng sale and customer 
SELECT region,COUNT(DISTINCT mobile)exisiting_customer,SUM(amount)existing_revenue FROM txn_report_accrual_redemption a 
JOIN store_master b ON a.storecode=b.storecode 
JOIN 
WHERE txndate BETWEEN '2025-01-01' AND '2025-01-31'
AND mobile IN (SELECT DISTINCT mobile FROM txn_report_accrual_redemption a JOIN dummy.camp_coco_fofo_store b USING(storecode) WHERE txndate<'2024-04-01' AND frequencycount=1
AND b.storecode NOT LIKE '%demo%' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND store_type ='foco')
GROUP BY 1;
##########################################3



-- for FY 2024-2025 
WITH base_data AS(
SELECT mobile,region,MAX(txndate)last_txndate,MIN(frequencycount)minfc,MAX(frequencycount)maxfc,frequencycount fc,
COUNT(DISTINCT txndate,mobile)visit,
SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills,c.storecode,txndate 
FROM txn_report_accrual_redemption a LEFT JOIN store_master b USING(storecode)
JOIN dummy.camp_coco_fofo_store c ON a.storecode=b.storecode
WHERE txndate BETWEEN '2024-04-01' AND '2025-01-31'
AND b.storecode NOT LIKE '%demo%' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND store_type ='foco'
GROUP BY 1,2)
SELECT region,COUNT(DISTINCT CASE WHEN minfc=1 AND maxfc=1 THEN  mobile END)+
COUNT(DISTINCT CASE WHEN minfc=1 AND maxfc>1 THEN  mobile END)new_customer,
COUNT(DISTINCT CASE WHEN minfc=1 AND maxfc=1 THEN mobile END)first_timer,
COUNT(DISTINCT CASE WHEN minfc>1 AND maxfc>1 THEN mobile END)repeater,
SUM(CASE WHEN minfc=1 AND maxfc=1 THEN  sales END)+
SUM(CASE WHEN minfc=1 AND maxfc>1 THEN  sales END)new_customer_revenue,
SUM(CASE WHEN minfc=1 AND maxfc=1 THEN sales END)first_timer_revenue,
SUM(CASE WHEN minfc>1 AND maxfc>1 THEN sales END)repeater_revenue
FROM base_data
WHERE txndate BETWEEN '2024-04-01' AND '2025-01-31'
GROUP BY 1;


###################################333333
-- exisitng sale and customer 
SELECT region,COUNT(DISTINCT mobile)exisiting_customer,SUM(amount)existing_revenue FROM txn_report_accrual_redemption a LEFT JOIN store_master b USING(storecode)
WHERE txndate BETWEEN '2024-04-01' AND '2025-01-31'
AND mobile IN (SELECT DISTINCT mobile FROM txn_report_accrual_redemption a JOIN dummy.camp_coco_fofo_store b USING(storecode)
WHERE txndate<'2024-04-01' AND frequencycount=1
AND b.storecode NOT LIKE '%demo%' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND store_type ='coco')
GROUP BY 1;
##########################################




