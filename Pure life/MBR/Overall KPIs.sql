####################################################################################################################

-- Sheet 1
-- For Sep 2024
SET @startdate= DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-01');
SET @enddate = LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH));
SELECT @Startdate,@enddate;

SELECT 'overall' AS CHANNEL,COUNT(DISTINCT Mobile) Transacting_customers,
COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN Mobile END)New_One_Timer,
COUNT(DISTINCT CASE WHEN maxf>1 THEN Mobile END)Repeater,
SUM(sales) AS Total_Sales,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END) AS Newonetimer_sales,
SUM(CASE WHEN maxf>1 THEN sales END) AS Repeater_sales,
SUM(bills) Total_Bills,
SUM(CASE WHEN maxf=1 AND minf=1 THEN bills END) AS Newonetimer_Bills,
SUM(CASE WHEN maxf>1 THEN bills END) AS Repeater_Bills,
SUM(sales)/SUM(bills) AS ABV,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END)/SUM(CASE WHEN maxf=1 AND minf=1 THEN bills END) AS Newonetimer_ABV,
SUM(CASE WHEN maxf>1 THEN sales END)/SUM(CASE WHEN maxf>1 THEN bills END) AS Repeater_ABV
FROM
(SELECT Mobile,SUM(amount) AS sales,
COUNT(DISTINCT UniqueBillNo) AS bills,
MAX(frequencycount) AS maxf,
MIN(frequencycount) AS minf FROM txn_report_accrual_redemption 
WHERE TxnDate BETWEEN @Startdate AND @enddate
AND storecode NOT LIKE '%demo%' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
-- AND storecode<>'ecom'
-- AND storecode='ecom'
AND mobile NOT IN ('8360605410','9899021077','9953602260','9910024512','7417295255','9811015405','9559796666')
AND amount>0
GROUP BY 1)b
GROUP BY 1 
UNION
SELECT 'offline' AS CHANNEL,COUNT(DISTINCT Mobile) Transacting_customers,
COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN Mobile END)New_One_Timer,
COUNT(DISTINCT CASE WHEN maxf>1 THEN Mobile END)Repeater,
SUM(sales) AS Total_Sales,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END) AS Newonetimer_sales,
SUM(CASE WHEN maxf>1 THEN sales END) AS Repeater_sales,
SUM(bills) Total_Bills,
SUM(CASE WHEN maxf=1 AND minf=1 THEN bills END) AS Newonetimer_Bills,
SUM(CASE WHEN maxf>1 THEN bills END) AS Repeater_Bills,
SUM(sales)/SUM(bills) AS ABV,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END)/SUM(CASE WHEN maxf=1 AND minf=1 THEN bills END) AS Newonetimer_ABV,
SUM(CASE WHEN maxf>1 THEN sales END)/SUM(CASE WHEN maxf>1 THEN bills END) AS Repeater_ABV
FROM
(SELECT Mobile,SUM(amount) AS sales,
COUNT(DISTINCT UniqueBillNo) AS bills,
MAX(frequencycount) AS maxf,
MIN(frequencycount) AS minf FROM txn_report_accrual_redemption 
WHERE TxnDate BETWEEN @Startdate AND @enddate
AND storecode NOT LIKE '%demo%' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND storecode<>'ecom'
-- AND storecode='ecom'
AND mobile NOT IN ('8360605410','9899021077','9953602260','9910024512','7417295255','9811015405','9559796666')
AND amount>0
GROUP BY 1)b
GROUP BY 1
UNION
SELECT 'online'CHANNEL,COUNT(DISTINCT Mobile) Transacting_customers,
COUNT(DISTINCT CASE WHEN maxf=1 AND minf=1 THEN Mobile END)New_One_Timer,
COUNT(DISTINCT CASE WHEN maxf>1 THEN Mobile END)Repeater,
SUM(sales) AS Total_Sales,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END) AS Newonetimer_sales,
SUM(CASE WHEN maxf>1 THEN sales END) AS Repeater_sales,
SUM(bills) Total_Bills,
SUM(CASE WHEN maxf=1 AND minf=1 THEN bills END) AS Newonetimer_Bills,
SUM(CASE WHEN maxf>1 THEN bills END) AS Repeater_Bills,
SUM(sales)/SUM(bills) AS ABV,
SUM(CASE WHEN maxf=1 AND minf=1 THEN sales END)/SUM(CASE WHEN maxf=1 AND minf=1 THEN bills END) AS Newonetimer_ABV,
SUM(CASE WHEN maxf>1 THEN sales END)/SUM(CASE WHEN maxf>1 THEN bills END) AS Repeater_ABV
FROM
(SELECT Mobile,SUM(amount) AS sales,
COUNT(DISTINCT UniqueBillNo) AS bills,
MAX(frequencycount) AS maxf,
MIN(frequencycount) AS minf FROM txn_report_accrual_redemption 
WHERE TxnDate BETWEEN @Startdate AND @enddate
AND storecode NOT LIKE '%demo%' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
-- AND storecode<>'ecom'
AND storecode='ecom'
AND mobile NOT IN ('8360605410','9899021077','9953602260','9910024512','7417295255','9811015405','9559796666')
AND amount>0
GROUP BY 1)b
GROUP BY 1;