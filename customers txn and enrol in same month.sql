

-- customer who enrolled on same month and also transact in same month 
WITH ent AS(
SELECT mobile FROM member_report
WHERE modifiedenrolledon BETWEEN '2025-01-01' AND '2025-02-28'
GROUP BY 1
),#149216
tne AS(
SELECT mobile FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2025-01-01' AND '2025-02-28'
GROUP BY 1 
)#163216
SELECT COUNT(DISTINCT mobile) FROM ent AS a
JOIN tne AS b USING(mobile);#123132



-- another way 
SELECT COUNT(DISTINCT mobile) FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2025-01-01' AND '2025-02-28'
AND mobile IN (SELECT DISTINCT mobile FROM member_report WHERE modifiedenrolledon BETWEEN '2025-01-01' AND '2025-02-28')
