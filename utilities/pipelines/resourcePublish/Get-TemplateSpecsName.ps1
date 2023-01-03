<#
.SYNOPSIS
Convert the given template file path into a valid Template Specs name

.DESCRIPTION
Convert the given template file path into a valid Template Specs repository name

.PARAMETER TemplateFilePath
Mandatory. The template file path to convert

.EXAMPLE
Get-TemplateSpecsName -TemplateFilePath 'C:\modules\Microsoft.KeyVault\vaults\deploy.bicep'

Convert 'C:\modules\Microsoft.KeyVault\vaults\deploy.bicep' to e.g. 'microsoft.keyvault.vaults'
#>
function Get-TemplateSpecsName {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $TemplateFilePath
    )

    $moduleIdentifier = (Split-Path $TemplateFilePath -Parent).Replace('\', '/').Split('/modules/')[1]
    $templateSpecIdentifier = $moduleIdentifier.Replace('\', '/').Replace('/', '.').ToLower()


    return $templateSpecIdentifier
}
