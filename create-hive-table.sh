### Login into HDInsightCluster ###
ssh arthurluzssh@starburstpresto-ssh.azurehdinsight.net
# b1gDataCluster&

### Open Hive application ###
/usr/bin/hive

### Create Hive AdventureWorks Database ###
CREATE DATABASE adventureworks;

### Creating Hive Table to Text ###
CREATE EXTERNAL TABLE adventureworks.SalesOrderDetail (
    SalesOrderID int,
    SalesOrderDetailID int,
    OrderQty smallint,
    ProductID int,
    UnitPrice decimal(10,2),
    UnitPriceDiscount decimal(10,2),
    LineTotal decimal(38,6),
    rowguid varchar(100),
    ModifiedDate timestamp
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE LOCATION '/hive/advworks-files';

### Load Data Into Hive Table ###
LOAD DATA INPATH '/hive/advworks-files/SalesOrderDetail.csv' INTO TABLE adventureworks.SalesOrderDetail;


