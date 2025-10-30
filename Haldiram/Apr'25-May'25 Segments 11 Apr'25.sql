SELECT * FROM program_single_view LIMIT 10;
-- # repeater and onetimer
-- ####################################################
-- april 25 
SELECT CASE WHEN recency BETWEEN 30 AND 90 AND availablepoints <= 25 AND `total visits`>=3 AND atv<=250 AND `points spent`>0
THEN 'Repeaters who have recency between 30-90 days, points available <=25, and have frequency >=3, atv <=250, points spent>0 '
WHEN recency BETWEEN 30 AND 90 AND availablepoints <= 25 AND `total visits`>=3 AND atv>250 AND atv <=500 AND `points spent`>0 
THEN 'Repeaters who have recency between 30-90 days, points available <=25, and have frequency >=3, atv between 250 and 500, points spent>0'
WHEN recency BETWEEN 30 AND 90 AND availablepoints <= 25 AND `total visits`>=3 AND atv>500 AND atv<=750 AND `points spent`>0
THEN 'Repeaters who have recency between 30-90 days, points available <=25, and have frequency >=3, atv between 500 and 750, points spent>0'
WHEN recency BETWEEN 30 AND 90 AND availablepoints >25 AND availablepoints <=100 
THEN 'Repeaters who have recency between 30-90 days, points available 26-100'
WHEN recency BETWEEN 91 AND 180 AND availablepoints <=25 AND `total visits`>=3 AND atv>=250 AND `points spent`>0
THEN 'Repeaters who have recency between 91 and 180 days and points <=25, and frequency >= 3, atv >=250, points spent>0'
WHEN recency BETWEEN 91 AND 180 AND availablepoints >25 AND availablepoints <=100 AND `total visits`>=3 AND atv>=250 
THEN 'Repeaters who have recency between 91 and 180 days and points between 25 -100, and frequency >= 3, atv >=250'
WHEN recency BETWEEN 30 AND 254 AND `total visits`=2 AND atv>=250 AND atv<=750 
THEN 'Repeaters with recency between 30 and 254 days and frequency = 2, atv between 250 & 750' 
WHEN recency BETWEEN 30 AND 90 AND atv>250 AND atv<=500 AND `total visits` = 1 
THEN 'Onetimers who have atv between 250-500 and have recency between 30-90'
WHEN recency BETWEEN 30 AND 90 AND atv>500 AND atv<=750 AND `total visits` = 1 
THEN 'Onetimers who have atv between 501-750 and have recency between 30-90'
WHEN recency BETWEEN 30 AND 90 AND atv >750 AND atv<=1000 AND `total visits` = 1  
THEN 'Onetimers who have atv between 751-1000 and have recency between 30-90'
WHEN recency BETWEEN 30 AND 90 AND atv>1000 AND `total visits` = 1 
THEN 'Onetimers who have atv >1000 and recency between 30 and 90'
WHEN recency >=254 AND atv>=300 THEN 'Customers who have recency >=254 days, atv >=300'
WHEN recency BETWEEN 30 AND 90 AND availablepoints <= 25 AND `total visits`>=3 AND atv<=250 AND `points spent`=0
THEN 'Repeaters who have recency between 30-90 days, points available <=25, and have frequency >=3, atv <=250, points spent=0 '
WHEN recency BETWEEN 30 AND 90 AND availablepoints <= 25 AND `total visits`>=3 AND atv>250 AND atv <=500 AND `points spent`=0 
THEN 'Repeaters who have recency between 30-90 days, points available <=25, and have frequency >=3, atv between 250 and 500, points spent=0'
WHEN recency BETWEEN 30 AND 90 AND availablepoints <= 25 AND `total visits`>=3 AND atv>500 AND atv<=750 AND `points spent`=0
THEN 'Repeaters who have recency between 30-90 days, points available <=25, and have frequency >=3, atv between 500 and 750, points spent=0'
WHEN recency BETWEEN 91 AND 180 AND availablepoints <=25 AND `total visits`>=3 AND atv>=250 AND `points spent`=0
THEN 'Repeaters who have recency between 91 and 180 days and points <=25, and frequency >= 3, atv >=250, points spent=0'
WHEN `last shopped store` IN ('RO301','RO103',
'RO303',
'RO302',
'RO319',
'RO501',
'RO543',
'RO101',
'RO401',
'RO404') THEN 'customers transacted in top 10 stores'
END 'segments',
COUNT(DISTINCT mobile)customer,SUM(`total spends`)sales,SUM(`total transactions`)bills 
FROM (
SELECT mobile,recency,availablepoints,`total spends`,`last shopped store`,
`total visits`,SUM(`total spends`)/SUM(`total transactions`)atv,`points spent`,
`total transactions` FROM program_single_view
GROUP BY 1)a
GROUP BY 1;
###########################################################################################
-- for atv >=300

SELECT CASE WHEN recency >=254 AND atv>=300 THEN 'Customers who have recency >=254 days, atv >=300' END 'segment',
COUNT(DISTINCT mobile)customer,
SUM(`total spends`),SUM(`total transactions`) FROM(
SELECT mobile,recency,availablepoints,`total spends`,
`total visits`,SUM(`total spends`)/SUM(`total transactions`)atv,
`total transactions` FROM program_single_view
GROUP BY 1)a
GROUP BY 1;

-- QC 
SELECT COUNT(DISTINCT mobile)customer,SUM(`total spends`)sales,SUM(`total transactions`)bill FROM (
SELECT mobile,recency,availablepoints,`total spends`,`points spent`,
`total visits`,SUM(`total spends`)/SUM(`total transactions`)atv,
`total transactions` FROM program_single_view
GROUP BY 1)a
WHERE recency BETWEEN 30 AND 90 AND availablepoints <= 25 AND `total visits`>=3 AND atv>250 AND atv <=500 AND `points spent`>0 


SELECT COUNT(DISTINCT mobile)customr,SUM(sales)sales,SUM(bills )bills FROM(
SELECT mobile,DATEDIFF(CURDATE(),MAX(txndate))recency,SUM(amount)sales,MAX(frequencycount)fc,
COUNT(DISTINCT uniquebillno)bills,b.availablepoints ,SUM(amount)/COUNT(DISTINCT uniquebillno)atv 
FROM txn_report_accrual_redemption a LEFT JOIN member_report b USING(mobile)
WHERE storecode NOT LIKE 'demo' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%role%'
GROUP BY 1)a
WHERE recency >=254 AND atv>=300 ;

-- QC end
####################################################################################################
#mom trends on weekdays
SELECT YEAR(txndate)txnyear,MONTHNAME(txndate)txnmonth,DAYNAME(txndate)day_of_week,
COUNT(DISTINCT mobile)customer,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills 
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2024-05-01' AND '2025-03-31' 
AND billno NOT LIKE '%test%' AND billno NOT LIKE '%role%' AND storecode NOT LIKE 'demo'
GROUP BY 1,2,3
ORDER BY txnyear,txnmonth,FIELD(day_of_week, 
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');
    








SELECT DISTINCT city,storecode FROM store_master;
SELECT city FROM store_master
WHERE city LIKE 'rohtak';





##################################################################################################

SELECT DISTINCT storecode FROM store_master 
WHERE city IN ('noida','Gurgaon','Gurugram','New Delhi','Faridabad','Sonipat',
'Meerut','Ghaziabad');








######################################################################################\
-- Repeaters who have recency between 30-90 days, points available <=25, and have frequency >=3, ATV between 250 and 500, points spent>0
-- Repeaters who have recency between 30-90 days, points available <=25, and have frequency >=3, ATV between 500 and 750, points spent>0
-- Repeaters who have recency between 30-90 days, points available 26-100
-- Onetimers who have ATV between 250-500 and have recency between 30-90
Onetimers who have ATV BETWEEN 751-1000 AND have recency BETWEEN 30-90
Onetimers who have ATV >1000 AND recency BETWEEN 30 AND 90
Customers who have recency >=254 days, ATV >=300 (May, June, July)
Repeaters WITH recency BETWEEN 30 AND 254 days AND frequency = 2, ATV BETWEEN 250 & 750

SELECT CASE 
WHEN recency BETWEEN 30 AND 90 AND availablepoints <= 25 AND `total visits`>=3 AND atv>250 AND atv <=500 AND `points spent`>0 
THEN 'Repeaters who have recency between 30-90 days, points available <=25, and have frequency >=3, atv between 250 and 500, points spent>0'
WHEN recency BETWEEN 30 AND 90 AND availablepoints <= 25 AND `total visits`>=3 AND atv>500 AND atv<=750 AND `points spent`>0
THEN 'Repeaters who have recency between 30-90 days, points available <=25, and have frequency >=3, atv between 500 and 750, points spent>0'
WHEN recency BETWEEN 30 AND 90 AND availablepoints >25 AND availablepoints <=100 
THEN 'Repeaters who have recency between 30-90 days, points available 26-100'
WHEN recency BETWEEN 30 AND 90 AND atv>250 AND atv<=500 AND `total visits` = 1 
THEN 'Onetimers who have atv between 250-500 and have recency between 30-90'
WHEN recency BETWEEN 30 AND 90 AND atv >750 AND atv<=1000 AND `total visits` = 1  
THEN 'Onetimers who have atv between 751-1000 and have recency between 30-90'
WHEN recency BETWEEN 30 AND 90 AND atv>1000 AND `total visits` = 1 
THEN 'Onetimers who have atv >1000 and recency between 30 and 90'
WHEN recency >=254 AND atv>=300 THEN 'Customers who have recency >=254 days, ATV >=300 (May, June, July)'
WHEN recency BETWEEN 30 AND 254 AND `total visits`=2 AND atv>=250 AND atv<=750 
THEN 'Repeaters WITH recency BETWEEN 30 AND 254 days AND frequency = 2, ATV BETWEEN 250 & 750'
WHEN `last shopped store` IN ('RO101','RO425','RO543','RO102','RO103','RO106','RO107','RO109','RO110',
'RO112','RO113','RO114','RO115','RO116','RO117','RO118','RO120','RO121','RO122','RO126','RO128','RO129','RO130',
'RO131','RO137','RO140','RO302','RO303','RO304','RO305','RO306','RO309','RO310','RO311','RO314','RO317','RO318',
'RO319','RO322','RO323','RO324','RO329','RO330','RO331','RO334','RO335','RO338','RO340','RO343','RO344','RO346',
'RO348','RO401','RO403','RO404','RO405','RO408','RO410','RO414','RO417','RO419','RO422','RO423','RO426','RO428',
'RO429','RO431','RO432','RO435','RO501','RO503','RO504','RO506','RO507','RO509','RO510','RO511','RO513','RO515',
'RO516','RO517','RO518','RO519','RO520','RO521','RO523','RO524','RO525','RO526','RO528','RO530','RO531','RO533',
'RO534','RO535','RO536','RO537','RO538','RO539','RO545','RO547','RO301','RO327','RO436','Ecom',
'RO138','RO326','RO548','RO439','RO141','RO148','QRCODE','RO550','RO549','RO150','RO440','RO135','RO142','RO352','RO443') 
AND recency BETWEEN 15 AND 180 THEN 'customers transacted in NCR stores'
END 'segments',
COUNT(DISTINCT mobile)customer,SUM(`total spends`)sales,SUM(`total transactions`)bills 
FROM (
SELECT mobile,recency,availablepoints,`total spends`,`last shopped store`,
`total visits`,SUM(`total spends`)/SUM(`total transactions`)atv,`points spent`,
`total transactions` FROM program_single_view
GROUP BY 1)a
GROUP BY 1;


-- QC 
SELECT COUNT(DISTINCT mobile)customer,SUM(`total spends`)sales,SUM(`total transactions`)bill FROM (
SELECT mobile,recency,availablepoints,`total spends`,`points spent`,
`total visits`,SUM(`total spends`)/SUM(`total transactions`)atv,
`total transactions` FROM program_single_view
GROUP BY 1)a
WHERE recency BETWEEN 30 AND 90 AND atv>250 AND atv<=500 AND `total visits` = 1 ;

####################################################################################






-- ################################################################# 
-- May 25 
SELECT CASE WHEN recency BETWEEN 30 AND 90 AND availablepoints <= 25 AND `total visits`>=3 AND `Average Spend per Visit`<=250 AND `Points Spent` =0
THEN 'Repeaters who have recency between 30-90 days, points available <=25, and have frequency >=3, `Average Spend per Visit` <=250, points spent=0'
WHEN recency BETWEEN 30 AND 90 AND availablepoints <= 25 AND `total visits`>=3 AND `Average Spend per Visit`<=250 AND `Points Spent` >0
THEN 'Repeaters who have recency between 30-90 days, points available <=25, and have frequency >=3, `Average Spend per Visit` <=250, points spent>0'
WHEN recency BETWEEN 30 AND 90 AND availablepoints <= 25 AND `total visits`>=3 AND `Average Spend per Visit`>250 AND `Average Spend per Visit` <=500 AND `Points Spent` >0 
THEN 'Repeaters who have recency between 30-90 days, points available <=25, and have frequency >=3, `Average Spend per Visit` between 250 and 500, points spent >0'
WHEN recency BETWEEN 30 AND 90 AND availablepoints <= 25 AND `total visits`>=3 AND `Average Spend per Visit`>500 AND `Average Spend per Visit`<=750 AND `Points Spent` >0 
THEN 'Repeaters who have recency between 30-90 days, points available <=25, and have frequency >=3, `Average Spend per Visit` between 500 and 750, points spent >0'
WHEN recency BETWEEN 30 AND 90 AND availablepoints <= 25 AND `total visits`>=3 AND `Average Spend per Visit`>750 AND `Average Spend per Visit` <=1000 AND `Points Spent` >0 
THEN 'Repeaters who have recency between 30-90 days, points available <=25, and have frequency >=3, `Average Spend per Visit` between 750 and 1000, points spent >0'
WHEN recency BETWEEN 30 AND 90 AND availablepoints <= 25 AND `total visits`>=3 AND `Average Spend per Visit`>1000 AND `Points Spent` >0 
THEN 'Repeaters who have recency between 30-90 days, points available <=25, and have frequency >=3, `Average Spend per Visit` >1000, points spent >0'
WHEN recency BETWEEN 30 AND 90 AND availablepoints >25 AND availablepoints <=100 
THEN 'Repeaters who have recency between 30-90 days, points available 26-100'
WHEN recency BETWEEN 91 AND 180 AND availablepoints <=25 AND `total visits`>=3 AND `Average Spend per Visit`>=250 AND `Points Spent` >0 
THEN 'Repeaters who have recency between 91 and 180 days and points <=25, and frequency >= 3, `Average Spend per Visit` >=250, points spent >0'
WHEN recency BETWEEN 91 AND 180 AND availablepoints >25 AND `total visits`>=3 AND `Average Spend per Visit`>=250 
THEN 'Repeaters who have recency between 91 and 180 days and points available >25, and frequency >= 3, `Average Spend per Visit` >=250'
WHEN recency BETWEEN 30 AND 254 AND `total visits`=2 AND `Average Spend per Visit`>=250 AND `Average Spend per Visit`<=750 
THEN 'Repeaters with recency between 30 and 254 days and frequency = 2, `Average Spend per Visit` between 250 & 750' 
WHEN recency BETWEEN 30 AND 90 AND `Average Spend per Visit`>250 AND `Average Spend per Visit`<=500 AND `total visits` = 1 
THEN 'Onetimers who have `Average Spend per Visit` between 250-500 and have recency between 30-90'
WHEN recency BETWEEN 30 AND 90 AND `Average Spend per Visit`>500 AND `Average Spend per Visit`<=750 AND `total visits` = 1 
THEN 'Onetimers who have `Average Spend per Visit` between 501-750 and have recency between 30-90'
WHEN recency BETWEEN 30 AND 90 AND `Average Spend per Visit` >750 AND `Average Spend per Visit`<=1000 AND `total visits` = 1  
THEN 'Onetimers who have `Average Spend per Visit` between 751-1000 and have recency between 30-90'
WHEN recency BETWEEN 30 AND 90 AND `Average Spend per Visit`>1000 AND `total visits` = 1 
THEN 'Onetimers who have `Average Spend per Visit` >1000 and recency between 30 and 90'
WHEN `Last Shopped Date` <='2024-10-31' AND `Average Spend per Visit`>=300 
THEN 'Customers who havent shopped from October and have `Average Spend per Visit` >=300'
END 'segments',COUNT(DISTINCT mobile)customer,SUM(`total spends`)sales,SUM(`total transactions`)bills 
FROM program_single_view
GROUP BY 1;