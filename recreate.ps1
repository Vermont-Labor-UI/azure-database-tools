function Clear-Database {
    param(
        [Parameter(Mandatory=$true)][string]$resourceGroup,
        [Parameter(Mandatory=$true)][string]$databaseServer,
        [Parameter(Mandatory=$true)][string]$databaseName,
        [Parameter][string]$elasticPoolName
    )

    Write-Host "Starting to recrate database: $databaseName on server $databaseServer"
    $database = Get-AzureRmSqlDatabase  -ResourceGroupName $resourceGroup `
        -ServerName $databaseServer `
        -DatabaseName $databaseName `

    if (-Not $database.ElasticPoolName) {
        Write-Host "Cannot detect current ElasticPool name falling back to parameter"
        if (-Not $elasticPoolName) {
            
        }
    }
    Remove-AzureRmSqlDatabase -ResourceGroupName $resourceGroup `
        -ServerName $databaseServer `
        -DatabaseName $databaseName

    New-AzureRmSqlDatabase -ResourceGroupName $resourceGroup `
        -ServerName $databaseServer `
        -DatabaseName $databaseName `
        -ElasticPoolName $database.ElasticPoolName
}
