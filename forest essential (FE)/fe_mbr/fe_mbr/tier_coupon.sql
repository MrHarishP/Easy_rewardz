SET @insertiondate=CURDATE();
SET @MBRstartdate=DATE_SUB(((@insertiondate-INTERVAL 30 DAY)),INTERVAL DAYOFMONTH((@insertiondate-INTERVAL 30 DAY))-1 DAY),@MBRenddate=LAST_DAY(@insertiondate-INTERVAL 30 DAY);
SET @MBRPREVStartDate=DATE_SUB(@MBRstartdate,INTERVAL DAYOFMONTH(@MBRstartdate - INTERVAL 1 DAY) DAY);
SET @MBRPREVEndDate=LAST_DAY(@MBRPREVStartDate);
SET @MBRPREVYearStartDate=@MBRstartdate- INTERVAL 1 YEAR;
SET @MBRPREVYearEndDate=LAST_DAY(@MBRstartdate- INTERVAL 1 YEAR);

SELECT @MBRstartdate,@MBRenddate,@insertiondate, @MBRPREVStartDate,@MBRPREVEndDate,@MBRPREVYearStartDate,@MBRPREVYearEndDate;



-- tier wise coupon data
SELECT b.TIER, 
MONTH(issueddate), COUNT(*)Issued
FROM coupon_offer_report a LEFT JOIN member_report b ON a.IssuedMobile=b.mobile
WHERE issueddate BETWEEN @MBRstartdate AND @MBRenddate 
AND issuedstore<>'demo'
GROUP BY 1,2;

-- SELECT 
-- tier,
-- MONTH(useddate),
-- COUNT(DISTINCT issuedmobile)Redeemers, 
-- COUNT(couponcode)CouponsRedeemed, 
-- SUM(amount)RedemptionSale, 
-- COUNT(DISTINCT billno) redemptionbills, 
-- SUM(discount)discount 
-- FROM coupon_offer_report 
-- WHERE useddate BETWEEN @MBRstartdate AND @MBRenddate 
-- AND couponstatus = 'Used' 
-- AND redeemedstorecode<>'demo' 
-- GROUP BY 1,2; 
-- 
-- 
-- 
-- SELECT * FROM coupon_offer_report ;

SELECT 
b.tier,
MONTH(useddate),
COUNT(DISTINCT issuedmobile)Redeemers, 
COUNT(couponcode)CouponsRedeemed, 
SUM(amount)RedemptionSale, 
COUNT(DISTINCT billno) redemptionbills, 
SUM(discount)discount 
FROM coupon_offer_report  a LEFT JOIN member_report b ON a.IssuedMobile=b.mobile
WHERE useddate BETWEEN @MBRstartdate AND @MBRenddate 
AND couponstatus = 'Used' 
AND redeemedstorecode<>'demo' 
GROUP BY 1,2; 

