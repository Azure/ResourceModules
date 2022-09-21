<#
.SYNOPSIS
Fetch all available Role Definitions for the given ProviderNamespace

.DESCRIPTION
Fetch all available Role Definitions for the given ProviderNamespace
Leverges Microsoft Docs's [https://learn.microsoft.com/en-us/powershell/module/az.resources/get-azroledefinition?view=azps-8.3.0] to fetch the data

.PARAMETER ProviderNamespace
Mandatory. The Provider Namespace to fetch the role definitions

.EXAMPLE
Get-AzRoleDefinition | Where-Object { !$_.IsCustom -and ($_.Actions -match $ProviderNamespace -or $_.DataActions -match $ProviderNamespace -or $_.Actions -like '`**') } | Select-Object Name, Id | ConvertTo-Json | ConvertFrom-Json

Fetch all available Role Definitions for ProviderNamespace [Microsoft.KeyVault]
#>
function Get-RoleAssignmentsList {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $ProviderNamespace

    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)
    }

    process {

        #################
        ##   Get Roles ##
        #################
        $roleDefinitions = Get-AzRoleDefinition | Where-Object { !$_.IsCustom -and ($_.Actions -match $ProviderNamespace -or $_.DataActions -match $ProviderNamespace -or $_.Actions -like '`**') } | Select-Object Name, Id | ConvertTo-Json | ConvertFrom-Json
        $resBicep = [System.Collections.ArrayList]@()
        foreach ($role in $roleDefinitions) {
            $roleName = $role.Name
            $roleId = $role.Id
            $resBicep += "'$roleName':subscriptionResourceId('Microsoft.Authorization/roleDefinitions','$roleId')"

        }
        return $resBicep
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
