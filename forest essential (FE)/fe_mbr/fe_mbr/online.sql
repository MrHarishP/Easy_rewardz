SET @insertiondate=CURDATE();
SET @MBRstartdate=DATE_SUB(((@insertiondate-INTERVAL 30 DAY)),INTERVAL DAYOFMONTH((@insertiondate-INTERVAL 30 DAY))-1 DAY),@MBRenddate=LAST_DAY(@insertiondate-INTERVAL 30 DAY);
SET @MBRPREVStartDate=DATE_SUB(@MBRstartdate,INTERVAL DAYOFMONTH(@MBRstartdate - INTERVAL 1 DAY) DAY);
SET @MBRPREVEndDate=LAST_DAY(@MBRPREVStartDate);
SET @MBRPREVYearStartDate=@MBRstartdate- INTERVAL 1 YEAR;
SET @MBRPREVYearEndDate=LAST_DAY(@MBRstartdate- INTERVAL 1 YEAR);

SELECT @MBRstartdate,@MBRenddate,@insertiondate, @MBRPREVStartDate,@MBRPREVEndDate,@MBRPREVYearStartDate,@MBRPREVYearEndDate;



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
WHERE TxnDate BETWEEN @MBRPREVYearStartDate AND @MBRPREVYearEndDate
AND storecode ='ecom'
AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
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
WHERE TxnDate BETWEEN @MBRPREVStartDate AND @MBRPREVEndDate
AND storecode ='ecom'
AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
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
WHERE TxnDate BETWEEN @MBRstartdate AND @MBRenddate
AND storecode ='ecom'
AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND insertiondate<@insertiondate
GROUP BY 1,2,3)a GROUP BY 1,2;



SELECT COUNT(DISTINCT membershipcardnumber)customer,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills 
FROM txn_report_accrual_redemption 
WHERE TxnDate BETWEEN '2025-08-01' AND '2025-08-31'
AND storecode ='ecom'
AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND insertiondate<CURDATE();