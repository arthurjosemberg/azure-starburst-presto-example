<### -------------------------- ###
    Create HDInsight Environment 
#>## -------------------------- ###

### Login to Azure Account ###
#Login-AzAccount 

Get-Date -Format o

# ALTERE O NOME DA SUBSCRIPTION
$subcriptionName = "Microsoft Azure Sponsorship"

# ALTERE O DIRETORIO ONDE OS ARQUIVOS IRÃO FICAR
$configurationFilesDirectory = "/Users/arthurluz/OneDrive/personal_studies/azure_hdinsight"

### Create Variables ###
$resourceGroupName = "bigdatargn"
$templateFile = "$configurationFilesDirectory/template_create_hdinsight_with_presto/template.json"
$templateParameterFile = "$configurationFilesDirectory/template_create_hdinsight_with_presto/parametersFile.json"

# Set subscription 
Set-AzContext -SubscriptionName $subcriptionName -Force

# Create a resource group
New-AzResourceGroup -Name $resourceGroupName -Location $location -Force

# Create HDInsight Cluster with Starburst Presto Application 
New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName `
                              -TemplateFile $templateFile `
                              -TemplateParameterFile $templateParameterFile