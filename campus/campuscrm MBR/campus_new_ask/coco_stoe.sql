WITH base_data AS (
    SELECT 
        txnmappedmobile,
        SUM(itemnetamount) AS sales,
        COUNT(DISTINCT UniqueBillNo) AS bills,
        SUM(ItemQty) AS qty,
        MAX(frequencycount) AS maxf, 
        MIN(frequencycount) AS minf,
        COUNT(DISTINCT frequencycount) AS frequency,
        DATEDIFF(MAX(modifiedtxndate), MIN(modifiedtxndate)) / NULLIF((COUNT(DISTINCT modifiedtxndate) - 1), 0) AS Latency
    FROM `campuscrm`.sku_report_loyalty a 
    JOIN `campuscrm`.member_report b 
    ON a.txnmappedmobile = b.mobile
    WHERE modifiedtxndate BETWEEN '2024-07-01' AND '2025-06-30'
    AND modifiedstorecode NOT LIKE '%demo%'
    AND modifiedbillno NOT LIKE '%test%'
    AND modifiedbillno NOT LIKE '%roll%'
    AND modifiedstorecode NOT IN ('Corporate')
    AND modifiedstorecode NOT LIKE '%ecom%'
    AND modifiedstorecode IN (SELECT StoreCode FROM store_master WHERE StoreType1 LIKE '%coco%')
    AND itemnetamount > 0
    GROUP BY 1
)

SELECT 
    COUNT(DISTINCT txnmappedmobile) AS `Transacting Customer`,
    COUNT(DISTINCT CASE WHEN minf = 1 THEN txnmappedmobile END) AS `New Customers`,
    COUNT(DISTINCT CASE WHEN minf > 1 THEN txnmappedmobile END) AS `Repeat Customers (Existing)`,
    SUM(sales) AS `Loyalty Sales`,
    SUM(CASE WHEN minf = 1 THEN sales END) AS `New Customer's Sales`,
    SUM(CASE WHEN minf > 1 THEN sales END) AS `Repeat Customer's Sales`,
    SUM(bills) AS `Loyalty Bills`,
    SUM(qty)qty,
    SUM(CASE WHEN minf = 1 THEN bills END) AS `New Customer's Bills`,  
    SUM(CASE WHEN minf > 1 THEN bills END) AS `Repeat Customer's Bills`,
    ROUND(SUM(sales) / NULLIF(SUM(bills), 0), 2) AS `Overall ATV`,
    ROUND(SUM(sales) / NULLIF(COUNT(txnmappedmobile), 0), 2) AS `Overall AMV`,           
    AVG(frequency) AS `Overall Frequency`,
    AVG(Latency)Latency,
SUM(sales) / NULLIF(SUM(qty), 0) AS ASP,
    SUM(qty) / NULLIF(SUM(bills), 0) AS UPT
FROM base_data;
