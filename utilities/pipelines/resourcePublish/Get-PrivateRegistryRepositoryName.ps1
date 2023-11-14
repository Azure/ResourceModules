<#
.SYNOPSIS
Convert the given template file path into a valid Container Registry repository name

.DESCRIPTION
Convert the given template file path into a valid Container Registry repository name

.PARAMETER TemplateFilePath
Mandatory. The template file path to convert

.PARAMETER UseApiSpecsAlignedName
Optional. If set to true, the returned name will be aligned with the Azure API naming. If not, the one aligned with the module's folder path. See the following examples:
- True:  bicep/modules/microsoft.keyvault.vaults.secrets
- False: bicep/modules/key-vault.vault.secret

.EXAMPLE
Get-PrivateRegistryRepositoryName -TemplateFilePath 'C:\modules\key-vault\vault\main.bicep'

Convert 'C:\modules\key-vault\vault\main.bicep' to e.g. 'bicep/modules/key-vault.vault'
#>
function Get-PrivateRegistryRepositoryName {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $TemplateFilePath,

        [Parameter(Mandatory = $false)]
        [bool] $UseApiSpecsAlignedName = $false
    )

    $moduleIdentifier = (Split-Path $TemplateFilePath -Parent).Replace('\', '/').Split('/modules/')[1]

    if ($UseApiSpecsAlignedName) {
        # Load helper script
        . (Join-Path (Get-Item -Path $PSScriptRoot).Parent.Parent 'pipelines' 'sharedScripts' 'helper' 'Get-SpecsAlignedResourceName.ps1')
        $moduleIdentifier = Get-SpecsAlignedResourceName -ResourceIdentifier $moduleIdentifier
    }

    $moduleRegistryIdentifier = 'bicep/modules/{0}' -f $moduleIdentifier.Replace('\', '/').Replace('/', '.').ToLower()

    return $moduleRegistryIdentifier
}
