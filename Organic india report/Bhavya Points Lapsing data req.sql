 -- SUMMARY
SELECT YEAR(lapsingdate),MONTHNAME(lapsingdate),SUM(pointslapsing) FROM lapse_report WHERE lapsingdate
BETWEEN '2024-12-01' AND '2025-02-28'
GROUP BY 1,2;

SELECT MAX(lapsingdate) FROM lapse_report;

-- Row Level please first known the date range what is the starting point and what is the endding point
SELECT mobile,billid,txndate,pointscollected,pointsspent,pointslapsing,pointslapsed,lapsingdate FROM lapse_report
WHERE lapsingdate BETWEEN '2024-06-06' AND '2025-01-31';
