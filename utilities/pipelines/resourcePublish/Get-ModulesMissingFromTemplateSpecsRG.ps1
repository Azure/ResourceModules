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

.EXAMPLE
Get-ModulesMissingFromTemplateSpecsRG -TemplateFilePath 'C:\ResourceModules\modules\key-vault\vaults\main.bicep' -TemplateSpecsRGName 'artifacts-rg'

Check if either the Key Vault module or any of its children (e.g. 'secret') is missing in the Resource Group 'artifacts-rg'

Returns for example:
Name                           Value
----                           -----
Version                        0.4.0
TemplateFilePath               C:\ResourceModules\modules\key-vault\vaults\access-policies\main.bicep
Version                        0.4
TemplateFilePath               C:\ResourceModules\modules\key-vault\vaults\access-policies\main.bicep
Version                        0
TemplateFilePath               C:\ResourceModules\modules\key-vault\vaults\access-policies\main.bicep
Version                        latest
TemplateFilePath               C:\ResourceModules\modules\key-vault\vaults\access-policies\main.bicep
Version                        0.4.0
TemplateFilePath               C:\ResourceModules\modules\key-vault\vaults\keys\main.bicep
Version                        0.4
TemplateFilePath               C:\ResourceModules\modules\key-vault\vaults\keys\main.bicep
Version                        0
TemplateFilePath               C:\ResourceModules\modules\key-vault\vaults\keys\main.bicep
Version                        latest
TemplateFilePath               C:\ResourceModules\modules\key-vault\vaults\keys\main.bicep
Version                        0.4.0
TemplateFilePath               C:\ResourceModules\modules\key-vault\vaults\secrets\main.bicep
Version                        0.4
TemplateFilePath               C:\ResourceModules\modules\key-vault\vaults\secrets\main.bicep
Version                        0
TemplateFilePath               C:\ResourceModules\modules\key-vault\vaults\secrets\main.bicep
Version                        latest
TemplateFilePath               C:\ResourceModules\modules\key-vault\vaults\secrets\main.bicep
Version                        0.5.0
TemplateFilePath               C:\ResourceModules\modules\key-vault\vaults\main.bicep
Version                        0.5
TemplateFilePath               C:\ResourceModules\modules\key-vault\vaults\main.bicep
Version                        0
TemplateFilePath               C:\ResourceModules\modules\key-vault\vaults\main.bicep
Version                        latest
TemplateFilePath               C:\ResourceModules\modules\key-vault\vaults\main.bicep
#>
function Get-ModulesMissingFromTemplateSpecsRG {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $TemplateFilePath,

        [Parameter(Mandatory = $true)]
        [string] $TemplateSpecsRGName,

        [Parameter(Mandatory = $false)]
        [bool] $PublishLatest = $true
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)

        # Load used functions
        . (Join-Path $PSScriptRoot 'Get-TemplateSpecsName.ps1')
    }

    process {
        # Get all children
        $availableModuleTemplatePaths = (Get-ChildItem -Path (Split-Path $TemplateFilePath) -Recurse -Include @('main.bicep', 'main.json')).FullName

        if (-not (Get-AzResourceGroup -ResourceGroupName $TemplateSpecsRGName -ErrorAction 'SilentlyContinue')) {
            $missingTemplatePaths = $availableModuleTemplatePaths
        } else {
            # Test all children against Resource Group
            $missingTemplatePaths = @()
            foreach ($templatePath in $availableModuleTemplatePaths) {

                # Get a valid Template Spec name
                $templateSpecsIdentifier = Get-TemplateSpecsName -TemplateFilePath $templatePath

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

