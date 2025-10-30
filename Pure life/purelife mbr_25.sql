## Enrollments
-- Prev year current MBR
SELECT CONCAT(MONTHNAME(modifiedenrolledon),YEAR(modifiedenrolledon)) AS PERIOD,
COUNT(DISTINCT CASE WHEN enrolledstorecode IN ('ECOM') THEN mobile END) AS 'ECOM',
COUNT(DISTINCT CASE WHEN enrolledstorecode NOT IN ('ECOM') THEN mobile END) AS 'OFFLINE',
COUNT(DISTINCT mobile) AS Over_All 
FROM `purelife`.member_report 
WHERE enrolledstorecode NOT LIKE '%demo%'
AND modifiedenrolledon BETWEEN  '2024-07-01' AND '2024-07-31'
AND mobile NOT IN ('8360605410','9899021077','9953602260','9910024512','7417295255','9811015405','9559796666')
UNION
-- Prev Month MBR
SELECT CONCAT(MONTHNAME(modifiedenrolledon),YEAR(modifiedenrolledon)) AS PERIOD,
COUNT(DISTINCT CASE WHEN enrolledstorecode IN ('ECOM') THEN mobile END) AS 'ECOM',
COUNT(DISTINCT CASE WHEN enrolledstorecode NOT IN ('ECOM') THEN mobile END) AS 'OFFLINE',
COUNT(DISTINCT mobile) AS Over_All 
FROM purelife.member_report 
WHERE enrolledstorecode NOT LIKE '%demo%'
AND modifiedenrolledon BETWEEN  '2025-06-01' AND '2025-06-30'
AND mobile NOT IN ('8360605410','9899021077','9953602260','9910024512','7417295255','9811015405','9559796666')
UNION
-- current MBR
SELECT CONCAT(MONTHNAME(modifiedenrolledon),YEAR(modifiedenrolledon)) AS PERIOD,
COUNT(DISTINCT CASE WHEN enrolledstorecode IN ('ECOM') THEN mobile END) AS 'ECOM',
COUNT(DISTINCT CASE WHEN enrolledstorecode NOT IN ('ECOM') THEN mobile END) AS 'OFFLINE',
COUNT(DISTINCT mobile) AS Over_All 
FROM purelife.member_report 
WHERE enrolledstorecode NOT LIKE '%demo%'
AND modifiedenrolledon BETWEEN '2025-07-01' AND '2025-07-31'
AND mobile NOT IN ('8360605410','9899021077','9953602260','9910024512','7417295255','9811015405','9559796666')
AND insertiondate<'2025-08-07';

-- QC

SELECT COUNT(DISTINCT mobile) FROM member_report 
WHERE modifiedenrolledon BETWEEN '2025-07-01' AND '2025-07-31'
AND enrolledstorecode != 'ecom'
AND enrolledstorecode NOT LIKE '%demo%';
####################################################################################################################
-- Sheet 1
-- For Sep 2024
SELECT COUNT(DISTINCT Mobile) Transacting_customers,
COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN Mobile END)New_One_Timer,
COUNT(DISTINCT CASE WHEN maxf>1 THEN Mobile END)Repeater,
SUM(sales) AS Total_Sales,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END) AS Newonetimer_sales,
SUM(CASE WHEN maxf>1 THEN sales END) AS Repeater_sales,
SUM(bills) Total_Bills,
SUM(CASE WHEN maxf=1 AND minf=1 THEN bills END) AS Newonetimer_Bills,
SUM(CASE WHEN maxf>1 THEN bills END) AS Repeater_Bills,
SUM(sales)/SUM(bills) AS ABV,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END)/SUM(CASE WHEN maxf=1 AND minf=1 THEN bills END) AS Newonetimer_ABV,
SUM(CASE WHEN maxf>1 THEN sales END)/SUM(CASE WHEN maxf>1 THEN bills END) AS Repeater_ABV
FROM
(SELECT Mobile,SUM(amount) AS sales,
COUNT(DISTINCT UniqueBillNo) AS bills,
MAX(frequencycount) AS maxf,
MIN(frequencycount) AS minf FROM txn_report_accrual_redemption 
WHERE TxnDate BETWEEN '2025-07-01' AND '2025-07-31' 
AND storecode NOT LIKE '%demo%' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
-- AND storecode<>'ecom'
-- AND storecode='ecom'
AND mobile NOT IN ('8360605410','9899021077','9953602260','9910024512','7417295255','9811015405','9559796666')
AND amount>0
GROUP BY 1)b;

SELECT COUNT(DISTINCT mobile),SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2025-07-01' AND '2025-07-31' 
AND storecode NOT LIKE '%demo%' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
-- AND storecode<>'ecom'
AND storecode='ecom'
AND mobile NOT IN ('8360605410','9899021077','9953602260','9910024512','7417295255','9811015405','9559796666')
AND amount>0;


########################### Sheet - Overall KPI : Online & Offline ################################################ ###################################################################################################################
-- Previous year MBR month
SELECT TxnMonth, TxnYear,
COUNT(DISTINCT Mobile) Transacting_customers,
COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN Mobile END)New_One_Timer,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf=1 THEN Mobile END)New_Repeater,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf>1 THEN Mobile END)Old_Repeater,
SUM(sales) AS Total_Sales,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END) AS Newonetimer_sales,
SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END) AS Newrepeater_sales,
SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END) AS oldRepeater_sales,
SUM(bills) Total_Bills,
SUM(CASE WHEN maxf=1 AND minf=1 THEN bills END) AS Newonetimer_Bills,
SUM(CASE WHEN maxf>1 AND minf=1 THEN bills END) AS Newrepeater_Bills,
SUM(CASE WHEN maxf>1 AND minf>1 THEN bills END) AS oldRepeater_Bills,
SUM(sales)/SUM(bills) AS ABV,
ROUND(SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END)/SUM(CASE WHEN maxf=1 AND minf=1 THEN bills END))New_One_Timer_ABV,
ROUND(SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END)/SUM(CASE WHEN maxf>1 AND minf=1 THEN bills END))New_Repeater_ABV,
ROUND(SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END)/SUM(CASE WHEN maxf>1 AND minf>1 THEN bills END)) Repeater_ABV,
SUM(sales)/COUNT(Mobile) AS AMV,
ROUND(SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END)/COUNT(CASE WHEN maxf=1 AND minf=1 THEN Mobile END))New_Onetimer_AMV,
ROUND(SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END)/COUNT(CASE WHEN maxf>1 AND minf=1 THEN Mobile END))
New_Repeater_AMV,
ROUND(SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END)/COUNT(CASE WHEN maxf>1 AND minf>1 THEN Mobile END))
Old_Repeater_AMV,
SUM(Points_Issued)Points_Issued,
SUM(Points_Redemption)Points_Redemption,
AVG(latency) AS avg_latency,
AVG(visits) AS avg_visit,
AVG(CASE WHEN maxf>1 AND minf>=1 THEN visits END) AS avg_repeater_visit
FROM
(SELECT Mobile,TxnMonth,TxnYear,SUM(amount) AS sales,
COUNT(DISTINCT UniqueBillNo) AS bills,
MAX(frequencycount) AS maxf,
MIN(frequencycount) AS minf,SUM(pointscollected)Points_Issued,
SUM(pointsspent)Points_Redemption,
ROUND(DATEDIFF(MAX(txndate),MIN(txndate))/NULLIF((COUNT(DISTINCT txndate)-1),0)) AS Latency,
COUNT(DISTINCT txndate) AS visits FROM txn_report_accrual_redemption 
WHERE TxnDate BETWEEN '2024-07-01' AND '2024-07-31' 
AND storecode NOT LIKE '%demo%' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND amount>0
AND mobile NOT IN ('8360605410','9899021077','9953602260','9910024512','7417295255','9811015405','9559796666')
GROUP BY 1,2,3)b
GROUP BY 1,2
-- Previous Month of MBR
UNION
SELECT TxnMonth, TxnYear,
COUNT(DISTINCT Mobile) Transacting_customers,
COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN Mobile END)New_One_Timer,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf=1 THEN Mobile END)New_Repeater,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf>1 THEN Mobile END)Old_Repeater,
SUM(sales) AS Total_Sales,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END) AS Newonetimer_sales,
SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END) AS Newrepeater_sales,
SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END) AS oldRepeater_sales,
SUM(bills) Total_Bills,
SUM(CASE WHEN maxf=1 AND minf=1 THEN bills END) AS Newonetimer_Bills,
SUM(CASE WHEN maxf>1 AND minf=1 THEN bills END) AS Newrepeater_Bills,
SUM(CASE WHEN maxf>1 AND minf>1 THEN bills END) AS oldRepeater_Bills,
SUM(sales)/SUM(bills) AS ABV,
ROUND(SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END)/SUM(CASE WHEN maxf=1 AND minf=1 THEN bills END))New_One_Timer_ABV,
ROUND(SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END)/SUM(CASE WHEN maxf>1 AND minf=1 THEN bills END))New_Repeater_ABV,
ROUND(SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END)/SUM(CASE WHEN maxf>1 AND minf>1 THEN bills END)) Repeater_ABV,
SUM(sales)/COUNT(Mobile) AS AMV,
ROUND(SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END)/COUNT(CASE WHEN maxf=1 AND minf=1 THEN Mobile END))New_Onetimer_AMV,
ROUND(SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END)/COUNT(CASE WHEN maxf>1 AND minf=1 THEN Mobile END))
New_Repeater_AMV,
ROUND(SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END)/COUNT(CASE WHEN maxf>1 AND minf>1 THEN Mobile END))
Old_Repeater_AMV,
SUM(Points_Issued)Points_Issued,
SUM(Points_Redemption)Points_Redemption,
AVG(latency) AS avg_latency,
AVG(visits) AS avg_visit,
AVG(CASE WHEN maxf>1 AND minf>=1 THEN visits END) AS avg_repeater_visit
FROM
(SELECT Mobile,TxnMonth,TxnYear,SUM(amount) AS sales,
COUNT(DISTINCT UniqueBillNo) AS bills,
MAX(frequencycount) AS maxf,
MIN(frequencycount) AS minf,SUM(pointscollected)Points_Issued,
SUM(pointsspent)Points_Redemption,
ROUND(DATEDIFF(MAX(txndate),MIN(txndate))/NULLIF((COUNT(DISTINCT txndate)-1),0)) AS Latency,
COUNT(DISTINCT txndate) AS visits FROM txn_report_accrual_redemption 
WHERE TxnDate BETWEEN '2025-06-01' AND '2025-06-30' 
AND storecode NOT LIKE '%demo%' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND amount>0
AND mobile NOT IN ('8360605410','9899021077','9953602260','9910024512','7417295255','9811015405','9559796666')
GROUP BY 1,2,3)b GROUP BY 1,2
UNION
-- Current MBR month
SELECT TxnMonth, TxnYear,
COUNT(DISTINCT Mobile) Transacting_customers,
COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN Mobile END)New_One_Timer,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf=1 THEN Mobile END)New_Repeater,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf>1 THEN Mobile END)Old_Repeater,
SUM(sales) AS Total_Sales,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END) AS Newonetimer_sales,
SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END) AS Newrepeater_sales,
SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END) AS oldRepeater_sales,
SUM(bills) Total_Bills,
SUM(CASE WHEN maxf=1 AND minf=1 THEN bills END) AS Newonetimer_Bills,
SUM(CASE WHEN maxf>1 AND minf=1 THEN bills END) AS Newrepeater_Bills,
SUM(CASE WHEN maxf>1 AND minf>1 THEN bills END) AS oldRepeater_Bills,
SUM(sales)/SUM(bills) AS ABV,
ROUND(SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END)/SUM(CASE WHEN maxf=1 AND minf=1 THEN bills END))New_One_Timer_ABV,
ROUND(SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END)/SUM(CASE WHEN maxf>1 AND minf=1 THEN bills END))New_Repeater_ABV,
ROUND(SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END)/SUM(CASE WHEN maxf>1 AND minf>1 THEN bills END)) Repeater_ABV,
SUM(sales)/COUNT(Mobile) AS AMV,
ROUND(SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END)/COUNT(CASE WHEN maxf=1 AND minf=1 THEN Mobile END))New_Onetimer_AMV,
ROUND(SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END)/COUNT(CASE WHEN maxf>1 AND minf=1 THEN Mobile END))
New_Repeater_AMV,
ROUND(SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END)/COUNT(CASE WHEN maxf>1 AND minf>1 THEN Mobile END))
Old_Repeater_AMV,
SUM(Points_Issued)Points_Issued,
SUM(Points_Redemption)Points_Redemption,
AVG(latency) AS avg_latency,
AVG(visits) AS avg_visit,
AVG(CASE WHEN maxf>1 AND minf>=1 THEN visits END) AS avg_repeater_visit
FROM
(SELECT Mobile,TxnMonth,TxnYear,SUM(amount) AS sales,
COUNT(DISTINCT UniqueBillNo) AS bills,
MAX(frequencycount) AS maxf,
MIN(frequencycount) AS minf,SUM(pointscollected)Points_Issued,
SUM(pointsspent)Points_Redemption,
ROUND(DATEDIFF(MAX(txndate),MIN(txndate))/NULLIF((COUNT(DISTINCT txndate)-1),0)) AS Latency,
COUNT(DISTINCT txndate) AS visits FROM txn_report_accrual_redemption 
WHERE TxnDate BETWEEN '2025-07-01' AND '2025-07-31' 
AND storecode NOT LIKE '%demo%' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND amount>0
AND mobile NOT IN ('8360605410','9899021077','9953602260','9910024512','7417295255','9811015405','9559796666')
GROUP BY 1,2,3)b GROUP BY 1,2;


SELECT SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills,SUM(pointsspent)redeemed,SUM(pointscollected)issued 
FROM txn_report_accrual_redemption
WHERE 
TxnDate BETWEEN '2025-08-01' AND '2025-08-31' 
AND storecode NOT LIKE '%demo%' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND amount>0
AND storecode ='ecom'
AND mobile NOT IN ('8360605410','9899021077','9953602260','9910024512','7417295255','9811015405','9559796666');


###################################################################################################################
## Online
-- Previous year MBR month
SELECT TxnMonth, TxnYear,
COUNT(DISTINCT Mobile) Transacting_customers,
COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN Mobile END)New_One_Timer,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf=1 THEN Mobile END)New_Repeater,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf>1 THEN Mobile END)Old_Repeater,
SUM(sales) AS Total_Sales,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END) AS Newonetimer_sales,
SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END) AS Newrepeater_sales,
SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END) AS oldRepeater_sales,
SUM(bills) Total_Bills,
SUM(CASE WHEN maxf=1 AND minf=1 THEN bills END) AS Newonetimer_Bills,
SUM(CASE WHEN maxf>1 AND minf=1 THEN bills END) AS Newrepeater_Bills,
SUM(CASE WHEN maxf>1 AND minf>1 THEN bills END) AS oldRepeater_Bills,
SUM(sales)/SUM(bills) AS ABV,
ROUND(SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END)/SUM(CASE WHEN maxf=1 AND minf=1 THEN bills END))New_One_Timer_ABV,
ROUND(SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END)/SUM(CASE WHEN maxf>1 AND minf=1 THEN bills END))New_Repeater_ABV,
ROUND(SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END)/SUM(CASE WHEN maxf>1 AND minf>1 THEN bills END)) Repeater_ABV,
SUM(sales)/COUNT(Mobile) AS AMV,
ROUND(SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END)/COUNT(CASE WHEN maxf=1 AND minf=1 THEN Mobile END))New_Onetimer_AMV,
ROUND(SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END)/COUNT(CASE WHEN maxf>1 AND minf=1 THEN Mobile END))
New_Repeater_AMV,
ROUND(SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END)/COUNT(CASE WHEN maxf>1 AND minf>1 THEN Mobile END))
Old_Repeater_AMV,
SUM(Points_Issued)Points_Issued,
SUM(Points_Redemption)Points_Redemption,
AVG(latency) AS avg_latency,
AVG(visits) AS avg_visit,
AVG(CASE WHEN maxf>1 AND minf>=1 THEN visits END) AS avg_repeater_visit
FROM
(SELECT Mobile,TxnMonth,TxnYear,SUM(amount) AS sales,
COUNT(DISTINCT UniqueBillNo) AS bills,
MAX(frequencycount) AS maxf,
MIN(frequencycount) AS minf,SUM(pointscollected)Points_Issued,
SUM(pointsspent)Points_Redemption,
ROUND(DATEDIFF(MAX(txndate),MIN(txndate))/NULLIF((COUNT(DISTINCT txndate)-1),0)) AS Latency,
COUNT(DISTINCT txndate) AS visits FROM txn_report_accrual_redemption 
WHERE TxnDate BETWEEN '2024-07-01' AND '2024-07-31' 
AND storecode NOT LIKE '%demo%' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND storecode='ecom' AND amount>0
AND mobile NOT IN ('8360605410','9899021077','9953602260','9910024512','7417295255','9811015405','9559796666')
GROUP BY 1,2,3)b
GROUP BY 1,2
-- Previous Month of MBR
UNION
SELECT TxnMonth, TxnYear,
COUNT(DISTINCT Mobile) Transacting_customers,
COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN Mobile END)New_One_Timer,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf=1 THEN Mobile END)New_Repeater,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf>1 THEN Mobile END)Old_Repeater,
SUM(sales) AS Total_Sales,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END) AS Newonetimer_sales,
SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END) AS Newrepeater_sales,
SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END) AS oldRepeater_sales,
SUM(bills) Total_Bills,
SUM(CASE WHEN maxf=1 AND minf=1 THEN bills END) AS Newonetimer_Bills,
SUM(CASE WHEN maxf>1 AND minf=1 THEN bills END) AS Newrepeater_Bills,
SUM(CASE WHEN maxf>1 AND minf>1 THEN bills END) AS oldRepeater_Bills,
SUM(sales)/SUM(bills) AS ABV,
ROUND(SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END)/SUM(CASE WHEN maxf=1 AND minf=1 THEN bills END))New_One_Timer_ABV,
ROUND(SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END)/SUM(CASE WHEN maxf>1 AND minf=1 THEN bills END))New_Repeater_ABV,
ROUND(SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END)/SUM(CASE WHEN maxf>1 AND minf>1 THEN bills END)) Repeater_ABV,
SUM(sales)/COUNT(Mobile) AS AMV,
ROUND(SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END)/COUNT(CASE WHEN maxf=1 AND minf=1 THEN Mobile END))New_Onetimer_AMV,
ROUND(SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END)/COUNT(CASE WHEN maxf>1 AND minf=1 THEN Mobile END))
New_Repeater_AMV,
ROUND(SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END)/COUNT(CASE WHEN maxf>1 AND minf>1 THEN Mobile END))
Old_Repeater_AMV,
SUM(Points_Issued)Points_Issued,
SUM(Points_Redemption)Points_Redemption,
AVG(latency) AS avg_latency,
AVG(visits) AS avg_visit,
AVG(CASE WHEN maxf>1 AND minf>=1 THEN visits END) AS avg_repeater_visit
FROM
(SELECT Mobile,TxnMonth,TxnYear,SUM(amount) AS sales,
COUNT(DISTINCT UniqueBillNo) AS bills,
MAX(frequencycount) AS maxf,
MIN(frequencycount) AS minf,SUM(pointscollected)Points_Issued,
SUM(pointsspent)Points_Redemption,
ROUND(DATEDIFF(MAX(txndate),MIN(txndate))/NULLIF((COUNT(DISTINCT txndate)-1),0)) AS Latency,
COUNT(DISTINCT txndate) AS visits FROM txn_report_accrual_redemption 
WHERE TxnDate BETWEEN '2025-06-01' AND '2025-06-30' 
AND storecode NOT LIKE '%demo%' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND storecode='ecom' AND  amount>0
AND mobile NOT IN ('8360605410','9899021077','9953602260','9910024512','7417295255','9811015405','9559796666')
GROUP BY 1,2,3)b GROUP BY 1,2
UNION
-- Current MBR month
SELECT TxnMonth, TxnYear,
COUNT(DISTINCT Mobile) Transacting_customers,
COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN Mobile END)New_One_Timer,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf=1 THEN Mobile END)New_Repeater,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf>1 THEN Mobile END)Old_Repeater,
SUM(sales) AS Total_Sales,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END) AS Newonetimer_sales,
SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END) AS Newrepeater_sales,
SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END) AS oldRepeater_sales,
SUM(bills) Total_Bills,
SUM(CASE WHEN maxf=1 AND minf=1 THEN bills END) AS Newonetimer_Bills,
SUM(CASE WHEN maxf>1 AND minf=1 THEN bills END) AS Newrepeater_Bills,
SUM(CASE WHEN maxf>1 AND minf>1 THEN bills END) AS oldRepeater_Bills,
SUM(sales)/SUM(bills) AS ABV,
ROUND(SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END)/SUM(CASE WHEN maxf=1 AND minf=1 THEN bills END))New_One_Timer_ABV,
ROUND(SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END)/SUM(CASE WHEN maxf>1 AND minf=1 THEN bills END))New_Repeater_ABV,
ROUND(SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END)/SUM(CASE WHEN maxf>1 AND minf>1 THEN bills END)) Repeater_ABV,
SUM(sales)/COUNT(Mobile) AS AMV,
ROUND(SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END)/COUNT(CASE WHEN maxf=1 AND minf=1 THEN Mobile END))New_Onetimer_AMV,
ROUND(SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END)/COUNT(CASE WHEN maxf>1 AND minf=1 THEN Mobile END))
New_Repeater_AMV,
ROUND(SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END)/COUNT(CASE WHEN maxf>1 AND minf>1 THEN Mobile END))
Old_Repeater_AMV,
SUM(Points_Issued)Points_Issued,
SUM(Points_Redemption)Points_Redemption,
AVG(latency) AS avg_latency,
AVG(visits) AS avg_visit,
AVG(CASE WHEN maxf>1 AND minf>=1 THEN visits END) AS avg_repeater_visit
FROM
(SELECT Mobile,TxnMonth,TxnYear,SUM(amount) AS sales,
COUNT(DISTINCT UniqueBillNo) AS bills,
MAX(frequencycount) AS maxf,
MIN(frequencycount) AS minf,SUM(pointscollected)Points_Issued,
SUM(pointsspent)Points_Redemption,
ROUND(DATEDIFF(MAX(txndate),MIN(txndate))/NULLIF((COUNT(DISTINCT txndate)-1),0)) AS Latency,
COUNT(DISTINCT txndate) AS visits FROM txn_report_accrual_redemption 
WHERE TxnDate BETWEEN '2025-07-01' AND '2025-07-31' 
AND storecode NOT LIKE '%demo%' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND storecode='ecom' AND  amount>0
AND mobile NOT IN ('8360605410','9899021077','9953602260','9910024512','7417295255','9811015405','9559796666')
GROUP BY 1,2,3)b GROUP BY 1,2;


-- QC
SELECT COUNT(DISTINCT mobile),SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills FROM txn_report_accrual_redemption
WHERE TxnDate BETWEEN '2025-06-01' AND '2025-06-30' 
AND storecode NOT LIKE '%demo%' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND storecode='ecom' AND  amount>0
AND mobile NOT IN ('8360605410','9899021077','9953602260','9910024512','7417295255','9811015405','9559796666');
###################################################################################################################
## Offline

-- Previous year MBR month
SELECT TxnMonth, TxnYear,
COUNT(DISTINCT Mobile) Transacting_customers,
COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN Mobile END)New_One_Timer,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf=1 THEN Mobile END)New_Repeater,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf>1 THEN Mobile END)Old_Repeater,
SUM(sales) AS Total_Sales,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END) AS Newonetimer_sales,
SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END) AS Newrepeater_sales,
SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END) AS oldRepeater_sales,
SUM(bills) Total_Bills,
SUM(CASE WHEN maxf=1 AND minf=1 THEN bills END) AS Newonetimer_Bills,
SUM(CASE WHEN maxf>1 AND minf=1 THEN bills END) AS Newrepeater_Bills,
SUM(CASE WHEN maxf>1 AND minf>1 THEN bills END) AS oldRepeater_Bills,
SUM(sales)/SUM(bills) AS ABV,
ROUND(SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END)/SUM(CASE WHEN maxf=1 AND minf=1 THEN bills END))New_One_Timer_ABV,
ROUND(SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END)/SUM(CASE WHEN maxf>1 AND minf=1 THEN bills END))New_Repeater_ABV,
ROUND(SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END)/SUM(CASE WHEN maxf>1 AND minf>1 THEN bills END)) Repeater_ABV,
SUM(sales)/COUNT(Mobile) AS AMV,
ROUND(SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END)/COUNT(CASE WHEN maxf=1 AND minf=1 THEN Mobile END))New_Onetimer_AMV,
ROUND(SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END)/COUNT(CASE WHEN maxf>1 AND minf=1 THEN Mobile END))
New_Repeater_AMV,
ROUND(SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END)/COUNT(CASE WHEN maxf>1 AND minf>1 THEN Mobile END))
Old_Repeater_AMV,
SUM(Points_Issued)Points_Issued,
SUM(Points_Redemption)Points_Redemption,
AVG(latency) AS avg_latency,
AVG(visits) AS avg_visit,
AVG(CASE WHEN maxf>1 AND minf>=1 THEN visits END) AS avg_repeater_visit
FROM
(SELECT Mobile,TxnMonth,TxnYear,SUM(amount) AS sales,
COUNT(DISTINCT UniqueBillNo) AS bills,
MAX(frequencycount) AS maxf,
MIN(frequencycount) AS minf,SUM(pointscollected)Points_Issued,
SUM(pointsspent)Points_Redemption,
ROUND(DATEDIFF(MAX(txndate),MIN(txndate))/NULLIF((COUNT(DISTINCT txndate)-1),0)) AS Latency,
COUNT(DISTINCT txndate) AS visits FROM txn_report_accrual_redemption 
WHERE TxnDate BETWEEN '2024-07-01' AND '2024-07-31' 
AND storecode NOT LIKE '%demo%' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND storecode<>'ecom' AND amount>0
AND mobile NOT IN ('8360605410','9899021077','9953602260','9910024512','7417295255','9811015405','9559796666')
GROUP BY 1,2,3)b
GROUP BY 1,2
-- Previous Month of MBR
UNION
SELECT TxnMonth, TxnYear,
COUNT(DISTINCT Mobile) Transacting_customers,
COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN Mobile END)New_One_Timer,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf=1 THEN Mobile END)New_Repeater,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf>1 THEN Mobile END)Old_Repeater,
SUM(sales) AS Total_Sales,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END) AS Newonetimer_sales,
SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END) AS Newrepeater_sales,
SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END) AS oldRepeater_sales,
SUM(bills) Total_Bills,
SUM(CASE WHEN maxf=1 AND minf=1 THEN bills END) AS Newonetimer_Bills,
SUM(CASE WHEN maxf>1 AND minf=1 THEN bills END) AS Newrepeater_Bills,
SUM(CASE WHEN maxf>1 AND minf>1 THEN bills END) AS oldRepeater_Bills,
SUM(sales)/SUM(bills) AS ABV,
ROUND(SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END)/SUM(CASE WHEN maxf=1 AND minf=1 THEN bills END))New_One_Timer_ABV,
ROUND(SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END)/SUM(CASE WHEN maxf>1 AND minf=1 THEN bills END))New_Repeater_ABV,
ROUND(SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END)/SUM(CASE WHEN maxf>1 AND minf>1 THEN bills END)) Repeater_ABV,
SUM(sales)/COUNT(Mobile) AS AMV,
ROUND(SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END)/COUNT(CASE WHEN maxf=1 AND minf=1 THEN Mobile END))New_Onetimer_AMV,
ROUND(SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END)/COUNT(CASE WHEN maxf>1 AND minf=1 THEN Mobile END))
New_Repeater_AMV,
ROUND(SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END)/COUNT(CASE WHEN maxf>1 AND minf>1 THEN Mobile END))
Old_Repeater_AMV,
SUM(Points_Issued)Points_Issued,
SUM(Points_Redemption)Points_Redemption,
AVG(latency) AS avg_latency,
AVG(visits) AS avg_visit,
AVG(CASE WHEN maxf>1 AND minf>=1 THEN visits END) AS avg_repeater_visit
FROM
(SELECT Mobile,TxnMonth,TxnYear,SUM(amount) AS sales,
COUNT(DISTINCT UniqueBillNo) AS bills,
MAX(frequencycount) AS maxf,
MIN(frequencycount) AS minf,SUM(pointscollected)Points_Issued,
SUM(pointsspent)Points_Redemption,
ROUND(DATEDIFF(MAX(txndate),MIN(txndate))/NULLIF((COUNT(DISTINCT txndate)-1),0)) AS Latency,
COUNT(DISTINCT txndate) AS visits FROM txn_report_accrual_redemption 
WHERE TxnDate BETWEEN '2025-06-01' AND '2025-06-30' 
AND storecode NOT LIKE '%demo%' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND storecode<>'ecom' AND amount>0
AND mobile NOT IN ('8360605410','9899021077','9953602260','9910024512','7417295255','9811015405','9559796666')
GROUP BY 1,2,3)b GROUP BY 1,2
UNION
-- Current MBR month
SELECT TxnMonth, TxnYear,
COUNT(DISTINCT Mobile) Transacting_customers,
COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN Mobile END)New_One_Timer,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf=1 THEN Mobile END)New_Repeater,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf>1 THEN Mobile END)Old_Repeater,
SUM(sales) AS Total_Sales,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END) AS Newonetimer_sales,
SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END) AS Newrepeater_sales,
SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END) AS oldRepeater_sales,
SUM(bills) Total_Bills,
SUM(CASE WHEN maxf=1 AND minf=1 THEN bills END) AS Newonetimer_Bills,
SUM(CASE WHEN maxf>1 AND minf=1 THEN bills END) AS Newrepeater_Bills,
SUM(CASE WHEN maxf>1 AND minf>1 THEN bills END) AS oldRepeater_Bills,
SUM(sales)/SUM(bills) AS ABV,
ROUND(SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END)/SUM(CASE WHEN maxf=1 AND minf=1 THEN bills END))New_One_Timer_ABV,
ROUND(SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END)/SUM(CASE WHEN maxf>1 AND minf=1 THEN bills END))New_Repeater_ABV,
ROUND(SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END)/SUM(CASE WHEN maxf>1 AND minf>1 THEN bills END)) Repeater_ABV,
SUM(sales)/COUNT(Mobile) AS AMV,
ROUND(SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END)/COUNT(CASE WHEN maxf=1 AND minf=1 THEN Mobile END))New_Onetimer_AMV,
ROUND(SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END)/COUNT(CASE WHEN maxf>1 AND minf=1 THEN Mobile END))
New_Repeater_AMV,
ROUND(SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END)/COUNT(CASE WHEN maxf>1 AND minf>1 THEN Mobile END))
Old_Repeater_AMV,
SUM(Points_Issued)Points_Issued,
SUM(Points_Redemption)Points_Redemption,
AVG(latency) AS avg_latency,
AVG(visits) AS avg_visit,
AVG(CASE WHEN maxf>1 AND minf>=1 THEN visits END) AS avg_repeater_visit
FROM
(SELECT Mobile,TxnMonth,TxnYear,SUM(amount) AS sales,
COUNT(DISTINCT UniqueBillNo) AS bills,
MAX(frequencycount) AS maxf,
MIN(frequencycount) AS minf,SUM(pointscollected)Points_Issued,
SUM(pointsspent)Points_Redemption,
ROUND(DATEDIFF(MAX(txndate),MIN(txndate))/NULLIF((COUNT(DISTINCT txndate)-1),0)) AS Latency,
COUNT(DISTINCT txndate) AS visits FROM txn_report_accrual_redemption 
WHERE TxnDate BETWEEN '2025-07-01' AND '2025-07-31' 
AND storecode NOT LIKE '%demo%' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND storecode<>'ecom' AND amount>0
AND mobile NOT IN ('8360605410','9899021077','9953602260','9910024512','7417295255','9811015405','9559796666')
GROUP BY 1,2,3)b GROUP BY 1,2;


-- QC
SELECT COUNT(DISTINCT mobile),SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills FROM txn_report_accrual_redemption
WHERE TxnDate BETWEEN '2025-08-01' AND '2025-08-31' 
AND storecode NOT LIKE '%demo%' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
-- AND storecode<>'ecom' 
AND  amount>0 
AND mobile NOT IN ('8360605410','9899021077','9953602260','9910024512','7417295255','9811015405','9559796666');
####################################################################################################################

-- Overall
SELECT MONTHNAME(txndate)mnth,
YEAR(txndate)YEAR,COUNT(DISTINCT mobile)customer,
SUM(pointscollected)points_collected,SUM(pointsspent)points_reedemed,
COUNT(DISTINCT CASE WHEN pointsspent>0 THEN mobile END) AS Redeemers,
COUNT(DISTINCT CASE WHEN pointsspent>0 THEN uniquebillno END)AS Redemption_Bills,
SUM(CASE WHEN pointsspent>0 THEN amount END ) AS Redemption_sales 
FROM txn_report_accrual_redemption 
WHERE storecode<>'demo' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND txndate BETWEEN '2025-06-01' AND '2025-07-31' 
AND mobile NOT IN ('8360605410','9899021077','9953602260','9910024512','7417295255','9811015405','9559796666')
AND insertiondate<'2025-08-07' GROUP BY 1;




-- Channelwise
SELECT 
-- MONTHNAME(txndate)mnth,CASE WHEN storecode='ecom' THEN "online" ELSE "offline" END AS store,
YEAR(txndate)YEAR,COUNT(DISTINCT mobile)customer,
SUM(pointscollected)points_collected,
SUM(pointsspent)points_reedemed,
COUNT(DISTINCT CASE WHEN pointsspent>0 THEN mobile END) AS Redeemers,
COUNT(DISTINCT CASE WHEN pointsspent>0 THEN uniquebillno END)AS Redemption_Bills,
SUM(CASE WHEN pointsspent>0 THEN amount END ) AS Redemption_sales 
FROM txn_report_accrual_redemption 
WHERE storecode<>'demo' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND txndate BETWEEN '2025-08-01' AND '2025-08-31' 
AND mobile NOT IN ('8360605410','9899021077','9953602260','9910024512','7417295255','9811015405','9559796666')
AND insertiondate<'2025-09-08' GROUP BY 1,2;

-- Bonus Points
SELECT MONTHNAME(txndate)mnth,
YEAR(txndate)YEAR,COUNT(DISTINCT mobile)accrued_customer,
SUM(pointscollected)points_issued
FROM txn_report_flat_accrual 
WHERE storecode<>'demo' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND txndate BETWEEN '2025-07-01' AND '2025-07-31' AND insertiondate<'2025-09-08' GROUP BY 1;

-- Channelwise Bonus Points
SELECT MONTHNAME(txndate)mnth,CASE WHEN storecode='ecom' THEN "online" ELSE "offline" END AS store,
YEAR(txndate)YEAR,COUNT(DISTINCT mobile)accrued_customer,
SUM(pointscollected)points_issued
FROM txn_report_flat_accrual 
WHERE storecode<>'demo' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND txndate BETWEEN '2025-04-01' AND '2025-05-31' AND insertiondate<'2025-06-06' GROUP BY 1,2;

-- Narration wise Bonus Points

SELECT narration,SUM(pointscollected)points_issued
FROM txn_report_flat_accrual 
WHERE storecode<>'demo' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND txndate BETWEEN '2025-07-01' AND '2025-08-31' 
AND mobile NOT IN ('8360605410','9899021077','9953602260','9910024512','7417295255','9811015405','9559796666')
AND insertiondate<'2025-09-08' GROUP BY 1;

########################################################################################################################################################################################################################################

## Coupon Level Data
SELECT "Aug24" AS PERIOD,
CASE WHEN redeemedstorecode='ecom' THEN "online" ELSE "offline" END AS storetype,
COUNT(*)Issued,COUNT(DISTINCT CASE WHEN couponstatus='Used' THEN issuedmobile END)Redeemers,
COUNT(CASE WHEN couponstatus='Used' THEN couponoffercode END)CouponsRedeemed,SUM(discount)disc 
FROM coupon_offer_report WHERE issueddate BETWEEN '2024-08-01' AND '2024-08-31' 
AND redeemedstorecode<>'demo'
GROUP BY 2
UNION
SELECT "Sep24" AS PERIOD,
CASE WHEN redeemedstorecode='ecom' THEN "online" ELSE "offline" END AS storetype,
COUNT(*)Issued,COUNT(DISTINCT CASE WHEN couponstatus='Used' THEN issuedmobile END)Redeemers,
COUNT(CASE WHEN couponstatus='Used' THEN couponoffercode END)CouponsRedeemed,SUM(discount)disc 
FROM coupon_offer_report WHERE issueddate BETWEEN '2024-09-01' AND '2024-09-30'
AND redeemedstorecode<>'demo'
GROUP BY 2;

-- Overall
SELECT "Aug24" AS PERIOD,
COUNT(*)Issued,COUNT(DISTINCT CASE WHEN couponstatus='Used' THEN issuedmobile END)Redeemers,
COUNT(CASE WHEN couponstatus='Used' THEN couponoffercode END)CouponsRedeemed,SUM(discount)disc 
FROM coupon_offer_report WHERE issueddate BETWEEN '2024-08-01' AND '2024-08-31' 
AND redeemedstorecode<>'demo'
UNION
SELECT "Sep24" AS PERIOD,
COUNT(*)Issued,COUNT(DISTINCT CASE WHEN couponstatus='Used' THEN issuedmobile END)Redeemers,
COUNT(CASE WHEN couponstatus='Used' THEN couponoffercode END)CouponsRedeemed,SUM(discount)disc 
FROM coupon_offer_report WHERE issueddate BETWEEN '2024-09-01' AND '2024-09-30'
AND redeemedstorecode<>'demo';



SELECT 
-- CASE WHEN issuedstore='ecom' THEN "online" ELSE "offline" END AS storetype,
MONTHNAME(issueddate), COUNT(*)Issued
FROM coupon_offer_report 
WHERE issueddate BETWEEN '2025-07-01' AND '2025-08-31' 
AND issuedstore<>'demo'
AND issuedmobile NOT IN ('8360605410','9899021077','9953602260','9910024512','7417295255','9811015405','9559796666')
GROUP BY 1
-- ,2
;



SELECT 
--  CASE WHEN issuedstore='ecom' THEN "online" ELSE "offline" END AS storetype,
MONTHNAME(issueddate), COUNT(*)Issued
FROM coupon_offer_report 
WHERE issueddate BETWEEN '2025-07-01' AND '2025-08-31' 
AND issuedstore<>'demo'
GROUP BY 1,2;




SELECT 
-- CASE WHEN redeemedstorecode='ecom' THEN "online" ELSE "offline" END AS storetype,
MONTHNAME(useddate),COUNT(DISTINCT issuedmobile)Redeemers, 
COUNT(couponcode)CouponsRedeemed, SUM(b.amount)RedemptionSale, 
COUNT(modifiedbillno) redemptionbills, SUM(discount)discount 
FROM coupon_offer_report a JOIN txn_Report_accrual_Redemption b ON a.billno=b.modifiedbillno 
WHERE useddate BETWEEN '2025-07-01' AND '2025-08-31' AND couponstatus = 'Used' 
AND redeemedstorecode<>'demo' 
AND mobile NOT IN ('8360605410','9899021077','9953602260','9910024512','7417295255','9811015405','9559796666')
GROUP BY 1
-- ,2
;


####################################################################################################################

INSERT INTO dummy.PH_segment_aug25
SELECT mobile,MAX(frequencycount)FCOverall,
DATEDIFF('2025-08-31',MAX(txndate))Recency
FROM `purelife`.txn_report_accrual_redemption
WHERE txndate <='2025-08-31' 
GROUP BY 1;#271208


INSERT INTO dummy.PH_segment_aug24
SELECT mobile,MAX(frequencycount)FCOverall,
DATEDIFF('2024-08-31',MAX(txndate))Recency
FROM `purelife`.txn_report_accrual_redemption
WHERE txndate <='2024-08-31' 
GROUP BY 1;#220278

ALTER TABLE dummy.PH_segment_aug24 ADD COLUMN 2024_lifecycle VARCHAR(20);


UPDATE dummy.PH_segment_aug24 SET 2024_lifecycle=
CASE WHEN recency<=210 THEN "Active"
WHEN recency BETWEEN 211 AND 365 THEN "Dormant"
WHEN recency> 365 THEN "Lapsed"
END; #220278

ALTER TABLE dummy.PH_segment_aug25 ADD COLUMN 2025_lifecycle VARCHAR(20);

UPDATE dummy.PH_segment_aug25 SET 2025_lifecycle=
CASE WHEN recency <=210 THEN "Active"
WHEN recency BETWEEN 211 AND 365 THEN "Dormant"
WHEN recency> 365 THEN "Lapsed"
END;#271208

SELECT 2025_lifecycle, COUNT(mobile) AS customers FROM dummy.PH_segment_aug25 GROUP BY 1;
SELECT 2024_lifecycle, COUNT(mobile) AS customers FROM dummy.PH_segment_aug24 GROUP BY 1;

####################################################################################################################

#Coupon Related
SELECT MONTHNAME(issueddate) MONTH,
-- COUNT(*)Issued,
COUNT(DISTINCT CASE WHEN couponstatus='Used' THEN issuedmobile END)Redeemers,
COUNT(CASE WHEN couponstatus='Used' THEN couponoffercode END)CouponsRedeemed,SUM(discount)disc
FROM coupon_offer_report WHERE useddate BETWEEN '2025-05-01' AND '2025-06-30'
AND redeemedmobile NOT IN ('8360605410','9899021077','9953602260','9910024512','7417295255','9811015405','9559796666')
GROUP BY 1;


####################################################################################################################

-- Tierwise
SELECT tier,TxnMonth, TxnYear,
COUNT(DISTINCT Mobile) Transacting_customers,
COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN Mobile END)New_One_Timer,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf=1 THEN Mobile END)New_Repeater,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf>1 THEN Mobile END)Old_Repeater,
SUM(sales) AS Total_Sales,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END) AS Newonetimer_sales,
SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END) AS Newrepeater_sales,
SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END) AS oldRepeater_sales,
SUM(bills) Total_Bills,
SUM(CASE WHEN maxf=1 AND minf=1 THEN bills END) AS Newonetimer_Bills,
SUM(CASE WHEN maxf>1 AND minf=1 THEN bills END) AS Newrepeater_Bills,
SUM(CASE WHEN maxf>1 AND minf>1 THEN bills END) AS oldRepeater_Bills,
SUM(sales)/SUM(bills) AS ABV,
ROUND(SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END)/SUM(CASE WHEN maxf=1 AND minf=1 THEN bills END))New_One_Timer_ABV,
ROUND(SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END)/SUM(CASE WHEN maxf>1 AND minf=1 THEN bills END))New_Repeater_ABV,
ROUND(SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END)/SUM(CASE WHEN maxf>1 AND minf>1 THEN bills END)) Repeater_ABV,
SUM(sales)/COUNT(Mobile) AS AMV,
ROUND(SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END)/COUNT(CASE WHEN maxf=1 AND minf=1 THEN Mobile END))New_Onetimer_AMV,
ROUND(SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END)/COUNT(CASE WHEN maxf>1 AND minf=1 THEN Mobile END))
New_Repeater_AMV,
ROUND(SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END)/COUNT(CASE WHEN maxf>1 AND minf>1 THEN Mobile END))
Old_Repeater_AMV,
SUM(Points_Issued)Points_Issued,
SUM(Points_Redemption)Points_Redemption,
AVG(latency) AS avg_latency,
AVG(visits) AS avg_visit,
AVG(CASE WHEN maxf>1 AND minf>=1 THEN visits END) AS avg_repeater_visit
FROM
(SELECT Mobile,TxnMonth,TxnYear,tier,SUM(amount) AS sales,
COUNT(DISTINCT UniqueBillNo) AS bills,
MAX(frequencycount) AS maxf,
MIN(frequencycount) AS minf,SUM(pointscollected)Points_Issued,
SUM(a.pointsspent)Points_Redemption,
ROUND(DATEDIFF(MAX(txndate),MIN(txndate))/NULLIF((COUNT(DISTINCT txndate)-1),0)) AS Latency,
COUNT(DISTINCT txndate) AS visits FROM txn_report_accrual_redemption  a JOIN member_Report b
USING(mobile)
WHERE TxnDate BETWEEN '2024-09-01' AND '2024-09-30' 
AND storecode NOT LIKE '%demo%' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND storecode='ecom'
GROUP BY 1,2,3,4)b GROUP BY 1,2,3;
