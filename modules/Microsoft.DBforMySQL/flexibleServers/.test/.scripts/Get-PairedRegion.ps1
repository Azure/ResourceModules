param(
    [string] $Location
)

# Sleep for role assignment propagation
Start-Sleep -Seconds 10

$PairedRegionName = Get-AzLocation |
    Where-Object -FilterScript { $PSItem.Location -eq $Location -or $PSItem.DisplayName -eq $Location } |
    Select-Object -ExpandProperty PairedRegion |
    Select-Object -ExpandProperty Name

# Write into Deployment Script output stream
$DeploymentScriptOutputs = @{
    pairedRegionName = $PairedRegionName
}
