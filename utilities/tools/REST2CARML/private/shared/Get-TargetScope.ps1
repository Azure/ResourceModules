<#
.SYNOPSIS
Get the target scope (bicep) of a given key path.

.DESCRIPTION
Get the target scope (bicep) of a given key path. For example 'resourceGroup'.

.PARAMETER UrlPath
Mandatory. The key path to check for its scope.

.EXAMPLE
Get-TargetScope -UrlPath 'subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.KeyVault/vaults/{vaultName}'

Check the given KeyPath for its scope. Would return 'resourceGroup'.
#>
function Get-TargetScope {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $UrlPath
    )

    switch ($UrlPath) {
        { $PSItem -like '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/*' } { return 'resourceGroup' }
        { $PSItem -like '/subscriptions/{subscriptionId}/*' } { return 'subscription' }
        { $PSItem -like '/providers/Microsoft.Management/managementGroups/*' } { return 'managementGroup' }
        Default {
            throw 'Unable to detect target scope'
        }
    }
}
