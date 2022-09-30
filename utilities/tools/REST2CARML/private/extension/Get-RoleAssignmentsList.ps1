<#
.SYNOPSIS
Fetch all available Role Definitions for the given ProviderNamespace

.DESCRIPTION
Fetch all available Role Definitions for the given ProviderNamespace
Leverges Microsoft Docs's [https://learn.microsoft.com/en-us/powershell/module/az.resources/get-azroledefinition?view=azps-8.3.0] to fetch the data

.PARAMETER ProviderNamespace
Mandatory. The Provider Namespace to fetch the role definitions for

.PARAMETER ResourceType
Mandatory. The ResourceType to fetch the role definitions for

.EXAMPLE
Get-RoleAssignmentsList -ProviderNamespace 'Microsoft.KeyVault' -ResourceType 'vaults'

Fetch all available Role Definitions for ProviderNamespace [Microsoft.KeyVault/vaults]
#>
function Get-RoleAssignmentsList {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $ProviderNamespace,

        [Parameter(Mandatory)]
        [string] $ResourceType
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)
    }

    process {

        #################
        ##   Get Roles ##
        #################
        $roles = Get-AzRoleDefinition

        # Filter Custom Roles
        $roleDefinitions = $roles | Where-Object { -not $_.IsCustom }

        $relevantRoles = [System.Collections.ArrayList]@()

        # Filter Action based
        $relevantRoles += $roleDefinitions | Where-Object {
            $_.Actions -like "$ProviderNamespace/$ResourceType/*" -or
            $_.Actions -like "$ProviderNamespace/`**" -or
            $_.Actions -like '`**'
        }

        # Filter Data Action based
        $relevantRoles += $roleDefinitions | Where-Object {
            $_.DataActions -like "$ProviderNamespace/$ResourceType/*" -or
            $_.DataActions -like "$ProviderNamespace/`**" -or
            $_.DataActions -like '`**'
        }

        $resBicep = [System.Collections.ArrayList]@()
        foreach ($role in $relevantRoles | Sort-Object -Property 'Name' -Unique) {
            $roleName = $role.Name
            $roleId = $role.Id
            $resBicep += "'$roleName': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '$roleId')"
        }

        return $resBicep
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
