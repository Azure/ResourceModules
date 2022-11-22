<#
.SYNOPSIS
Populate the provided ModuleData with all parameters, variables & resources required for locks.

.DESCRIPTION
Populate the provided ModuleData with all parameters, variables & resources required for locks.

.PARAMETER ResourceType
Mandatory. The resource type to check if lock are supported.

.PARAMETER ModuleData
Mandatory. The ModuleData object to populate.

.EXAMPLE
Set-LockModuleData -ResourceType 'vaults' -ModuleData @{ parameters = @(...); resources = @(...); (...) }

Add the lock module data of the resource type [vaults] to the provided module data object
#>
function Set-LockModuleData {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $ResourceType,

        [Parameter(Mandatory = $true)]
        [Hashtable] $ModuleData
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)
    }

    process {

        $resourceTypeSingular = ((Get-ResourceTypeSingularName -ResourceType $resourceType) -split '/')[-1]

        # Type check (in case PowerShell auto-converted the array to a hashtable)
        if ($ModuleData.additionalFiles -is [hashtable]) {
            $ModuleData.additionalFiles = @($ModuleData.additionalFiles)
        }
        if ($ModuleData.resources -is [hashtable]) {
            $ModuleData.resources = @($ModuleData.resources)
        }

        $ModuleData.additionalParameters += @(
            @{
                name          = 'lock'
                type          = 'string'
                description   = 'Specify the type of lock.'
                required      = $false
                default       = ''
                allowedValues = @(
                    ''
                    'CanNotDelete'
                    'ReadOnly'
                )
            }
        )

        $ModuleData.resources += @{
            name    = "$($resourceTypeSingular)_lock"
            content = @(
                "resource $($resourceTypeSingular)_lock 'Microsoft.Authorization/locks@2017-04-01' = if (!empty(lock)) {"
                "  name: '`${$resourceTypeSingular.name}-`${lock}-lock'"
                '  properties: {'
                '    level: any(lock)'
                "    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'"
                '  }'
                '  scope: {0}' -f $resourceTypeSingular
                '}'
                ''
            )
        }
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}

