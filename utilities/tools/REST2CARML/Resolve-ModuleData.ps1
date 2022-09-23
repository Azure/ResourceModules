#region helperFunctions
<#
.SYNOPSIS
Add any optional property to the given 'TargetObject' if it exists in the given 'SourceObject'

.DESCRIPTION
Add any optional property to the given 'TargetObject' if it exists in the given 'SourceObject'

.PARAMETER SourceParameterObject
Mandatory. The source object to fetch the properties from

.PARAMETER TargetObject
Mandatory. The target object to add the optional parameters to

.EXAMPLE
Set-OptionalParameter -SourceParameterObject @{ minLength = 3; allowedValues = @('default') } -TargetObject @{ name = 'sampleObject' }

Add any optional parameter defined in the given source object to the given target object. In this case, both the 'minLength' & 'allowedValues' properties would be added. In addition, the property 'default' is added, as the 'allowedValues' specify only one possible value.
#>
function Set-OptionalParameter {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [hashtable] $SourceParameterObject,

        [Parameter(Mandatory = $true)]
        [hashtable] $TargetObject
    )

    # Allowed values
    if ($SourceParameterObject.Keys -contains 'enum') {
        $TargetObject['allowedValues'] = $SourceParameterObject.enum

        if ($SourceParameterObject.enum.count -eq 1) {
            $TargetObject['default'] = $SourceParameterObject.enum[0]
        }
    }

    # Min Length
    if ($SourceParameterObject.Keys -contains 'minLength') {
        $TargetObject['minLength'] = $SourceParameterObject.minLength
    }

    # Max Length
    if ($SourceParameterObject.Keys -contains 'maxLength') {
        $TargetObject['maxLength'] = $SourceParameterObject.maxLength
    }

    # Min
    if ($SourceParameterObject.Keys -contains 'minimum') {
        $TargetObject['minimum'] = $SourceParameterObject.minimum
    }

    # Max
    if ($SourceParameterObject.Keys -contains 'maximum') {
        $TargetObject['maximum'] = $SourceParameterObject.maximum
    }

    # Default value
    if ($SourceParameterObject.Keys -contains 'default') {
        $TargetObject['default'] = $SourceParameterObject.default
    }

    # Pattern
    if ($SourceParameterObject.Keys -contains 'pattern') {
        $TargetObject['pattern'] = $SourceParameterObject.pattern
    }

    # Secure
    if ($SourceParameterObject.Keys -contains 'x-ms-secret') {
        $TargetObject['secure'] = $SourceParameterObject.'x-ms-secret'
    }

    return $TargetObject
}

<#
.SYNOPSIS
Extract all parameters from the given API spec parameter root

.DESCRIPTION
Extract all parameters from the given API spec parameter root (e.g., PUT parameters)

.PARAMETER SpecificationData
Mandatory. The source content to crawl for data.

.PARAMETER RelevantParamRoot
Mandatory. The array of root parameters to process (e.g., PUT parameters).

.PARAMETER JSONKeyPath
Mandatory. The API Path in the JSON specification file to process

.PARAMETER ResourceType
Mandatory. The Resource Type to investigate

.EXAMPLE
Get-ParametersFromRoot -SpecificationData @{ paths = @(...); definitions = @{...} } -RelevantParamRoot @(@{ $ref: "../(...)"}) '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.KeyVault/vaults/{vaultName}' -ResourceType 'vaults'

Fetch all parameters (e.g., PUT) from the KeyVault REST path.
#>
function Get-ParametersFromRoot {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [hashtable] $SpecificationData,

        [Parameter(Mandatory = $true)]
        [array] $RelevantParamRoot,

        [Parameter(Mandatory = $true)]
        [string] $JSONKeyPath,

        [Parameter(Mandatory = $true)]
        [string] $ResourceType
    )

    $definitions = $specificationData.definitions
    $specParameters = $specificationData.parameters

    $templateData = @()

    $matchingPathObjectParametersRef = ($relevantParamRoot | Where-Object { $_.in -eq 'body' }).schema.'$ref'

    if (-not $matchingPathObjectParametersRef) {
        # If 'parameters' does not exist (as the API isn't consistent), we try the resource type instead
        $matchingPathObjectParametersRef = ($relevantParamRoot | Where-Object { $_.name -eq $ResourceType }).schema.'$ref'
    }
    if (-not $matchingPathObjectParametersRef) {
        # If even that doesn't exist (as the API is even more inconsistent), let's try a 'singular' resource type
        $matchingPathObjectParametersRef = ($relevantParamRoot | Where-Object { $_.name -eq ($ResourceType.Substring(0, $ResourceType.Length - 1)) }).schema.'$ref'
    }

    $outerParameters = $definitions[(Split-Path $matchingPathObjectParametersRef -Leaf)]

    # Handle resource name
    # --------------------
    # Note: The name can be specified in different locations like the PUT statement, but also in the spec's 'parameters' object as a reference
    # Case: The name in the url is also a parameter of the PUT statement
    $pathServiceName = (Split-Path $JSONKeyPath -Leaf) -replace '{|}', ''
    if ($relevantParamRoot.name -contains $pathServiceName) {
        $param = $relevantParamRoot | Where-Object { $_.name -eq $pathServiceName }

        $parameterObject = @{
            level       = 0
            name        = 'name'
            type        = 'string'
            description = $param.description
            required    = $true
        }

        $parameterObject = Set-OptionalParameter -SourceParameterObject $param -TargetObject $parameterObject
    } else {
        # Case: The name is a ref in the spec's 'parameters' object. E.g., { "$ref": "#/parameters/BlobServicesName" }
        # For this, we need to find the correct ref, as there can be multiple
        $nonDefaultParameter = $relevantParamRoot.'$ref' | Where-Object { $_ -like '#/parameters/*' } | Where-Object { $specParameters[(Split-Path $_ -Leaf)].name -eq $pathServiceName }
        if ($nonDefaultParameter) {
            $param = $specParameters[(Split-Path $nonDefaultParameter -Leaf)]

            $parameterObject = @{
                level       = 0
                name        = 'name'
                type        = 'string'
                description = $param.description
                required    = $true
            }

            $parameterObject = Set-OptionalParameter -SourceParameterObject $param -TargetObject $parameterObject
        }
    }

    $templateData += $parameterObject

    # Process outer properties
    # ------------------------
    foreach ($outerParameter in $outerParameters.properties.Keys | Where-Object { $_ -ne 'properties' -and -not $outerParameters.properties[$_].readOnly }) {
        $param = $outerParameters.properties[$outerParameter]
        $parameterObject = @{
            level       = 0
            name        = $outerParameter
            type        = $param.keys -contains 'type' ? $param.type : 'object'
            description = $param.description
            required    = $outerParameters.required -contains $outerParameter
        }

        $parameterObject = Set-OptionalParameter -SourceParameterObject $param -TargetObject $parameterObject

        $templateData += $parameterObject
    }

    # Special case: Location
    # The location parameter is not explicitely documented at this place (even though it should). It is however referenced as 'required' and must be included
    if ($outerParameters.required -contains 'location') {
        $parameterObject = @{
            level       = 0
            name        = 'location'
            type        = 'string'
            description = 'Location for all Resources.'
            required    = $false
            default     = ($JSONKeyPath -like '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/*') ? 'resourceGroup().location' : 'deployment().location'
        }

        # param location string = resourceGroup().location
        $templateData += $parameterObject
    }

    # Process inner properties
    # ------------------------
    $innerRef = $outerParameters.properties.properties.'$ref'
    $innerParameters = $definitions[(Split-Path $innerRef -Leaf)].properties

    foreach ($innerParameter in ($innerParameters.Keys | Where-Object { -not $innerParameters[$_].readOnly })) {
        $param = $innerParameters[$innerParameter]
        $parameterObject = @{
            level       = 1
            name        = $innerParameter
            type        = $param.keys -contains 'type' ? $param.type : 'object'
            description = $param.description
            required    = $innerParameters.required -contains $innerParameter
        }

        $parameterObject = Set-OptionalParameter -SourceParameterObject $param -TargetObject $parameterObject

        $templateData += $parameterObject
    }

    return $templateData
}
#endregion

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
