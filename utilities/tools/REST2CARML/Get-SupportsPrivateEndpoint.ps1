<#
.SYNOPSIS
Check if the given service specification references Private Endpoint

.DESCRIPTION
Check if the given service specification references Private Endpoint

.PARAMETER SpecificationFilePath
Mandatory. The file path to the service specification to check

.EXAMPLE
Get-SupportsPrivateEndpoint -SpecificationFilePath './resource-manager/Microsoft.KeyVault/stable/2022-07-01/keyvault.json'

Check the Key Vault service specification for any Private Endpoint references
#>
function Get-SupportsPrivateEndpoint {

    [CmdletBinding()]
    [OutputType('System.Boolean')]
    param (
        [Parameter(Mandatory = $true)]
        [string] $SpecificationFilePath
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)
    }

    process {

        $specContent = Get-Content -Path $SpecificationFilePath -Raw | ConvertFrom-Json -AsHashtable

        $relevantPaths = $specContent.paths.Keys | Where-Object {
            ($_ -replace '\\', '/') -like '*/privateLinkResources*' -or
            ($_ -replace '\\', '/') -like '*/privateEndpointConnections*'
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
