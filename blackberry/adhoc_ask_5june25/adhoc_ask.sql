-- A. How many customers purchased for a cumulative value > Rs 20,000 during the period 1 June 2023 to 31 May 2024.

WITH A AS (
SELECT txnmappedmobile,SUM(sales)sales FROM (
SELECT txnmappedmobile,SUM(itemnetamount)sales FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2023-06-01' AND '2024-05-31'
AND itemnetamount>0 AND modifiedstorecode <> 'demo' AND txnmappedmobile IS NOT NULL AND txnmappedmobile <> ''
GROUP BY 1)a
WHERE sales>20000
GROUP BY 1), #90435
-- select count(distinct txnmappedmobile)customer from a; #90435
-- B. Out of “A” above how many shopped with us during the 12 month period “ 1  June2024 to 31 May 2025”
b AS (SELECT txnmappedmobile,SUM(itemnetamount)sales FROM sku_report_loyalty a 
WHERE modifiedtxndate BETWEEN '2024-06-01' AND '2025-05-31'
AND txnmappedmobile IN (SELECT DISTINCT txnmappedmobile FROM A)
AND itemnetamount>0 AND modifiedstorecode <> 'demo' AND txnmappedmobile IS NOT NULL AND txnmappedmobile <> ''
GROUP BY 1)
-- , # 34953

-- select count(distinct txnmappedmobile)customer from b;#34953
-- C. For “B” above give a break-up of their shopping value as “full price purchase” and “discounted purchase” during the period “ 1  June2024 to 31 May 2025” will work on it 

-- discount_non_discount as (
-- select tag,count(distinct txnmappedmobile)customer,txnmappedmobile from (
SELECT txnmappedmobile,SUM(itemdiscountamount)discount,
CASE WHEN itemdiscountamount=0 THEN 'full_price_purchase' ELSE 'discounted_purchase' END AS tag
FROM sku_report_loyalty a JOIN b AS b USING(txnmappedmobile)
WHERE modifiedtxndate BETWEEN '2024-06-01' AND '2025-05-31' 
-- and txnmappedmobile in (select distinct txnmappedmobile from b)
AND itemnetamount>0 AND txnmappedmobile IS NOT NULL AND txnmappedmobile <>'' AND modifiedstorecode <> 'demo'
GROUP BY 1
-- )a
-- group by 1
;

-- select tag,count(distinct txnmappedmobile )customer
-- from discount_non_discount
-- group by 1;
-- D. Out of “A” how many people shopped during the period 1st June 2024 to 31st May 2025, for a cumulative value of Rs 20000 or more.
SELECT  txnmappedmobile customer,SUM(sales)sales FROM (
SELECT b.txnmappedmobile,SUM(itemnetamount)sales FROM sku_report_loyalty a JOIN b AS b USING(txnmappedmobile)
WHERE modifiedtxndate BETWEEN '2024-06-01' AND '2025-05-31'
-- AND txnmappedmobile IN (SELECT DISTINCT txnmappedmobile FROM b)
AND itemnetamount>0 AND modifiedstorecode <> 'demo' AND txnmappedmobile IS NOT NULL AND txnmappedmobile <> ''
GROUP BY 1)a
WHERE sales>=20000
GROUP BY 1;


SELECT txnmappedmobile,SUM(itemnetamount)sales FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2024-06-01' AND '2025-05-31'
AND txnmappedmobile = '6005073320'





