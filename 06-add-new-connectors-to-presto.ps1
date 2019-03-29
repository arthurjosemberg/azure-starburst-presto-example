<### ---------------------------------------------------- ###
    Add Connectors on Starburst Presto on HdInsight Cluster
#>## ---------------------------------------------------- ###

# ALTERE O NOME DA SUBSCRIPTION
$subcriptionName = "Microsoft Azure Sponsorship"

### Create Variables ###
$resourceGroupName = "bigdatargn"
$storageAccountName = "storage$resourceGroupName"
$containerName = "starburstpresto"
$clusterName = $containerName

# Declare Variable to Install and Configure Starburst Presto
$nodeTypesHeadWork = "HeadNode", "WorkerNode"

### Select Azure Subscription Context ###
Set-AzContext -SubscriptionName $subcriptionName

# Add New Connections
Submit-AzHDInsightScriptAction -ClusterName $clusterName `
                               -Name "configurenewconnections" `
                               -Uri "https://starburstdata.blob.core.windows.net/302-e/update-presto-config.sh" `
                               -NodeTypes $nodeTypesHeadWork `
                               -Parameters "-p https://$storageAccountName.blob.core.windows.net/$containerName/customConnectors/presto-connectors.zip"