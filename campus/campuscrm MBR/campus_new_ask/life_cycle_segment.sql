INSERT INTO  dummy.campuscrm_segment_jun24
SELECT
MOBILE,
MAX(frequencycount)FCOverall,
DATEDIFF('2024-06-30',MAX(txndate))Recency
FROM `campuscrm`.txn_report_accrual_redemption
WHERE txndate <='2024-06-30'
GROUP BY 1;#1542105


ALTER TABLE dummy.campuscrm_segment_jun24 ADD COLUMN 2024_lifecycle VARCHAR(20);


UPDATE dummy.campuscrm_segment_jun24 
SET 2024_lifecycle=
CASE 
 WHEN recency <= 365 THEN 'active'
 WHEN recency BETWEEN 366 AND 730 THEN 'dormant'
WHEN recency > 730 THEN 'lapsed'
END;



SELECT 2024_lifecycle, COUNT(MOBILE) AS customers FROM dummy.campuscrm_segment_jun24 GROUP BY 1;




-- ____2025____

SELECT * FROM dummy.campuscrm_segment_jun25;

INSERT INTO dummy.campuscrm_segment_jun25
SELECT
MOBILE,
MAX(frequencycount)FCOverall,
DATEDIFF('2025-06-30',MAX(txndate))Recency
FROM `campuscrm`.txn_report_accrual_redemption
WHERE txndate <='2025-06-30' 
GROUP BY 1;#2274806


ALTER TABLE dummy.campuscrm_segment_jun25 ADD COLUMN 2025_lifecycle VARCHAR(20);


UPDATE dummy.campuscrm_segment_jun25 
SET 2025_lifecycle=
CASE 
 WHEN recency <= 365 THEN 'active'
 WHEN recency BETWEEN 366 AND 730 THEN 'dormant'
WHEN recency > 730 THEN 'lapsed'
END;#2274806



SELECT 2025_lifecycle, COUNT(MOBILE) AS customers FROM dummy.campuscrm_segment_jun25 GROUP BY 1;


SELECT 2024_lifecycle, COUNT(MOBILE) AS customers FROM dummy.campuscrm_segment_jun24 GROUP BY 1;