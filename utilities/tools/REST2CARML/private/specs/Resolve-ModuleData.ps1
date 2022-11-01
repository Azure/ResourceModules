<#
.SYNOPSIS
Extract the outer (top-level) and inner (property-level) parameters for a given API Path

.DESCRIPTION
Extract the outer (top-level) and inner (property-level) parameters for a given API Path

.PARAMETER JSONFilePath
Mandatory. The service specification file to process.

.PARAMETER UrlPath
Mandatory. The API Path in the JSON specification file to process

.PARAMETER ResourceType
Mandatory. The Resource Type to investigate

.EXAMPLE
Resolve-ModuleData -JSONFilePath '(...)/resource-manager/Microsoft.KeyVault/stable/2022-07-01/keyvault.json' -UrlPath '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.KeyVault/vaults/{vaultName}' -ResourceType 'vaults'

Process the API path '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.KeyVault/vaults/{vaultName}' in file 'keyvault.json'
#>
function Resolve-ModuleData {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $JSONFilePath,

        [Parameter(Mandatory = $true)]
        [string] $UrlPath,

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
        JSONFilePath      = $JSONFilePath
        RelevantParamRoot = $specificationData.paths[$UrlPath].put.parameters
        UrlPath           = $UrlPath
        ResourceType      = $ResourceType
    }
    $templateData += Get-SpecsPropertiesAsParameterList @putParametersInputObject

    # Get PATCH parameters (as the REST command actually always is Create or Update)
    if ($specificationData.paths[$UrlPath].patch) {
        $putParametersInputObject = @{
            JSONFilePath      = $JSONFilePath
            RelevantParamRoot = $specificationData.paths[$UrlPath].patch.parameters
            UrlPath           = $UrlPath
            ResourceType      = $ResourceType
        }
        $templateData += Get-SpecsPropertiesAsParameterList @putParametersInputObject
    }

    # Filter duplicates introduced by overlaps of PUT & PATCH
    $filteredList = @()
    foreach ($property in $templateData) {
        if (($filteredList | Where-Object { $_.level -eq $property.level -and $_.name -eq $property.name -and $_.parent -eq $property.parent }).Count -eq 0) {
            $filteredList += $property
        }
    }

    $moduleData = @{
        parameters           = $filteredList
        additionalParameters = @()
        resources            = @()
        modules              = @()
        variables            = @()
        outputs              = @()
        additionalFiles      = @()
    }

    #################################
    ##   Collect additional data   ##
    #################################

    # Set diagnostic data
    $diagInputObject = @{
        ProviderNamespace = $ProviderNamespace
        ResourceType      = $ResourceType
        ModuleData        = $ModuleData
    }
    Set-DiagnosticModuleData @diagInputObject

    # Set Endpoint data
    $endpInputObject = @{
        UrlPath      = $UrlPath
        JSONFilePath = $JSONFilePath
        ResourceType = $ResourceType
        ModuleData   = $ModuleData
    }
    Set-PrivateEndpointModuleData @endpInputObject

    ## Set RBAC data
    $rbacInputObject = @{
        ProviderNamespace = $ProviderNamespace
        ResourceType      = $ResourceType
        ModuleData        = $ModuleData
        ServiceApiVersion = Split-Path (Split-Path $JSONFilePath -Parent) -Leaf
    }
    Set-RoleAssignmentsModuleData @rbacInputObject

    ## Set Locks data
    $lockInputObject = @{
        UrlPath      = $UrlPath
        ResourceType = $ResourceType
        ModuleData   = $ModuleData
    }
    Set-LockModuleData @lockInputObject

    return $moduleData
}
