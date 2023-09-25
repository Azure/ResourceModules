<#
.SYNOPSIS
Populate the provided ModuleData with all parameters, variables & resources required for private endpoints.

.DESCRIPTION
Populate the provided ModuleData with all parameters, variables & resources required for private endpoints.

.PARAMETER ResourceType
Mandatory. The resource type to check if private endpoints are supported.

.PARAMETER ModuleData
Mandatory. The ModuleData object to populate.

.EXAMPLE
Set-PrivateEndpointModuleData -ResourceType 'vaults' -ModuleData @{ parameters = @(...); resources = @(...); (...) }

Add the private endpoint module data of the resource type [vaults] to the provided module data object
#>
function Set-PrivateEndpointModuleData {

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
        if ($ModuleData.additionalParameters -is [hashtable]) {
            $ModuleData.additionalParameters = @($ModuleData.additionalParameters)
        }
        if ($ModuleData.modules -is [hashtable]) {
            $ModuleData.modules = @($ModuleData.modules)
        }

        # Built result
        $ModuleData.additionalParameters += @(
            @{
                name        = 'privateEndpoints'
                type        = 'array'
                description = 'Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.'
                required    = $false
                default     = @()
            }
        )

        $ModuleData.modules += @{
            name    = "$($resourceTypeSingular)_privateEndpoints"
            content = @(
                "module $($resourceTypeSingular)_privateEndpoints '../../Microsoft.Network/privateEndpoints/deploy.bicep' = [for (privateEndpoint,index) in privateEndpoints: {"
                "  name: '`${uniqueString(deployment().name, location)}-$resourceTypeSingular-PrivateEndpoint-`${index}'"
                '  params: {'
                '    groupIds: ['
                '      privateEndpoint.service'
                '    ]'
                "    name: contains(privateEndpoint,'name') ? privateEndpoint.name : 'pe-`${last(split($resourceTypeSingular.id, '/'))}-`${privateEndpoint.service}-`${index}'"
                '    serviceResourceId: {0}.id' -f $resourceTypeSingular
                '    subnetResourceId: privateEndpoint.subnetResourceId'
                '    enableDefaultTelemetry: enableReferencedModulesTelemetry'
                "    location: reference(split(privateEndpoint.subnetResourceId,'/subnets/')[0], '2020-06-01', 'Full').location"
                "    lock: contains(privateEndpoint,'lock') ? privateEndpoint.lock : lock"
                "    privateDnsZoneGroup: contains(privateEndpoint,'privateDnsZoneGroup') ? privateEndpoint.privateDnsZoneGroup : {}"
                "    roleAssignments: contains(privateEndpoint,'roleAssignments') ? privateEndpoint.roleAssignments : []"
                "    tags: contains(privateEndpoint,'tags') ? privateEndpoint.tags : {}"
                "    manualPrivateLinkServiceConnections: contains(privateEndpoint,'manualPrivateLinkServiceConnections') ? privateEndpoint.manualPrivateLinkServiceConnections : []"
                "    customDnsConfigs: contains(privateEndpoint,'customDnsConfigs') ? privateEndpoint.customDnsConfigs : []"
                '  }'
                '}]'
                ''
            )
        }
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}

