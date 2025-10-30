WITH base_table AS (
SELECT EnrolledStore, mobile,1_year_sales,1_year_bills FROM program_single_view
WHERE EnrolledOn BETWEEN DATE_SUB('2025-10-13', INTERVAL 1 YEAR) AND '2025-10-13')

SELECT EnrolledStore,COUNT(DISTINCT mobile)customer,SUM(1_year_sales)1_year_sales,SUM(1_year_bills)1_year_bills FROM base_table
GROUP BY 1;



WITH base_table AS (
SELECT EnrolledStore, mobile,1_year_sales,1_year_bills,`Total spends` ,`Total transactions` FROM program_single_view
WHERE EnrolledOn <= '2025-10-13')

SELECT EnrolledStore,COUNT(DISTINCT mobile)customer,SUM(1_year_sales)1_year_sales,SUM(1_year_bills)1_year_bills,
SUM(`Total spends`)Total_sales,SUM(`Total transactions`)Total_bills
FROM base_table
GROUP BY 1;


WITH base_table AS (
SELECT `last shopped store`, mobile,1_year_sales,1_year_bills FROM program_single_view
WHERE `last shopped date` BETWEEN DATE_SUB('2025-10-13', INTERVAL 1 YEAR) AND '2025-10-13')

SELECT `last shopped store`,COUNT(DISTINCT mobile)customer,SUM(1_year_sales)1_year_sales,SUM(1_year_bills)1_year_bills FROM base_table
GROUP BY 1;



WITH base_table AS (
SELECT `last shopped store`, mobile,1_year_sales,1_year_bills,`Total spends` ,`Total transactions` FROM program_single_view
WHERE `last shopped date` <= '2025-10-13'
AND `last shopped store` IN ('BAN001',
'BAN010',
'BAN011',
'BAN018',
'BAN019',
'BAN024',
'BAN025',
'BAN027',
'BAN029',
'BAN030',
'BAN038',
'BAN042',
'BAN043',
'BAN044',
'BAN045',
'BAN072',
'BAN073',
'BAN076',
'BAN078',
'BAN092',
'BAN101',
'BAN110',
'BAN111',
'BAN112',
'BAN116',
'BAN117',
'BAN118'
)),

base_table_2 AS (
SELECT `last shopped store`,
CASE
WHEN recency>0 AND recency<=90 THEN '0-90'
WHEN recency>90 AND recency<=180 THEN '90-180' 
WHEN recency>240 AND recency<=270 THEN '180-270'
WHEN recency>270 AND recency<=360 THEN '270-360'
WHEN recency>360 THEN '>360' END recency,
CASE WHEN `Total Visits` = 1 THEN 'ONETIMER' ELSE 'REPEAER' END AS customer_type,
mobile,
SUM(1_year_sales) AS 1_year_sales,
SUM(1_year_bills) AS 1_year_bills,
SUM(`Total spends`)Total_sales,SUM(`Total transactions`)Total_bills
GROUP BY 1,2,3,4
)

SELECT `last shopped store`, recency,customer_type,COUNT(DISTINCT mobile)customer,SUM(1_year_sales)1_year_sales,SUM(1_year_bills)1_year_bills,
SUM(`Total spends`)Total_sales,SUM(`Total transactions`)Total_bills
FROM base_table a JOIN 
GROUP BY 1,2,3;

SELECT * FROM program_single_view;

SELECT MIN(`last shopped date`),MAX(`last shopped date`) FROM program_single_view;


#####################################
-- ________________________use this query for segemnet data which is for specific storecode_____________________ 
WITH TABLE1 AS
(SELECT
Mobile,
`last shopped store`,
Recency,
`Total Visits`,
1_year_sales,
1_year_bills,
`Total spends` ,`Total transactions`
FROM program_single_view
WHERE `last shopped store` IN ('BAN001','BAN010','BAN011','BAN018',
'BAN019','BAN024','BAN025','BAN027',
'BAN029','BAN030','BAN038','BAN042',
'BAN043','BAN044','BAN045','BAN072',
'BAN073','BAN076','BAN078','BAN092',
'BAN101','BAN110','BAN111','BAN112',
'BAN116','BAN117','BAN118')
)

SELECT `last shopped store`,
CASE
WHEN recency>0 AND recency<=90 THEN '0-90'
WHEN recency>90 AND recency<=180 THEN '90-180' 
WHEN recency>240 AND recency<=270 THEN '180-270'
WHEN recency>270 AND recency<=360 THEN '270-360'
WHEN recency>360 THEN '>360' END recency,
CASE WHEN `Total Visits` = 1 THEN 'ONETIMER' ELSE 'REPEAER' END AS customer_type,
COUNT(DISTINCT mobile) AS cusotmer_count, 
SUM(1_year_sales) AS 1_year_sales,
SUM(1_year_bills) AS 1_year_bills,
SUM(`Total spends`)Total_sales,SUM(`Total transactions`)Total_bills
FROM TABLE1
GROUP BY 1,2,3;



#####################################
-- ________________________use this query for segemnet data which is for specific storecode_____________________ 
WITH TABLE1 AS
(SELECT
Mobile,
`last shopped store`,
Recency,
`Total Visits`,
1_year_sales,
1_year_bills
FROM program_single_view
WHERE `last shopped store` IN (
'BAN001','BAN003','BAN010','BAN011','BAN013','BAN018','BAN019','BAN024','BAN025',
'BAN026','BAN027','BAN029','BAN030','BAN038','BAN042','BAN043','BAN044','BAN045',
'BAN052','BAN072','BAN073','BAN074','BAN076','BAN077','BAN079','BAN081','BAN082',
'BAN089','BAN090','BAN091','BAN092','BAN094','BAN095','BAN096','BAN097','BAN100',
'BAN101','BAN102','BAN103','BAN104','BAN105','BAN106','BAN107','BAN108','BAN109',
'BAN110','BAN111','BAN112','BAN115','BAN116','BAN117','BAN118','BAN033','BAN034',
'BAN056','BAN078'
))

SELECT `last shopped store`,
CASE
WHEN recency>0 AND recency<=90 THEN '0-90'
WHEN recency>90 AND recency<=180 THEN '90-180' 
WHEN recency>240 AND recency<=270 THEN '180-270'
WHEN recency>270 AND recency<=360 THEN '270-360'
WHEN recency>360 THEN '>360' END recency,
CASE WHEN `Total Visits` = 1 THEN 'ONETIMER' ELSE 'REPEAER' END AS customer_type,
COUNT(DISTINCT mobile) AS cusotmer_count, 
SUM(1_year_sales) AS 1_year_sales,
SUM(1_year_bills) AS 1_year_bills
FROM TABLE1
GROUP BY 1,2,3;