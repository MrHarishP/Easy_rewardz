CREATE TABLE dummy.customer_store_data (
    mobile BIGINT,
    total_transactions INT,
    total_spends DECIMAL(10,2),
    atv DECIMAL(10,2),
    StoreCode VARCHAR(50),
    store_type VARCHAR(50)
);# 0 

WITH coco AS (
    SELECT StoreCode, store_type 
    FROM dummy.camp_coco_fofo_store 
    WHERE store_type = 'coco'
)
    SELECT 
        mobile,
        `total transactions`,
        `total spends`,
        `total spends` / `total transactions` AS atv,
        `last shopped store` AS StoreCode
    FROM program_single_view 
    WHERE `last shopped date` <= '2024-12-31';

INSERT INTO dummy.customer_store_data (mobile, total_transactions, total_spends, atv, StoreCode, store_type)
SELECT 
    psv.mobile,
    psv.`total transactions`,
    psv.`total spends`,
    psv.`total spends` / NULLIF(psv.`total transactions`, 0) AS atv,
    psv.`last shopped store`,
    coco.store_type
FROM program_single_view psv
LEFT JOIN dummy.camp_coco_fofo_store coco 
    ON psv.`last shopped store` = coco.StoreCode AND coco.store_type = 'coco'
WHERE psv.`last shopped date` <= '2024-12-31';

SELECT * FROM dummy.customer_store_data;

SELECT CASE 
        WHEN atv>= 800 AND atv<=1800 THEN '800-1800'
        WHEN atv >1800 AND atv<=2300 THEN '1800-2300'
        WHEN atv >2300 AND atv<=2800 THEN '2300-2800' 
        ELSE 'Other' END 
        
        
        
SELECT CASE WHEN atv>=800 AND atv<=1800 THEN '800-1800'
WHEN atv>1800 AND atv<=2300 THEN '1800-2300'
WHEN atv>2300 AND atv<=2800 THEN '2300-2800'
ELSE 'other' END 'atv band',COUNT(DISTINCT mobile)FROM dummy.customer_store_data
WHERE store_type='coco'
GROUP BY 1

-- atv>= 800 AND atv<=1800        
SELECT mobile,store_type FROM dummy.customer_store_data
WHERE atv>= 800 AND atv<=1800 AND store_type ='coco'
GROUP BY 1,2;

-- atv >1800 AND atv<=2300
SELECT mobile,store_type FROM dummy.customer_store_data 
WHERE atv >1800 AND atv<=2300 AND store_type ='coco'
GROUP BY 1,2;

-- atv >2300 AND atv<=2800
SELECT mobile,store_type FROM dummy.customer_store_data 
WHERE atv >2300 AND atv<=2800 AND store_type ='coco'
GROUP BY 1,2;