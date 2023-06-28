<#
.SYNOPSIS
Convert the given template file path into a valid Container Registry repository name

.DESCRIPTION
Convert the given template file path into a valid Container Registry repository name

.PARAMETER TemplateFilePath
Mandatory. The template file path to convert

.EXAMPLE
Get-PrivateRegistryRepositoryName -TemplateFilePath 'C:\modules\key-vault\vaults\main.bicep'

Convert 'C:\modules\key-vault\vaults\main.bicep' to e.g. 'bicep/modules/keyvault.vaults'
#>
function Get-PrivateRegistryRepositoryName {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $TemplateFilePath
    )

    $moduleIdentifier = (Split-Path $TemplateFilePath -Parent).Replace('\', '/').Split('/modules/')[1]
    $moduleRegistryIdentifier = 'bicep/modules/{0}' -f $moduleIdentifier.Replace('\', '/').Replace('/', '.').ToLower()

    return $moduleRegistryIdentifier
}
