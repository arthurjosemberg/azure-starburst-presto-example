<### -------------------- ###
    Remove all Environment 
#>## -------------------- ###

### Login to Azure Account ###
Login-AzAccount

# ALTERE O NOME DA SUBSCRIPTION
$subcriptionName = "Microsoft Azure Sponsorship"
$resourceGroupName = "bigdatargn"

# Set subscription 
Set-AzContext -SubscriptionName $subcriptionName -Force

# Remove environment
Remove-azResourceGroup -Name $resourceGroupName -Force