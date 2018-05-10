param(
    [Parameter(Mandatory=$true)][string]$resourceGroup,
    [Parameter(Mandatory=$true)][string]$databaseServer,
    [Parameter(Mandatory=$true)][string]$databaseName
)

Write-Host "Starting to recrate database: $databaseName on server $databaseServer"
$database = Get-AzureRmSqlDatabase  -ResourceGroupName $resourceGroup `
    -ServerName $databaseServer `
    -DatabaseName $databaseName `

if (-Not $database.ElasticPoolName) {
    Write-Host "Cannot detect ElasticPool failing build"
    exit 1
}
Remove-AzureRmSqlDatabase -ResourceGroupName $resourceGroup `
    -ServerName $databaseServer `
    -DatabaseName $databaseName

New-AzureRmSqlDatabase -ResourceGroupName $resourceGroup `
    -ServerName $databaseServer `
    -DatabaseName $databaseName `
    -ElasticPoolName $database.ElasticPoolName