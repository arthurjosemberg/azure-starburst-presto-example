<### --------------------------- ###
    Create Cosmos DB Environment
#>## --------------------------- ###

### Install Module ###
#Install-Module -Name CosmosDB
#Import-Module -Name CosmosDB

### Login to Azure Account ###
#Login-AzAccount

# ALTERE O NOME DA SUBSCRIPTION
$subcriptionName = "Microsoft Azure Sponsorship"

# ALTERE O DIRETORIO ONDE OS ARQUIVOS IRÃO FICAR
$configurationFilesDirectory = "/Users/arthurluz/OneDrive/personal_studies/azure_hdinsight"

$resourceGroupName = "bigdatargn"
$databaseName = "adventureworks"
$cosmosdbAccountName = "dataslightcdb"
$location = "West US"
$templateFile = "$configurationFilesDirectory/template_api_mongodb_cosmos_db/template.json"
$templateParameterFile = "$configurationFilesDirectory/template_api_mongodb_cosmos_db/parametersFile.json"

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