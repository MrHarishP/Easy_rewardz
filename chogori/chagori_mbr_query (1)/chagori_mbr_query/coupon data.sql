-- Calculate date ranges-- 
  
  SELECT DATE_FORMAT(CURDATE() - INTERVAL 1 MONTH, '%Y-%m-01') INTO @startdate;
SELECT LAST_DAY(CURDATE() - INTERVAL 1 MONTH) INTO @enddate;


SET @startdate1m = DATE_SUB(@startdate, INTERVAL 1 MONTH);
SET @enddate1m = LAST_DAY(@startdate1m);
SET @startdate1y = DATE_SUB(@startdate, INTERVAL 1 YEAR);
SET @enddate1y = LAST_DAY(@startdate1y);

-- Main query
WITH monthly_data AS (
  SELECT 
    CASE 
      WHEN issueddate BETWEEN @startdate1m AND @enddate1m THEN 'prev_month'
      WHEN issueddate BETWEEN @startdate AND @enddate THEN 'curr_month' 
    END AS month_period,
    couponstatus,
    issuedmobile,
    couponoffercode,
    discount
  FROM coupon_offer_report
  WHERE 
    redeemedstorecode <> 'demo'
    AND issueddate BETWEEN @startdate1m AND @enddate  -- Dynamic date filter
)

SELECT 
  metric AS PERIOD,
  MAX(CASE WHEN month_period = 'prev_month' THEN VALUE END) AS prev_month,
  MAX(CASE WHEN month_period = 'curr_month' THEN VALUE END) AS curr_month
FROM (
  SELECT 'issued' AS metric, month_period, COUNT(*) AS VALUE
  FROM monthly_data
  GROUP BY month_period

  UNION ALL

  SELECT 'redeemers', month_period, COUNT(DISTINCT issuedmobile)
  FROM monthly_data
  WHERE couponstatus = 'Used'
  GROUP BY month_period

  UNION ALL

  SELECT 'coupons_redeemed', month_period, COUNT(couponoffercode)
  FROM monthly_data
  WHERE couponstatus = 'Used'
  GROUP BY month_period

  UNION ALL

  SELECT 'discount', month_period, SUM(discount)
  FROM monthly_data
  GROUP BY month_period
) AS metrics
GROUP BY metric
ORDER BY 
  CASE metric
    WHEN 'issued' THEN 1
    WHEN 'redeemers' THEN 2
    WHEN 'coupons_redeemed' THEN 3
    WHEN 'discount' THEN 4
  END;