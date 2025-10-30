INSERT INTO   dummy.FE_segment_jun_25_1
SELECT membershipcardnumber,MAX(frequencycount)FCOverall,
DATEDIFF('2025-06-30',MAX(txndate))Recency
FROM `forestessentials`.txn_report_accrual_redemption
WHERE txndate <='2025-06-30' 
GROUP BY 1;

INSERT INTO  dummy.FE_segment_jun_24_1
SELECT membershipcardnumber,MAX(frequencycount)FCOverall,
DATEDIFF('2024-06-30',MAX(txndate))Recency
FROM `forestessentials`.txn_report_accrual_redemption
WHERE txndate <='2024-06-30' 
GROUP BY 1;#

ALTER TABLE dummy.FE_segment_jun_24_1 ADD COLUMN 2024_lifecycle VARCHAR(20);

UPDATE dummy.FE_segment_jun_24_1 SET 2024_lifecycle=
CASE WHEN recency BETWEEN 0 AND 90 THEN "active"
WHEN recency BETWEEN 91 AND 180 THEN "dormant"
WHEN recency BETWEEN 181 AND 365 THEN "Recently Lapsed"
WHEN recency > 365 THEN "Long Lapsed"
END; #332866

ALTER TABLE dummy.FE_segment_jun_25_1 ADD COLUMN 2025_lifecycle VARCHAR(20);

UPDATE dummy.FE_segment_jun_25_1 SET 2025_lifecycle=
CASE WHEN recency BETWEEN 0 AND 90 THEN "Active"
WHEN recency BETWEEN 91 AND 180 THEN "Dormant"
WHEN recency BETWEEN 181 AND 365 THEN "Recently Lapsed"
WHEN recency > 365 THEN "Long Lapsed"
END;#410797

SELECT 2024_lifecycle, COUNT(membershipcardnumber) AS customers FROM dummy.FE_segment_jun_24_1 GROUP BY 1;
SELECT 2025_lifecycle, COUNT(membershipcardnumber) AS customers FROM dummy.FE_segment_jun_25_1 GROUP BY 1;



#######################################lifecycle_25_base###########################
SET @enddate=LAST_DAY(DATE_SUB(CURDATE(),INTERVAL 1 MONTH));
SELECT @enddate;

WITH lifecycle_base AS (
SELECT mobile,MAX(frequencycount)FCOverall,
DATEDIFF(@enddate,MAX(txndate))Recency
FROM txn_report_accrual_redemption
WHERE txndate <=@enddate 
GROUP BY 1)

SELECT CASE WHEN recency BETWEEN 0 AND 90 THEN "Active"
WHEN recency BETWEEN 91 AND 180 THEN "Dormant"
WHEN recency BETWEEN 181 AND 365 THEN "Recently Lapsed"
WHEN recency > 365 THEN "Long Lapsed"
END life_cycle_25,COUNT(DISTINCT mobile)customer FROM lifecycle_base
GROUP BY 1;



#######################################lifecycle_24_base###########################
SET @enddate=LAST_DAY(DATE_SUB(CURDATE(),INTERVAL 13 MONTH));
SELECT @enddate;

WITH lifecycle_24_base AS (
SELECT mobile,MAX(frequencycount)FCOverall,
DATEDIFF(@enddate,MAX(txndate))Recency
FROM txn_report_accrual_redemption
WHERE txndate <=@enddate 
GROUP BY 1)


SELECT CASE WHEN recency BETWEEN 0 AND 90 THEN "Active"
WHEN recency BETWEEN 91 AND 180 THEN "Dormant"
WHEN recency BETWEEN 181 AND 365 THEN "Recently Lapsed"
WHEN recency > 365 THEN "Long Lapsed"
END life_cycle_24,COUNT(DISTINCT mobile)customer FROM lifecycle_24_base
GROUP BY 1;


