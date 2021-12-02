<#
.SYNOPSIS
Publish a new version of a given module to a private bicep registry

.DESCRIPTION
Publish a new version of a given module to a private bicep registry
The function will take evaluate which version should be published based on the provided input parameters (moduleVersion, ) and the version currently deployed to the private bicep registry
If the moduleVersion is higher than the current latest, it has the highest priority over the other options
Otherwise, one of the provided version options is chosen and applied with the default being 'patch'

.PARAMETER templateFilePath
Mandatory. Path to the module deployment file from root.

.PARAMETER bicepRegistryName
Mandatory. Name of the private bicep registry to publish to.

.PARAMETER bicepRegistryRgName
Mandatory. ResourceGroup of the private bicep registry to publish to.

.PARAMETER moduleVersion
Optional. A custom version that can be provided by the UI. '-' represents an empty value.

.EXAMPLE
Publish-ModuleToPrivateBicepRegistry -templateFilePath 'C:/KeyVault/deploy.json' -bicepRegistryRgName 'artifacts-rg' -moduleVersion '3.0.0'

Try to publish the KeyVault module with version 3.0.0 to a private bicep registry called KeyVault based on a value provided in the UI
#>
function Publish-ModuleToPrivateBicepRegistry {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string] $templateFilePath,

        [Parameter(Mandatory)]
        [string] $bicepRegistryRgName,

        [Parameter(Mandatory)]
        [string] $bicepRegistryName,

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
        if ((Split-Path $templateFilePath -Extension) -ne '.bicep') {
            throw "The template in path [$templateFilePath] is no bicep template."
        }

        # Registry
        if (-not (Get-AzContainerRegistry -ResourceGroupName $bicepRegistryRgName -Name $bicepRegistryName -ErrorAction 'SilentlyContinue')) {
            if ($PSCmdlet.ShouldProcess("Container Registry [$bicepRegistryName] to resource group [$bicepRegistryRgName]", 'Deploy')) {
                New-AzContainerRegistry -ResourceGroupName $bicepRegistryRgName -Name $bicepRegistryName -Sku 'Basic'
            }
        }

        #################################
        ##    FIND AVAILABLE VERSION   ##
        #################################
        # Extracts Microsoft.KeyVault/vaults from e.g. C:\arm\Microsoft.KeyVault\vaults\deploy.bicep
        $moduleIdentifier = (Split-Path $templateFilePath -Parent).Replace('\', '/').Split('/arm/')[1]
        $moduleRegistryIdentifier = 'bicep/modules/{0}' -f $moduleIdentifier.Replace('\', '/').Replace('/', '.').ToLower()

        if (-not ($repositories = Get-AzContainerRegistryRepository -RegistryName $bicepRegistryName -ErrorAction 'SilentlyContinue')) {
            # No repositories yet
            $repositories = @()
        }

        if ($repositories.Contains($moduleRegistryIdentifier)) {
            $versions = (Get-AzContainerRegistryTag -RegistryName $bicepRegistryName -RepositoryName $moduleRegistryIdentifier).Tags.Name
            $latestVersion = (($versions -as [Version[]]) | Measure-Object -Maximum).Maximum
            Write-Verbose "Published versions detected in private bicep registry [$moduleIdentifier]. Fetched latest [$latestVersion]."
        } else {
            Write-Verbose "No version for module reference [$moduleRegistryIdentifier] detected in private bicep registry [$bicepRegistryName]. Creating new."
            $latestVersion = New-Object System.Version('0.0.0')
        }

        if($latestVersion -ge $ModuleVersion) {
            throw "The version [$ModuleVersion] is not higher than the latest version [$latestVersion] in the private bicep registry [$bicepRegistryName]."
        }

        #############################################
        ##    Publish to private bicep registry    ##
        #############################################
        $publishingTarget = 'br:{0}.azurecr.io/{1}:{2}' -f $bicepRegistryName, $moduleRegistryIdentifier, $newVersion
        if ($PSCmdlet.ShouldProcess("Private bicep registry entry [$moduleRegistryIdentifier] version [$newVersion] to registry [$bicepRegistryName]", 'Publish')) {
            bicep publish $templateFilePath --target $publishingTarget
        }
        Write-Verbose 'Publish complete'
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
