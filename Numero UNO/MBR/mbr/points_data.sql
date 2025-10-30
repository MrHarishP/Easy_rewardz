

-- Tierwise Points Data 


SET @startdate = DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%Y-%m-01');
SET @enddate = LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH));
SET @startdate_1 = DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 2 MONTH), '%Y-%m-01');
SET @enddate_1 = LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 2 MONTH));


SELECT @startdate,@enddate,@startdate_1,@enddate_1;


 
 WITH base_data AS
(SELECT a.mobile,tier,
SUM(a.pointscollected) AS Points_collected,
SUM(a.pointsspent) AS Points_Redeemed, 
MAX(frequencycount) AS max_fc
FROM `numerouno`.`txn_report_accrual_redemption` a 
JOIN `numerouno`.member_report b  ON a.mobile=b.mobile
WHERE a.insertiondate< CURDATE()
AND txndate BETWEEN  @startdate AND @enddate
AND modifiedbillno NOT LIKE '%brn%'
AND modifiedbillno NOT LIKE '%roll%' AND storecode NOT LIKE '%demo%'
GROUP BY 1)
SELECT 
tier,
COUNT(mobile),
SUM(Points_collected),
SUM(Points_Redeemed),
SUM(CASE WHEN max_fc>1 THEN Points_Redeemed END) AS point_redeemed_by_oldmembers
FROM base_data
GROUP BY 1;



-- Tierwise Points Data 

WITH base_data AS
(SELECT a.mobile,tier,
SUM(a.pointscollected) AS Points_collected
FROM `numerouno`.`txn_report_flat_accrual` a 
JOIN `numerouno`.member_report b  
ON a.mobile=b.mobile
WHERE a.insertiondate< CURDATE()
AND txndate BETWEEN  @startdate AND @enddate
AND modifiedbillno NOT LIKE '%brn%'
AND modifiedbillno NOT LIKE '%roll%' AND storecode NOT LIKE '%demo%'
GROUP BY 1)
SELECT tier,COUNT(mobile),SUM(Points_collected)Flat_Accrual_points
FROM base_data GROUP BY 1;


SELECT MONTHNAME(txndate)mnth,
YEAR(txndate)YEAR,
COUNT(DISTINCT mobile)customer,
SUM(pointscollected)points_collected,
SUM(pointsspent)points_reedemed,
COUNT(DISTINCT CASE WHEN pointsspent>0 THEN mobile END) AS Redeemers,
COUNT(DISTINCT CASE WHEN pointsspent>0 THEN uniquebillno END)AS Redemption_Bills,
SUM(CASE WHEN pointsspent>0 THEN amount END ) AS Redemption_sales 
FROM `numerouno`.txn_report_accrual_redemption 
WHERE storecode<>'demo' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
AND txndate BETWEEN @startdate_1 AND @enddate AND insertiondate<CURDATE() GROUP BY 1;
