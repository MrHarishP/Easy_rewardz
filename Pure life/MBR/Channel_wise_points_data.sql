-- Channelwise

SELECT MONTHNAME(txndate)mnth,CASE WHEN storecode='ecom' THEN "online" ELSE "offline" END AS store,
YEAR(txndate)YEAR,COUNT(DISTINCT mobile)customer,
SUM(pointscollected)points_collected,SUM(pointsspent)points_reedemed,
COUNT(DISTINCT CASE WHEN pointsspent>0 THEN mobile END) AS Redeemers,
COUNT(DISTINCT CASE WHEN pointsspent>0 THEN uniquebillno END)AS Redemption_Bills,
SUM(CASE WHEN pointsspent>0 THEN amount END ) AS Redemption_sales 
FROM txn_report_accrual_redemption 
WHERE storecode<>'demo' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND txndate BETWEEN '2025-06-01' AND '2025-07-31' 
AND mobile NOT IN ('8360605410','9899021077','9953602260','9910024512','7417295255','9811015405','9559796666')
AND insertiondate<'2025-08-07' GROUP BY 1,2

UNION
SELECT MONTHNAME(txndate)mnth,'overall'store,
-- CASE WHEN storecode='ecom' THEN "online" ELSE "offline" END AS store,
YEAR(txndate)YEAR,COUNT(DISTINCT mobile)customer,
SUM(pointscollected)points_collected,SUM(pointsspent)points_reedemed,
COUNT(DISTINCT CASE WHEN pointsspent>0 THEN mobile END) AS Redeemers,
COUNT(DISTINCT CASE WHEN pointsspent>0 THEN uniquebillno END)AS Redemption_Bills,
SUM(CASE WHEN pointsspent>0 THEN amount END ) AS Redemption_sales 
FROM txn_report_accrual_redemption 
WHERE storecode<>'demo' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND txndate BETWEEN '2025-06-01' AND '2025-07-31' 
AND mobile NOT IN ('8360605410','9899021077','9953602260','9910024512','7417295255','9811015405','9559796666')
AND insertiondate<'2025-08-07' GROUP BY 1,2;