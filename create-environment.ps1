### Login to Azure Account ###
#Login-AzAccount

$subcriptionName = "Microsoft Azure Sponsorship"
$resourceGroupName = "bigdatargn"
$location = "West US"
$adminSqlLogin = "arthur.luz"
$password = ConvertTo-SecureString "b1gDataCluster&" -AsPlainText -Force
$serverName = "dataslightaw"
$databaseName = "adventureWorks"
$startIp = "0.0.0.0"
$endIp = "0.0.0.0"
$sqlAdminCredential = New-Object System.Management.Automation.PSCredential ($adminSqlLogin,$password)

# Set subscription 
Set-AzContext -SubscriptionName $subcriptionName

# Create a resource group
New-AzResourceGroup -Name $resourceGroupName -Location $location

# Create a server with a system wide unique server name
New-AzSqlServer -ResourceGroupName $resourceGroupName `
                -ServerName $serverName `
                -Location $location `
                -SqlAdministratorCredentials $sqlAdminCredential

# Create a server firewall rule that allows access from the specified IP range
New-AzSqlServerFirewallRule -ResourceGroupName $resourceGroupName `
                            -ServerName $serverName `
                            -FirewallRuleName "AllowedIPs" `
                            -StartIpAddress $startIp `
                            -EndIpAddress $endIp

# Create a blank database with an S0 performance level
New-AzSqlDatabase  -ResourceGroupName $resourceGroupName `
                   -ServerName $serverName `
                   -DatabaseName $databaseName `
                   -RequestedServiceObjectiveName "S0" `
                   -SampleName "AdventureWorksLT"


$subcriptionName = "Microsoft Azure Sponsorship"
$resourceGroupName = "bigdatargn"
$databaseName = "adventureworks"
$cosmosdbAccountName = "dataslightcdb"
$location = "West US"
$templateFile = "/Users/arthurluz/OneDrive/personal_studies/azure_hdinsight/template_api_mongodb_cosmos_db/template.json"
$templateParameterFile = "/Users/arthurluz/OneDrive/personal_studies/azure_hdinsight/template_api_mongodb_cosmos_db/parametersFile.json"

# Set subscription 
Set-AzContext -SubscriptionName $subcriptionName -Force

# Create a resource group
New-AzResourceGroup -Name $resourceGroupName -Location $location -Force

# Create CosmosDB Account with MongoDB API
New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName `
                              -nameFromTemplate $cosmosdbAccountName `
                              -TemplateFile $templateFile `
                              -TemplateParameterFile $templateParameterFile

# Setup CosmosDb Context
$cosmosDbContext = New-CosmosDbContext -Account $cosmosdbAccountName `
                                       -ResourceGroupName $resourceGroupName `
                                       -MasterKeyType 'PrimaryMasterKey'

# Create CosmosDb Database 
New-CosmosDbDatabase -Context $cosmosDbContext `
                     -Id $databaseName


### Create Variables ###
$subcriptionName = "Microsoft Azure Sponsorship"
$resourceGroupName = "bigdatargn"
$location = "West US"
$storageAccountName = "storage$resourceGroupName"
$containerName = "starburstpresto" 
$clusterName = $containerName
$clusterNodes = 4
$httpUserName = "arthurluzhttp"
$sshUserName = "arthurluzssh"
$password = ConvertTo-SecureString "b1gDataCluster&" -AsPlainText -Force
$templateFile = "/Users/arthurluz/OneDrive/personal_studies/azure_hdinsight/template_edge_node/template.json"
$templateParameterFile = "/Users/arthurluz/OneDrive/personal_studies/azure_hdinsight/template_edge_node/parametersFile.json"

### Select Azure Subscription Context ###
Set-AzContext -SubscriptionName $subcriptionName

### Create new Resource Group ###
#New-AzResourceGroup -Name $resourceGroupName -Location $location

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

### Create Credentials ###
$httpCredential = New-Object System.Management.Automation.PSCredential ($httpUserName,$password)
$sshCredential = New-Object System.Management.Automation.PSCredential ($sshUserName,$password)

### Create Azure HDInsight Cluster ###
New-AzHDInsightCluster -ResourceGroupName $resourceGroupName `
                       -ClusterName $clusterName `
                       -ClusterType Hadoop `
                       -Version 3.6 `
                       -Location $location `
                       -DefaultStorageAccountName "$storageAccountName.blob.core.windows.net" `
                       -DefaultStorageAccountKey $storageAccountKey `
                       -DefaultStorageContainer $containerName `
                       -ClusterSizeInNodes $clusterNodes `
                       -OSType Linux `
                       -HttpCredential $httpCredential `
                       -SshCredential $sshCredential `
                       -EdgeNodeSize Standard_D3

New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName `
                              -ClusterName $clusterName `
                              -TemplateFile $templateFile `
                              -TemplateParameterFile $templateParameterFile


### Select Azure Subscription Context ###
Set-AzContext
### Create Variables ###
$subcriptionName = "Microsoft Azure Sponsorship"
$resourceGroupName = "bigdatargn"
$storageAccountName = "storage$resourceGroupName"
$containerName = "starburstpresto"
$fileLocation1 = "/Users/arthurluz/OneDrive/dataslight/starburst_presto/presto-connectors.zip"
$fileLocation2 = "/Users/arthurluz/OneDrive/dataslight/adventureworks_oltp_files/SalesOrderDetail.csv"
 -SubscriptionName $subcriptionName

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


### Create Variables ###
$subcriptionName = "Microsoft Azure Sponsorship"
$resourceGroupName = "bigdatargn"
$storageAccountName = "storage$resourceGroupName"
$containerName = "starburstpresto"
$clusterName = $containerName

# Declare Variable to Install and Configure Starburst Presto
$nodeTypesHeadWork = "HeadNode", "WorkerNode"
$nodeTypeEdge = "EdgeNode"

### Select Azure Subscription Context ###
Set-AzContext -SubscriptionName $subcriptionName

# Install Starburts Presto Application
Submit-AzHDInsightScriptAction -ClusterName $clusterName `
                               -Name "installpresto" `
                               -Uri "https://starburstdata.blob.core.windows.net/302-e/install-presto.sh" `
                               -NodeTypes $nodeTypesHeadWork `
                               -PersistOnSuccess

# Setup Edge node
Submit-AzHDInsightScriptAction -ClusterName $clusterName `
                               -Name "setupedgenode" `
                               -Uri "https://starburstdata.blob.core.windows.net/302-e/edgenode-setup.sh" `
                               -NodeTypes $nodeTypeEdge `
                               -PersistOnSuccess

# Restart Starburst Presto    
Submit-AzHDInsightScriptAction -ClusterName $clusterName `
                               -Name "restartpresto" `
                               -Uri "https://starburstdata.blob.core.windows.net/302-e/restart-presto.sh" `
                               -NodeTypes $nodeTypesHeadWork 

# Add New Connections
Submit-AzHDInsightScriptAction -ClusterName $clusterName `
                               -Name "configurenewconnections" `
                               -Uri "https://starburstdata.blob.core.windows.net/302-e/update-presto-config.sh" `
                               -NodeTypes $nodeTypesHeadWork `
                               -Parameters "-p https://$storageAccountName.blob.core.windows.net/$containerName/customConnectors/presto-connectors.zip"

<### -------------------- ###
    Remove all Environment 
#>## -------------------- ###

<#
Set-AzContext -SubscriptionName $subcriptionName
Remove-azResourceGroup -Name $resourceGroupName -Force
#>