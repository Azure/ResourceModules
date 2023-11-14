<#
.SYNOPSIS
Get a list of all modules (path & version) in the given TemplatePath that do not exist as an Universal Package in the given Azure DevOps project & artifacts feed

.DESCRIPTION
Get a list of all modules (path & version) in the given TemplatePath that do not exist as an Universal Package in the given Azure DevOps project & artifacts feed

.PARAMETER TemplateFilePath
Mandatory. The Template File Path to process

.PARAMETER VstsOrganizationUri
Mandatory. Azure DevOps organization URL hosting the artifacts feed.
Example: 'https://dev.azure.com/fabrikam/'.

.PARAMETER VstsFeedProject
Optional. Name of the project hosting the artifacts feed. May be empty.
Example: 'IaC'.

.PARAMETER VstsFeedName
Mandatory. Name to the feed to publish to.
Example: 'Artifacts'.

.PARAMETER UseApiSpecsAlignedName
Optional. If set to true, the module name looked for is aligned with the Azure API naming. If not, it's one aligned with the module's folder path. See the following examples:
- True:  microsoft.keyvault.vaults.secrets
- False: key-vault.vault.secret

.PARAMETER BearerToken
Optional. The bearer token to use to authenticate the request. If not provided it MUST be existing in your environment as `$env:TOKEN`

.EXAMPLE
Get-ModulesMissingFromUniversalArtifactsFeed -TemplateFilePath 'C:\modules\key-vault\vault\main.bicep' -vstsOrganizationUri 'https://dev.azure.com/fabrikam' -VstsProject 'IaC' -VstsFeedName 'Artifacts'

Check if either the Key Vault module or any of its children (e.g. 'secret') is missing in artifacts feed 'Artifacts' of Azure DevOps project 'https://dev.azure.com/fabrikam/IaC'

Returns for example:
Name                           Value
----                           -----
Version                        0.4.0
TemplateFilePath               C:\ResourceModules\modules\key-vault\vault\access-policy\main.bicep
Version                        0.4.0
TemplateFilePath               C:\ResourceModules\modules\key-vault\vault\key\main.bicep
Version                        0.4.0
TemplateFilePath               C:\ResourceModules\modules\key-vault\vault\secret\main.bicep
Version                        0.5.0
TemplateFilePath               C:\ResourceModules\modules\key-vault\vault\main.bicep
#>
function Get-ModulesMissingFromUniversalArtifactsFeed {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $TemplateFilePath,

        [Parameter(Mandatory = $true)]
        [string] $VstsFeedName,

        [Parameter(Mandatory = $true)]
        [string] $VstsOrganizationUri,

        [Parameter(Mandatory = $false)]
        [string] $VstsFeedProject = '',

        [Parameter(Mandatory = $false)]
        [bool] $UseApiSpecsAlignedName = $false,

        [Parameter(Mandatory = $false)]
        [string] $BearerToken = $env:TOKEN
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)

        # Load used functions
        . (Join-Path $PSScriptRoot 'Get-UniversalArtifactsName.ps1')
    }

    process {
        # Get all children, bicep templates only
        $availableModuleTemplatePaths = (Get-ChildItem -Path (Split-Path $TemplateFilePath) -Recurse -Include @('main.bicep')).FullName

        # Get all children, ARM templates only
        $availableModuleTemplatePathsARM = (Get-ChildItem -Path (Split-Path $TemplateFilePath) -Recurse -Include @('main.json')).FullName

        # Add ARM templates to the list of available modules only if there is no bicep template for the same module
        foreach ($path in $availableModuleTemplatePathsARM) {
            if ($availableModuleTemplatePaths -contains $path.Replace('.json', '.bicep')) { continue }
            $availableModuleTemplatePaths += $path
        }
        $availableModuleTemplatePaths = $availableModuleTemplatePaths | Sort-Object

        # Get artifacts
        if ($VstsOrganizationUri -like '*/') {
            $VstsOrganizationUri = $VstsOrganizationUri.Substring(0, ($VstsOrganizationUri.length - 1)) # Remove tailing slash if any
        }
        $VstsOrganization = Split-Path $VstsOrganizationUri -Leaf # Extract only organization name

        $modulesInputObject = @{
            Method  = 'Get'
            Headers = @{
                # Authorization = "Basic $BearerToken" # For custom PAT
                Authorization = "Bearer $BearerToken" # For pipeline PAT
            }
            Uri     = "https://feeds.dev.azure.com/$VstsOrganization/$VstsFeedProject/_apis/packaging/Feeds/$VstsFeedName/Packages?api-version=6.0-preview"
        }

        $publishedModules = Invoke-RestMethod @modulesInputObject
        $publishedModules = $publishedModules.value.name # Reduce down to the name

        # Test all children against Universal Artifacts feed
        $missingTemplatePaths = @()
        foreach ($templatePath in $availableModuleTemplatePaths) {

            # Get a valid Universal Artifact name
            $artifactsIdentifier = Get-UniversalArtifactsName -TemplateFilePath $templatePath -UseApiSpecsAlignedName $UseApiSpecsAlignedName

            if ($publishedModules -notcontains $artifactsIdentifier) {
                $missingTemplatePaths += $templatePath
            }
        }

        # Collect any that are not part of the ACR, fetch their version and return the result array
        $modulesToPublish = @()
        foreach ($missingTemplatePath in $missingTemplatePaths) {
            $moduleVersionToPublish = @{
                TemplateFilePath = $missingTemplatePath
                Version          = '{0}.0' -f (Get-Content (Join-Path (Split-Path $missingTemplatePath) 'version.json') -Raw | ConvertFrom-Json).version
            }
            $modulesToPublish += $moduleVersionToPublish
            Write-Verbose ('Missing module [{0}] will be considered for publishing with version [{1}]' -f $moduleVersionToPublish.TemplateFilePath, $moduleVersionToPublish.Version) -Verbose
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
