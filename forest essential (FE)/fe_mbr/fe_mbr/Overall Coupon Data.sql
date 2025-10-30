SET @insertiondate=CURDATE();
SET @MBRstartdate=DATE_SUB(((@insertiondate-INTERVAL 30 DAY)),INTERVAL DAYOFMONTH((@insertiondate-INTERVAL 30 DAY))-1 DAY),@MBRenddate=LAST_DAY(@insertiondate-INTERVAL 30 DAY);
SET @MBRPREVStartDate=DATE_SUB(@MBRstartdate,INTERVAL DAYOFMONTH(@MBRstartdate - INTERVAL 1 DAY) DAY);
SET @MBRPREVEndDate=LAST_DAY(@MBRPREVStartDate);
SET @MBRPREVYearStartDate=@MBRstartdate- INTERVAL 1 YEAR;
SET @MBRPREVYearEndDate=LAST_DAY(@MBRstartdate- INTERVAL 1 YEAR);



-- Overall Coupon Data


SELECT 
MONTHNAME(issueddate), 
COUNT(*)Issued
FROM coupon_offer_report 
WHERE issueddate BETWEEN @MBRPREVStartDate AND @MBRenddate 
AND issuedstore<>'demo'
GROUP BY 1;




SELECT 
CASE WHEN issuedstore='ecom' THEN "online" ELSE "offline" END AS storetype,
MONTHNAME(issueddate), 
COUNT(*)Issued
FROM coupon_offer_report 
WHERE issueddate BETWEEN @MBRPREVStartDate AND @MBRenddate 
AND issuedstore<>'demo'
GROUP BY 1,2;




SELECT 
MONTHNAME(useddate),
COUNT(DISTINCT issuedmobile)Redeemers, 
COUNT(couponcode)CouponsRedeemed, 
SUM(b.amount)RedemptionSale, 
COUNT(modifiedbillno) redemptionbills, SUM(discount)discount 
FROM coupon_offer_report a JOIN txn_Report_accrual_Redemption b ON a.billno=b.modifiedbillno 
WHERE useddate BETWEEN @MBRPREVStartDate AND @MBRenddate AND couponstatus = 'Used' 
AND redeemedstorecode<>'demo' 
GROUP BY 1; 






SELECT 
CASE WHEN redeemedstorecode='ecom' THEN "online" ELSE "offline" END AS storetype,
MONTHNAME(useddate),COUNT(DISTINCT issuedmobile)Redeemers, 
COUNT(couponcode)CouponsRedeemed, SUM(b.amount)RedemptionSale, 
COUNT(modifiedbillno) redemptionbills, SUM(discount)discount 
FROM coupon_offer_report a JOIN txn_Report_accrual_Redemption b ON a.billno=b.modifiedbillno 
WHERE useddate BETWEEN @MBRPREVStartDate AND @MBRenddate AND couponstatus = 'Used' 
AND redeemedstorecode<>'demo' 
GROUP BY 1,2; 



