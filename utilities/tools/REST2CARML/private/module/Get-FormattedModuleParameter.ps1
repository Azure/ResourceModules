<#
.SYNOPSIS
Convert the given Parameter Data object into a formatted Bicep parameter block.

.DESCRIPTION
Convert the given Parameter Data object into a formatted Bicep parameter block. The result is returned as an array of parameter block lines.

.PARAMETER ParameterData
Mandatory. The Parameter Data to convert.

.EXAMPLE
Get-FormattedModuleParameter -ParameterData @{ name = 'myParam'; type = 'string'; (...) }

Convert the given 'myParam' parameter into the Bicep format.
#>
function Get-FormattedModuleParameter {

    param (
        [Parameter(Mandatory = $true)]
        [object] $ParameterData
    )

    $result = @()

    # description (optional)
    # ----------------------
    # TODO: Add logic to always add a finishing '.' if missing
    if ($ParameterData.description) {
        # For the description we have to escape any single quote that is not already escaped (i.e., negative lookbehind)
        if ($ParameterData.description -match '^\w+\. .+' ) {
            # A keyword like 'Conditional' was already specified
            $result += "@description('{0}')" -f ($ParameterData.description -replace "(?<!\\)'", "\'")

        } else {
            $result += "@description('{0}. {1}')" -f (($ParameterData.required) ? 'Required' : 'Optional'), ($ParameterData.description -replace "(?<!\\)'", "\'")
        }
    }

    # secure (optional)
    # -----------------
    if ($ParameterData.secure) {
        $result += '@secure()'
    }

    # allowed (optional)
    # ------------------
    if ($ParameterData.allowedValues) {
        $result += '@allowed(['

        $result += $ParameterData.allowedValues | ForEach-Object {
            if ($ParameterData.type -eq 'boolean') {
                # Any boolean type (e.g., True)
                "  '{0}'" -f $_.ToLower()
            } elseif ($_ -match '\w') {
                # Any string value (e.g., 'Enabled')
                "  '$_'"
            } elseif ($_ -match '\d') {
                # Any number value (e.g., 3)
                "  $_"
            } elseif ($_ -match '') {
                "  ''"
            }
        }
        $result += '])'
    }

    # minValue (optional)
    # -------------------
    if ($ParameterData.minValue) {
        $result += '@minValue({0})' -f $ParameterData.minValue
    }

    # maxValue (optional)
    # -------------------
    if ($ParameterData.maxValue) {
        $result += '@maxValue({0})' -f $ParameterData.maxValue
    }

    # minLength (optional)
    # --------------------
    if ($ParameterData.minLength) {
        $result += '@minLength({0})' -f $ParameterData.minLength
    }

    # maxLength (optional)
    # --------------------
    if ($ParameterData.maxLength) {
        $result += '@maxLength({0})' -f $ParameterData.maxLength
    }

    # param line (mandatory) with (optional) default value
    # ----------------------------------------------------
    switch ($ParameterData.type) {
        'boolean' {
            $parameterType = 'bool'
            break
        }
        'integer' {
            $parameterType = 'int'
            break
        }
        Default {
            $parameterType = $ParameterData.type
        }
    }
    $paramLine = 'param {0} {1}' -f $ParameterData.name, $parameterType

    if ($ParameterData.Keys -contains 'default') {

        if ($ParameterData.default -like '*()*') {
            # Handle functions
            $result += "$paramLine = {0}" -f ($ParameterData.default -replace '"', '')
        } else {
            switch ($ParameterData.type) {
                'boolean' {
                    $value = [String]::IsNullOrEmpty($ParameterData.default) ? "''" : $ParameterData.default.ToString().ToLower() # boolean 'True' must be lower-cased
                    $result += "$paramLine = $value"
                    break
                }
                'string' {
                    $result += "$paramLine = '{0}'" -f $ParameterData.default
                    break
                }
                'array' {
                    if ($ParameterData.default.Count -eq 0) {
                        $result += "$paramLine = []"
                    } else {
                        $result += "$paramLine = ["
                        $result += $ParameterData.default | ForEach-Object {
                            if ($ParameterData.type -eq 'boolean') {
                                # Any boolean type (e.g., True)
                                "  '{0}'" -f $_.ToLower()
                            } elseif ($_ -match '\w') {
                                # Any string value (e.g., 'Enabled')
                                "  '$_'"
                            } elseif ($_ -match '\d') {
                                # Any number value (e.g., 3)
                                "  $_"
                            } else {
                                throw 'Not handled when formatting object'
                            }
                        }
                        $result += ']'
                    }
                    break
                }
                'integer' {
                    $result += "$paramLine = {0}" -f $ParameterData.default
                    break
                }
                'object' {
                    if ($ParameterData.default.Keys.count -eq 0) {
                        # Empty default
                        $result += "$paramLine = {}"
                    } else {
                        throw 'Handling of default objects not yet implemented'
                    }
                    break
                }
                default {
                    throw ('Unhandled parameter type [{0}]' -f $ParameterData.type)
                }
            }
        }
    } else {
        $result += $paramLine
    }

    $result += ''

    return $result

}
