<#
.SYNOPSIS
Publish a new version of a given module to a private bicep registry

.DESCRIPTION
Publish a new version of a given module to a private bicep registry

.PARAMETER TemplateFilePath
Mandatory. Path to the module deployment file from root.
Example: 'C:\modules\Microsoft.KeyVault\vaults\deploy.bicep'

.PARAMETER ModuleVersion
Mandatory. Version of the module to publish, following SemVer convention.
Example: '1.0.0', '2.1.5-alpha.1', '0.0.5-beta.1'

.PARAMETER BicepRegistryName
Mandatory. Name of the private bicep registry to publish to.
Example: 'adpsxxazacrx001'

.PARAMETER BicepRegistryRgName
Mandatory. ResourceGroup of the private bicep registry to publish to.
Example: 'artifacts-rg'

.PARAMETER BicepRegistryRgLocation
Optional. The location of the resourceGroup the private bicep registry is deployed to. Required if the resource group is not yet existing.
Example: 'West Europe'

.EXAMPLE
Publish-ModuleToBicepRegistry -TemplateFilePath 'C:\modules\Microsoft.KeyVault\vaults\deploy.bicep' -ModuleVersion '3.0.0-alpha' -BicepRegistryName 'adpsxxazacrx001' -BicepRegistryRgName 'artifacts-rg'

Try to publish the KeyVault module with version 3.0.0-alpha to a private bicep registry called 'adpsxxazacrx001' in resource group 'artifacts-rg'.
#>
function Publish-ModuleToBicepRegistry {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string] $TemplateFilePath,

        [Parameter(Mandatory)]
        [string] $ModuleVersion,

        [Parameter(Mandatory)]
        [string] $BicepRegistryName,

        [Parameter(Mandatory)]
        [string] $BicepRegistryRgName,

        [Parameter(Mandatory = $false)]
        [string] $BicepRegistryRgLocation,

        [Parameter(Mandatory = $false)]
        [bool] $BicepRegistryPublic
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)
    }

    process {
        #############################
        ##    EVALUATE RESOURCES   ##
        #############################
        if ((Split-Path $TemplateFilePath -Extension) -ne '.bicep') {
            throw "The template in path [$TemplateFilePath] is no bicep template."
        }

        # Resource Group
        if (-not (Get-AzResourceGroup -Name $BicepRegistryRgName -ErrorAction 'SilentlyContinue')) {
            if ($PSCmdlet.ShouldProcess("Resource group [$BicepRegistryRgName] to location [$BicepRegistryRgLocation]", 'Deploy')) {
                New-AzResourceGroup -Name $BicepRegistryRgName -Location $BicepRegistryRgLocation
            }
        }

        # Registry
        if (-not (Get-AzContainerRegistry -ResourceGroupName $BicepRegistryRgName -Name $BicepRegistryName -ErrorAction 'SilentlyContinue')) {
            if ($PSCmdlet.ShouldProcess("Container Registry [$BicepRegistryName] to resource group [$BicepRegistryRgName]", 'Deploy')) {
                New-AzContainerRegistry -ResourceGroupName $BicepRegistryRgName -Name $BicepRegistryName -Sku 'Basic'
            }
        }

        if ($BicepRegistryPublic) {
            if ($PSCmdlet.ShouldProcess("Container Registry [$BicepRegistryName] public (anonymous) access", 'Enable')) {
                az acr update --name $BicepRegistryName --anonymous-pull-enabled
            }
        }

        # Extracts Microsoft.KeyVault/vaults from e.g. C:\modules\Microsoft.KeyVault\vaults\deploy.bicep
        $moduleIdentifier = (Split-Path $TemplateFilePath -Parent).Replace('\', '/').Split('/modules/')[1]
        $moduleRegistryIdentifier = 'bicep/modules/{0}' -f $moduleIdentifier.Replace('\', '/').Replace('/', '.').ToLower()

        #############################################
        ##    Publish to bicep registry    ##
        #############################################
        $publishingTarget = 'br:{0}.azurecr.io/{1}:{2}' -f $BicepRegistryName, $moduleRegistryIdentifier, $ModuleVersion
        $publishingTargetLatest = 'br:{0}.azurecr.io/{1}:{2}' -f $BicepRegistryName, $moduleRegistryIdentifier, 'latest'
        if ($PSCmdlet.ShouldProcess("Bicep registry entry [$moduleRegistryIdentifier] version [$ModuleVersion] to registry [$BicepRegistryName]", 'Publish')) {
            bicep publish $TemplateFilePath --target $publishingTarget
            bicep publish $TemplateFilePath --target $publishingTargetLatest
        }
        Write-Verbose 'Publish complete'
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
