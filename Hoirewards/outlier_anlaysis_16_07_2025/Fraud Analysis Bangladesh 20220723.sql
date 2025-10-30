DROP TABLE dummy.batabangladesh_FA_2022

CREATE TABLE dummy.batabangladesh_FA_2022
SELECT mobile,txndate,SUM(amount)AS spend,frequencycount,
COUNT(DISTINCT CONCAT(txndate,modifiedbillno,storecode)) AS TotalBills
FROM `bataclubbangladesh`.`txn_report_accrual_redemption`
WHERE txndate BETWEEN '2022-01-01' AND '2022-06-30'
GROUP BY 1,2;#1572357


SELECT COUNT(DISTINCT mobile) FROM dummy.batabangladesh_FA_2022;#1172795

#################################################################################################################
# 1Day

SELECT COUNT(DISTINCT mobile) FROM dummy.batabangladesh_FA_2022
WHERE spend>=4000;#

SELECT COUNT(DISTINCT mobile) FROM dummy.batabangladesh_FA_2022
WHERE spend>=5000;#

SELECT COUNT(DISTINCT mobile) FROM dummy.batabangladesh_FA_2022
WHERE spend>=6000;#

SELECT COUNT(DISTINCT mobile) FROM dummy.batabangladesh_FA_2022
WHERE spend>=7000;#



SELECT COUNT(DISTINCT mobile) FROM dummy.batabangladesh_FA_2022
WHERE TotalBills>=2;# 

SELECT COUNT(DISTINCT mobile) FROM dummy.batabangladesh_FA_2022
WHERE TotalBills>=3;# 

SELECT COUNT(DISTINCT mobile) FROM dummy.batabangladesh_FA_2022
WHERE TotalBills>=4;# 

SELECT COUNT(DISTINCT mobile) FROM dummy.batabangladesh_FA_2022
WHERE TotalBills>=5;# 



SELECT COUNT(DISTINCT mobile) FROM dummy.batabangladesh_FA_2022
WHERE spend>=4000 OR TotalBills>=2;#

SELECT COUNT(DISTINCT mobile) FROM dummy.batabangladesh_FA_2022
WHERE spend>=5000 OR TotalBills>=3;#

SELECT COUNT(DISTINCT mobile) FROM dummy.batabangladesh_FA_2022
WHERE spend>=6000 OR TotalBills>=4;#

SELECT COUNT(DISTINCT mobile) FROM dummy.batabangladesh_FA_2022
WHERE spend>=7000 OR TotalBills>=5;#

#################################################################################################################
# 7 Days


SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2022-01-01')) DIV 7 AS week_num,
'2022-01-01' + INTERVAL (DATEDIFF(txndate,'2022-01-01') DIV 7) WEEK AS week_start,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.batabangladesh_FA_2022
GROUP BY 1,2
HAVING totalspend>=8000 )a;#27255


SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2022-01-01')) DIV 7 AS week_num,
'2022-01-01' + INTERVAL (DATEDIFF(txndate,'2022-01-01') DIV 7) WEEK AS week_start,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.batabangladesh_FA_2022
GROUP BY 1,2
HAVING totalspend>=10000 )a;#18637

SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2022-01-01')) DIV 7 AS week_num,
'2022-01-01' + INTERVAL (DATEDIFF(txndate,'2022-01-01') DIV 7) WEEK AS week_start,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.batabangladesh_FA_2022
GROUP BY 1,2
HAVING totalspend>=12000 )a;#13618

SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2022-01-01')) DIV 7 AS week_num,
'2022-01-01' + INTERVAL (DATEDIFF(txndate,'2022-01-01') DIV 7) WEEK AS week_start,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.batabangladesh_FA_2022
GROUP BY 1,2
HAVING totalspend>=14000 )a;#9939


SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2022-01-01')) DIV 7 AS week_num,
'2022-01-01' + INTERVAL (DATEDIFF(txndate,'2022-01-01') DIV 7) WEEK AS week_start,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.batabangladesh_FA_2022
GROUP BY 1,2
HAVING transactions>=4 )a;#16511


SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2022-01-01')) DIV 7 AS week_num,
'2022-01-01' + INTERVAL (DATEDIFF(txndate,'2022-01-01') DIV 7) WEEK AS week_start,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.batabangladesh_FA_2022
GROUP BY 1,2
HAVING transactions>=6 )a;#8597

SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2022-01-01')) DIV 7 AS week_num,
'2022-01-01' + INTERVAL (DATEDIFF(txndate,'2022-01-01') DIV 7) WEEK AS week_start,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.batabangladesh_FA_2022
GROUP BY 1,2
HAVING transactions>=8 )a;#5673

SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2022-01-01')) DIV 7 AS week_num,
'2022-01-01' + INTERVAL (DATEDIFF(txndate,'2022-01-01') DIV 7) WEEK AS week_start,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.batabangladesh_FA_2022
GROUP BY 1,2
HAVING transactions>=10 )a;#4076


SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2022-01-01')) DIV 7 AS week_num,
'2022-01-01' + INTERVAL (DATEDIFF(txndate,'2022-01-01') DIV 7) WEEK AS week_start,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.batabangladesh_FA_2022
GROUP BY 1,2
HAVING totalspend>=8000 OR transactions>=4 )a;#36366

SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2022-01-01')) DIV 7 AS week_num,
'2022-01-01' + INTERVAL (DATEDIFF(txndate,'2022-01-01') DIV 7) WEEK AS week_start,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.batabangladesh_FA_2022
GROUP BY 1,2
HAVING totalspend>=10000 OR transactions>=6 )a;#22553

SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2022-01-01')) DIV 7 AS week_num,
'2022-01-01' + INTERVAL (DATEDIFF(txndate,'2022-01-01') DIV 7) WEEK AS week_start,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.batabangladesh_FA_2022
GROUP BY 1,2
HAVING totalspend>=12000 OR transactions>=8 )a;#15905

SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2022-01-01')) DIV 7 AS week_num,
'2022-01-01' + INTERVAL (DATEDIFF(txndate,'2022-01-01') DIV 7) WEEK AS week_start,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.batabangladesh_FA_2022
GROUP BY 1,2
HAVING totalspend>=14000 OR transactions>=10 )a;#11378


####################################################################################################

#15 days


SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2022-01-01')) DIV 15 AS 15DaysCount,
'2022-01-01' + INTERVAL (DATEDIFF(txndate,'2022-01-01') DIV 15) WEEK AS 15DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.batabangladesh_FA_2022
GROUP BY 1,2
HAVING totalspend>=12000 )a;#14628


SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2022-01-01')) DIV 15 AS 15DaysCount,
'2022-01-01' + INTERVAL (DATEDIFF(txndate,'2022-01-01') DIV 15) WEEK AS 15DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.batabangladesh_FA_2022
GROUP BY 1,2
HAVING totalspend>=15000 )a;#9356

SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2022-01-01')) DIV 15 AS 15DaysCount,
'2022-01-01' + INTERVAL (DATEDIFF(txndate,'2022-01-01') DIV 15) WEEK AS 15DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.batabangladesh_FA_2022
GROUP BY 1,2
HAVING totalspend>=18000 )a;#6447

SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2022-01-01')) DIV 15 AS 15DaysCount,
'2022-01-01' + INTERVAL (DATEDIFF(txndate,'2022-01-01') DIV 15) WEEK AS 15DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.batabangladesh_FA_2022
GROUP BY 1,2
HAVING totalspend>=21000 )a;#4793


SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2022-01-01')) DIV 15 AS 15DaysCount,
'2022-01-01' + INTERVAL (DATEDIFF(txndate,'2022-01-01') DIV 15) WEEK AS 15DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.batabangladesh_FA_2022
GROUP BY 1,2
HAVING transactions>=6 )a;#9738


SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2022-01-01')) DIV 15 AS 15DaysCount,
'2022-01-01' + INTERVAL (DATEDIFF(txndate,'2022-01-01') DIV 15) WEEK AS 15DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.batabangladesh_FA_2022
GROUP BY 1,2
HAVING transactions>=9 )a;#5550

SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2022-01-01')) DIV 15 AS 15DaysCount,
'2022-01-01' + INTERVAL (DATEDIFF(txndate,'2022-01-01') DIV 15) WEEK AS 15DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.batabangladesh_FA_2022
GROUP BY 1,2
HAVING transactions>=12 )a;#3618

SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2022-01-01')) DIV 15 AS 15DaysCount,
'2022-01-01' + INTERVAL (DATEDIFF(txndate,'2022-01-01') DIV 15) WEEK AS 15DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.batabangladesh_FA_2022
GROUP BY 1,2
HAVING transactions>=15 )a;#2525


SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2022-01-01')) DIV 15 AS 15DaysCount,
'2022-01-01' + INTERVAL (DATEDIFF(txndate,'2022-01-01') DIV 15) WEEK AS 15DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.batabangladesh_FA_2022
GROUP BY 1,2
HAVING totalspend>=12000 OR transactions>=6 )a;#19700

SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2022-01-01')) DIV 15 AS 15DaysCount,
'2022-01-01' + INTERVAL (DATEDIFF(txndate,'2022-01-01') DIV 15) WEEK AS 15DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.batabangladesh_FA_2022
GROUP BY 1,2
HAVING totalspend>=15000 OR transactions>=9 )a;#11752

SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2022-01-01')) DIV 15 AS 15DaysCount,
'2022-01-01' + INTERVAL (DATEDIFF(txndate,'2022-01-01') DIV 15) WEEK AS 15DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.batabangladesh_FA_2022
GROUP BY 1,2
HAVING totalspend>=18000 OR transactions>=12 )a;#7764

SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2022-01-01')) DIV 15 AS 15DaysCount,
'2022-01-01' + INTERVAL (DATEDIFF(txndate,'2022-01-01') DIV 15) WEEK AS 15DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.batabangladesh_FA_2022
GROUP BY 1,2
HAVING totalspend>=21000 OR transactions>=15 )a;#5583

###############################################################################################

# 30 days

SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2022-01-01')) DIV 30 AS 30DaysCount,
'2022-01-01' + INTERVAL (DATEDIFF(txndate,'2022-01-01') DIV 30) WEEK AS 30DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.batabangladesh_FA_2022
GROUP BY 1,2
HAVING totalspend>=16000 )a;#9072


SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2022-01-01')) DIV 30 AS 30DaysCount,
'2022-01-01' + INTERVAL (DATEDIFF(txndate,'2022-01-01') DIV 30) WEEK AS 30DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.batabangladesh_FA_2022
GROUP BY 1,2
HAVING totalspend>=20000 )a;#6052

SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2022-01-01')) DIV 30 AS 30DaysCount,
'2022-01-01' + INTERVAL (DATEDIFF(txndate,'2022-01-01') DIV 30) WEEK AS 30DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.batabangladesh_FA_2022
GROUP BY 1,2
HAVING totalspend>=24000 )a;#4286

SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2022-01-01')) DIV 30 AS 30DaysCount,
'2022-01-01' + INTERVAL (DATEDIFF(txndate,'2022-01-01') DIV 30) WEEK AS 30DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.batabangladesh_FA_2022
GROUP BY 1,2
HAVING totalspend>=28000 )a;#3242


SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2022-01-01')) DIV 30 AS 30DaysCount,
'2022-01-01' + INTERVAL (DATEDIFF(txndate,'2022-01-01') DIV 30) WEEK AS 30DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.batabangladesh_FA_2022
GROUP BY 1,2
HAVING transactions>=8 )a;#7504


SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2022-01-01')) DIV 30 AS 30DaysCount,
'2022-01-01' + INTERVAL (DATEDIFF(txndate,'2022-01-01') DIV 30) WEEK AS 30DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.batabangladesh_FA_2022
GROUP BY 1,2
HAVING transactions>=12 )a;#4290

SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2022-01-01')) DIV 30 AS 30DaysCount,
'2022-01-01' + INTERVAL (DATEDIFF(txndate,'2022-01-01') DIV 30) WEEK AS 30DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.batabangladesh_FA_2022
GROUP BY 1,2
HAVING transactions>=16 )a;#2782

SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2022-01-01')) DIV 30 AS 30DaysCount,
'2022-01-01' + INTERVAL (DATEDIFF(txndate,'2022-01-01') DIV 30) WEEK AS 30DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.batabangladesh_FA_2022
GROUP BY 1,2
HAVING transactions>=20 )a;#1975


SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2022-01-01')) DIV 30 AS 30DaysCount,
'2022-01-01' + INTERVAL (DATEDIFF(txndate,'2022-01-01') DIV 30) WEEK AS 30DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.batabangladesh_FA_2022
GROUP BY 1,2
HAVING totalspend>=16000 OR transactions>=8 )a;#12780

SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2022-01-01')) DIV 30 AS 30DaysCount,
'2022-01-01' + INTERVAL (DATEDIFF(txndate,'2022-01-01') DIV 30) WEEK AS 30DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.batabangladesh_FA_2022
GROUP BY 1,2
HAVING totalspend>=20000 OR transactions>=12 )a;#7727

SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2022-01-01')) DIV 30 AS 30DaysCount,
'2022-01-01' + INTERVAL (DATEDIFF(txndate,'2022-01-01') DIV 30) WEEK AS 30DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.batabangladesh_FA_2022
GROUP BY 1,2
HAVING totalspend>=24000 OR transactions>=16 )a;#5220

SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2022-01-01')) DIV 30 AS 30DaysCount,
'2022-01-01' + INTERVAL (DATEDIFF(txndate,'2022-01-01') DIV 30) WEEK AS 30DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.batabangladesh_FA_2022
GROUP BY 1,2
HAVING totalspend>=28000 OR transactions>=20 )a;#3832

######################################################################################################################

#All Or conditions

SELECT COUNT(DISTINCT mobile) FROM(
SELECT DISTINCT mobile FROM dummy.batabangladesh_FA_2022
WHERE spend>=4000 OR TotalBills>=2
UNION
SELECT DISTINCT mobile FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2022-01-01')) DIV 7 AS week_num,
'2022-01-01' + INTERVAL (DATEDIFF(txndate,'2022-01-01') DIV 7) WEEK AS week_start,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.batabangladesh_FA_2022
GROUP BY 1,2
HAVING totalspend>=8000 OR transactions>=4 )a
UNION
SELECT DISTINCT mobile FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2022-01-01')) DIV 15 AS 15DaysCount,
'2022-01-01' + INTERVAL (DATEDIFF(txndate,'2022-01-01') DIV 15) WEEK AS 15DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.batabangladesh_FA_2022
GROUP BY 1,2
HAVING totalspend>=12000 OR transactions>=6 )b
UNION
SELECT COUNT(DISTINCT mobile) FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2022-01-01')) DIV 30 AS 30DaysCount,
'2022-01-01' + INTERVAL (DATEDIFF(txndate,'2022-01-01') DIV 30) WEEK AS 30DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.batabangladesh_FA_2022
GROUP BY 1,2
HAVING totalspend>=16000 OR transactions>=8 )d
)e;#164481








SELECT COUNT(DISTINCT mobile) FROM(
SELECT DISTINCT mobile FROM dummy.batabangladesh_FA_2022
WHERE spend>=5000 OR TotalBills>=3
UNION 
SELECT DISTINCT mobile FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2022-01-01')) DIV 7 AS week_num,
'2022-01-01' + INTERVAL (DATEDIFF(txndate,'2022-01-01') DIV 7) WEEK AS week_start,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.batabangladesh_FA_2022
GROUP BY 1,2
HAVING totalspend>=10000 OR transactions>=6 )a
UNION 
SELECT DISTINCT mobile FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2022-01-01')) DIV 15 AS 15DaysCount,
'2022-01-01' + INTERVAL (DATEDIFF(txndate,'2022-01-01') DIV 15) WEEK AS 15DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.batabangladesh_FA_2022
GROUP BY 1,2
HAVING totalspend>=15000 OR transactions>=9 )b
UNION
SELECT DISTINCT mobile FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2022-01-01')) DIV 30 AS 30DaysCount,
'2022-01-01' + INTERVAL (DATEDIFF(txndate,'2022-01-01') DIV 30) WEEK AS 30DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.batabangladesh_FA_2022
GROUP BY 1,2
HAVING totalspend>=20000 OR transactions>=12 )c
)e;#71738





SELECT COUNT(DISTINCT mobile) FROM(
SELECT DISTINCT mobile FROM dummy.batabangladesh_FA_2022
WHERE spend>=6000 OR TotalBills>=4
UNION
SELECT DISTINCT mobile FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2022-01-01')) DIV 7 AS week_num,
'2022-01-01' + INTERVAL (DATEDIFF(txndate,'2022-01-01') DIV 7) WEEK AS week_start,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.batabangladesh_FA_2022
GROUP BY 1,2
HAVING totalspend>=12000 OR transactions>=8 )a
UNION
SELECT DISTINCT mobile FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2022-01-01')) DIV 15 AS 15DaysCount,
'2022-01-01' + INTERVAL (DATEDIFF(txndate,'2022-01-01') DIV 15) WEEK AS 15DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.batabangladesh_FA_2022
GROUP BY 1,2
HAVING totalspend>=18000 OR transactions>=12 )b
UNION
SELECT DISTINCT mobile FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2022-01-01')) DIV 30 AS 30DaysCount,
'2022-01-01' + INTERVAL (DATEDIFF(txndate,'2022-01-01') DIV 30) WEEK AS 30DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.batabangladesh_FA_2022
GROUP BY 1,2
HAVING totalspend>=24000 OR transactions>=16 )c
)d;#47964



SELECT COUNT(DISTINCT mobile) FROM(
SELECT DISTINCT mobile FROM dummy.batabangladesh_FA_2022
WHERE spend>=7000 OR TotalBills>=5
UNION
SELECT DISTINCT mobile FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2022-01-01')) DIV 7 AS week_num,
'2022-01-01' + INTERVAL (DATEDIFF(txndate,'2022-01-01') DIV 7) WEEK AS week_start,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.batabangladesh_FA_2022
GROUP BY 1,2
HAVING totalspend>=14000 OR transactions>=10 )a
UNION
SELECT DISTINCT mobile FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2022-01-01')) DIV 15 AS 15DaysCount,
'2022-01-01' + INTERVAL (DATEDIFF(txndate,'2022-01-01') DIV 15) WEEK AS 15DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.batabangladesh_FA_2022
GROUP BY 1,2
HAVING totalspend>=21000 OR transactions>=15 )b
UNION
SELECT DISTINCT mobile FROM 
(SELECT mobile,
CONCAT(1 + DATEDIFF(txndate,'2022-01-01')) DIV 30 AS 30DaysCount,
'2022-01-01' + INTERVAL (DATEDIFF(txndate,'2022-01-01') DIV 30) WEEK AS 30DaysStart,
SUM(spend)totalspend,COUNT(DISTINCT txndate)visits,
SUM(TotalBills)transactions
FROM dummy.batabangladesh_FA_2022
GROUP BY 1,2
HAVING totalspend>=28000 OR transactions>=20 )c
)d#35510