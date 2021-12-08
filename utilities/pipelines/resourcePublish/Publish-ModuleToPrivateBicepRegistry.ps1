<#
.SYNOPSIS
Publish a new version of a given module to a private bicep registry

.DESCRIPTION
Publish a new version of a given module to a private bicep registry

.PARAMETER TemplateFilePath
Mandatory. Path to the module deployment file from root.

.PARAMETER BicepRegistryName
Mandatory. Name of the private bicep registry to publish to.

.PARAMETER BicepRegistryRgName
Mandatory. ResourceGroup of the private bicep registry to publish to.

.PARAMETER ModuleVersion
Required. Version of the module to publish.

.EXAMPLE
Publish-ModuleToPrivateBicepRegistry -TemplateFilePath 'C:/KeyVault/deploy.json' -BicepRegistryRgName 'artifacts-rg' -ModuleVersion '3.0.0-alpha'

Try to publish the KeyVault module with version 3.0.0-alpha to a private bicep registry called KeyVault based on a value provided in the UI
#>
function Publish-ModuleToPrivateBicepRegistry {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string] $TemplateFilePath,

        [Parameter(Mandatory)]
        [string] $BicepRegistryRgName,

        [Parameter(Mandatory)]
        [string] $BicepRegistryName,

        [Parameter(Mandatory)]
        [string] $ModuleVersion
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

        # Registry
        if (-not (Get-AzContainerRegistry -ResourceGroupName $BicepRegistryRgName -Name $BicepRegistryName -ErrorAction 'SilentlyContinue')) {
            if ($PSCmdlet.ShouldProcess("Container Registry [$BicepRegistryName] to resource group [$BicepRegistryRgName]", 'Deploy')) {
                New-AzContainerRegistry -ResourceGroupName $BicepRegistryRgName -Name $BicepRegistryName -Sku 'Basic'
            }
        }

        # Extracts Microsoft.KeyVault/vaults from e.g. C:\arm\Microsoft.KeyVault\vaults\deploy.bicep
        $moduleIdentifier = (Split-Path $TemplateFilePath -Parent).Replace('\', '/').Split('/arm/')[1]
        $moduleRegistryIdentifier = 'bicep/modules/{0}' -f $moduleIdentifier.Replace('\', '/').Replace('/', '.').ToLower()

        #############################################
        ##    Publish to private bicep registry    ##
        #############################################
        $publishingTarget = 'br:{0}.azurecr.io/{1}:{2}' -f $BicepRegistryName, $moduleRegistryIdentifier, $ModuleVersion
        if ($PSCmdlet.ShouldProcess("Private bicep registry entry [$moduleRegistryIdentifier] version [$ModuleVersion] to registry [$BicepRegistryName]", 'Publish')) {
            bicep publish $TemplateFilePath --target $publishingTarget
        }
        Write-Verbose 'Publish complete'
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
