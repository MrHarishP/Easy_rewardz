-- sales tag
WITH cte AS(SELECT mobile,
COUNT(DISTINCT uniquebillno)Bills,
SUM(amount)Sales
FROM dummy.dnyanesh_BB_loyalty_dump_apr22_mar25 
WHERE YearTag='FY25(Apr24_Mar25)'
-- WHERE modifiedstorecode IN(SELECT modifiedstorecode FROM dummy.Nidhi_BB_Like_to_like_store_23_24_25)
GROUP BY 1)
SELECT CASE WHEN sales<10000 THEN '<10000'
WHEN sales>=10000 AND sales<12000 THEN '10000-11999'
WHEN sales>=12000 AND sales<14000 THEN '12000-13999'
WHEN sales>=14000 AND sales<16000 THEN '14000-15999'
WHEN sales>=16000 AND sales<18000 THEN '16000-17999'
WHEN sales>=18000 AND sales<20000 THEN '18000-19999'
WHEN sales>=20000 THEN '>=20000' END AS 'Sales Tag',
COUNT(DISTINCT mobile)Customers,
SUM(Bills)Bills,
SUM(Sales)Sales
FROM cte
-- WHERE sales>=20000
GROUP BY 1
ORDER BY sales;

-- onetimer and repeater
WITH cte AS(SELECT mobile,
COUNT(DISTINCT uniquebillno)Bills,
SUM(amount)Sales,MAX(frequencycount)maxfc
FROM dummy.dnyanesh_BB_loyalty_dump_apr22_mar25 
WHERE YearTag='FY25(Apr24_Mar25)'
-- WHERE modifiedstorecode IN(SELECT modifiedstorecode FROM dummy.Nidhi_BB_Like_to_like_store_23_24_25)
GROUP BY 1)
SELECT CASE WHEN maxfc=1 THEN 'onetimer'
WHEN maxfc>1 THEN 'repeater'
END AS 'customer type',
COUNT(DISTINCT mobile)Customers,
SUM(Bills)Bills,
SUM(Sales)Sales
FROM cte
WHERE sales>=20000
GROUP BY 1
ORDER BY sales;
 
 
 
--  tiermonth wise data 
WITH cte AS(SELECT mobile,
COUNT(DISTINCT uniquebillno)Bills,
SUM(amount)Sales
FROM dummy.dnyanesh_BB_loyalty_dump_apr22_mar25 
WHERE YearTag='FY25(Apr24_Mar25)'
GROUP BY 1)
SELECT MONTH(TierEndDate)TierEndMonth,YEAR(TierEndDate)tierendyear,COUNT(DISTINCT mobile)Customers
FROM cte a JOIN tier_report_log b USING(mobile)
WHERE sales>=20000
GROUP BY 1,2;