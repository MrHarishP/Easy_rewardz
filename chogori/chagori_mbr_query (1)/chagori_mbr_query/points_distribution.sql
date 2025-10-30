
SELECT DATE_FORMAT(CURDATE() - INTERVAL 1 MONTH, '%Y-%m-01') INTO @startdate;
SELECT LAST_DAY(CURDATE() - INTERVAL 1 MONTH) INTO @enddate;

  

WITH 
current_month_transactions AS (
  SELECT DISTINCT mobile
  FROM `outdoortribes`.txn_report_accrual_redemption
  WHERE txndate BETWEEN @startdate AND @enddate
    AND modifiedbillno NOT LIKE '%brn%'
    AND modifiedbillno NOT LIKE '%roll%'
    AND storecode NOT LIKE '%demo%'
),
all_transactions AS (
  SELECT DISTINCT mobile
  FROM `outdoortribes`.txn_report_accrual_redemption
  WHERE txndate <= @enddate
    AND modifiedbillno NOT LIKE '%brn%'
    AND modifiedbillno NOT LIKE '%roll%'
    AND storecode NOT LIKE '%demo%'
)
SELECT 
  CASE 
    WHEN availablepoints>=0 AND availablepoints<=100 THEN '0-100'
    WHEN availablepoints>=101 AND availablepoints<=250 THEN '101-250'
    WHEN availablepoints>=251 AND availablepoints<=500 THEN '251-500'
    WHEN availablepoints>=501 AND availablepoints<=1000 THEN '501-1,000'
    ELSE '1,001 and above' 
  END AS available_points_bucket,
  COUNT(DISTINCT CASE WHEN cm.mobile IS NOT NULL THEN m.mobile END) AS curr_month_transactors,
  COUNT(DISTINCT CASE WHEN at.mobile IS NOT NULL THEN m.mobile END) AS customers_till_date
FROM outdoortribes.member_Report m
LEFT JOIN current_month_transactions cm ON m.mobile = cm.mobile
LEFT JOIN all_transactions AT ON m.mobile = at.mobile
GROUP BY 1 ORDER BY  MIN(availablepoints); 


