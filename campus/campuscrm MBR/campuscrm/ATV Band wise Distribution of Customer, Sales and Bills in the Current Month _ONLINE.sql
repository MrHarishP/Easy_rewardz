-- 
-- 
-- 
-- SET @startdate = DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-01');
-- SET @enddate = LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH));
-- 
-- SELECT @startdate,@enddate;
-- 
-- 
-- WITH ONLINE_ATV AS
-- (SELECT 
--     mobile, 
--     COUNT(DISTINCT uniquebillno) AS bills, 
--     SUM(amount) AS sales, 
--     ROUND(SUM(amount) / COUNT(DISTINCT uniquebillno), 2) AS ATV
-- FROM 
--     txn_report_accrual_redemption WHERE 
--     txndate BETWEEN  @startdate AND @enddate   
--     AND amount > 0
--     AND insertiondate < CURDATE()
--     AND billno NOT LIKE '%test%'
--     AND billno NOT LIKE '%roll%'
--     AND storecode IN ('ecom','corporate')
--     InsertionDate<='2025-06-12'
--     GROUP BY 
--     1)
-- 	
-- SELECT 
--     CASE 
--         WHEN ATV <= < 400 THEN '< 400'
--         WHEN ATV >400  AND ATV <= 600 THEN '>400 <=600' 
--         WHEN ATV > 600 AND ATV <= 800 THEN '> 600 <= 800'
--         WHEN ATV > 800 AND ATV <= 1000 THEN '> 800 <=1000'
--         WHEN ATV > 1000 AND ATV <= 1200 THEN '> 1000 <= 1200'
--         WHEN ATV > 1200 AND ATV <= 1400 THEN '> 1200 <= 1400'
--         WHEN ATV > 1400 AND ATV <= 1600 THEN '> 1400 <= 1600'
--         WHEN ATV > 1600 AND ATV <= 1800 THEN '> 1600 <= 1800'
--         WHEN ATV > 1800 AND ATV <= 2000 THEN '> 1800 <= 2000'
--         WHEN ATV > 2000 AND ATV <= 2500 THEN '> 2000 <= 2500'
--         WHEN ATV > 2500 AND ATV <= 3000 THEN '> 2500 <= 3000'
--         WHEN ATV > 3000 THEN '>3000'
-- 	END AS atv_band,
--     COUNT(DISTINCT mobile) customers,
--     SUM(bills) bills,
--     SUM(sales) AS sales,
--     SUM(sales)/SUM(bills) atv,
--     SUM(sales)/COUNT(DISTINCT mobile) amv
--     FROM ONLINE_ATV GROUP BY 1 ;




SET @startdate = DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-01');
SET @enddate = LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH));

SELECT @startdate, @enddate;

WITH ONLINE_ATV AS (
    SELECT 
        mobile, 
        COUNT(DISTINCT uniquebillno) AS bills, 
        SUM(amount) AS sales, 
        ROUND(SUM(amount) / COUNT(DISTINCT uniquebillno), 2) AS ATV
    FROM txn_report_accrual_redemption 
    WHERE txndate BETWEEN @startdate AND @enddate
        AND amount > 0
        AND InsertionDate <'2025-10-08'
        AND billno NOT LIKE '%test%'
        AND billno NOT LIKE '%roll%'
        AND storecode = 'ecom'
        AND storecode <> 'corporate'
    GROUP BY mobile
)

SELECT 
    CASE 
        WHEN ATV <= 400 THEN '< 400'
        WHEN ATV > 400 AND ATV <= 600 THEN '>400 <=600' 
        WHEN ATV > 600 AND ATV <= 800 THEN '> 600 <= 800'
        WHEN ATV > 800 AND ATV <= 1000 THEN '> 800 <=1000'
        WHEN ATV > 1000 AND ATV <= 1200 THEN '> 1000 <= 1200'
        WHEN ATV > 1200 AND ATV <= 1400 THEN '> 1200 <= 1400'
        WHEN ATV > 1400 AND ATV <= 1600 THEN '> 1400 <= 1600'
        WHEN ATV > 1600 AND ATV <= 1800 THEN '> 1600 <= 1800'
        WHEN ATV > 1800 AND ATV <= 2000 THEN '> 1800 <= 2000'
        WHEN ATV > 2000 AND ATV <= 2500 THEN '> 2000 <= 2500'
        WHEN ATV > 2500 AND ATV <= 3000 THEN '> 2500 <= 3000'
        WHEN ATV > 3000 THEN '>3000'
    END AS atv_band,
    COUNT(DISTINCT mobile) AS customers,
    SUM(bills) AS bills,
    SUM(sales) AS sales,
    ROUND(SUM(sales) / SUM(bills), 2) AS atv,
    ROUND(SUM(sales) / COUNT(DISTINCT mobile), 2) AS amv
FROM ONLINE_ATV
GROUP BY atv_band
ORDER BY atv;

