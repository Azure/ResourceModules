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

    return $TargetObject
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

.EXAMPLE
Resolve-ModuleData -JSONFilePath '(...)/resource-manager/Microsoft.KeyVault/stable/2022-07-01/keyvault.json' -JSONKeyPath '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.KeyVault/vaults/{vaultName}'

Process the API path '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.KeyVault/vaults/{vaultName}' in file 'keyvault.json'
#>
function Resolve-ModuleData {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $JSONFilePath,

        [Parameter(Mandatory = $true)]
        [string] $JSONKeyPath
    )


    # Collect data
    # ------------
    $specificationData = Get-Content -Path $JSONFilePath -Raw | ConvertFrom-Json -AsHashtable
    $definitions = $specificationData.definitions
    $specParameters = $specificationData.parameters

    $putParameters = $specificationData.paths[$JSONKeyPath].put.parameters
    $matchingPathObjectParametersRef = ($putParameters | Where-Object { $_.name -eq 'parameters' }).schema.'$ref'
    $outerParameters = $definitions[(Split-Path $matchingPathObjectParametersRef -Leaf)]

    $templateData = [System.Collections.ArrayList]@()

    # Handle resource name
    # --------------------
    # Note: The name can be specified in different locations like the PUT statement, but also in the spec's 'parameters' object as a reference
    # Case: The name in the url is also a parameter of the PUT statement
    $pathServiceName = (Split-Path $JSONKeyPath -Leaf) -replace '{|}', ''
    if ($putParameters.name -contains $pathServiceName) {
        $param = $putParameters | Where-Object { $_.name -eq $pathServiceName }

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
        $nonDefaultParameter = $putParameters.'$ref' | Where-Object { $_ -like '#/parameters/*' } | Where-Object { $specParameters[(Split-Path $_ -Leaf)].name -eq $pathServiceName }
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
