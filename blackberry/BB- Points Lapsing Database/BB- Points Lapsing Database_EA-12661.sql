SELECT * FROM lapse_report;
-- ask 1 Required Customer data who have point expiry by end of November
##################______________________________########################

INSERT INTO dummy.lapsing_points_data_harish
SELECT mobile,SUM(pointslapsing)lapsing_points FROM lapse_report
WHERE lapsingdate BETWEEN '2025-11-01' AND '2025-11-30' 
GROUP BY 1;#19654

ALTER TABLE dummy.lapsing_points_data_harish ADD INDEX mobile(mobile),ADD COLUMN FirstName VARCHAR(200),ADD COLUMN LastName VARCHAR(200),ADD COLUMN tier VARCHAR(100),ADD COLUMN Available_Points VARCHAR(200),ADD COLUMN DOB VARCHAR(200);

UPDATE dummy.lapsing_points_data_harish a JOIN member_report b USING(mobile)
SET a.FirstName=b.FirstName,a.LastName=b.LastName,a.tier=b.tier,
a.Available_Points=b.AvailablePoints,a.DOB=b.dateofbirth;#19475


ALTER TABLE dummy.lapsing_points_data_harish ADD COLUMN Last_transacted_store VARCHAR(200),ADD COLUMN Last_Shopped_Date VARCHAR(200),ADD COLUMN PreferredStore VARCHAR(200);

UPDATE dummy.lapsing_points_data_harish a JOIN program_single_view b USING(mobile)
SET a.Last_transacted_store=b.`last shopped store`,a.Last_Shopped_Date=b.`Last Shopped Date`,a.PreferredStore=b.PreferredStore;#19474



SELECT mobile,FirstName,LastName,tier,available_points,DOB,Last_Shopped_Date,last_transacted_store,preferredstore FROM dummy.lapsing_points_data_harish;

SELECT * FROM program_single_view LIMIT 10;


-- ASK 2 have balance point 500 & above.
############################_____________________________#######################


INSERT INTO dummy.balance_points_harish
SELECT mobile,FirstName,LastName,tier,dateofbirth,AvailablePoints FROM member_report 
WHERE AvailablePoints>=500 ;#67527

ALTER TABLE dummy.balance_points_harish ADD COLUMN Last_transacted_store VARCHAR(200),ADD COLUMN Last_Shopped_Date VARCHAR(200),ADD COLUMN PreferredStore VARCHAR(200);

UPDATE dummy.balance_points_harish a JOIN program_single_view b USING(mobile)
SET a.Last_transacted_store=b.`last shopped store`,a.Last_Shopped_Date=b.`Last Shopped Date`,a.PreferredStore=b.PreferredStore;#67520



SELECT * FROM dummy.balance_points_harish;
