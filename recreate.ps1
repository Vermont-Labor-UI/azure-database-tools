param(
    [Parameter(Mandatory=$true)][string]$resourceGroup,
    [Parameter(Mandatory=$true)][string]$databaseServer,
    [Parameter(Mandatory=$true)][string]$databaseName,
    [Parameter(Mandatory=$false)][string]$dacpacFilePath
)

if ($PSBoundParameters.ContainsKey('dacpacFilePath')){
    Write-Host "Looking for file $dacpacFilePath"
    if ([System.IO.File]::Exists($dacpacFilePath) -eq $false){
        Write-Host "File $dacpacFilePath not found, aborting"
        exit 1
    }
}

Write-Host "Starting to recrate database: $databaseName on server $databaseServer"
$database = Get-AzureRmSqlDatabase  -ResourceGroupName $resourceGroup `
    -ServerName $databaseServer `
    -DatabaseName $databaseName `

if (-Not $database.ElasticPoolName) {
    Write-Host "Cannot detect ElasticPool failing build"
    exit 1
}

Write-Host "Removing database: $databaseName on server $databaseServer"

Remove-AzureRmSqlDatabase -ResourceGroupName $resourceGroup `
    -ServerName $databaseServer `
    -DatabaseName $databaseName

Write-Host "Creating database: $databaseName on server $databaseServer"

New-AzureRmSqlDatabase -ResourceGroupName $resourceGroup `
    -ServerName $databaseServer `
    -DatabaseName $databaseName `
    -ElasticPoolName $database.ElasticPoolName