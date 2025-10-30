## Enrollments
-- Prev year current MBR # update date for previes year of feb because we are at mar and want to current prev year month MBR so take date for feb or last year
SELECT CONCAT(MONTHNAME(modifiedenrolledon),YEAR(modifiedenrolledon)) AS PERIOD,
COUNT(DISTINCT CASE WHEN enrolledstorecode IN ('ECOM','corporate') THEN mobile END) AS 'ECOM',
COUNT(DISTINCT CASE WHEN enrolledstorecode NOT IN ('ECOM','corporate') THEN mobile END) AS 'OFFLINE',
COUNT(DISTINCT mobile) AS Over_All 
FROM `campuscrm`.member_report 
WHERE enrolledstorecode NOT LIKE '%demo%'
AND modifiedenrolledon BETWEEN  '2024-03-01' AND '2024-03-31'
UNION
-- Prev Month MBR
SELECT CONCAT(MONTHNAME(modifiedenrolledon),YEAR(modifiedenrolledon)) AS PERIOD,
COUNT(DISTINCT CASE WHEN enrolledstorecode IN ('ECOM','corporate') THEN mobile END) AS 'ECOM',
COUNT(DISTINCT CASE WHEN enrolledstorecode NOT IN ('ECOM','corporate') THEN mobile END) AS 'OFFLINE',
COUNT(DISTINCT mobile) AS Over_All 
FROM `campuscrm`.member_report 
WHERE enrolledstorecode NOT LIKE '%demo%'
AND modifiedenrolledon BETWEEN  '2025-02-01' AND '2025-02-28'
UNION
-- current MBR
SELECT CONCAT(MONTHNAME(modifiedenrolledon),YEAR(modifiedenrolledon)) AS PERIOD,
COUNT(DISTINCT CASE WHEN enrolledstorecode IN ('ECOM','corporate') THEN mobile END) AS 'ECOM',
COUNT(DISTINCT CASE WHEN enrolledstorecode NOT IN ('ECOM','corporate') THEN mobile END) AS 'OFFLINE',
COUNT(DISTINCT mobile) AS Over_All 
FROM `campuscrm`.member_report 
WHERE enrolledstorecode NOT LIKE '%demo%'
AND modifiedenrolledon BETWEEN '2025-03-01' AND '2025-03-31'
AND insertiondate<'2025-04-01';
####################################################################################################################

-- Overall
#### KPIs
-- Prev Year MBR Month # same for this
SELECT TxnMonth, TxnYear,COUNT(mobile)Transacting_Customers,
COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN mobile END)OneTimer,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf=1 THEN mobile END)New_Repeater,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf>1 THEN mobile END)Old_Repeater,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END) AS onetimer_Sales,
SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END) AS New_Repeat_Sales,
SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END) AS Old_Repeat_Sales,SUM(sales)sales,
SUM(CASE WHEN maxf=1 AND minf=1 THEN bills END) AS onetimer_Bills,
SUM(CASE WHEN maxf>1 AND minf=1 THEN bills END) AS New_Repeat_Bills,
SUM(CASE WHEN maxf>1 AND minf>1 THEN bills END) AS Old_Repeat_Bills,SUM(bills) AS bills,
SUM(sales)/SUM(bills) AS ABV,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END)/SUM(CASE WHEN maxf=1 AND minf=1 THEN bills END) Onetimer_ABV,
SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END)/SUM(CASE WHEN maxf>1 AND minf=1 THEN bills END) AS New_Repeat_ABV,
SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END)/SUM(CASE WHEN maxf>1 AND minf>1 THEN bills END) AS Old_Repeat_ABV,
SUM(sales)/COUNT(mobile) AMV,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END)/COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN mobile END) Onetimer_AMV,
SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END)/COUNT(DISTINCT CASE WHEN maxf>1 AND minf=1 THEN mobile END) AS New_Repeat_AMV,
SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END)/COUNT(DISTINCT CASE WHEN maxf>1 AND minf>1 THEN mobile END) AS Old_Repeat_AMV,
SUM(points_collected) AS Transaction_Points_issued,SUM(redeemed) AS Points_redeemed
FROM (SELECT mobile, TxnMonth,TxnYear ,SUM(Amount) AS sales,COUNT(DISTINCT (UniqueBillNo)) AS bills,
MAX(frequencycount) AS maxf, MIN(frequencycount) AS minf,
SUM(pointscollected) AS Points_collected,SUM(pointsspent) AS Redeemed
FROM txn_report_accrual_redemption 
WHERE TxnDate BETWEEN '2024-03-01' AND '2024-03-31'
AND storecode NOT LIKE '%demo%' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
GROUP BY 1,2,3)a GROUP BY 1,2
UNION
-- Prev Month MBR
SELECT TxnMonth, TxnYear,COUNT(mobile)Transacting_Customers,
COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN mobile END)OneTimer,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf=1 THEN mobile END)New_Repeater,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf>1 THEN mobile END)Old_Repeater,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END) AS onetimer_Sales,
SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END) AS New_Repeat_Sales,
SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END) AS Old_Repeat_Sales,SUM(sales)sales,
SUM(CASE WHEN maxf=1 AND minf=1 THEN bills END) AS onetimer_Bills,
SUM(CASE WHEN maxf>1 AND minf=1 THEN bills END) AS New_Repeat_Bills,
SUM(CASE WHEN maxf>1 AND minf>1 THEN bills END) AS Old_Repeat_Bills,SUM(bills) AS bills,
SUM(sales)/SUM(bills) AS ABV,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END)/SUM(CASE WHEN maxf=1 AND minf=1 THEN bills END) Onetimer_ABV,
SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END)/SUM(CASE WHEN maxf>1 AND minf=1 THEN bills END) AS New_Repeat_ABV,
SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END)/SUM(CASE WHEN maxf>1 AND minf>1 THEN bills END) AS Old_Repeat_ABV,
SUM(sales)/COUNT(mobile) AMV,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END)/COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN mobile END) Onetimer_AMV,
SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END)/COUNT(DISTINCT CASE WHEN maxf>1 AND minf=1 THEN mobile END) AS New_Repeat_AMV,
SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END)/COUNT(DISTINCT CASE WHEN maxf>1 AND minf>1 THEN mobile END) AS Old_Repeat_AMV,
SUM(points_collected) AS Transaction_Points_issued,SUM(redeemed) AS Points_redeemed
FROM (SELECT mobile, TxnMonth,TxnYear ,SUM(Amount) AS sales,COUNT(DISTINCT (UniqueBillNo)) AS bills,
MAX(frequencycount) AS maxf, MIN(frequencycount) AS minf,
SUM(pointscollected) AS Points_collected,SUM(pointsspent) AS Redeemed
FROM txn_report_accrual_redemption 
WHERE TxnDate BETWEEN '2025-02-01' AND '2025-02-28'
AND storecode NOT LIKE '%demo%' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
GROUP BY 1,2,3)a GROUP BY 1,2
UNION
-- Current Month MBR
SELECT TxnMonth, TxnYear,COUNT(mobile)Transacting_Customers,
COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN mobile END)OneTimer,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf=1 THEN mobile END)New_Repeater,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf>1 THEN mobile END)Old_Repeater,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END) AS onetimer_Sales,
SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END) AS New_Repeat_Sales,
SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END) AS Old_Repeat_Sales,SUM(sales)sales,
SUM(CASE WHEN maxf=1 AND minf=1 THEN bills END) AS onetimer_Bills,
SUM(CASE WHEN maxf>1 AND minf=1 THEN bills END) AS New_Repeat_Bills,
SUM(CASE WHEN maxf>1 AND minf>1 THEN bills END) AS Old_Repeat_Bills,SUM(bills) AS bills,
SUM(sales)/SUM(bills) AS ABV,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END)/SUM(CASE WHEN maxf=1 AND minf=1 THEN bills END) Onetimer_ABV,
SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END)/SUM(CASE WHEN maxf>1 AND minf=1 THEN bills END) AS New_Repeat_ABV,
SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END)/SUM(CASE WHEN maxf>1 AND minf>1 THEN bills END) AS Old_Repeat_ABV,
SUM(sales)/COUNT(mobile) AMV,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END)/COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN mobile END) Onetimer_AMV,
SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END)/COUNT(DISTINCT CASE WHEN maxf>1 AND minf=1 THEN mobile END) AS New_Repeat_AMV,
SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END)/COUNT(DISTINCT CASE WHEN maxf>1 AND minf>1 THEN mobile END) AS Old_Repeat_AMV,
SUM(points_collected) AS Transaction_Points_issued,SUM(redeemed) AS Points_redeemed
FROM (SELECT mobile, TxnMonth,TxnYear ,SUM(Amount) AS sales,COUNT(DISTINCT (UniqueBillNo)) AS bills,
MAX(frequencycount) AS maxf, MIN(frequencycount) AS minf,
SUM(pointscollected) AS Points_collected,SUM(pointsspent) AS Redeemed
FROM txn_report_accrual_redemption 
WHERE TxnDate BETWEEN '2025-03-01' AND '2025-03-31'
AND storecode NOT LIKE '%demo%' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND insertiondate<'2025-04-01'
GROUP BY 1,2,3)a GROUP BY 1,2;

################################################################################################################
################################################################################################################

-- Channelwise 

#### Offline KPIs
-- Prev Year MBR Month
SELECT TxnMonth, TxnYear,COUNT(mobile)Transacting_Customers,
COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN mobile END)OneTimer,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf=1 THEN mobile END)New_Repeater,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf>1 THEN mobile END)Old_Repeater,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END) AS onetimer_Sales,
SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END) AS New_Repeat_Sales,
SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END) AS Old_Repeat_Sales,SUM(sales)sales,
SUM(CASE WHEN maxf=1 AND minf=1 THEN bills END) AS onetimer_Bills,
SUM(CASE WHEN maxf>1 AND minf=1 THEN bills END) AS New_Repeat_Bills,
SUM(CASE WHEN maxf>1 AND minf>1 THEN bills END) AS Old_Repeat_Bills,SUM(bills) AS bills,
SUM(sales)/SUM(bills) AS ABV,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END)/SUM(CASE WHEN maxf=1 AND minf=1 THEN bills END) Onetimer_ABV,
SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END)/SUM(CASE WHEN maxf>1 AND minf=1 THEN bills END) AS New_Repeat_ABV,
SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END)/SUM(CASE WHEN maxf>1 AND minf>1 THEN bills END) AS Old_Repeat_ABV,
SUM(sales)/COUNT(mobile) AMV,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END)/COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN mobile END) Onetimer_AMV,
SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END)/COUNT(DISTINCT CASE WHEN maxf>1 AND minf=1 THEN mobile END) AS New_Repeat_AMV,
SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END)/COUNT(DISTINCT CASE WHEN maxf>1 AND minf>1 THEN mobile END) AS Old_Repeat_AMV,
SUM(points_collected) AS Transaction_Points_issued,SUM(redeemed) AS Points_redeemed
FROM (SELECT mobile, TxnMonth,TxnYear ,SUM(Amount) AS sales,COUNT(DISTINCT (UniqueBillNo)) AS bills,
MAX(frequencycount) AS maxf, MIN(frequencycount) AS minf,
SUM(pointscollected) AS Points_collected,SUM(pointsspent) AS Redeemed
FROM txn_report_accrual_redemption
WHERE TxnDate BETWEEN '2024-03-01' AND '2024-03-31'
AND storecode NOT IN ('Demo','ecom','corporate')
AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
GROUP BY 1,2,3)a GROUP BY 1,2
UNION
-- Prev Month MBR
SELECT TxnMonth, TxnYear,COUNT(mobile)Transacting_Customers,
COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN mobile END)OneTimer,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf=1 THEN mobile END)New_Repeater,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf>1 THEN mobile END)Old_Repeater,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END) AS onetimer_Sales,
SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END) AS New_Repeat_Sales,
SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END) AS Old_Repeat_Sales,SUM(sales)sales,
SUM(CASE WHEN maxf=1 AND minf=1 THEN bills END) AS onetimer_Bills,
SUM(CASE WHEN maxf>1 AND minf=1 THEN bills END) AS New_Repeat_Bills,
SUM(CASE WHEN maxf>1 AND minf>1 THEN bills END) AS Old_Repeat_Bills,SUM(bills) AS bills,
SUM(sales)/SUM(bills) AS ABV,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END)/SUM(CASE WHEN maxf=1 AND minf=1 THEN bills END) Onetimer_ABV,
SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END)/SUM(CASE WHEN maxf>1 AND minf=1 THEN bills END) AS New_Repeat_ABV,
SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END)/SUM(CASE WHEN maxf>1 AND minf>1 THEN bills END) AS Old_Repeat_ABV,
SUM(sales)/COUNT(mobile) AMV,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END)/COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN mobile END) Onetimer_AMV,
SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END)/COUNT(DISTINCT CASE WHEN maxf>1 AND minf=1 THEN mobile END) AS New_Repeat_AMV,
SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END)/COUNT(DISTINCT CASE WHEN maxf>1 AND minf>1 THEN mobile END) AS Old_Repeat_AMV,
SUM(points_collected) AS Transaction_Points_issued,SUM(redeemed) AS Points_redeemed
FROM (SELECT mobile, TxnMonth,TxnYear ,SUM(Amount) AS sales,COUNT(DISTINCT (UniqueBillNo)) AS bills,
MAX(frequencycount) AS maxf, MIN(frequencycount) AS minf,
SUM(pointscollected) AS Points_collected,SUM(pointsspent) AS Redeemed
FROM txn_report_accrual_redemption 
WHERE TxnDate BETWEEN '2025-02-01' AND '2025-02-28'
AND storecode NOT IN ('Demo','ecom','corporate')
AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
GROUP BY 1,2,3)a GROUP BY 1,2
UNION
-- Current Month MBR
SELECT TxnMonth, TxnYear,COUNT(mobile)Transacting_Customers,
COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN mobile END)OneTimer,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf=1 THEN mobile END)New_Repeater,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf>1 THEN mobile END)Old_Repeater,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END) AS onetimer_Sales,
SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END) AS New_Repeat_Sales,
SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END) AS Old_Repeat_Sales,SUM(sales)sales,
SUM(CASE WHEN maxf=1 AND minf=1 THEN bills END) AS onetimer_Bills,
SUM(CASE WHEN maxf>1 AND minf=1 THEN bills END) AS New_Repeat_Bills,
SUM(CASE WHEN maxf>1 AND minf>1 THEN bills END) AS Old_Repeat_Bills,SUM(bills) AS bills,
SUM(sales)/SUM(bills) AS ABV,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END)/SUM(CASE WHEN maxf=1 AND minf=1 THEN bills END) Onetimer_ABV,
SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END)/SUM(CASE WHEN maxf>1 AND minf=1 THEN bills END) AS New_Repeat_ABV,
SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END)/SUM(CASE WHEN maxf>1 AND minf>1 THEN bills END) AS Old_Repeat_ABV,
SUM(sales)/COUNT(mobile) AMV,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END)/COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN mobile END) Onetimer_AMV,
SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END)/COUNT(DISTINCT CASE WHEN maxf>1 AND minf=1 THEN mobile END) AS New_Repeat_AMV,
SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END)/COUNT(DISTINCT CASE WHEN maxf>1 AND minf>1 THEN mobile END) AS Old_Repeat_AMV,
SUM(points_collected) AS Transaction_Points_issued,SUM(redeemed) AS Points_redeemed
FROM (SELECT mobile, TxnMonth,TxnYear ,SUM(Amount) AS sales,COUNT(DISTINCT (UniqueBillNo)) AS bills,
MAX(frequencycount) AS maxf, MIN(frequencycount) AS minf,
SUM(pointscollected) AS Points_collected,SUM(pointsspent) AS Redeemed
FROM txn_report_accrual_redemption 
WHERE TxnDate BETWEEN '2025-03-01' AND '2025-03-31'
AND storecode NOT IN ('Demo','ecom','corporate')
AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND insertiondate<'2025-04-01'
GROUP BY 1,2,3)a GROUP BY 1,2;

 
#### Online KPIs
-- Prev Year MBR Month
SELECT TxnMonth, TxnYear,COUNT(mobile)Transacting_Customers,
COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN mobile END)OneTimer,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf=1 THEN mobile END)New_Repeater,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf>1 THEN mobile END)Old_Repeater,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END) AS onetimer_Sales,
SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END) AS New_Repeat_Sales,
SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END) AS Old_Repeat_Sales,SUM(sales)sales,
SUM(CASE WHEN maxf=1 AND minf=1 THEN bills END) AS onetimer_Bills,
SUM(CASE WHEN maxf>1 AND minf=1 THEN bills END) AS New_Repeat_Bills,
SUM(CASE WHEN maxf>1 AND minf>1 THEN bills END) AS Old_Repeat_Bills,SUM(bills) AS bills,
SUM(sales)/SUM(bills) AS ABV,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END)/SUM(CASE WHEN maxf=1 AND minf=1 THEN bills END) Onetimer_ABV,
SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END)/SUM(CASE WHEN maxf>1 AND minf=1 THEN bills END) AS New_Repeat_ABV,
SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END)/SUM(CASE WHEN maxf>1 AND minf>1 THEN bills END) AS Old_Repeat_ABV,
SUM(sales)/COUNT(mobile) AMV,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END)/COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN mobile END) Onetimer_AMV,
SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END)/COUNT(DISTINCT CASE WHEN maxf>1 AND minf=1 THEN mobile END) AS New_Repeat_AMV,
SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END)/COUNT(DISTINCT CASE WHEN maxf>1 AND minf>1 THEN mobile END) AS Old_Repeat_AMV,
SUM(points_collected) AS Transaction_Points_issued,SUM(redeemed) AS Points_redeemed
FROM (SELECT mobile, TxnMonth,TxnYear ,SUM(Amount) AS sales,COUNT(DISTINCT (UniqueBillNo)) AS bills,
MAX(frequencycount) AS maxf, MIN(frequencycount) AS minf,
SUM(pointscollected) AS Points_collected,SUM(pointsspent) AS Redeemed
FROM txn_report_accrual_redemption 
WHERE TxnDate BETWEEN '2024-03-01' AND '2024-03-31'
AND storecode IN ('ecom','corporate')
AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
GROUP BY 1,2,3)a GROUP BY 1,2
UNION
-- Prev Month MBR
SELECT TxnMonth, TxnYear,COUNT(mobile)Transacting_Customers,
COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN mobile END)OneTimer,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf=1 THEN mobile END)New_Repeater,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf>1 THEN mobile END)Old_Repeater,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END) AS onetimer_Sales,
SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END) AS New_Repeat_Sales,
SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END) AS Old_Repeat_Sales,SUM(sales)sales,
SUM(CASE WHEN maxf=1 AND minf=1 THEN bills END) AS onetimer_Bills,
SUM(CASE WHEN maxf>1 AND minf=1 THEN bills END) AS New_Repeat_Bills,
SUM(CASE WHEN maxf>1 AND minf>1 THEN bills END) AS Old_Repeat_Bills,SUM(bills) AS bills,
SUM(sales)/SUM(bills) AS ABV,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END)/SUM(CASE WHEN maxf=1 AND minf=1 THEN bills END) Onetimer_ABV,
SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END)/SUM(CASE WHEN maxf>1 AND minf=1 THEN bills END) AS New_Repeat_ABV,
SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END)/SUM(CASE WHEN maxf>1 AND minf>1 THEN bills END) AS Old_Repeat_ABV,
SUM(sales)/COUNT(mobile) AMV,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END)/COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN mobile END) Onetimer_AMV,
SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END)/COUNT(DISTINCT CASE WHEN maxf>1 AND minf=1 THEN mobile END) AS New_Repeat_AMV,
SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END)/COUNT(DISTINCT CASE WHEN maxf>1 AND minf>1 THEN mobile END) AS Old_Repeat_AMV,
SUM(points_collected) AS Transaction_Points_issued,SUM(redeemed) AS Points_redeemed
FROM (SELECT mobile, TxnMonth,TxnYear ,SUM(Amount) AS sales,COUNT(DISTINCT (UniqueBillNo)) AS bills,
MAX(frequencycount) AS maxf, MIN(frequencycount) AS minf,
SUM(pointscollected) AS Points_collected,SUM(pointsspent) AS Redeemed
FROM txn_report_accrual_redemption 
WHERE TxnDate BETWEEN '2025-02-01' AND '2025-02-28'
AND storecode IN ('ecom','corporate')
AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
GROUP BY 1,2,3)a GROUP BY 1,2
UNION
-- Current Month MBR
SELECT TxnMonth, TxnYear,COUNT(mobile)Transacting_Customers,
COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN mobile END)OneTimer,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf=1 THEN mobile END)New_Repeater,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf>1 THEN mobile END)Old_Repeater,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END) AS onetimer_Sales,
SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END) AS New_Repeat_Sales,
SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END) AS Old_Repeat_Sales,SUM(sales)sales,
SUM(CASE WHEN maxf=1 AND minf=1 THEN bills END) AS onetimer_Bills,
SUM(CASE WHEN maxf>1 AND minf=1 THEN bills END) AS New_Repeat_Bills,
SUM(CASE WHEN maxf>1 AND minf>1 THEN bills END) AS Old_Repeat_Bills,SUM(bills) AS bills,
SUM(sales)/SUM(bills) AS ABV,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END)/SUM(CASE WHEN maxf=1 AND minf=1 THEN bills END) Onetimer_ABV,
SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END)/SUM(CASE WHEN maxf>1 AND minf=1 THEN bills END) AS New_Repeat_ABV,
SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END)/SUM(CASE WHEN maxf>1 AND minf>1 THEN bills END) AS Old_Repeat_ABV,
SUM(sales)/COUNT(mobile) AMV,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END)/COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN mobile END) Onetimer_AMV,
SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END)/COUNT(DISTINCT CASE WHEN maxf>1 AND minf=1 THEN mobile END) AS New_Repeat_AMV,
SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END)/COUNT(DISTINCT CASE WHEN maxf>1 AND minf>1 THEN mobile END) AS Old_Repeat_AMV,
SUM(points_collected) AS Transaction_Points_issued,SUM(redeemed) AS Points_redeemed
FROM (SELECT mobile, TxnMonth,TxnYear ,SUM(Amount) AS sales,COUNT(DISTINCT (UniqueBillNo)) AS bills,
MAX(frequencycount) AS maxf, MIN(frequencycount) AS minf,
SUM(pointscollected) AS Points_collected,SUM(pointsspent) AS Redeemed
FROM txn_report_accrual_redemption 
WHERE TxnDate BETWEEN '2025-03-01' AND '2025-03-31'
AND storecode IN ('ecom','corporate')
AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND insertiondate<'2025-04-01'
GROUP BY 1,2,3)a GROUP BY 1,2;

####################################################################################################################
####################################################################################################################
-- ATV Band 
SELECT CASE WHEN ATV <1500 THEN 'upto 1500'
WHEN ATV BETWEEN 1500 AND 3000 THEN '1500-3000'
WHEN ATV BETWEEN 3001 AND 4500 THEN '3001-4500'
WHEN ATV BETWEEN 4501 AND 6000 THEN '4501-6000'
WHEN ATV BETWEEN 6001 AND 7500 THEN '6001-7500'
WHEN ATV BETWEEN 7501 AND 9000 THEN '7501-9000'
WHEN ATV BETWEEN 9001 AND 10500 THEN '9001-10500'
WHEN ATV BETWEEN 10501 AND 12000 THEN '10501-12000'
WHEN ATV > 12000 THEN 'more than 12000'
END AS ATV_band,COUNT(mobile)AS customers,SUM(bills) AS bills,SUM(sales) AS sales
FROM (
SELECT mobile,COUNT(DISTINCT uniquebillno) AS bills,SUM(amount) AS sales,
SUM(amount)/COUNT(DISTINCT uniquebillno) AS ATV
FROM `txn_report_accrual_redemption`
WHERE insertiondate< '2025-04-01'
AND txndate BETWEEN  '2025-03-01' AND '2025-03-31'
GROUP BY 1)a
GROUP BY 1
ORDER BY ATV;
####################################################################################################################

-- Tierwise Points Data 
-- SELECT tier,COUNT(mobile),SUM(Points_collected),SUM(Points_Redeemed),
-- SUM(CASE WHEN max_fc>1 THEN Points_Redeemed END) AS point_redeemed_by_oldmembers
--  FROM
-- (SELECT a.mobile,tier,
-- SUM(a.pointscollected) AS Points_collected,SUM(a.pointsspent) AS Points_Redeemed, MAX(frequencycount) AS max_fc
-- FROM `txn_report_accrual_redemption` a JOIN member_report b  ON a.mobile=b.mobile
-- WHERE a.insertiondate< '2024-07-05'
-- AND txndate BETWEEN  '2024-08-01' AND '2024-08-31'
-- AND modifiedbillno NOT LIKE '%brn%'
-- AND modifiedbillno NOT LIKE '%roll%' AND storecode NOT LIKE '%demo%'
-- GROUP BY 1)c
-- GROUP BY 1;

########################################################################################################################################################################################################################################
#use this code for coupon data for previous month 
-- overall issued mobile for previous month when you want to update overall data then you have to 
-- commet this line CASE WHEN issuedstore='ecom' THEN "online" ELSE "offline" END AS storetype,and 
-- group by 2 channel wise you have to extract over all data so run without commet

SELECT 
CASE WHEN issuedstore='ecom' THEN "online" ELSE "offline" END AS storetype,
MONTHNAME(issueddate), COUNT(*)Issued
FROM coupon_offer_report 
WHERE issueddate BETWEEN '2025-02-01' AND '2025-02-28' 
AND issuedstore<>'demo'
GROUP BY 1
,2
;
-- channel wise other kpis for previous month  
SELECT -- 
CASE WHEN redeemedstorecode='ecom' THEN "online" ELSE "offline" END AS storetype,
MONTH(useddate),COUNT(DISTINCT issuedmobile)Redeemers, 
COUNT(couponcode)CouponsRedeemed, SUM(b.amount)RedemptionSale, 
COUNT(modifiedbillno) redemptionbills, SUM(discount)discount 
FROM coupon_offer_report a JOIN txn_Report_accrual_Redemption b ON a.billno=b.modifiedbillno 
WHERE useddate BETWEEN '2025-02-01' AND '2025-02-28' AND couponstatus = 'Used' 
AND redeemedstorecode<>'demo' 
GROUP BY 1
,2
; 





#use this code for coupon data
-- overall issued mobile for current month when you want to update overall data then you have to 
-- commet this line CASE WHEN issuedstore='ecom' THEN "online" ELSE "offline" END AS storetype,and group by 2 channel wise you have to extract over all data so run without commet
SELECT 
-- CASE WHEN issuedstore='ecom' THEN "online" ELSE "offline" END AS storetype,
MONTHNAME(issueddate), COUNT(*)Issued
FROM coupon_offer_report 
WHERE issueddate BETWEEN '2025-03-01' AND '2025-03-31' 
AND issuedstore <>'demo'
GROUP BY 1
,2
;
-- channel wise other kpis for current month  
SELECT -- 
-- CASE WHEN redeemedstorecode='ecom' THEN "online" ELSE "offline" END AS storetype,
MONTH(useddate),COUNT(DISTINCT issuedmobile)Redeemers, 
COUNT(couponcode)CouponsRedeemed, SUM(b.amount)RedemptionSale, 
COUNT(modifiedbillno) redemptionbills, SUM(discount)discount 
FROM coupon_offer_report a JOIN txn_Report_accrual_Redemption b ON a.billno=b.modifiedbillno 
WHERE useddate BETWEEN '2025-03-01' AND '2025-03-31' AND couponstatus = 'Used' 
AND redeemedstorecode <> 'demo'
GROUP BY 1
-- ,2
; 


##########

-- ## Coupon Level Data   ---wrond code 
SELECT "feb25" AS PERIOD,
CASE WHEN redeemedstorecode='ecom' THEN "online" ELSE "offline" END AS storetype,
COUNT(*)Issued,COUNT(DISTINCT CASE WHEN couponstatus='Used' THEN issuedmobile END)Redeemers,
COUNT(CASE WHEN couponstatus='Used' THEN couponoffercode END)CouponsRedeemed,SUM(discount)disc 
FROM coupon_offer_report WHERE useddate BETWEEN '2025-02-01' AND '2025-02-28' 
AND redeemedstorecode<>'demo'
GROUP BY 2
UNION
SELECT "mar25" AS PERIOD,
CASE WHEN redeemedstorecode='ecom' THEN "online" ELSE "offline" END AS storetype,
COUNT(*)Issued,COUNT(DISTINCT CASE WHEN couponstatus='Used' THEN issuedmobile END)Redeemers,
COUNT(CASE WHEN couponstatus='Used' THEN couponoffercode END)CouponsRedeemed,SUM(discount)disc 
FROM coupon_offer_report WHERE useddate BETWEEN '2025-03-01' AND '2025-03-31'
AND redeemedstorecode<>'demo'
GROUP BY 2;

-- -- Overall
SELECT "feb25" AS PERIOD,
COUNT(*)Issued,COUNT(DISTINCT CASE WHEN couponstatus='Used' THEN issuedmobile END)Redeemers,
COUNT(CASE WHEN couponstatus='Used' THEN couponoffercode END)CouponsRedeemed,SUM(discount)disc 
FROM coupon_offer_report WHERE useddate BETWEEN '2025-02-01' AND '2025-02-28' 
AND redeemedstorecode<>'demo'
UNION
SELECT "mar25" AS PERIOD,
COUNT(*)Issued,COUNT(DISTINCT CASE WHEN couponstatus='Used' THEN issuedmobile END)Redeemers,
COUNT(CASE WHEN couponstatus='Used' THEN couponoffercode END)CouponsRedeemed,SUM(discount)disc 
FROM coupon_offer_report WHERE useddate BETWEEN '2025-03-01' AND '2025-03-31'
AND redeemedstorecode<>'demo';

-- QC
SELECT redeemedmobile,couponoffercode,redeemedstorecode FROM coupon_offer_report
 WHERE issueddate BETWEEN '2025-02-01' AND '2025-02-28'
AND redeemedstorecode='ecom'
AND redeemedmobile IS NOT NULL;


####################################################################################################################
-- MOM KPIs
SELECT TxnMonth, TxnYear,COUNT(mobile)Transacting_Customers,
COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN mobile END)OneTimer,
COUNT(DISTINCT CASE WHEN maxf>1 THEN mobile END) Repeater,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END) AS onetimer_Sales,
SUM(CASE WHEN maxf>1 THEN sales END) AS Repeat_Sales,
SUM(sales) sales,
SUM(CASE WHEN maxf=1 AND minf=1 THEN bills END) AS onetimer_Bills,
SUM(CASE WHEN maxf>1 THEN bills END) AS Repeat_Bills,
SUM(bills) AS bills,
SUM(sales)/SUM(bills) AS ABV,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END)/SUM(CASE WHEN maxf=1 AND minf=1 THEN bills END) Onetimer_ABV,
SUM(CASE WHEN maxf>1 THEN sales END)/SUM(CASE WHEN maxf>1 THEN bills END) AS Repeat_ABV
FROM (SELECT mobile, TxnMonth,TxnYear ,SUM(Amount) AS sales,COUNT(DISTINCT (UniqueBillNo)) AS bills,
MAX(frequencycount) AS maxf, MIN(frequencycount) AS minf
FROM txn_report_accrual_redemption 
WHERE TxnDate BETWEEN '2022-11-01' AND '2025-03-31'
AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND storecode NOT IN ('ecom','demo')
AND insertiondate<'2025-04-01'
GROUP BY 1,2,3)a GROUP BY 1,2;