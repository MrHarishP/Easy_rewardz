

SELECT mobile, CASE WHEN recency <=365  THEN 'Less then 365'
WHEN recency BETWEEN 366 AND 730 THEN '1-2year_customers'
WHEN recency>730 THEN '2-3year_customers' 
END AS recency_bucket,
CASE WHEN totalspend < 5000  THEN 'less then 5k'
WHEN totalspend >= 5000 AND totalspend <= 10000 THEN '5K-10K'
WHEN totalspend >10000 THEN '10000+' 
END AS spent_bucket, mobile FROM dummy.lifecycle_levisin_02Feb25
WHERE favstore IN ('0020022156','0020022157','0020024139','0020024141',
'0020024143','0020024144','0020024146','0020024152','0020024817','0020025406',
'0020026958','0020027865','0020028007','0020029840','0020030550','0020030711',
'0020031060','0020031627','0020031737','0020031760','0020032031','0020032889'
)
GROUP BY 1;
 almusbah
 
 SELECT * FROM store_master
 SELECT * FROM txn_report_accrual_redemption LIMIT 100;
 
--  overall by joining store master and txn report 
SELECT b.brand,COUNT(DISTINCT mobile)customer FROM txn_report_accrual_redemption a LEFT JOIN store_master b ON a.storecode=b.storecode
GROUP BY  1;

-- last one month by joining store master and txn report 
SELECT b.brand,COUNT(DISTINCT mobile)customer FROM txn_report_accrual_redemption a LEFT JOIN store_master b ON a.storecode=b.storecode
WHERE txndate BETWEEN '2025-02-01' AND '2025-02-28'
GROUP BY  1;

SELECT b.brand,COUNT(DISTINCT mobile)customer FROM txn_report_accrual_redemption a LEFT JOIN store_master b ON a.storecode=b.storecode
WHERE b.brand LIKE 'HyperMarket' 
-- and txndate BETWEEN '2025-02-01' AND '2025-02-28'
GROUP BY 1 

-- another way 
WITH brand_name AS(
SELECT brand,storecode FROM store_master
GROUP BY 1,2),
customer_base AS (
SELECT mobile,storecode FROM txn_report_accrual_redemption 
-- where txndate between '2025-02-01' AND '2025-02-28'
GROUP BY 1,2)
SELECT brand,COUNT(DISTINCT mobile) FROM brand_name a JOIN customer_base b USING(storecode)
GROUP BY 1;


-- data by txn report 
SELECT brand,COUNT(DISTINCT mobile)customer FROM txn_report_accrual_redemption 
-- where txndate BETWEEN '2025-02-01' AND '2025-02-28'
-- where brand like 'HyperMarket'
GROUP BY 1