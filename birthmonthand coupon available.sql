-- find those customers whos birthday is in april and they have coupon code are available


SELECT mobile,dateofbirth,couponoffercode,expirydate FROM member_report a JOIN coupon_offer_report b ON a.mobile=b.issuedmobile
WHERE MONTHNAME(dateofbirth) ='april' AND couponstatus='issued' 
GROUP BY 1;
