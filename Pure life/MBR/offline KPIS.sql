SET @lycurrentmonthstartdate= DATE_FORMAT(DATE_SUB(CURDATE(),INTERVAL 13 MONTH),'%Y-%m-01');
SET @lycurrentmonthenddate= LAST_DAY(DATE_SUB(CURDATE(),INTERVAL 13 MONTH));
SELECT @lycurrentmonthstartdate,@lycurrentmonthenddate;

SET @previousmonthstartdate= DATE_FORMAT(DATE_SUB(CURDATE(),INTERVAL 2 MONTH),'%Y-%m-01');
SET @previousmonthenddate = LAST_DAY(DATE_SUB(CURDATE(),INTERVAL 2 MONTH));
SELECT @previousmonthstartdate,@previousmonthenddate;

SET @currentmonthstartdate=DATE_FORMAT(DATE_SUB(CURDATE(),INTERVAL 1 MONTH),'%Y-%m-01');
SET @currentmonthenddate=LAST_DAY(DATE_SUB(CURDATE(),INTERVAL 1 MONTH));
SELECT @currentmonthstartdate,@currentmonthenddate;

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
WHERE TxnDate BETWEEN @lycurrentmonthstartdate AND @lycurrentmonthenddate
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
WHERE TxnDate BETWEEN @previousmonthstartdate AND @previousmonthenddate
AND storecode NOT LIKE '%demo%' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND storecode<>'ecom' AND  amount>0
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
WHERE TxnDate BETWEEN @currentmonthstartdate AND @currentmonthenddate 
AND storecode NOT LIKE '%demo%' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND storecode<>'ecom' AND  amount>0
AND mobile NOT IN ('8360605410','9899021077','9953602260','9910024512','7417295255','9811015405','9559796666')
GROUP BY 1,2,3)b GROUP BY 1,2;