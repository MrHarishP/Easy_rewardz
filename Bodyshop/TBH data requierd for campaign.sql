SELECT * FROM `tier_report_log`;
SELECT * FROM `program_single_view` LIMIT 100;
SELECT * FROM member_report LIMIT 100;
 


-- current tier friend and previous tier was club 
SELECT mobile,a.recency,a.enrolledstore,c.isNondnd ,c.tier,b.previoustier FROM `program_single_view` a
JOIN `tier_report_log` b USING(mobile)
JOIN member_report c USING(mobile)
WHERE c.tier LIKE 'Friend' AND b.previoustier LIKE 'club' AND a.enrolledstore NOT LIKE '%Demo%'
GROUP BY 1;
-- current tier friend and previous tier was platinum 
SELECT mobile,a.recency,a.enrolledstore,c.isNondnd ,currenttier,previoustier FROM `program_single_view` a
JOIN `tier_report_log` b USING(mobile)
JOIN member_report c USING(mobile)
WHERE currenttier LIKE 'Friend' AND previoustier LIKE 'platinum' AND a.enrolledstore NOT LIKE '%Demo%'
GROUP BY 1;

SELECT mobile,DATEDIFF(MAX(txndate),MIN(txndate))recency,b.enrolledstorecode,b.isnondnd,b.tier,previoustier FROM txn_report_accrual_redemption a
JOIN member_report b USING(mobile) 
JOIN `tier_report_log` USING(mobile)
WHERE currenttier LIKE 'Friend' AND previoustier LIKE 'platinum' AND b.enrolledstore NOT LIKE '%Demo%'
GROUP BY 1

SELECT mobile,DATEDIFF(MAX(txndate),MIN(txndate))recency,b.enrolledstorecode,b.isnondnd,b.tier,previoustier FROM txn_report_accrual_redemption a
JOIN member_report b USING(mobile) 
JOIN `tier_report_log` USING(mobile)
WHERE currenttier LIKE 'Friend' AND previoustier LIKE 'club' AND b.enrolledstore NOT LIKE '%Demo%'
GROUP BY 1




SELECT a.mobile,currenttier,previoustier,d.recency,c.isnondnd,c.enrolledstorecode FROM (
SELECT mobile,MAX(DATE(tierchangedate))max_tierchangedate FROM `tier_report_log` 
WHERE DATE(tierchangedate)<='2025-03-06' AND currenttier='Friend' AND previoustier='club'
GROUP BY 1)a
JOIN `tier_report_log` b ON a.mobile=b.mobile AND DATE(tierchangedate)=a.max_tierchangedate
JOIN member_report c ON a.mobile=b.mobile
JOIN `program_single_view` d ON a.mobile=d.mobile
GROUP BY 1



CREATE TABLE dummy.dummy.changetierclubclub 
SELECT a.mobile,currenttier,previoustier FROM (
SELECT mobile,MAX(DATE(tierchangedate))max_tierchangedate FROM tier_report_log
WHERE DATE(tierchangedate)<='2025-03-06' AND currenttier='Friend' AND previoustier='club'
GROUP BY 1)a
JOIN tier_report_log b ON a.mobile=b.mobile AND DATE(tierchangedate)=a.max_tierchangedate
GROUP BY 1;#249860

ALTER TABLE dummy.changetierclub ADD INDEX mobile(mobile);
ALTER TABLE dummy.changetierclub ADD COLUMN recency VARCHAR(100),
ADD COLUMN enrolledstorecode VARCHAR(50),ADD COLUMN isnondnd INT;


UPDATE dummy.changetierclub a
JOIN (
SELECT mobile,DATEDIFF(MAX(txndate),MIN(txndate))recency FROM txn_report_accrual_redemption 
GROUP BY 1)b USING(mobile)
SET a.recency=b.recency;#249698

UPDATE dummy.changetierclub a
JOIN(
SELECT mobile,enrolledstorecode,isnondnd FROM member_report 
WHERE enrolledstorecode NOT LIKE '%Demo%'
GROUP BY 1)b USING(mobile)
SET a.enrolledstorecode=b.enrolledstorecode,a.isnondnd=b.isnondnd;#249805
SELECT * FROM dummy.changetierclub;







CREATE TABLE dummy.dummy.changetierclubclub 
SELECT a.mobile,currenttier,previoustier FROM (
SELECT mobile,MAX(DATE(tierchangedate))max_tierchangedate FROM tier_report_log
WHERE DATE(tierchangedate)<='2025-03-06' AND currenttier='Friend' AND previoustier='club'
GROUP BY 1)a
JOIN tier_report_log b ON a.mobile=b.mobile AND DATE(tierchangedate)=a.max_tierchangedate
GROUP BY 1;#249860

ALTER TABLE dummy.changetierclub ADD INDEX mobile(mobile);
ALTER TABLE dummy.changetierclub ADD COLUMN recency VARCHAR(100),
ADD COLUMN enrolledstorecode VARCHAR(50),ADD COLUMN isnondnd INT;


UPDATE dummy.changetierclub a
JOIN (
SELECT mobile,recency FROM `program_single_view` 
GROUP BY 1)b USING(mobile)
SET a.recency=b.recency;#249653

UPDATE dummy.changetierclub a
JOIN(
SELECT mobile,enrolledstorecode,isnondnd FROM member_report 
WHERE enrolledstorecode NOT LIKE '%Demo%'
GROUP BY 1)b USING(mobile)
SET a.enrolledstorecode=b.enrolledstorecode,a.isnondnd=b.isnondnd;#249805
SELECT * FROM dummy.changetierclub;






CREATE TABLE dummy.changetierplatinum 
SELECT a.mobile,currenttier,previoustier FROM (
SELECT mobile,MAX(DATE(tierchangedate))max_tierchangedate FROM tier_report_log
WHERE DATE(tierchangedate)<='2025-03-06' AND currenttier='Friend' AND previoustier='platinum'
GROUP BY 1)a
JOIN tier_report_log b ON a.mobile=b.mobile AND DATE(tierchangedate)=a.max_tierchangedate
GROUP BY 1;#40

ALTER TABLE dummy.changetierplatinum  ADD INDEX mobile(mobile);
ALTER TABLE dummy.changetierplatinum  ADD COLUMN recency VARCHAR(100),
ADD COLUMN enrolledstorecode VARCHAR(50),ADD COLUMN isnondnd INT;


UPDATE dummy.changetierplatinum  a
JOIN (
SELECT mobile,recency FROM `program_single_view` 
GROUP BY 1)b USING(mobile)
SET a.recency=b.recency;#249653

UPDATE dummy.changetierplatinum  a
JOIN(
SELECT mobile,enrolledstorecode,isnondnd FROM member_report 
WHERE enrolledstorecode NOT LIKE '%Demo%'
GROUP BY 1)b USING(mobile)
SET a.enrolledstorecode=b.enrolledstorecode,a.isnondnd=b.isnondnd;#37
SELECT * FROM dummy.changetierplatinum ;








SELECT * FROM dummy.tbs_tier_camp_data
WHERE privioustier='platinum'




SELECT a.mobile,last_txndate,currenttier FROM (
SELECT mobile,MAX(tierchangedate)last_txndate FROM tier_report_log 
WHERE mobile IS NOT NULL AND mobile NOT LIKE ''
GROUP BY 1)a JOIN tier_report_log b ON a.mobile=b.mobile AND DATE(tierchangedate)=last_txndate
GROUP BY 1,2;

SELECT * FROM tier_report_log;






SELECT a.mobile,currenttier FROM (
SELECT mobile,tierchangedate,DENSE_RANK()OVER(PARTITION BY mobile ORDER BY tierchangedate DESC) ranked
FROM tier_report_log 
WHERE mobile IS NOT NULL
GROUP BY 1)a JOIN tier_report_log b ON a.mobile=b.mobile AND DATE(b.tierchangedate)=ranked
GROUP BY 1,2













SELECT mobile,currenttier FROM
(SELECT mobile,DENSE_RANK()OVER(PARTITION BY mobile ORDER BY tierchangedate DESC)ranked,currenttier
FROM tier_report_log
GROUP BY 1)a
WHERE ranked=2








SELECT mobile,txndate,tiername FROM txn_report_accrual_redemption
WHERE mobile='6000138534'
GROUP BY 1,2






SELECT a.membershipcardno,a.currenttier,MAX(tierchangedate) FROM tier_report_log a
JOIN tier_detail_report b ON a.membershipcardno=b.membershipcardno AND a.tierstartdate=b.tierstartdate
GROUP BY 1 LIMIT 100;


SELECT membershipcardno,currenttier FROM tier_report_log
WHERE membershipcardno='302029910'























########################## Final query TBH for tier from club to freind and platinum to friend 

CREATE TABLE dummy.harish_platinum_to_freiend_tier_data
WITH RankedTiers AS (
    SELECT
        mobile,
        CurrentTier,
        PreviousTier,
        TierStartDate,
        TierEndDate,
        TierChangeDate,
        ROW_NUMBER() OVER (PARTITION BY mobile ORDER BY tierchangedate DESC) AS rn
    FROM
        tier_report_log
),
tierdata AS (
SELECT
    mobile,
    MAX(CASE WHEN rn = 1 THEN CurrentTier END) AS CurrentTier,
    MAX(CASE WHEN rn = 2 THEN CurrentTier END) AS PreviousTier
FROM
    RankedTiers
GROUP BY
    mobile)
    SELECT mobile,currenttier,PreviousTier FROM tierdata
    WHERE currenttier='friend' AND PreviousTier='platinum'
    GROUP BY 1;#club 100297   platinum 20
    
    
    ALTER TABLE dummy.harish_platinum_to_freiend_tier_data ADD INDEX mobile(mobile);
    ALTER TABLE dummy.harish_platinum_to_freiend_tier_data ADD COLUMN isnnondnd VARCHAR(20),ADD COLUMN enrolledstorecode VARCHAR(50);
    
    UPDATE dummy.harish_platinum_to_freiend_tier_data a
    JOIN (
    SELECT mobile,isnondnd ,enrolledstorecode FROM member_report
    GROUP  BY 1)b USING(mobile)
    SET a.isnnondnd=b.isnondnd,a.enrolledstorecode=b.enrolledstorecode;# club 100283 platinum 20 
    
    ALTER TABLE dummy.harish_platinum_to_freiend_tier_data ADD COLUMN recency VARCHAR(100);
    
    UPDATE dummy.harish_platinum_to_freiend_tier_data a
    JOIN (
    SELECT mobile,DATEDIFF('2025-03-10',MAX(txndate))recency FROM txn_report_accrual_redemption 
    GROUP BY 1)b USING(mobile)
    SET a.recency=b.recency;#club 100260 platinumn 20
    
    
    
    SELECT * FROM dummy.harish_platinum_to_freiend_tier_data ;
    
    SELECT * FROM dummy.harish_tier_data;
    
    
SELECT mobile,tier FROM member_report
    WHERE mobile='6239051568'