SET @startdate = DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-01');
SET @enddate = LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH));

SELECT @startdate,@enddate;


WITH fOfO_ATV AS
(SELECT 
    a.mobile, 
    COUNT(DISTINCT a.uniquebillno) AS bills, 
    SUM(a.amount) AS sales, 
    ROUND(SUM(a.amount) / COUNT(DISTINCT a.uniquebillno), 2) AS ATV
FROM 
    txn_report_accrual_redemption a
JOIN 
    store_master b ON a.storecode = b.storecode
WHERE 
    a.txndate BETWEEN  @startdate AND @enddate   
     AND a.amount > 0
    AND a.insertiondate < CURDATE()
    AND a.billno NOT LIKE '%test%'
    AND a.billno NOT LIKE '%roll%'
    AND b.storetype1 LIKE '%fofo%'
    AND a.storecode NOT IN ('demo','corporate')
GROUP BY 
    a.mobile)
	
SELECT 
    CASE 
        WHEN ATV <= 1000 THEN '< 1000'
        WHEN ATV > 1000 AND ATV <= 1500 THEN '> 1000 <= 1500' 
        WHEN ATV > 1500 AND ATV <= 1800 THEN '> 1500 <= 1800'
        WHEN ATV > 1800 AND ATV <= 2000 THEN '> 1800 <= 2000'
        WHEN ATV > 2000 AND ATV <= 2400 THEN '> 2000 <= 2400'
        WHEN ATV > 2400 AND ATV <= 3000 THEN '> 2400 <= 3000'
        WHEN ATV > 3000 AND ATV <= 3500 THEN '> 3000 <= 3500'
        WHEN ATV > 3500 AND ATV <= 4000 THEN '> 3500 <= 4000'
        WHEN ATV > 4000 AND ATV <= 5000 THEN '> 4000 <= 5000'
        WHEN ATV > 5000 THEN '> 5000'
	END AS atv_band,
    COUNT(DISTINCT mobile) customers,
    SUM(bills) bills,
    SUM(sales) AS sales,
    SUM(sales)/SUM(bills) atv,
    SUM(sales)/COUNT(DISTINCT mobile) amv
    FROM fOfO_ATV GROUP BY 1 
ORDER BY 
    CASE atv_band
        WHEN '< 1000' THEN 1
        WHEN '> 1000 <= 1500' THEN 2
        WHEN '> 1500 <= 1800' THEN 3
        WHEN '> 1800 <= 2000' THEN 4
        WHEN '> 2000 <= 2400' THEN 5
        WHEN '> 2400 <= 3000' THEN 6
        WHEN '> 3000 <= 3500' THEN 7
        WHEN '> 3500 <= 4000' THEN 8
        WHEN '> 4000 <= 5000' THEN 9
        WHEN '> 5000' THEN 10
    END;

	
	
	
	