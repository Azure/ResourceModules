<#
.SYNOPSIS
Check if the given service specification supports resource locks

.DESCRIPTION
Check if the given service specification supports resource locks

.PARAMETER JSONKeyPath
Mandatory. The file path to the service specification to check

.PARAMETER ProvidersToIgnore
Optional. Providers to ignore because they fundamentally don't support locks (e.g. 'Microsoft.Authorization')

.EXAMPLE
Get-SupportsLock -JSONKeyPath '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}'

Check if the storage service supports locks.
#>
function Get-SupportsLock {

    [CmdletBinding()]
    [OutputType('System.Boolean')]
    param (
        [Parameter(Mandatory = $true)]
        [string] $JSONKeyPath,

        [Parameter(Mandatory = $false)]
        [array] $ProvidersToIgnore = @('Microsoft.Authorization')
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)
    }

    process {

        # If the Specification URI contains any of the namespaces to ignore, no Lock is supported
        foreach ($ProviderToIgnore in $ProvidersToIgnore) {
            if ($JSONKeyPath.Contains($ProviderToIgnore)) {
                return $false
            }
        }

        return ($JSONKeyPath -split '\/').Count -le 9
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
