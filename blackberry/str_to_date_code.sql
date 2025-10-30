SELECT COUNT(*)
FROM responders_data
WHERE STR_TO_DATE(SUBSTRING_INDEX(campaignsubcode, '_', -1), '%Y-%m-%d') 
      BETWEEN '2025-07-01' AND '2025-07-31';


 SELECT DISTINCT storecode 
FROM txn_report_accrual_redemption 
WHERE storecode  REGEXP 'demo|corporate';


SELECT 
  *
FROM `responders_data`
WHERE STR_TO_DATE(SUBSTRING_INDEX(campaignsubcode, '_', -1),'%Y-%m-%d') BETWEEN '2025-07-31' AND '2025-07-31'
;