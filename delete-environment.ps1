<### -------------------- ###
    Remove all Environment 
#>## -------------------- ###

# ALTERE O NOME DA SUBSCRIPTION
$subcriptionName = "Microsoft Azure Sponsorship"
$resourceGroupName = "bigdatargn"

# Set subscription 
Set-AzContext -SubscriptionName $subcriptionName -Force

# Remove environment
Remove-azResourceGroup -Name $resourceGroupName -Force