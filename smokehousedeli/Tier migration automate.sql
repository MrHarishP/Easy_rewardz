SET @TierStartDate = DATE_SUB(DATE_FORMAT(CURDATE(), '%Y-%m-01'), INTERVAL 1 MONTH);
SET @TierEndate= LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH));
SET @migration_time = '2025-08-28';
SELECT @TierStartDate,@TierEndate,@migration_time;


-- _________________________________________ TIER MIGRATION work on it _____________________________
WITH current_customer AS (
SELECT CurrentTier,
COUNT(DISTINCT mobile)cur_count 
FROM tier_report_log 
WHERE TierStartDate<= @TierEndate
GROUP BY 1),

at_migration AS (
SELECT CurrentTier,
COUNT(DISTINCT mobile)migration
FROM tier_report_log 
WHERE TierStartDate<= @migration_time
GROUP BY 1)

SELECT CurrentTier,
cur_count AS 'Current Customer Count​',
IFNULL(migration,0) AS 'At the time of Migration​',
IFNULL(cur_count-migration,0) AS 'New Enrolment in the tier​',
IFNULL(
    (IFNULL(cur_count,0) - IFNULL(migration,0)) / 
    NULLIF(IFNULL(cur_count,0),0),
0) AS `% New Customer​`

FROM current_customer a LEFT JOIN at_migration b USING(CurrentTier)
GROUP BY 1;



SET @currentmbrmonthstart = DATE_SUB(DATE_FORMAT(CURDATE(), '%Y-%m-01'), INTERVAL 1 MONTH);
SET @currentmbrmonthend= LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH));
SELECT @currentmbrmonthstart,@currentmbrmonthend;

WITH tier_issued AS (
SELECT 
tier,
COUNT(*)Issued
FROM coupon_offer_report
WHERE issueddate BETWEEN @currentmbrmonthstart AND @currentmbrmonthend
-- and issuedstore <> 'demo'
AND issuedstore NOT IN('demo','Corporate','Whatsapp','DummyStore')
GROUP BY 1),

tier_redeemed AS (
SELECT 
a.tier,
COUNT(couponcode)CouponsRedeemed,
COUNT(DISTINCT issuedmobile)Coupon_Redeemers, 
 SUM(discount)discount,
 SUM(b.amount)RedemptionSale 
FROM coupon_offer_report a JOIN txn_Report_accrual_Redemption b 
ON a.billno=b.modifiedbillno 
WHERE useddate BETWEEN @currentmbrmonthstart AND @currentmbrmonthend 
AND couponstatus = 'Used' 
-- AND redeemedstorecode <> 'demo'
AND redeemedstorecode NOT IN('demo','Corporate','Whatsapp','DummyStore') 
GROUP BY 1)

SELECT a.tier AS 'Tier name',
Issued AS 'Coupon issued',
CouponsRedeemed AS 'COUPON REDEEMED',
IFNULL(CouponsRedeemed/Issued,0) AS 'REDEMPTION RATE',
Coupon_Redeemers AS 'REDEEMERS',
RedemptionSale AS 'REDEMPTION SALES',
discount AS Discount,
discount/RedemptionSale AS '% DISCOUNT'
FROM tier_issued a LEFT JOIN tier_redeemed b USING (tier);

