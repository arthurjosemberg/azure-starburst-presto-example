### Login into HDInsightCluster ###
ssh arthurluzssh@starburstpresto-ssh.azurehdinsight.net

### Open Hive application ###
/usr/bin/hive

### Create Hive AdventureWorks Database ###
CREATE DATABASE adventureworks;

### Creating Hive Table to Text ###
CREATE EXTERNAL TABLE SalesOrderDetail (
    SalesOrderID int,
    SalesOrderDetailID int,
    CarrierTrackingNumber varchar(25),
    OrderQty smallint,
    ProductID int,
    SpecialOfferID int,
    UnitPrice decimal(10,2),
    UnitPriceDiscount decimal(10,2),
    LineTotal decimal(38,6),
    rowguid varchar(100),
    ModifiedDate timestamp
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE LOCATION '/hive/advworks-files';

### Load Data Into Hive Table ###
LOAD DATA INPATH '/hive/advworks-files/SalesOrderDetail.csv' INTO TABLE SalesOrderDetail;

