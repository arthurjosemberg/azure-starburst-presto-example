<### -------------------------- ###
    Create HDInsight Environment 
#>## -------------------------- ###

### Login to Azure Account ###
Login-AzAccount 

### Create Variables ###
$subcriptionName = "Microsoft Azure Sponsorship"
$resourceGroupName = "bigdatargn"
$templateFile = "/Users/arthurluz/OneDrive/personal_studies/azure_hdinsight/template_create_hdinsight_with_presto/template.json"
$templateParameterFile = "/Users/arthurluz/OneDrive/personal_studies/azure_hdinsight/template_create_hdinsight_with_presto/parametersFile.json"

# Set subscription 
Set-AzContext -SubscriptionName $subcriptionName -Force

# Create a resource group
New-AzResourceGroup -Name $resourceGroupName -Location $location -Force

# Create HDInsight Cluster with Starburst Presto Application 
New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName `
                              -TemplateFile $templateFile `
                              -TemplateParameterFile $templateParameterFile