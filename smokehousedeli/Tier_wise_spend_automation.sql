SET @currentmbrmonthstart = DATE_SUB(DATE_FORMAT(CURDATE(), '%Y-%m-01'), INTERVAL 1 MONTH);
SET @currentmbrmonthend= LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH));
SELECT @currentmbrmonthstart,@currentmbrmonthend;

SELECT 
tiername,
COUNT(DISTINCT mobile) AS Transactor,
SUM(amount) AS Sales,
ROUND(SUM(amount)/SUM(SUM(amount)) OVER(),4) AS Sales_contribution, 
COUNT(DISTINCT UniqueBillNo) AS bills,
SUM(amount)/COUNT(DISTINCT mobile)AMV,
SUM(amount)/COUNT(DISTINCT UniqueBillNo) ATV,
COUNT(DISTINCT UniqueBillNo) / COUNT(DISTINCT mobile) AS visit
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN @currentmbrmonthstart AND @currentmbrmonthend
AND storecode NOT IN('demo','Corporate','Whatsapp','DummyStore')
GROUP BY 1;
