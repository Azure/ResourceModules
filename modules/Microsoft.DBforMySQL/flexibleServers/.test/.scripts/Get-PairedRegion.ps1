param(
    [string] $Location
)

Start-Sleep -Seconds 20

$PairedRegionName = Get-AzLocation | Where-Object -Property Location -EQ $Location | Select-Object -expand PairedRegion |
    Select-Object -ExpandProperty name

# Write into Deployment Script output stream
$DeploymentScriptOutputs = @{
    pairedRegionName = $PairedRegionName
}
