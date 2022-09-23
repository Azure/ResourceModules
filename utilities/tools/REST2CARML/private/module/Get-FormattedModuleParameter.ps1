function Get-FormattedModuleParameter {

    param (
        [Parameter(Mandatory = $true)]
        [object] $ParameterData
    )

    $result = @()

    # description (optional)
    # ----------------------
    if ($ParameterData.description) {
        $result += "@description('{0}. {1}')" -f (($ParameterData.required) ? 'Required' : 'Optional'), $ParameterData.description
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

    if ($ParameterData.default) {


        if ($ParameterData.default -like '*()*') {
            # Handle functions
            $result += "$paramLine = {0}" -f ($ParameterData.default -replace '"', '')
        } else {
            switch ($ParameterData.type) {
                'bool' {
                    $result += "$paramLine = {0}" -f $ParameterData.default.ToString().ToLower() # boolean 'True' must be lower-cased
                    break
                }
                'string' {
                    $result += "$paramLine = '{0}'" -f $ParameterData.default
                    break
                }
                'array' {
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
                        }
                    }
                    $result += ']'
                    break
                }
                'int' {
                    $result += "$paramLine = {0}" -f $ParameterData.default
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
