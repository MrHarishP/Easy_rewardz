-- this dummy is created by suraj 
SELECT * FROM dummy.bb_Focussed_store_and_Bottom_Stores ;

INSERT INTO dummy.BB_focused_store_and_bottom_store_EA_12186
SELECT mobile,Segment_Name,lpaasstore,last_shopped_store,storeurl
FROM dummy.bb_Focussed_store_and_Bottom_Stores a LEFT JOIN store_master b ON a.`last_shopped_store`=b.storecode
GROUP BY 1;#213236


SELECT * FROM dummy.BB_focused_store_and_bottom_store_EA_12186;

SELECT * FROM store_master;