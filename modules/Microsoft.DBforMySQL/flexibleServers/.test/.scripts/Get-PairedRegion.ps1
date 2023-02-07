param(
    [string] $Location
)

Start-Sleep -Seconds 30

$PairedRegionName = Get-AzLocation |
    Where-Object -FilterScript { $PSItem.Location -eq $Location -or $PSItem.DisplayName -eq $Location } |
    Select-Object -ExpandProperty PairedRegion |
    Select-Object -ExpandProperty Name

# Write into Deployment Script output stream
$DeploymentScriptOutputs = @{
    pairedRegionName = $PairedRegionName
}
