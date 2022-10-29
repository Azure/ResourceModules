<#
.SYNOPSIS
Check if the given service specification supports private endpoints

.DESCRIPTION
Check if the given service specification supports private endpoints

.PARAMETER UrlPath
Mandatory. The JSON key path (of the API Specs) to use when determining if private endpoints are supported or not

.PARAMETER JSONFilePath
Mandatory. The file path to the service specification to check

.EXAMPLE
Get-SupportsPrivateEndpoint -JSONFilePath './resource-manager/Microsoft.KeyVault/stable/2022-07-01/keyvault.json' -UrlPath '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}'

Check the Key Vault service specification for any Private Endpoint references
#>
function Get-SupportsPrivateEndpoint {

    [CmdletBinding()]
    [OutputType('System.Boolean')]
    param (
        [Parameter(Mandatory = $true)]
        [string] $UrlPath,

        [Parameter(Mandatory = $true)]
        [string] $JSONFilePath
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)
    }

    process {
        $specContent = Get-Content -Path $JSONFilePath -Raw | ConvertFrom-Json -AsHashtable

        # Only consider those paths that
        # - contain a reference to private links
        # - and in that link reference a resource type (e.g. 'Microsoft.Storage/storageAccounts/privateLink/*')
        $relevantPaths = $specContent.paths.Keys | Where-Object {
            (($_ -replace '\\', '/') -like '*/privateLinkResources*' -or
            ($_ -replace '\\', '/') -like '*/privateEndpointConnections*') -and
            $_ -like "$UrlPath/*" -and
            $_ -ne $UrlPath
        } | Where-Object {
            $specContent.paths[$_].keys -contains 'put'
        }

        if ($relevantPaths.Count -gt 0) {
            return $true
        }

        return $false
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
