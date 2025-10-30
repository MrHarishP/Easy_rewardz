SELECT * FROM txn_report_accrual_redemption;
SELECT * FROM program_single_view;


SELECT 
`last shopped store` AS storecode,
CASE 
	WHEN recency >=0 AND recency<=90 THEN '0-90'
	WHEN recency >90 AND recency<=180 THEN '91-180'
	WHEN recency >180 AND recency<=365 THEN '181-365' 
	WHEN recency>365 THEN '>365'
	END recency_bucket,
CASE 
	WHEN `total visits`=1 THEN 'one_timer'
	WHEN `total visits`>1 THEN 'repeater' 
	END STATUS,
CASE 
	WHEN availablepoints =0 THEN '0'
	WHEN availablepoints>0 AND availablepoints<=25 THEN '1-25'
	WHEN availablepoints>25 AND availablepoints<=50 THEN '26-50'
	WHEN availablepoints>50 AND availablepoints<=75 THEN '51-75'
	WHEN availablepoints>75 AND availablepoints<=100 THEN '76-100'
	WHEN availablepoints>100 THEN '>100'
	END Available_Points,
COUNT(DISTINCT mobile)customer,
SUM(`Total Spends`)sales,
SUM(`Total Transactions`)bills 
FROM program_single_view
WHERE `last shopped store` IN('RO355','Ro347','RO328','RO356','RO354',
'RO336','RO313','RO337','RO341','RO353','RO339','RO321','RO358')
AND `last shopped store` NOT IN ('demo','corporate')
GROUP BY 1,2,3,4;


SELECT 
-- `last shopped store` AS storecode,
CASE 
	WHEN recency >=0 AND recency<=90 THEN '0-90'
	WHEN recency >90 AND recency<=180 THEN '91-180'
	WHEN recency >180 AND recency<=365 THEN '181-365' 
	WHEN recency>365 THEN '>365'
	END recency_bucket,
CASE 
	WHEN `total visits`=1 THEN 'one_timer'
	WHEN `total visits`>1 THEN 'repeater' 
	END STATUS,
CASE 
	WHEN availablepoints =0 THEN '0'
	WHEN availablepoints>0 AND availablepoints<=25 THEN '1-25'
	WHEN availablepoints>25 AND availablepoints<=50 THEN '26-50'
	WHEN availablepoints>50 AND availablepoints<=75 THEN '51-75'
	WHEN availablepoints>75 AND availablepoints<=100 THEN '76-100'
	WHEN availablepoints>100 THEN '>100'
	END Available_Points,
COUNT(DISTINCT mobile)customer,
SUM(`Total Spends`)sales,
SUM(`Total Transactions`)bills 
FROM program_single_view
WHERE `last shopped store` IN('RO355','Ro347','RO328','RO356','RO354',
'RO336','RO313','RO337','RO341','RO353','RO339','RO321','RO358')
AND `last shopped store` NOT IN ('demo','corporate')
GROUP BY 1,2,3;



-- QC
SELECT 
COUNT(DISTINCT mobile)customer,
SUM(`Total Spends`)sales,
SUM(`Total Transactions`)bills 
FROM program_single_view
WHERE `last shopped store` IN('RO355','Ro347','RO328','RO356','RO354',
'RO336','RO313','RO337','RO341','RO353','RO339','RO321','RO358')
AND `last shopped store` NOT IN ('demo','corporate') AND recency >90 AND recency<=180 AND `total visits`>1 AND availablepoints =0

######################################################################################################################

SELECT 
`last shopped store` AS storecode,
CASE 
	WHEN recency >=0 AND recency<=30 THEN '0-30'
	WHEN recency >30 AND recency<=45 THEN '31-45'
	WHEN recency >45 AND recency<=60 THEN '45-60'
	WHEN recency >60 AND recency<=90 THEN '61-90'
	WHEN recency >90 AND recency<=180 THEN '91-180'
	WHEN recency >180 AND recency<=365 THEN '181-365' 
	WHEN recency>365 THEN '>365'
	END recency_bucket,
CASE 
	WHEN availablepoints =0 THEN '0'
	WHEN availablepoints>0 AND availablepoints<=25 THEN '1-25'
	WHEN availablepoints>25 AND availablepoints<=50 THEN '26-50'
	WHEN availablepoints>50 AND availablepoints<=75 THEN '51-75'
	WHEN availablepoints>75 AND availablepoints<=100 THEN '76-100'
	WHEN availablepoints>100 THEN '>100'
	END Available_Points,
COUNT(DISTINCT mobile)customer,
SUM(`Total Spends`)sales,
SUM(`Total Transactions`)bills 
FROM program_single_view
WHERE `last shopped store` IN('RO355','Ro347','RO328','RO356','RO354',
'RO336','RO313','RO337','RO341','RO353','RO339','RO321','RO358')
AND `last shopped store` NOT IN ('demo','corporate') 
AND `total visits`>1
GROUP BY 1,2,3;


-- ___________________end___________________________



SELECT 
`last shopped store` AS storecode,
CASE 
	WHEN recency >=0 AND recency<=30 THEN '0-30'
	WHEN recency >30 AND recency<=45 THEN '31-45'
	WHEN recency >45 AND recency<=60 THEN '45-60'
	WHEN recency >60 AND recency<=90 THEN '61-90'
	WHEN recency >90 AND recency<=180 THEN '91-180'
	WHEN recency >180 AND recency<=365 THEN '181-365' 
	WHEN recency>365 THEN '>365'
	END recency_bucket,
CASE 
	WHEN availablepoints <=25 THEN '<25'
	WHEN availablepoints>25 AND availablepoints<=50 THEN '25-50'
	WHEN availablepoints>50 AND availablepoints<=100 THEN '50-100'
	WHEN availablepoints>100 AND availablepoints<=200 THEN '100-200'
	WHEN availablepoints>200 AND availablepoints<=500 THEN '200-500'
	WHEN availablepoints>500 AND availablepoints>1000 THEN '500-1000'
	WHEN availablepoints>1000 THEN '>1000'
	END Available_Points,
COUNT(DISTINCT mobile)customer,
SUM(`Total Spends`)sales,
SUM(`Total Transactions`)bills 
FROM program_single_view
WHERE 
-- `last shopped store` IN('RO355','Ro347','RO328','RO356','RO354',
-- 'RO336','RO313','RO337','RO341','RO353','RO339','RO321','RO358')
`last shopped store` NOT IN ('demo','corporate') 
AND `total visits`>1
GROUP BY 1,2,3;



SELECT 
CASE 
	WHEN recency >=0 AND recency<=30 THEN '0-30'
	WHEN recency >30 AND recency<=45 THEN '31-45'
	WHEN recency >45 AND recency<=60 THEN '45-60'
	WHEN recency >60 AND recency<=90 THEN '61-90'
	WHEN recency >90 AND recency<=180 THEN '91-180'
	WHEN recency >180 AND recency<=365 THEN '181-365' 
	WHEN recency>365 THEN '>365'
	END recency_bucket,
CASE 
	WHEN availablepoints <=25 THEN '<25'
	WHEN availablepoints>25 AND availablepoints<=50 THEN '25-50'
	WHEN availablepoints>50 AND availablepoints<=100 THEN '50-100'
	WHEN availablepoints>100 AND availablepoints<=200 THEN '100-200'
	WHEN availablepoints>200 AND availablepoints<=500 THEN '200-500'
	WHEN availablepoints>500 AND availablepoints>1000 THEN '500-1000'
	WHEN availablepoints>1000 THEN '>1000'
	END Available_Points,
COUNT(DISTINCT mobile)customer,
SUM(`Total Spends`)sales,
SUM(`Total Transactions`)bills 
FROM program_single_view
WHERE 
-- `last shopped store` IN('RO355','Ro347','RO328','RO356','RO354',
-- 'RO336','RO313','RO337','RO341','RO353','RO339','RO321','RO358')
`last shopped store` NOT IN ('demo','corporate') 
AND `total visits`>1
GROUP BY 1,2;