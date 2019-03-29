<### --------------------------- ###
    Create Database Environment
#>## --------------------------- ###

### Login to Azure Account ###
Login-AzAccount

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