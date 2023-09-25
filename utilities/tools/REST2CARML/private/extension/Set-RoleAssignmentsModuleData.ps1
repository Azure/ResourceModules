<#
.SYNOPSIS
Fetch all available roles for a given resource type, store the content of the the corresponding nested_roleAssignment.bicep file in the given 'additionalFiles' array of the provided module data object & add any additional required parameters, variables & resources to the provide module data object.

.DESCRIPTION
Fetch all available roles for a given resource type, store the content of the the corresponding nested_roleAssignment.bicep file in the given 'additionalFiles' array of the provided module data object & add any additional required parameters, variables & resources to the provide module data object.

.PARAMETER ProviderNamespace
Mandatory. The ProviderNamespace to fetch the available role options for.

.PARAMETER ResourceType
Mandatory. The ResourceType to fetch the available role options for.

.PARAMETER ServiceApiVersion
Mandatory. The API version of the module to generate the RBAC module file for

.PARAMETER ModuleData
Mandatory. The ModuleData object to populate.

.EXAMPLE
Set-RoleAssignmentsModuleData -ProviderNamespace 'Microsoft.KeyVault' -ResourceType 'vaults' -ServiceApiVersion '10-10-2022' -ModuleData @{ parameters = @(...); resources = @(...); (...) }

Generate the nested_roleAssignment.bicep file in the [Microsoft.KeyVault/vaults]'s module path and add any additional required data to the provided module data object.
#>
function Set-RoleAssignmentsModuleData {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [string] $ProviderNamespace,

        [Parameter(Mandatory = $true)]
        [object[]] $RelevantRoles = @(),

        [Parameter(Mandatory = $true)]
        [string] $ResourceType,

        [Parameter(Mandatory = $true)]
        [string] $ServiceApiVersion,

        [Parameter(Mandatory = $true)]
        [Hashtable] $ModuleData
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)
    }

    process {

        $resourceTypeSingular = ((Get-ResourceTypeSingularName -ResourceType $resourceType) -split '/')[-1]

        # Type check (in case PowerShell auto-converted the array to a hashtable)
        if ($ModuleData.modules -is [hashtable]) {
            $ModuleData.modules = @($ModuleData.modules)
        }
        if ($ModuleData.additionalFiles -is [hashtable]) {
            $ModuleData.additionalFiles = @($ModuleData.additionalFiles)
        }
        if ($ModuleData.additionalParameters -is [hashtable]) {
            $ModuleData.additionalParameters = @($ModuleData.additionalParameters)
        }

        # Tokens to replace in files
        $tokens = @{
            providerNamespace    = $ProviderNamespace
            resourceType         = $ResourceType
            resourceTypeSingular = $resourceTypeSingular
            apiVersion           = $ServiceApiVersion
        }

        # Format roles
        if ($RelevantRoles.count -eq 0) {
            return
        } else {
            $roleAssignmentList = [System.Collections.ArrayList]@()
            foreach ($role in $RelevantRoles | Sort-Object -Property 'Name' -Unique) {
                $roleAssignmentList += "{0}: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '{1}')" -f ($role.Name -match '\s+' ? ("'{0}'" -f $role.Name) : $role.Name), $role.Id
            }
        }

        $ModuleData.additionalParameters += @(
            @{
                name        = 'roleAssignments'
                type        = 'array'
                description = "Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'."
                required    = $false
                default     = @()
            }
        )

        $ModuleData.modules += @{
            name    = "$($resourceTypeSingular)_roleAssignments"
            content = @(
                "module $($resourceTypeSingular)_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment,index) in roleAssignments: {"
                "  name: '`${uniqueString(deployment().name, location)}-$resourceTypeSingular-Rbac-`${index}'"
                '  params: {'
                "    description: contains(roleAssignment,'description') ? roleAssignment.description : ''"
                '    principalIds: roleAssignment.principalIds'
                "    principalType: contains(roleAssignment,'principalType') ? roleAssignment.principalType : ''"
                '    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName'
                "    condition: contains(roleAssignment,'condition') ? roleAssignment.condition : ''"
                "    delegatedManagedIdentityResourceId: contains(roleAssignment,'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''"
                "    resourceId: $resourceTypeSingular.id"
                '  }'
                '}]'
                ''
            )
        }

        $fileContent = @()
        $rawContent = Get-Content -Path (Join-Path $script:src 'nested_roleAssignments.bicep') -Raw

        # Replace general tokens
        $fileContent = Set-TokenValuesInArray -Content $rawContent -Tokens $tokens

        # Add roles
        ## Split content into pre-roles & post-roles content
        $preRolesContent = ($fileContent -split '<<roleDefinitions>>')[0].Trim() -split '\n' | ForEach-Object { $_.TrimEnd() }
        $postRolesContent = ($fileContent -split '<<roleDefinitions>>')[1].Trim() -split '\n' | ForEach-Object { $_.TrimEnd() }
        ## Add roles
        $fileContent = $preRolesContent.TrimEnd() + ($roleAssignmentList | ForEach-Object { "  $_" }) + $postRolesContent

        # Set content
        $roleTemplateFilePath = Join-Path '.bicep' 'nested_roleAssignments.bicep'

        if ($PSCmdlet.ShouldProcess("RBAC data for file in path [$roleTemplateFilePath]", 'Set')) {
            $ModuleData.additionalFiles += @{
                type                    = 'roleAssignments'
                relativeFilePath        = $roleTemplateFilePath
                fileContent             = ($fileContent | Out-String).Trim()
                onlyRoleDefinitionIds   = $roleAssignmentList.onlyRoleDefinitionIds
                onlyRoleDefinitionNames = $roleAssignmentList.onlyRoleDefinitionNames
            }
        }
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}

