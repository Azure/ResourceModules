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
        . (Join-Path $PSScriptRoot 'Get-ModuleData.ps1')
        . (Join-Path $PSScriptRoot 'Set-ModuleFileStructure.ps1')

        Write-Verbose ('Processing module [{0}/{1}]' -f $ProviderNamespace, $ResourceType) -Verbose
    }

    process {
        # TODO: Invoke function to fetch module data
        # $moduleData = Get-ModuleData -ProviderNamespace $ProviderNamespace -ResourceType $ResourceType

        if ($PSCmdlet.ShouldProcess(('Module [{0}/{1}] structure' -f $ProviderNamespace, $ResourceType), 'Create/Update')) {
            Set-ModuleFileStructure -ProviderNamespace $ProviderNamespace -ResourceType $ResourceType
        }

        if ($PSCmdlet.ShouldProcess(('Module [{0}/{1}] files' -f $ProviderNamespace, $ResourceType), 'Create/Update')) {
            # TODO: Invoke function to fill module files with module data
        }
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}

Invoke-REST2CARML -ProviderNamespace 'Microsoft.Storage' -ResourceType 'customStorage' -Verbose
