
## Final Query to exract output for TBS Campaigns

SELECT * FROM dummy.SanketK_Bodyshop_01mar25_Birthday_Same_Month; 
SELECT * FROM dummy.SanketK_Bodyshop_01mar25_Birthday_Same_Month_new_Register;
SELECT * FROM dummy.SanketK_Bodyshop_01mar25_Renewal_Club;
SELECT * FROM dummy.SanketK_Bodyshop_01mar25_Renewal_Platinum;

#Birthday_Same_Month
CREATE TABLE dummy.SanketK_Bodyshop_01mar25_Birthday_Same_Month_final
       SELECT
  `a`.`Mobile`             AS `Mobile`,
  `a`.`FirstName`          AS `FirstName`,
  `a`.`LastName`           AS `LastName`,
  `a`.`MembershipNo`       AS `MembershipNo`,
  `a`.`ClientID`           AS `ClientID`,
  `a`.`DateOfBirth`        AS `DateofBirth`,
  `a`.`EnrolledStore`      AS `EnrolledStore`,
  `a`.`EnrolledStoreCode`  AS `EnrolledStoreCode`,
  `a`.`ModifiedEnrolledOn` AS `ModifiedEnrolledon`,
  `b`.`CurrentTier`        AS `tier`,
  `b`.`TierEndDate`        AS `Tierenddate`,
  `b`.`TierStartDate`      AS `TierStartDate`
FROM (thebodyshop.`member_report` `a`
   LEFT JOIN thebodyshop.`tier_detail_report` `b`
     ON ((`a`.`ClientID` = `b`.`ClientId`)))
WHERE ((`b`.`CurrentTier` IN('Club','Friend','Platinum'))
       AND (`a`.`Tier` IN('Club','Friend','Platinum'))
       AND (MONTH(`a`.`DateOfBirth`) = MONTH(CURDATE()))
       AND (`a`.`Mobile` IS NOT NULL)
       AND (`a`.`Mobile` <> ' ')
       AND (`b`.`TierEndDate` >= CURDATE()));  -- 187202
       
       
ALTER TABLE dummy.SanketK_Bodyshop_01mar25_Birthday_Same_Month ADD INDEX mobile(mobile);
ALTER TABLE dummy.SanketK_Bodyshop_01mar25_Birthday_Same_Month ADD COLUMN LastTxnDate VARCHAR(20);


UPDATE dummy.SanketK_Bodyshop_01mar25_Birthday_Same_Month a JOIN(
SELECT mobile,MAX(txndate)LastTxnDate
FROM thebodyshop.`txn_report_accrual_redemption`
GROUP BY 1)b USING(mobile)
SET a.LastTxnDate=b.LastTxnDate; -- 161079

#Birthday_Same_Month_new_Register
CREATE TABLE dummy.SanketK_Bodyshop_01mar25_Birthday_Same_Month_new_Register
SELECT
  `a`.`Mobile`             AS `Mobile`,
  `a`.`FirstName`          AS `FirstName`,
  `a`.`LastName`           AS `LastName`,
  `a`.`MembershipNo`       AS `MembershipNo`,
  `a`.`ClientID`           AS `ClientID`,
  `a`.`DateOfBirth`        AS `DateofBirth`,
  `a`.`EnrolledStore`      AS `EnrolledStore`,
  `a`.`EnrolledStoreCode`  AS `EnrolledStoreCode`,
  `a`.`ModifiedEnrolledOn` AS `ModifiedEnrolledon`,
  `a`.`Tier`               AS `Tier`,
  `b`.`TierEndDate`        AS `TierEndDate`,
  `b`.`TierStartDate`      AS `TierStartDate`
FROM (`thebodyshop`.`member_report` `a`
   LEFT JOIN `thebodyshop`.`tier_detail_report` `b`
     ON ((`a`.`ClientID` = `b`.`ClientId`)))
WHERE ((MONTH(`a`.`DateOfBirth`) = MONTH((CURDATE() - INTERVAL 1 MONTH)))
       AND (`a`.`Tier` IN('Club','Friend','Platinum'))  
       AND (`b`.`CurrentTier` IN('Club','Friend','Platinum')) 
       AND (`a`.`Mobile` IS NOT NULL)
       AND (`a`.`Mobile` <> ' ')
       AND (MONTH(`a`.`ModifiedEnrolledOn`) = MONTH((CURDATE() - INTERVAL 1 MONTH)))
       AND (YEAR(`a`.`ModifiedEnrolledOn`) = YEAR(CURDATE()))
       AND (`b`.`TierEndDate` >= CURDATE())); -- 6335
       
       


ALTER TABLE dummy.SanketK_Bodyshop_01mar25_Birthday_Same_Month_new_Register ADD INDEX mobile(mobile);
ALTER TABLE dummy.SanketK_Bodyshop_01mar25_Birthday_Same_Month_new_Register ADD COLUMN LastTxnDate VARCHAR(20);


UPDATE dummy.SanketK_Bodyshop_01mar25_Birthday_Same_Month_new_Register a JOIN(
SELECT mobile,MAX(txndate)LastTxnDate
FROM thebodyshop.`txn_report_accrual_redemption`
GROUP BY 1)b USING(mobile)
SET a.LastTxnDate=b.LastTxnDate; -- 5855

# Renewal
#Club
CREATE TABLE dummy.SanketK_Bodyshop_01mar25_Renewal_Club
SELECT
  `b`.`Mobile`            AS `Mobile`,
  `b`.`FirstName`         AS `Firstname`,
  `b`.`EnrolledStore`     AS `Enrolledstore`,
  `b`.`EnrolledStoreCode` AS `Enrolledstorecode`,
  `a`.`MembershipCardNo`  AS `Membershipcardno`,
  `a`.`TierStartDate`     AS `TierStartDate`,
  `a`.`TierEndDate`       AS `Tierenddate`,
  `a`.`CurrentTier`       AS `Currenttier`,
  (5000 - IFNULL(`a`.`CurrentTierSpends`,0)) AS `Distance`,
  (CASE WHEN (`a`.`CurrentTierSpends` >= '5000') THEN 'Free Renewal' 
	WHEN ((`a`.`CurrentTierSpends` <= '4999') AND (`a`.`CurrentTierSpends` >= '4501')) THEN '< INR 500' 
	WHEN (IFNULL(`a`.`CurrentTierSpends`,0) <= '4501') THEN 'INR 500 to 5000' END) AS `Amount left to reach INR 5000`,
  IFNULL(`a`.`CurrentTierSpends`,0) AS `Currenttierspends`,
  `b`.`ClientID`          AS `Clientid`
FROM (`thebodyshop`.`tier_detail_report` `a`
JOIN `thebodyshop`.`member_report` `b`
ON ((`a`.`ClientId` = `b`.`ClientID`)))
WHERE ((`a`.`TierEndDate` = LAST_DAY(NOW()))
AND (`a`.`CurrentTier` = 'Club')
AND (`b`.`Tier` = 'Club')
AND (`b`.`Mobile` IS NOT NULL)
AND (`b`.`Mobile` <> '')); -- 10182

ALTER TABLE dummy.SanketK_Bodyshop_01mar25_Renewal_Club ADD INDEX mobile(mobile);
ALTER TABLE dummy.SanketK_Bodyshop_01mar25_Renewal_Club ADD COLUMN LastTxnDate VARCHAR(20);


UPDATE dummy.SanketK_Bodyshop_01mar25_Renewal_Club a JOIN(
SELECT mobile,MAX(txndate)LastTxnDate
FROM thebodyshop.`txn_report_accrual_redemption`
GROUP BY 1)b USING(mobile)
SET a.LastTxnDate=b.LastTxnDate; -- 10176

# for platinum
CREATE TABLE dummy.SanketK_Bodyshop_01mar25_Renewal_Platinum
SELECT
  `b`.`Mobile`            AS `Mobile`,
  `b`.`FirstName`         AS `Firstname`,
  `b`.`EnrolledStore`     AS `Enrolledstore`,
  `b`.`EnrolledStoreCode` AS `Enrolledstorecode`,
  `a`.`MembershipCardNo`  AS `Membershipcardno`,
  `a`.`TierStartDate`     AS `TierStartDate`,
  `a`.`TierEndDate`       AS `Tierenddate`,
  `a`.`CurrentTier`       AS `Currenttier`,
  (15000 - IFNULL(`a`.`CurrentTierSpends`,0)) AS `Distance`,
  (CASE WHEN (`a`.`CurrentTierSpends` >= '15000') THEN 'Free Renewal' 
	WHEN ((`a`.`CurrentTierSpends` <= '14999') AND (`a`.`CurrentTierSpends` >= '14501')) THEN '< INR 500' 
	WHEN ((`a`.`CurrentTierSpends` <= '14500') AND (`a`.`CurrentTierSpends` >= '12000')) THEN 'INR 500 to 3000' 
	WHEN (IFNULL(`a`.`CurrentTierSpends`,0) <= '12000') THEN '> INR 3000' END) AS `Amount left to reach INR 15000`,
  IFNULL(`a`.`CurrentTierSpends`,0) AS `Currenttierspends`,
  `b`.`ClientID`          AS `Clientid`
FROM (`thebodyshop`.`tier_detail_report` `a`
   JOIN `thebodyshop`.`member_report` `b`
     ON ((`a`.`ClientId` = `b`.`ClientID`)))
WHERE ((`a`.`TierEndDate` = LAST_DAY(NOW()))
       AND (`a`.`CurrentTier` = 'Platinum')
       AND (`b`.`Tier` = 'Platinum')
       AND (`b`.`Mobile` IS NOT NULL)
       AND (`b`.`Mobile` <> '')); -- 4324
              
ALTER TABLE dummy.SanketK_Bodyshop_01mar25_Renewal_Platinum ADD INDEX mobile(mobile);
ALTER TABLE dummy.SanketK_Bodyshop_01mar25_Renewal_Platinum ADD COLUMN LastTxnDate VARCHAR(20);

UPDATE dummy.SanketK_Bodyshop_01mar25_Renewal_Platinum a JOIN(
SELECT mobile,MAX(txndate)LastTxnDate
FROM thebodyshop.`txn_report_accrual_redemption`
GROUP BY 1)b USING(mobile)
SET a.LastTxnDate=b.LastTxnDate; -- 4320