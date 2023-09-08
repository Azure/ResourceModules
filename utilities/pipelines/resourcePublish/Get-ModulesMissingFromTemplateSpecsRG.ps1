<#
.SYNOPSIS
Get a list of all modules (path & version) in the given TemplatePath that do not exist as a Template Spec in the given Resource Group

.DESCRIPTION
Get a list of all modules (path & version) in the given TemplatePath that do not exist as a Template Spec in the given Resource Group

.PARAMETER TemplateFilePath
Mandatory. The Template File Path to process

.PARAMETER TemplateSpecsRGName
Mandatory. The Resource Group to search in

.PARAMETER PublishLatest
Optional. Publish an absolute latest version.
Note: This version may include breaking changes and is not recommended for production environments

.PARAMETER UseApiSpecsAlignedName
Optional. If set to true, the module name looked for is aligned with the Azure API naming. If not, it's one aligned with the module's folder path. See the following examples:
- True:  microsoft.keyvault.vaults.secrets
- False: key-vault.vault.secret

.EXAMPLE
Get-ModulesMissingFromTemplateSpecsRG -TemplateFilePath 'C:\ResourceModules\modules\key-vault\vault\main.bicep' -TemplateSpecsRGName 'artifacts-rg'

Check if either the Key Vault module or any of its children (e.g. 'secret') is missing in the Resource Group 'artifacts-rg'

Returns for example:
Name                           Value
----                           -----
Version                        0.4.0
TemplateFilePath               C:\ResourceModules\modules\key-vault\vault\access-policy\main.bicep
Version                        0.4
TemplateFilePath               C:\ResourceModules\modules\key-vault\vault\access-policy\main.bicep
Version                        0
TemplateFilePath               C:\ResourceModules\modules\key-vault\vault\access-policy\main.bicep
Version                        latest
TemplateFilePath               C:\ResourceModules\modules\key-vault\vault\access-policy\main.bicep
Version                        0.4.0
TemplateFilePath               C:\ResourceModules\modules\key-vault\vault\key\main.bicep
Version                        0.4
TemplateFilePath               C:\ResourceModules\modules\key-vault\vault\key\main.bicep
Version                        0
TemplateFilePath               C:\ResourceModules\modules\key-vault\vault\key\main.bicep
Version                        latest
TemplateFilePath               C:\ResourceModules\modules\key-vault\vault\key\main.bicep
Version                        0.4.0
TemplateFilePath               C:\ResourceModules\modules\key-vault\vault\secret\main.bicep
Version                        0.4
TemplateFilePath               C:\ResourceModules\modules\key-vault\vault\secret\main.bicep
Version                        0
TemplateFilePath               C:\ResourceModules\modules\key-vault\vault\secret\main.bicep
Version                        latest
TemplateFilePath               C:\ResourceModules\modules\key-vault\vault\secret\main.bicep
Version                        0.5.0
TemplateFilePath               C:\ResourceModules\modules\key-vault\vault\main.bicep
Version                        0.5
TemplateFilePath               C:\ResourceModules\modules\key-vault\vault\main.bicep
Version                        0
TemplateFilePath               C:\ResourceModules\modules\key-vault\vault\main.bicep
Version                        latest
TemplateFilePath               C:\ResourceModules\modules\key-vault\vault\main.bicep
#>
function Get-ModulesMissingFromTemplateSpecsRG {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $TemplateFilePath,

        [Parameter(Mandatory = $true)]
        [string] $TemplateSpecsRGName,

        [Parameter(Mandatory = $false)]
        [bool] $PublishLatest = $true,

        [Parameter(Mandatory = $false)]
        [bool] $UseApiSpecsAlignedName = $false
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)

        # Load used functions
        . (Join-Path $PSScriptRoot 'Get-TemplateSpecsName.ps1')
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

        if (-not (Get-AzResourceGroup -ResourceGroupName $TemplateSpecsRGName -ErrorAction 'SilentlyContinue')) {
            $missingTemplatePaths = $availableModuleTemplatePaths
        } else {
            # Test all children against Resource Group
            $missingTemplatePaths = @()
            foreach ($templatePath in $availableModuleTemplatePaths) {

                # Get a valid Template Spec name
                $templateSpecsIdentifier = Get-TemplateSpecsName -TemplateFilePath $templatePath -UseApiSpecsAlignedName $UseApiSpecsAlignedName

                $null = Get-AzTemplateSpec -ResourceGroupName $TemplateSpecsRGName -Name $templateSpecsIdentifier -ErrorAction 'SilentlyContinue' -ErrorVariable 'result'

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

