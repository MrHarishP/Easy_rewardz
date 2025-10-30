-- EA-12280_Customers 1st Transaction details
SELECT `txnmappedMobile`,`UniqueBillNo`,modifiedstorecode,modifiedtxndate,
SUM(itemnetamount)sales,SUM(itemqty)qty,`CouponOfferCode`,frequencycount,c.tier,modifiedenrolledon
FROM `sku_report_loyalty` a LEFT JOIN `coupon_offer_report` b 
ON (a.modifiedtxndate=b.useddate AND a.modifiedbillno=b.billno AND a.modifiedstorecode=b.RedeemedStorecode)
LEFT JOIN member_report c ON a.txnmappedmobile=c.mobile
WHERE modifiedtxndate BETWEEN '2025-08-01' AND '2025-08-26' AND frequencycount=1
GROUP BY 1,2;


SELECT txnmappedmobile,COUNT(DISTINCT uniquebillno)bills,SUM(sales)sales,SUM(qty)qty,COUNT(CouponOfferCode)CouponOfferCode,tier,modifiedenrolledon 
FROM(
SELECT `txnmappedMobile`,`UniqueBillNo`,SUM(itemnetamount)sales,SUM(itemqty)qty,`CouponOfferCode`,frequencycount,c.tier,modifiedenrolledon
FROM `sku_report_loyalty` a LEFT JOIN `coupon_offer_report` b 
ON (a.modifiedtxndate=b.useddate AND a.modifiedbillno=b.billno AND a.modifiedstorecode=b.RedeemedStorecode)
LEFT JOIN member_report c ON a.txnmappedmobile=c.mobile
WHERE modifiedtxndate BETWEEN '2025-08-01' AND '2025-08-26' AND frequencycount=1
GROUP BY 1,2)a GROUP BY 1;


SELECT * FROM txn_report_accrual_redemption
WHERE txncount=1 AND txndate BETWEEN '2025-08-01' AND '2025-08-26'

SELECT DISTINCT txnmappedmobile,uniquebillno,itemnetamount FROM sku_report_loyalty
WHERE txndate BETWEEN '2025-08-01' AND '2025-08-26' AND frequencycount=1


SELECT * FROM coupon_offer_report
WHERE CouponOfferCode='10percentoffon6000upto1000';

SELECT * FROM member_report
WHERE mobile = '9839887404';

SELECT * FROM store_master
WHERE storecode = '1130';