<### ------------------------ ###
     Load Data Into HDInsight 
#>## ------------------------ ###

### Login to Azure Account ###
#Login-AzAccount 

### Create Variables ###
$subcriptionName = "Microsoft Azure Sponsorship"
$resourceGroupName = "bigdatargn"
$storageAccountName = "storage$resourceGroupName"
$containerName = "starburstpresto"
$fileLocation1 = "/Users/arthurluz/OneDrive/dataslight/starburst_presto/presto-connectors.zip"
$fileLocation2 = "/Users/arthurluz/OneDrive/dataslight/adventureworks_oltp_files/SalesOrderDetail.csv"

### Select Azure Subscription Context ###
Set-AzContext -SubscriptionName $subcriptionName

$storageAccountKey = (Get-AzStorageAccountKey -ResourceGroupName $resourceGroupName `
                                              -Name $storageAccountName).Value[0]

$storageContext = New-AzStorageContext -StorageAccountName $storageAccountName `
                                       -StorageAccountKey $storageAccountKey

# Load file you need to setup the URL to Local zip file with connectors config
set-AzStorageblobcontent -File $fileLocation1 `
                         -Container $containerName `
                         -Blob "customConnectors/presto-connectors.zip" `
                         -Context $storageContext

set-AzStorageblobcontent -File $fileLocation2 `
                         -Container $containerName `
                         -Blob "hive/advworks-files/SalesOrderDetail.csv" `
                         -Context $storageContext `
                         -Force