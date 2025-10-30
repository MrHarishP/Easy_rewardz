
###############################

WITH category_data AS (
    SELECT 
        b.categoryname,
        c.region,
        COUNT(DISTINCT a.txnmappedmobile) AS Customers,
        SUM(a.itemnetamount) AS Sales,
        COUNT(DISTINCT a.uniquebillno) AS Bills
    FROM sku_report_loyalty a
    JOIN item_master b ON a.uniqueitemcode = b.uniqueitemcode
    JOIN store_master c ON a.modifiedstorecode = c.storecode
    WHERE a.modifiedtxndate BETWEEN '2024-11-01' AND '2024-11-30'
        AND a.itemnetamount > 0
        AND a.modifiedstorecode NOT LIKE '%demo%'
    GROUP BY b.categoryname, c.region
),

-- 🔹 Rank top 10 by Sales
rank_sales AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY region ORDER BY Sales DESC) AS rnk
    FROM category_data
),

-- 🔹 Rank top 10 by Bills
rank_bills AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY region ORDER BY Bills DESC) AS rnk
    FROM category_data
),

-- 🔹 Rank top 10 by Customers
rank_customers AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY region ORDER BY Customers DESC) AS rnk
    FROM category_data
)

-- -- ✅ Combine all top 10s
-- SELECT 
--        region, categoryname, Customers, Sales, Bills
-- FROM rank_sales
-- WHERE rnk <= 10
-- order by sales desc
-- 
-- UNION ALL

-- SELECT 
--        region, categoryname, Customers, Sales, Bills
-- FROM rank_bills
-- WHERE rnk <= 10
-- order by bills desc
-- 
-- UNION ALL

SELECT 
       region, categoryname, Customers, Sales, Bills
FROM rank_customers
WHERE rnk <= 10

ORDER BY customers DESC;
