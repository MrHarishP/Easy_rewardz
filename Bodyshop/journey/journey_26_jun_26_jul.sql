SELECT * FROM txn_report_accrual_redemption ;

WITH txn AS (
SELECT 
CASE 
WHEN txndate BETWEEN '2025-04-26' AND '2025-05-26' THEN '26-apr-25 to 26-may-25'
WHEN txndate BETWEEN '2025-06-26' AND '2025-07-26' THEN '26-jun-25 to 26-jul-25' 
END PERIOD,
clientid,
frequencycount,
SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills,
COUNT(DISTINCT txndate,mobile)visit
FROM txn_report_accrual_redemption 
WHERE ((txndate BETWEEN '2025-04-26' AND '2025-05-26')
OR (txndate BETWEEN '2025-06-26' AND '2025-07-26'))
GROUP BY 1,2,3),
sku AS (
SELECT
clientid, 
CASE 
WHEN modifiedtxndate BETWEEN '2025-04-26' AND '2025-05-26' THEN '26-apr-25 to 26-may-25'
WHEN modifiedtxndate BETWEEN '2025-06-26' AND '2025-07-26' THEN '26-jun-25 to 26-jul-25' END PERIOD,
SUM(itemqty)/COUNT(DISTINCT uniquebillno)upt,
SUM(itemnetamount)/SUM(itemqty)asp
FROM sku_report_loyalty
WHERE ((modifiedtxndate BETWEEN '2025-04-26' AND '2025-05-26')
OR (modifiedtxndate BETWEEN '2025-06-26' AND '2025-07-26'))
GROUP BY 1,2)

SELECT PERIOD,
COUNT(DISTINCT clientid)customer,
COUNT(DISTINCT CASE WHEN frequencycount=1 THEN clientid END)onetimer,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN clientid END)repeater,
SUM(sales)sales,SUM(bills)bills,SUM(sales)/SUM(bills)AVT,SUM(sales)/COUNT(DISTINCT clientid)amv,
upt,asp FROM txn a JOIN sku b USING(clientid,PERIOD)
GROUP BY 1;




INSERT INTO dummy.base_26_apr_to_26_may_25
SELECT COUNT(DISTINCT clientid),SUM(amount),COUNT(DISTINCT uniquebillno)bills
FROM txn_report_accrual_redemption 
WHERE (txndate BETWEEN '2025-04-26' AND '2025-05-26')
AND frequencycount=1;#79013,20968


SELECT COUNT(DISTINCT CASE WHEN a.frequencycount=1 THEN clientid END )onetimer,
COUNT(DISTINCT CASE WHEN a.frequencycount>1 THEN clientid END )repeater,
SUM(amount)sales,
SUM(CASE WHEN a.frequencycount=1 THEN amount END)onetimer_sales,
SUM(CASE WHEN a.frequencycount>1 THEN amount END)repeater_sales,
COUNT(DISTINCT a.uniquebillno)bills,
COUNT(DISTINCT CASE WHEN a.frequencycount=1 THEN uniquebillno END)onetimer_bills,
COUNT(DISTINCT CASE WHEN a.frequencycount>1 THEN uniquebillno END)repeater_bills,-- 
-- COUNT(DISTINCT a.txndate,clientid)/COUNT(DISTINCT clientid)visit,
-- count(distinct case when a.frequencycount=1 then a.txndate,clientid end)/count(distinct case when frequencycount=1 then clientid end)one_timer_visit,
-- COUNT(DISTINCT CASE WHEN a.frequencycount>1 THEN a.txndate,clientid END)/COUNT(DISTINCT CASE WHEN frequencycount>1 THEN clientid END)repeater_visit,
SUM(amount)/COUNT(DISTINCT a.uniquebillno)atv,
SUM(CASE WHEN frequencycount=1 THEN amount END)/COUNT(DISTINCT CASE WHEN frequencycount=1 THEN  a.uniquebillno END)onetimer_atv,
SUM(CASE WHEN frequencycount>1 THEN amount END)/COUNT(DISTINCT CASE WHEN frequencycount>1 THEN  a.uniquebillno END)repeart_atv,
SUM(amount)/COUNT(DISTINCT clientid)amv,
SUM(CASE WHEN frequencycount=1 THEN amount END)/COUNT(DISTINCT CASE WHEN frequencycount=1 THEN clientid END)onetimer_amv,
SUM(CASE WHEN frequencycount>1 THEN amount END)/COUNT(DISTINCT CASE WHEN frequencycount>1 THEN clientid END)repeater_amv
FROM txn_report_accrual_redemption a 
JOIN dummy.base_26_apr_to_26_may_25 b USING(clientid)
WHERE a.txndate BETWEEN '2025-04-26' AND '2025-05-26' ;


SELECT 
SUM(CASE WHEN visit=1 THEN visit END)/COUNT(DISTINCT CASE WHEN visit=1 THEN clientid END)onetimer_visit,
SUM(CASE WHEN visit>1 THEN visit END)/COUNT(DISTINCT CASE WHEN visit>1 THEN clientid END)repeater_visit,
SUM(visit)/COUNT(DISTINCT clientid)avg_visit 
FROM(
SELECT clientid,COUNT(DISTINCT txndate,clientid)visit 
FROM txn_report_accrual_redemption a JOIN 
dummy.base_26_apr_to_26_may_25 b USING(clientid)
WHERE a.txndate BETWEEN '2025-04-26' AND '2025-05-26' 
GROUP BY 1)a;



SELECT 
SUM(itemqty)/COUNT(DISTINCT uniquebillno)upt,
SUM(CASE WHEN frequencycount=1 THEN itemqty END)/COUNT(DISTINCT CASE WHEN frequencycount=1 THEN  uniquebillno END)New_customert_upt,
SUM(CASE WHEN frequencycount>1 THEN itemqty END)/COUNT(DISTINCT CASE WHEN frequencycount>1 THEN  uniquebillno END)New_to_repeat_upt,
SUM(itemnetamount)/SUM(itemqty)asp,
SUM(CASE WHEN frequencycount=1 THEN itemnetamount END )/SUM(CASE WHEN frequencycount=1 THEN itemqty END)New_customer_asp,
SUM(CASE WHEN frequencycount>1 THEN itemnetamount END )/SUM(CASE WHEN frequencycount>1 THEN itemqty END)New_to_repeat_asp
FROM sku_report_loyalty a JOIN dummy.base_26_apr_to_26_may_25 b USING(clientid)
WHERE a.txndate BETWEEN '2025-04-26' AND '2025-05-26' ;



#########################################


CREATE TABLE dummy.base_26_jun_to_26_jul_25
SELECT COUNT(DISTINCT clientid),SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills
FROM txn_report_accrual_redemption 
WHERE (txndate BETWEEN '2025-06-26' AND '2025-07-26')
AND frequencycount>1;#23274


SELECT 
COUNT(DISTINCT CASE WHEN a.frequencycount=1 THEN clientid END )onetimer,
COUNT(DISTINCT CASE WHEN a.frequencycount>1 THEN clientid END )repeater,
SUM(amount)sales,
SUM(CASE WHEN a.frequencycount=1 THEN amount END)onetimer_sales,
SUM(CASE WHEN a.frequencycount>1 THEN amount END)repeater_sales,
COUNT(DISTINCT a.uniquebillno)bills,
COUNT(DISTINCT CASE WHEN a.frequencycount=1 THEN uniquebillno END)onetimer_bills,
COUNT(DISTINCT CASE WHEN a.frequencycount>1 THEN uniquebillno END)repeater_bills,-- 
-- COUNT(DISTINCT a.txndate,clientid)/COUNT(DISTINCT clientid)visit,
-- count(distinct case when a.frequencycount=1 then a.txndate,clientid end)/count(distinct case when frequencycount=1 then clientid end)one_timer_visit,
-- COUNT(DISTINCT CASE WHEN a.frequencycount>1 THEN a.txndate,clientid END)/COUNT(DISTINCT CASE WHEN frequencycount>1 THEN clientid END)repeater_visit,
SUM(amount)/COUNT(DISTINCT a.uniquebillno)atv,
SUM(CASE WHEN frequencycount=1 THEN amount END)/COUNT(DISTINCT CASE WHEN frequencycount=1 THEN  a.uniquebillno END)onetimer_atv,
SUM(CASE WHEN frequencycount>1 THEN amount END)/COUNT(DISTINCT CASE WHEN frequencycount>1 THEN  a.uniquebillno END)repeart_atv,
SUM(amount)/COUNT(DISTINCT clientid)amv,
SUM(CASE WHEN frequencycount=1 THEN amount END)/COUNT(DISTINCT CASE WHEN frequencycount=1 THEN clientid END)onetimer_amv,
SUM(CASE WHEN frequencycount>1 THEN amount END)/COUNT(DISTINCT CASE WHEN frequencycount>1 THEN clientid END)repeater_amv
FROM txn_report_accrual_redemption a 
JOIN dummy.base_26_jun_to_26_jul_25 b USING(clientid)
WHERE a.txndate BETWEEN '2025-06-26' AND '2025-07-26' ;

SELECT 
SUM(itemqty)/COUNT(DISTINCT uniquebillno)upt,
SUM(CASE WHEN frequencycount=1 THEN itemqty END)/COUNT(DISTINCT CASE WHEN frequencycount=1 THEN  uniquebillno END)New_customert_upt,
SUM(CASE WHEN frequencycount>1 THEN itemqty END)/COUNT(DISTINCT CASE WHEN frequencycount>1 THEN  uniquebillno END)New_to_repeat_upt,
SUM(itemnetamount)/SUM(itemqty)asp,
SUM(CASE WHEN frequencycount=1 THEN itemnetamount END )/SUM(CASE WHEN frequencycount=1 THEN itemqty END)New_customer_asp,
SUM(CASE WHEN frequencycount>1 THEN itemnetamount END )/SUM(CASE WHEN frequencycount>1 THEN itemqty END)New_to_repeat_asp
FROM sku_report_loyalty a JOIN dummy.base_26_jun_to_26_jul_25 b USING(clientid)
WHERE a.txndate BETWEEN '2025-06-26' AND '2025-07-26' 

SELECT 
SUM(CASE WHEN visit=1 THEN visit END)/COUNT(DISTINCT CASE WHEN visit=1 THEN clientid END)onetimer_visit,
SUM(CASE WHEN visit>1 THEN visit END)/COUNT(DISTINCT CASE WHEN visit>1 THEN clientid END)repeater_visit,
SUM(visit)/COUNT(DISTINCT clientid)avg_visit 
FROM(
SELECT clientid,COUNT(DISTINCT txndate,clientid)visit 
FROM txn_report_accrual_redemption a JOIN 
dummy.base_26_jun_to_26_jul_25 b USING(clientid)
WHERE a.txndate BETWEEN '2025-06-26' AND '2025-07-26' 
GROUP BY 1)a;