<#
.SYNOPSIS
Convert the given template file path into a valid Template Specs name

.DESCRIPTION
Convert the given template file path into a valid Template Specs repository name

.PARAMETER TemplateFilePath
Mandatory. The template file path to convert

.EXAMPLE
Get-TemplateSpecsName -TemplateFilePath 'C:\modules\key-vault\vault\main.bicep'

Convert 'C:\modules\key-vault\vault\main.bicep' to e.g. 'key-vault.vault'
#>
function Get-TemplateSpecsName {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $TemplateFilePath
    )

    $moduleIdentifier = (Split-Path $TemplateFilePath -Parent).Replace('\', '/').Split('/modules/')[1]
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
            if ($stringToCheck.StartsWith($stringToRemove)) {
                $nameElems[($index + 1)] = $stringToCheck -replace "$stringToRemove-"
            }
        }
    }
    $templateSpecIdentifier = $nameElems -join '.'

    return $templateSpecIdentifier
}
