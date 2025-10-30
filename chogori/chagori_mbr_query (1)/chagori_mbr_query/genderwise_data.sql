
SET @startdate = DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-01');
SET @enddate = LAST_DAY(@startdate);

WITH original_data AS (
  SELECT 
    Gender,
    COUNT(DISTINCT txnmappedmobile) AS customer,
    SUM(itemnetamount) AS sales,
    COUNT(DISTINCT uniquebillno) AS bills,
    SUM(itemqty) AS qty,
    SUM(itemnetamount)/COUNT(DISTINCT uniquebillno) AS ABV,
    SUM(itemnetamount)/COUNT(DISTINCT txnmappedmobile) AS AMV,
    SUM(itemqty)/COUNT(DISTINCT uniquebillno) AS UPT,
    SUM(itemnetamount)/SUM(itemqty) AS ASP
  FROM sku_report_loyalty a
  JOIN member_report b ON a.txnmappedmobile = b.mobile
  WHERE modifiedtxndate BETWEEN @startdate AND @enddate
    AND LOWER(Gender) IN ('male', 'female') 
  GROUP BY Gender
)

SELECT 
  kpis,
  SUM(CASE WHEN Gender = 'male' THEN VALUE END) AS Male,
  SUM(CASE WHEN Gender = 'female' THEN VALUE END) AS Female
FROM (
  SELECT Gender, 'Customers' AS kpis, customer AS VALUE FROM original_data
  UNION ALL
  SELECT Gender, 'No of Units Sold', qty FROM original_data
  UNION ALL
  SELECT Gender, 'Sales', sales FROM original_data
  UNION ALL
  SELECT Gender, 'Bills', bills FROM original_data
  UNION ALL
  SELECT Gender, 'ABV', ABV FROM original_data
  UNION ALL
  SELECT Gender, 'AMV', AMV FROM original_data
  UNION ALL
  SELECT Gender, 'UPT', UPT FROM original_data
  UNION ALL
  SELECT Gender, 'ASP', ASP FROM original_data
) AS unpivoted
GROUP BY kpis
ORDER BY FIELD(kpis, 'Customers', 'No of Units Sold', 'Sales', 'Bills', 
               'ABV', 'AMV', 'UPT', 'ASP');