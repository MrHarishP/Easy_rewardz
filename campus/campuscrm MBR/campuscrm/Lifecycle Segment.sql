
WITH segment_base AS (
    SELECT 
        mobile,
        MAX(frequencycount) AS FCOverall,
        DATEDIFF('2024-09-30', MAX(txndate)) AS recency
    FROM campuscrm.txn_report_accrual_redemption
    WHERE txndate <= '2024-09-30'
    AND amount>0
    GROUP BY mobile
),
segment_lifecycle AS (
    SELECT 
        mobile,
        FCOverall,
        recency,
        CASE 
            WHEN recency <= 365 THEN 'active'
            WHEN recency BETWEEN 366 AND 730 THEN 'dormant'
            WHEN recency > 730 THEN 'lapsed'
        END AS lifecycle_2024
    FROM segment_base
)
SELECT 
    lifecycle_2024 AS `2024_lifecycle`,
    COUNT(mobile) AS customers
FROM segment_lifecycle
GROUP BY 1;






WITH segment_base AS (
    SELECT 
        mobile,
        MAX(frequencycount) AS FCOverall,
        DATEDIFF('2025-09-30', MAX(txndate)) AS recency
    FROM campuscrm.txn_report_accrual_redemption
    WHERE txndate <= '2025-09-30'
    GROUP BY mobile
),
segment_lifecycle AS (
    SELECT 
        mobile,
        FCOverall,
        recency,
        CASE 
            WHEN recency <= 365 THEN 'active'
            WHEN recency BETWEEN 366 AND 730 THEN 'dormant'
            WHEN recency > 730 THEN 'lapsed'
        END AS lifecycle_2025
    FROM segment_base
)
SELECT 
    lifecycle_2025 AS `2025_lifecycle`,
    COUNT(mobile) AS customers
FROM segment_lifecycle
GROUP BY 1;

