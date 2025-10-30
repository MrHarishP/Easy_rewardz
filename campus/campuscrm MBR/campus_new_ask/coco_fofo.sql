WITH base_data AS (
SELECT 
mobile,
MAX(frequencycount) AS maxf, 
MIN(frequencycount) AS minf,
DATEDIFF(MAX(txndate), MIN(txndate)) / NULLIF((COUNT(DISTINCT txndate) - 1), 0) AS Latency
 FROM `campuscrm`.txn_report_accrual_redemption a 
WHERE modifiedtxndate BETWEEN '2022-07-01' AND '2023-06-30'
AND modifiedstorecode NOT LIKE '%demo%'
AND modifiedbillno NOT LIKE '%test%'
AND modifiedbillno NOT LIKE '%roll%'
 AND modifiedstorecode NOT IN ('Corporate')
AND amount > 0
GROUP BY 1
    )SELECT 
        COUNT(DISTINCT mobile) AS `Transacting Customer`,
        SUM(Latency)/COUNT(DISTINCT CASE WHEN minf =1 AND maxf >1  THEN txnmappedmobile END)Latency
        FROM base_data;
        
        
        
