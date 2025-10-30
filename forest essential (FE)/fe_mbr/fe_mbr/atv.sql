SET @insertiondate=CURDATE();
SET @MBRstartdate=DATE_SUB(((@insertiondate-INTERVAL 30 DAY)),INTERVAL DAYOFMONTH((@insertiondate-INTERVAL 30 DAY))-1 DAY),@MBRenddate=LAST_DAY(@insertiondate-INTERVAL 30 DAY);
SET @MBRPREVStartDate=DATE_SUB(@MBRstartdate,INTERVAL DAYOFMONTH(@MBRstartdate - INTERVAL 1 DAY) DAY);
SET @MBRPREVEndDate=LAST_DAY(@MBRPREVStartDate);
SET @MBRPREVYearStartDate=@MBRstartdate- INTERVAL 1 YEAR;
SET @MBRPREVYearEndDate=LAST_DAY(@MBRstartdate- INTERVAL 1 YEAR);



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
WHERE insertiondate<CURDATE()
AND txndate BETWEEN  @MBRstartdate AND @MBRenddate
AND storecode<>'demo' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
GROUP BY 1)a
GROUP BY 1
ORDER BY ATV;

