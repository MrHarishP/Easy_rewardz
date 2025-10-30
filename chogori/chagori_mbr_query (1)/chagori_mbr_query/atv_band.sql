SELECT DATE_FORMAT(CURDATE() - INTERVAL 1 MONTH, '%Y-%m-01') INTO @startdate;
SELECT LAST_DAY(CURDATE() - INTERVAL 1 MONTH) INTO @enddate;


WITH atv_band AS
(SELECT mobile, COUNT(DISTINCT uniquebillno) AS bills,
  SUM(amount) AS sales, SUM(amount) / COUNT(DISTINCT uniquebillno) AS ATV
FROM outdoortribes.txn_report_accrual_redemption WHERE txndate BETWEEN @startdate AND @enddate
 AND amount > 0 AND insertiondate <CURDATE() AND billno NOT LIKE '%test%' 
 AND billno NOT LIKE '%roll%' GROUP BY 1)
SELECT 
    CASE 
        WHEN ATV <= 1500 THEN 'Upto 1,500'
        WHEN ATV > 1500 AND ATV <= 3000 THEN '1,500-3,000' 
        WHEN ATV > 3000 AND ATV <= 4500 THEN '3,001-4,500'
        WHEN ATV > 4500 AND ATV <= 6000 THEN '4,501-6,000'
        WHEN ATV > 6000 AND ATV <= 7500 THEN '6,001-7,500'
        WHEN ATV > 7500 AND ATV <= 9000 THEN '7,501-9,000'
        WHEN ATV > 9000 AND ATV <= 10500 THEN '9,001-10,500'
        WHEN ATV > 10500 AND ATV <= 12000 THEN '10,501-12,000'
        WHEN ATV > 12000 THEN 'more than 12,000'
    END AS atv_band,
    COUNT(DISTINCT mobile) customers,
    SUM(bills) bills,
    SUM(sales) AS sales 
FROM atv_band 
GROUP BY 1 
ORDER BY 
    CASE atv_band
        WHEN 'Upto 1,500' THEN 1
        WHEN '1,500-3,000' THEN 2
        WHEN '3,001-4,500' THEN 3
        WHEN '4,501-6,000' THEN 4
        WHEN '6,001-7,500' THEN 5
        WHEN '7,501-9,000' THEN 6
        WHEN '9,001-10,500' THEN 7
        WHEN '10,501-12,000' THEN 8
        WHEN 'more than 12,000' THEN 9
    END;