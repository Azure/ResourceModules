<#
.SYNOPSIS
Fetch all available Role Definitions for the given ProviderNamespace

.DESCRIPTION
Fetch all available Role Definitions for the given ProviderNamespace
Leverges Microsoft Docs's [https://learn.microsoft.com/en-us/powershell/module/az.resources/get-azroledefinition?view=azps-8.3.0] to fetch the data

.PARAMETER ProviderNamespace
Optional. The Provider Namespace to fetch the role definitions for

.PARAMETER ResourceType
Optional. The ResourceType to fetch the role definitions for

.PARAMETER IncludeCustomRoles
Optional. Whether to include custom roles or not

.EXAMPLE
Get-RoleAssignmentList -ProviderNamespace 'Microsoft.KeyVault' -ResourceType 'vaults'

Fetch all available Role Definitions for ProviderNamespace [Microsoft.KeyVault/vaults], excluding custom roles
#>
function Get-RoleAssignmentList {

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
        ##  Get Roles  ##
        #################
        $roleDefinitions = Get-AzRoleDefinition

        # Filter Custom Roles
        if (-not $IncludeCustomRoles) {
            $roleDefinitions = $roleDefinitions | Where-Object { -not $_.IsCustom }
        }

        $relevantRoles = [System.Collections.ArrayList]@()

        # No role filtering for the [Microsoft.Authorization/RoleAssignments] module
        # selecting only relevant roles for all other modules
        if ("$ProviderNamespace/$ResourceType" -eq 'Microsoft.Authorization/RoleAssignments') {
            # No filter
            $relevantRoles = $roleDefinitions
        } else {
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
        }

        # (Bicep-only) To comply with Bicep Linter Rule prefer-unquoted-property-names, remove quotes from role names not containing spaces
        $resBicep = [System.Collections.ArrayList]@()
        $resArm = [System.Collections.ArrayList]@()
        if ("$ProviderNamespace/$ResourceType" -ne 'Microsoft.Authorization/RoleAssignments') {
            foreach ($role in $relevantRoles | Sort-Object -Property 'Name' -Unique) {
                if ($role.Name -match '\s') {
                    $resBicep += "'{0}': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '{1}')" -f $role.Name, $role.Id
                } else {
                    $resBicep += "{0}: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '{1}')" -f $role.Name, $role.Id
                }
                $resArm += "`"{0}`": `"[subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '{1}')]`"," -f $role.Name, $role.Id
            }
        } else {
            # different output format for the 'Microsoft.Authorization/RoleAssignments' module
            foreach ($role in $relevantRoles | Sort-Object -Property 'Name' -Unique) {
                if ($role.Name -match '\s') {
                    $resBicep += "'{0}': '/providers/Microsoft.Authorization/roleDefinitions/{1}'" -f $role.Name, $role.Id
                } else {
                    $resBicep += "{0}: '/providers/Microsoft.Authorization/roleDefinitions/{1}'" -f $role.Name, $role.Id
                }
                $resArm += "`"{0}`": `"/providers/Microsoft.Authorization/roleDefinitions/{1}`"" -f $role.Name, $role.Id
            }
        }

        # Return arrays
        return @{
            bicepFormat = $resBicep
            armFormat   = $resArm
        }
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
