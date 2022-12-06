<#
.SYNOPSIS
Get a list of all modules (path & version) in the given TemplatePath that do not exist as a Template Spec in the given Resource Group

.DESCRIPTION
Get a list of all modules (path & version) in the given TemplatePath that do not exist as a Template Spec in the given Resource Group

.PARAMETER TemplateFilePath
Mandatory. The Template File Path to process

.PARAMETER TemplateSpecsRGName
Mandatory. The Resource Group to search in

.EXAMPLE
Get-ModulesMissingFromTemplateSpecsRG -TemplateFilePath 'C:\ResourceModules\modules\Microsoft.KeyVault\vaults\deploy.bicep' -TemplateSpecsRGName 'artifacts-rg'

Check if either the Key Vault module or any of its children (e.g. 'secret') is missing in the Resource Group 'artifacts-rg'

Returns for example:
Name                           Value
----                           -----
Version                        0.4.0
TemplateFilePath               C:\ResourceModules\modules\Microsoft.KeyVault\vaults\accessPolicies\deploy.bicep
Version                        0.4.0
TemplateFilePath               C:\ResourceModules\modules\Microsoft.KeyVault\vaults\keys\deploy.bicep
Version                        0.4.0
TemplateFilePath               C:\ResourceModules\modules\Microsoft.KeyVault\vaults\secrets\deploy.bicep
Version                        0.5.0
TemplateFilePath               C:\ResourceModules\modules\Microsoft.KeyVault\vaults\deploy.bicep
#>
function Get-ModulesMissingFromUniversalArtifactsFeed {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $TemplateFilePath,

        [Parameter(Mandatory = $true)]
        [string] $TemplateSpecsRGName
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)

        # Load used functions
        . (Join-Path $PSScriptRoot 'Get-UniversalArtifactsName.ps1')
    }

    process {
        # Get all children
        $availableModuleTemplatePaths = (Get-ChildItem -Path (Split-Path $TemplateFilePath) -Recurse -Include @('deploy.bicep', 'deploy.json')).FullName

        # Test all children against Universal Artifacts feed
        $missingTemplatePaths = @()
        foreach ($templatePath in $availableModuleTemplatePaths) {

            # Get a valid Universal Artifact name
            $templateSpecsIdentifier = Get-UniversalArtifactsName -TemplateFilePath $templatePath

            $null = # TODO Add call -ErrorAction 'SilentlyContinue' -ErrorVariable 'result'

            if ($result.exception.Response.StatusCode -eq 'NotFound') {
                $missingTemplatePaths += $templatePath
            }
        }

        # Collect any that are not part of the ACR, fetch their version and return the result array
        $modulesToPublish = @()
        foreach ($missingTemplatePath in $missingTemplatePaths) {
            $modulesToPublish += @{
                TemplateFilePath = $missingTemplatePath
                Version          = '{0}.0' -f (Get-Content (Join-Path (Split-Path $missingTemplatePath) 'version.json') -Raw | ConvertFrom-Json).version
            }
        }

        return $modulesToPublish
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}

