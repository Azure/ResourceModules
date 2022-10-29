
<#
.SYNOPSIS
Get the given API Specs property as a flat parameter with its attributes in a list together with any nested & also resolved property

.DESCRIPTION
Get the given API Specs property as a flat parameter with its attributes in a list together with any nested & also resolved property

.PARAMETER JSONFilePath
Mandatory. The path to the API Specs JSON file hosting the data

.PARAMETER SpecificationData
Mandatory. The specification data contain in the given API Specs file

.PARAMETER RequiredParametersOnLevel
Optional. A list of required parameters for the current level. If the current parameter is part of that list it will have a 'required' attribute

.PARAMETER Parameter
Mandatory. The parameter reference of the API Specs file to process

.PARAMETER Name
Mandatory. The name of the parameter to process

.PARAMETER Parent
Opional. The parent parameter of the currently process parameter. For example 'properties' for the most properties parameters - and '' (empty) if on root

.PARAMETER Level
Mandatory. The current 'tab' level. For example, root equals to 0, properties to 1 etc.

.PARAMETER SkipLevel
Optional. For this parameter, do not create a 'container' parameter, that is, a parameter that just exist to host other parameters. Only required in rare cases where a `ref` only contains further `ref` attributes and no properties.

.EXAMPLE
Get-SpecsPropertyAsParameter -JSONFilePath '(...)/resource-manager/Microsoft.KeyVault/stable/2022-07-01/keyvault.json' -SpecificationData @{ paths = @{(..)}; definititions = @{(..)}; (..) } -RequiredParametersOnLevel @('param1', 'param2') -Parameter @{ '$ref' = (..); description = '..' } -Name 'Param1' -Parent 'Param0' -Level 0

Process the given parameter. Converted in JSON the output may look like
[
    {
        "required": false,
        "Parent": "properties",
        "description": "The blob service properties for blob restore policy",
        "level": 1,
        "name": "restorePolicy",
        "type": "object"
    },
    {
        "required": false,
        "Parent": "restorePolicy",
        "description": "Blob restore is enabled if set to true.",
        "level": 2,
        "name": "enabled",
        "type": "boolean"
    },
    {
        "name": "days",
        "maxValue": 365,
        "type": "integer",
        "level": 2,
        "required": false,
        "description": "how long this blob can be restored. It should be great than zero and less than DeleteRetentionPolicy.days.",
        "minValue": 1,
        "Parent": "restorePolicy"
    }
]

Which is equivalent to the following structure:

    restorePolicy:object
        enabled:boolean
        days:integer
#>
function Get-SpecsPropertyAsParameter {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $JSONFilePath,

        [Parameter(Mandatory = $true)]
        [hashtable] $SpecificationData,

        [Parameter(Mandatory = $false)]
        [array] $RequiredParametersOnLevel = @(),

        [Parameter(Mandatory = $true)]
        [hashtable] $Parameter,

        [Parameter(Mandatory = $true)]
        [string] $Name,

        [Parameter(Mandatory = $false)]
        [string] $Parent = '',

        [Parameter(Mandatory = $true)]
        [int] $Level,

        [Parameter(Mandatory = $false)]
        [boolean] $SkipLevel = $false
    )

    $refObjects = @()

    if ($Parameter.readOnly) {
        return @()
    }

    if ($Parameter.Keys -contains '$ref') {
        # Parameter contains a reference to another specification
        $inputObject = @{
            JSONFilePath      = $JSONFilePath
            SpecificationData = $SpecificationData
            Parameter         = $Parameter
        }
        $resolvedReference = Resolve-SpecPropertyReference @inputObject
        $parameter = $resolvedReference.parameter
        $specificationData = $resolvedReference.SpecificationData

        if ($Parameter.Keys -contains 'properties') {
            # Parameter is an object
            if (-not $SkipLevel) {
                $parameterObject = @{
                    level       = $Level
                    name        = $Name
                    type        = 'object'
                    description = $Parameter.description
                    required    = $RequiredParametersOnLevel -contains $Name
                    Parent      = $Parent
                }
                $refObjects += Set-OptionalParameter -SourceParameterObject $Parameter -TargetObject $parameterObject
            }

            foreach ($property in $Parameter['properties'].Keys) {
                $recursiveInputObject = @{
                    JSONFilePath              = $JSONFilePath
                    SpecificationData         = $SpecificationData
                    Parameter                 = $Parameter['properties'][$property]
                    RequiredParametersOnLevel = $RequiredParametersOnLevel
                    Level                     = $SkipLevel ? $Level : $Level + 1
                    Parent                    = $Name
                    Name                      = $property
                }
                $refObjects += Get-SpecsPropertyAsParameter @recursiveInputObject
            }
        } else {
            $recursiveInputObject = @{
                JSONFilePath              = $JSONFilePath
                SpecificationData         = $SpecificationData
                Parameter                 = $Parameter
                RequiredParametersOnLevel = $RequiredParametersOnLevel
                Level                     = $Level
                Parent                    = $Parent
                Name                      = $Name
            }
            $refObjects += Get-SpecsPropertyAsParameter @recursiveInputObject
        }
    } elseif ($Parameter.Keys -contains 'items') {
        # Parameter is an array
        if ($Parameter.items.Keys -contains '$ref') {
            # Each item is an object/array
            $parameterObject = @{
                level       = $Level
                name        = $Name
                type        = 'array'
                description = $Parameter.description
                required    = $RequiredParametersOnLevel -contains $Name
                Parent      = $Parent
            }
            $refObjects += Set-OptionalParameter -SourceParameterObject $Parameter -TargetObject $parameterObject

            $recursiveInputObject = @{
                JSONFilePath              = $JSONFilePath
                SpecificationData         = $SpecificationData
                Parameter                 = $Parameter['items']
                RequiredParametersOnLevel = $RequiredParametersOnLevel
                Level                     = $Level + 1
                Parent                    = $Name
                Name                      = $property
                SkipLevel                 = $true
            }
            $refObjects += Get-SpecsPropertyAsParameter @recursiveInputObject
        } else {
            # Each item has a primitive type
            $parameterObject = @{
                level       = $Level
                name        = $Name
                type        = 'array'
                description = $Parameter.description
                required    = $RequiredParametersOnLevel -contains $Name
                Parent      = $Parent
            }
            $refObjects += Set-OptionalParameter -SourceParameterObject $Parameter -TargetObject $parameterObject

        }
    } elseif ($parameter.Keys -contains 'properties') {
        # The case if a definition reference should have been created, but the RP implemented it another way.
        # Example "TableServiceProperties": { "properties": { "properties": { "properties": { "cors": {...}}}}}
        $parameterObject = @{
            level       = $Level
            name        = $Name
            type        = 'object'
            description = $Parameter.description
            required    = $RequiredParametersOnLevel -contains $Name
            Parent      = $Parent
        }
        $refObjects += Set-OptionalParameter -SourceParameterObject $Parameter -TargetObject $parameterObject

        foreach ($property in $Parameter['properties'].Keys) {
            $recursiveInputObject = @{
                JSONFilePath              = $JSONFilePath
                SpecificationData         = $SpecificationData
                Parameter                 = $Parameter['properties'][$property]
                RequiredParametersOnLevel = $RequiredParametersOnLevel
                Level                     = $SkipLevel ? $Level : $Level + 1
                Parent                    = $Name
                Name                      = $property
            }
            $refObjects += Get-SpecsPropertyAsParameter @recursiveInputObject
        }
    } else {
        # Parameter is a 'simple' leaf - that is, not an object/array and does not reference any other specification
        if ($parameter.readOnly) {
            return @()
        }

        $parameterObject = @{
            level       = $Level
            name        = $Name
            type        = $Parameter.keys -contains 'type' ? $Parameter.type : 'object'
            description = $Parameter.description
            required    = $RequiredParametersOnLevel -contains $Name
            Parent      = $Parent
        }
        $refObjects += Set-OptionalParameter -SourceParameterObject $Parameter -TargetObject $parameterObject
    }

    return $refObjects
}
