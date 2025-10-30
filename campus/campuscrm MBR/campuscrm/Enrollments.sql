-- by using store master

-- Enrollments

-- previous year mbr month
SELECT 
  CONCAT(MONTHNAME(modifiedenrolledon), YEAR(modifiedenrolledon)) AS PERIOD,
  COUNT(DISTINCT CASE WHEN enrolledstorecode IN ('ECOM') THEN mobile END) AS 'ECOM',
  COUNT(DISTINCT CASE WHEN enrolledstorecode NOT IN ('ECOM') THEN mobile END) AS 'OFFLINE',
  COUNT(DISTINCT mobile) AS Over_All,
  COUNT(DISTINCT CASE WHEN storetype1 IN ('coco') AND enrolledstorecode NOT IN ('ECOM') THEN mobile END) AS coco_customer,
  COUNT(DISTINCT CASE WHEN storetype1 IN ('fofo') AND enrolledstorecode NOT IN ('ECOM') THEN mobile END) AS fofo_customer,
  COUNT(DISTINCT CASE WHEN storetype1 IS NULL THEN mobile END) AS null_customer
FROM (
  SELECT DISTINCT mobile, enrolledstorecode, storetype1, modifiedenrolledon
  FROM `campuscrm`.member_report a
  LEFT JOIN store_master b ON a.enrolledstorecode = b.storecode
  WHERE enrolledstorecode NOT LIKE '%demo%' AND enrolledstorecode NOT LIKE '%corporate%'
    AND modifiedenrolledon BETWEEN '2024-09-01' AND '2024-09-30'
) AS base_data_1
UNION ALL
-- previous month
SELECT 
  CONCAT(MONTHNAME(modifiedenrolledon), YEAR(modifiedenrolledon)) AS PERIOD,
  COUNT(DISTINCT CASE WHEN enrolledstorecode IN ('ECOM') THEN mobile END) AS 'ECOM',
  COUNT(DISTINCT CASE WHEN enrolledstorecode NOT IN ('ECOM') THEN mobile END) AS 'OFFLINE',
  COUNT(DISTINCT mobile) AS Over_All,
  COUNT(DISTINCT CASE WHEN storetype1 IN ('coco') AND enrolledstorecode NOT IN ('ECOM') THEN mobile END) AS coco_customer,
  COUNT(DISTINCT CASE WHEN storetype1 IN ('fofo') AND enrolledstorecode NOT IN ('ECOM') THEN mobile END) AS fofo_customer,
  COUNT(DISTINCT CASE WHEN storetype1 IS NULL THEN mobile END) AS null_customer
FROM (
  SELECT DISTINCT mobile, enrolledstorecode, storetype1, modifiedenrolledon
  FROM `campuscrm`.member_report a
  LEFT JOIN store_master b ON a.enrolledstorecode = b.storecode
  WHERE enrolledstorecode NOT LIKE '%demo%' AND enrolledstorecode NOT LIKE '%corporate%'
    AND modifiedenrolledon BETWEEN '2025-08-01' AND '2025-08-31'
) AS base_data_2

UNION ALL
-- current month mbr
SELECT 
  CONCAT(MONTHNAME(modifiedenrolledon), YEAR(modifiedenrolledon)) AS PERIOD,
  COUNT(DISTINCT CASE WHEN enrolledstorecode IN ('ECOM') THEN mobile END) AS 'ECOM',
  COUNT(DISTINCT CASE WHEN enrolledstorecode NOT IN ('ECOM') THEN mobile END) AS 'OFFLINE',
  COUNT(DISTINCT mobile) AS Over_All,
  COUNT(DISTINCT CASE WHEN storetype1 IN ('coco') AND enrolledstorecode NOT IN ('ECOM') THEN mobile END) AS coco_customer,
  COUNT(DISTINCT CASE WHEN storetype1 IN ('fofo') AND enrolledstorecode NOT IN ('ECOM') THEN mobile END) AS fofo_customer,
  COUNT(DISTINCT CASE WHEN storetype1 IS NULL THEN mobile END) AS null_customer
FROM (
  SELECT DISTINCT mobile, enrolledstorecode, storetype1, modifiedenrolledon
  FROM `campuscrm`.member_report a
  LEFT JOIN store_master b ON a.enrolledstorecode = b.storecode
  WHERE enrolledstorecode NOT LIKE '%demo%' AND enrolledstorecode NOT LIKE '%corporate%'
    AND modifiedenrolledon BETWEEN '2025-09-01' AND '2025-09-30'
    AND a.insertiondate <CURDATE()
) AS base_data_3;

############################################








-- -- Enrollments
-- 
-- -- previous year mbr month
-- SELECT 
--   CONCAT(MONTHNAME(modifiedenrolledon), YEAR(modifiedenrolledon)) AS PERIOD,
--   COUNT(DISTINCT CASE WHEN enrolledstorecode IN ('ECOM') THEN mobile END) AS 'ECOM',
--   COUNT(DISTINCT CASE WHEN enrolledstorecode NOT IN ('ECOM') THEN mobile END) AS 'OFFLINE',
--   COUNT(DISTINCT mobile) AS Over_All,
--   COUNT(DISTINCT CASE WHEN store_type IN ('coco') AND enrolledstorecode NOT IN ('ECOM') THEN mobile END) AS coco_customer,
--   COUNT(DISTINCT CASE WHEN store_type IN ('fofo') AND enrolledstorecode NOT IN ('ECOM') THEN mobile END) AS fofo_customer,
--   COUNT(DISTINCT CASE WHEN store_type ='Not Identified' THEN mobile END) AS null_customer
-- FROM (
--   SELECT DISTINCT mobile, enrolledstorecode, store_type, modifiedenrolledon
--   FROM `campuscrm`.member_report a
--   LEFT JOIN dummy.campuscrm_store_master_2025_jun_24 b ON a.enrolledstorecode = b.storecode
--   WHERE enrolledstorecode NOT LIKE '%demo%' AND enrolledstorecode NOT LIKE '%corporate%'
--     AND modifiedenrolledon BETWEEN '2024-08-01' AND '2024-08-31'
-- ) AS base_data_1
-- UNION ALL
-- -- previous month
-- SELECT 
--   CONCAT(MONTHNAME(modifiedenrolledon), YEAR(modifiedenrolledon)) AS PERIOD,
--   COUNT(DISTINCT CASE WHEN enrolledstorecode IN ('ECOM') THEN mobile END) AS 'ECOM',
--   COUNT(DISTINCT CASE WHEN enrolledstorecode NOT IN ('ECOM') THEN mobile END) AS 'OFFLINE',
--   COUNT(DISTINCT mobile) AS Over_All,
--   COUNT(DISTINCT CASE WHEN store_type IN ('coco') AND enrolledstorecode NOT IN ('ECOM') THEN mobile END) AS coco_customer,
--   COUNT(DISTINCT CASE WHEN store_type IN ('fofo') AND enrolledstorecode NOT IN ('ECOM') THEN mobile END) AS fofo_customer,
--   COUNT(DISTINCT CASE WHEN store_type ='Not Identified' THEN mobile END) AS null_customer
-- FROM (
--   SELECT DISTINCT mobile, enrolledstorecode, store_type, modifiedenrolledon
--   FROM `campuscrm`.member_report a
--   LEFT JOIN dummy.campuscrm_store_master_2025_jun_24 b ON a.enrolledstorecode = b.storecode
--   WHERE enrolledstorecode NOT LIKE '%demo%' AND enrolledstorecode NOT LIKE '%corporate%'
--     AND modifiedenrolledon BETWEEN '2025-07-01' AND '2025-07-31'
-- ) AS base_data_2
-- 
-- UNION ALL
-- -- current month mbr
-- SELECT 
--   CONCAT(MONTHNAME(modifiedenrolledon), YEAR(modifiedenrolledon)) AS PERIOD,
--   COUNT(DISTINCT CASE WHEN enrolledstorecode IN ('ECOM') THEN mobile END) AS 'ECOM',
--   COUNT(DISTINCT CASE WHEN enrolledstorecode NOT IN ('ECOM') THEN mobile END) AS 'OFFLINE',
--   COUNT(DISTINCT mobile) AS Over_All,
--   COUNT(DISTINCT CASE WHEN store_type IN ('coco') AND enrolledstorecode NOT IN ('ECOM') THEN mobile END) AS coco_customer,
--   COUNT(DISTINCT CASE WHEN store_type IN ('fofo') AND enrolledstorecode NOT IN ('ECOM') THEN mobile END) AS fofo_customer,
--   COUNT(DISTINCT CASE WHEN store_type ='Not Identified' THEN mobile END) AS null_customer
-- FROM (
--   SELECT DISTINCT mobile, enrolledstorecode, store_type, modifiedenrolledon
--   FROM `campuscrm`.member_report a
--   LEFT JOIN dummy.campuscrm_store_master_2025_jun_24 b ON a.enrolledstorecode = b.storecode
--   WHERE enrolledstorecode NOT LIKE '%demo%' AND enrolledstorecode NOT LIKE '%corporate%'
--     AND modifiedenrolledon BETWEEN '2025-08-01' AND '2025-08-31'
--     and a.insertiondate<='2025-09-05'
-- ) AS base_data_3;






