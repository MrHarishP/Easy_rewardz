SET @startdate=DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 2 MONTH),'%Y-%m-01');
SET @enddate=LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH));
SELECT @startdate,@enddate;

WITH base AS (
    SELECT 
        DATE_FORMAT(txndate, '%b-%y') AS mnth,
        CASE WHEN storecode='ecom' THEN 'online' ELSE 'offline' END AS store,
        YEAR(txndate) AS YEAR,
        mobile,
        pointscollected,
        pointsspent,
        uniquebillno,
        amount
    FROM txn_report_accrual_redemption 
    WHERE storecode<>'demo' 
      AND billno NOT LIKE '%test%' 
      AND billno NOT LIKE '%roll%'
      AND txndate BETWEEN @startdate AND @enddate
      AND mobile NOT IN ('8360605410','9899021077','9953602260',
                         '9910024512','7417295255','9811015405','9559796666')
      AND insertiondate < CURDATE()
),
agg AS (
    SELECT 
        mnth,
        store,
        YEAR,
        COUNT(DISTINCT mobile) AS customer,
        SUM(pointscollected) AS points_collected,
        SUM(pointsspent) AS points_reedemed,
        COUNT(DISTINCT CASE WHEN pointsspent>0 THEN mobile END) AS Redeemers,
        COUNT(DISTINCT CASE WHEN pointsspent>0 THEN uniquebillno END) AS Redemption_Bills,
        SUM(CASE WHEN pointsspent>0 THEN amount END ) AS Redemption_sales
    FROM base
    GROUP BY mnth, store, YEAR
),
overall AS (
    SELECT 
        mnth,
        'Overall' AS store,
        YEAR,
        COUNT(DISTINCT mobile) AS customer,
        SUM(pointscollected) AS points_collected,
        SUM(pointsspent) AS points_reedemed,
        COUNT(DISTINCT CASE WHEN pointsspent>0 THEN mobile END) AS Redeemers,
        COUNT(DISTINCT CASE WHEN pointsspent>0 THEN uniquebillno END) AS Redemption_Bills,
        SUM(CASE WHEN pointsspent>0 THEN amount END ) AS Redemption_sales
    FROM base
    GROUP BY 1,3
),
unioned AS (
    SELECT * FROM agg
    UNION ALL
    SELECT * FROM overall
)
SELECT 
    metric,
    MAX(CASE WHEN store='offline' AND mnth='Jul-25' THEN val END) AS "Jul-25_offline",
    MAX(CASE WHEN store='online'  AND mnth='Jul-25' THEN val END) AS "Jul-25_online",
    MAX(CASE WHEN store='Overall' AND mnth='Jul-25' THEN val END) AS "Jul-25_Overall",
    MAX(CASE WHEN store='offline' AND mnth='Aug-25' THEN val END) AS "Aug-25_offline",
    MAX(CASE WHEN store='online'  AND mnth='Aug-25' THEN val END) AS "Aug-25_online",
    MAX(CASE WHEN store='Overall' AND mnth='Aug-25' THEN val END) AS "Aug-25_Overall"
FROM (
    SELECT mnth, store, YEAR, 'YEAR' AS metric, YEAR AS val FROM unioned
    UNION ALL 
    SELECT mnth, store, YEAR, 'customer', customer FROM unioned
    UNION ALL 
    SELECT mnth, store, YEAR, 'points_collected', points_collected FROM unioned
    UNION ALL 
    SELECT mnth, store, YEAR, 'points_reedemed', points_reedemed FROM unioned
    UNION ALL 
    SELECT mnth, store, YEAR, 'Redeemers', Redeemers FROM unioned
    UNION ALL 
    SELECT mnth, store, YEAR, 'Redemption_Bills', Redemption_Bills FROM unioned
    UNION ALL 
    SELECT mnth, store, YEAR, 'Redemption_sales', Redemption_sales FROM unioned
) t
GROUP BY metric
ORDER BY FIELD(metric,
               'YEAR','customer','points_collected',
               'points_reedemed','Redeemers',
               'Redemption_Bills','Redemption_sales');



-- Narration points issued data 

SET @startdate=DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 2 MONTH),'%Y-%m-01');
SET @enddate=LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH));
SELECT @startdate,@enddate;

SELECT narration,SUM(pointscollected)points_issued
FROM txn_report_flat_accrual 
WHERE storecode<>'demo' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND txndate BETWEEN @startdate AND @enddate 
AND mobile NOT IN ('8360605410','9899021077','9953602260','9910024512','7417295255','9811015405','9559796666')
AND insertiondate<'2025-09-08' GROUP BY 1;

##############################################################################

#####################################coupon date##########################
SET @startdate=DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 2 MONTH),'%Y-%m-01');
SET @enddate=LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH));
SELECT @startdate,@enddate;


WITH issued AS (
SELECT 
-- CASE WHEN issuedstore='ecom' THEN "online" ELSE "offline" END AS storetype,
MONTHNAME(issueddate)PERIOD, COUNT(*)Issued
FROM coupon_offer_report 
WHERE issueddate BETWEEN @startdate AND @enddate 
AND issuedstore<>'demo'
AND issuedmobile NOT IN ('8360605410','9899021077','9953602260','9910024512','7417295255','9811015405','9559796666')
GROUP BY 1
-- ,2
ORDER BY issueddate
),

used AS (
SELECT 
-- CASE WHEN redeemedstorecode='ecom' THEN "online" ELSE "offline" END AS storetype,
MONTHNAME(useddate)PERIOD,COUNT(DISTINCT issuedmobile)Redeemers, 
COUNT(couponcode)CouponsRedeemed, SUM(b.amount)RedemptionSale, 
COUNT(modifiedbillno) redemptionbills, SUM(discount)discount 
FROM coupon_offer_report a JOIN txn_Report_accrual_Redemption b ON a.billno=b.modifiedbillno 
WHERE useddate BETWEEN @startdate AND @enddate AND couponstatus = 'Used' 
AND redeemedstorecode<>'demo' 
AND mobile NOT IN ('8360605410','9899021077','9953602260','9910024512','7417295255','9811015405','9559796666')
GROUP BY 1
-- ,2
ORDER BY useddate
)
SELECT PERIOD,Issued,Redeemers,CouponsRedeemed,discount FROM issued a JOIN used b USING(PERIOD);
##################################################################
