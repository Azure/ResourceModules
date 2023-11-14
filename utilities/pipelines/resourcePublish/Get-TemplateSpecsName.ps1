<#
.SYNOPSIS
Convert the given template file path into a valid Template Specs name

.DESCRIPTION
Convert the given template file path into a valid Template Specs repository name

.PARAMETER TemplateFilePath
Mandatory. The template file path to convert

.PARAMETER UseApiSpecsAlignedName
Optional. If set to true, the returned name will be aligned with the Azure API naming. If not, the one aligned with the module's folder path. See the following examples:
- True:  microsoft.keyvault.vaults.secrets
- False: key-vault.vault.secret

.EXAMPLE
Get-TemplateSpecsName -TemplateFilePath 'C:\modules\key-vault\vault\main.bicep'

Convert 'C:\modules\key-vault\vault\main.bicep' to e.g. 'key-vault.vault'
#>
function Get-TemplateSpecsName {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $TemplateFilePath,

        [Parameter(Mandatory = $false)]
        [bool] $UseApiSpecsAlignedName = $false
    )

    $moduleIdentifier = (Split-Path $TemplateFilePath -Parent).Replace('\', '/').Split('/modules/')[1]

    if ($UseApiSpecsAlignedName) {
        # Load helper script
        . (Join-Path (Get-Item -Path $PSScriptRoot).Parent.Parent 'pipelines' 'sharedScripts' 'helper' 'Get-SpecsAlignedResourceName.ps1')
        $moduleIdentifier = Get-SpecsAlignedResourceName -ResourceIdentifier $moduleIdentifier
        $moduleIdentifier = $moduleIdentifier -replace 'microsoft', 'ms'
    }

    $templateSpecIdentifier = $moduleIdentifier.Replace('\', '/').Replace('/', '.').ToLower()

    # Shorten the name
    # This is required as certain modules generate names such as `recovery-services.vault.replication-fabric.replication-protection-container.replication-protection-container-mapping` which are longer than the allowed 90 characters for template specs
    # Using the logic below, the name is shortened to `recovery-services.vault.replication-fabric.replication-protection-container.mapping` which has 'only' 86 characters
    $nameElems = $templateSpecIdentifier -split '\.'
    # Starting at index 1 to skip the resource provider
    for ($index = 1; $index -lt $nameElems.Count; $index++) {
        # Only run as long as we're not already at last element of the array
        if ($index -lt ($nameElems.count - 1)) {
            $stringToRemove = $nameElems[($index)]
            $stringToCheck = $nameElems[($index + 1)]

            # If a name is replicated in a path, it is usually plural in the parent, and singular in the child path.
            # For example: /virtualNetworks/ (plural) & /virtualNetworks/virtualNetworkPeerings/ (singular)
            # In this case we want to remove the singular version from the subsequent string & format it accordingly
            if ($stringToRemove.EndsWith('s') -and $stringToCheck.StartsWith($stringToRemove.Substring(0, $stringToRemove.length - 1))) {
                $singularString = $stringToRemove.Substring(0, $stringToRemove.length - 1) # Would be 'virtualNetwork' from the example above
                $rest = $stringToCheck.length - $singularString.Length # Would be 8 from the example above
                $shortenedString = $stringToCheck.Substring($singularString.length, $rest) # Would be 'peerings' from the example above
                $camelCaseString = [Regex]::Replace($shortenedString , '\b.', { $args[0].Value.Tolower() }) # Would be 'peerings' from the example above
                $nameElems[($index + 1)] = $camelCaseString # Would overwrite 'virtualnetworkpeerings' with 'peerings' from the example above
            } elseif ($stringToCheck.StartsWith($stringToRemove)) {
                # If the subsequent string starts with the current string, we want to remove the current string from the subsequent string.
                # So we take the index of the end of the current string, caculate the length until the end of the string and reduce. If a `-` was in between the 2 elements, we also want to trim it from the front.
                # For example 'replication-protection-container' & 'replication-protection-container-mapping' should become 'mapping'
                $nameElems[($index + 1)] = $stringToCheck.Substring($stringToRemove.length, $stringToCheck.length - $stringToRemove.length).TrimStart('-')
            }
        }
    }
    $templateSpecIdentifier = $nameElems -join '.'

    return $templateSpecIdentifier
}
