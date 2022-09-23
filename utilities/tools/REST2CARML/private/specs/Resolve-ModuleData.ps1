<#
.SYNOPSIS
Extract the outer (top-level) and inner (property-level) parameters for a given API Path

.DESCRIPTION
Extract the outer (top-level) and inner (property-level) parameters for a given API Path

.PARAMETER JSONFilePath
Mandatory. The service specification file to process.

.PARAMETER JSONKeyPath
Mandatory. The API Path in the JSON specification file to process

.PARAMETER ResourceType
Mandatory. The Resource Type to investigate

.EXAMPLE
Resolve-ModuleData -JSONFilePath '(...)/resource-manager/Microsoft.KeyVault/stable/2022-07-01/keyvault.json' -JSONKeyPath '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.KeyVault/vaults/{vaultName}' -ResourceType 'vaults'

Process the API path '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.KeyVault/vaults/{vaultName}' in file 'keyvault.json'
#>
function Resolve-ModuleData {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $JSONFilePath,

        [Parameter(Mandatory = $true)]
        [string] $JSONKeyPath,

        [Parameter(Mandatory = $true)]
        [string] $ResourceType
    )

    # Output object
    $templateData = [System.Collections.ArrayList]@()

    # Collect data
    # ------------
    $specificationData = Get-Content -Path $JSONFilePath -Raw | ConvertFrom-Json -AsHashtable

    # Get PUT parameters
    $putParametersInputObject = @{
        SpecificationData = $SpecificationData
        RelevantParamRoot = $specificationData.paths[$JSONKeyPath].put.parameters
        JSONKeyPath       = $JSONKeyPath
        ResourceType      = $ResourceType
    }
    $templateData += Get-ParametersFromRoot @putParametersInputObject

    # Get PATCH parameters (as the REST command actually always is Create or Update)
    if ($specificationData.paths[$JSONKeyPath].patch) {
        $putParametersInputObject = @{
            SpecificationData = $SpecificationData
            RelevantParamRoot = $specificationData.paths[$JSONKeyPath].patch.parameters
            JSONKeyPath       = $JSONKeyPath
            ResourceType      = $ResourceType
        }
        $templateData += Get-ParametersFromRoot @putParametersInputObject
    }

    # Filter duplicates
    $filteredList = @()
    foreach ($level in $templateData.Level | Select-Object -Unique) {
        $filteredList += $templateData | Where-Object { $_.level -eq $level } | Sort-Object name -Unique
    }

    return @{
        parameters           = $filteredList
        additionalParameters = @()
        resources            = @()
        variables            = @()
        outputs              = @()
    }
}
