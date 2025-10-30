WITH data_base AS (
SELECT DISTINCT storecode 
FROM `campuscrm`.txn_report_accrual_redemption
WHERE txndate BETWEEN '2025-04-01' AND '2025-06-30'
AND storecode NOT LIKE '%demo%'
AND billno NOT LIKE '%test%'
AND billno NOT LIKE '%roll%'
AND storecode NOT IN ('Corporate')
AND storecode LIKE '%ecom%'

),
base_data AS (
    SELECT 
        mobile AS mobile,
        SUM(amount) AS sales,
        COUNT(DISTINCT UniqueBillNo) AS bills,
        MAX(frequencycount) AS maxf, 
        MIN(frequencycount) AS minf,
        COUNT(DISTINCT frequencycount) AS frequency,
        DATEDIFF(MAX(txndate), MIN(txndate)) / NULLIF((COUNT(DISTINCT txndate) - 1), 0) AS Latency
    FROM `campuscrm`.txn_report_accrual_redemption a 
    JOIN data_base b ON a.storecode = b.storecode
    WHERE a.txndate BETWEEN '2024-04-01' AND '2024-06-30'
      AND a.storecode NOT LIKE '%demo%'
      AND a.billno NOT LIKE '%test%'
      AND a.billno NOT LIKE '%roll%'
      AND a.storecode NOT IN ('Corporate')
      AND a.storecode  LIKE '%ecom%'
      AND a.amount > 0
    GROUP BY a.mobile
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
    AVG(frequency) AS `Overall Frequency`
FROM base_data;
