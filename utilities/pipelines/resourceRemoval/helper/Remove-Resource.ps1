<#
.SYNOPSIS
Remove a specific resource

.DESCRIPTION
Remove a specific resource. Tries to handle different resource types accordingly

.PARAMETER resourceId
Mandatory. The resourceID of the resource to remove

.PARAMETER name
Mandatory. The name of the resource to remove

.PARAMETER type
Mandatory. The type of the resource to remove

.EXAMPLE
Remove-Resource -name 'sxx-vm-linux-001-nic-01-diagnosticSettings' -type 'Microsoft.Insights/diagnosticSettings' -resourceId '/subscriptions/a7439831-1cd9-435d-a091-4aa863c96556/resourceGroups/validation-rg/providers/Microsoft.Network/networkInterfaces/sxx-vm-linux-001-nic-01/providers/Microsoft.Insights/diagnosticSettings/sxx-vm-linux-001-nic-01-diagnosticSettings'

Remove the resource 'sxx-vm-linux-001-nic-01-diagnosticSettings' of type 'Microsoft.Insights/diagnosticSettings' from resource '/subscriptions/a7439831-1cd9-435d-a091-4aa863c96556/resourceGroups/validation-rg/providers/Microsoft.Network/networkInterfaces/sxx-vm-linux-001-nic-01'
#>
function Remove-Resource {

    [CmdletBinding()]
    param (
        [Parameter()]
        [string] $resourceId,

        [Parameter()]
        [string] $name,

        [Parameter()]
        [string] $type
    )

    switch ($type) {
        'Microsoft.Insights/diagnosticSettings' {
            $parentResourceId = $resourceId.Split('/providers/{0}' -f $type)[0]
            $null = Remove-AzDiagnosticSetting -ResourceId $parentResourceId -Name $name
            break
        }
        Default {
            $null = Remove-AzResource -ResourceId $resourceId -Force -ErrorAction 'Stop'
        }
    }
}
