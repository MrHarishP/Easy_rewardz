SET @startdate = DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-01');
SET @enddate = LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH));
SET @startdate_1 = DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 2 MONTH), '%Y-%m-01');
SET @enddate_1 = LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 2 MONTH));
SET @startdate_1y = DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 13 MONTH), '%Y-%m-01');
SET @enddate_1y = LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 13 MONTH));


SELECT @startdate,@enddate,@startdate_1,@enddate_1,@startdate_1y,@enddate_1y;



SELECT CONCAT(MONTHNAME(modifiedenrolledon),YEAR(modifiedenrolledon)) AS PERIOD,
COUNT(DISTINCT mobile) AS enrollment
FROM `numerouno`.member_report 
WHERE enrolledstorecode NOT LIKE '%demo%'
AND modifiedenrolledon BETWEEN  @startdate_1y AND @enddate_1y
UNION
-- Prev Month MBR
SELECT CONCAT(MONTHNAME(modifiedenrolledon),YEAR(modifiedenrolledon)) AS PERIOD,
COUNT(DISTINCT mobile) AS enrollment
FROM `numerouno`.member_report 
WHERE enrolledstorecode NOT LIKE '%demo%'
AND modifiedenrolledon BETWEEN  @startdate_1 AND @enddate_1
UNION
-- current MBR
SELECT CONCAT(MONTHNAME(modifiedenrolledon),YEAR(modifiedenrolledon)) AS PERIOD,
COUNT(DISTINCT mobile) AS enrollment
FROM `numerouno`.member_report 
WHERE enrolledstorecode NOT LIKE '%demo%'
AND modifiedenrolledon BETWEEN @startdate AND @enddate
AND insertiondate<CURDATE();

SET @startdate = DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-01');
SET @enddate = LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH));
SET @startdate_1 = DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 2 MONTH), '%Y-%m-01');
SET @enddate_1 = LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 2 MONTH));
SET @startdate_1y = DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 13 MONTH), '%Y-%m-01');
SET @enddate_1y = LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 13 MONTH));



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
FROM 
(
SELECT mobile, TxnMonth,TxnYear ,SUM(Amount) AS sales,COUNT(DISTINCT (UniqueBillNo)) AS bills,
MAX(frequencycount) AS maxf, MIN(frequencycount) AS minf,
SUM(pointscollected) AS Points_collected,SUM(pointsspent) AS Redeemed
FROM `numerouno`.txn_report_accrual_redemption 
WHERE TxnDate BETWEEN @startdate_1y AND @enddate_1y
AND storecode NOT LIKE '%demo%' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
GROUP BY 1,2,3
)
a GROUP BY 1,2
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
FROM `numerouno`.txn_report_accrual_redemption 
WHERE TxnDate BETWEEN @startdate_1 AND @enddate_1
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
FROM `numerouno`.txn_report_accrual_redemption 
WHERE TxnDate BETWEEN @startdate AND @enddate
AND storecode NOT LIKE '%demo%' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND insertiondate<CURDATE()
GROUP BY 1,2,3)a GROUP BY 1,2;


