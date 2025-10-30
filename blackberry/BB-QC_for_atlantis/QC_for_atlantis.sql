SELECT PERIOD,SUM(sales)Total_sales,SUM(bills)Total_bills,SUM(qty)total_qty FROM (
SELECT CONCAT(LEFT(MONTHNAME(modifiedtxndate),3),RIGHT(YEAR(modifiedtxndate),2))PERIOD,
SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills,SUM(itemqty)qty FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2024-09-01' AND '2025-08-31'
AND modifiedstorecode <> 'demo'
AND modifiedstorecode <> 'corporate'
AND billno NOT LIKE '%test%'
AND billno NOT LIKE '%roll%'
AND itemnetamount>0
GROUP BY 1
ORDER BY modifiedtxndate

UNION 
SELECT CONCAT(LEFT(MONTHNAME(modifiedtxndate),3),RIGHT(YEAR(modifiedtxndate),2))PERIOD,
SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills,SUM(itemqty)qty 
FROM sku_report_nonloyalty 
WHERE modifiedtxndate BETWEEN '2024-09-01' AND '2025-08-31'
AND modifiedstorecode <> 'demo'
AND modifiedstorecode <> 'corporate'
AND billno NOT LIKE '%test%'
AND billno NOT LIKE '%roll%'
AND itemnetamount>0 GROUP BY 1)a
GROUP BY 1;


SELECT COUNT(DISTINCT mobile)Engaged_customer FROM (
SELECT mobile FROM member_report
WHERE modifiedmodifiedEnrolledon BETWEEN '2024-09-01' AND '2025-08-31'
AND enrolledstorecode <> 'demo'
AND enrolledstorecode <> 'corporate'
UNION
SELECT DISTINCT txnmappedmobile AS mobile FROM sku_report_nonloyalty 
WHERE modifiedtxndate BETWEEN '2024-09-01' AND '2025-08-31'
AND modifiedstorecode <> 'demo'
AND modifiedstorecode <> 'corporate'
AND billno NOT LIKE '%test%'
AND billno NOT LIKE '%roll%'
AND itemnetamount>0)a;


SELECT CONCAT(LEFT(MONTHNAME(txndate),3),RIGHT(YEAR(txndate),2))PERIOD,COUNT(DISTINCT mobile)Total_transcted_customer,
SUM(pointscollected)points_issued,SUM(pointsspent)points_redemeed,
COUNT(DISTINCT CASE WHEN pointsspent>0 THEN mobile END)redeemers FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2024-09-01' AND '2025-08-31'
AND storecode <> 'demo'
AND storecode <> 'corporate'
AND billno NOT LIKE '%test%'
AND billno NOT LIKE '%roll%'
AND amount>0
GROUP BY 1
ORDER BY txndate
AND mobile IN (SELECT DISTINCT txnmappedmobile FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2024-09-01' AND '2025-08-31'
AND modifiedstorecode <> 'demo'
AND modifiedstorecode <> 'corporate'
AND billno NOT LIKE '%test%'
AND billno NOT LIKE '%roll%'
AND itemnetamount>0
ORDER BY modifiedtxndate);

SELECT PERIOD,SUM(visit)/COUNT(DISTINCT txnmappedmobile)visit,AVG(visit)visit FROM (
SELECT CONCAT(LEFT(MONTHNAME(modifiedtxndate),3),RIGHT(YEAR(modifiedtxndate),2))PERIOD,
txnmappedmobile,COUNT(DISTINCT modifiedtxndate,txnmappedmobile)visit FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2024-09-01' AND '2025-08-31'
AND modifiedstorecode <> 'demo'
AND modifiedstorecode <> 'corporate'
AND billno NOT LIKE '%test%'
AND billno NOT LIKE '%roll%'
AND itemnetamount>0
GROUP BY 1,2
ORDER BY modifiedtxndate)a
GROUP BY 1
ORDER BY 1;

SELECT SUM(qty)qty FROM (
SELECT SUM(itemqty)qty FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2024-09-01' AND '2025-08-31'
AND modifiedstorecode <> 'demo'
AND modifiedstorecode <> 'corporate'
AND billno NOT LIKE '%test%'
AND billno NOT LIKE '%roll%'
AND itemnetamount>0 
UNION
SELECT SUM(itemqty)qty
FROM sku_report_nonloyalty 
WHERE modifiedtxndate BETWEEN '2024-09-01' AND '2025-08-31'
AND modifiedstorecode <> 'demo'
AND modifiedstorecode <> 'corporate'
AND billno NOT LIKE '%test%'
AND billno NOT LIKE '%roll%'
AND itemnetamount>0)a


SELECT PERIOD,SUM(sales)repeater_sales FROM (
SELECT CONCAT(LEFT(MONTHNAME(modifiedtxndate),3),RIGHT(YEAR(modifiedtxndate),2))PERIOD,txnmappedmobile,SUM(itemnetamount)sales FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2024-09-01' AND '2025-08-31'
AND modifiedstorecode <> 'demo'
AND modifiedstorecode <> 'corporate'
AND billno NOT LIKE '%test%'
AND billno NOT LIKE '%roll%'
AND itemnetamount>0 GROUP BY 1,2
ORDER BY modifiedtxndate)a
GROUP BY 1;


SELECT PERIOD,AVG(recency)recency,AVG(latency)latency FROM(
SELECT CONCAT(LEFT(MONTHNAME(modifiedtxndate),3),RIGHT(YEAR(modifiedtxndate),2))PERIOD,
txnmappedmobile,DATEDIFF('2025-08-31',MAX(modifiedtxndate))recency,
DATEDIFF(MAX(modifiedtxndate),MIN(modifiedtxndate))/NULLIF((COUNT(DISTINCT modifiedtxndate)-1),0)latency
FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2024-09-01' AND '2025-08-31'
AND modifiedstorecode <> 'demo'
AND modifiedstorecode <> 'corporate'
AND billno NOT LIKE '%test%'
AND billno NOT LIKE '%roll%'
AND itemnetamount>0
GROUP BY 1,2 
ORDER BY modifiedtxndate)a
GROUP BY 1;

-- customer sheet 
-- shopped customer 
SELECT COUNT(DISTINCT txnmappedmobile)customers,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN txnmappedmobile END )repeater,
COUNT(DISTINCT CASE WHEN dayssincelastvisit>365 THEN txnmappedmobile END)winback,
COUNT(DISTINCT CASE WHEN modifiedstorecode = 'ecom' THEN txnmappedmobile END)online_buyer
FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2024-09-01' AND '2025-08-31'
AND modifiedstorecode <> 'demo'
AND modifiedstorecode <> 'corporate'
AND billno NOT LIKE '%test%'
AND billno NOT LIKE '%roll%'
AND itemnetamount>0;


SELECT COUNT(DISTINCT mobile)customers,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN mobile END )repeater,
COUNT(DISTINCT CASE WHEN dayssincelastvisit>365 THEN mobile END)winback,
COUNT(DISTINCT CASE WHEN storecode = 'ecom' THEN mobile END)online_buyer
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2024-09-01' AND '2025-08-31'
AND storecode <> 'demo'
AND storecode <> 'corporate'
AND billno NOT LIKE '%test%'
AND billno NOT LIKE '%roll%'
AND amount>0;


-- enrolled 
SELECT COUNT(DISTINCT mobile)enrolled FROM member_report
WHERE modifiedmodifiedEnrolledon BETWEEN '2024-09-01' AND '2025-08-31'
AND enrolledstorecode <> 'demo';


-- redeemer

SELECT COUNT(DISTINCT mobile)redeemerd
FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2024-09-01' AND '2025-08-31'
AND storecode <> 'demo'
AND storecode <> 'corporate'
AND billno NOT LIKE '%test%'
AND billno NOT LIKE '%roll%'
AND pointsspent>0
AND amount>0;



-- demographics





WITH sku AS (
    SELECT 
        gender,
        CASE 
            WHEN customerage BETWEEN 0 AND 18 THEN '0-18'
            WHEN customerage BETWEEN 19 AND 35 THEN '19-35'
            WHEN customerage BETWEEN 36 AND 60 THEN '36-60'
            WHEN customerage > 60 THEN '>60'
            ELSE 'unmapped' 
        END AS customerage,
        COUNT(DISTINCT txnmappedmobile) AS Shoppedcustomers,
        COUNT(DISTINCT CASE WHEN frequencycount > 1 THEN txnmappedmobile END) AS repeater,
        COUNT(DISTINCT CASE WHEN dayssincelastvisit > 365 THEN txnmappedmobile END) AS winback,
        COUNT(DISTINCT CASE WHEN modifiedstorecode = 'ecom' THEN txnmappedmobile END) AS online_customers,
        COUNT(DISTINCT CASE WHEN modifiedstorecode <> 'ecom' THEN txnmappedmobile END) AS offline_customer,
        SUM(itemnetamount) AS Loyalty_sales,
        COUNT(DISTINCT CASE WHEN modifiedtxndate BETWEEN '2024-09-01' AND '2025-08-31' THEN txnmappedmobile END) AS active_customer
    FROM sku_report_loyalty a 
    JOIN member_report b ON a.txnmappedmobile = b.mobile
    WHERE modifiedtxndate BETWEEN '2024-09-01' AND '2025-08-31'
      AND modifiedstorecode NOT IN ('demo','corporate')
      AND billno NOT LIKE '%test%'
      AND billno NOT LIKE '%roll%'
      AND itemnetamount > 0
    GROUP BY 1,2
),

enrolled AS (
    SELECT 
        gender,
        CASE 
            WHEN customerage BETWEEN 0 AND 18 THEN '0-18'
            WHEN customerage BETWEEN 19 AND 35 THEN '19-35'
            WHEN customerage BETWEEN 36 AND 60 THEN '36-60'
            WHEN customerage > 60 THEN '>60'
            ELSE 'unmapped' 
        END AS customerage,
        COUNT(DISTINCT mobile) AS enrolled
    FROM member_report 
    WHERE modifiedEnrolledon BETWEEN '2024-09-01' AND '2025-08-31'
      AND enrolledstorecode NOT IN ('demo','corporate')
    GROUP BY 1,2
),

txn AS (
    SELECT 
        gender,
        CASE 
            WHEN customerage BETWEEN 0 AND 18 THEN '0-18'
            WHEN customerage BETWEEN 19 AND 35 THEN '19-35'
            WHEN customerage BETWEEN 36 AND 60 THEN '36-60'
            WHEN customerage > 60 THEN '>60'
            ELSE 'unmapped' 
        END AS customerage,
        COUNT(DISTINCT CASE WHEN a.pointsspent > 0 THEN a.mobile END) AS redeem_customers,
        COUNT(DISTINCT CASE WHEN a.pointsspent = 0 OR a.pointsspent IS NULL THEN a.mobile END) AS non_redeem_customers
    FROM txn_report_accrual_redemption a 
    JOIN member_report b USING(mobile)
    WHERE txndate BETWEEN '2024-09-01' AND '2025-08-31'
      AND storecode NOT IN ('demo','corporate')
      AND billno NOT LIKE '%test%'
      AND billno NOT LIKE '%roll%' 
    GROUP BY 1,2
)

SELECT 

    a.gender,
    a.customerage,
    a.Shoppedcustomers,
    a.repeater,
    a.winback,
    a.online_customers,
    a.offline_customer,
    a.Loyalty_sales,
    a.active_customer,
    c.redeem_customers,
    c.non_redeem_customers,
    b.enrolled
FROM sku a
LEFT JOIN enrolled b 
  ON 
   a.gender = b.gender 
  AND a.customerage = b.customerage
LEFT JOIN txn c 
  ON 
   a.gender = c.gender 
  AND a.customerage = c.customerage;

WITH txn AS (
SELECT 
        gender,
        CASE 
            WHEN customerage BETWEEN 0 AND 18 THEN '0-18'
            WHEN customerage BETWEEN 19 AND 35 THEN '19-35'
            WHEN customerage BETWEEN 36 AND 60 THEN '36-60'
            WHEN customerage > 60 THEN '>60'
            ELSE 'unmapped' 
        END AS customerage,
        COUNT(DISTINCT a.mobile) AS Shoppedcustomers,
        COUNT(DISTINCT CASE WHEN frequencycount > 1 THEN a.mobile END) AS repeater,
        COUNT(DISTINCT CASE WHEN dayssincelastvisit > 365 THEN a.mobile END) AS winback,
        COUNT(DISTINCT CASE WHEN storecode = 'ecom' THEN a.mobile END) AS online_customers,
        COUNT(DISTINCT CASE WHEN storecode <> 'ecom' THEN a.mobile END) AS offline_customer,
        SUM(amount) AS Loyalty_sales,
        COUNT(DISTINCT CASE WHEN txndate BETWEEN '2024-09-01' AND '2025-08-31' THEN a.mobile END) AS active_customer,
        COUNT(DISTINCT CASE WHEN a.pointsspent > 0 THEN a.mobile END) AS redeem_customers,
        COUNT(DISTINCT CASE WHEN a.pointsspent = 0 OR a.pointsspent IS NULL THEN a.mobile END) AS non_redeem_customers
    FROM txn_report_accrual_redemption a 
    JOIN member_report b ON a.mobile = b.mobile
    WHERE txndate BETWEEN '2024-09-01' AND '2025-08-31'
      AND storecode NOT IN ('demo','corporate')
      AND billno NOT LIKE '%test%'
      AND billno NOT LIKE '%roll%'
      AND amount > 0
    GROUP BY 1,2),
    
    enrolled AS (
    SELECT 
        gender,
        CASE 
            WHEN customerage BETWEEN 0 AND 18 THEN '0-18'
            WHEN customerage BETWEEN 19 AND 35 THEN '19-35'
            WHEN customerage BETWEEN 36 AND 60 THEN '36-60'
            WHEN customerage > 60 THEN '>60'
            ELSE 'unmapped' 
        END AS customerage,
        COUNT(DISTINCT mobile) AS enrolled
    FROM member_report 
    WHERE modifiedmodifiedEnrolledon BETWEEN '2024-09-01' AND '2025-08-31'
      AND enrolledstorecode NOT IN ('demo','corporate')
    GROUP BY 1,2
)

SELECT 

    a.gender,
    a.customerage,
    a.Shoppedcustomers,
    a.repeater,
    a.winback,
    a.online_customers,
    a.offline_customer,
    a.Loyalty_sales,
    a.active_customer,
    a.redeem_customers,
    a.non_redeem_customers,
    b.enrolled
FROM txn a
LEFT JOIN enrolled b 
  ON 
   a.gender = b.gender 
  AND a.customerage = b.customerage;
  
  
--   location wise


SELECT region,city,state,COUNT(DISTINCT mobile)customers 
FROM txn_report_accrual_redemption a JOIN store_master b USING(storecode)
WHERE txndate BETWEEN '2024-09-01' AND '2025-08-31'
AND storecode NOT IN ('demo','corporate')
AND billno NOT LIKE '%test%'
AND billno NOT LIKE '%roll%'
AND amount > 0
GROUP BY 1,2,3;

-- tier wise 


SELECT tier,COUNT(DISTINCT mobile)customer FROM member_report 
WHERE enrolledstorecode <> 'demo'
GROUP BY 1;


SELECT tier,COUNT(DISTINCT mobile)customer FROM txn_report_accrual_redemption a JOIN 
member_report b USING(mobile)
WHERE txndate BETWEEN '2024-09-01' AND '2025-08-31'
AND storecode NOT IN ('demo','corporate')
AND billno NOT LIKE '%test%'
AND billno NOT LIKE '%roll%'
AND amount > 0
GROUP BY 1;


SELECT CONCAT(LEFT(MONTHNAME(txndate),3),RIGHT(YEAR(txndate),2))PERIOD,COUNT(DISTINCT mobile)shopped,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN mobile END )repeater,
COUNT(DISTINCT CASE WHEN dayssincelastvisit>365 THEN mobile END)Reactive,
COUNT(DISTINCT CASE WHEN pointsspent>0 THEN mobile END)redeemers,

FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2024-09-01' AND '2025-08-31'
AND storecode <> 'demo'
AND storecode <> 'corporate'
AND billno NOT LIKE '%test%'
AND billno NOT LIKE '%roll%'
AND amount>0s
GROUP BY 1
ORDER BY txndate;

SELECT 
SELECT mobile,DATEDIFF('2025-08-31',MAX(txndate))recency FROM 
txn_report_accrual_redemption 
WHERE txndate <='2025-08-31'
AND storecode <> 'demo'
AND storecode <> 'corporate'
AND billno NOT LIKE '%test%'
AND billno NOT LIKE '%roll%'
AND amount>0
GROUP BY 1
ORDER BY txndate;

SELECT CASE WHEN DAYNAME(txndate) IN ('Saturday','sunday') THEN 'weekend' ELSE 'weekday' END PERIOD,
COUNT(DISTINCT mobile)shopped FROM
txn_report_accrual_redemption 
WHERE txndate BETWEEN '2025-06-06' AND '2025-06-10'
AND storecode <> 'demo'
AND storecode <> 'corporate'
AND billno NOT LIKE '%test%'
AND billno NOT LIKE '%roll%'

AND amount>0
GROUP BY 1;
########################################3
-- Transacted
SELECT 
    CASE 
	WHEN txndate BETWEEN '2025-06-06' AND '2025-06-10' THEN 'Bakhrid'
	WHEN txndate BETWEEN '2024-11-01' AND '2024-11-05' THEN 'Bhai dooj'
	WHEN txndate BETWEEN '2025-05-08' AND '2025-05-13' THEN 'Buddha Purnima'
	WHEN txndate BETWEEN '2024-11-06' AND '2024-11-10' THEN 'Chhat Puja'
	WHEN txndate BETWEEN '2024-11-11' AND '2024-11-15' THEN 'Children day'
	WHEN txndate BETWEEN '2024-12-22' AND '2024-12-28' THEN 'Christmas'
	WHEN txndate BETWEEN '2024-10-24' AND '2024-10-31' THEN 'Diwali'
	WHEN txndate BETWEEN '2024-10-03' AND '2024-10-12' THEN 'Dusshera'
	WHEN txndate BETWEEN '2025-06-12' AND '2025-06-18' THEN 'Fathers day'
	WHEN txndate BETWEEN '2024-10-01' AND '2024-10-02' THEN 'Gandhi Jayanti'
	WHEN txndate BETWEEN '2024-09-05' AND '2024-09-30' THEN 'Ganesh Chaturthi' #hold
	WHEN txndate BETWEEN '2025-04-17' AND '2025-04-22' THEN 'Good friday'
	WHEN txndate BETWEEN '2025-03-27' AND '2025-03-31' THEN 'Gudi padwa'
	WHEN txndate BETWEEN '2024-11-16' AND '2024-11-17' THEN 'Guru nanak Jayanti'
	WHEN txndate BETWEEN '2025-03-13' AND '2025-03-17' THEN 'Holi'
	WHEN txndate BETWEEN '2024-09-15' AND '2024-09-21' THEN 'Id-E-Milad'
	WHEN txndate BETWEEN '2025-08-11' AND '2025-08-15' THEN 'Independence day'
	WHEN txndate BETWEEN '2025-08-16' AND '2025-08-19' THEN 'Janmashthami'
	WHEN txndate BETWEEN '2024-10-18' AND '2024-10-21' THEN 'Karva Chauth'
	WHEN txndate BETWEEN '2025-02-23' AND '2025-02-27' THEN 'Mahashivratri'
	WHEN txndate BETWEEN '2025-04-10' AND '2025-04-13' THEN 'Mahavir jayanti'
	WHEN txndate BETWEEN '2025-01-14' AND '2025-01-19' THEN 'Makar sakranti'
	WHEN txndate BETWEEN '2025-05-14' AND '2025-05-15' THEN 'Mother day'
	WHEN txndate BETWEEN '2025-07-04' AND '2025-07-09' THEN 'Muharram'
	WHEN txndate BETWEEN '2025-01-01' AND '2025-01-08' THEN 'New Year Celebration'
	WHEN txndate BETWEEN '2024-09-12' AND '2024-09-14' THEN 'Onam'
	WHEN txndate BETWEEN '2025-08-07' AND '2025-08-10' THEN 'Raksha bandhan'
	WHEN txndate BETWEEN '2025-04-05' AND '2025-04-09' THEN 'Ram navmi'
	WHEN txndate BETWEEN '2025-04-01' AND '2025-04-04' THEN 'RamZan'
	WHEN txndate BETWEEN '2025-01-26' AND '2025-01-29' THEN 'Republic day'
	WHEN txndate BETWEEN '2025-02-11' AND '2025-02-17' THEN 'Valentine week'
	WHEN txndate BETWEEN '2025-08-06' AND '2025-08-06' THEN 'Woman day'
	END PERIOD,
        

    -- 👥 Unique Customers
    COUNT(DISTINCT CASE WHEN DAYOFWEEK(txndate) IN (1,7) THEN mobile END) AS Weekend_Customers,
    COUNT(DISTINCT CASE WHEN DAYOFWEEK(txndate) NOT IN (1,7) THEN mobile END) AS Weekday_Customers
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2024-09-01' AND '2025-08-31'
AND storecode NOT IN ('demo','corporate')
AND billno NOT LIKE '%test%'
AND billno NOT LIKE '%roll%'
AND amount > 0
GROUP BY 1;

-- enrollment

SELECT 
    CASE 
	WHEN modifiedEnrolledon BETWEEN '2025-06-06' AND '2025-06-10' THEN 'Bakhrid'
	WHEN modifiedEnrolledon BETWEEN '2024-11-01' AND '2024-11-05' THEN 'Bhai dooj'
	WHEN modifiedEnrolledon BETWEEN '2025-05-08' AND '2025-05-13' THEN 'Buddha Purnima'
	WHEN modifiedEnrolledon BETWEEN '2024-11-06' AND '2024-11-10' THEN 'Chhat Puja'
	WHEN modifiedEnrolledon BETWEEN '2024-11-11' AND '2024-11-15' THEN 'Children day'
	WHEN modifiedEnrolledon BETWEEN '2024-12-22' AND '2024-12-28' THEN 'Christmas'
	WHEN modifiedEnrolledon BETWEEN '2024-10-24' AND '2024-10-31' THEN 'Diwali'
	WHEN modifiedEnrolledon BETWEEN '2024-10-03' AND '2024-10-12' THEN 'Dusshera'
	WHEN modifiedEnrolledon BETWEEN '2025-06-12' AND '2025-06-18' THEN 'Fathers day'
	WHEN modifiedEnrolledon BETWEEN '2024-10-01' AND '2024-10-02' THEN 'Gandhi Jayanti'
	WHEN modifiedEnrolledon BETWEEN '2025-08-24' AND '2025-08-30' THEN 'Ganesh Chaturthi' #hold
	WHEN modifiedEnrolledon BETWEEN '2025-04-17' AND '2025-04-22' THEN 'Good friday'
	WHEN modifiedEnrolledon BETWEEN '2025-03-27' AND '2025-03-31' THEN 'Gudi padwa'
	WHEN modifiedEnrolledon BETWEEN '2024-11-16' AND '2024-11-17' THEN 'Guru nanak Jayanti'
	WHEN modifiedEnrolledon BETWEEN '2025-03-13' AND '2025-03-17' THEN 'Holi'
	WHEN modifiedEnrolledon BETWEEN '2024-09-15' AND '2024-09-21' THEN 'Id-E-Milad'
	WHEN modifiedEnrolledon BETWEEN '2025-08-11' AND '2025-08-15' THEN 'Independence day'
	WHEN modifiedEnrolledon BETWEEN '2025-08-16' AND '2025-08-19' THEN 'Janmashthami'
	WHEN modifiedEnrolledon BETWEEN '2024-10-18' AND '2024-10-21' THEN 'Karva Chauth'
	WHEN modifiedEnrolledon BETWEEN '2025-02-23' AND '2025-02-27' THEN 'Mahashivratri'
	WHEN modifiedEnrolledon BETWEEN '2025-04-10' AND '2025-04-13' THEN 'Mahavir jayanti'
	WHEN modifiedEnrolledon BETWEEN '2025-01-14' AND '2025-01-19' THEN 'Makar sakranti'
	WHEN modifiedEnrolledon BETWEEN '2025-05-14' AND '2025-05-15' THEN 'Mother day'
	WHEN modifiedEnrolledon BETWEEN '2025-07-04' AND '2025-07-09' THEN 'Muharram'
	WHEN modifiedEnrolledon BETWEEN '2025-01-01' AND '2025-01-08' THEN 'New Year Celebration'
	WHEN modifiedEnrolledon BETWEEN '2024-09-12' AND '2024-09-14' THEN 'Onam'
	WHEN modifiedEnrolledon BETWEEN '2025-08-07' AND '2025-08-10' THEN 'Raksha bandhan'
	WHEN modifiedEnrolledon BETWEEN '2025-04-05' AND '2025-04-09' THEN 'Ram navmi'
	WHEN modifiedEnrolledon BETWEEN '2025-04-01' AND '2025-04-04' THEN 'RamZan'
	WHEN modifiedEnrolledon BETWEEN '2025-01-26' AND '2025-01-29' THEN 'Republic day'
	WHEN modifiedEnrolledon BETWEEN '2025-02-11' AND '2025-02-17' THEN 'Valentine week'
	WHEN modifiedEnrolledon BETWEEN '2025-08-06' AND '2025-08-06' THEN 'Woman day'
	END PERIOD,
        

-- Unique Customers
COUNT(DISTINCT CASE WHEN DAYOFWEEK(modifiedEnrolledon) IN (1,7) THEN mobile END) AS Weekend_Customers,
COUNT(DISTINCT CASE WHEN DAYOFWEEK(modifiedEnrolledon) NOT IN (1,7) THEN mobile END) AS Weekday_Customers
FROM Member_report 
WHERE modifiedEnrolledon BETWEEN '2024-09-01' AND '2025-08-31'
AND enrolledstorecode NOT IN ('demo','corporate')
GROUP BY 1;

########################################3
-- Transacted
SELECT 
    CASE 
	WHEN txndate BETWEEN '2025-06-06' AND '2025-06-10' THEN 'Bakhrid'
	WHEN txndate BETWEEN '2024-11-01' AND '2024-11-05' THEN 'Bhai dooj'
	WHEN txndate BETWEEN '2025-05-08' AND '2025-05-13' THEN 'Buddha Purnima'
	WHEN txndate BETWEEN '2024-11-06' AND '2024-11-10' THEN 'Chhat Puja'
	WHEN txndate BETWEEN '2024-11-11' AND '2024-11-15' THEN 'Children day'
	WHEN txndate BETWEEN '2024-12-22' AND '2024-12-28' THEN 'Christmas'
	WHEN txndate BETWEEN '2024-10-24' AND '2024-10-31' THEN 'Diwali'
	WHEN txndate BETWEEN '2024-10-03' AND '2024-10-12' THEN 'Dusshera'
	WHEN txndate BETWEEN '2025-06-12' AND '2025-06-18' THEN 'Fathers day'
	WHEN txndate BETWEEN '2024-10-01' AND '2024-10-02' THEN 'Gandhi Jayanti'
	WHEN txndate BETWEEN '2025-08-24' AND '2025-08-30' THEN 'Ganesh Chaturthi' #hold
	WHEN txndate BETWEEN '2025-04-17' AND '2025-04-22' THEN 'Good friday'
	WHEN txndate BETWEEN '2025-03-27' AND '2025-03-31' THEN 'Gudi padwa'
	WHEN txndate BETWEEN '2024-11-16' AND '2024-11-17' THEN 'Guru nanak Jayanti'
	WHEN txndate BETWEEN '2025-03-13' AND '2025-03-17' THEN 'Holi'
	WHEN txndate BETWEEN '2024-09-15' AND '2024-09-21' THEN 'Id-E-Milad'
	WHEN txndate BETWEEN '2025-08-11' AND '2025-08-15' THEN 'Independence day'
	WHEN txndate BETWEEN '2025-08-16' AND '2025-08-19' THEN 'Janmashthami'
	WHEN txndate BETWEEN '2024-10-18' AND '2024-10-21' THEN 'Karva Chauth'
	WHEN txndate BETWEEN '2025-02-23' AND '2025-02-27' THEN 'Mahashivratri'
	WHEN txndate BETWEEN '2025-04-10' AND '2025-04-13' THEN 'Mahavir jayanti'
	WHEN txndate BETWEEN '2025-01-14' AND '2025-01-19' THEN 'Makar sakranti'
	WHEN txndate BETWEEN '2025-05-14' AND '2025-05-15' THEN 'Mother day'
	WHEN txndate BETWEEN '2025-07-04' AND '2025-07-09' THEN 'Muharram'
	WHEN txndate BETWEEN '2025-01-01' AND '2025-01-08' THEN 'New Year Celebration'
	WHEN txndate BETWEEN '2024-09-12' AND '2024-09-14' THEN 'Onam'
	WHEN txndate BETWEEN '2025-08-07' AND '2025-08-10' THEN 'Raksha bandhan'
	WHEN txndate BETWEEN '2025-04-05' AND '2025-04-09' THEN 'Ram navmi'
	WHEN txndate BETWEEN '2025-04-01' AND '2025-04-04' THEN 'RamZan'
	WHEN txndate BETWEEN '2025-01-26' AND '2025-01-29' THEN 'Republic day'
	WHEN txndate BETWEEN '2025-02-11' AND '2025-02-17' THEN 'Valentine week'
	WHEN txndate BETWEEN '2025-08-06' AND '2025-08-06' THEN 'Woman day'
	END PERIOD,
        CASE WHEN pointsspent>0 THEN 'redeemer' ELSE 'nonRedeemer' END redeemer,

    -- 👥 Unique Customers
    COUNT(DISTINCT CASE WHEN DAYOFWEEK(txndate) IN (1,7) THEN mobile END) AS Weekend_Customers,
    COUNT(DISTINCT CASE WHEN DAYOFWEEK(txndate) NOT IN (1,7) THEN mobile END) AS Weekday_Customers
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2024-09-01' AND '2025-08-31'
AND storecode NOT IN ('demo','corporate')
AND billno NOT LIKE '%test%'
AND billno NOT LIKE '%roll%'
AND amount > 0
GROUP BY 1,2;


########################################3
-- online
SELECT 
    CASE 
	WHEN txndate BETWEEN '2025-06-06' AND '2025-06-10' THEN 'Bakhrid'
	WHEN txndate BETWEEN '2024-11-01' AND '2024-11-05' THEN 'Bhai dooj'
	WHEN txndate BETWEEN '2025-05-08' AND '2025-05-13' THEN 'Buddha Purnima'
	WHEN txndate BETWEEN '2024-11-06' AND '2024-11-10' THEN 'Chhat Puja'
	WHEN txndate BETWEEN '2024-11-11' AND '2024-11-15' THEN 'Children day'
	WHEN txndate BETWEEN '2024-12-22' AND '2024-12-28' THEN 'Christmas'
	WHEN txndate BETWEEN '2024-10-24' AND '2024-10-31' THEN 'Diwali'
	WHEN txndate BETWEEN '2024-10-03' AND '2024-10-12' THEN 'Dusshera'
	WHEN txndate BETWEEN '2025-06-12' AND '2025-06-18' THEN 'Fathers day'
	WHEN txndate BETWEEN '2024-10-01' AND '2024-10-02' THEN 'Gandhi Jayanti'
	WHEN txndate BETWEEN '2025-08-24' AND '2025-08-30' THEN 'Ganesh Chaturthi' #hold
	WHEN txndate BETWEEN '2025-04-17' AND '2025-04-22' THEN 'Good friday'
	WHEN txndate BETWEEN '2025-03-27' AND '2025-03-31' THEN 'Gudi padwa'
	WHEN txndate BETWEEN '2024-11-16' AND '2024-11-17' THEN 'Guru nanak Jayanti'
	WHEN txndate BETWEEN '2025-03-13' AND '2025-03-17' THEN 'Holi'
	WHEN txndate BETWEEN '2024-09-15' AND '2024-09-21' THEN 'Id-E-Milad'
	WHEN txndate BETWEEN '2025-08-11' AND '2025-08-15' THEN 'Independence day'
	WHEN txndate BETWEEN '2025-08-16' AND '2025-08-19' THEN 'Janmashthami'
	WHEN txndate BETWEEN '2024-10-18' AND '2024-10-21' THEN 'Karva Chauth'
	WHEN txndate BETWEEN '2025-02-23' AND '2025-02-27' THEN 'Mahashivratri'
	WHEN txndate BETWEEN '2025-04-10' AND '2025-04-13' THEN 'Mahavir jayanti'
	WHEN txndate BETWEEN '2025-01-14' AND '2025-01-19' THEN 'Makar sakranti'
	WHEN txndate BETWEEN '2025-05-14' AND '2025-05-15' THEN 'Mother day'
	WHEN txndate BETWEEN '2025-07-04' AND '2025-07-09' THEN 'Muharram'
	WHEN txndate BETWEEN '2025-01-01' AND '2025-01-08' THEN 'New Year Celebration'
	WHEN txndate BETWEEN '2024-09-12' AND '2024-09-14' THEN 'Onam'
	WHEN txndate BETWEEN '2025-08-07' AND '2025-08-10' THEN 'Raksha bandhan'
	WHEN txndate BETWEEN '2025-04-05' AND '2025-04-09' THEN 'Ram navmi'
	WHEN txndate BETWEEN '2025-04-01' AND '2025-04-04' THEN 'RamZan'
	WHEN txndate BETWEEN '2025-01-26' AND '2025-01-29' THEN 'Republic day'
	WHEN txndate BETWEEN '2025-02-11' AND '2025-02-17' THEN 'Valentine week'
	WHEN txndate BETWEEN '2025-08-06' AND '2025-08-06' THEN 'Woman day'
	END PERIOD,
        

    -- 👥 Unique Customers
    COUNT(DISTINCT CASE WHEN DAYOFWEEK(txndate) IN (1,7) THEN mobile END) AS Weekend_Customers,
    COUNT(DISTINCT CASE WHEN DAYOFWEEK(txndate) NOT IN (1,7) THEN mobile END) AS Weekday_Customers
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2024-09-01' AND '2025-08-31'
AND storecode NOT IN ('demo','corporate')
AND billno NOT LIKE '%test%'
AND billno NOT LIKE '%roll%'
AND amount > 0
AND storecode ='ecom'
GROUP BY 1;


########################################3
-- offline
SELECT 
    CASE 
	WHEN txndate BETWEEN '2025-06-06' AND '2025-06-10' THEN 'Bakhrid'
	WHEN txndate BETWEEN '2024-11-01' AND '2024-11-05' THEN 'Bhai dooj'
	WHEN txndate BETWEEN '2025-05-08' AND '2025-05-13' THEN 'Buddha Purnima'
	WHEN txndate BETWEEN '2024-11-06' AND '2024-11-10' THEN 'Chhat Puja'
	WHEN txndate BETWEEN '2024-11-11' AND '2024-11-15' THEN 'Children day'
	WHEN txndate BETWEEN '2024-12-22' AND '2024-12-28' THEN 'Christmas'
	WHEN txndate BETWEEN '2024-10-24' AND '2024-10-31' THEN 'Diwali'
	WHEN txndate BETWEEN '2024-10-03' AND '2024-10-12' THEN 'Dusshera'
	WHEN txndate BETWEEN '2025-06-12' AND '2025-06-18' THEN 'Fathers day'
	WHEN txndate BETWEEN '2024-10-01' AND '2024-10-02' THEN 'Gandhi Jayanti'
	WHEN txndate BETWEEN '2025-08-24' AND '2025-08-30' THEN 'Ganesh Chaturthi' #hold
	WHEN txndate BETWEEN '2025-04-17' AND '2025-04-22' THEN 'Good friday'
	WHEN txndate BETWEEN '2025-03-27' AND '2025-03-31' THEN 'Gudi padwa'
	WHEN txndate BETWEEN '2024-11-16' AND '2024-11-17' THEN 'Guru nanak Jayanti'
	WHEN txndate BETWEEN '2025-03-13' AND '2025-03-17' THEN 'Holi'
	WHEN txndate BETWEEN '2024-09-15' AND '2024-09-21' THEN 'Id-E-Milad'
	WHEN txndate BETWEEN '2025-08-11' AND '2025-08-15' THEN 'Independence day'
	WHEN txndate BETWEEN '2025-08-16' AND '2025-08-19' THEN 'Janmashthami'
	WHEN txndate BETWEEN '2024-10-18' AND '2024-10-21' THEN 'Karva Chauth'
	WHEN txndate BETWEEN '2025-02-23' AND '2025-02-27' THEN 'Mahashivratri'
	WHEN txndate BETWEEN '2025-04-10' AND '2025-04-13' THEN 'Mahavir jayanti'
	WHEN txndate BETWEEN '2025-01-14' AND '2025-01-19' THEN 'Makar sakranti'
	WHEN txndate BETWEEN '2025-05-14' AND '2025-05-15' THEN 'Mother day'
	WHEN txndate BETWEEN '2025-07-04' AND '2025-07-09' THEN 'Muharram'
	WHEN txndate BETWEEN '2025-01-01' AND '2025-01-08' THEN 'New Year Celebration'
	WHEN txndate BETWEEN '2024-09-12' AND '2024-09-14' THEN 'Onam'
	WHEN txndate BETWEEN '2025-08-07' AND '2025-08-10' THEN 'Raksha bandhan'
	WHEN txndate BETWEEN '2025-04-05' AND '2025-04-09' THEN 'Ram navmi'
	WHEN txndate BETWEEN '2025-04-01' AND '2025-04-04' THEN 'RamZan'
	WHEN txndate BETWEEN '2025-01-26' AND '2025-01-29' THEN 'Republic day'
	WHEN txndate BETWEEN '2025-02-11' AND '2025-02-17' THEN 'Valentine week'
	WHEN txndate BETWEEN '2025-08-06' AND '2025-08-06' THEN 'Woman day'
	END PERIOD,
        

    -- 👥 Unique Customers
    COUNT(DISTINCT CASE WHEN DAYOFWEEK(txndate) IN (1,7) THEN mobile END) AS Weekend_Customers,
    COUNT(DISTINCT CASE WHEN DAYOFWEEK(txndate) NOT IN (1,7) THEN mobile END) AS Weekday_Customers
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2024-09-01' AND '2025-08-31'
AND storecode NOT IN ('demo','corporate')
AND billno NOT LIKE '%test%'
AND billno NOT LIKE '%roll%'
AND amount > 0
AND storecode <> 'ecom'
GROUP BY 1;


########################################3
-- loyalt sales
SELECT 
    CASE 
	WHEN txndate BETWEEN '2025-06-06' AND '2025-06-10' THEN 'Bakhrid'
	WHEN txndate BETWEEN '2024-11-01' AND '2024-11-05' THEN 'Bhai dooj'
	WHEN txndate BETWEEN '2025-05-08' AND '2025-05-13' THEN 'Buddha Purnima'
	WHEN txndate BETWEEN '2024-11-06' AND '2024-11-10' THEN 'Chhat Puja'
	WHEN txndate BETWEEN '2024-11-11' AND '2024-11-15' THEN 'Children day'
	WHEN txndate BETWEEN '2024-12-22' AND '2024-12-28' THEN 'Christmas'
	WHEN txndate BETWEEN '2024-10-24' AND '2024-10-31' THEN 'Diwali'
	WHEN txndate BETWEEN '2024-10-03' AND '2024-10-12' THEN 'Dusshera'
	WHEN txndate BETWEEN '2025-06-12' AND '2025-06-18' THEN 'Fathers day'
	WHEN txndate BETWEEN '2024-10-01' AND '2024-10-02' THEN 'Gandhi Jayanti'
	WHEN txndate BETWEEN '2025-08-24' AND '2025-08-30' THEN 'Ganesh Chaturthi' #hold
	WHEN txndate BETWEEN '2025-04-17' AND '2025-04-22' THEN 'Good friday'
	WHEN txndate BETWEEN '2025-03-27' AND '2025-03-31' THEN 'Gudi padwa'
	WHEN txndate BETWEEN '2024-11-16' AND '2024-11-17' THEN 'Guru nanak Jayanti'
	WHEN txndate BETWEEN '2025-03-13' AND '2025-03-17' THEN 'Holi'
	WHEN txndate BETWEEN '2024-09-15' AND '2024-09-21' THEN 'Id-E-Milad'
	WHEN txndate BETWEEN '2025-08-11' AND '2025-08-15' THEN 'Independence day'
	WHEN txndate BETWEEN '2025-08-16' AND '2025-08-19' THEN 'Janmashthami'
	WHEN txndate BETWEEN '2024-10-18' AND '2024-10-21' THEN 'Karva Chauth'
	WHEN txndate BETWEEN '2025-02-23' AND '2025-02-27' THEN 'Mahashivratri'
	WHEN txndate BETWEEN '2025-04-10' AND '2025-04-13' THEN 'Mahavir jayanti'
	WHEN txndate BETWEEN '2025-01-14' AND '2025-01-19' THEN 'Makar sakranti'
	WHEN txndate BETWEEN '2025-05-14' AND '2025-05-15' THEN 'Mother day'
	WHEN txndate BETWEEN '2025-07-04' AND '2025-07-09' THEN 'Muharram'
	WHEN txndate BETWEEN '2025-01-01' AND '2025-01-08' THEN 'New Year Celebration'
	WHEN txndate BETWEEN '2024-09-12' AND '2024-09-14' THEN 'Onam'
	WHEN txndate BETWEEN '2025-08-07' AND '2025-08-10' THEN 'Raksha bandhan'
	WHEN txndate BETWEEN '2025-04-05' AND '2025-04-09' THEN 'Ram navmi'
	WHEN txndate BETWEEN '2025-04-01' AND '2025-04-04' THEN 'RamZan'
	WHEN txndate BETWEEN '2025-01-26' AND '2025-01-29' THEN 'Republic day'
	WHEN txndate BETWEEN '2025-02-11' AND '2025-02-17' THEN 'Valentine week'
	WHEN txndate BETWEEN '2025-08-06' AND '2025-08-06' THEN 'Woman day'
	END PERIOD,
        

    -- 👥 Unique Customers
    SUM(CASE WHEN DAYOFWEEK(txndate) IN (1,7) THEN amount END) AS Weekend_Customers,
    SUM(CASE WHEN DAYOFWEEK(txndate) NOT IN (1,7) THEN amount END) AS Weekday_Customers
FROM `blackberrys`.txn_report_accrual_redemption 
WHERE txndate BETWEEN '2024-09-01' AND '2025-08-31'
AND storecode NOT IN ('demo','corporate')
AND billno NOT LIKE '%test%'
AND billno NOT LIKE '%roll%'
AND amount > 0
GROUP BY 1;


-- Repeater
SELECT 
    CASE 
	WHEN txndate BETWEEN '2025-06-06' AND '2025-06-10' THEN 'Bakhrid'
	WHEN txndate BETWEEN '2024-11-01' AND '2024-11-05' THEN 'Bhai dooj'
	WHEN txndate BETWEEN '2025-05-08' AND '2025-05-13' THEN 'Buddha Purnima'
	WHEN txndate BETWEEN '2024-11-06' AND '2024-11-10' THEN 'Chhat Puja'
	WHEN txndate BETWEEN '2024-11-11' AND '2024-11-15' THEN 'Children day'
	WHEN txndate BETWEEN '2024-12-22' AND '2024-12-28' THEN 'Christmas'
	WHEN txndate BETWEEN '2024-10-24' AND '2024-10-31' THEN 'Diwali'
	WHEN txndate BETWEEN '2024-10-03' AND '2024-10-12' THEN 'Dusshera'
	WHEN txndate BETWEEN '2025-06-12' AND '2025-06-18' THEN 'Fathers day'
	WHEN txndate BETWEEN '2024-10-01' AND '2024-10-02' THEN 'Gandhi Jayanti'
	WHEN txndate BETWEEN '2025-08-24' AND '2025-08-30' THEN 'Ganesh Chaturthi' #hold
	WHEN txndate BETWEEN '2025-04-17' AND '2025-04-22' THEN 'Good friday'
	WHEN txndate BETWEEN '2025-03-27' AND '2025-03-31' THEN 'Gudi padwa'
	WHEN txndate BETWEEN '2024-11-16' AND '2024-11-17' THEN 'Guru nanak Jayanti'
	WHEN txndate BETWEEN '2025-03-13' AND '2025-03-17' THEN 'Holi'
	WHEN txndate BETWEEN '2024-09-15' AND '2024-09-21' THEN 'Id-E-Milad'
	WHEN txndate BETWEEN '2025-08-11' AND '2025-08-15' THEN 'Independence day'
	WHEN txndate BETWEEN '2025-08-16' AND '2025-08-19' THEN 'Janmashthami'
	WHEN txndate BETWEEN '2024-10-18' AND '2024-10-21' THEN 'Karva Chauth'
	WHEN txndate BETWEEN '2025-02-23' AND '2025-02-27' THEN 'Mahashivratri'
	WHEN txndate BETWEEN '2025-04-10' AND '2025-04-13' THEN 'Mahavir jayanti'
	WHEN txndate BETWEEN '2025-01-14' AND '2025-01-19' THEN 'Makar sakranti'
	WHEN txndate BETWEEN '2025-05-14' AND '2025-05-15' THEN 'Mother day'
	WHEN txndate BETWEEN '2025-07-04' AND '2025-07-09' THEN 'Muharram'
	WHEN txndate BETWEEN '2025-01-01' AND '2025-01-08' THEN 'New Year Celebration'
	WHEN txndate BETWEEN '2024-09-12' AND '2024-09-14' THEN 'Onam'
	WHEN txndate BETWEEN '2025-08-07' AND '2025-08-10' THEN 'Raksha bandhan'
	WHEN txndate BETWEEN '2025-04-05' AND '2025-04-09' THEN 'Ram navmi'
	WHEN txndate BETWEEN '2025-04-01' AND '2025-04-04' THEN 'RamZan'
	WHEN txndate BETWEEN '2025-01-26' AND '2025-01-29' THEN 'Republic day'
	WHEN txndate BETWEEN '2025-02-11' AND '2025-02-17' THEN 'Valentine week'
	WHEN txndate BETWEEN '2025-08-06' AND '2025-08-06' THEN 'Woman day'
	END PERIOD,
        

    -- 👥 Unique Customers
    COUNT(DISTINCT CASE WHEN DAYOFWEEK(txndate) IN (1,7) THEN mobile END) AS Weekend_Customers,
    COUNT(DISTINCT CASE WHEN DAYOFWEEK(txndate) NOT IN (1,7) THEN mobile END) AS Weekday_Customers
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2024-09-01' AND '2025-08-31'
AND storecode NOT IN ('demo','corporate')
AND billno NOT LIKE '%test%'
AND billno NOT LIKE '%roll%'
AND amount > 0 AND frequencycount>1
GROUP BY 1;


-- Store wise data 

SELECT COUNT(DISTINCT storecode)total_store 
FROM txn_report_accrual_redemption a 
WHERE txndate BETWEEN '2024-09-01' AND '2025-08-31'
AND storecode IN (SELECT DISTINCT storecode FROM txn_report_accrual_redemption a 
WHERE txndate <'2024-04-01'
AND storecode NOT IN ('demo','corporate')
AND billno NOT LIKE '%test%'
AND billno NOT LIKE '%roll%'
AND amount > 0)
AND storecode NOT IN ('demo','corporate')
AND billno NOT LIKE '%test%'
AND billno NOT LIKE '%roll%'
AND amount > 0;



WITH valid_stores AS (
    SELECT DISTINCT storecode
    FROM txn_report_accrual_redemption
    WHERE 
        txndate < '2024-04-01'
        AND storecode NOT IN ('demo', 'corporate')
        AND billno NOT LIKE '%test%'
        AND billno NOT LIKE '%roll%'
        AND amount > 0
)
SELECT 
    COUNT(DISTINCT a.storecode) AS total_store
FROM txn_report_accrual_redemption a
JOIN valid_stores v ON a.storecode = v.storecode
WHERE 
    a.txndate BETWEEN '2024-09-01' AND '2025-08-31'
    AND a.storecode NOT IN ('demo', 'corporate')
    AND a.billno NOT LIKE '%test%'
    AND a.billno NOT LIKE '%roll%'
    AND a.amount > 0;



SELECT COUNT(DISTINCT storecode)total_store 
FROM txn_report_accrual_redemption a LEFT JOIN store_master b USING(storecode)
WHERE 
-- txndate BETWEEN '2024-09-01' AND '2025-08-31'
-- AND 
storecode NOT IN ('demo','corporate')
AND billno NOT LIKE '%test%'
AND billno NOT LIKE '%roll%'
AND amount > 0;

-- total storecode
SELECT COUNT(DISTINCT enrolledstorecode)total_store 
FROM member_report
WHERE enrolledstorecode <> 'demo';



SELECT DISTINCT a.storecode
FROM txn_report_accrual_redemption a
WHERE 
    a.txndate BETWEEN '2024-09-01' AND '2025-08-31'
    AND a.storecode IN (
        SELECT DISTINCT b.storecode
        FROM txn_report_accrual_redemption b
        WHERE 
            b.txndate < '2024-04-01'  -- store existed before 1 year
            AND b.storecode NOT IN ('demo', 'corporate')
            AND b.billno NOT LIKE '%test%'
            AND b.billno NOT LIKE '%roll%'
            AND b.amount > 0
    )
    AND a.storecode NOT IN ('demo', 'corporate')
    AND a.billno NOT LIKE '%test%'
    AND a.billno NOT LIKE '%roll%'
    AND a.amount > 0
ORDER BY a.storecode;


SELECT COUNT(DISTINCT storecode) FROM txn_report_accrual_redemption a
WHERE 
    a.txndate BETWEEN '2024-09-01' AND '2025-08-31'
    AND a.storecode NOT IN ('demo', 'corporate')
    AND a.billno NOT LIKE '%test%'
    AND a.billno NOT LIKE '%roll%'
    AND a.amount > 0



-- active store 

SELECT COUNT(DISTINCT enrolledstorecode)active_store FROM member_report
WHERE modifiedenrolledon BETWEEN '2025-07-01' AND '2025-07-31'
AND enrolledstorecode NOT IN ('demo','corporate');

-- region wise distribution
SELECT CASE WHEN region LIKE '%north%' THEN 'North'
WHEN region LIKE '%west%' THEN 'West'
WHEN region LIKE '%east%' THEN 'East' ELSE 'South' END region
,COUNT(DISTINCT storecode)storecode 
FROM txn_report_accrual_redemption a RIGHT JOIN store_master b USING(storecode)
WHERE a.txndate BETWEEN '2024-09-01' AND '2025-08-31'
AND a.storecode NOT IN ('demo', 'corporate')
AND a.billno NOT LIKE '%test%'
AND a.billno NOT LIKE '%roll%'
-- AND a.amount > 0
GROUP BY 1;


-- region wise kpis distribution

SELECT region,COUNT(DISTINCT mobile)customers,
SUM(amount)Loyalty_sales,
COUNT(DISTINCT CASE WHEN dayssincelastvisit>365 THEN mobile END) winback,
COUNT(DISTINCT CASE WHEN frequencycount=1 THEN mobile END)First_timer,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN mobile END)Repeater
FROM txn_report_accrual_redemption a JOIN store_master b USING(storecode)
WHERE a.txndate BETWEEN '2024-09-01' AND '2025-08-31'
AND a.storecode NOT IN ('demo', 'corporate')
AND a.billno NOT LIKE '%test%'
AND a.billno NOT LIKE '%roll%'
AND a.amount > 0
GROUP BY 1;



