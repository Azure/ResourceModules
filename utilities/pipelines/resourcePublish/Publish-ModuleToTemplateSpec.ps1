<#
.SYNOPSIS
Publish a new version of a given module to a template spec

.DESCRIPTION
Publish a new version of a given module to a template spec
The template spec is set up if not already existing.

.PARAMETER TemplateFilePath
Mandatory. Path to the module deployment file from root.
Example: 'C:\arm\Microsoft.KeyVault\vaults\deploy.bicep'

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

.EXAMPLE
Publish-ModuleToTemplateSpec -TemplateFilePath 'C:\arm\Microsoft.KeyVault\vaults\deploy.bicep' -ModuleVersion '3.0.0-alpha' -TemplateSpecsRgName 'artifacts-rg' -TemplateSpecsRgLocation 'West Europe' -TemplateSpecsDescription 'iacs key vault'

Try to publish the KeyVault module with version 3.0.0-alpha to a template spec in resource group 'artifacts-rg'.
#>
function Publish-ModuleToTemplateSpec {

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
        [string] $subscriptionId
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

        #############################
        ##      set AzContext      ##
        #############################
        if (-not [String]::IsNullOrEmpty($subscriptionId)) {
            Write-Verbose ('Setting context to subscription [{0}]' -f $subscriptionId)
            $null = Set-AzContext -Subscription $subscriptionId
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
