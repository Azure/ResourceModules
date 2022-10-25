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
        $TargetObject['minValue'] = $SourceParameterObject.minimum
    }

    # Max
    if ($SourceParameterObject.Keys -contains 'maximum') {
        $TargetObject['maxValue'] = $SourceParameterObject.maximum
    }

    # Default value
    if ($SourceParameterObject.Keys -contains 'default') {
        $TargetObject['default'] = $SourceParameterObject.default
    } elseif ($TargetObject.Required -eq $false) {
        # If no default is specified, but we know the value is optional, we can set it as per its type
        switch ($TargetObject.Type) {
            'object' { $TargetObject['default'] = @{} }
            'array' { $TargetObject['default'] = @() }
            'boolean' { $TargetObject['default'] = $null } # Unkown
            'number' { $TargetObject['default'] = $null } # Unkown
            'integer' { $TargetObject['default'] = $null } # Unkown
            'string' { $TargetObject['default'] = '' }
            Default {
                throw ('Missing type handling for type [{0}]' -f $TargetObject.Type)
            }
        }
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
