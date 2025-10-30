SELECT DISTINCT mobile,identifieddatemin,fraudcode,fraudcodedesc 
FROM probable_fraud_customer
WHERE identifieddatemin >='2025-07-08';
