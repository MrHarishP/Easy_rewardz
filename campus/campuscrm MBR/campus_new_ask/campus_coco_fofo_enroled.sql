WITH base_data AS
(SELECT a.Mobile,a.`last shopped store` ,b.StoreType1
FROM program_single_view a JOIN store_master b
ON a.`last shopped store`=b.StoreCode
WHERE  a.`Total Visits`>0
--  AND `Last Shopped Date` BETWEEN '2025-06-30'-INTERVAL 1 YEAR AND '2025-06-30'
  )
 
SELECT StoreType1,COUNT(DISTINCT mobile) FROM base_data GROUP BY 1 ;

SELECT * FROM   store_master ;
SELECT StoreType1,COUNT(DISTINCT storecode)
 FROM store_master a JOIN  program_single_view b
 ON a.storecode=b.`last shopped store`
 WHERE a.`Status`='Active'
 GROUP BY 1;
 
SELECT * FROM program_single_view ;

WITH bsae_data AS
(SELECT a.mobile,a.EnrolledStore,b.StoreType1
FROM program_single_view a LEFT JOIN store_master b
ON a.EnrolledStore=b.StoreCode
WHERE EnrolledOn BETWEEN '2025-06-30'-INTERVAL 1 YEAR AND '2025-06-30')
SELECT StoreType1,COUNT(DISTINCT mobile) FROM bsae_data GROUP BY 1;


