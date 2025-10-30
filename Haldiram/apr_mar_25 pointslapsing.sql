SELECT * FROM lapse_report LIMIT 10;

-- april month points lapsing
SELECT mobile,SUM(pointslapsing)pointslapsing,lapsingdate FROM lapse_report
WHERE lapsingdate BETWEEN '2025-04-01' AND '2025-04-30' AND pointslapsing>0
GROUP BY 1;


-- may month points lapsing


SELECT mobile,SUM(pointslapsing)pointslapsing,lapsingdate FROM lapse_report
WHERE lapsingdate BETWEEN '2025-05-01' AND '2025-05-31' AND pointslapsing>0
GROUP BY 1;