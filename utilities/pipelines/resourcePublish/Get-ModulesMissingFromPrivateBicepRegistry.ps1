<#
.SYNOPSIS
Get a list of all modules (path & version) in the given TemplatePath that do not exist as a repository in the given Container Registry

.DESCRIPTION
Get a list of all modules (path & version) in the given TemplatePath that do not exist as a repository in the given Container Registry

.PARAMETER TemplateFilePath
Mandatory. The Template File Path to process

.PARAMETER BicepRegistryName
Mandatory. The name of the Container Registry to search in

.PARAMETER BicepRegistryRgName
Mandatory. The name of Resource Group the Container Registry is located it.

.PARAMETER PublishLatest
Optional. Publish an absolute latest version.
Note: This version may include breaking changes and is not recommended for production environments

.EXAMPLE
Get-ModulesMissingFromPrivateBicepRegistry -TemplateFilePath 'C:\ResourceModules\modules\compute\virtual-machines\main.bicep' -BicepRegistryName 'adpsxxazacrx001' -BicepRegistryRgName 'artifacts-rg'

Check if either the Virtual Machine module or any of its children (e.g. 'extension') is missing in the Container Registry 'adpsxxazacrx001' of Resource Group 'artifacts-rg'

Returns for example:
Name                           Value
----                           -----
Version                        0.4.0
TemplateFilePath               C:\ResourceModules\modules\compute\virtual-machines\extensions\main.bicep
Version                        0.4
TemplateFilePath               C:\ResourceModules\modules\compute\virtual-machines\extensions\main.bicep
Version                        0
TemplateFilePath               C:\ResourceModules\modules\compute\virtual-machines\extensions\main.bicep
Version                        latest
TemplateFilePath               C:\ResourceModules\modules\compute\virtual-machines\extensions\main.bicep
Version                        0.6.0
TemplateFilePath               C:\ResourceModules\modules\compute\virtual-machines\main.bicep
Version                        0.6
TemplateFilePath               C:\ResourceModules\modules\compute\virtual-machines\main.bicep
Version                        0
TemplateFilePath               C:\ResourceModules\modules\compute\virtual-machines\main.bicep
Version                        latest
TemplateFilePath               C:\ResourceModules\modules\compute\virtual-machines\main.bicep
#>
function Get-ModulesMissingFromPrivateBicepRegistry {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $TemplateFilePath,

        [Parameter(Mandatory = $true)]
        [string] $BicepRegistryName,

        [Parameter(Mandatory = $true)]
        [string] $BicepRegistryRgName,

        [Parameter(Mandatory = $false)]
        [bool] $PublishLatest = $true
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)

        # Load used functions
        . (Join-Path $PSScriptRoot 'Get-PrivateRegistryRepositoryName.ps1')
    }

    process {
        # Get all children
        $availableModuleTemplatePaths = (Get-ChildItem -Path (Split-Path $TemplateFilePath) -Recurse -Include @('main.bicep', 'main.json')).FullName

        if (-not (Get-AzContainerRegistry -Name $BicepRegistryName -ResourceGroupName $BicepRegistryRgName -ErrorAction 'SilentlyContinue')) {
            $missingTemplatePaths = $availableModuleTemplatePaths
        } else {
            # Test all children against ACR
            $missingTemplatePaths = @()
            foreach ($templatePath in $availableModuleTemplatePaths) {

                # Get a valid Container Registry name
                $moduleRegistryIdentifier = Get-PrivateRegistryRepositoryName -TemplateFilePath $templatePath

                $null = Get-AzContainerRegistryTag -RepositoryName $moduleRegistryIdentifier -RegistryName $BicepRegistryName -ErrorAction 'SilentlyContinue' -ErrorVariable 'result'

                if ($result.exception.Response.StatusCode -eq 'NotFound') {
                    $missingTemplatePaths += $templatePath
                }
            }
        }

        # Collect any that are not part of the ACR, fetch their version and return the result array
        $modulesToPublish = @()
        foreach ($missingTemplatePath in $missingTemplatePaths) {
            $moduleVersionsToPublish = @(
                # Patch version
                @{
                    TemplateFilePath = $missingTemplatePath
                    Version          = '{0}.0' -f (Get-Content (Join-Path (Split-Path $missingTemplatePath) 'version.json') -Raw | ConvertFrom-Json).version
                },
                # Minor version
                @{
                    TemplateFilePath = $missingTemplatePath
                    Version          = (Get-Content (Join-Path (Split-Path $missingTemplatePath) 'version.json') -Raw | ConvertFrom-Json).version
                },
                # Major version
                @{
                    TemplateFilePath = $missingTemplatePath
                    Version          = ((Get-Content (Join-Path (Split-Path $missingTemplatePath) 'version.json') -Raw | ConvertFrom-Json).version -split '\.')[0]
                }
            )
            if ($PublishLatest) {
                $moduleVersionsToPublish += @{
                    TemplateFilePath = $missingTemplatePath
                    Version          = 'latest'
                }
            }

            $modulesToPublish += $moduleVersionsToPublish
            Write-Verbose ('Missing module [{0}] will be considered for publishing with version(s) [{1}]' -f $missingTemplatePath, ($moduleVersionsToPublish.Version -join ', ')) -Verbose
        }

        if ($modulesToPublish.count -eq 0) {
            Write-Verbose 'No modules missing in the target environment' -Verbose
        }

        return $modulesToPublish
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
