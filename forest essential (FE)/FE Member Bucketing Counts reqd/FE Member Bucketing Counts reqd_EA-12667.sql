CREATE TABLE dummy.fe_Member_Bucketing_harish_1
SELECT membershipno,email,mobile,modifiedenrolledon,tier,enrolledstorecode 
FROM member_report
WHERE modifiedenrolledon <= '2025-10-28' AND enrolledstorecode <> 'demo';#595898 row(s) affected


ALTER TABLE dummy.fe_Member_Bucketing_harish_1 ADD INDEX membershipno(membershipno), ADD COLUMN sales FLOAT,ADD COLUMN recency VARCHAR(200);

UPDATE dummy.fe_Member_Bucketing_harish_1 a JOIN (
SELECT membershipcardnumber,SUM(amount)sales,DATEDIFF('2025-10-28',MAX(txndate))recency FROM txn_report_accrual_redemption 
WHERE txndate<='2025-10-28'
AND amount>0 AND storecode <> 'demo'
AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
GROUP BY 1)b ON a.membershipno = b.membershipcardnumber
SET a.sales=b.sales,a.recency=b.recency;#435798 row(s) affected


SELECT * FROM dummy.fe_Member_Bucketing_harish_1;

ALTER TABLE dummy.fe_Member_Bucketing_harish_1 ADD COLUMN active_nonactive VARCHAR(200);

UPDATE dummy.fe_Member_Bucketing_harish_1
SET a.active_nonactive = 
CASE WHEN (tier= 'Platinum' AND recency <=90) THEN 'active'
WHEN (tier= 'Gold' AND recency <=180) THEN 'active'
WHEN (tier= 'Silver' AND recency <=270) THEN 'active'
WHEN (tier= 'Bronze' AND recency <=365) THEN 'active'
ELSE 'Non active' END active_nonactive;


SELECT DISTINCT membershipno,email,mobile,modifiedenrolledon,tier,sales,active_nonactive
FROM dummy.fe_Member_Bucketing_harish_1;

SELECT DISTINCT tier FROM member_report;



###############################################################
-- this is without creating table 
WITH member_base AS (
    SELECT 
        membershipno,
        email,
        mobile,
        modifiedenrolledon,
        tier,
        enrolledstorecode
    FROM member_report
    WHERE modifiedenrolledon <= '2025-10-28'
      AND enrolledstorecode <> 'demo'
),

txn_data AS (
    SELECT 
        membershipcardnumber,
        SUM(amount) AS sales,
        DATEDIFF('2025-10-28', MAX(txndate)) AS recency
    FROM txn_report_accrual_redemption 
    WHERE txndate <= '2025-10-28'
      AND amount > 0
      AND storecode <> 'demo'
      AND billno NOT LIKE '%test%'
      AND billno NOT LIKE '%roll%'
    GROUP BY membershipcardnumber
)

SELECT 
    DISTINCT a.membershipno,
    a.email,
    a.mobile,
    a.modifiedenrolledon,
    a.tier,
    IFNULL(b.sales, 0) AS sales,
    CASE 
        WHEN a.tier = 'Platinum' AND (b.recency) <= 90 THEN 'Active'
        WHEN a.tier = 'Gold' AND (b.recency) <= 180 THEN 'Active'
        WHEN a.tier = 'Silver' AND (b.recency) <= 270 THEN 'Active'
        WHEN a.tier = 'Bronze' AND (b.recency) <= 365 THEN 'Active'
        ELSE 'Non Active'
    END AS active_nonactive
FROM member_base a
LEFT JOIN txn_data b 
    ON a.membershipno = b.membershipcardnumber;



SELECT SUM(amount) FROM txn_report_accrual_redemption 
WHERE membershipcardnumber = '1000986992213544'
AND txndate<='2025-10-28'
AND amount>0 AND storecode <> 'demo'
AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%';