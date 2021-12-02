<#
.SYNOPSIS
Publish a new version of a given module to a template spec

.DESCRIPTION
Publish a new version of a given module to a template spec
The function will take evaluate which version should be published based on the provided input parameters (ModuleVersion, versioningOption) and the version currently deployed to the template spec
If the customVersion is higher than the current latest, it has the highest priority over the other options
Otherwise, one of the provided version options is chosen and applied with the default being 'patch'

The template spec is set up if not already existing.

.PARAMETER templateFilePath
Mandatory. Path to the module deployment file from root.

.PARAMETER templateSpecsRgName
Mandatory. ResourceGroup of the template spec to publish to.

.PARAMETER templateSpecsRgLocation
Mandatory. Location of the template spec resource group.

.PARAMETER templateSpecsDescription
Mandatory. The description of the parent template spec.

.PARAMETER ModuleVersion
Optional. A custom/generated version for the module.

.EXAMPLE
Publish-ModuleToTemplateSpec -templateFilePath 'C:/KeyVault/deploy.json' -templateSpecsRgName 'artifacts-rg' -templateSpecsRgLocation 'West Europe' -templateSpecsDescription 'iacs key vault' -customVersion '3.0.0'

Try to publish the KeyVault module with version 3.0.0 to a template spec called KeyVault based on a value provided in the UI
#>
function Publish-ModuleToTemplateSpec {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string] $templateFilePath,

        [Parameter(Mandatory)]
        [string] $templateSpecsRgName,

        [Parameter(Mandatory)]
        [string] $templateSpecsRgLocation,

        [Parameter(Mandatory)]
        [string] $templateSpecsDescription,

        [Parameter(Mandatory)]
        [string] $ModuleVersion
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)
    }

    process {
        $moduleIdentifier = (Split-Path $templateFilePath -Parent).Replace('\', '/').Split('/arm/')[1]
        $templateSpecIdentifier = $moduleIdentifier.Replace('\', '/').Replace('/', '.').ToLower()

        #############################
        ##    EVALUATE RESOURCES   ##
        #############################
        if (-not (Get-AzResourceGroup -Name $templateSpecsRgName -ErrorAction 'SilentlyContinue')) {
            if ($PSCmdlet.ShouldProcess("Resource group [$templateSpecsRgName] to location [$templateSpecsRgLocation]", 'Deploy')) {
                New-AzResourceGroup -Name $templateSpecsRgName -Location $templateSpecsRgLocation
            }
        }

        ################################
        ##    Create template spec    ##
        ################################
        if ($PSCmdlet.ShouldProcess("Template spec [$templateSpecIdentifier] version [$ModuleVersion]", 'Publish')) {
            $templateSpecInputObject = @{
                ResourceGroupName = $templateSpecsRgName
                Name              = $templateSpecIdentifier
                Version           = $ModuleVersion
                Description       = $templateSpecsDescription
                Location          = $templateSpecsRgLocation
                TemplateFile      = $templateFilePath
            }
            New-AzTemplateSpec @templateSpecInputObject -Force
        }
        Write-Verbose 'Publish complete'
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
