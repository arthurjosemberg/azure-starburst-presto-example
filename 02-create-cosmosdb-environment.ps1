<### --------------------------- ###
    Create Cosmos DB Environment
#>## --------------------------- ###

### Install Module ###
#Install-Module -Name CosmosDB
#Import-Module -Name CosmosDB

### Login to Azure Account ###
#Login-AzAccount

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