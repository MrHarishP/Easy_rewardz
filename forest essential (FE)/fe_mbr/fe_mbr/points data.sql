SET @insertiondate=CURDATE();
SET @MBRstartdate=DATE_SUB(((@insertiondate-INTERVAL 30 DAY)),INTERVAL DAYOFMONTH((@insertiondate-INTERVAL 30 DAY))-1 DAY),@MBRenddate=LAST_DAY(@insertiondate-INTERVAL 30 DAY);
SET @MBRPREVStartDate=DATE_SUB(@MBRstartdate,INTERVAL DAYOFMONTH(@MBRstartdate - INTERVAL 1 DAY) DAY);
SET @MBRPREVEndDate=LAST_DAY(@MBRPREVStartDate);
SET @MBRPREVYearStartDate=@MBRstartdate- INTERVAL 1 YEAR;
SET @MBRPREVYearEndDate=LAST_DAY(@MBRstartdate- INTERVAL 1 YEAR);



# Points data
-- Overall
SELECT 
MONTHNAME(txndate)mnth,
"overall" AS store,
YEAR(txndate)YEAR,
COUNT(DISTINCT membershipcardnumber)customer,
SUM(pointscollected)points_collected,
SUM(pointsspent)points_reedemed,
COUNT(DISTINCT CASE WHEN pointsspent>0 THEN membershipcardnumber END) AS Redeemers,
COUNT(DISTINCT CASE WHEN pointsspent>0 THEN uniquebillno END)AS Redemption_Bills,
SUM(CASE WHEN pointsspent>0 THEN amount END ) AS Redemption_sales 
FROM txn_report_accrual_redemption 
WHERE storecode<>'demo' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND txndate BETWEEN @MBRPREVStartDate AND @MBRenddate AND insertiondate<CURDATE() GROUP BY 1;




-- Channelwise

SELECT 
MONTHNAME(txndate)mnth,
CASE WHEN storecode='ecom' THEN "online" ELSE "offline" END AS store,
YEAR(txndate)YEAR,
COUNT(DISTINCT membershipcardnumber)customer,
SUM(pointscollected)points_collected,
SUM(pointsspent)points_reedemed,
COUNT(DISTINCT CASE WHEN pointsspent>0 THEN membershipcardnumber END) AS Redeemers,
COUNT(DISTINCT CASE WHEN pointsspent>0 THEN uniquebillno END)AS Redemption_Bills,
SUM(CASE WHEN pointsspent>0 THEN amount END ) AS Redemption_sales 
FROM txn_report_accrual_redemption 
WHERE storecode<>'demo' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND txndate BETWEEN @MBRPREVStartDate AND @MBRenddate AND insertiondate<CURDATE() 
GROUP BY 1,2;



-- Bonus Points
SELECT MONTHNAME(txndate)mnth,
YEAR(txndate)YEAR,COUNT(DISTINCT mobile)accrued_customer,
SUM(pointscollected)points_issued
FROM txn_report_flat_accrual 
WHERE storecode<>'demo' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND txndate  BETWEEN @MBRPREVStartDate AND @MBRenddate AND insertiondate<CURDATE() 
GROUP BY 1;



-- Channel wise


SELECT MONTHNAME(txndate)mnth,CASE WHEN storecode='ecom' THEN "online" ELSE "offline" END AS store,
YEAR(txndate)YEAR,COUNT(DISTINCT mobile)accrued_customer,
SUM(pointscollected)points_issued
FROM txn_report_flat_accrual 
WHERE storecode<>'demo' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND txndate BETWEEN @MBRPREVStartDate AND @MBRenddate AND insertiondate<CURDATE() 
GROUP BY 1,2;
a