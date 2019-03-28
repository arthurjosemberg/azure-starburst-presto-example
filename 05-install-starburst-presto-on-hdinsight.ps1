<### ------------------------------------------- ###
    Install Starburst Presto on HdInsight Cluster
#>## ------------------------------------------- ###

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