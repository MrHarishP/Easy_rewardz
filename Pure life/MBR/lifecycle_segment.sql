
#######################################lifecycle_25_base###########################
SET @enddate=LAST_DAY(DATE_SUB(CURDATE(),INTERVAL 1 MONTH));
SELECT @enddate;

WITH lifecycle_base AS (
SELECT mobile,MAX(frequencycount)FCOverall,
DATEDIFF(@enddate,MAX(txndate))Recency
FROM `purelife`.txn_report_accrual_redemption
WHERE txndate <=@enddate 
GROUP BY 1)

SELECT CASE WHEN recency<=210 THEN "Active"
WHEN recency BETWEEN 211 AND 365 THEN "Dormant"
WHEN recency> 365 THEN "Lapsed"
END life_cycle_25,COUNT(DISTINCT mobile)customer FROM lifecycle_base
GROUP BY 1;




#######################################lifecycle_24_base###########################
SET @enddate=LAST_DAY(DATE_SUB(CURDATE(),INTERVAL 13 MONTH));
SELECT @enddate;

WITH lifecycle_24_base AS (
SELECT mobile,MAX(frequencycount)FCOverall,
DATEDIFF(@enddate,MAX(txndate))Recency
FROM `purelife`.txn_report_accrual_redemption
WHERE txndate <=@enddate 
GROUP BY 1)


SELECT CASE WHEN recency<=210 THEN "Active"
WHEN recency BETWEEN 211 AND 365 THEN "Dormant"
WHEN recency> 365 THEN "Lapsed"
END life_cycle_24,COUNT(DISTINCT mobile)customer FROM lifecycle_24_base
GROUP BY 1;
