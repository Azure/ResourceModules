<#
.SYNOPSIS
Populate the provided ModuleData with all parameters, variables & resources required for locks.

.DESCRIPTION
Populate the provided ModuleData with all parameters, variables & resources required for locks.

.PARAMETER UrlPath
Mandatory. The JSON key path (of the API Specs) to use when determining if locks are supported or not

.PARAMETER ResourceType
Mandatory. The resource type to check if lock are supported.

.PARAMETER ModuleData
Mandatory. The ModuleData object to populate.

.EXAMPLE
Set-LockModuleData -UrlPath '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}' -ResourceType 'vaults' -ModuleData @{ parameters = @(...); resources = @(...); (...) }

Add the lock module data of the resource type [vaults] to the provided module data object
#>
function Set-LockModuleData {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $UrlPath,

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

        if (-not (Get-SupportsLock -UrlPath $UrlPath)) {
            return
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

