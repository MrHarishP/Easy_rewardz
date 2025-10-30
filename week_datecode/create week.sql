-- create week by this way 
  WITH RECURSIVE date_series AS(
    SELECT CAST('2025-01-01' AS DATE)DATE
    UNION ALL 
    SELECT DATE_ADD(DATE,INTERVAL 1 DAY) 
    FROM date_series WHERE DATE <='2025-12-31')
    SELECT DATE,MONTHNAME(DATE)MONTH,
    CASE WHEN DATE BETWEEN '2025-01-01' AND '2025-01-05' THEN 1 
    ELSE FLOOR((TO_DAYS(DATE)-TO_DAYS('2025-01-06'))/7)+2 END WEEK,
    YEAR(DATE)YEAR,DAYNAME(DATE)day_name,MONTH(DATE)month_no
    FROM date_series
    WHERE YEAR(DATE)=2025;













WITH RECURSIVE date_series AS (
    SELECT CAST('2025-01-01' AS DATE) AS DATE
    UNION ALL
    SELECT DATE_ADD(DATE, INTERVAL 1 DAY)
    FROM date_series
    WHERE DATE <= '2025-12-31'
),
calender AS(
    SELECT 
        DATE, 
        CASE 
            WHEN DATE BETWEEN '2025-01-01' AND '2025-01-05' THEN 1
            ELSE FLOOR((TO_DAYS(DATE) - TO_DAYS('2025-01-06')) / 7) + 2
        END AS WEEK,
        MONTHNAME(DATE) AS month_name,
        MONTH(DATE) AS monthNO,
        YEAR(DATE) AS YEAR,
        DAYNAME(DATE) AS day_name
    FROM date_series)
    -- 
-- select week,date,count(distinct case when minfc=1 and maxfc=1 then mobile end)onetimer,
-- COUNT(DISTINCT CASE WHEN minfc=1 AND maxfc>1 THEN mobile END)new_repeater,
-- COUNT(DISTINCT CASE WHEN minfc>1 AND maxfc>1 THEN mobile END)old_repeater
--  from(    
-- SELECT mobile,MIN(frequencycount) AS minfc,MAX(frequencycount) AS maxfc,txndate
-- FROM txn_report_accrual_redemption 
-- WHERE txndate BETWEEN '2025-01-01' AND '2025-03-09' AND storecode = 'ecom'
-- GROUP BY 1)a left join calender b on a.txndate=b.date
-- group by 1,2;



-- SELECT week ,COUNT(DISTINCT CASE WHEN frequencycount=1 THEN mobile END) onteimer,
-- COUNT(DISTINCT CASE WHEN frequencycount>1 THEN mobile END )onteimer,
-- COUNT(DISTINCT mobile) FROM txn_report_accrual_redemption a join calender b on a.txndate=b.date
-- WHERE txndate BETWEEN '2025-01-01' AND '2025-01-05' 
-- AND storecode ='ecom'
-- group by 1






SELECT store_type,month_name,WEEK,
COUNT(DISTINCT CASE WHEN fc=1  THEN mobile END)onetimer,
COUNT(DISTINCT CASE WHEN fc>1 THEN mobile END)repeater,
-- COUNT(DISTINCT CASE WHEN  frequencycount=1 THEN mobile END)first_timer,
-- COUNT(DISTINCT CASE WHEN   frequencycount>1 THEN mobile END)new_repeater,
COUNT(DISTINCT mobile)customer
-- SUM(CASE WHEN  frequencycount=1 THEN sales END)first_timersale,
-- SUM(CASE WHEN  frequencycount>1 THEN sales END)new_repeatersale,SUM(sales)sales 
FROM(
SELECT
CASE WHEN storecode ='ecom' THEN 'online_store' ELSE 'offline' END store_type,
mobile,
txndate,SUM(amount)sales,frequencycount fc
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2025-01-01' AND '2025-03-09'
AND amount>0 AND mobile NOT IN (SELECT mobile FROM probable_fraud_customer)AND 
storecode NOT LIKE '%demo%' AND billno NOT LIKE '%test%' AND billno NOT LIKE '%roll%'
GROUP BY 1,2
)a LEFT JOIN calender b  ON a.txndate=b.DATE
GROUP BY 1,2,3
ORDER BY 1,2;


SELECT COUNT(DISTINCT CASE WHEN frequencycount=1 THEN mobile END) onteimer,
COUNT(DISTINCT CASE WHEN frequencycount>1 THEN mobile END )onteimer,
COUNT(DISTINCT mobile) FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2025-01-01' AND '2025-01-05'
AND storecode ='ecom'