SELECT tier,modifiedtxndate,txnmappedmobile,SUM(itemnetamount)sales 
FROM sku_report_loyalty a JOIN member_report b ON a.txnmappedmobile=b.mobile AND tier='MVC'
WHERE modifiedtxndate BETWEEN '2025-07-01' AND '2025-09-10'
AND itemnetamount>0
AND modifiedstorecode <> 'demo'
AND Txnmappedmobile NOT IN (SELECT mobile FROM probable_fraud_customer)
GROUP BY 1,2,3;

-- main query 
SELECT tier,modifiedtxndate,COUNT(DISTINCT txnmappedmobile)customer,SUM(itemnetamount)sales 
FROM sku_report_loyalty a JOIN member_report b ON a.txnmappedmobile=b.mobile AND tier='MVC'
WHERE modifiedtxndate = '2025-09-10' #change date
AND itemnetamount>0
AND modifiedstorecode <> 'demo'
AND Txnmappedmobile NOT IN (SELECT mobile FROM probable_fraud_customer)
AND txnmappedmobile IN (
SELECT DISTINCT CASE WHEN minf=1 AND maxf=1 THEN mobile END customers FROM (
SELECT txnmappedmobile mobile,MIN(frequencycount)minf,MAX(frequencycount)maxf 
FROM sku_report_loyalty a JOIN member_report b ON a.txnmappedmobile=b.mobile AND tier='MVC'
WHERE modifiedtxndate = '2025-09-10'  #change date 
AND itemnetamount>0
AND modifiedstorecode <> 'demo'
AND Txnmappedmobile NOT IN (SELECT mobile FROM probable_fraud_customer)
GROUP BY 1)a
GROUP BY 1) 
GROUP BY 1,2;

-- use this also when you want 1st txndate 
INSERT INTO dummy.First_txndate
SELECT txnmappedmobile,tier,MIN(modifiedtxndate)mindate 
FROM sku_report_loyalty a JOIN member_report b ON a.txnmappedmobile=b.mobile AND tier='MVC'
WHERE modifiedtxndate <='2025-09-10'  #change date 
AND itemnetamount>0
AND modifiedstorecode <> 'demo'
AND Txnmappedmobile NOT IN (SELECT mobile FROM probable_fraud_customer) 
GROUP BY 1,2
ORDER BY modifiedtxndate;



SELECT a.txnmappedmobile,mindate,tier,SUM(itemnetamount)sales FROM dummy.First_txndate a JOIN sku_report_loyalty b
ON a.txnmappedmobile=b.txnmappedmobile AND a.mindate=b.modifiedtxndate
WHERE mindate BETWEEN '2025-08-01' AND '2025-09-10'
AND itemnetamount>0
AND modifiedstorecode <> 'demo'
-- AND Txnmappedmobile NOT IN (SELECT mobile FROM probable_fraud_customer) 
GROUP BY 1,2



SELECT txnmappedmobile mobile,MIN(frequencycount)minf,MAX(frequencycount)maxf 
FROM sku_report_loyalty a JOIN member_report b ON a.txnmappedmobile=b.mobile AND tier='MVC'
WHERE modifiedtxndate ='2025-08-21'  #change date 
AND itemnetamount>0
AND modifiedstorecode <> 'demo'
AND Txnmappedmobile NOT IN (SELECT mobile FROM probable_fraud_customer)
GROUP BY 1;



SELECT modifiedtxndate,txnmappedmobile mobile,frequencycount 
FROM sku_report_loyalty a JOIN member_report b ON a.txnmappedmobile=b.mobile AND tier='MVC'
WHERE modifiedtxndate BETWEEN '2025-07-01' AND '2025-09-10'
AND txnmappedmobile ='6386236319'
GROUP BY 1,2



SELECT * 
FROM sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2025-08-01' AND '2025-09-10'
AND txnmappedmobile ='8077199202';


SELECT * FROM p



SELECT modifiedtxndate,txnmappedmobile,MIN(frequencycount)minf,MAX(frequencycount)maxf,SUM(itemnetamount)sales 
FROM sku_report_loyalty a JOIN member_report b ON a.txnmappedmobile=b.mobile AND tier='MVC'
WHERE modifiedtxndate BETWEEN '2025-07-01' AND '2025-09-10'
AND itemnetamount>0
AND txnmappedmobile= '8999274439'
AND modifiedstorecode <> 'demo'
AND Txnmappedmobile NOT IN (SELECT mobile FROM probable_fraud_customer)
GROUP BY 1
HAVING maxf=1


SELECT DISTINCT tier,modifiedtxndate,txnmappedmobile,itemnetamount,frequencycount  
FROM sku_report_loyalty a JOIN member_report b ON a.txnmappedmobile=b.mobile AND tier='MVC'
WHERE modifiedtxndate BETWEEN '2025-07-01' AND '2025-09-10'
AND itemnetamount>0
AND modifiedstorecode <> 'demo'
AND Txnmappedmobile NOT IN (SELECT mobile FROM probable_fraud_customer);


###############################################v3 file data from there way #####################################

WITH first_txn AS (
    SELECT 
        a.txnmappedmobile AS mobile,
        MIN(a.modifiedtxndate) AS first_txn_date
    FROM sku_report_loyalty a
    JOIN member_report b
        ON a.txnmappedmobile = b.mobile 
       AND b.tier = 'MVC'
    WHERE a.itemnetamount > 0
      AND a.modifiedstorecode <> 'demo'
      AND a.txnmappedmobile NOT IN (SELECT mobile FROM probable_fraud_customer)
    GROUP BY 1
),
txn_check AS (
    SELECT 
        a.mobile,
        a.first_txn_date,COUNT(DISTINCT b.modifiedtxndate) txncount
    FROM first_txn a
    JOIN sku_report_loyalty b
        ON a.mobile = b.txnmappedmobile
       AND b.modifiedtxndate BETWEEN a.first_txn_date AND DATE_ADD(a.first_txn_date, INTERVAL 6 DAY)
    WHERE b.itemnetamount > 0
      AND b.modifiedstorecode <> 'demo'
    GROUP BY 1,2
    HAVING txncount = 1
),
daily_count AS (
    SELECT 
        first_txn_date ,
        COUNT(DISTINCT mobile) AS customer_count,SUM(itemnetamount)sales
    FROM txn_check a JOIN sku_report_loyalty b ON a.mobile=b.txnmappedmobile AND a.first_txn_date=b.modifiedtxndate
    WHERE first_txn_date BETWEEN '2025-07-01' AND '2025-09-05'
    GROUP BY 1
)
SELECT 
    first_txn_date,
    customer_count,sales
FROM daily_count
ORDER BY 1;


WITH first_txn AS (
    SELECT 
        a.txnmappedmobile AS mobile,
        MIN(a.modifiedtxndate) AS first_txn_date
    FROM sku_report_loyalty a
    JOIN member_report b
        ON a.txnmappedmobile = b.mobile 
       AND b.tier = 'MVC'
    WHERE a.itemnetamount > 0
      AND a.modifiedstorecode <> 'demo'
      AND a.txnmappedmobile NOT IN (SELECT mobile FROM probable_fraud_customer)
    GROUP BY 1
),
txn_check AS (
    SELECT 
        a.mobile,
        a.first_txn_date,COUNT(DISTINCT b.modifiedtxndate) txncount
    FROM first_txn a
    JOIN sku_report_loyalty b
        ON a.mobile = b.txnmappedmobile
       AND b.modifiedtxndate BETWEEN a.first_txn_date AND DATE_ADD(a.first_txn_date, INTERVAL 6 DAY)
    WHERE b.itemnetamount > 0
      AND b.modifiedstorecode <> 'demo'
    GROUP BY 1,2
    HAVING txncount = 1
)
    SELECT 
        first_txn_date ,
         mobile,SUM(itemnetamount)sales
    FROM txn_check a JOIN sku_report_loyalty b ON a.mobile=b.txnmappedmobile AND a.first_txn_date=b.modifiedtxndate
    WHERE first_txn_date BETWEEN '2025-07-01' AND '2025-09-05'
    GROUP BY 1,2
    ORDER BY 1;
    
    
    
    SELECT * FROM sku_report_loyalty 
    WHERE modifiedtxndate BETWEEN '2025-07-01' AND '2025-09-05'#change date
AND itemnetamount>0
AND modifiedstorecode <> 'demo'
AND Txnmappedmobile NOT IN (SELECT mobile FROM probable_fraud_customer)
AND txnmappedmobile = '9080264091'