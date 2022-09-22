<#
.SYNOPSIS
Check if the given service specification supports resource locks

.DESCRIPTION
Check if the given service specification supports resource locks

.PARAMETER SpecificationUrl
Mandatory. The file path to the service specification to check

.PARAMETER ProvidersToIgnore
Optional. Providers to ignore because they fundamentally don't support locks (e.g. 'Microsoft.Authorization')

.EXAMPLE
Get-SupportsLock -SpecificationUrl '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}'

Check if the storage service supports locks.
#>
function Get-SupportsLock {

    [CmdletBinding()]
    [OutputType('System.Boolean')]
    param (
        [Parameter(Mandatory = $true)]
        [string] $SpecificationUrl,

        [Parameter(Mandatory = $false)]
        [array] $ProvidersToIgnore = @('Microsoft.Authorization')
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)
    }

    process {

        # If the Specification URI contains any of the namespaces to ignore, no Lock is supported
        foreach ($ProviderToIgnore in $ProvidersToIgnore) {
            if ($SpecificationUrl.Contains($ProviderToIgnore)) {
                return $false
            }
        }

        return ($SpecificationUrl -split '\/').Count -le 9
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
