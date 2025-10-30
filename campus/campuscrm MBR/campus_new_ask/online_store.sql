WITH base_data AS
(SELECT 
        mobile,
        SUM(amount) AS sales,
        COUNT(DISTINCT UniqueBillNo) AS bills,
        MAX(frequencycount) AS maxf, 
        MIN(frequencycount) AS minf,
        COUNT(DISTINCT frequencycount) AS frequency,
        DATEDIFF(MAX(txndate), MIN(txndate)) / NULLIF((COUNT(DISTINCT txndate) - 1), 0) AS Latency
    FROM `campuscrm`.txn_report_accrual_redemption 
     WHERE txndate BETWEEN '2024-07-01' AND '2025-06-30'
      AND storecode NOT LIKE '%demo%'
      AND billno NOT LIKE '%test%'
      AND billno NOT LIKE '%roll%'
      AND storecode NOT LIKE '%Corporate%'
      AND storecode  LIKE '%ecom%'
      AND amount > 0
    GROUP BY 1
    )
SELECT 
    COUNT(DISTINCT mobile) AS `Transacting Customer`,
    COUNT(DISTINCT CASE WHEN minf = 1 THEN mobile END) AS `New Customers`,
    COUNT(DISTINCT CASE WHEN minf > 1 THEN mobile END) AS `Repeat Customers (Existing)`,
    SUM(sales) AS `Loyalty Sales`,
    SUM(CASE WHEN minf = 1 THEN sales END) AS `New Customer's Sales`,
    SUM(CASE WHEN minf > 1 THEN sales END) AS `Repeat Customer's Sales`,
    SUM(bills) AS `Loyalty Bills`,
    SUM(CASE WHEN minf = 1 THEN bills END) AS `New Customer's Bills`,  
    SUM(CASE WHEN minf > 1 THEN bills END) AS `Repeat Customer's Bills`,
    ROUND(SUM(sales) / NULLIF(SUM(bills), 0), 2) AS `Overall ATV`,
    ROUND(SUM(sales) / NULLIF(COUNT(mobile), 0), 2) AS `Overall AMV`,           
    AVG(frequency) AS `Overall Frequency`,
    AVG(Latency)Latency
    FROM base_data;
    
    
    
