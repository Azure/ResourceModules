param(
    [string] $Location
)

Start-Sleep -Seconds 20

$PairedRegionName = Get-AzLocation | Where-Object -Property Location -eq $Location |
    Select-Object -ExpandProperty PairedRegion -First 1 | Select-Object -ExpandProperty name

# Write into Deployment Script output stream
$DeploymentScriptOutputs = @{
    pairedRegionName = $PairedRegionName
}
