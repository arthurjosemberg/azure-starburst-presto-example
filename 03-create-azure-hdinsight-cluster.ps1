<### -------------------------- ###
    Create HDInsight Environment 
#>## -------------------------- ###

### Login to Azure Account ###
#Login-AzAccount 

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
