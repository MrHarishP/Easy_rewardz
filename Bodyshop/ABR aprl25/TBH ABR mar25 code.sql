
-- KIPS quarter wise and fy 23-25
-- enrolledmen mom 

SELECT CASE 
WHEN modifiedenrolledon BETWEEN '2024-04-01' AND '2024-06-30' THEN 'Apr 24-Jun-24 (Q1)'
WHEN modifiedenrolledon BETWEEN '2024-07-01' AND '2024-09-30' THEN 'Jul 24-Sep-24 (Q2)'
WHEN modifiedenrolledon BETWEEN '2024-10-01' AND '2024-12-31' THEN 'Oct 24-Dec-24 (Q3)'
WHEN modifiedenrolledon BETWEEN '2025-01-01' AND '2025-03-31' THEN 'Jan 25-Mar-25 (Q4)' END 'period',COUNT(DISTINCT clientid)enrollment 
FROM member_report 
WHERE modifiedenrolledon BETWEEN '2024-04-01' AND '2025-03-31'
AND enrolledstorecode NOT LIKE '%demo%'
AND insertiondate <='2025-04-20'
GROUP BY 1;
-- non loyatly data  qoq

SELECT CASE 
WHEN modifiedtxndate BETWEEN '2024-04-01' AND '2024-06-30' THEN 'Apr 24-Jun-24 (Q1)'
WHEN modifiedtxndate BETWEEN '2024-07-01' AND '2024-09-30' THEN 'Jul 24-Sep-24 (Q2)'
WHEN modifiedtxndate BETWEEN '2024-10-01' AND '2024-12-31' THEN 'Oct 24-Dec-24 (Q3)'
WHEN modifiedtxndate BETWEEN '2025-01-01' AND '2025-03-31' THEN 'Jan 25-Mar-25 (Q4)' END 'period',
SUM(itemnetamount)nonloyalty_sales,COUNT(DISTINCT uniquebillno)nonloyalty_bills,SUM(itemqty)nonloyatly_qty
FROM sku_report_nonloyalty 
WHERE modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31' 
AND modifiedstorecode NOT LIKE '%demo%'
AND modifiedbillno NOT LIKE '%brn%'
AND modifiedbillno NOT LIKE '%roll%'
AND modifiedbillno NOT LIKE '%test%'
AND insertiondate <='2025-04-20'
GROUP BY 1;
-- loyatly
SELECT PERIOD,
COUNT(DISTINCT clientid)total_transactor,
SUM(itemnetamount)loyalty_sales,SUM(uniquebillno)loyalty_bills,SUM(itemqty)loyatly_qty,
SUM(itemnetamount)/SUM(uniquebillno)ATV,SUM(itemnetamount)/COUNT(DISTINCT clientid)AMV,SUM(itemnetamount)/SUM(itemqty)ASP,
SUM(itemqty)/SUM( uniquebillno)UPT,
COUNT(DISTINCT CASE WHEN maxfc=1 THEN clientid END)'New/Onetimer Customers',
SUM(CASE WHEN maxfc=1 THEN itemnetamount END)'New/Onetimer Sales',
COUNT(DISTINCT CASE WHEN maxfc>1 THEN clientid END)'Repeat Customers',
SUM(CASE WHEN maxfc>1 THEN itemnetamount END)'Repeat Sales',
COUNT(DISTINCT modifiedstorecode)storecount,AVG(recency)recency,AVG(latency)latency,SUM(visits)/COUNT(DISTINCT clientid)avg_visit
FROM (
SELECT clientid,CASE 
WHEN modifiedtxndate BETWEEN '2024-04-01' AND '2024-06-30' THEN 'Apr 24-Jun-24 (Q1)'
WHEN modifiedtxndate BETWEEN '2024-07-01' AND '2024-09-30' THEN 'Jul 24-Sep-24 (Q2)'
WHEN modifiedtxndate BETWEEN '2024-10-01' AND '2024-12-31' THEN 'Oct 24-Dec-24 (Q3)'
WHEN modifiedtxndate BETWEEN '2025-01-01' AND '2025-03-31' THEN 'Jan 25-Mar-25 (Q4)' END 'period',
modifiedstorecode,DATEDIFF('2025-03-31',MAX(modifiedtxndate))recency,
DATEDIFF(MAX(modifiedtxndate),MIN(modifiedtxndate))/NULLIF((COUNT(DISTINCT modifiedtxndate)-1),0)latency,COUNT(DISTINCT clientid,modifiedtxndate)visits,
MAX(frequencycount)maxfc,SUM(itemnetamount)itemnetamount,COUNT(DISTINCT uniquebillno)uniquebillno,SUM(itemqty)itemqty FROM 
sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31' 
AND modifiedstorecode NOT LIKE '%demo%'
AND modifiedbillno NOT LIKE '%brn%'
AND modifiedbillno NOT LIKE '%roll%'
AND modifiedbillno NOT LIKE '%test%'
AND insertiondate <='2025-04-20'
GROUP BY 1,2)a
GROUP BY 1;


-- select COUNT(DISTINCT clientid,modifiedtxndate)visits from sku_report_loyalty 
-- WHERE modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31' #821265

--  txn_accrual_points 
SELECT PERIOD,SUM(pointscollected)'Transactional Points Issued ',
SUM(pointsspent)'Points Redeemed'
FROM (
SELECT clientid,CASE 
WHEN txndate BETWEEN '2024-04-01' AND '2024-06-30' THEN 'Apr 24-Jun-24 (Q1)'
WHEN txndate BETWEEN '2024-07-01' AND '2024-09-30' THEN 'Jul 24-Sep-24 (Q2)'
WHEN txndate BETWEEN '2024-10-01' AND '2024-12-31' THEN 'Oct 24-Dec-24 (Q3)'
WHEN txndate BETWEEN '2025-01-01' AND '2025-03-31' THEN 'Jan 25-Mar-25 (Q4)' END 'period',SUM(pointscollected)pointscollected,
SUM(pointsspent)pointsspent FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2024-04-01' AND '2025-03-31' 
AND storecode NOT LIKE '%demo%'
AND billno NOT LIKE '%brn%'
AND billno NOT LIKE '%roll%'
AND billno NOT LIKE '%test%'
AND insertiondate <='2025-04-20'
GROUP BY 1,2)a
GROUP BY 1;

-- flat_accrual 
SELECT PERIOD,SUM(pointscollected)'Bonus Points Issued '
FROM (
SELECT clientid,CASE 
WHEN txndate BETWEEN '2024-04-01' AND '2024-06-30' THEN 'Apr 24-Jun-24 (Q1)'
WHEN txndate BETWEEN '2024-07-01' AND '2024-09-30' THEN 'Jul 24-Sep-24 (Q2)'
WHEN txndate BETWEEN '2024-10-01' AND '2024-12-31' THEN 'Oct 24-Dec-24 (Q3)'
WHEN txndate BETWEEN '2025-01-01' AND '2025-03-31' THEN 'Jan 25-Mar-25 (Q4)' END 'period',SUM(pointscollected)pointscollected
FROM txn_report_flat_accrual
WHERE txndate BETWEEN '2024-04-01' AND '2025-03-31' 
AND storecode NOT LIKE '%demo%'
AND billno NOT LIKE '%brn%'
AND billno NOT LIKE '%roll%'
AND billno NOT LIKE '%test%'
AND insertiondate <='2025-04-20'
GROUP BY 1,2)a
GROUP BY 1;

############################################################################################################################################
############################################################################################################################################
############################################################################################################################################

-- enrolledmen mom 

SELECT CASE 
WHEN modifiedenrolledon BETWEEN '2023-04-01' AND '2024-03-31' THEN ' (FY’23-24)'
WHEN modifiedenrolledon BETWEEN '2024-04-01' AND '2025-03-31' THEN ' (FY’24-25)'
END'period',COUNT(DISTINCT clientid)enrollment FROM member_report 
WHERE modifiedenrolledon BETWEEN '2023-04-01' AND '2025-03-31'
AND enrolledstorecode NOT LIKE '%demo%'
AND insertiondate <='2025-04-20'
GROUP BY 1;
-- non loyatly data  qoq

SELECT CASE 
WHEN txndate BETWEEN '2023-04-01' AND '2024-03-31' THEN ' (FY’23-24)'
WHEN txndate BETWEEN '2024-04-01' AND '2025-03-31' THEN ' (FY’24-25)'
END'period',
SUM(itemnetamount)nonloyalty_sales,COUNT(DISTINCT uniquebillno)nonloyalty_bills,SUM(itemqty)nonloyatly_qty
FROM sku_report_nonloyalty 
WHERE modifiedtxndate BETWEEN '2023-04-01' AND '2025-03-31' 
AND storecode NOT LIKE '%demo%'
AND modifiedbillno NOT LIKE '%brn%'
AND modifiedbillno NOT LIKE '%roll%'
AND modifiedbillno NOT LIKE '%test%'
GROUP BY 1;
-- loyatly
SELECT PERIOD,
COUNT(DISTINCT clientid)total_transactor,
SUM(itemnetamount)loyalty_sales,SUM(uniquebillno)loyalty_bills,SUM(itemqty)loyatly_qty,
SUM(itemnetamount)/SUM(uniquebillno)ATV,SUM(itemnetamount)/COUNT(DISTINCT clientid)AMV,SUM(itemnetamount)/SUM(itemqty)ASP,
SUM(itemqty)/SUM( uniquebillno)UPT,
COUNT(DISTINCT CASE WHEN maxfc=1 THEN clientid END)'New/Onetimer Customers',
SUM(CASE WHEN maxfc=1 THEN itemnetamount END)'New/Onetimer Sales',
COUNT(DISTINCT CASE WHEN maxfc>1 THEN clientid END)'Repeat Customers',
SUM(CASE WHEN maxfc>1 THEN itemnetamount END)'Repeat Sales',
COUNT(DISTINCT modifiedstorecode)storecount,AVG(recency)recency,AVG(latency)latency,SUM(visits)/COUNT(DISTINCT clientid) AS avg_visit
FROM (
SELECT clientid,CASE 
WHEN txndate BETWEEN '2023-04-01' AND '2024-03-31' THEN ' (FY’23-24)'
WHEN txndate BETWEEN '2024-04-01' AND '2025-03-31' THEN ' (FY’24-25)'
END'period',modifiedstorecode,DATEDIFF('2025-03-31',MAX(modifiedtxndate))recency,
DATEDIFF(MAX(modifiedtxndate),MIN(modifiedtxndate))/NULLIF((COUNT(DISTINCT modifiedtxndate)-1),0)latency,
COUNT(DISTINCT clientid,modifiedtxndate)visits,
MAX(frequencycount)maxfc,SUM(itemnetamount)itemnetamount,COUNT(DISTINCT uniquebillno)uniquebillno,SUM(itemqty)itemqty FROM 
sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2023-04-01' AND '2025-03-31' 
AND modifiedstorecode NOT LIKE '%demo%'
AND modifiedbillno NOT LIKE '%brn%'
AND modifiedbillno NOT LIKE '%roll%'
AND modifiedbillno NOT LIKE '%test%'
AND insertiondate <='2025-04-20'
GROUP BY 1,2)a
GROUP BY 1;

--  txn_accrual_points 
SELECT CASE 
WHEN txndate BETWEEN '2023-04-01' AND '2024-03-31' THEN ' (FY’23-24)'
WHEN txndate BETWEEN '2024-04-01' AND '2025-03-31' THEN ' (FY’24-25)'
END'period',SUM(pointscollected)'Transactional Points Issued ',
SUM(pointsspent)'Points Redeemed'
FROM (
SELECT clientid,txndate,SUM(pointscollected)pointscollected,
SUM(pointsspent)pointsspent FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2023-04-01' AND '2025-03-31' 
AND storecode NOT LIKE '%demo%'
AND billno NOT LIKE '%brn%'
AND billno NOT LIKE '%roll%'
AND billno NOT LIKE '%test%'
AND insertiondate <='2025-04-20'
GROUP BY 1,2)a
GROUP BY 1;

-- flat_accrual 
SELECT PERIOD,SUM(pointscollected)'Bonus Points Issued '
FROM (
SELECT clientid,
CASE 
WHEN txndate BETWEEN '2023-04-01' AND '2024-03-31' THEN ' (FY’23-24)'
WHEN txndate BETWEEN '2024-04-01' AND '2025-03-31' THEN ' (FY’24-25)'
END'period',SUM(pointscollected)pointscollected
FROM txn_report_flat_accrual
WHERE txndate BETWEEN '2023-04-01' AND '2025-03-31' 
AND storecode NOT LIKE '%demo%'
AND billno NOT LIKE '%brn%'
AND billno NOT LIKE '%roll%'
AND billno NOT LIKE '%test%'
AND insertiondate <='2025-04-20'
GROUP BY 1,2)a
GROUP BY 1;


############################################################################################################################################
############################################################################################################################################
############################################################################################################################################
###### END


##############################################-- channle wise kpis start ###################################
-- enrolledment 
SELECT CASE 
WHEN modifiedenrolledon BETWEEN '2024-04-01' AND '2024-06-30' THEN 'Apr 24-Jun-24 (Q1)'
WHEN modifiedenrolledon BETWEEN '2024-07-01' AND '2024-09-30' THEN 'Jul 24-Sep-24 (Q2)'
WHEN modifiedenrolledon BETWEEN '2024-10-01' AND '2024-12-31' THEN 'Oct 24-Dec-24 (Q3)'
WHEN modifiedenrolledon BETWEEN '2025-01-01' AND '2025-03-31' THEN 'Jan 25-Mar-25 (Q4)' END 'period',COUNT(DISTINCT clientid)enrollment 
FROM member_report 
WHERE modifiedenrolledon BETWEEN '2024-04-01' AND '2025-03-31'
AND enrolledstorecode NOT LIKE '%demo%'
AND enrolledstorecode <> 3011
AND insertiondate <='2025-04-20'
GROUP BY 1;
-- non loyatly data  qoq

SELECT CASE 
WHEN modifiedtxndate BETWEEN '2024-04-01' AND '2024-06-30' THEN 'Apr 24-Jun-24 (Q1)'
WHEN modifiedtxndate BETWEEN '2024-07-01' AND '2024-09-30' THEN 'Jul 24-Sep-24 (Q2)'
WHEN modifiedtxndate BETWEEN '2024-10-01' AND '2024-12-31' THEN 'Oct 24-Dec-24 (Q3)'
WHEN modifiedtxndate BETWEEN '2025-01-01' AND '2025-03-31' THEN 'Jan 25-Mar-25 (Q4)' END 'period',
SUM(itemnetamount)nonloyalty_sales,COUNT(DISTINCT uniquebillno)nonloyalty_bills,SUM(itemqty)nonloyatly_qty
FROM sku_report_nonloyalty 
WHERE modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31' 
AND modifiedstorecode NOT LIKE '%demo%'
AND modifiedbillno NOT LIKE '%brn%'
AND modifiedbillno NOT LIKE '%roll%'
AND modifiedbillno NOT LIKE '%test%'
AND insertiondate <='2025-04-20'
AND modifiedstorecode <> 3011
GROUP BY 1;
-- loyatly
SELECT PERIOD,
COUNT(DISTINCT clientid)total_transactor,
SUM(itemnetamount)loyalty_sales,SUM(uniquebillno)loyalty_bills,SUM(itemqty)loyatly_qty,
SUM(itemnetamount)/SUM(uniquebillno)ATV,SUM(itemnetamount)/COUNT(DISTINCT clientid)AMV,SUM(itemnetamount)/SUM(itemqty)ASP,
SUM(itemqty)/SUM( uniquebillno)UPT,
COUNT(DISTINCT CASE WHEN maxfc=1 THEN clientid END)'New/Onetimer Customers',
SUM(CASE WHEN maxfc=1 THEN itemnetamount END)'New/Onetimer Sales',
COUNT(DISTINCT CASE WHEN maxfc>1 THEN clientid END)'Repeat Customers',
SUM(CASE WHEN maxfc>1 THEN itemnetamount END)'Repeat Sales',
COUNT(DISTINCT modifiedstorecode)storecount,AVG(recency)recency,AVG(latency)latency,SUM(visits)/COUNT(DISTINCT clientid)avg_visit
FROM (
SELECT clientid,CASE 
WHEN modifiedtxndate BETWEEN '2024-04-01' AND '2024-06-30' THEN 'Apr 24-Jun-24 (Q1)'
WHEN modifiedtxndate BETWEEN '2024-07-01' AND '2024-09-30' THEN 'Jul 24-Sep-24 (Q2)'
WHEN modifiedtxndate BETWEEN '2024-10-01' AND '2024-12-31' THEN 'Oct 24-Dec-24 (Q3)'
WHEN modifiedtxndate BETWEEN '2025-01-01' AND '2025-03-31' THEN 'Jan 25-Mar-25 (Q4)' END 'period',
modifiedstorecode,DATEDIFF('2025-03-31',MAX(modifiedtxndate))recency,
DATEDIFF(MAX(modifiedtxndate),MIN(modifiedtxndate))/NULLIF((COUNT(DISTINCT modifiedtxndate)-1),0)latency,COUNT(DISTINCT clientid,modifiedtxndate)visits,
MAX(frequencycount)maxfc,SUM(itemnetamount)itemnetamount,COUNT(DISTINCT uniquebillno)uniquebillno,SUM(itemqty)itemqty FROM 
sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31' 
AND modifiedstorecode NOT LIKE '%demo%'
AND modifiedbillno NOT LIKE '%brn%'
AND modifiedbillno NOT LIKE '%roll%'
AND modifiedbillno NOT LIKE '%test%'
AND modifiedstorecode <> 3011
AND insertiondate <='2025-04-20'
GROUP BY 1,2)a
GROUP BY 1;


-- select COUNT(DISTINCT clientid,modifiedtxndate)visits from sku_report_loyalty 
-- WHERE modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31' #821265

--  txn_accrual_points 
SELECT PERIOD,SUM(pointscollected)'Transactional Points Issued ',
SUM(pointsspent)'Points Redeemed'
FROM (
SELECT clientid,CASE 
WHEN txndate BETWEEN '2024-04-01' AND '2024-06-30' THEN 'Apr 24-Jun-24 (Q1)'
WHEN txndate BETWEEN '2024-07-01' AND '2024-09-30' THEN 'Jul 24-Sep-24 (Q2)'
WHEN txndate BETWEEN '2024-10-01' AND '2024-12-31' THEN 'Oct 24-Dec-24 (Q3)'
WHEN txndate BETWEEN '2025-01-01' AND '2025-03-31' THEN 'Jan 25-Mar-25 (Q4)' END 'period',SUM(pointscollected)pointscollected,
SUM(pointsspent)pointsspent FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2024-04-01' AND '2025-03-31' 
AND storecode NOT LIKE '%demo%'
AND billno NOT LIKE '%brn%'
AND billno NOT LIKE '%roll%'
AND billno NOT LIKE '%test%'
AND storecode <> 3011
AND insertiondate <='2025-04-20'
GROUP BY 1,2)a
GROUP BY 1;

-- flat_accrual 
SELECT PERIOD,SUM(pointscollected)'Bonus Points Issued '
FROM (
SELECT clientid,CASE 
WHEN txndate BETWEEN '2024-04-01' AND '2024-06-30' THEN 'Apr 24-Jun-24 (Q1)'
WHEN txndate BETWEEN '2024-07-01' AND '2024-09-30' THEN 'Jul 24-Sep-24 (Q2)'
WHEN txndate BETWEEN '2024-10-01' AND '2024-12-31' THEN 'Oct 24-Dec-24 (Q3)'
WHEN txndate BETWEEN '2025-01-01' AND '2025-03-31' THEN 'Jan 25-Mar-25 (Q4)' END 'period',SUM(pointscollected)pointscollected
FROM txn_report_flat_accrual
WHERE txndate BETWEEN '2024-04-01' AND '2025-03-31' 
AND storecode NOT LIKE '%demo%'
AND billno NOT LIKE '%brn%'
AND billno NOT LIKE '%roll%'
AND billno NOT LIKE '%test%'
AND storecode <> 3011
AND insertiondate <='2025-04-20'
GROUP BY 1,2)a
GROUP BY 1;

############################################################################################################################################
############################################################################################################################################
############################################################################################################################################

-- enrolledmen mom 

SELECT CASE 
WHEN modifiedenrolledon BETWEEN '2023-04-01' AND '2024-03-31' THEN ' (FY’23-24)'
WHEN modifiedenrolledon BETWEEN '2024-04-01' AND '2025-03-31' THEN ' (FY’24-25)'
END'period',COUNT(DISTINCT clientid)enrollment FROM member_report 
WHERE modifiedenrolledon BETWEEN '2023-04-01' AND '2025-03-31'
AND enrolledstorecode  NOT LIKE '%demo%'
AND enrolledstorecode <> 3011
AND insertiondate <='2025-04-20'
GROUP BY 1;
-- non loyatly data  qoq

SELECT CASE 
WHEN txndate BETWEEN '2023-04-01' AND '2024-03-31' THEN ' (FY’23-24)'
WHEN txndate BETWEEN '2024-04-01' AND '2025-03-31' THEN ' (FY’24-25)'
END'period',
SUM(itemnetamount)nonloyalty_sales,COUNT(DISTINCT uniquebillno)nonloyalty_bills,SUM(itemqty)nonloyatly_qty
FROM sku_report_nonloyalty 
WHERE modifiedtxndate BETWEEN '2023-04-01' AND '2025-03-31' 
AND storecode NOT LIKE '%demo%'
AND modifiedbillno NOT LIKE '%brn%'
AND modifiedbillno NOT LIKE '%roll%'
AND modifiedstorecode <> 3011
AND modifiedbillno NOT LIKE '%test%'
GROUP BY 1;
-- loyatly
SELECT PERIOD,
COUNT(DISTINCT clientid)total_transactor,
SUM(itemnetamount)loyalty_sales,SUM(uniquebillno)loyalty_bills,SUM(itemqty)loyatly_qty,
SUM(itemnetamount)/SUM(uniquebillno)ATV,SUM(itemnetamount)/COUNT(DISTINCT clientid)AMV,SUM(itemnetamount)/SUM(itemqty)ASP,
SUM(itemqty)/SUM( uniquebillno)UPT,
COUNT(DISTINCT CASE WHEN maxfc=1 THEN clientid END)'New/Onetimer Customers',
SUM(CASE WHEN maxfc=1 THEN itemnetamount END)'New/Onetimer Sales',
COUNT(DISTINCT CASE WHEN maxfc>1 THEN clientid END)'Repeat Customers',
SUM(CASE WHEN maxfc>1 THEN itemnetamount END)'Repeat Sales',
COUNT(DISTINCT modifiedstorecode)storecount,AVG(recency)recency,AVG(latency)latency,SUM(visits)/COUNT(DISTINCT clientid) AS avg_visit
FROM (
SELECT clientid,CASE 
WHEN txndate BETWEEN '2023-04-01' AND '2024-03-31' THEN ' (FY’23-24)'
WHEN txndate BETWEEN '2024-04-01' AND '2025-03-31' THEN ' (FY’24-25)'
END'period',modifiedstorecode,DATEDIFF('2025-03-31',MAX(modifiedtxndate))recency,
DATEDIFF(MAX(modifiedtxndate),MIN(modifiedtxndate))/NULLIF((COUNT(DISTINCT modifiedtxndate)-1),0)latency,
COUNT(DISTINCT clientid,modifiedtxndate)visits,
MAX(frequencycount)maxfc,SUM(itemnetamount)itemnetamount,COUNT(DISTINCT uniquebillno)uniquebillno,SUM(itemqty)itemqty FROM 
sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2023-04-01' AND '2025-03-31' 
AND modifiedstorecode NOT LIKE '%demo%'
AND modifiedbillno NOT LIKE '%brn%'
AND modifiedbillno NOT LIKE '%roll%'
AND modifiedbillno NOT LIKE '%test%'
AND modifiedstorecode <> 3011
AND insertiondate <='2025-04-20'
GROUP BY 1,2)a
GROUP BY 1;

--  txn_accrual_points 
SELECT CASE 
WHEN txndate BETWEEN '2023-04-01' AND '2024-03-31' THEN ' (FY’23-24)'
WHEN txndate BETWEEN '2024-04-01' AND '2025-03-31' THEN ' (FY’24-25)'
END'period',SUM(pointscollected)'Transactional Points Issued ',
SUM(pointsspent)'Points Redeemed'
FROM (
SELECT clientid,txndate,SUM(pointscollected)pointscollected,
SUM(pointsspent)pointsspent FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2023-04-01' AND '2025-03-31' 
AND storecode NOT LIKE '%demo%'
AND billno NOT LIKE '%brn%'
AND billno NOT LIKE '%roll%'
AND billno NOT LIKE '%test%'
AND insertiondate <='2025-04-20'
AND storecode <> 3011
GROUP BY 1,2)a
GROUP BY 1;

-- flat_accrual 
SELECT PERIOD,SUM(pointscollected)'Bonus Points Issued '
FROM (
SELECT clientid,
CASE 
WHEN txndate BETWEEN '2023-04-01' AND '2024-03-31' THEN ' (FY’23-24)'
WHEN txndate BETWEEN '2024-04-01' AND '2025-03-31' THEN ' (FY’24-25)'
END'period',SUM(pointscollected)pointscollected
FROM txn_report_flat_accrual
WHERE txndate BETWEEN '2023-04-01' AND '2025-03-31' 
AND storecode NOT LIKE '%demo%'
AND billno NOT LIKE '%brn%'
AND billno NOT LIKE '%roll%'
AND billno NOT LIKE '%test%'
AND insertiondate <='2025-04-20'
AND storecode <> 3011
GROUP BY 1,2)a
GROUP BY 1;

-- online 





-- enrolledment 
SELECT CASE 
WHEN modifiedenrolledon BETWEEN '2024-04-01' AND '2024-06-30' THEN 'Apr 24-Jun-24 (Q1)'
WHEN modifiedenrolledon BETWEEN '2024-07-01' AND '2024-09-30' THEN 'Jul 24-Sep-24 (Q2)'
WHEN modifiedenrolledon BETWEEN '2024-10-01' AND '2024-12-31' THEN 'Oct 24-Dec-24 (Q3)'
WHEN modifiedenrolledon BETWEEN '2025-01-01' AND '2025-03-31' THEN 'Jan 25-Mar-25 (Q4)' END 'period',COUNT(DISTINCT clientid)enrollment 
FROM member_report 
WHERE modifiedenrolledon BETWEEN '2024-04-01' AND '2025-03-31'
AND enrolledstore NOT LIKE '%demo%'
AND enrolledstorecode = 3011
AND insertiondate <='2025-04-20'
GROUP BY 1;
-- non loyatly data  qoq

SELECT CASE 
WHEN modifiedtxndate BETWEEN '2024-04-01' AND '2024-06-30' THEN 'Apr 24-Jun-24 (Q1)'
WHEN modifiedtxndate BETWEEN '2024-07-01' AND '2024-09-30' THEN 'Jul 24-Sep-24 (Q2)'
WHEN modifiedtxndate BETWEEN '2024-10-01' AND '2024-12-31' THEN 'Oct 24-Dec-24 (Q3)'
WHEN modifiedtxndate BETWEEN '2025-01-01' AND '2025-03-31' THEN 'Jan 25-Mar-25 (Q4)' END 'period',
SUM(itemnetamount)nonloyalty_sales,COUNT(DISTINCT uniquebillno)nonloyalty_bills,SUM(itemqty)nonloyatly_qty
FROM sku_report_nonloyalty 
WHERE modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31' 
AND modifiedstorecode NOT LIKE '%demo%'
AND modifiedbillno NOT LIKE '%brn%'
AND modifiedbillno NOT LIKE '%roll%'
AND modifiedbillno NOT LIKE '%test%'
AND insertiondate <='2025-04-20'
AND modifiedstorecode = 3011
GROUP BY 1;
-- loyatly
SELECT PERIOD,
COUNT(DISTINCT clientid)total_transactor,
SUM(itemnetamount)loyalty_sales,SUM(uniquebillno)loyalty_bills,SUM(itemqty)loyatly_qty,
SUM(itemnetamount)/SUM(uniquebillno)ATV,SUM(itemnetamount)/COUNT(DISTINCT clientid)AMV,SUM(itemnetamount)/SUM(itemqty)ASP,
SUM(itemqty)/SUM( uniquebillno)UPT,
COUNT(DISTINCT CASE WHEN maxfc=1 THEN clientid END)'New/Onetimer Customers',
SUM(CASE WHEN maxfc=1 THEN itemnetamount END)'New/Onetimer Sales',
COUNT(DISTINCT CASE WHEN maxfc>1 THEN clientid END)'Repeat Customers',
SUM(CASE WHEN maxfc>1 THEN itemnetamount END)'Repeat Sales',
COUNT(DISTINCT modifiedstorecode)storecount,AVG(recency)recency,AVG(latency)latency,SUM(visits)/COUNT(DISTINCT clientid)avg_visit
FROM (
SELECT clientid,CASE 
WHEN modifiedtxndate BETWEEN '2024-04-01' AND '2024-06-30' THEN 'Apr 24-Jun-24 (Q1)'
WHEN modifiedtxndate BETWEEN '2024-07-01' AND '2024-09-30' THEN 'Jul 24-Sep-24 (Q2)'
WHEN modifiedtxndate BETWEEN '2024-10-01' AND '2024-12-31' THEN 'Oct 24-Dec-24 (Q3)'
WHEN modifiedtxndate BETWEEN '2025-01-01' AND '2025-03-31' THEN 'Jan 25-Mar-25 (Q4)' END 'period',
modifiedstorecode,DATEDIFF('2025-03-31',MAX(modifiedtxndate))recency,
DATEDIFF(MAX(modifiedtxndate),MIN(modifiedtxndate))/NULLIF((COUNT(DISTINCT modifiedtxndate)-1),0)latency,COUNT(DISTINCT clientid,modifiedtxndate)visits,
MAX(frequencycount)maxfc,SUM(itemnetamount)itemnetamount,COUNT(DISTINCT uniquebillno)uniquebillno,SUM(itemqty)itemqty FROM 
sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31' 
AND modifiedstorecode NOT LIKE '%demo%'
AND modifiedbillno NOT LIKE '%brn%'
AND modifiedbillno NOT LIKE '%roll%'
AND modifiedbillno NOT LIKE '%test%'
AND modifiedstorecode = 3011
AND insertiondate <='2025-04-20'
GROUP BY 1,2)a
GROUP BY 1;


-- select COUNT(DISTINCT clientid,modifiedtxndate)visits from sku_report_loyalty 
-- WHERE modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31' #821265

--  txn_accrual_points 
SELECT PERIOD,SUM(pointscollected)'Transactional Points Issued ',
SUM(pointsspent)'Points Redeemed'
FROM (
SELECT clientid,CASE 
WHEN txndate BETWEEN '2024-04-01' AND '2024-06-30' THEN 'Apr 24-Jun-24 (Q1)'
WHEN txndate BETWEEN '2024-07-01' AND '2024-09-30' THEN 'Jul 24-Sep-24 (Q2)'
WHEN txndate BETWEEN '2024-10-01' AND '2024-12-31' THEN 'Oct 24-Dec-24 (Q3)'
WHEN txndate BETWEEN '2025-01-01' AND '2025-03-31' THEN 'Jan 25-Mar-25 (Q4)' END 'period',SUM(pointscollected)pointscollected,
SUM(pointsspent)pointsspent FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2024-04-01' AND '2025-03-31' 
AND storecode NOT LIKE '%demo%'
AND billno NOT LIKE '%brn%'
AND billno NOT LIKE '%roll%'
AND billno NOT LIKE '%test%'
AND storecode = 3011
AND insertiondate <='2025-04-20'
GROUP BY 1,2)a
GROUP BY 1;

-- flat_accrual 
SELECT PERIOD,SUM(pointscollected)'Bonus Points Issued '
FROM (
SELECT clientid,CASE 
WHEN txndate BETWEEN '2024-04-01' AND '2024-06-30' THEN 'Apr 24-Jun-24 (Q1)'
WHEN txndate BETWEEN '2024-07-01' AND '2024-09-30' THEN 'Jul 24-Sep-24 (Q2)'
WHEN txndate BETWEEN '2024-10-01' AND '2024-12-31' THEN 'Oct 24-Dec-24 (Q3)'
WHEN txndate BETWEEN '2025-01-01' AND '2025-03-31' THEN 'Jan 25-Mar-25 (Q4)' END 'period',SUM(pointscollected)pointscollected
FROM txn_report_flat_accrual
WHERE txndate BETWEEN '2024-04-01' AND '2025-03-31' 
AND storecode NOT LIKE '%demo%'
AND billno NOT LIKE '%brn%'
AND billno NOT LIKE '%roll%'
AND billno NOT LIKE '%test%'
AND storecode = 3011
AND insertiondate <='2025-04-20'
GROUP BY 1,2)a
GROUP BY 1;

############################################################################################################################################
############################################################################################################################################
############################################################################################################################################

-- enrolledmen mom for financial year

SELECT CASE 
WHEN modifiedenrolledon BETWEEN '2023-04-01' AND '2024-03-31' THEN ' (FY’23-24)'
WHEN modifiedenrolledon BETWEEN '2024-04-01' AND '2025-03-31' THEN ' (FY’24-25)'
END'period',COUNT(DISTINCT clientid)enrollment FROM member_report 
WHERE modifiedenrolledon BETWEEN '2023-04-01' AND '2025-03-31'
AND enrolledstore NOT LIKE '%demo%'
AND enrolledstorecode = 3011
AND insertiondate <='2025-04-20'
GROUP BY 1;
-- non loyatly data  qoq

SELECT CASE 
WHEN txndate BETWEEN '2023-04-01' AND '2024-03-31' THEN ' (FY’23-24)'
WHEN txndate BETWEEN '2024-04-01' AND '2025-03-31' THEN ' (FY’24-25)'
END'period',
SUM(itemnetamount)nonloyalty_sales,COUNT(DISTINCT uniquebillno)nonloyalty_bills,SUM(itemqty)nonloyatly_qty
FROM sku_report_nonloyalty 
WHERE modifiedtxndate BETWEEN '2023-04-01' AND '2025-03-31' 
AND modifiedstorecode NOT LIKE '%demo%'
AND modifiedbillno NOT LIKE '%brn%'
AND modifiedbillno NOT LIKE '%roll%'
AND modifiedstorecode = 3011
AND modifiedbillno NOT LIKE '%test%'
GROUP BY 1;
-- loyatly
SELECT PERIOD,
COUNT(DISTINCT clientid)total_transactor,
SUM(itemnetamount)loyalty_sales,SUM(uniquebillno)loyalty_bills,SUM(itemqty)loyatly_qty,
SUM(itemnetamount)/SUM(uniquebillno)ATV,SUM(itemnetamount)/COUNT(DISTINCT clientid)AMV,SUM(itemnetamount)/SUM(itemqty)ASP,
SUM(itemqty)/SUM( uniquebillno)UPT,
COUNT(DISTINCT CASE WHEN maxfc=1 THEN clientid END)'New/Onetimer Customers',
SUM(CASE WHEN maxfc=1 THEN itemnetamount END)'New/Onetimer Sales',
COUNT(DISTINCT CASE WHEN maxfc>1 THEN clientid END)'Repeat Customers',
SUM(CASE WHEN maxfc>1 THEN itemnetamount END)'Repeat Sales',
COUNT(DISTINCT modifiedstorecode)storecount,AVG(recency)recency,AVG(latency)latency,SUM(visits)/COUNT(DISTINCT clientid) AS avg_visit
FROM (
SELECT clientid,CASE 
WHEN txndate BETWEEN '2023-04-01' AND '2024-03-31' THEN ' (FY’23-24)'
WHEN txndate BETWEEN '2024-04-01' AND '2025-03-31' THEN ' (FY’24-25)'
END'period',modifiedstorecode,DATEDIFF('2025-03-31',MAX(modifiedtxndate))recency,
DATEDIFF(MAX(modifiedtxndate),MIN(modifiedtxndate))/NULLIF((COUNT(DISTINCT modifiedtxndate)-1),0)latency,
COUNT(DISTINCT clientid,modifiedtxndate)visits,
MAX(frequencycount)maxfc,SUM(itemnetamount)itemnetamount,COUNT(DISTINCT uniquebillno)uniquebillno,SUM(itemqty)itemqty FROM 
sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2023-04-01' AND '2025-03-31' 
AND modifiedstorecode NOT LIKE '%demo%'
AND modifiedbillno NOT LIKE '%brn%'
AND modifiedbillno NOT LIKE '%roll%'
AND modifiedbillno NOT LIKE '%test%'
AND modifiedstorecode = 3011
AND insertiondate <='2025-04-20'
GROUP BY 1,2)a
GROUP BY 1;

--  txn_accrual_points 
SELECT CASE 
WHEN txndate BETWEEN '2023-04-01' AND '2024-03-31' THEN ' (FY’23-24)'
WHEN txndate BETWEEN '2024-04-01' AND '2025-03-31' THEN ' (FY’24-25)'
END'period',SUM(pointscollected)'Transactional Points Issued ',
SUM(pointsspent)'Points Redeemed'
FROM (
SELECT clientid,txndate,SUM(pointscollected)pointscollected,
SUM(pointsspent)pointsspent FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2023-04-01' AND '2025-03-31' 
AND storecode NOT LIKE '%demo%'
AND billno NOT LIKE '%brn%'
AND billno NOT LIKE '%roll%'
AND billno NOT LIKE '%test%'
AND insertiondate <='2025-04-20'
AND storecode = 3011
GROUP BY 1,2)a
GROUP BY 1;

-- flat_accrual 
SELECT PERIOD,SUM(pointscollected)'Bonus Points Issued '
FROM (
SELECT clientid,
CASE 
WHEN txndate BETWEEN '2023-04-01' AND '2024-03-31' THEN ' (FY’23-24)'
WHEN txndate BETWEEN '2024-04-01' AND '2025-03-31' THEN ' (FY’24-25)'
END'period',SUM(pointscollected)pointscollected
FROM txn_report_flat_accrual
WHERE txndate BETWEEN '2023-04-01' AND '2025-03-31' 
AND storecode NOT LIKE '%demo%'
AND billno NOT LIKE '%brn%'
AND billno NOT LIKE '%roll%'
AND billno NOT LIKE '%test%'
AND insertiondate <='2025-04-20'
AND storecode = 3011
GROUP BY 1,2)a
GROUP BY 1;

##############################################-- channle wise kpis end ###################################



-- channel wise data distrubtion and kpis 

-- sku_report kpis overall 
SELECT 'overall',COUNT(DISTINCT clientid)'Transacting customers',
COUNT(DISTINCT CASE WHEN  maxfc=1 THEN clientid END)'new onetimer customer',
COUNT(DISTINCT CASE WHEN  maxfc>1 THEN clientid END)'repeater customer',
SUM(sales)'Total Sales',
SUM(CASE WHEN maxfc=1 THEN sales END)'New Onetimer Sales',
SUM(CASE WHEN maxfc>1 THEN sales END)'Repeater Sale',
SUM(bills)'Total Bills',
SUM(CASE WHEN maxfc=1 THEN bills END)'New Onetimer bills',
SUM(CASE WHEN maxfc>1 THEN bills END)'Repeater bills',
SUM(qty)'Total Quantity',
SUM(CASE WHEN maxfc=1 THEN qty END)'New Onetimer qty',
SUM(CASE WHEN maxfc>1 THEN qty END)'Repeater qty',
SUM(sales)/SUM(bills)'ABV(Overall)',
SUM(CASE WHEN  maxfc=1 THEN sales END)/SUM(CASE WHEN maxfc=1 THEN bills END)'New Onetimer ABV',
SUM(CASE WHEN maxfc>1 THEN sales END)/SUM(CASE WHEN maxfc>1 THEN bills END)'Repeater ABV',
SUM(sales)/COUNT(DISTINCT clientid)'AMV(Overall)',
SUM(CASE WHEN maxfc=1 THEN sales END)/COUNT(DISTINCT CASE WHEN  maxfc=1 THEN clientid END)'New Onetimer AMV',
SUM(CASE WHEN maxfc>1 THEN sales END)/COUNT(DISTINCT CASE WHEN maxfc>1 THEN clientid END)'Repeater AMV',
SUM(qty)/SUM(bills)UPT,
SUM(CASE WHEN maxfc=1 THEN qty END)/SUM(CASE WHEN maxfc=1 THEN bills END)'New onetimer upt',
SUM(CASE WHEN maxfc>1 THEN qty END)/SUM(CASE WHEN maxfc>1 THEN bills END)'repeater upt',
SUM(sales)/SUM(qty)ASP,
SUM(CASE WHEN maxfc=1 THEN sales END)/SUM(CASE WHEN  maxfc=1 THEN qty END)'New one timer upt',
SUM(CASE WHEN maxfc>1 THEN sales END)/SUM(CASE WHEN maxfc>1 THEN qty END)'repeater upt'
FROM (
SELECT clientid,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills,SUM(itemqty)qty,
MIN(frequencycount)minfc,MAX(frequencycount)maxfc 
FROM sku_report_loyalty
WHERE modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31'
AND modifiedbillno NOT LIKE '%brn%'
AND modifiedbillno NOT LIKE '%roll%'
AND modifiedbillno NOT LIKE '%test%'
AND insertiondate <='2025-04-20'
GROUP BY 1)a
GROUP BY 1
UNION 
-- offline
SELECT 'offline',COUNT(DISTINCT clientid)'Transacting customers',
COUNT(DISTINCT CASE WHEN  maxfc=1 THEN clientid END)'new onetimer customer',
COUNT(DISTINCT CASE WHEN  maxfc>1 THEN clientid END)'repeater customer',
SUM(sales)'Total Sales',
SUM(CASE WHEN maxfc=1 THEN sales END)'New Onetimer Sales',
SUM(CASE WHEN maxfc>1 THEN sales END)'Repeater Sale',
SUM(bills)'Total Bills',
SUM(CASE WHEN maxfc=1 THEN bills END)'New Onetimer bills',
SUM(CASE WHEN maxfc>1 THEN bills END)'Repeater bills',
SUM(qty)'Total Quantity',
SUM(CASE WHEN maxfc=1 THEN qty END)'New Onetimer qty',
SUM(CASE WHEN maxfc>1 THEN qty END)'Repeater qty',
SUM(sales)/SUM(bills)'ABV(Overall)',
SUM(CASE WHEN  maxfc=1 THEN sales END)/SUM(CASE WHEN maxfc=1 THEN bills END)'New Onetimer ABV',
SUM(CASE WHEN maxfc>1 THEN sales END)/SUM(CASE WHEN maxfc>1 THEN bills END)'Repeater ABV',
SUM(sales)/COUNT(DISTINCT clientid)'AMV(Overall)',
SUM(CASE WHEN maxfc=1 THEN sales END)/COUNT(DISTINCT CASE WHEN  maxfc=1 THEN clientid END)'New Onetimer AMV',
SUM(CASE WHEN maxfc>1 THEN sales END)/COUNT(DISTINCT CASE WHEN maxfc>1 THEN clientid END)'Repeater AMV',
SUM(qty)/SUM(bills)UPT,
SUM(CASE WHEN maxfc=1 THEN qty END)/SUM(CASE WHEN maxfc=1 THEN bills END)'New onetimer upt',
SUM(CASE WHEN maxfc>1 THEN qty END)/SUM(CASE WHEN maxfc>1 THEN bills END)'repeater upt',
SUM(sales)/SUM(qty)ASP,
SUM(CASE WHEN maxfc=1 THEN sales END)/SUM(CASE WHEN  maxfc=1 THEN qty END)'New one timer upt',
SUM(CASE WHEN maxfc>1 THEN sales END)/SUM(CASE WHEN maxfc>1 THEN qty END)'repeater upt'
FROM (
SELECT clientid,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills,SUM(itemqty)qty,
MIN(frequencycount)minfc,MAX(frequencycount)maxfc 
FROM sku_report_loyalty
WHERE modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31'
AND modifiedbillno NOT LIKE '%brn%'
AND modifiedbillno NOT LIKE '%roll%'
AND modifiedbillno NOT LIKE '%test%'
AND modifiedstorecode NOT LIKE '3011'
AND insertiondate <='2025-04-20'
GROUP BY 1)a
GROUP BY 1

UNION
-- online
SELECT 'online',COUNT(DISTINCT clientid)'Transacting customers',
COUNT(DISTINCT CASE WHEN  maxfc=1 THEN clientid END)'new onetimer customer',
COUNT(DISTINCT CASE WHEN  maxfc>1 THEN clientid END)'repeater customer',
SUM(sales)'Total Sales',
SUM(CASE WHEN maxfc=1 THEN sales END)'New Onetimer Sales',
SUM(CASE WHEN maxfc>1 THEN sales END)'Repeater Sale',
SUM(bills)'Total Bills',
SUM(CASE WHEN maxfc=1 THEN bills END)'New Onetimer bills',
SUM(CASE WHEN maxfc>1 THEN bills END)'Repeater bills',
SUM(qty)'Total Quantity',
SUM(CASE WHEN maxfc=1 THEN qty END)'New Onetimer qty',
SUM(CASE WHEN maxfc>1 THEN qty END)'Repeater qty',
SUM(sales)/SUM(bills)'ABV(Overall)',
SUM(CASE WHEN  maxfc=1 THEN sales END)/SUM(CASE WHEN maxfc=1 THEN bills END)'New Onetimer ABV',
SUM(CASE WHEN maxfc>1 THEN sales END)/SUM(CASE WHEN maxfc>1 THEN bills END)'Repeater ABV',
SUM(sales)/COUNT(DISTINCT clientid)'AMV(Overall)',
SUM(CASE WHEN maxfc=1 THEN sales END)/COUNT(DISTINCT CASE WHEN  maxfc=1 THEN clientid END)'New Onetimer AMV',
SUM(CASE WHEN maxfc>1 THEN sales END)/COUNT(DISTINCT CASE WHEN maxfc>1 THEN clientid END)'Repeater AMV',
SUM(qty)/SUM(bills)UPT,
SUM(CASE WHEN maxfc=1 THEN qty END)/SUM(CASE WHEN maxfc=1 THEN bills END)'New onetimer upt',
SUM(CASE WHEN maxfc>1 THEN qty END)/SUM(CASE WHEN maxfc>1 THEN bills END)'repeater upt',
SUM(sales)/SUM(qty)ASP,
SUM(CASE WHEN maxfc=1 THEN sales END)/SUM(CASE WHEN  maxfc=1 THEN qty END)'New one timer upt',
SUM(CASE WHEN maxfc>1 THEN sales END)/SUM(CASE WHEN maxfc>1 THEN qty END)'repeater upt'
FROM (
SELECT clientid,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills,SUM(itemqty)qty,
MIN(frequencycount)minfc,MAX(frequencycount)maxfc 
FROM sku_report_loyalty
WHERE modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31'
AND modifiedbillno NOT LIKE '%brn%'
AND modifiedbillno NOT LIKE '%roll%'
AND modifiedbillno NOT LIKE '%test%'
AND modifiedstorecode LIKE '3011'
AND insertiondate <='2025-04-20'
GROUP BY 1)a
GROUP BY 1;

-- enrollment
SELECT 'overall' kpis,COUNT(DISTINCT clientid)enrollment FROM member_report 
WHERE modifiedenrolledon BETWEEN '2024-04-01' AND '2025-03-31'
AND enrolledstorecode NOT LIKE '%demo%'
AND insertiondate <='2025-04-20'

UNION 
SELECT 'offline' kpis,COUNT(DISTINCT clientid)enrollment FROM member_report 
WHERE modifiedenrolledon BETWEEN '2024-04-01' AND '2025-03-31'
AND enrolledstorecode NOT LIKE '%demo%'
AND enrolledstorecode <> '3011'
AND insertiondate <='2025-04-20'

UNION 
SELECT 'online' kpis,COUNT(DISTINCT clientid)enrollment FROM member_report 
WHERE modifiedenrolledon BETWEEN '2024-04-01' AND '2025-03-31'
AND enrolledstorecode NOT LIKE '%demo%'
AND enrolledstorecode ='3011'
AND insertiondate <='2025-04-20';


--  accrual points 
SELECT 'overall',SUM(pointscollected)'Transaction Points issued',SUM(pointsspent)'Points redeemed'
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2024-04-01' AND '2025-03-31'
AND billno NOT LIKE '%brn%'
AND billno NOT LIKE '%roll%'
AND billno NOT LIKE '%test%'
AND insertiondate <='2025-04-20'
-- AND storecode LIKE '3011'
UNION 
SELECT 'offline',SUM(pointscollected)'Transaction Points issued',SUM(pointsspent)'Points redeemed'
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2024-04-01' AND '2025-03-31'
AND billno NOT LIKE '%brn%'
AND billno NOT LIKE '%roll%'
AND billno NOT LIKE '%test%'
AND insertiondate <='2025-04-20'
AND storecode<> '3011'

UNION 
SELECT 'online',SUM(pointscollected)'Transaction Points issued',SUM(pointsspent)'Points redeemed'
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2024-04-01' AND '2025-03-31'
AND billno NOT LIKE '%brn%'
AND billno NOT LIKE '%roll%'
AND billno NOT LIKE '%test%'
AND storecode ='3011'
AND insertiondate <='2025-04-20';

-- milestone points

SELECT 'overall',SUM(pointscollected) FROM txn_report_flat_accrual
 WHERE txndate BETWEEN '2024-04-01' AND '2025-03-31'
AND storecode NOT LIKE '%demo%' 
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
AND insertiondate <='2025-04-20'
UNION
SELECT 'offline',SUM(pointscollected) FROM txn_report_flat_accrual 
WHERE txndate BETWEEN '2024-04-01' AND '2025-03-31'
AND storecode NOT LIKE '%demo%' 
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
AND storecode<>'3011'
AND insertiondate <='2025-04-20'
UNION
SELECT 'online',SUM(pointscollected) FROM txn_report_flat_accrual 
WHERE txndate BETWEEN '2024-04-01' AND '2025-03-31'
AND storecode NOT LIKE '%demo%' 
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
AND storecode='3011'
AND insertiondate <='2025-04-20';

-- ##################################### loyalty sales and bills

SELECT 'overall'CHANNEL,SUM(sales)loyalty_sales,SUM(bills)loyalty_bills FROM (
SELECT clientid,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills,SUM(itemqty)qty,
MIN(frequencycount)minfc,MAX(frequencycount)maxfc 
FROM sku_report_loyalty
WHERE modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31'
AND modifiedbillno NOT LIKE '%brn%'
AND modifiedbillno NOT LIKE '%roll%'
AND modifiedbillno NOT LIKE '%test%'
AND insertiondate <='2025-04-20'
GROUP BY 1)a
GROUP BY 1
UNION
SELECT 'online',SUM(sales)loyalty_sales,SUM(bills)loyalty_bills FROM (
SELECT clientid,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills,SUM(itemqty)qty,
MIN(frequencycount)minfc,MAX(frequencycount)maxfc 
FROM sku_report_loyalty
WHERE modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31'
AND modifiedbillno NOT LIKE '%brn%'
AND modifiedbillno NOT LIKE '%roll%'
AND modifiedbillno NOT LIKE '%test%'
AND modifiedstorecode LIKE '3011'
AND insertiondate <='2025-04-20'
GROUP BY 1)a
GROUP BY 1
UNION 
SELECT 'offline',SUM(sales)loyalty_sales,SUM(bills)loyalty_bills FROM (
SELECT clientid,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills,SUM(itemqty)qty,
MIN(frequencycount)minfc,MAX(frequencycount)maxfc 
FROM sku_report_loyalty
WHERE modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31'
AND modifiedbillno NOT LIKE '%brn%'
AND modifiedbillno NOT LIKE '%roll%'
AND modifiedbillno NOT LIKE '%test%'
AND modifiedstorecode NOT LIKE '3011'
AND insertiondate <='2025-04-20'
GROUP BY 1)a
GROUP BY 1;

-- ###############################################non loyalayt bills and sales 

SELECT 'overall'CHANNEL,SUM(sales)nonloyalty_sales,SUM(bills)nonloyalty_bills FROM (
SELECT clientid,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills
FROM sku_report_nonloyalty
WHERE modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31'
AND modifiedbillno NOT LIKE '%brn%'
AND modifiedbillno NOT LIKE '%roll%'
AND modifiedbillno NOT LIKE '%test%'
AND insertiondate <='2025-04-20'
GROUP BY 1)a
GROUP BY 1
UNION
SELECT 'online',SUM(sales)nonloyalty_sales,SUM(bills)nonloyalty_bills FROM (
SELECT clientid,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills
FROM sku_report_nonloyalty
WHERE modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31'
AND modifiedbillno NOT LIKE '%brn%'
AND modifiedbillno NOT LIKE '%roll%'
AND modifiedbillno NOT LIKE '%test%'
AND modifiedstorecode LIKE '3011'
AND insertiondate <='2025-04-20'
GROUP BY 1)a
GROUP BY 1
UNION 
SELECT 'offline',SUM(sales)nonloyalty_sales,SUM(bills)nonloyalty_bills FROM (
SELECT clientid,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills
FROM sku_report_nonloyalty
WHERE modifiedtxndate BETWEEN '2024-04-01' AND '2025-03-31'
AND modifiedbillno NOT LIKE '%brn%'
AND modifiedbillno NOT LIKE '%roll%'
AND modifiedbillno NOT LIKE '%test%'
AND modifiedstorecode NOT LIKE '3011'
AND insertiondate <='2025-04-20'
GROUP BY 1)a
GROUP BY 1;



#################################################################END####################################################################
#################################################################END####################################################################
#################################################################END####################################################################






##########################QOQ start###################### 

-- non loyatly data  qoq

SELECT CASE 
WHEN modifiedtxndate BETWEEN '2023-04-01' AND '2023-06-30' THEN 'Apr 23-Jun-23 (Q1)'
WHEN modifiedtxndate BETWEEN '2024-04-01' AND '2024-06-30' THEN 'Apr 24-Jun-24 (Q1)'
WHEN modifiedtxndate BETWEEN '2023-07-01' AND '2023-09-30' THEN 'Jul 23-Sep-23 (Q2)'
WHEN modifiedtxndate BETWEEN '2024-07-01' AND '2024-09-30' THEN 'Jul 24-Sep-24 (Q2)'
WHEN modifiedtxndate BETWEEN '2023-10-01' AND '2023-12-31' THEN 'Oct 23-Dec-23 (Q3)'
WHEN modifiedtxndate BETWEEN '2024-10-01' AND '2024-12-31' THEN 'Oct 24-Dec-24 (Q3)'
WHEN modifiedtxndate BETWEEN '2024-01-01' AND '2024-03-31' THEN 'Jan 24-Mar-24 (Q4)'
WHEN modifiedtxndate BETWEEN '2025-01-01' AND '2025-03-31' THEN 'Jan 25-Mar-25 (Q4)' END 'period',
SUM(itemnetamount)'nonloyalty sales',COUNT(DISTINCT uniquebillno)'nonloyalty bills',SUM(itemqty)'nonloyatly qty'
FROM sku_report_nonloyalty 
WHERE modifiedtxndate BETWEEN '2023-04-01' AND '2025-03-31' 
AND storecode NOT LIKE '%demo%'
AND modifiedbillno NOT LIKE '%brn%'
AND modifiedbillno NOT LIKE '%roll%'
AND modifiedbillno NOT LIKE '%test%'
AND insertiondate <='2025-04-20'
GROUP BY 1;

-- QC
SELECT SUM(itemnetamount)'nonloyalty sales',COUNT(DISTINCT uniquebillno)'nonloyalty bills',SUM(itemqty)'nonloyatly qty'
FROM sku_report_nonloyalty 
WHERE modifiedtxndate BETWEEN '2023-07-01' AND '2023-09-30' 
AND storecode NOT LIKE '%demo%'
AND modifiedbillno NOT LIKE '%brn%'
AND modifiedbillno NOT LIKE '%roll%'
AND modifiedbillno NOT LIKE '%test%'
AND insertiondate <='2025-04-20';


-- loyalty data 

SELECT PERIOD,
COUNT(DISTINCT clientid)total_transactor,
SUM(itemnetamount)'loyalty sales',SUM(uniquebillno)'loyalty bills',SUM(itemqty)'loyatly qty',
SUM(itemnetamount)/SUM(uniquebillno)ATV,SUM(itemnetamount)/COUNT(DISTINCT clientid)AMV,SUM(itemnetamount)/SUM(itemqty)ASP,
SUM(itemqty)/SUM( uniquebillno)UPT,
COUNT(DISTINCT CASE WHEN maxfc=1 THEN clientid END)'New/Onetimer Customers',
SUM(CASE WHEN maxfc=1 THEN itemnetamount END)'New/Onetimer Sales',
COUNT(DISTINCT CASE WHEN maxfc>1 THEN clientid END)'Repeat Customers',
SUM(CASE WHEN maxfc>1 THEN itemnetamount END)'Repeat Sales',
COUNT(DISTINCT modifiedstorecode)storecount
FROM (
SELECT clientid,CASE 
WHEN modifiedtxndate BETWEEN '2023-04-01' AND '2023-06-30' THEN 'Apr 23-Jun-23 (Q1)'
WHEN modifiedtxndate BETWEEN '2024-04-01' AND '2024-06-30' THEN 'Apr 24-Jun-24 (Q1)'
WHEN modifiedtxndate BETWEEN '2023-07-01' AND '2023-09-30' THEN 'Jul 23-Sep-23 (Q2)'
WHEN modifiedtxndate BETWEEN '2024-07-01' AND '2024-09-30' THEN 'Jul 24-Sep-24 (Q2)'
WHEN modifiedtxndate BETWEEN '2023-10-01' AND '2023-12-31' THEN 'Oct 23-Dec-23 (Q3)'
WHEN modifiedtxndate BETWEEN '2024-10-01' AND '2024-12-31' THEN 'Oct 24-Dec-24 (Q3)'
WHEN modifiedtxndate BETWEEN '2024-01-01' AND '2024-03-31' THEN 'Jan 24-Mar-24 (Q4)'
WHEN modifiedtxndate BETWEEN '2025-01-01' AND '2025-03-31' THEN 'Jan 25-Mar-25 (Q4)' END 'period',modifiedstorecode,
MAX(frequencycount)maxfc,SUM(itemnetamount)itemnetamount,COUNT(DISTINCT uniquebillno)uniquebillno,SUM(itemqty)itemqty FROM 
sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2023-04-01' AND '2025-03-31' 
AND modifiedstorecode NOT LIKE '%demo%'
AND modifiedbillno NOT LIKE '%brn%'
AND modifiedbillno NOT LIKE '%roll%'
AND modifiedbillno NOT LIKE '%test%'
AND insertiondate <='2025-04-20'
GROUP BY 1,2)a
GROUP BY 1;

-- QC
SELECT COUNT(DISTINCT clientid)transactor FROM (
SELECT clientid,modifiedtxndate,modifiedstorecode,MAX(frequencycount)maxfc,SUM(itemnetamount)itemnetamount,COUNT(DISTINCT uniquebillno)uniquebillno,SUM(itemqty)itemqty FROM 
sku_report_loyalty 
WHERE modifiedtxndate BETWEEN '2023-07-01' AND '2023-09-30' 
AND storecode NOT LIKE '%demo%'
AND modifiedbillno NOT LIKE '%brn%'
AND modifiedbillno NOT LIKE '%roll%'
AND modifiedbillno NOT LIKE '%test%'
AND insertiondate <='2025-04-20'
GROUP BY 1,2)a;

-- txn points data 
SELECT CASE 
WHEN txndate BETWEEN '2023-04-01' AND '2023-06-30' THEN 'Apr 23-Jun-23 (Q1)'
WHEN txndate BETWEEN '2024-04-01' AND '2024-06-30' THEN 'Apr 24-Jun-24 (Q1)'
WHEN txndate BETWEEN '2023-07-01' AND '2023-09-30' THEN 'Jul 23-Sep-23 (Q2)'
WHEN txndate BETWEEN '2024-07-01' AND '2024-09-30' THEN 'Jul 24-Sep-24 (Q2)'
WHEN txndate BETWEEN '2023-10-01' AND '2023-12-31' THEN 'Oct 23-Dec-23 (Q3)'
WHEN txndate BETWEEN '2024-10-01' AND '2024-12-31' THEN 'Oct 24-Dec-24 (Q3)'
WHEN txndate BETWEEN '2024-01-01' AND '2024-03-31' THEN 'Jan 24-Mar-24 (Q4)'
WHEN txndate BETWEEN '2025-01-01' AND '2025-03-31' THEN 'Jan 25-Mar-25 (Q4)' 
END 'period',SUM(pointscollected)'Transactional Points Issued ',
SUM(pointsspent)'Points Redeemed'
FROM (
SELECT clientid,txndate,SUM(pointscollected)pointscollected,
SUM(pointsspent)pointsspent FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2023-04-01' AND '2025-03-31' 
AND storecode NOT LIKE '%demo%'
AND billno NOT LIKE '%brn%'
AND billno NOT LIKE '%roll%'
AND billno NOT LIKE '%test%'
AND insertiondate <='2025-04-20'
GROUP BY 1,2)a
GROUP BY 1;

-- QC
SELECT SUM(pointscollected)'Transactional Points Issued ',SUM(pointsspent)
FROM (
SELECT clientid,txndate,SUM(pointscollected)pointscollected,
SUM(pointsspent)pointsspent FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2023-04-01' AND '2023-06-30' 
AND storecode NOT LIKE '%demo%'
AND billno NOT LIKE '%brn%'
AND billno NOT LIKE '%roll%'
AND billno NOT LIKE '%test%'
AND insertiondate <='2025-04-20'
GROUP BY 1,2)a;

-- flat accrual bonus points 

SELECT CASE 
WHEN txndate BETWEEN '2023-04-01' AND '2023-06-30' THEN 'Apr 23-Jun-23 (Q1)'
WHEN txndate BETWEEN '2024-04-01' AND '2024-06-30' THEN 'Apr 24-Jun-24 (Q1)'
WHEN txndate BETWEEN '2023-07-01' AND '2023-09-30' THEN 'Jul 23-Sep-23 (Q2)'
WHEN txndate BETWEEN '2024-07-01' AND '2024-09-30' THEN 'Jul 24-Sep-24 (Q2)'
WHEN txndate BETWEEN '2023-10-01' AND '2023-12-31' THEN 'Oct 23-Dec-23 (Q3)'
WHEN txndate BETWEEN '2024-10-01' AND '2024-12-31' THEN 'Oct 24-Dec-24 (Q3)'
WHEN txndate BETWEEN '2024-01-01' AND '2024-03-31' THEN 'Jan 24-Mar-24 (Q4)'
WHEN txndate BETWEEN '2025-01-01' AND '2025-03-31' THEN 'Jan 25-Mar-25 (Q4)' 
END 'period',SUM(pointscollected)'Bonus Points Issued '
FROM (
SELECT clientid,txndate,SUM(pointscollected)pointscollected
FROM txn_report_flat_accrual
WHERE txndate BETWEEN '2023-04-01' AND '2025-03-31' 
AND storecode NOT LIKE '%demo%'
AND billno NOT LIKE '%brn%'
AND billno NOT LIKE '%roll%'
AND billno NOT LIKE '%test%'
AND insertiondate <='2025-04-20'
GROUP BY 1,2)a
GROUP BY 1;



###################################################### END ######################################################################################
######################################################   END  ######################################################################################
######################################################  END   ######################################################################################
 
 
 
 ######################################### Stat txn data mom##############################################
WITH txndata AS (
SELECT clientid,TxnMonth,TxnYear,SUM(itemnetAmount) AS sales,COUNT(DISTINCT (UniqueBillNo)) AS bills,
MAX(frequencycount) AS maxfc,SUM(itemqty)quantity
FROM sku_report_loyalty  
WHERE modifiedTxnDate BETWEEN '2023-04-01' AND '2025-03-31'
AND storecode NOT LIKE '%demo%' 
AND billno NOT LIKE '%test%' 
AND billno NOT LIKE '%roll%'
AND billno NOT LIKE '%brn%'
AND insertiondate <='2025-04-20'
GROUP BY 1,2,3
ORDER BY 2,3)
SELECT CONCAT(txnmonth,' ',txnyear)txnmonth,COUNT(DISTINCT a.clientid)Transactors,
COUNT(DISTINCT CASE WHEN maxfc>1 THEN a.clientid END)repeater,
COUNT(DISTINCT CASE WHEN maxfc=1 THEN a.clientid END)onetimer,
SUM(bills)bills,
SUM(CASE WHEN maxfc>1 THEN bills END)repeater_bills,
SUM(CASE WHEN maxfc=1 THEN bills END)onetimer_bills,
SUM(sales)sales,
SUM(CASE WHEN maxfc>1 THEN sales END)repeater_sales,
SUM(CASE WHEN maxfc=1 THEN sales END)onetimer_sales,
SUM(quantity)quantity,
SUM(CASE WHEN maxfc>1 THEN quantity END)repeater_quantity,
SUM(CASE WHEN maxfc=1 THEN quantity END)onetimer_quantity,
SUM(sales)/SUM(bills)ATV,
SUM(sales)/COUNT(DISTINCT a.clientid)AMV,
SUM(quantity)/SUM(bills)UPT,
SUM(sales)/SUM(quantity)ASP 
FROM txndata a 
GROUP BY txnmonth,txnyear
ORDER BY txnyear,txnmonth;


-- enrolledmen mom 
SELECT CONCAT(enrolledmonth,' ',enrolledyear)txnmonth, COUNT(DISTINCT clientid)enrollment FROM member_report 
WHERE modifiedenrolledon BETWEEN '2023-04-01' AND '2025-03-31'
AND enrolledstore NOT LIKE '%demo%'
AND insertiondate <='2025-04-20'
GROUP BY enrolledmonth,enrolledyear 
ORDER BY enrolledmonth,enrolledyear ;



#################################################################  END###########################################################################
#################################################################    END###########################################################################
#################################################################  END###########################################################################

#######################################repeat cohort start###############################################################################
#######################################repeat cohort start###############################################################################
#######################################repeat cohort start###############################################################################


WITH enrolled_cust AS
(SELECT clientid,MONTHNAME(txndate)enrolled_month,MIN(frequencycount)f1 FROM txn_report_accrual_redemption
    WHERE txndate>= '2024-04-01' AND txndate<='2025-03-31' 
    AND storecode NOT LIKE '%demo%'
    AND billno NOT LIKE '%test%'
    AND billno NOT LIKE '%roll%'
    AND insertiondate <='2025-04-20'
    GROUP BY 1,2 HAVING f1=1),
    transacted_cust AS
(SELECT clientid,MONTHNAME(txndate)transacted_month FROM txn_report_accrual_redemption
    WHERE txndate>= '2024-04-01' AND txndate<='2025-03-31'
    AND storecode NOT LIKE '%demo%'
    AND billno NOT LIKE '%test%'
    AND billno NOT LIKE '%roll%'AND insertiondate <='2025-04-20'
    GROUP BY 1,2)
    SELECT enrolled_month,transacted_month,COUNT(a.clientid)repeat_cust FROM enrolled_cust a
    JOIN transacted_cust b USING(clientid)
    GROUP BY 1,2;

####################################### repeat cohort end ###############################################################################
####################################### repeat cohort end ###############################################################################
####################################### repeat cohort end ###############################################################################




####################################### visit distribution start ###############################################################################
####################################### visit distribution start ###############################################################################
####################################### visit distribution start ###############################################################################



SELECT CASE WHEN visit<=10 THEN visit ELSE '10+' END visit_tag,COUNT(DISTINCT clientid)transacted_customer,SUM(sales)sales FROM (
SELECT clientid,SUM(itemnetamount)sales,COUNT(DISTINCT modifiedtxndate,clientid)visit FROM sku_report_loyalty
WHERE modifiedtxndate BETWEEN '2023-04-01' AND '2024-03-31' #change for different time duration 
AND modifiedstorecode NOT LIKE '%demo%'
AND modifiedbillno NOT LIKE '%brn%'
AND modifiedbillno NOT LIKE '%roll%'
AND modifiedbillno NOT LIKE '%test%'
AND insertiondate <='2025-04-20'
GROUP BY 1)a
GROUP BY 1;
####################################### visit distribution end ###############################################################################
####################################### visit distribution end ###############################################################################
####################################### visit distribution end ###############################################################################


####################################### latency buck start ###############################################################################
####################################### latency buck start ###############################################################################
####################################### latency buck start ###############################################################################



SELECT CASE WHEN latency <= 30 THEN '0-30'
WHEN latency >30 AND latency <=60 THEN '31-60'
WHEN latency >60 AND latency <= 90 THEN '61-90'
WHEN latency >90 AND latency <=120 THEN '91-120'
WHEN latency >120 AND latency <=150 THEN '121-150'
WHEN latency >150 AND latency <=180 THEN '151-180'
WHEN latency >180 AND latency <=210 THEN '181-210'
WHEN latency >210 AND latency <=240 THEN '211-240'
WHEN latency >240 AND latency <=270 THEN '241-270'
WHEN latency >270 AND latency <=300 THEN '271-300'
WHEN latency >300 AND latency <=330 THEN '301-330'
WHEN latency >330 AND latency <=360 THEN '331-360'
WHEN latency >360 AND latency <=390 THEN '361-390'
WHEN latency >390 THEN '>390' END 'latency bucketing',COUNT(DISTINCT clientid)customers FROM (
SELECT clientid,DATEDIFF(MAX(modifiedtxndate),MIN(modifiedtxndate))/NULLIF((COUNT(DISTINCT modifiedtxndate)-1),0)latency 
FROM sku_report_loyalty 
WHERE modifiedtxndate <='2025-03-31'
AND modifiedstorecode NOT LIKE '%demo%'
AND modifiedbillno NOT LIKE '%brn%'
AND modifiedbillno NOT LIKE '%roll%'
AND modifiedbillno NOT LIKE '%test%'
AND insertiondate <='2025-04-20'
GROUP BY 1)a
GROUP BY 1
ORDER BY latency;

####################################### latency buck start ###############################################################################
####################################### latency buck start ###############################################################################
####################################### latency buck start ###############################################################################





######################################################gender and age start######################################################################################
######################################################gender and age start######################################################################################
######################################################gender and age start######################################################################################


  
WITH sku_data AS 
(SELECT a.clientid,gender,customerage,(frequencycount)maxfc,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills,
DATEDIFF(MAX(modifiedtxndate),MIN(modifiedtxndate))/NULLIF((COUNT(DISTINCT modifiedtxndate)-1),0)latency,
COUNT(DISTINCT modifiedtxndate)visits,
SUM(itemqty)qty FROM member_report a JOIN sku_report_loyalty b ON a.clientid=b.clientid 
WHERE b.modifiedtxndate BETWEEN '2023-04-01' AND '2024-03-31' 
AND b.modifiedstorecode NOT LIKE '%demo%'
AND b.modifiedbillno NOT LIKE '%brn%'
AND b.modifiedbillno NOT LIKE '%roll%'
AND b.modifiedbillno NOT LIKE '%test%'
AND insertiondate <='2025-04-20'
GROUP BY 1,2,3),
txn_data AS(
SELECT a.clientid,gender,customerage,SUM(b.pointscollected)points_collected,SUM(b.pointsspent)points_spent FROM member_report a
JOIN txn_report_accrual_redemption b ON a.clientid=b.clientid
WHERE b.txndate BETWEEN '2023-04-01' AND '2024-03-31' 
AND b.storecode NOT LIKE '%demo%'
AND b.billno NOT LIKE '%brn%'
AND b.billno NOT LIKE '%roll%'
AND b.billno NOT LIKE '%test%'
AND insertiondate <='2025-04-20'
GROUP BY 1,2,3
)
SELECT CASE WHEN a.gender='male' THEN 'male'
WHEN a.gender ='female' THEN 'female' ELSE 'NUll' END 'gender',
CASE WHEN a.customerage <20 THEN '<20'
WHEN a.customerage BETWEEN 20 AND 25 THEN '20-25'
WHEN a.customerage BETWEEN 26 AND 30 THEN '26-30'
WHEN a.customerage BETWEEN 31 AND 35 THEN '31-35'
WHEN a.customerage BETWEEN 36 AND 40 THEN '36-40'
WHEN a.customerage >40 THEN 'above 40' END 'age bucketing',
COUNT(DISTINCT a.clientid)'cust',
COUNT(DISTINCT CASE WHEN maxfc>1 THEN a.clientid END )'repeater',
SUM(sales)/SUM(bills)ATV,SUM(sales)/COUNT(DISTINCT a.clientid)AMV,AVG(latency) avg_latency,
SUM(points_collected)total_points_issued,
SUM(points_spent)total_points_redemption,
AVG(visits) avg_visit,SUM(qty)/SUM(bills)UPT
FROM sku_data a JOIN txn_data b ON a.clientid=b.clientid 
GROUP BY 1,2;

######################################################gender and age end ##################################################################
######################################################gender and age end ##################################################################
######################################################gender and age end##################################################################

######################################################tier migration start##################################################################
###################################################### tier migration start##################################################################
###################################################### tier migration start##################################################################


CREATE TABLE dummy.SKS_tiermovement_Apr24
SELECT mobile, MAX(DATE(TierStartDate))AS TierStartDate FROM tier_report_log 
WHERE TierStartDate<='2024-04-30'  AND 1=0 GROUP BY 1; 

INSERT INTO dummy.SKS_tiermovement_Apr24
SELECT mobile, MAX(DATE(TierStartDate))AS TierStartDate FROM tier_report_log 
WHERE TierStartDate<='2024-04-30' GROUP BY 1; 

ALTER TABLE dummy.SKS_tiermovement_Apr24 ADD COLUMN tier_Apr24 VARCHAR(20),
UPDATE dummy.SKS_tiermovement_Apr24 a JOIN (SELECT mobile,DATE(TierStartDate) AS TierStartDate,currentTier 
FROM tier_report_log
WHERE DATE(TierStartDate)<='2024-04-30')b ON a.mobile=b.mobile AND a.tierstartdate=b.tierstartdate 
SET a.tier_Apr24=b.currenttier;

SELECT a.tier_mar25,b.tier_Apr24,
COUNT(mobile) FROM dummy.SKS_tiermovement_mar25 a JOIN dummy.SKS_tiermovement_Apr24 b USING(mobile)
GROUP BY 1,2;
######################################################tier migration end##################################################################
###################################################### tier migration end##################################################################
###################################################### tier migration end##################################################################
 
 
 
 
 
######################################################tier level data start##################################################################
###################################################### tier level data start##################################################################
###################################################### tier level data start##################################################################
 
 
 
 
-- tier level data 
SELECT a.tier,COUNT(DISTINCT b.clientid)transactor,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)'loyalty bills'
FROM member_report a LEFT JOIN sku_report_loyalty  b ON a.clientid=b.clientid
WHERE 
modifiedtxndate BETWEEN '2023-04-01' AND '2024-03-31' #when you pull lifetime data so comment this and below line 
AND 
b.modifiedstorecode NOT LIKE '%demo%'  
AND b.modifiedbillno NOT LIKE '%brn%'
AND b.modifiedbillno NOT LIKE '%roll%'
AND b.modifiedbillno NOT LIKE '%test%'
AND insertiondate <='2025-04-20'
GROUP BY 1;

-- redeemer sales points collected spend
SELECT a.tier, COUNT(DISTINCT CASE WHEN b.pointsspent>0 THEN b.clientid END)redeemers,
SUM(CASE WHEN b.pointsspent>0 THEN amount END)redeemers_sales,
SUM(b.pointscollected)LOYALTY_POINT_Issued,SUM(b.pointsspent)LOYALTY_POINT_Redeem 
FROM member_report a LEFT JOIN txn_report_accrual_redemption  b ON  a.clientid=b.clientid
WHERE 
txndate BETWEEN '2024-04-01' AND '2025-03-31' #when you pull lifetime data so comment this and below line 
AND
 storecode NOT LIKE '%demo%'
AND billno NOT LIKE '%brn%'
AND billno NOT LIKE '%roll%'
AND billno NOT LIKE '%test%'
AND insertiondate <='2025-04-20'
GROUP BY 1;

-- flat points 
SELECT a.tier, SUM(pointscollected)bonus_points 
FROM member_report a LEFT JOIN txn_report_flat_accrual  b ON a.clientid=b.clientid 
WHERE txndate BETWEEN '2023-04-01' AND '2024-03-31' #when you pull lifetime data so comment this and below line 
AND storecode NOT LIKE '%demo%'
AND billno NOT LIKE '%brn%'
AND billno NOT LIKE '%roll%'
AND billno NOT LIKE '%test%'
AND insertiondate <='2025-04-20'
GROUP BY 1;

########################################################tier level data end ####################################################################################
#########################################################tier level data end###################################################################################
#########################################################tier level data end###################################################################################



######################################################## state LEVEL DATA start ####################################################################################
######################################################### state LEVEL DATA start ###################################################################################
######################################################### state LEVEL DATA start ###################################################################################
 state LEVEL DATA 
SELECT state,COUNT(DISTINCT clientid)total_customer,COUNT(DISTINCT CASE WHEN maxfc=1 THEN clientid END)onetimer,
COUNT(DISTINCT CASE WHEN maxfc>1 THEN clientid END)repeater,
SUM(sales)total_sales,
SUM(CASE WHEN maxfc=1 THEN sales END)onetimer_sales,
SUM(CASE WHEN maxfc>1 THEN sales END)repeater_sales,
SUM(bills)total_bills,
SUM(CASE WHEN maxfc=1 THEN bills END)onetimer_bills,
SUM(CASE WHEN maxfc>1 THEN bills END)repeater_sales,
COUNT(DISTINCT modifiedstorecode)storecode,
SUM(qty)total_qty,SUM(CASE WHEN maxfc=1 THEN qty END)onetimer_qty,
SUM(CASE WHEN maxfc>1 THEN qty END)repeater_qty
FROM (
SELECT clientid,state,modifiedstorecode,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills,MAX(frequencycount)maxfc,SUM(itemqty)qty
FROM sku_report_loyalty a LEFT JOIN store_master b ON a.modifiedstorecode=b.storecode
WHERE modifiedtxndate BETWEEN '2023-04-01' AND '2024-03-31'
AND modifiedstorecode NOT LIKE '%demo%'
AND modifiedbillno NOT LIKE '%brn%'
AND modifiedbillno NOT LIKE '%roll%'
AND modifiedbillno NOT LIKE '%test%'
AND insertiondate <='2025-04-20'
GROUP BY 1,2,3)a
GROUP BY 1;

######################################################## state LEVEL DATA end ####################################################################################
######################################################### state LEVEL DATA end ###################################################################################
######################################################### state LEVEL DATA end ###################################################################################


#######################################################region level data start#####################################################################################
########################################################region level data start####################################################################################
########################################################region level data start####################################################################################
-- 
SELECT region,COUNT(DISTINCT clientid)total_customer,COUNT(DISTINCT CASE WHEN maxfc=1 THEN clientid END)onetimer,
COUNT(DISTINCT CASE WHEN maxfc>1 THEN clientid END)repeater,
SUM(sales)total_sales,
SUM(CASE WHEN maxfc=1 THEN sales END)onetimer_sales,
SUM(CASE WHEN maxfc>1 THEN sales END)repeater_sales,
SUM(bills)total_bills,
SUM(CASE WHEN maxfc=1 THEN bills END)onetimer_bills,
SUM(CASE WHEN maxfc>1 THEN bills END)repeater_sales,
SUM(storecode)storecode,
SUM(qty)total_qty,SUM(CASE WHEN maxfc=1 THEN qty END)onetimer_qty,
SUM(CASE WHEN maxfc>1 THEN qty END)repeater_qty
FROM (
SELECT clientid,region,COUNT(DISTINCT modifiedstorecode)storecode,SUM(itemnetamount)sales,
COUNT(DISTINCT uniquebillno)bills,MAX(frequencycount)maxfc,SUM(itemqty)qty
FROM sku_report_loyalty a LEFT JOIN store_master b ON a.modifiedstorecode=b.storecode
WHERE modifiedtxndate BETWEEN '2023-04-01' AND '2024-03-31'
AND modifiedstorecode NOT LIKE '%demo%'
AND modifiedbillno NOT LIKE '%brn%'
AND modifiedbillno NOT LIKE '%roll%'
AND modifiedbillno NOT LIKE '%test%'
AND insertiondate <='2025-04-20'

GROUP BY 1,2)a
GROUP BY 1;
#######################################################region level data end#####################################################################################
########################################################region level data end####################################################################################
########################################################region level data end####################################################################################




###########################################################store level data start #################################################################################
###########################################################store level data start #################################################################################
############################################################store level data start ################################################################################

 
SELECT modifiedstorecode,COUNT(DISTINCT clientid)total_customer,COUNT(DISTINCT CASE WHEN maxfc=1 THEN clientid END)onetimer,
COUNT(DISTINCT CASE WHEN maxfc>1 THEN clientid END)repeater,
SUM(sales)total_sales,
SUM(CASE WHEN maxfc=1 THEN sales END)onetimer_sales,
SUM(CASE WHEN maxfc>1 THEN sales END)repeater_sales,
SUM(bills)total_bills,
SUM(CASE WHEN maxfc=1 THEN bills END)onetimer_bills,
SUM(CASE WHEN maxfc>1 THEN bills END)repeater_sales,
COUNT(DISTINCT modifiedstorecode)storecode,
SUM(qty)total_qty,SUM(CASE WHEN maxfc=1 THEN qty END)onetimer_qty,
SUM(CASE WHEN maxfc>1 THEN qty END)repeater_qty
FROM (
SELECT clientid,modifiedstorecode,SUM(itemnetamount)sales,
COUNT(DISTINCT uniquebillno)bills,MAX(frequencycount)maxfc,SUM(itemqty)qty
FROM sku_report_loyalty a LEFT JOIN store_master b ON a.modifiedstorecode=b.storecode
WHERE modifiedtxndate BETWEEN '2023-04-01' AND '2024-03-31'
AND modifiedstorecode NOT LIKE '%demo%'
AND modifiedbillno NOT LIKE '%brn%'
AND modifiedbillno NOT LIKE '%roll%'
AND modifiedbillno NOT LIKE '%test%'
AND insertiondate <='2025-04-20'
GROUP BY 1,2)a
GROUP BY 1;

###########################################################store level data end #################################################################################
###########################################################store level data end #################################################################################
############################################################store level data end ################################################################################

