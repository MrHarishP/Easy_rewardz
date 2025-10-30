SET @insertiondate=CURDATE();
SET @MBRstartdate=DATE_SUB(((@insertiondate-INTERVAL 30 DAY)),INTERVAL DAYOFMONTH((@insertiondate-INTERVAL 30 DAY))-1 DAY),@MBRenddate=LAST_DAY(@insertiondate-INTERVAL 30 DAY);
SET @MBRPREVStartDate=DATE_SUB(@MBRstartdate,INTERVAL DAYOFMONTH(@MBRstartdate - INTERVAL 1 DAY) DAY);
SET @MBRPREVEndDate=LAST_DAY(@MBRPREVStartDate);
SET @MBRPREVYearStartDate=@MBRstartdate- INTERVAL 1 YEAR;
SET @MBRPREVYearEndDate=LAST_DAY(@MBRstartdate- INTERVAL 1 YEAR);

SELECT @MBRstartdate,@MBRenddate,@insertiondate, @MBRPREVStartDate,@MBRPREVEndDate,@MBRPREVYearStartDate,@MBRPREVYearEndDate;

## Enrollments
SET @insertiondate=CURDATE();
SET @MBRstartdate=DATE_SUB(((@insertiondate-INTERVAL 30 DAY)),INTERVAL DAYOFMONTH((@insertiondate-INTERVAL 30 DAY))-1 DAY),@MBRenddate=LAST_DAY(@insertiondate-INTERVAL 30 DAY);
SET @MBRPREVStartDate=DATE_SUB(@MBRstartdate,INTERVAL DAYOFMONTH(@MBRstartdate - INTERVAL 1 DAY) DAY);
SET @MBRPREVEndDate=LAST_DAY(@MBRPREVStartDate);
SET @MBRPREVYearStartDate=@MBRstartdate- INTERVAL 1 YEAR;
SET @MBRPREVYearEndDate=LAST_DAY(@MBRstartdate- INTERVAL 1 YEAR);

-- Prev year current MBR
SELECT CONCAT(MONTHNAME(modifiedenrolledon),YEAR(modifiedenrolledon)) AS PERIOD,
COUNT(DISTINCT CASE WHEN enrolledstorecode = 'ECOM' THEN membershipno END) AS 'ECOM',
COUNT(DISTINCT CASE WHEN enrolledstorecode <> 'ECOM' THEN membershipno END) AS 'OFFLINE',
COUNT(DISTINCT membershipno) AS Over_All 
FROM `forestessentials`.member_report 
WHERE enrolledstorecode NOT LIKE '%demo%'
AND modifiedenrolledon BETWEEN  @MBRPREVYearStartDate AND @MBRPREVYearEndDate
UNION
-- Prev Month MBR
SELECT CONCAT(MONTHNAME(modifiedenrolledon),YEAR(modifiedenrolledon)) AS PERIOD,
COUNT(DISTINCT CASE WHEN enrolledstorecode = 'ECOM' THEN membershipno END) AS 'ECOM',
COUNT(DISTINCT CASE WHEN enrolledstorecode <> 'ECOM' THEN membershipno END) AS 'OFFLINE',
COUNT(DISTINCT membershipno) AS Over_All 
FROM `forestessentials`.member_report 
WHERE enrolledstorecode NOT LIKE '%demo%'
AND modifiedenrolledon BETWEEN  @MBRPREVStartDate AND @MBRPREVEndDate
UNION
-- current MBR
SELECT CONCAT(MONTHNAME(modifiedenrolledon),YEAR(modifiedenrolledon)) AS PERIOD,
COUNT(DISTINCT CASE WHEN enrolledstorecode = 'ECOM' THEN membershipno END) AS 'ECOM',
COUNT(DISTINCT CASE WHEN enrolledstorecode <> 'ECOM' THEN membershipno END) AS 'OFFLINE',
COUNT(DISTINCT membershipno) AS Over_All 
FROM `forestessentials`.member_report 
WHERE enrolledstorecode NOT LIKE '%demo%'
AND modifiedenrolledon BETWEEN @MBRstartdate AND @MBRenddate
AND insertiondate<@insertiondate;
####################################################################################################################

-- Overall
#### KPIs
-- Prev Year MBR Month # prev current month data like its march of 2025 and we extracting current month of 2024
SELECT TxnMonth, TxnYear,COUNT(membershipcardnumber)Transacting_Customers,
COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN membershipcardnumber END)OneTimer,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf=1 THEN membershipcardnumber END)New_Repeater,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf>1 THEN membershipcardnumber END)Old_Repeater,
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
SUM(sales)/COUNT(membershipcardnumber) AMV,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END)/COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN membershipcardnumber END) Onetimer_AMV,
SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END)/COUNT(DISTINCT CASE WHEN maxf>1 AND minf=1 THEN membershipcardnumber END) AS New_Repeat_AMV,
SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END)/COUNT(DISTINCT CASE WHEN maxf>1 AND minf>1 THEN membershipcardnumber END) AS Old_Repeat_AMV,
SUM(points_collected) AS Transaction_Points_issued,SUM(redeemed) AS Points_redeemed
FROM (SELECT membershipcardnumber, TxnMonth,TxnYear ,SUM(Amount) AS sales,COUNT(DISTINCT (UniqueBillNo)) AS bills,
MAX(frequencycount) AS maxf, MIN(frequencycount) AS minf,
SUM(pointscollected) AS Points_collected,SUM(pointsspent) AS Redeemed
FROM txn_report_accrual_redemption 
WHERE TxnDate BETWEEN '2024-04-01' AND '2024-04-30'
AND storecode NOT LIKE '%demo%' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
GROUP BY 1,2,3)a GROUP BY 1,2
UNION
-- Prev Month MBR #prev month MBR mean the prev month from the current for ex its march so prev month was jan and current month is feb
SELECT TxnMonth, TxnYear,COUNT(membershipcardnumber)Transacting_Customers,
COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN membershipcardnumber END)OneTimer,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf=1 THEN membershipcardnumber END)New_Repeater,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf>1 THEN membershipcardnumber END)Old_Repeater,
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
SUM(sales)/COUNT(membershipcardnumber) AMV,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END)/COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN membershipcardnumber END) Onetimer_AMV,
SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END)/COUNT(DISTINCT CASE WHEN maxf>1 AND minf=1 THEN membershipcardnumber END) AS New_Repeat_AMV,
SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END)/COUNT(DISTINCT CASE WHEN maxf>1 AND minf>1 THEN membershipcardnumber END) AS Old_Repeat_AMV,
SUM(points_collected) AS Transaction_Points_issued,SUM(redeemed) AS Points_redeemed
FROM (SELECT membershipcardnumber, TxnMonth,TxnYear ,SUM(Amount) AS sales,COUNT(DISTINCT (UniqueBillNo)) AS bills,
MAX(frequencycount) AS maxf, MIN(frequencycount) AS minf,
SUM(pointscollected) AS Points_collected,SUM(pointsspent) AS Redeemed
FROM txn_report_accrual_redemption 
WHERE TxnDate BETWEEN '2025-03-01' AND '2025-03-31'
AND storecode NOT LIKE '%demo%' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
GROUP BY 1,2,3)a GROUP BY 1,2
UNION
-- Current Month MBR # current month mean the like its mar and we take feb because we are looking for current month and current month is feb
SELECT TxnMonth, TxnYear,COUNT(membershipcardnumber)Transacting_Customers,
COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN membershipcardnumber END)OneTimer,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf=1 THEN membershipcardnumber END)New_Repeater,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf>1 THEN membershipcardnumber END)Old_Repeater,
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
SUM(sales)/COUNT(membershipcardnumber) AMV,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END)/COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN membershipcardnumber END) Onetimer_AMV,
SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END)/COUNT(DISTINCT CASE WHEN maxf>1 AND minf=1 THEN membershipcardnumber END) AS New_Repeat_AMV,
SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END)/COUNT(DISTINCT CASE WHEN maxf>1 AND minf>1 THEN membershipcardnumber END) AS Old_Repeat_AMV,
SUM(points_collected) AS Transaction_Points_issued,SUM(redeemed) AS Points_redeemed
FROM (SELECT membershipcardnumber, TxnMonth,TxnYear ,SUM(Amount) AS sales,COUNT(DISTINCT (UniqueBillNo)) AS bills,
MAX(frequencycount) AS maxf, MIN(frequencycount) AS minf,
SUM(pointscollected) AS Points_collected,SUM(pointsspent) AS Redeemed
FROM txn_report_accrual_redemption 
WHERE TxnDate BETWEEN '2025-04-01' AND '2025-04-30'
AND storecode NOT LIKE '%demo%' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND insertiondate<'2025-05-05'
GROUP BY 1,2,3)a GROUP BY 1,2;


################################################################################################################
################################################################################################################

-- Channelwise 

#### Offline KPIs
-- Prev Year MBR Month   # prev current month data like its march of 2025 and we extracting current month of 2024
SELECT TxnMonth, TxnYear,COUNT(membershipcardnumber)Transacting_Customers,
COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN membershipcardnumber END)OneTimer,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf=1 THEN membershipcardnumber END)New_Repeater,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf>1 THEN membershipcardnumber END)Old_Repeater,
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
SUM(sales)/COUNT(membershipcardnumber) AMV,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END)/COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN membershipcardnumber END) Onetimer_AMV,
SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END)/COUNT(DISTINCT CASE WHEN maxf>1 AND minf=1 THEN membershipcardnumber END) AS New_Repeat_AMV,
SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END)/COUNT(DISTINCT CASE WHEN maxf>1 AND minf>1 THEN membershipcardnumber END) AS Old_Repeat_AMV,
SUM(points_collected) AS Transaction_Points_issued,SUM(redeemed) AS Points_redeemed
FROM (SELECT membershipcardnumber, TxnMonth,TxnYear ,SUM(Amount) AS sales,COUNT(DISTINCT (UniqueBillNo)) AS bills,
MAX(frequencycount) AS maxf, MIN(frequencycount) AS minf,
SUM(pointscollected) AS Points_collected,SUM(pointsspent) AS Redeemed
FROM txn_report_accrual_redemption 
WHERE TxnDate BETWEEN '2024-04-01' AND '2024-04-30'
AND storecode NOT IN ('Demo','ecom')
AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
GROUP BY 1,2,3)a GROUP BY 1,2
UNION
-- Prev Month MBR #prev month MBR mean the prev month from the current for exp its march so prev month was jan and current month is feb
SELECT TxnMonth, TxnYear,COUNT(membershipcardnumber)Transacting_Customers,
COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN membershipcardnumber END)OneTimer,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf=1 THEN membershipcardnumber END)New_Repeater,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf>1 THEN membershipcardnumber END)Old_Repeater,
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
SUM(sales)/COUNT(membershipcardnumber) AMV,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END)/COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN membershipcardnumber END) Onetimer_AMV,
SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END)/COUNT(DISTINCT CASE WHEN maxf>1 AND minf=1 THEN membershipcardnumber END) AS New_Repeat_AMV,
SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END)/COUNT(DISTINCT CASE WHEN maxf>1 AND minf>1 THEN membershipcardnumber END) AS Old_Repeat_AMV,
SUM(points_collected) AS Transaction_Points_issued,SUM(redeemed) AS Points_redeemed
FROM (SELECT membershipcardnumber, TxnMonth,TxnYear ,SUM(Amount) AS sales,COUNT(DISTINCT (UniqueBillNo)) AS bills,
MAX(frequencycount) AS maxf, MIN(frequencycount) AS minf,
SUM(pointscollected) AS Points_collected,SUM(pointsspent) AS Redeemed
FROM txn_report_accrual_redemption 
WHERE TxnDate BETWEEN '2025-03-01' AND '2025-03-31'
AND storecode NOT IN ('Demo','ecom')
AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
GROUP BY 1,2,3)a GROUP BY 1,2
UNION
-- Current Month MBR #current month mean the like its mar and we take feb because we are looking for current month and current month is feb
SELECT TxnMonth, TxnYear,COUNT(membershipcardnumber)Transacting_Customers,
COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN membershipcardnumber END)OneTimer,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf=1 THEN membershipcardnumber END)New_Repeater,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf>1 THEN membershipcardnumber END)Old_Repeater,
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
SUM(sales)/COUNT(membershipcardnumber) AMV,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END)/COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN membershipcardnumber END) Onetimer_AMV,
SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END)/COUNT(DISTINCT CASE WHEN maxf>1 AND minf=1 THEN membershipcardnumber END) AS New_Repeat_AMV,
SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END)/COUNT(DISTINCT CASE WHEN maxf>1 AND minf>1 THEN membershipcardnumber END) AS Old_Repeat_AMV,
SUM(points_collected) AS Transaction_Points_issued,SUM(redeemed) AS Points_redeemed
FROM (SELECT membershipcardnumber, TxnMonth,TxnYear ,SUM(Amount) AS sales,COUNT(DISTINCT (UniqueBillNo)) AS bills,
MAX(frequencycount) AS maxf, MIN(frequencycount) AS minf,
SUM(pointscollected) AS Points_collected,SUM(pointsspent) AS Redeemed
FROM txn_report_accrual_redemption 
WHERE TxnDate BETWEEN '2025-04-01' AND '2025-04-30'
AND storecode NOT IN ('Demo','ecom')
AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND insertiondate<'2025-05-05'
GROUP BY 1,2,3)a GROUP BY 1,2;

 
#### Online KPIs
-- Prev Year MBR Month #prev current month data like its march of 2025 and we extracting current month of 2024
SELECT TxnMonth, TxnYear,COUNT(membershipcardnumber)Transacting_Customers,
COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN membershipcardnumber END)OneTimer,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf=1 THEN membershipcardnumber END)New_Repeater,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf>1 THEN membershipcardnumber END)Old_Repeater,
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
SUM(sales)/COUNT(membershipcardnumber) AMV,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END)/COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN membershipcardnumber END) Onetimer_AMV,
SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END)/COUNT(DISTINCT CASE WHEN maxf>1 AND minf=1 THEN membershipcardnumber END) AS New_Repeat_AMV,
SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END)/COUNT(DISTINCT CASE WHEN maxf>1 AND minf>1 THEN membershipcardnumber END) AS Old_Repeat_AMV,
SUM(points_collected) AS Transaction_Points_issued,SUM(redeemed) AS Points_redeemed
FROM (SELECT membershipcardnumber, TxnMonth,TxnYear ,SUM(Amount) AS sales,COUNT(DISTINCT (UniqueBillNo)) AS bills,
MAX(frequencycount) AS maxf, MIN(frequencycount) AS minf,
SUM(pointscollected) AS Points_collected,SUM(pointsspent) AS Redeemed
FROM txn_report_accrual_redemption 
WHERE TxnDate BETWEEN '2024-04-01' AND '2024-04-30'
AND storecode ='ecom'
AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
GROUP BY 1,2,3)a GROUP BY 1,2
UNION
-- Prev Month MBR #prev month MBR mean the prev month from the current for ex its march so prev month was jan and current month is feb
SELECT TxnMonth, TxnYear,COUNT(membershipcardnumber)Transacting_Customers,
COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN membershipcardnumber END)OneTimer,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf=1 THEN membershipcardnumber END)New_Repeater,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf>1 THEN membershipcardnumber END)Old_Repeater,
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
SUM(sales)/COUNT(membershipcardnumber) AMV,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END)/COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN membershipcardnumber END) Onetimer_AMV,
SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END)/COUNT(DISTINCT CASE WHEN maxf>1 AND minf=1 THEN membershipcardnumber END) AS New_Repeat_AMV,
SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END)/COUNT(DISTINCT CASE WHEN maxf>1 AND minf>1 THEN membershipcardnumber END) AS Old_Repeat_AMV,
SUM(points_collected) AS Transaction_Points_issued,SUM(redeemed) AS Points_redeemed
FROM (SELECT membershipcardnumber, TxnMonth,TxnYear ,SUM(Amount) AS sales,COUNT(DISTINCT (UniqueBillNo)) AS bills,
MAX(frequencycount) AS maxf, MIN(frequencycount) AS minf,
SUM(pointscollected) AS Points_collected,SUM(pointsspent) AS Redeemed
FROM txn_report_accrual_redemption 
WHERE TxnDate BETWEEN '2025-03-01' AND '2025-03-31'
AND storecode ='ecom'
AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
GROUP BY 1,2,3)a GROUP BY 1,2
UNION
-- Current Month MBR #current month mean the like its mar and we take feb because we are looking for current month and current month is feb
SELECT TxnMonth, TxnYear,COUNT(membershipcardnumber)Transacting_Customers,
COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN membershipcardnumber END)OneTimer,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf=1 THEN membershipcardnumber END)New_Repeater,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf>1 THEN membershipcardnumber END)Old_Repeater,
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
SUM(sales)/COUNT(membershipcardnumber) AMV,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END)/COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN membershipcardnumber END) Onetimer_AMV,
SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END)/COUNT(DISTINCT CASE WHEN maxf>1 AND minf=1 THEN membershipcardnumber END) AS New_Repeat_AMV,
SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END)/COUNT(DISTINCT CASE WHEN maxf>1 AND minf>1 THEN membershipcardnumber END) AS Old_Repeat_AMV,
SUM(points_collected) AS Transaction_Points_issued,SUM(redeemed) AS Points_redeemed
FROM (SELECT membershipcardnumber, TxnMonth,TxnYear ,SUM(Amount) AS sales,COUNT(DISTINCT (UniqueBillNo)) AS bills,
MAX(frequencycount) AS maxf, MIN(frequencycount) AS minf,
SUM(pointscollected) AS Points_collected,SUM(pointsspent) AS Redeemed
FROM txn_report_accrual_redemption 
WHERE TxnDate BETWEEN '2025-04-01' AND '2025-04-30'
AND storecode ='ecom'
AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND insertiondate<'2025-05-05'
GROUP BY 1,2,3)a GROUP BY 1,2;


##############################################
####################################################################################################################

# Points data
-- Overall
SELECT MONTHNAME(txndate)mnth,"overall" AS store,
YEAR(txndate)YEAR,COUNT(DISTINCT membershipcardnumber)customer,
SUM(pointscollected)points_collected,SUM(pointsspent)points_reedemed,
COUNT(DISTINCT CASE WHEN pointsspent>0 THEN membershipcardnumber END) AS Redeemers,
COUNT(DISTINCT CASE WHEN pointsspent>0 THEN uniquebillno END)AS Redemption_Bills,
SUM(CASE WHEN pointsspent>0 THEN amount END ) AS Redemption_sales 
FROM txn_report_accrual_redemption 
WHERE storecode<>'demo' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND txndate BETWEEN '2025-03-01' AND '2025-04-30' AND insertiondate<'2025-05-05' GROUP BY 1;

-- Channelwise
SELECT MONTHNAME(txndate)mnth,CASE WHEN storecode='ecom' THEN "online" ELSE "offline" END AS store,
YEAR(txndate)YEAR,COUNT(DISTINCT membershipcardnumber)customer,
SUM(pointscollected)points_collected,SUM(pointsspent)points_reedemed,
COUNT(DISTINCT CASE WHEN pointsspent>0 THEN membershipcardnumber END) AS Redeemers,
COUNT(DISTINCT CASE WHEN pointsspent>0 THEN uniquebillno END)AS Redemption_Bills,
SUM(CASE WHEN pointsspent>0 THEN amount END ) AS Redemption_sales 
FROM txn_report_accrual_redemption 
WHERE storecode<>'demo' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND txndate BETWEEN '2025-03-01' AND '2025-04-30' AND insertiondate<'2025-05-05' GROUP BY 1,2;

-- Bonus Points
SELECT MONTHNAME(txndate)mnth,
YEAR(txndate)YEAR,COUNT(DISTINCT mobile)accrued_customer,
SUM(pointscollected)points_issued
FROM txn_report_flat_accrual 
WHERE storecode<>'demo' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND txndate BETWEEN '2025-03-01' AND '2025-04-30' AND insertiondate<'2025-05-05' GROUP BY 1;
 
-- Channel wise
SELECT MONTHNAME(txndate)mnth,CASE WHEN storecode='ecom' THEN "online" ELSE "offline" END AS store,
YEAR(txndate)YEAR,COUNT(DISTINCT mobile)accrued_customer,
SUM(pointscollected)points_issued
FROM txn_report_flat_accrual 
WHERE storecode<>'demo' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND txndate BETWEEN '2025-03-01' AND '2025-04-30' AND insertiondate<'2025-05-05' GROUP BY 1,2;

#################################################################################################################################
#################################################################################################################################

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
END AS ATV_band,COUNT(membershipcardnumber)AS customers,SUM(bills) AS bills,SUM(sales) AS sales
FROM (
SELECT membershipcardnumber,COUNT(DISTINCT uniquebillno) AS bills,SUM(amount) AS sales,
SUM(amount)/COUNT(DISTINCT uniquebillno) AS ATV
FROM `txn_report_accrual_redemption`
WHERE insertiondate< '2025-05-05'
AND txndate BETWEEN  '2025-03-01' AND '2025-04-30'
GROUP BY 1)a
GROUP BY 1
ORDER BY ATV;

####################################################################################################################

-- Tier wise Points Data 
SELECT tier,COUNT(membershipcardnumber),SUM(Points_collected),SUM(Points_Redeemed)
 FROM
(SELECT membershipcardnumber,tier,
SUM(a.pointscollected) AS Points_collected,SUM(a.pointsspent) AS Points_Redeemed, MAX(frequencycount) AS max_fc
FROM `txn_report_accrual_redemption` a JOIN member_report b  ON a.membershipcardnumber=b.membershipno
WHERE a.insertiondate< '2025-05-05'
AND txndate BETWEEN  '2025-04-01' AND '2025-04-30'
AND modifiedbillno NOT LIKE '%brn%'
AND modifiedbillno NOT LIKE '%roll%' AND storecode NOT LIKE '%demo%'
GROUP BY 1)c
GROUP BY 1;

-- tier wise coupon data
SELECT TIER, MONTH(issueddate), COUNT(*)Issued
FROM coupon_offer_report 
WHERE issueddate BETWEEN '2025-03-01' AND '2025-03-31' 
AND issuedstore<>'demo'
GROUP BY 1,2;

SELECT tier,
MONTH(useddate),COUNT(DISTINCT issuedmobile)Redeemers, 
COUNT(couponcode)CouponsRedeemed, SUM(amount)RedemptionSale, 
COUNT(DISTINCT billno) redemptionbills, SUM(discount)discount 
FROM coupon_offer_report 
WHERE useddate BETWEEN '2025-03-01' AND '2025-03-31' AND couponstatus = 'Used' 
AND redeemedstorecode<>'demo' 
GROUP BY 1
,2
; 
-- Bonus points
-- SELECT tier,COUNT(membershipno),SUM(Points_collected),SUM(Points_Redeemed) FROM
-- (SELECT membershipno,tier,
-- SUM(a.pointscollected) AS Points_collected,SUM(a.pointsspent) AS Points_Redeemed
-- FROM `txn_report_Flat_accrual` a JOIN member_report b  ON a.customerid=b.storecustomerid
-- WHERE a.insertiondate< '2024-09-02'
-- AND txndate BETWEEN  '2024-08-01' AND '2024-08-31'
-- AND modifiedbillno NOT LIKE '%brn%'
-- AND modifiedbillno NOT LIKE '%roll%' AND storecode NOT LIKE '%demo%'
-- GROUP BY 1)c
-- GROUP BY 1;

##################

CREATE TABLE dummy.FE_segment_apr25_Sanket
SELECT membershipcardnumber,MAX(frequencycount)FCOverall,
DATEDIFF('2025-04-30',MAX(txndate))Recency
FROM `forestessentials`.txn_report_accrual_redemption
WHERE txndate <='2025-04-30'
GROUP BY 1; -- 

CREATE TABLE dummy.FE_segment_apr24_Sanket
SELECT membershipcardnumber,MAX(frequencycount)FCOverall,
DATEDIFF('2024-04-30',MAX(txndate))Recency
FROM `forestessentials`.txn_report_accrual_redemption
WHERE txndate <='2024-04-30'
GROUP BY 1; --

ALTER TABLE dummy.FE_segment_apr24_Sanket ADD COLUMN 2024_lifecycle VARCHAR(20);


UPDATE dummy.FE_segment_apr24_Sanket SET 2024_lifecycle=
CASE WHEN recency BETWEEN 0 AND 90 THEN "active"
WHEN recency BETWEEN 91 AND 180 THEN "dormant"
WHEN recency BETWEEN 181 AND 365 THEN "Recently Lapsed"
WHEN recency > 365 THEN "Long Lapsed"
END; -- 

ALTER TABLE dummy.FE_segment_apr25_Sanket ADD COLUMN 2025_lifecycle VARCHAR(20);

UPDATE dummy.FE_segment_apr25_Sanket SET 2025_lifecycle=
CASE WHEN recency BETWEEN 0 AND 90 THEN "Active"
WHEN recency BETWEEN 91 AND 180 THEN "Dormant"
WHEN recency BETWEEN 181 AND 365 THEN "Recently Lapsed"
WHEN recency > 365 THEN "Long Lapsed"
END;

SELECT 2024_lifecycle, COUNT(membershipcardnumber) AS customers FROM dummy.FE_segment_apr24_Sanket GROUP BY 1;
SELECT 2025_lifecycle, COUNT(membershipcardnumber) AS customers FROM dummy.FE_segment_apr25_Sanket GROUP BY 1;

-- Bonus Points

SELECT 
    MONTHNAME(txndate) AS MONTH,
    SUM(CASE WHEN narration='Bronze Milestone Points' THEN pointscollected ELSE 0 END) AS Bronze_milestone,
    SUM(CASE WHEN narration='Silver Milestone Points' THEN pointscollected ELSE 0 END) AS Silver_milestone,
    SUM(CASE WHEN narration='Gold Milestone Points' THEN pointscollected ELSE 0 END) AS Gold_milestone,
    SUM(CASE WHEN narration='Platinum Milestone Points' THEN pointscollected ELSE 0 END) AS Platinum_milestone,
    SUM(CASE WHEN narration='250 Bronze Points' THEN pointscollected ELSE 0 END) AS Bronse_Bday_points,
    SUM(CASE WHEN narration='500 silver Points' THEN pointscollected ELSE 0 END) AS Silver_Bday_points,
    SUM(CASE WHEN narration='750 GOLD Points' THEN pointscollected ELSE 0 END) AS Gold_Bday_points,
    SUM(CASE WHEN narration='1100 Points' THEN pointscollected ELSE 0 END) AS Platinum_Bday_points
FROM 
    txn_report_flat_accrual
WHERE  
    storecode <> 'demo' 
    AND billno NOT LIKE '%test%' 
    AND billno NOT LIKE '%roll%'
    AND txndate BETWEEN '2025-01-01' AND '2025-02-28' 
    AND insertiondate < '2025-02-28' 
GROUP BY 
    MONTHNAME(txndate)
ORDER BY 
    MIN(txndate);
    
## Coupon Data
-- -- Overall Coupon Data
-- 	SELECT 
-- -- 	CASE WHEN redeemedstorecode='ecom' THEN "online" ELSE "offline" END AS storetype,
-- 	COUNT(*)Issued,COUNT(DISTINCT CASE WHEN couponstatus='Used' AND useddate BETWEEN '2024-10-30' AND '2024-11-20' THEN issuedmobile END)Redeemers,
-- 	COUNT(DISTINCT CASE WHEN couponstatus='Used' AND useddate BETWEEN '2024-10-30' AND '2024-11-20' THEN couponcode END)CouponsRedeemed,
-- 	SUM(CASE WHEN couponstatus='Used' AND useddate BETWEEN '2024-10-30' AND '2024-11-20' THEN b.amount END)RedemtionSale,
-- 	COUNT(CASE WHEN couponstatus='Used' AND useddate BETWEEN '2024-10-30' AND '2024-11-20' THEN modifiedbillno END) redemptionbills, 
-- 	SUM(CASE WHEN couponstatus='Used' AND useddate BETWEEN '2024-10-30' AND '2024-11-20' THEN discount END)disc 
-- 		FROM coupon_offer_report a LEFT JOIN txn_Report_accrual_Redemption b ON a.billno=b.modifiedbillno WHERE issueddate BETWEEN '2024-10-30' AND '2024-11-20'
-- 	AND redeemedstorecode<>'demo'
-- 	-- GROUP BY 1
-- 	;

-- Overall Coupon Data
	SELECT 
	CASE WHEN redeemedstorecode='ecom' THEN "online" ELSE "offline" END AS storetype,
	COUNT(DISTINCT CASE WHEN couponstatus='Used' THEN issuedmobile END)Redeemers,
	COUNT(DISTINCT CASE WHEN couponstatus='Used' THEN couponcode END)CouponsRedeemed,
	SUM(CASE WHEN couponstatus='Used' THEN b.amount END)RedemtionSale,
	COUNT(CASE WHEN couponstatus='Used' THEN modifiedbillno END) redemptionbills, 
	SUM(CASE WHEN couponstatus='Used' THEN discount END)disc 
		FROM coupon_offer_report a LEFT JOIN txn_Report_accrual_Redemption b ON a.billno=b.modifiedbillno
		WHERE useddate BETWEEN '2025-03-01' AND '2025-03-31'
	AND redeemedstorecode<>'demo'
	GROUP BY 1
	;
-- 	issued data 
	SELECT 
-- 	CASE WHEN IssuedStore='ecom' THEN "online" ELSE "offline" END AS storetype,
	COUNT(*)issued FROM coupon_offer_report 
		WHERE issueddate BETWEEN '2025-04-01' AND '2025-04-30'
	AND issuedstore<>'demo'
-- 	group by 1
	;

   -- ################################
-- -- Unwanted Data
 
-- SELECT COUNT FROM txn_report_flat_accrual WHERE mobile='';
-- 
-- SELECT txndate,b.mobile,pointscollected,narration,membershipno FROM txn_report_flat_accrual  a LEFT JOIN member_report b
-- ON a.customerid=b.storecustomerid
-- WHERE pointscollected>0 ORDER BY txndate ASC LIMIT 700000 OFFSET 500001;
--  
-- SELECT * FROM member_report;

#############################################################################################################################################
-- ALTER TABLE dummy.FE_segment_May24_Sanket ADD INDEX mb(membershipcardnumber);
-- ALTER TABLE dummy.FE_segment_May24_Sanket ADD COLUMN(Segment1 VARCHAR(20),Segment2 VARCHAR(20), fcYear INT);
-- UPDATE dummy.FE_segment_May24_Sanket a JOIN(
-- SELECT membershipcardnumber,COUNT(DISTINCT txndate)fcyear
-- FROM `forestessentials`.txn_report_accrual_redemption
-- WHERE txndate BETWEEN '2024-05-31' - INTERVAL 1 YEAR AND '2024-05-31'
-- GROUP BY 1)b USING(membershipcardnumber)
-- SET a.fcyear=b.fcyear; -- 236199
-- 
-- 
-- UPDATE dummy.FE_segment_May24_Sanket
-- SET Segment1=
-- CASE
-- WHEN recency<=365 AND FCOverall=1 THEN 'New'
-- WHEN recency<= 182  AND FCyear<3 THEN 'Grow'
-- WHEN recency<= 182  AND FCyear>=3 THEN 'Stable'
-- WHEN recency BETWEEN 183 AND 365 AND FCOverall>=2 THEN 'Declining'
-- WHEN recency BETWEEN 366 AND 1095 THEN 'Lapsed'
-- WHEN recency>1095 THEN 'Dormant' END;
-- 
-- UPDATE dummy.FE_segment_May24_Sanket
-- SET Segment2=
-- CASE
-- WHEN recency<=365 AND FCOverall=1 THEN 'New'
-- WHEN recency<= 182  AND FCyear<4 THEN 'Grow'
-- WHEN recency<= 182  AND FCyear>=4 THEN 'Stable'
-- WHEN recency BETWEEN 183 AND 365 AND FCOverall>=2 THEN 'Declining'
-- WHEN recency BETWEEN 366 AND 1095 THEN 'Lapsed'
-- WHEN recency>1095 THEN 'Dormant' END;
-- 
-- 
-- SELECT segment2,COUNT(membershipcardnumber) AS customers FROM dummy.FE_segment_May24_Sanket GROUP BY 1;
-- 
-- -- Segment 3
-- SELECT 
-- CASE
-- WHEN recency<=365 AND FCOverall=1 THEN 'New'
-- WHEN recency<= 120  AND FCyear<3 THEN 'Grow'
-- WHEN recency<= 120  AND FCyear>=3 THEN 'Stable'
-- WHEN recency BETWEEN 121 AND 365 AND FCOverall>=2 THEN 'Declining'
-- WHEN recency BETWEEN 366 AND 1095 THEN 'Lapsed'
-- WHEN recency>1095 THEN 'Dormant' END AS segment3, COUNT(membershipcardnumber) AS cust
-- FROM dummy.FE_segment_May24_Sanket GROUP BY 1;
-- 
-- -- Segment 4
-- SELECT CASE
-- WHEN recency<=365 AND FCOverall=1 THEN 'New'
-- WHEN recency<= 120  AND FCyear<4 THEN 'Grow'
-- WHEN recency<= 120  AND FCyear>=4 THEN 'Stable'
-- WHEN recency BETWEEN 121 AND 365 AND FCOverall>=2 THEN 'Declining'
-- WHEN recency BETWEEN 366 AND 1095 THEN 'Lapsed'
-- WHEN recency>1095 THEN 'Dormant' END AS segment4, COUNT(membershipcardnumber) AS cust
-- FROM dummy.FE_segment_May24_Sanket GROUP BY 1;
-- 
-- -- Segment 5
-- SELECT CASE
-- WHEN recency<=365 AND FCOverall=1 THEN 'New'
-- WHEN recency<= 90  AND FCyear<3 THEN 'Grow'
-- WHEN recency<= 90  AND FCyear>=3 THEN 'Stable'
-- WHEN recency BETWEEN 91 AND 365 AND FCOverall>=2 THEN 'Declining'
-- WHEN recency BETWEEN 366 AND 1095 THEN 'Lapsed'
-- WHEN recency>1095 THEN 'Dormant' END AS segment5, COUNT(membershipcardnumber) AS cust
-- FROM dummy.FE_segment_May24_Sanket GROUP BY 1;
-- 
-- -- Segment 6
-- SELECT
-- CASE
-- WHEN recency<=365 AND FCOverall=1 THEN 'New'
-- WHEN recency<= 90  AND FCyear<4 THEN 'Grow'
-- WHEN recency<= 90  AND FCyear>=4 THEN 'Stable'
-- WHEN recency BETWEEN 91 AND 365 AND FCOverall>=2 THEN 'Declining'
-- WHEN recency BETWEEN 366 AND 1095 THEN 'Lapsed'
-- WHEN recency>1095 THEN 'Dormant' END AS segment6, COUNT(membershipcardnumber) AS cust
-- FROM dummy.FE_segment_May24_Sanket GROUP BY 1;

