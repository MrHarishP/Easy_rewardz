WITH customers AS
(
SELECT mobile,SUM(amount)AS sales,SUM(CASE WHEN frequencycount = 1 THEN amount END)AS First_visit_Sale,
SUM(CASE WHEN frequencycount > 1 THEN amount END)AS Repeat_Sale,
COUNT(DISTINCT uniquebillno)AS bills FROM 
txn_report_accrual_redemption 
WHERE txndate BETWEEN '2024-02-01' AND '2025-01-31' AND amount>0
GROUP BY 1),
new_customer AS (
SELECT mobile,storecode  
FROM txn_report_accrual_redemption 
WHERE txndate BETWEEN '2024-02-01' AND '2025-01-31' AND amount>0 AND frequencycount =1
GROUP BY 1)
SELECT storecode,COUNT(DISTINCT mobile)AS customers,SUM(sales)AS total_sales,SUM(First_visit_Sale)AS first_visit_Sale,
SUM(Repeat_Sale)AS Repeat_sale,
SUM(bills)AS Total_bills
FROM customers a JOIN new_customer b
USING(mobile)
GROUP BY 1
