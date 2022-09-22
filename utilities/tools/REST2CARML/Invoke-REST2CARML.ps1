<#
.SYNOPSIS
Create/Update a CARML module based on the latest API information available

.DESCRIPTION
Create/Update a CARML module based on the latest API information available.
NOTE: As we query some data from Azure, you must be connected to an Azure Context to use this function

.PARAMETER ProviderNamespace
Mandatory. The provider namespace to query the data for

.PARAMETER ResourceType
Mandatory. The resource type to query the data for

.PARAMETER IncludePreview
Mandatory. Include preview API versions

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
        [string] $ResourceType,

        [Parameter(Mandatory = $false)]
        [switch] $IncludePreview
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)

        # Load used functions
        . (Join-Path $PSScriptRoot 'Get-ServiceSpecPathData.ps1')
        . (Join-Path $PSScriptRoot 'Resolve-ModuleData.ps1')
        . (Join-Path $PSScriptRoot 'Set-ModuleFileStructure.ps1')
        . (Join-Path $PSScriptRoot 'Set-Module.ps1')

        Write-Verbose ('Processing module [{0}/{1}]' -f $ProviderNamespace, $ResourceType) -Verbose
    }

    process {

        ###########################
        ##   Fetch module data   ##
        ###########################
        $getPathDataInputObject = @{
            ProviderNamespace = $ProviderNamespace
            ResourceType      = $ResourceType
            IncludePreview    = $IncludePreview
        }
        $pathData = Get-ServiceSpecPathData @getPathDataInputObject
        $moduleData = Resolve-ModuleData -JSONFilePath $pathData.jsonFilePath -JSONKeyPath $pathData.jsonKeyPath

        ###########################################
        ##   Generate initial module structure   ##
        ###########################################
        if ($PSCmdlet.ShouldProcess(('Module [{0}/{1}] structure' -f $ProviderNamespace, $ResourceType), 'Create/Update')) {
            Set-ModuleFileStructure -ProviderNamespace $ProviderNamespace -ResourceType $ResourceType
        }

        ############################
        ##   Set module content   ##
        ############################
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
