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

.PARAMETER IncludeCustomRoles
Optional. Whether to include custom roles or not

.EXAMPLE
Get-RoleAssignmentsList -ProviderNamespace 'Microsoft.KeyVault' -ResourceType 'vaults'

Fetch all available Role Definitions for ProviderNamespace [Microsoft.KeyVault/vaults], excluding custom roles
#>
function Get-RoleAssignmentsList {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [string] $ProviderNamespace,

        [Parameter(Mandatory = $false)]
        [string] $ResourceType,

        [Parameter(Mandatory = $false)]
        [switch] $IncludeCustomRoles
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)
    }

    process {

        #################
        ##   Get Roles ##
        #################
        $roleDefinitions = Get-AzRoleDefinition

        # Filter Custom Roles
        if (-not $IncludeCustomRoles) {
            $roleDefinitions = $roleDefinitions | Where-Object { -not $_.IsCustom }
        }

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
        $resArm = [System.Collections.ArrayList]@()
        foreach ($role in $relevantRoles | Sort-Object -Property 'Name' -Unique) {
            $resBicep += "'{0}': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','{1}')" -f $role.Name, $role.Id
            $resArm += "`"{0}`": `"[subscriptionResourceId('Microsoft.Authorization/roleDefinitions','{1}')]`"," -f $role.Name, $role.Id
        }

        return @{
            bicepFormat = $resBicep
            armFormat   = $resArm
        }
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
