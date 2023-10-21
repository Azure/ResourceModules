<#
.SYNOPSIS
Convert the given template file path into a valid Universal Artifact name

.DESCRIPTION
Convert the given template file path into a valid Universal Artifact repository name
Must be lowercase alphanumerics, dashes, dots or underscores, under 256 characters.

.PARAMETER TemplateFilePath
Mandatory. The template file path to convert

.PARAMETER UseApiSpecsAlignedName
Optional. If set to true, the returned name will be aligned with the Azure API naming. If not, the one aligned with the module's folder path. See the following examples:
- True:  microsoft.keyvault.vaults.secrets
- False: key-vault.vault.secret

.EXAMPLE
Get-UniversalArtifactsName -TemplateFilePath 'C:\modules\key-vault\vault\main.bicep'

Convert 'C:\modules\key-vault\vault\main.bicep' to e.g. 'microsoft.key-vault.vault'
#>
function Get-UniversalArtifactsName {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $TemplateFilePath,

        [Parameter(Mandatory = $false)]
        [bool] $UseApiSpecsAlignedName = $false
    )

    $ModuleFolderPath = Split-Path $TemplateFilePath -Parent
    $universalPackageModuleName = $ModuleFolderPath.Replace('\', '/').Split('/modules/')[1]

    if ($UseApiSpecsAlignedName) {
        # Load helper script
        . (Join-Path (Get-Item -Path $PSScriptRoot).Parent.Parent 'pipelines' 'sharedScripts' 'helper' 'Get-SpecsAlignedResourceName.ps1')
        $universalPackageModuleName = Get-SpecsAlignedResourceName -ResourceIdentifier $universalPackageModuleName
    }

    $universalPackageModuleName = $universalPackageModuleName.Replace('\', '.').Replace('/', '.').toLower()

    return $universalPackageModuleName
}
