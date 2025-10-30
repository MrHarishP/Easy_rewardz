CREATE TABLE dummy.unmasked_COCO_LT_CustomerBase_151 (
    Mobile VARCHAR(20),
    FirstName VARCHAR(100),
    Email VARCHAR(150),
    globaltestcontrol VARCHAR(50),
    CountryCode VARCHAR(10),
    EnrolledStore VARCHAR(50),
    AvailablePoints INT,
    TotalSpends DECIMAL(10, 2),
    TotalTransactions INT,
    TotalVisits INT,
    AverageSpendPerVisit DECIMAL(10, 2),
    Recency INT,
    Latency INT,
    CustomerType VARCHAR(50),
    TotalPointsCollected INT,
    PointsSpent INT,
    LastShoppedDate DATE,
    LastName VARCHAR(100),
    TierName VARCHAR(50),
    EnrolledOn DATE,
    DateOfBirth DATE
);

LOAD DATA LOCAL INFILE  "D:\\OneDrive - EasyRewardz Software Services Private Limited\\North\\dummy\\unmasked_COCO_LT_CustomerBase_151.csv" 
INTO TABLE dummy.unmasked_COCO_LT_CustomerBase_151
CHARACTER SET 'latin1'
FIELDS ESCAPED BY '\\' 
TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;#1005390

SELECT * FROM dummy.unmasked_COCO_LT_CustomerBase_151;


CREATE TABLE dummy.unmasked_FOFO_Lt_Customerbase_153 (
    Mobile VARCHAR(20),
    FirstName VARCHAR(100),
    Email VARCHAR(150),
    globaltestcontrol VARCHAR(50),
    CountryCode VARCHAR(10),
    EnrolledStore VARCHAR(50),
    AvailablePoints INT,
    TotalSpends DECIMAL(10, 2),
    TotalTransactions INT,
    TotalVisits INT,
    AverageSpendPerVisit DECIMAL(10, 2),
    Recency INT,
    Latency INT,
    CustomerType VARCHAR(50),
    TotalPointsCollected INT,
    PointsSpent INT,
    LastShoppedDate DATE,
    LastName VARCHAR(100),
    TierName VARCHAR(50),
    EnrolledOn DATE,
    DateOfBirth DATE
);

LOAD DATA LOCAL INFILE  "D:\\OneDrive - EasyRewardz Software Services Private Limited\\North\\dummy\\unmasked_FOFO_Lt_Customerbase_153.csv"
INTO TABLE dummy.unmasked_FOFO_Lt_Customerbase_153
CHARACTER SET 'latin1'
FIELDS ESCAPED BY '\\' 
TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;#948252

SELECT * FROM dummy.unmasked_FOFO_Lt_Customerbase_153 JOIN dummy.unmasked_COCO_LT_CustomerBase_151 USING(mobile)