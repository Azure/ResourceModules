<#
.SYNOPSIS
Publish a new version of a given module to a template spec

.DESCRIPTION
Publish a new version of a given module to a template spec
The template spec is set up if not already existing.

.PARAMETER TemplateFilePath
Mandatory. Path to the module deployment file from root.

.PARAMETER TemplateSpecsRgName
Mandatory. ResourceGroup of the template spec to publish to.

.PARAMETER TemplateSpecsRgLocation
Mandatory. Location of the template spec resource group.

.PARAMETER TemplateSpecsDescription
Mandatory. The description of the parent template spec.

.PARAMETER ModuleVersion
Required. Version of the module to publish.

.EXAMPLE
Publish-ModuleToTemplateSpec -TemplateFilePath 'C:/KeyVault/deploy.json' -TemplateSpecsRgName 'artifacts-rg' -TemplateSpecsRgLocation 'West Europe' -TemplateSpecsDescription 'iacs key vault' -ModuleVersion '3.0.0-alpha'

Try to publish the KeyVault module with version 3.0.0 to a template spec called KeyVault based on a value provided in the UI
#>
function Publish-ModuleToTemplateSpec {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string] $TemplateFilePath,

        [Parameter(Mandatory)]
        [string] $TemplateSpecsRgName,

        [Parameter(Mandatory)]
        [string] $TemplateSpecsRgLocation,

        [Parameter(Mandatory)]
        [string] $TemplateSpecsDescription,

        [Parameter(Mandatory)]
        [string] $ModuleVersion
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)
    }

    process {
        $moduleIdentifier = (Split-Path $TemplateFilePath -Parent).Replace('\', '/').Split('/arm/')[1]
        $templateSpecIdentifier = $moduleIdentifier.Replace('\', '/').Replace('/', '.').ToLower()

        #############################
        ##    EVALUATE RESOURCES   ##
        #############################
        if (-not (Get-AzResourceGroup -Name $TemplateSpecsRgName -ErrorAction 'SilentlyContinue')) {
            if ($PSCmdlet.ShouldProcess("Resource group [$TemplateSpecsRgName] to location [$TemplateSpecsRgLocation]", 'Deploy')) {
                New-AzResourceGroup -Name $TemplateSpecsRgName -Location $TemplateSpecsRgLocation
            }
        }

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
