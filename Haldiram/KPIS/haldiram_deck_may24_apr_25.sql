-- enrollment
SELECT COUNT(DISTINCT mobile)enrollements FROM member_report
WHERE modifiedenrolledon BETWEEN '2024-05-01' AND '2025-04-30';


-- txn_data
SELECT COUNT(DISTINCT mobile)total_transactor,
COUNT(DISTINCT CASE WHEN maxfc=1 THEN mobile END)'New Customers (One timer)',
COUNT(DISTINCT CASE WHEN maxfc>1 THEN mobile END)'Repeater Customers',
SUM(sales)loyalty_sales,
SUM(CASE WHEN maxfc=1 THEN sales END)'Sales from New Customers',
SUM(CASE WHEN maxfc>1 THEN sales END)'Sales from Repeaters',
SUM(bills)loyalty_bills,
SUM(CASE WHEN maxfc=1 THEN bills END)'Bills from New Customers',
SUM(CASE WHEN maxfc>1 THEN bills END)'Bills from Repeaters',
SUM(CASE WHEN maxfc=1 THEN sales END)/SUM(CASE WHEN maxfc=1 THEN bills END)'ATV - New',
SUM(CASE WHEN maxfc>1 THEN sales END)/SUM(CASE WHEN maxfc>1 THEN bills END)'ATV - Repeat',
SUM(CASE WHEN maxfc=1 THEN sales END)/COUNT(DISTINCT CASE WHEN maxfc=1 THEN mobile END)'AMV - New',
SUM(CASE WHEN maxfc>1 THEN sales END)/COUNT(DISTINCT CASE WHEN maxfc>1 THEN mobile END)'AMV - Repeat',
SUM(points_issued)points_issued,
SUM(points_redemeed)points_redemeed,
COUNT(DISTINCT CASE WHEN points_redemeed>0 THEN mobile END)'Point Redeemers',
SUM(CASE WHEN points_redemeed>0 THEN sales END)'Redemption Sales',
SUM(CASE WHEN points_redemeed>0 THEN bills END)'Redemption Bills',
SUM(maxfc)/COUNT(DISTINCT mobile)avg_frequency,
SUM(CASE WHEN maxfc>1 THEN maxfc END)/COUNT(DISTINCT CASE WHEN maxfc>1 THEN mobile END)avg_frequency_repeater,
SUM(latency)/COUNT(DISTINCT mobile)'Latency of Repeaters'
FROM(
SELECT mobile,SUM(amount)sales,COUNT(DISTINCT uniquebillno)bills,MAX(frequencycount)maxfc,
DATEDIFF(MAX(txndate),MIN(txndate))/NULLIF((COUNT(DISTINCT txndate)-1),0)latency,
SUM(pointscollected)points_issued,
SUM(pointsspent)points_redemeed
FROM txn_report_accrual_redemption
WHERE txndate BETWEEN '2024-05-01' AND '2025-04-30'
AND storecode <> 'demo'
AND billno <> '%roll%'
AND billno <> '%test%'
GROUP BY 1)a;

-- nonloyalty data
SELECT SUM(itemnetamount)nonloyalty_sales,COUNT(DISTINCT uniquebillno)nonloyalty_bills 
FROM sku_report_nonloyalty
WHERE modifiedtxndate BETWEEN '2024-05-01' AND '2025-04-30'
AND modifiedstorecode <> 'demo'
AND billno <> '%roll%'
AND billno <> '%test%';


-- sku_data for itemqty and upt
SELECT SUM(sales)sku_loyalty_sales,
SUM(CASE WHEN maxfc=1 THEN sales END)'sku_Sales from New Customers',
SUM(CASE WHEN maxfc>1 THEN sales END)'sku_Sales from Repeaters',
SUM(bills),
SUM(CASE WHEN maxfc=1 THEN bills END)'Bills from New Customers',
SUM(CASE WHEN maxfc>1 THEN bills END)'Bills from Repeaters',
SUM(CASE WHEN maxfc=1 THEN qty END)'Qty from New Customers',
SUM(CASE WHEN maxfc>1 THEN qty END)'Qty from Repeaters',
SUM(CASE WHEN maxfc=1 THEN qty END)/SUM(CASE WHEN maxfc=1 THEN bills END)'UPT - New ',
SUM(CASE WHEN maxfc>1 THEN qty END)/SUM(CASE WHEN maxfc>1 THEN bills END)'UPT - Repeat' FROM (
SELECT txnmappedmobile,SUM(itemnetamount)sales,COUNT(DISTINCT uniquebillno)bills,SUM(itemqty)qty,
MAX(frequencycount)maxfc 
FROM sku_report_loyalty
WHERE modifiedtxndate BETWEEN '2024-05-01' AND '2025-04-30'
AND modifiedstorecode <> 'demo'
AND billno <> '%roll%'
AND billno <> '%test%'
GROUP BY 1)a;

-- storecount
SELECT COUNT(DISTINCT storecode)storecount FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2024-05-01' AND '2025-04-30'
AND storecode <> 'demo'
AND billno <> '%roll%'
AND billno <> '%test%';