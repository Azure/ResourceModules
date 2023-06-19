<#
.SYNOPSIS
Convert the given template file path into a valid Template Specs name

.DESCRIPTION
Convert the given template file path into a valid Template Specs repository name

.PARAMETER TemplateFilePath
Mandatory. The template file path to convert

.EXAMPLE
Get-TemplateSpecsName -TemplateFilePath 'C:\modules\key-vault\vaults\main.bicep'

Convert 'C:\modules\key-vault\vaults\main.bicep' to e.g. 'microsoft.keyvault.vaults'
#>
function Get-TemplateSpecsName {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $TemplateFilePath
    )

    $moduleIdentifier = (Split-Path $TemplateFilePath -Parent).Replace('\', '/').Split('/modules/')[1]
    $templateSpecIdentifier = $moduleIdentifier.Replace('\', '/').Replace('/', '.').ToLower()
    $templateSpecIdentifier = $templateSpecIdentifier -replace 'microsoft', 'ms'

    # Shorten the name
    # This is requried as certain modules generate names such as `MS.RecoveryServices.vaults.replicationFabrics.replicationProtectionContainers.replicationProtectionContainerMappings` which are longer than the allowed 90 characters for template specs
    # Using the logic below, the name is shortened to `MS.RecoveryServices.vaults.replicationFabrics.replicationProtectionContainers.Mappings` which has 'only' 86 characters
    $nameElems = $templateSpecIdentifier -split '\.'
    # Starting at index 2 to skip the resource provider
    for ($index = 2; $index -lt $nameElems.Count; $index++) {
        if ($index -lt ($nameElems.count - 1)) {
            $stringToRemove = $nameElems[($index)]
            $stringToCheck = $nameElems[($index + 1)]

            # If a name is replicated in a path, it is usually plural in the parent, and singular in the child path.
            # For example: /virtualNetworks/ (plural) & /virtualNetworks/virtualNetworkPeerings/ (singular)
            # In this case we want to remove the singular version from the subsequent string & format it accordingly
            if ($stringToRemove.EndsWith('s') -and $stringToCheck.StartsWith($stringToRemove.Substring(0, $stringToRemove.length - 1))) {
                $singularString = $stringToRemove.Substring(0, $stringToRemove.length - 1)
                $rest = $stringToCheck.length - $singularString.Length
                $shortenedString = $stringToCheck.Substring($singularString.length, $rest)
                $camelCaseString = [Regex]::Replace($shortenedString , '\b.', { $args[0].Value.Tolower() })
                $nameElems[($index + 1)] = $camelCaseString
            } elseif ($stringToCheck.StartsWith($stringToRemove)) {
                $nameElems[($index + 1)] = $stringToCheck.Substring($stringToRemove.length, $stringToCheck.length)
            }
        }
    }
    $templateSpecIdentifier = $nameElems -join '.'

    return $templateSpecIdentifier
}
