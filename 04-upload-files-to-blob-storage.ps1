<### ------------------------ ###
     Load Data Into HDInsight 
#>## ------------------------ ###

### Login to Azure Account ###
#Login-AzAccount 

# ALTERE O NOME DA SUBSCRIPTION
$subcriptionName = "Microsoft Azure Sponsorship"

# ALTERE O DIRETORIO ONDE OS ARQUIVOS IRÃO FICAR
$configurationFilesDirectory = "/Users/arthurluz/OneDrive/dataslight/starburst_presto"

### Create Variables ###
$resourceGroupName = "bigdatargn"
$storageAccountName = "storage$resourceGroupName"
$containerName = "starburstpresto"
$location = "West US"
$fileLocation1 = "$configurationFilesDirectory/presto-connectors.zip"
$fileLocation2 = "$configurationFilesDirectory/adventureworks_oltp_files/SalesOrderDetail.csv"

# Set subscription 
Set-AzContext -SubscriptionName $subcriptionName -Force

### Create new Storage Account ###
New-AzStorageAccount -ResourceGroupName $resourceGroupName `
                     -Name $storageAccountName `
                     -Type Standard_GRS `
                     -Location $location 

### Create a Blob Storage Container ###
### It's necessary container security access on blob
$storageAccountKey = (Get-AzStorageAccountKey -ResourceGroupName $resourceGroupName `
                                             -Name $storageAccountName).Value[0]

$storageContext = New-AzStorageContext -StorageAccountName $storageAccountName `
                                       -StorageAccountKey $storageAccountKey

New-AzStorageContainer -Name $containerName `
                       -Context $storageContext `
                       -Permission Container

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