param(
    [string] $Location
)

# Sleep for role assignment propagation
Start-Sleep -Seconds 10

$PairedRegionName = Get-AzLocation |
    Where-Object { $Location -in @($PSItem.Location, $PSItem.DisplayName) } |
    Select-Object -ExpandProperty PairedRegion |
    Select-Object -ExpandProperty Name

# Write into Deployment Script output stream
$DeploymentScriptOutputs = @{
    pairedRegionName = $PairedRegionName
}
