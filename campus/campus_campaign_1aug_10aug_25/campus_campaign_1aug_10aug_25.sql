-- use this method to extract date in excel file formula RIGHT(campaignsubcode,10)DATE
-- SELECT a.*,b.lpaasstore,b.storetype1,b.city,b.state
-- FROM `campuscrm`.responders_data a LEFT JOIN store_master b ON a.storecode COLLATE utf8mb4_unicode_ci =b.storecode 
-- WHERE 
-- RIGHT(campaignsubcode, 10) >= '2025-09-01' 
-- AND RIGHT(campaignsubcode, 10) <= '2025-09-28';
-- 
-- SELECT * FROM store_master

-- use this method to extract date in excel file formula RIGHT(campaignsubcode,10)DATE

SELECT a.*,b.lpaasstore,
CASE WHEN storetype1='Not Identified' THEN 'Online' ELSE storetype1 END storetype,
-- b.storetype1,
b.city,b.state
FROM `campuscrm`.responders_data a LEFT JOIN store_master b ON a.storecode COLLATE utf8mb4_unicode_ci =b.storecode 
WHERE 
RIGHT(campaignsubcode, 10) >= '2025-08-01' 
AND RIGHT(campaignsubcode, 10) <= '2025-08-12';



-- ____________________coupon offer report__________________________

SELECT DISTINCT issuedmobile mobile,billno,lpaasstore issuedstore,amount,discount,couponoffercode,couponcode,
CouponStatus,issueddate,useddate 
FROM coupon_offer_report a JOIN store_master b ON a.issuedstore=b.storecode
WHERE couponstatus = 'Used' AND useddate >= '2025-08-01' AND useddate <= '2025-08-12';


######################################################

SELECT * FROM store_master 
WHERE storecode IN ('CAPLAHGJ','CAPLKAGJ'
);
