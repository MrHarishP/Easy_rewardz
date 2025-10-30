CALL P1_P2_Tier_overview_report_part4_test ('2025-01-01','2025-04-30');

SELECT * FROM txn_report_accrual_redemption;
SELECT MIN(txndate) FROM `txn_report_flat_accrual`;
SELECT * FROM lapse_report;
SELECT DISTINCT tier FROM member_report;




####################################### task 1 ###########################################33
INSERT INTO dummy.harish_hoirewards_apr_25
SELECT a.mobile,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills,
COUNT(DISTINCT a.mobile,a.txndate)visit,
SUM(a.pointscollected)points_accrued,SUM(a.pointsspent)points_redeemed,
DATEDIFF('2025-05-15',MAX(a.txndate))recency,
DATEDIFF(MAX(a.txndate),MIN(a.txndate))/NULLIF((COUNT(DISTINCT a.txndate)-1),0)latency,SUM(pointslapsed)points_expried
FROM txn_report_accrual_redemption a LEFT JOIN lapse_report b USING(mobile)
WHERE a.txndate BETWEEN '2025-01-01' AND '2025-04-30'
GROUP BY 1;#65406



ALTER TABLE dummy.harish_hoirewards_apr_25 ADD INDEX mobile(mobile),ADD COLUMN frequencycount VARCHAR(50);



UPDATE dummy.harish_hoirewards_apr_25 a JOIN (
SELECT mobile,frequencycount FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2025-01-01' AND '2025-04-30'
GROUP BY 1)b USING(mobile)
SET a.frequencycount=b.frequencycount;#65406


-- summry query

SELECT a.tier,COUNT(DISTINCT b.mobile)customer,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN mobile END)repeater,
COUNT(DISTINCT CASE WHEN points_redeemed>0 THEN mobile END)redeemers,
SUM(visit)visit,AVG(visit)avg_visit,
SUM(sales)sales,SUM(bills)bills,SUM(sales)/SUM(bills)abv,
SUM(points_accrued)points_accrued,SUM(points_redeemed)points_redeemed,
SUM(points_expried)points_expried,AVG(recency)avg_recency,AVG(latency),AVG(latency)
FROM member_report a  JOIN dummy.harish_hoirewards_apr_25 b USING(mobile)
GROUP BY 1
ORDER BY tier;


-- QC
SELECT tier,SUM(sales) FROM member_report JOIN dummy.harish_hoirewards_apr_25 USING(mobile)
WHERE tier='silver'



############################################## end ###################################


################################## mom ###########################


SELECT MONTHNAME(txndate)MOM,SUM(pointscollected)points_issued,SUM(pointsspent)points_redeemed 
FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2025-01-01' AND '2025-04-30'
GROUP BY 1;

############################### end ###################################



################################### overall #########################################


SELECT COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN mobile END)redeemers,
SUM(a.pointscollected)points_issued,SUM(a.pointsspent)points_redeemed,
-- sum(pointslapsed)points_expiry,
COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN uniquebillno END)redemption_bills,
SUM(CASE WHEN a.pointsspent>0 THEN amount END)redemption_sales,
SUM(CASE WHEN a.pointsspent>0 THEN amount END)/COUNT(DISTINCT CASE WHEN a.pointsspent>0 THEN uniquebillno END)redemption_abv
FROM txn_report_accrual_redemption a 
-- group by 1
LEFT JOIN lapse_report b USING(mobile);

-- select sum(pointslapsed)points_expiry from lapse_report;
-- 
-- select COUNT(DISTINCT CASE WHEN pointsspent>0 THEN mobile END)redeemers from txn_report_accrual_redemption;
-- 
-- SELECT SUM(pointscollected) FROM txn_report_accrual_redemption;

####################################### end #################################



SELECT CASE WHEN sales>0 AND sales<=100 THEN '0-100'
WHEN sales>100 AND sales<=200 THEN '100-200'
WHEN sales>200 AND sales<=300 THEN '200-300'
WHEN sales>300 AND sales<=400 THEN '300-400'
WHEN sales>400 AND sales<=500 THEN '400-500'
WHEN sales>500 AND sales<=600 THEN '500-600'
WHEN sales>600 AND sales<=700 THEN '600-700'
WHEN sales>700 AND sales<=800 THEN '700-800'
WHEN sales>800 AND sales<=900 THEN '800-900'
WHEN sales>900 AND sales<=1000 THEN '900-1000'
WHEN sales>1000 THEN '1000+' END AS amount,SUM(sales)repeat_sales,SUM(bills)repeat_bills FROM(
SELECT mobile,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2025-01-01' AND '2025-04-30' AND frequencycount>1
GROUP BY 1)a
GROUP BY 1
ORDER BY sales;



SELECT mobile,SUM(pointslapsed) FROM lapse_report
WHERE txndate BETWEEN '2025-01-01' AND '2025-04-30' AND pointslapsed>0
GROUP BY 1 ;

SELECT SUM(points_expried) FROM dummy.harish_hoirewards_apr_25;


SELECT * FROM txn_report_accrual_redemption 
WHERE mobile IN ('6382484757','9995784075',
'7977463465',
'9026210786',
'9341667519',
'9904503171'
) ;
















