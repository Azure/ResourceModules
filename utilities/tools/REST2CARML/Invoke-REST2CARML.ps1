<#
.SYNOPSIS
Create/Update a CARML module based on the latest API information available

.DESCRIPTION
Create/Update a CARML module based on the latest API information available

.PARAMETER ProviderNamespace
Mandatory. The provider namespace to query the data for

.PARAMETER ResourceType
Mandatory. The resource type to query the data for

.EXAMPLE
Invoke-REST2CARML -ProviderNamespace 'Microsoft.Keyvault' -ResourceType 'vaults'

Generate/Update a CARML module for [Microsoft.Keyvault/vaults]
#>
function Invoke-REST2CARML {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [string] $ProviderNamespace,

        [Parameter(Mandatory = $true)]
        [string] $ResourceType
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)

        # Load used functions
        # . (Join-Path $PSScriptRoot 'Get-ModuleData.ps1')
        . (Join-Path $PSScriptRoot 'Set-ModuleFileStructure.ps1')
        . (Join-Path $PSScriptRoot 'Set-Module.ps1')

        Write-Verbose ('Processing module [{0}/{1}]' -f $ProviderNamespace, $ResourceType) -Verbose
    }

    process {
        # TODO: Invoke function to fetch module data
        $pathData = @{
            jsonFilePath = '(...)\azure-rest-api-specs\azure-rest-api-specs\specification\storage\resource-manager\Microsoft.Storage\stable\2022-05-01\storage.json'
            jsonKeyPath  = '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}' # PUT path
        }

        # $moduleData = Resolve-ModuleData -PathData $pathData
        $moduleData = @{
            parameters = @(
                @{
                    level         = 0
                    name          = 'sku'
                    type          = 'object'
                    description   = '...'
                    allowedValues = @('')
                    required      = $false
                    default       = ''
                }
                @{
                    level       = 1
                    name        = 'firewallEnabled'
                    type        = 'boolean'
                    description = '...'
                }
            )
        }

        if ($PSCmdlet.ShouldProcess(('Module [{0}/{1}] structure' -f $ProviderNamespace, $ResourceType), 'Create/Update')) {
            Set-ModuleFileStructure -ProviderNamespace $ProviderNamespace -ResourceType $ResourceType
        }

        $moduleTemplateInputObject = @{
            ProviderNamespace     = $ProviderNamespace
            ResourceType          = $ResourceType
            SpecificationFilePath = $pathData.jsonFilePath
            SpecificationUrl      = $pathData.jsonKeyPath
            ModuleData            = $moduleData
        }
        if ($PSCmdlet.ShouldProcess(('Module [{0}/{1}] files' -f $ProviderNamespace, $ResourceType), 'Create/Update')) {
            Set-Module @moduleTemplateInputObject
        }
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}

Invoke-REST2CARML -ProviderNamespace 'Microsoft.Storage' -ResourceType 'storageAccounts' -Verbose
