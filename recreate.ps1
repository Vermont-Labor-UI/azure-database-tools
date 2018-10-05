param(
    [Parameter(Mandatory = $true)][string]$resourceGroup,
    [Parameter(Mandatory = $true)][string]$databaseServer,
    [Parameter(Mandatory = $true)][string]$databaseName,
    [Parameter(Mandatory = $true)][string]$dacpacFilePath,
    [Parameter(Mandatory = $false)][Boolean]$skipRecreate
)

Write-Host "Looking for file $dacpacFilePath"
if ([System.IO.File]::Exists($dacpacFilePath) -eq $false) {
    Write-Host "File $dacpacFilePath not found, aborting"
    exit 1
}

Write-Host "Starting to recrate database: $databaseName on server $databaseServer"
$database = Get-AzureRmSqlDatabase  -ResourceGroupName $resourceGroup `
    -ServerName $databaseServer `
    -DatabaseName $databaseName `

if (-Not $database.ElasticPoolName) {
    Write-Host "Cannot detect ElasticPool failing build"
    exit 1
}

if ($PSBoundParameters.ContainsKey('skipRecreate')) {
    if ($skipRecreate) {
        Write-Host "Skipping recreate due to presence of flag"
        exit 0
    }
}

Write-Host "Removing database: $databaseName on server $databaseServer"
$removeResult = Remove-AzureRmSqlDatabase -ResourceGroupName $resourceGroup `
    -ServerName $databaseServer `
    -DatabaseName $databaseName
Write-Host ($removeResult | Format-List | Out-String)

Write-Host "Creating database: $databaseName on server $databaseServer"
try {
    $newResult = New-AzureRmSqlDatabase -ResourceGroupName $resourceGroup `
        -ServerName $databaseServer `
        -DatabaseName $databaseName `
        -ElasticPoolName $database.ElasticPoolName
    Write-Host ($newResult | Format-List | Out-String)
}
catch {
    Write-Host 'We Caught  '  + $_.Exception.GetType().FullName -fore blue -back white
    Write-Host ($_.Exception | Format-List | Out-String)
}