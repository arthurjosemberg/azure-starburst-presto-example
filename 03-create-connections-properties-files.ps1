### Login to Azure Account ###
#Login-AzAccount

# ALTERE O NOME DA SUBSCRIPTION
$subcriptionName = "Microsoft Azure Sponsorship"

# ALTERE O DIRETORIO ONDE OS ARQUIVOS IRÃO FICAR
$configurationFilesDirectory = "/Users/arthurluz/OneDrive/dataslight/starburst_presto"

# CosmosDb Variables
$cosmosdbAccountName = "dataslightcdb"
$resourceGroupName = "bigdatargn"

#SqlDatabase Variables
$sqldatabaseserverName = "dataslightaw"
$sqldatabasedatabaseName = "adventureWorks"
$sqldatabaseUser = "arthur.luz"
$sqldatabasePassword = "b1gDataCluster&"

# Set subscription 
Set-AzContext -SubscriptionName $subcriptionName

# Get Azure CosmosDB Account Key
$securetyKey = Get-CosmosDbAccountMasterKey -Name $cosmosdbAccountName -ResourceGroupName $resourceGroupName -MasterKeyType "PrimaryMasterKey"
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($securetyKey)
$key = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

# Shell Scripts to add account key into Starburst Presto Configuration File
cd $configurationFilesDirectory
rm -rf ./*
mkdir -p etc/catalog/
cd ./etc/catalog

rm mongodb_advworks.properties
echo "connector.name=mongodb
mongodb.seeds=dataslightcdb.documents.azure.com:10255
mongodb.credentials=dataslightcdb:$key@product
mongodb.ssl.enabled=true" > mongodb_advworks.properties

rm sqldatabase_advworks.properties
echo "connector.name=sqlserver
connection-url=jdbc:sqlserver://$sqldatabaseserverName.database.windows.net:1433;database=$sqldatabasedatabaseName;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;
connection-user=$sqldatabaseUser
connection-password=$sqldatabasePassword" > sqldatabase_advworks.properties

cd ../..
rm presto-connectors.zip
zip -r presto-connectors.zip ./etc/*
