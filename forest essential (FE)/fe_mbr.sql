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






-- QC
SELECT CONCAT(MONTHNAME(modifiedenrolledon),YEAR(modifiedenrolledon)) AS PERIOD,
COUNT(DISTINCT CASE WHEN enrolledstorecode = 'ECOM' THEN membershipno END) AS 'ECOM',
COUNT(DISTINCT CASE WHEN enrolledstorecode <> 'ECOM' THEN membershipno END) AS 'OFFLINE',
COUNT(DISTINCT membershipno) AS Over_All 
FROM `forestessentials`.member_report 
WHERE enrolledstorecode NOT LIKE '%demo%'
AND modifiedenrolledon BETWEEN  '2024-07-01' AND '2024-07-31'
AND insertiondate<'2025-08-04';




####################################################################################################################

-- Overall
#### KPIs
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
WHERE TxnDate BETWEEN '2024-07-01' AND '2024-07-31'
AND storecode NOT LIKE '%demo%' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND amount>0
GROUP BY 1,2,3)a GROUP BY 1,2
UNION
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
WHERE TxnDate BETWEEN '2025-06-01' AND '2025-06-30'
AND storecode NOT LIKE '%demo%' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND amount>0
GROUP BY 1,2,3)a GROUP BY 1,2
UNION
SELECT TxnMonth, TxnYear,COUNT(membershipcardnumber)Transacting_Customers,
COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN membershipcardnumber END)OneTimer,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf=1 THEN membershipcardnumber END)New_Repeater,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf>1 THEN membershipcardnumber END)Old_Repeater,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END) AS onetimer_Sales,
SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END) AS New_Repeat_Sales,
SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END) AS Old_Repeat_Sales,SUM(sales)sales,
SUM(CASE WHEN maxf=1 AND minf=1 THEN bills END) AS onetimer_Bills,
SUM(CASE WHEN maxf>1 AND minf=1 THEN bills END) AS New_Repeat_Bills,
SUM(CASE WHEN maxf>1 AND minf>1 THEN bills END) AS Old_Repeat_Bills,
SUM(bills) AS bills,
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
WHERE TxnDate BETWEEN '2025-07-01' AND '2025-07-31'
AND storecode NOT LIKE '%demo%' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND amount>0
AND insertiondate<'2025-08-04'
GROUP BY 1,2,3)a GROUP BY 1,2;




-- QC



SELECT TxnMonth, TxnYear,COUNT(membershipcardnumber)Transacting_Customers,
COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN membershipcardnumber END)OneTimer,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf=1 THEN membershipcardnumber END)New_Repeater,
COUNT(DISTINCT CASE WHEN maxf>1 AND minf>1 THEN membershipcardnumber END)Old_Repeater,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END) AS onetimer_Sales,
SUM(CASE WHEN maxf>1 AND minf=1 THEN sales END) AS New_Repeat_Sales,
SUM(CASE WHEN maxf>1 AND minf>1 THEN sales END) AS Old_Repeat_Sales,SUM(sales)sales,
SUM(CASE WHEN maxf=1 AND minf=1 THEN bills END) AS onetimer_Bills,
SUM(CASE WHEN maxf>1 AND minf=1 THEN bills END) AS New_Repeat_Bills,
SUM(CASE WHEN maxf>1 AND minf>1 THEN bills END) AS Old_Repeat_Bills,
SUM(bills) AS bills,
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
WHERE TxnDate BETWEEN '2025-07-01' AND '2025-07-31'
AND storecode NOT LIKE '%demo%' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND insertiondate<'2025-08-04'
GROUP BY 1,2,3)a
GROUP BY 1,2;

SELECT
SUM(CASE WHEN minf=1 AND maxf=1 THEN sales END )one_timer_sales,
SUM(CASE WHEN minf=1 AND maxf>1 THEN sales END )new_repeater_sales,
SUM(CASE WHEN minf>1 THEN sales END )old_repeater_sales, 
SUM(sales)sales,
SUM(CASE WHEN minf=1 AND maxf=1 THEN bills END )one_timer_bills,
SUM(CASE WHEN minf=1 AND maxf>1 THEN bills END )new_repeater_bills,
SUM(CASE WHEN minf>1 THEN bills END )old_repeater_bills,
SUM(bills)bills FROM (
SELECT membershipcardnumber,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills,
MAX(frequencycount) AS maxf, MIN(frequencycount) AS minf 
FROM txn_report_accrual_redemption 
WHERE TxnDate BETWEEN '2025-07-01' AND '2025-07-31'
AND storecode NOT LIKE '%demo%' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%' 
-- and amount>0
AND insertiondate<'2025-08-04'
GROUP BY 1)a
;
################################################################################################################
################################################################################################################

-- Channelwise 

#### Offline KPIs
-- Prev Year MBR Month
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
WHERE TxnDate BETWEEN '2024-07-01' AND '2024-07-31'
AND storecode NOT IN ('Demo','ecom')
AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%' AND amount>0
GROUP BY 1,2,3)a GROUP BY 1,2
UNION
-- Prev Month MBR
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
WHERE TxnDate BETWEEN '2025-06-01' AND '2025-06-30'
AND storecode NOT IN ('Demo','ecom')
AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%' AND amount>0
GROUP BY 1,2,3)a GROUP BY 1,2
UNION
-- Current Month MBR
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
WHERE TxnDate BETWEEN '2025-07-01' AND '2025-07-31'
AND storecode NOT IN ('Demo','ecom')
AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%' AND amount>0
AND insertiondate<'2025-08-04'
GROUP BY 1,2,3)a GROUP BY 1,2;

-- QC
SELECT SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills 
FROM txn_report_accrual_redemption 
WHERE TxnDate BETWEEN '2024-07-01' AND '2024-07-31'
AND storecode NOT IN ('Demo','ecom')
AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%' AND amount>0
AND insertiondate<'2025-08-04';

 
#### Online KPIs
-- Prev Year MBR Month
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
WHERE TxnDate BETWEEN '2024-07-01' AND '2024-07-31'
AND storecode ='ecom'
AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%' AND amount>0
GROUP BY 1,2,3)a GROUP BY 1,2
UNION
-- Prev Month MBR
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
WHERE TxnDate BETWEEN '2025-06-01' AND '2025-06-30'
AND storecode ='ecom'
AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%' AND amount>0
GROUP BY 1,2,3)a GROUP BY 1,2
UNION
-- Current Month MBR
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
WHERE TxnDate BETWEEN '2025-07-01' AND '2025-07-31'
AND storecode ='ecom'
AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%' AND amount>0
AND insertiondate<'2025-08-04'
GROUP BY 1,2,3)a GROUP BY 1,2;



-- QC
SELECT SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills 
FROM txn_report_accrual_redemption 
WHERE TxnDate BETWEEN '2024-07-01' AND '2024-07-31'
AND storecode ='ecom'
AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%' AND amount>0
AND insertiondate<'2025-08-04';

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
AND amount>0
AND txndate BETWEEN '2025-06-01' AND '2025-07-31' AND insertiondate<'2025-08-04' GROUP BY 1;

-- Channelwise
SELECT MONTHNAME(txndate)mnth,CASE WHEN storecode='ecom' THEN "online" ELSE "offline" END AS store,
YEAR(txndate)YEAR,COUNT(DISTINCT membershipcardnumber)customer,
SUM(pointscollected)points_collected,SUM(pointsspent)points_reedemed,
COUNT(DISTINCT CASE WHEN pointsspent>0 THEN membershipcardnumber END) AS Redeemers,
COUNT(DISTINCT CASE WHEN pointsspent>0 THEN uniquebillno END)AS Redemption_Bills,
SUM(CASE WHEN pointsspent>0 THEN amount END ) AS Redemption_sales 
FROM txn_report_accrual_redemption 
WHERE storecode<>'demo' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND amount>0
AND txndate BETWEEN '2025-06-01' AND '2025-07-31' AND insertiondate<'2025-08-04' GROUP BY 1,2;

-- Bonus Points
SELECT MONTHNAME(txndate)mnth,
YEAR(txndate)YEAR,COUNT(DISTINCT mobile)accrued_customer,
SUM(pointscollected)points_issued
FROM txn_report_flat_accrual 
WHERE storecode<>'demo' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
-- AND amount>0
AND txndate BETWEEN '2025-06-01' AND '2025-07-31' AND insertiondate<'2025-08-04' GROUP BY 1;



 
-- Channel wise
SELECT MONTHNAME(txndate)mnth,CASE WHEN storecode='ecom' THEN "online" ELSE "offline" END AS store,
YEAR(txndate)YEAR,COUNT(DISTINCT mobile)accrued_customer,
SUM(pointscollected)points_issued
FROM txn_report_flat_accrual 
WHERE storecode<>'demo' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
-- AND amount>0
AND txndate BETWEEN '2025-06-01' AND '2025-07-31' AND insertiondate<'2025-08-04' GROUP BY 1,2;


SELECT COUNT(DISTINCT mobile)accrued_customer,SUM(pointscollected)points_issued
FROM txn_report_flat_accrual WHERE txndate BETWEEN '2025-06-01' AND '2025-07-31' 
AND storecode<>'demo' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%' 
AND insertiondate<'2025-08-04';


#################################################################################################################################
#################################################################################################################################
    
-- ATV Band 
SELECT CASE WHEN ATV <=1500 THEN 'upto 1500'
WHEN ATV > 1500 AND atv <= 3000 THEN '1500-3000'
WHEN ATV > 3000 AND atv <= 4500 THEN '3001-4500'
WHEN ATV > 4500 AND atv <= 6000 THEN '4501-6000'
WHEN ATV > 6000 AND atv <= 7500 THEN '6001-7500'
WHEN ATV > 7500 AND atv <= 9000 THEN '7501-9000'
WHEN ATV > 9000 AND atv <= 10500 THEN '9001-10500'
WHEN ATV > 10500 AND atv <= 12000 THEN '10501-12000'
WHEN ATV > 12000 THEN 'more than 12000'
END AS ATV_band,COUNT(membershipcardnumber)AS customers,SUM(bills) AS bills,SUM(sales) AS sales
FROM (
SELECT membershipcardnumber,COUNT(DISTINCT uniquebillno) AS bills,SUM(amount) AS sales,
SUM(amount)/COUNT(DISTINCT uniquebillno) AS ATV
FROM `txn_report_accrual_redemption`
WHERE insertiondate< '2025-08-04'
AND txndate BETWEEN  '2025-07-01' AND '2025-07-31'
AND storecode<>'demo' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%' AND amount>0
GROUP BY 1)a
GROUP BY 1
ORDER BY ATV;

#######

-- Overall Coupon Data

SELECT 
--  CASE WHEN issuedstore='ecom' THEN "online" ELSE "offline" END AS storetype,
MONTHNAME(issueddate), COUNT(*)Issued
FROM coupon_offer_report 
WHERE issueddate BETWEEN '2025-06-01' AND '2025-07-31' 
AND issuedstore<>'demo'
GROUP BY 1
,2
;



SELECT 
--  CASE WHEN redeemedstorecode='ecom' THEN "online" ELSE "offline" END AS storetype,
MONTHNAME(useddate),
COUNT(DISTINCT issuedmobile)Redeemers, 
COUNT(couponcode)CouponsRedeemed, SUM(b.amount)RedemptionSale, 
COUNT(modifiedbillno) redemptionbills, SUM(discount)discount 
FROM coupon_offer_report a JOIN txn_Report_accrual_Redemption b ON a.billno=b.modifiedbillno 
WHERE useddate BETWEEN '2025-06-01' AND '2025-07-31' AND couponstatus = 'Used'  
AND redeemedstorecode<>'demo' 
GROUP BY 1
,2
; 





-- Tier wise Points Data 
SELECT tier,COUNT(membershipcardnumber),SUM(Points_collected),SUM(Points_Redeemed)
 FROM
(SELECT membershipcardnumber,tier,
SUM(a.pointscollected) AS Points_collected,SUM(a.pointsspent) AS Points_Redeemed, MAX(frequencycount) AS max_fc
FROM `txn_report_accrual_redemption` a JOIN member_report b  ON a.membershipcardnumber=b.membershipno
WHERE a.insertiondate< '2025-08-04'
AND txndate BETWEEN  '2025-07-01' AND '2025-07-31'
AND modifiedbillno NOT LIKE '%brn%'
AND modifiedbillno NOT LIKE '%roll%' AND storecode NOT LIKE '%demo%'
GROUP BY 1)c
GROUP BY 1;

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


CREATE TABLE dummy.FE_segment_july_25
SELECT membershipcardnumber,MAX(frequencycount)FCOverall,
DATEDIFF('2025-07-31',MAX(txndate))Recency
FROM `forestessentials`.txn_report_accrual_redemption
WHERE txndate <='2025-07-31' 
AND billno NOT LIKE '%brn%'
AND billno NOT LIKE '%roll%' AND storecode NOT LIKE '%demo%'
AND amount>0 AND 1=0
GROUP BY 1;#410797

INSERT INTO dummy.FE_segment_july_24
SELECT membershipcardnumber,MAX(frequencycount)FCOverall,
DATEDIFF('2024-07-31',MAX(txndate))Recency
FROM `forestessentials`.txn_report_accrual_redemption
WHERE txndate <='2024-07-31'
AND billno NOT LIKE '%brn%'
AND billno NOT LIKE '%roll%' AND storecode NOT LIKE '%demo%'
AND amount>0
GROUP BY 1;#332866

ALTER TABLE dummy.FE_segment_july_24 ADD COLUMN 2024_lifecycle VARCHAR(20);

UPDATE dummy.FE_segment_july_24 SET 2024_lifecycle=
CASE WHEN recency BETWEEN 0 AND 90 THEN "active"
WHEN recency BETWEEN 91 AND 180 THEN "dormant"
WHEN recency BETWEEN 181 AND 365 THEN "Recently Lapsed"
WHEN recency > 365 THEN "Long Lapsed"
END; #332866

ALTER TABLE dummy.FE_segment_july_25 ADD COLUMN 2025_lifecycle VARCHAR(20);
UPDATE dummy.FE_segment_july_25 SET 2025_lifecycle=
CASE WHEN recency BETWEEN 0 AND 90 THEN "Active"
WHEN recency BETWEEN 91 AND 180 THEN "Dormant"
WHEN recency BETWEEN 181 AND 365 THEN "Recently Lapsed"
WHEN recency > 365 THEN "Long Lapsed"
END;#410797

SELECT * FROM dummy.FE_segment_july_24
SELECT 2024_lifecycle, COUNT(membershipcardnumber) AS customers FROM dummy.FE_segment_july_24 GROUP BY 1;
SELECT 2025_lifecycle, COUNT(membershipcardnumber) AS customers FROM dummy.FE_segment_july_25 GROUP BY 1;



-- Overall Coupon Data
	SELECT 
--  	CASE WHEN redeemedstorecode='ecom' THEN "online" ELSE "offline" END AS storetype,
	COUNT(*)Issued,COUNT(DISTINCT CASE WHEN couponstatus='Used' THEN issuedmobile END)Redeemers,
	COUNT(DISTINCT CASE WHEN couponstatus='Used' THEN couponcode END)CouponsRedeemed,
	SUM(CASE WHEN couponstatus='Used' THEN b.amount END)RedemtionSale,
	COUNT(CASE WHEN couponstatus='Used' THEN modifiedbillno END) redemptionbills, 
	SUM(CASE WHEN couponstatus='Used' THEN discount END)disc 
		FROM coupon_offer_report a LEFT JOIN txn_Report_accrual_Redemption b ON a.billno=b.modifiedbillno WHERE usedate BETWEEN '2024-12-01' AND '2025-01-31'
	AND redeemedstorecode<>'demo'
-- 	 GROUP BY 1
	;
``	
	
SELECT 
b.Tier,
#CASE WHEN issuedstore='ecom' THEN "online" ELSE "offline" END AS storetype,
MONTH(issueddate), COUNT(*)Issued
FROM coupon_offer_report a JOIN member_report b ON a.issuedmobile=b.mobile
WHERE issueddate BETWEEN '2025-07-01' AND '2025-07-31' 
AND issuedstore<>'demo'
GROUP BY 1
-- ,2
;
	
	
	
	




-- -- Overall Coupon Data
-- 
-- SELECT 
-- -- CASE WHEN issuedstore='ecom' THEN "online" ELSE "offline" END AS storetype,
-- MONTH(issueddate), COUNT(*)Issued
-- FROM coupon_offer_report 
-- WHERE issueddate BETWEEN '2025-04-01' AND '2025-04-30' 
-- AND issuedstore<>'demo'
-- GROUP BY 1
-- -- ,2
-- ;
-- 
-- SELECT 
-- -- CASE WHEN redeemedstorecode='ecom' THEN "online" ELSE "offline" END AS storetype,
-- MONTH(useddate),COUNT(DISTINCT issuedmobile)Redeemers, 
-- COUNT(couponcode)CouponsRedeemed, SUM(b.amount)RedemptionSale, 
-- COUNT(modifiedbillno) redemptionbills, SUM(discount)discount 
-- FROM coupon_offer_report a JOIN txn_Report_accrual_Redemption b ON a.billno=b.modifiedbillno 
-- WHERE useddate BETWEEN '2025-01-01' AND '2025-02-28' AND couponstatus = 'Used' 
-- AND redeemedstorecode<>'demo' 
-- GROUP BY 1
-- -- ,2
-- ; 

-- tier wise coupon data
SELECT TIER, MONTH(issueddate), COUNT(*)Issued
FROM coupon_offer_report 
WHERE issueddate BETWEEN '2025-07-01' AND '2025-07-31' 
AND issuedstore<>'demo'
GROUP BY 1,2;

SELECT tier,
MONTH(useddate),COUNT(DISTINCT issuedmobile)Redeemers, 
COUNT(couponcode)CouponsRedeemed, SUM(amount)RedemptionSale, 
COUNT(DISTINCT billno) redemptionbills, SUM(discount)discount 
FROM coupon_offer_report 
WHERE useddate BETWEEN '2025-07-01' AND '2025-07-31'
 AND couponstatus = 'Used' 
AND redeemedstorecode<>'demo' 
AND insertiondate<='2025-08-04' AND amount>0
GROUP BY 1
,2
; 
