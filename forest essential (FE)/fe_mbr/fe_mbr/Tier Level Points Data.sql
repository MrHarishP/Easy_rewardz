SET @insertiondate=CURDATE();
SET @MBRstartdate=DATE_SUB(((@insertiondate-INTERVAL 30 DAY)),INTERVAL DAYOFMONTH((@insertiondate-INTERVAL 30 DAY))-1 DAY),@MBRenddate=LAST_DAY(@insertiondate-INTERVAL 30 DAY);
SET @MBRPREVStartDate=DATE_SUB(@MBRstartdate,INTERVAL DAYOFMONTH(@MBRstartdate - INTERVAL 1 DAY) DAY);
SET @MBRPREVEndDate=LAST_DAY(@MBRPREVStartDate);
SET @MBRPREVYearStartDate=@MBRstartdate- INTERVAL 1 YEAR;
SET @MBRPREVYearEndDate=LAST_DAY(@MBRstartdate- INTERVAL 1 YEAR);




SELECT 
tier,
COUNT(membershipcardnumber)customers,
SUM(Points_collected)Points_collected,
SUM(Points_Redeemed)Points_Redeemed
FROM
(SELECT membershipcardnumber,tier,
SUM(a.pointscollected) AS Points_collected,SUM(a.pointsspent) AS Points_Redeemed, MAX(frequencycount) AS max_fc
FROM `txn_report_accrual_redemption` a JOIN member_report b  ON a.membershipcardnumber=b.membershipno
WHERE a.insertiondate<CURDATE()
AND txndate BETWEEN  @MBRstartdate AND @MBRenddate
AND modifiedbillno NOT LIKE '%brn%'
AND modifiedbillno NOT LIKE '%roll%' AND storecode NOT LIKE '%demo%'
GROUP BY 1)c
GROUP BY 1;

