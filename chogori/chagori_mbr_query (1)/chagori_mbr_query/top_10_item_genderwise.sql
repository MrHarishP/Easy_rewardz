
   
SELECT DATE_FORMAT(CURDATE() - INTERVAL 1 MONTH, '%Y-%m-01') INTO @startdate;
SELECT LAST_DAY(CURDATE() - INTERVAL 1 MONTH) INTO @enddate;
  
  

WITH customer_base AS (
  SELECT 
    a.txnmappedmobile,
    a.itemqty,
    a.itemnetamount,
    a.modifiedtxndate,
    a.uniqueitemcode,
    c.product_group AS itemname,
    b.gender 
  FROM sku_report_loyalty a 
  JOIN member_report b ON a.txnmappedmobile = b.mobile
  LEFT JOIN dummy.chogori_item_master c ON a.uniqueitemcode = c.ci_code
  WHERE a.modifiedtxndate BETWEEN @startdate AND @enddate
    AND a.itemqty > 0 
    AND a.itemnetamount > 0 
    AND a.uniqueitemcode NOT IN (
      "CI26249", "CI26251", "CI26254", "CI26255", "CI26259", "CI26262", "CI26264", 
      "CI26304", "CI30148", "CI26546", "CI16414", "CI22436", "CI16406", "CI16407", 
      "CI16408", "CI20486", "CI20487", "CI26252", "CI26253", "CI26263", "CI26268", 
      "CI30151", "CI30152", "CI30153", "CI30154", "CI16415", "CI22445", "CI20488", 
      "CI30382", "CI16416", "CI20483", "CI20485", "CI26250", "CI26256", "CI26260", 
      "CI26261", "CI22444", "CI26272", "CI26258", "CI22443", "CI22442"
    )
    AND a.modifiedstorecode NOT LIKE '%demo%'
    AND a.modifiedbillno NOT LIKE '%test%' 
    AND a.modifiedbillno NOT LIKE '%roll%'
),
category AS (
  SELECT 
    gender,
    uniqueitemcode,
    itemname,
    SUM(itemqty) AS itemqty,
    SUM(itemnetamount) AS amount,
    ROW_NUMBER() OVER (PARTITION BY gender ORDER BY SUM(itemqty) DESC) AS rnk 
  FROM customer_base    
  GROUP BY gender, uniqueitemcode, itemname 
),
male_items AS (
  SELECT 
    uniqueitemcode,
    itemname,
    itemqty,
    rnk
  FROM category
  WHERE gender = 'Male'
),
female_items AS (
  SELECT 
    uniqueitemcode,
    itemname,
    itemqty,
    rnk
  FROM category
  WHERE gender = 'Female'
)
SELECT
  m.uniqueitemcode AS male_item_code,
  m.itemname AS male_item_name,
  m.itemqty AS male_units_sold,
  f.uniqueitemcode AS female_item_code,
  f.itemname AS female_item_name,
  f.itemqty AS female_units_sold
FROM male_items m
LEFT JOIN female_items f ON m.rnk = f.rnk
ORDER BY m.rnk LIMIT 10;