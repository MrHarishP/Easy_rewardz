-- enrollemnet
SELECT 
'23_jun_25 to 22_jul_25' PERIOD,
COUNT(mobile)AS enrollments
FROM member_report
WHERE modifiedenrolledon BETWEEN '2025-06-23' AND '2025-07-22'
AND enrolledstorecode NOT IN ('demo', 'qrcode')
AND insertiondate<='2025-08-25'
GROUP BY 1;

-- txndata
SELECT COUNT(DISTINCT mobile)Transacted_Customers,
COUNT(DISTINCT storecode)store_count,
SUM(loyalty_sales)txn_sales,
SUM(CASE WHEN maxf>1 THEN loyalty_sales END)Repeat_Sales,
SUM(Loyalty_Bills)txn_bills,
SUM(CASE WHEN maxf>1 THEN Loyalty_Bills END)Repeat_Bills,
COUNT(DISTINCT CASE WHEN maxf>1 THEN mobile END)Repeaters,
SUM(redeemer)redeemer,
SUM(Redeemed)Points_Redeemed,
SUM(Points_collected)Points_Issued,
SUM(loyalty_sales)/COUNT(DISTINCT mobile)loyalty_amv,
SUM(CASE WHEN maxf>1 THEN loyalty_sales END)/COUNT(DISTINCT CASE WHEN maxf>1 THEN mobile END)repeat_amv,
SUM(loyalty_sales)/SUM(Loyalty_Bills)loyalty_atv,
SUM(CASE WHEN maxf>1 THEN loyalty_sales END)/SUM(CASE WHEN maxf>1 THEN Loyalty_Bills END)repeat_atv,
AVG(latency)avg_latency,
AVG(visit)avg_frequency
FROM(
SELECT 
Mobile,storecode,frequencycount,
SUM(Amount) AS loyalty_sales,
COUNT(DISTINCT UniqueBillNo) AS Loyalty_Bills,
MAX(frequencycount)maxf,
SUM(pointscollected) AS Points_collected,
SUM(pointsspent) AS Redeemed,
COUNT(DISTINCT CASE WHEN pointsspent>0 THEN mobile END) AS redeemer,
DATEDIFF(MAX(txndate),MIN(txndate))/NULLIF(COUNT(DISTINCT txndate)-1,0)latency,
COUNT(DISTINCT mobile,txndate)visit
FROM `haldirams`.txn_report_accrual_redemption 
WHERE TxnDate BETWEEN '2024-08-03' AND '2024-08-14'
AND storecode NOT LIKE '%demo%' 
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
AND insertiondate<='2025-08-05' AND amount>0
GROUP BY 1)a;


#################################3
SELECT SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills,
SUM(pointscollected)pointsissued,SUM(pointsspent)pointsspend 
FROM txn_report_accrual_redemption
WHERE TxnDate BETWEEN '2024-08-03' AND '2024-08-14'
AND storecode NOT LIKE '%demo%' 
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
AND insertiondate<='2025-08-05' AND amount>0


SELECT SUM(sku_sales)sku_sales,SUM(sku_bills),
SUM(sku_sales)/SUM(qty)ASP,
SUM(qty)/SUM(sku_bills)upt
FROM (
SELECT txnmappedmobile,SUM(itemnetamount)sku_sales,
COUNT(DISTINCT uniquebillno)sku_bills,
SUM(itemqty)qty
FROM sku_report_loyalty
WHERE modifiedTxnDate BETWEEN '2024-08-12' AND '2024-08-14'
AND modifiedstorecode NOT LIKE '%demo%' 
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
AND insertiondate<='2025-08-05' AND itemnetamount>0
GROUP BY 1)a;






-- total_sales or bills
SELECT SUM(sku_sales)`Loyalty Sales and Non Loyalty Sales`,
SUM(sku_bills)`Loyalty Bills and Non Loyalty Bills` FROM (
SELECT SUM(itemnetamount)sku_sales,
COUNT(DISTINCT uniquebillno)sku_bills
FROM sku_report_loyalty
WHERE modifiedTxnDate BETWEEN '2024-07-23' AND '2024-08-03'
AND modifiedstorecode NOT LIKE '%demo%' 
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
AND insertiondate<='2025-08-05' AND itemnetamount>0
UNION
SELECT SUM(itemnetamount)nonloyalty_sales,
COUNT(DISTINCT uniquebillno)nonloyalty_bills
FROM sku_report_nonloyalty
WHERE modifiedTxnDate BETWEEN '2024-08-03' AND '2024-08-14'
AND modifiedstorecode NOT LIKE '%demo%' 
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
AND insertiondate<='2025-08-05' AND itemnetamount>0
)a;


SELECT MIN(modifiedTxnDate) FROM sku_report_nonloyalty;
SELECT MIN(modifiedTxnDate) FROM sku_report_loyalty;


SELECT SUM(sku_sales)`txn Loyalty Sales and Non Loyalty Sales`,
SUM(sku_bills)`txn Loyalty Bills and Non Loyalty Bills` FROM (
SELECT SUM(amount)sku_sales,
COUNT(DISTINCT uniquebillno)sku_bills
FROM txn_report_accrual_redemption
WHERE TxnDate BETWEEN '2024-07-23' AND '2024-08-03'
AND storecode NOT LIKE '%demo%' 
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
AND insertiondate<='2025-08-05' AND amount>0
UNION
SELECT SUM(itemnetamount)sku_sales,
COUNT(DISTINCT uniquebillno)sku_bills
FROM sku_report_nonloyalty
WHERE modifiedTxnDate BETWEEN '2024-07-23' AND '2024-08-03'
AND modifiedstorecode NOT LIKE '%demo%' 
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
AND insertiondate<='2025-08-05' AND itemnetamount>0
)a;

SELECT AVG(fc)avg_fc,SUM(fc)/COUNT(DISTINCT mobile)avg_frequency FROM(
SELECT mobile,frequencycount fc FROM txn_report_accrual_redemption
WHERE TxnDate BETWEEN '2024-07-23' AND '2024-08-03'
AND storecode NOT LIKE '%demo%' 
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
AND insertiondate<='2025-08-05' AND amount>0
GROUP BY 1)a;




















###################################################################################################################################

-- enrollment


WITH enrolledment AS (
SELECT  '1Jan25-31mar25' PERIOD ,
COUNT(DISTINCT mobile)enrolled_customer FROM member_report
WHERE modifiedenrolledon BETWEEN '2025-06-01' AND '2025-08-31'
AND enrolledstorecode NOT IN ('demo','corporate')
-- and enrolledstorecode <> 'ecom'
GROUP BY 1),

txn AS (
SELECT '1Jun25-31 Aug25' PERIOD,
COUNT(DISTINCT mobile)`Transacting Customer`,
COUNT(DISTINCT CASE WHEN minf=1 AND maxf=1 THEN mobile END )new_onetimer,
COUNT(DISTINCT CASE WHEN minf=1 AND maxf>1 THEN mobile END )new_repeater,
COUNT(DISTINCT CASE WHEN minf>1 THEN mobile END )Old_repeater,
SUM(sales)`Loyalty Sales`,
SUM(CASE WHEN minf=1 AND maxf=1 THEN sales END)new_onetimer_sales,
SUM(CASE WHEN minf=1 AND maxf>1 THEN sales END)new_repeat_sales,
SUM(CASE WHEN minf>1 THEN sales END)old_repeart_sales ,
SUM(bills)Loyalty_bills,
SUM(CASE WHEN minf=1 AND maxf=1 THEN bills END)new_onetimer_bills,
SUM(CASE WHEN minf=1 AND maxf>1 THEN bills END)new_repeater_bills,
SUM(CASE WHEN minf>1 THEN bills END)old_repeater_bills,
SUM(sales)/SUM(bills)Overall_ATV,
SUM(sales)/COUNT(DISTINCT mobile)Overall_AMV,
AVG(frequencycount)Overall_frequency
-- AVG(latency)latency
-- sum(frequencycount)/count(distinct mobile)overall_freq 
FROM(
SELECT mobile,MIN(frequencycount)minf,MAX(frequencycount)maxf,
SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills,frequencycount,
SUM(frequencycount)overall_frequency,
DATEDIFF(MAX(txndate),MIN(txndate))/NULLIF(COUNT(DISTINCT txndate)-1,0)latency 
FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2025-06-01' AND '2025-08-31'
-- and storecode <> 'ecom'
AND storecode NOT IN ('demo','corporate') AND amount>0
GROUP BY 1)a
GROUP BY 1),

sku_upt AS (
SELECT '1Jun25-31 Aug25' PERIOD,SUM(itemqty)/COUNT(DISTINCT uniquebillno)upt,
SUM(itemnetamount)/SUM(itemqty)ASP 
FROM sku_report_loyalty
WHERE modifiedtxndate BETWEEN '2025-06-01' AND '2025-08-31'
-- AND modifiedstorecode <> 'ecom'
AND modifiedstorecode NOT IN ('demo','corporate') AND itemnetamount>0
GROUP BY 1
),
total_sale_bills AS (
SELECT '1Jun25-31 Aug25' PERIOD,SUM(sales)Total_sales,SUM(bills)Total_bills FROM (
SELECT SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills 
FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2025-06-01' AND '2025-08-31'
-- and storecode <> 'ecom'
AND storecode NOT IN ('demo','corporate') AND amount>0
UNION
SELECT SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills FROM 
sku_report_nonloyalty
WHERE modifiedtxndate BETWEEN '2025-06-01' AND '2025-08-31' 
-- and modifiedstorecode <> 'ecom' 
AND modifiedstorecode NOT IN ('demo','corporate') AND itemnetamount>0
)a)

SELECT PERIOD,enrolled_customer,`Transacting Customer`,new_onetimer,
new_repeater,Old_repeater,Total_sales,`Loyalty Sales`,new_onetimer_sales,
new_repeat_sales,old_repeart_sales,Total_bills,Loyalty_bills,
new_onetimer_bills,new_repeater_bills,old_repeater_bills,
Overall_ATV,Overall_AMV,Overall_frequency,
-- latency,
upt,ASP 
FROM txn a LEFT JOIN enrolledment b USING(PERIOD)
JOIN sku_upt c USING(PERIOD)
JOIN total_sale_bills d USING(PERIOD)
GROUP BY 1;

SELECT SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills,
SUM(amount)/COUNT(DISTINCT uniquebillno)ATV, 
SUM(amount)/COUNT(DISTINCT mobile)amv,
AVG(frequencycount)avg_frq
FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2025-01-01' AND '2025-03-31'
AND storecode = 'ecom'
AND storecode NOT IN ('demo','corporate') AND amount>0;





###################################################3

WITH enrollment AS (
SELECT 
'23_jul_25 to 22_aug_25' PERIOD,
COUNT(mobile)AS enrollments
FROM member_report
WHERE modifiedenrolledon BETWEEN '2025-07-23' AND '2025-08-22'
AND enrolledstorecode NOT IN ('demo', 'qrcode')
AND insertiondate<='2025-08-22'
GROUP BY 1),

txn AS (
SELECT 
COUNT(DISTINCT mobile)Transacted_Customers,
SUM(amount)Loyalty_sales,
SUM(CASE WHEN frequencycount>1 THEN amount END)Repeat_Sales,
COUNT(DISTINCT uniquebillno)Loyalty_Bills,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN uniquebillno END)Repeat_Bills,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN mobile END)Repeaters,
COUNT(DISTINCT CASE WHEN pointsspent>0 THEN mobile END)Redeemers,
SUM(CASE WHEN pointsspent>0 THEN pointsspent END)Points_Redeemed,
SUM(pointscollected)Points_Issued,
SUM(pointscollected)/SUM(pointsspent)Earn_Burn_Ratio,
SUM(amount)/COUNT(DISTINCT mobile)Loyalty_AMV,
SUM(CASE WHEN frequencycount>1 THEN amount END)/COUNT(DISTINCT CASE WHEN frequencycount>1 THEN  mobile END)Repeat_AMV,
SUM(amount)/COUNT(DISTINCT uniquebillno)Loyalty_ATV,
SUM(CASE WHEN frequencycount>1 THEN amount END)/COUNT(DISTINCT CASE WHEN frequencycount>1 THEN  uniquebillno END)Repeat_ATV,
SUM(visit)/COUNT(DISTINCT mobile)Avg_Frequency
FROM (

SELECT DISTINCT mobile,txndate,frequencycount,amount,uniquebillno,pointsspent,pointscollected,COUNT(DISTINCT txndate,mobile)visit 
FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2025-07-23' AND '2025-08-22'
AND storecode NOT LIKE '%demo%' 
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
AND insertiondate<='2025-08-24' AND amount>0)a),

SELECT 
SUM(itemqty)/COUNT(DISTINCT uniquebillno)upt,
SUM(itemnetamount)/SUM(itemqty)ASP 
FROM sku_report_loyalty
WHERE modifiedtxndate BETWEEN '2025-06-23' AND '2025-07-22'
-- AND modifiedstorecode <> 'ecom'
AND modifiedstorecode NOT IN ('demo','corporate') AND itemnetamount>0
GROUP BY 1;

######################################



SELECT 
PERIOD,
COUNT(DISTINCT mobile)Transacted_Customers,
SUM(amount)Loyalty_sales,
SUM(CASE WHEN frequencycount>1 THEN amount END)Repeat_Sales,
SUM(uniquebillno)Loyalty_Bills,
SUM( CASE WHEN frequencycount>1 THEN uniquebillno END)Repeat_Bills,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN mobile END)Repeaters,
COUNT(DISTINCT CASE WHEN pointsspent>0 THEN mobile END)Redeemers,
SUM(CASE WHEN pointsspent>0 THEN pointsspent END)Points_Redeemed,
SUM(pointscollected)Points_Issued,
SUM(pointscollected)/SUM(pointsspent)Earn_Burn_Ratio,
SUM(amount)/COUNT(DISTINCT mobile)Loyalty_AMV,
SUM(CASE WHEN frequencycount>1 THEN amount END)/COUNT(DISTINCT CASE WHEN frequencycount>1 THEN  mobile END)Repeat_AMV,
SUM(amount)/COUNT(DISTINCT uniquebillno)Loyalty_ATV,
SUM(CASE WHEN frequencycount>1 THEN amount END)/SUM(CASE WHEN frequencycount>1 THEN  uniquebillno END)Repeat_ATV,
SUM(visit)/COUNT(DISTINCT mobile)Avg_Frequency
FROM (

SELECT CASE 
WHEN txndate BETWEEN '2025-07-23' AND '2025-08-22' THEN '23_jul_25 to 22_aug_25' 
WHEN txndate BETWEEN '2024-07-23' AND '2024-08-22' THEN '23_jul_24 to 22_aug_24' 
WHEN txndate BETWEEN '2024-06-23' AND '2024-07-22' THEN '23_jun_24 to 22_jul_24' END
 PERIOD, mobile,MIN(frequencycount)frequencycount,SUM(amount)amount,COUNT(DISTINCT uniquebillno)uniquebillno,
 SUM(pointsspent)pointsspent,SUM(pointscollected)pointscollected,
 COUNT(DISTINCT txndate,mobile)visit 
FROM txn_report_accrual_redemption
WHERE ((txndate BETWEEN '2025-07-23' AND '2025-08-22')OR 
(txndate BETWEEN '2024-07-23' AND '2024-08-22')OR 
(txndate BETWEEN '2024-06-23' AND '2024-07-22'))
AND storecode NOT LIKE '%demo%' 
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
AND insertiondate<='2025-08-24' AND amount>0
GROUP BY 1,2)a
GROUP BY 1;



SELECT SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills,SUM(pointsspent)redeemedpoints,SUM(pointscollected)issud 
FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2025-06-23' AND '2025-07-22'
AND storecode NOT LIKE '%demo%' 
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
AND insertiondate<='2025-08-24' AND amount>0 AND frequencycount>1;



PERIOD,
COUNT(DISTINCT mobile)Transacted_Customers,
SUM(amount)Loyalty_sales,
SUM(CASE WHEN frequencycount>1 THEN amount END)Repeat_Sales,
SUM(uniquebillno)Loyalty_Bills,
SUM( CASE WHEN frequencycount>1 THEN uniquebillno END)Repeat_Bills,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN mobile END)Repeaters,
COUNT(DISTINCT CASE WHEN pointsspent>0 THEN mobile END)Redeemers,
SUM(CASE WHEN pointsspent>0 THEN pointsspent END)Points_Redeemed,
SUM(pointscollected)Points_Issued,
SUM(pointscollected)/SUM(pointsspent)Earn_Burn_Ratio,
SUM(amount)/COUNT(DISTINCT mobile)Loyalty_AMV,
SUM(CASE WHEN frequencycount>1 THEN amount END)/COUNT(DISTINCT CASE WHEN frequencycount>1 THEN  mobile END)Repeat_AMV,
SUM(amount)/COUNT(DISTINCT uniquebillno)Loyalty_ATV,
SUM(CASE WHEN frequencycount>1 THEN amount END)/SUM(CASE WHEN frequencycount>1 THEN  uniquebillno END)Repeat_ATV,
SUM(visit)/COUNT(DISTINCT mobile)Avg_Frequency

SELECT CASE 
WHEN txndate BETWEEN '2025-07-23' AND '2025-08-22' THEN '23_jul_25 to 22_aug_25' 
WHEN txndate BETWEEN '2024-07-23' AND '2024-08-22' THEN '23_jul_24 to 22_aug_24' 
WHEN txndate BETWEEN '2025-06-23' AND '2025-07-22' THEN '23_jun_25 to 22_jul_25' END
 PERIOD, 
 COUNT(DISTINCT mobile)transacting_customers,
 SUM(amount)loyalty_sales,
 SUM(CASE WHEN frequencycount>1 THEN amount END)repeater_sales,
 COUNT(DISTINCT uniquebillno)loyalty_bills,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN uniquebillno END)repeater_bills,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN mobile END)repeaters,
COUNT(DISTINCT CASE WHEN pointsspent>0 THEN mobile END)Redeemers,
 SUM(CASE WHEN pointsspent>0 THEN pointsspent END)points_redeemed,
 SUM(pointscollected)pointsissued,
SUM(amount)/COUNT(DISTINCT mobile)Loyalty_AMV,
SUM(CASE WHEN frequencycount>1 THEN amount END)/COUNT(DISTINCT CASE WHEN frequencycount>1 THEN  mobile END )repeat_AMV,
SUM(amount)/COUNT(DISTINCT uniquebillno)Loyalty_ATV,
SUM(CASE WHEN frequencycount>1 THEN amount END)/COUNT(DISTINCT CASE WHEN frequencycount>1 THEN  uniquebillno END )repeat_ATV
 
FROM txn_report_accrual_redemption
WHERE ((txndate BETWEEN '2025-07-23' AND '2025-08-22')OR 
(txndate BETWEEN '2024-07-23' AND '2024-08-22')OR 
(txndate BETWEEN '2025-06-23' AND '2025-07-22'))
AND storecode NOT LIKE '%demo%' 
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
AND insertiondate<='2025-08-24' AND amount>0
GROUP BY 1;







SELECT  PERIOD,SUM(visit)/COUNT(DISTINCT mobile)avg_visit FROM(

SELECT mobile,CASE 
WHEN txndate BETWEEN '2025-07-23' AND '2025-08-22' THEN '23_jul_25 to 22_aug_25' 
WHEN txndate BETWEEN '2024-07-23' AND '2024-08-22' THEN '23_jul_24 to 22_aug_24' 
WHEN txndate BETWEEN '2025-06-23' AND '2025-07-22' THEN '23_jun_25 to 22_jul_25' END
 PERIOD,COUNT(DISTINCT txndate)visit
FROM txn_report_accrual_redemption
WHERE ((txndate BETWEEN '2025-07-23' AND '2025-08-22')OR 
(txndate BETWEEN '2024-07-23' AND '2024-08-22')OR 
(txndate BETWEEN '2025-06-23' AND '2025-07-22'))
AND storecode NOT LIKE '%demo%' 
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
AND insertiondate<='2025-08-24' AND amount>0
GROUP BY 1,2)a GROUP BY 1;




	SELECT 
	COUNT(DISTINCT mobile)AS enrollments
	FROM member_report
	WHERE modifiedenrolledon BETWEEN '2025-06-23' AND '2025-07-22'
	AND enrolledstorecode NOT IN ('demo', 'qrcode')
	AND insertiondate<='2025-08-24'
	GROUP BY 1;
	
SELECT SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills 	
FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2025-06-01' AND '2025-08-31'
AND storecode NOT LIKE '%demo%' 
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
AND insertiondate<='2025-09-02' AND amount>0