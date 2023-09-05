<#
.SYNOPSIS
Publish a new version of a given module to a template spec

.DESCRIPTION
Publish a new version of a given module to a template spec
The template spec is set up if not already existing.

.PARAMETER TemplateFilePath
Mandatory. Path to the module deployment file from root.
Example: 'C:\modules\key-vault\vault\main.bicep'

.PARAMETER ModuleVersion
Mandatory. Version of the module to publish, following SemVer convention.
Example: '1.0.0', '2.1.5-alpha.1', '0.0.5-beta.1'

.PARAMETER TemplateSpecsRgName
Mandatory. ResourceGroup of the template spec to publish to.
Example: 'artifacts-rg'

.PARAMETER TemplateSpecsRgLocation
Mandatory. Location of the template spec resource group.
Example: 'West Europe'

.PARAMETER TemplateSpecsDescription
Mandatory. The description of the parent template spec.
Example: 'iacs key vault'

.PARAMETER UseApiSpecsAlignedName
Optional. If set to true, the module will be published with a name that is aligned with the Azure API naming. If not, one aligned with the module's folder path. See the following examples:
- True:  microsoft.keyvault.vaults.secrets
- False: key-vault.vault.secret

.EXAMPLE
Publish-ModuleToTemplateSpecsRG -TemplateFilePath 'C:\modules\key-vault\vault\main.bicep' -ModuleVersion '3.0.0-alpha' -TemplateSpecsRgName 'artifacts-rg' -TemplateSpecsRgLocation 'West Europe' -TemplateSpecsDescription 'iacs key vault'

Try to publish the KeyVault module with version 3.0.0-alpha to a template spec in resource group 'artifacts-rg'.
#>
function Publish-ModuleToTemplateSpecsRG {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string] $TemplateFilePath,

        [Parameter(Mandatory)]
        [string] $ModuleVersion,

        [Parameter(Mandatory)]
        [string] $TemplateSpecsRgName,

        [Parameter(Mandatory)]
        [string] $TemplateSpecsRgLocation,

        [Parameter(Mandatory)]
        [string] $TemplateSpecsDescription,

        [Parameter(Mandatory = $false)]
        [bool] $UseApiSpecsAlignedName = $false
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)

        # Load helper functions
        . (Join-Path $PSScriptRoot 'Get-TemplateSpecsName.ps1')
    }

    process {
        #############################
        ##    EVALUATE RESOURCES   ##
        #############################
        if (-not (Get-AzResourceGroup -Name $TemplateSpecsRgName -ErrorAction 'SilentlyContinue')) {
            if ($PSCmdlet.ShouldProcess("Resource group [$TemplateSpecsRgName] to location [$TemplateSpecsRgLocation]", 'Deploy')) {
                New-AzResourceGroup -Name $TemplateSpecsRgName -Location $TemplateSpecsRgLocation
            }
        }

        # Get a valid Template Specs name
        $templateSpecIdentifier = Get-TemplateSpecsName -TemplateFilePath $TemplateFilePath -UseApiSpecsAlignedName $UseApiSpecsAlignedName

        ################################
        ##    Create template spec    ##
        ################################
        if ($PSCmdlet.ShouldProcess("Template spec [$templateSpecIdentifier] version [$ModuleVersion]", 'Publish')) {
            $templateSpecInputObject = @{
                ResourceGroupName = $TemplateSpecsRgName
                Name              = $templateSpecIdentifier
                Version           = $ModuleVersion
                Description       = $TemplateSpecsDescription
                Location          = $TemplateSpecsRgLocation
                TemplateFile      = $TemplateFilePath
            }
            New-AzTemplateSpec @templateSpecInputObject -Force
        }
        Write-Verbose 'Publish complete'
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
