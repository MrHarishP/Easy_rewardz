SELECT MONTHNAME(modifiedtxndate)txnmonth,COUNT(DISTINCT clientid)customer,
SUM(itemnetamount)sales,SUM(itemqty)qty 
FROM sku_report_loyalty
WHERE modifiedtxndate BETWEEN '2025-01-01' AND '2025-08-31'
AND uniqueitemcode IN ('BS-23221001',
'BS-23221R001',
'BS-23221P01',
'BS-23221PR01'
) 
AND modifiedstorecode NOT IN ('demo','corporate') 
AND billno NOT LIKE '%brn%' 
AND billno NOT LIKE '%roll%'
AND billno NOT LIKE '%test%'
AND itemnetamount>0
GROUP BY 1
ORDER BY modifiedtxndate;

SELECT * FROM  sku_report_loyalty;

SELECT * FROM item_master
WHERE uniqueitemcode IN ('BS-23221001',
'BS-23221R001',
'BS-23221P01',
'BS-23221PR01');



-- clientid ,current tier sales ,current tier bill;
-- friend tier 
INSERT INTO dummy.fence_sitter_friend_club
SELECT DISTINCT 'Fence Sitter-Friend ( Customers who have current tier as Friend & have spent between 3,000 & 5,000 in last 1 year)'AS 'tag'
,clientid
FROM (
SELECT clientid,
SUM(currenttierspends)sales,
SUM(currenttierbills)bills FROM tier_detail_report 
WHERE tierstartdate BETWEEN '2025-01-01' AND  '2025-08-31'
AND currenttier = 'friend' 
-- AND storecode NOT IN ('demo','corporate') 
-- AND billno NOT LIKE '%brn%' 
-- AND billno NOT LIKE '%roll%'
-- AND billno NOT LIKE '%test%'
-- AND amount>0
GROUP BY 1
)a
WHERE sales BETWEEN 3000 AND 5000 ;#20822

SELECT * FROM tier_detail_report

-- club tier 
INSERT INTO dummy.fence_sitter_friend_club 
SELECT DISTINCT 'Fence Sitter- Club ( Customers who have current tier as Club & have spent between 12,000 & 15,000 in last 1 year)'AS 'tag',
clientid 
FROM (
SELECT clientid,
SUM(currenttierspends)sales,
SUM(currenttierbills)bills FROM tier_detail_report
WHERE tierstartdate BETWEEN '2025-01-01' AND  '2025-08-31'
AND currenttier = 'club' 
GROUP BY 1
)a
WHERE sales BETWEEN 12000 AND 15000;#1061

SELECT tag,COUNT(DISTINCT clientid)customers FROM 
dummy.fence_sitter_friend_club
GROUP BY 1
