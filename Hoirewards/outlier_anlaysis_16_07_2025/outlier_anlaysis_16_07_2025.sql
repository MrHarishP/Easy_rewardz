CREATE TABLE dummy.Hoirewardz_FA_2025
SELECT mobile,txndate,SUM(amount)AS spend,frequencycount,
COUNT(DISTINCT CONCAT(txndate,modifiedbillno,storecode)) AS TotalBills
FROM `hoirewards`.`txn_report_accrual_redemption`
WHERE txndate <='2025-07-15'
GROUP BY 1,2;#135000

SELECT COUNT(DISTINCT mobile) FROM dummy.Hoirewardz_FA_2025;#130290


######################################################################################################
-- day 1


SELECT COUNT(DISTINCT mobile)customers FROM dummy.Hoirewardz_FA_2025
WHERE spend>=3500;#878

SELECT COUNT(DISTINCT mobile)customers FROM dummy.Hoirewardz_FA_2025
WHERE spend>=4000;#507

SELECT COUNT(DISTINCT mobile)customers FROM dummy.Hoirewardz_FA_2025
WHERE spend>=4500;#341


SELECT COUNT(DISTINCT mobile)customers FROM dummy.Hoirewardz_FA_2025
WHERE spend>=5000;#243


SELECT COUNT(DISTINCT mobile)customerts FROM dummy.Hoirewardz_FA_2025
WHERE totalbills>=3;#1010


SELECT COUNT(DISTINCT mobile)customerts FROM dummy.Hoirewardz_FA_2025
WHERE totalbills>=4;#241

SELECT COUNT(DISTINCT mobile)customerts FROM dummy.Hoirewardz_FA_2025
WHERE totalbills>=5;#88

SELECT COUNT(DISTINCT mobile)customerts FROM dummy.Hoirewardz_FA_2025
WHERE totalbills>=6;#47



SELECT COUNT(DISTINCT mobile)customer FROM dummy.Hoirewardz_FA_2025
WHERE spend>=3500 OR totalbills>=3;#1736

SELECT COUNT(DISTINCT mobile)customer FROM dummy.Hoirewardz_FA_2025
WHERE spend>=4000 OR totalbills>=4;#1040

SELECT COUNT(DISTINCT mobile)customer FROM dummy.Hoirewardz_FA_2025
WHERE spend>=4500 OR totalbills>=5;#543


SELECT COUNT(DISTINCT mobile)customer FROM dummy.Hoirewardz_FA_2025
WHERE spend>=5000 OR totalbills>=6;#357


#############################################################################################
-- day 7 

SELECT MIN(txndate) FROM txn_report_accrual_redemption

SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2024-12-23')) DIV 7 AS week_num,
'2024-12-23' + INTERVAL (DATEDIFF(txndate,'2024-12-23') DIV 7) WEEK AS week_start,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.Hoirewardz_FA_2025
GROUP BY 1,2
HAVING totalspend>=8000)a;#118



SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2024-12-23')) DIV 7 AS week_num,
'2024-12-23' + INTERVAL (DATEDIFF(txndate,'2024-12-23') DIV 7) WEEK AS week_start,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.Hoirewardz_FA_2025
GROUP BY 1,2
HAVING totalspend>=9000)a;#100



SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2024-12-23')) DIV 7 AS week_num,
'2024-12-23' + INTERVAL (DATEDIFF(txndate,'2024-12-23') DIV 7) WEEK AS week_start,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.Hoirewardz_FA_2025
GROUP BY 1,2
HAVING totalspend>=10000)a;#82


SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2024-12-23')) DIV 7 AS week_num,
'2024-12-23' + INTERVAL (DATEDIFF(txndate,'2024-12-23') DIV 7) WEEK AS week_start,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.Hoirewardz_FA_2025
GROUP BY 1,2
HAVING totalspend>=11000)a;#58


SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2024-12-23')) DIV 7 AS week_num,
'2024-12-23' + INTERVAL (DATEDIFF(txndate,'2024-12-23') DIV 7) WEEK AS week_start,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.Hoirewardz_FA_2025
GROUP BY 1,2
HAVING transactions>=8)a;#32



SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2024-12-23')) DIV 7 AS week_num,
'2024-12-23' + INTERVAL (DATEDIFF(txndate,'2024-12-23') DIV 7) WEEK AS week_start,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.Hoirewardz_FA_2025
GROUP BY 1,2
HAVING transactions>=10)a;#24


SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2024-12-23')) DIV 7 AS week_num,
'2024-12-23' + INTERVAL (DATEDIFF(txndate,'2024-12-23') DIV 7) WEEK AS week_start,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.Hoirewardz_FA_2025
GROUP BY 1,2
HAVING transactions>=12)a;#17

SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2024-12-23')) DIV 7 AS week_num,
'2024-12-23' + INTERVAL (DATEDIFF(txndate,'2024-12-23') DIV 7) WEEK AS week_start,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.Hoirewardz_FA_2025
GROUP BY 1,2
HAVING transactions>=14)a;#12



SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2024-12-23')) DIV 7 AS week_num,
'2024-12-23' + INTERVAL (DATEDIFF(txndate,'2024-12-23') DIV 7) WEEK AS week_start,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.Hoirewardz_FA_2025
GROUP BY 1,2
HAVING totalspend>=8000 OR transactions>=8)a;#315

SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2024-12-23')) DIV 7 AS week_num,
'2024-12-23' + INTERVAL (DATEDIFF(txndate,'2024-12-23') DIV 7) WEEK AS week_start,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.Hoirewardz_FA_2025
GROUP BY 1,2
HAVING totalspend>=9000 OR transactions>=10)a;#175

SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2024-12-23')) DIV 7 AS week_num,
'2024-12-23' + INTERVAL (DATEDIFF(txndate,'2024-12-23') DIV 7) WEEK AS week_start,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.Hoirewardz_FA_2025
GROUP BY 1,2
HAVING totalspend>=10000 OR transactions>=12)a;#103

SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2024-12-23')) DIV 7 AS week_num,
'2024-12-23' + INTERVAL (DATEDIFF(txndate,'2024-12-23') DIV 7) WEEK AS week_start,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.Hoirewardz_FA_2025
GROUP BY 1,2
HAVING totalspend>=11000 OR transactions>=14)a;#84


##############################################################################

-- day 15




SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2024-12-23')) DIV 15 AS 15DaysCount,
'2024-12-23' + INTERVAL (DATEDIFF(txndate,'2024-12-23') DIV 15) WEEK AS 15DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.Hoirewardz_FA_2025
GROUP BY 1,2
HAVING totalspend>=16000)a;#85



SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2024-12-23')) DIV 15 AS 15DaysCount,
'2024-12-23' + INTERVAL (DATEDIFF(txndate,'2024-12-23') DIV 15) WEEK AS 15DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.Hoirewardz_FA_2025
GROUP BY 1,2
HAVING totalspend>=18000)a;#48


SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2024-12-23')) DIV 15 AS 15DaysCount,
'2024-12-23' + INTERVAL (DATEDIFF(txndate,'2024-12-23') DIV 15) WEEK AS 15DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.Hoirewardz_FA_2025
GROUP BY 1,2
HAVING totalspend>=20000)a;#48


SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2024-12-23')) DIV 15 AS 15DaysCount,
'2024-12-23' + INTERVAL (DATEDIFF(txndate,'2024-12-23') DIV 15) WEEK AS 15DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.Hoirewardz_FA_2025
GROUP BY 1,2
HAVING totalspend>=22000)a;#35


SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2024-12-23')) DIV 15 AS 15DaysCount,
'2024-12-23' + INTERVAL (DATEDIFF(txndate,'2024-12-23') DIV 15) WEEK AS 15DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.Hoirewardz_FA_2025
GROUP BY 1,2
HAVING transactions>=16)a;#15


SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2024-12-23')) DIV 15 AS 15DaysCount,
'2024-12-23' + INTERVAL (DATEDIFF(txndate,'2024-12-23') DIV 15) WEEK AS 15DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.Hoirewardz_FA_2025
GROUP BY 1,2
HAVING transactions>=20)a;#10

SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2024-12-23')) DIV 15 AS 15DaysCount,
'2024-12-23' + INTERVAL (DATEDIFF(txndate,'2024-12-23') DIV 15) WEEK AS 15DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.Hoirewardz_FA_2025
GROUP BY 1,2
HAVING transactions>=24)a;#9


SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2024-12-23')) DIV 15 AS 15DaysCount,
'2024-12-23' + INTERVAL (DATEDIFF(txndate,'2024-12-23') DIV 15) WEEK AS 15DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.Hoirewardz_FA_2025
GROUP BY 1,2
HAVING transactions>=28)a;#9


SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2024-12-23')) DIV 15 AS 15DaysCount,
'2024-12-23' + INTERVAL (DATEDIFF(txndate,'2024-12-23') DIV 15) WEEK AS 15DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.Hoirewardz_FA_2025
GROUP BY 1,2
HAVING totalspend>=16000 OR transactions>=16)a;#88


SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2024-12-23')) DIV 15 AS 15DaysCount,
'2024-12-23' + INTERVAL (DATEDIFF(txndate,'2024-12-23') DIV 15) WEEK AS 15DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.Hoirewardz_FA_2025
GROUP BY 1,2
HAVING totalspend>=18000 OR transactions>=20)a;#60


SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2024-12-23')) DIV 15 AS 15DaysCount,
'2024-12-23' + INTERVAL (DATEDIFF(txndate,'2024-12-23') DIV 15) WEEK AS 15DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.Hoirewardz_FA_2025
GROUP BY 1,2
HAVING totalspend>=20000 OR transactions>=24)a;#37



SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2024-12-23')) DIV 15 AS 15DaysCount,
'2024-12-23' + INTERVAL (DATEDIFF(txndate,'2024-12-23') DIV 15) WEEK AS 15DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.Hoirewardz_FA_2025
GROUP BY 1,2
HAVING totalspend>=22000 OR transactions>=28)a;#27



#########################################################################################


-- Day 30 

SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2024-12-23')) DIV 30 AS 30DaysCount,
'2024-12-23' + INTERVAL (DATEDIFF(txndate,'2024-12-23') DIV 30) WEEK AS 30DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.Hoirewardz_FA_2025
GROUP BY 1,2
HAVING totalspend>=35000 )a;#16


SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2024-12-23')) DIV 30 AS 30DaysCount,
'2024-12-23' + INTERVAL (DATEDIFF(txndate,'2024-12-23') DIV 30) WEEK AS 30DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.Hoirewardz_FA_2025
GROUP BY 1,2
HAVING totalspend>=40000 )a;#12


SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2024-12-23')) DIV 30 AS 30DaysCount,
'2024-12-23' + INTERVAL (DATEDIFF(txndate,'2024-12-23') DIV 30) WEEK AS 30DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.Hoirewardz_FA_2025
GROUP BY 1,2
HAVING totalspend>=45000 )a;#10


SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2024-12-23')) DIV 30 AS 30DaysCount,
'2024-12-23' + INTERVAL (DATEDIFF(txndate,'2024-12-23') DIV 30) WEEK AS 30DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.Hoirewardz_FA_2025
GROUP BY 1,2
HAVING totalspend>=50000 )a;#8

SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2024-12-23')) DIV 30 AS 30DaysCount,
'2024-12-23' + INTERVAL (DATEDIFF(txndate,'2024-12-23') DIV 30) WEEK AS 30DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.Hoirewardz_FA_2025
GROUP BY 1,2
HAVING transactions>=32)a;#10


SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2024-12-23')) DIV 30 AS 30DaysCount,
'2024-12-23' + INTERVAL (DATEDIFF(txndate,'2024-12-23') DIV 30) WEEK AS 30DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.Hoirewardz_FA_2025
GROUP BY 1,2
HAVING transactions>=38)a;#8


SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2024-12-23')) DIV 30 AS 30DaysCount,
'2024-12-23' + INTERVAL (DATEDIFF(txndate,'2024-12-23') DIV 30) WEEK AS 30DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.Hoirewardz_FA_2025
GROUP BY 1,2
HAVING transactions>=44)a;#8

SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2024-12-23')) DIV 30 AS 30DaysCount,
'2024-12-23' + INTERVAL (DATEDIFF(txndate,'2024-12-23') DIV 30) WEEK AS 30DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.Hoirewardz_FA_2025
GROUP BY 1,2
HAVING transactions>=50)a;#6


SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2024-12-23')) DIV 30 AS 30DaysCount,
'2024-12-23' + INTERVAL (DATEDIFF(txndate,'2024-12-23') DIV 30) WEEK AS 30DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.Hoirewardz_FA_2025
GROUP BY 1,2
HAVING totalspend>=35000 OR transactions>=32)a;#18


SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2024-12-23')) DIV 30 AS 30DaysCount,
'2024-12-23' + INTERVAL (DATEDIFF(txndate,'2024-12-23') DIV 30) WEEK AS 30DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.Hoirewardz_FA_2025
GROUP BY 1,2
HAVING totalspend>=40000 OR transactions>=38)a;#13


SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2024-12-23')) DIV 30 AS 30DaysCount,
'2024-12-23' + INTERVAL (DATEDIFF(txndate,'2024-12-23') DIV 30) WEEK AS 30DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.Hoirewardz_FA_2025
GROUP BY 1,2
HAVING totalspend>=45000 OR transactions>=44)a;#11


SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2024-12-23')) DIV 30 AS 30DaysCount,
'2024-12-23' + INTERVAL (DATEDIFF(txndate,'2024-12-23') DIV 30) WEEK AS 30DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.Hoirewardz_FA_2025
GROUP BY 1,2
HAVING totalspend>=50000 OR transactions>=50)a;#11




################################################################################

#All Or conditions


SELECT COUNT(DISTINCT mobile) FROM(
SELECT DISTINCT mobile FROM dummy.Hoirewardz_FA_2025
WHERE spend>=3500 OR TotalBills>=3
UNION
SELECT DISTINCT mobile FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2024-12-23')) DIV 7 AS week_num,
'2024-12-23' + INTERVAL (DATEDIFF(txndate,'2024-12-23') DIV 7) WEEK AS week_start,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.Hoirewardz_FA_2025
GROUP BY 1,2
HAVING totalspend>=8000 OR transactions>=8 )a
UNION
SELECT DISTINCT mobile FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2024-12-23')) DIV 15 AS 15DaysCount,
'2024-12-23' + INTERVAL (DATEDIFF(txndate,'2024-12-23') DIV 15) WEEK AS 15DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.Hoirewardz_FA_2025
GROUP BY 1,2
HAVING totalspend>=16000 OR transactions>=16 )b
UNION
SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2024-12-23')) DIV 30 AS 30DaysCount,
'2024-12-23' + INTERVAL (DATEDIFF(txndate,'2024-12-23') DIV 30) WEEK AS 30DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.Hoirewardz_FA_2025
GROUP BY 1,2
HAVING totalspend>=35000 OR transactions>=32 )d
)e;#5127



SELECT COUNT(DISTINCT mobile) FROM(
SELECT DISTINCT mobile FROM dummy.Hoirewardz_FA_2025
WHERE spend>=4000 OR TotalBills>=4
UNION
SELECT DISTINCT mobile FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2024-12-23')) DIV 7 AS week_num,
'2024-12-23' + INTERVAL (DATEDIFF(txndate,'2024-12-23') DIV 7) WEEK AS week_start,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.Hoirewardz_FA_2025
GROUP BY 1,2
HAVING totalspend>=9000 OR transactions>=10 )a
UNION
SELECT DISTINCT mobile FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2024-12-23')) DIV 15 AS 15DaysCount,
'2024-12-23' + INTERVAL (DATEDIFF(txndate,'2024-12-23') DIV 15) WEEK AS 15DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.Hoirewardz_FA_2025
GROUP BY 1,2
HAVING totalspend>=18000 OR transactions>=20)b
UNION
SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2024-12-23')) DIV 30 AS 30DaysCount,
'2024-12-23' + INTERVAL (DATEDIFF(txndate,'2024-12-23') DIV 30) WEEK AS 30DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.Hoirewardz_FA_2025
GROUP BY 1,2
HAVING totalspend>=40000 OR transactions>=38 )d
)e;#1041



SELECT COUNT(DISTINCT mobile) FROM(
SELECT DISTINCT mobile FROM dummy.Hoirewardz_FA_2025
WHERE spend>=4500 OR TotalBills>=5
UNION
SELECT DISTINCT mobile FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2024-12-23')) DIV 7 AS week_num,
'2024-12-23' + INTERVAL (DATEDIFF(txndate,'2024-12-23') DIV 7) WEEK AS week_start,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.Hoirewardz_FA_2025
GROUP BY 1,2
HAVING totalspend>=10000 OR transactions>=12 )a
UNION
SELECT DISTINCT mobile FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2024-12-23')) DIV 15 AS 15DaysCount,
'2024-12-23' + INTERVAL (DATEDIFF(txndate,'2024-12-23') DIV 15) WEEK AS 15DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.Hoirewardz_FA_2025
GROUP BY 1,2
HAVING totalspend>=20000 OR transactions>=24)b
UNION
SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2024-12-23')) DIV 30 AS 30DaysCount,
'2024-12-23' + INTERVAL (DATEDIFF(txndate,'2024-12-23') DIV 30) WEEK AS 30DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.Hoirewardz_FA_2025
GROUP BY 1,2
HAVING totalspend>=45000 OR transactions>=44 )d
)e;#544




SELECT COUNT(DISTINCT mobile) FROM(
SELECT DISTINCT mobile FROM dummy.Hoirewardz_FA_2025
WHERE spend>=5000 OR TotalBills>=6
UNION
SELECT DISTINCT mobile FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2024-12-23')) DIV 7 AS week_num,
'2024-12-23' + INTERVAL (DATEDIFF(txndate,'2024-12-23') DIV 7) WEEK AS week_start,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.Hoirewardz_FA_2025
GROUP BY 1,2
HAVING totalspend>=11000 OR transactions>=14 )a
UNION
SELECT DISTINCT mobile FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2024-12-23')) DIV 15 AS 15DaysCount,
'2024-12-23' + INTERVAL (DATEDIFF(txndate,'2024-12-23') DIV 15) WEEK AS 15DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.Hoirewardz_FA_2025
GROUP BY 1,2
HAVING totalspend>=22000 OR transactions>=28)b
UNION
SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2024-12-23')) DIV 30 AS 30DaysCount,
'2024-12-23' + INTERVAL (DATEDIFF(txndate,'2024-12-23') DIV 30) WEEK AS 30DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.Hoirewardz_FA_2025
GROUP BY 1,2
HAVING totalspend>=50000 OR transactions>=50 )d
)e;#520

SELECT mobile,SUM(pointscollected),SUM(pointsspent) FROM txn_report_accrual_redemption
WHERE txndate<='2025-07-16' AND amount>0
GROUP BY 1;



SELECT 
CASE 
	WHEN visit<=1 THEN '0-1'
	WHEN visit>1 AND visit<=3 THEN '1-3'
	WHEN visit>3 AND visit<=5 THEN '3-5'
	WHEN visit>5 AND visit<=9 THEN '5-9'
	WHEN visit >9 THEN '>9' END visit_tag,
COUNT(DISTINCT mobile)customers FROM (
SELECT mobile,COUNT(DISTINCT txndate,mobile)visit 
FROM `hoirewards`.`txn_report_accrual_redemption`
WHERE txndate <='2025-07-15'
GROUP BY 1)a
GROUP BY 1;


SELECT 
CASE 
	WHEN visit<=9 THEN visit ELSE '>9'
 END visit_tag,
COUNT(DISTINCT mobile)customers FROM (
SELECT mobile,COUNT(DISTINCT txndate,mobile)visit 
FROM `hoirewards`.`txn_report_accrual_redemption`
WHERE txndate <='2025-07-15'
GROUP BY 1)a
GROUP BY 1;


SELECT 
	CASE
	WHEN atv>=0 AND atv<=50 THEN '0-50'
	WHEN atv>50 AND atv<=100 THEN '50-100'
	WHEN atv>100 AND atv<=150 THEN '100-150'
	WHEN atv>150 AND atv<=200 THEN '150-200'
	WHEN atv>200 AND atv<=250 THEN '200-250'
	WHEN atv>250 AND atv<=300 THEN '250-300'
	WHEN atv>300 AND atv<=350 THEN '300-350'
	WHEN atv>350 AND atv<=400 THEN '350-400'
	WHEN atv>400 AND atv<=450 THEN '400-450'
	WHEN atv>450 AND atv<=500 THEN '450-500'
	WHEN atv>500 AND atv<=550 THEN '500-550'
	WHEN atv>550 AND atv<=600 THEN '550-600'
	WHEN atv>600 AND atv<=650 THEN '600-650' 
	WHEN atv>650 THEN '>650' END atv_band,COUNT(DISTINCT mobile)cusotmer 
FROM (
SELECT mobile,SUM(amount)/COUNT(DISTINCT uniquebillno)atv FROM txn_report_accrual_redemption
WHERE txndate<='2025-07-15' AND amount>0
GROUP BY 1)a
GROUP BY 1
ORDER BY atv;




SELECT 
	CASE
	WHEN atv>=0 AND atv<=150 THEN '0-150'
	WHEN atv>150 AND atv<=300 THEN '150-300'
	WHEN atv>300 AND atv<=450 THEN '300-450'
	WHEN atv>450 AND atv<=600 THEN '450-600'
	WHEN atv>600 AND atv<=750 THEN '600-750'
	WHEN atv>750 AND atv<=900 THEN '750-900'
	WHEN atv>900 AND atv<=1050 THEN '900-1050'
	WHEN atv>1050 THEN '>1050' END atv_band,COUNT(DISTINCT mobile)cusotmer 
FROM (
SELECT mobile,SUM(amount)/COUNT(DISTINCT uniquebillno)atv FROM txn_report_accrual_redemption
WHERE txndate<='2025-07-15' AND amount>0
GROUP BY 1)a
GROUP BY 1
ORDER BY atv;


-- will continue

SELECT CASE 
WHEN pointsspend=0 THEN '0' ELSE '9+' END tag,COUNT(DISTINCT mobile) customer FROM (
SELECT mobile,SUM(pointsspent)pointsspend FROM txn_report_accrual_redemption 
WHERE txndate<='2025-07-15' AND amount>0 AND mobile IN (SELECT mobile FROM dummy.Hoirewardz_FA_2025)
GROUP BY 1)a
GROUP BY 1;



SELECT * FROM dummy.Hoirewardz_FA_2025;
