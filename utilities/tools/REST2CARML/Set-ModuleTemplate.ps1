#region helperFunctions
function Get-ModuleParameter {
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

function Get-TargetScope {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $JSONKeyPath
    )

    switch ($JSONKeyPath) {
        { $PSItem -like '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/*' } { return 'resourceGroup' }
        { $PSItem -like '/subscriptions/{subscriptionId}/*' } { return 'subscription' }
        { $PSItem -like 'providers/Microsoft.Management/managementGroups/*' } { return 'managementGroup' }
    }
    Default {
        throw 'Unable to detect target scope'
    }
}
#endregion

function Set-ModuleTemplate {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [string] $ProviderNamespace,

        [Parameter(Mandatory = $true)]
        [string] $ResourceType,

        [Parameter(Mandatory = $true)]
        [array] $ModuleData,

        [Parameter(Mandatory = $true)]
        [string] $JSONFilePath,

        [Parameter(Mandatory = $true)]
        [string] $JSONKeyPath
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)

        $repoRootPath = (Get-Item $PSScriptRoot).Parent.Parent.Parent
        $templatePath = Join-Path $repoRootPath 'modules' $ProviderNamespace $ResourceType 'deploy.bicep'

        # Load used functions
        . (Join-Path $PSScriptRoot 'Get-ResourceTypeSingularName.ps1')
    }

    process {

        $resourceTypeSingular = Get-ResourceTypeSingularName -ResourceType $ResourceType

        ##################
        ##  PARAMETERS  ##
        ##################

        $targetScope = Get-TargetScope -JSONKeyPath $JSONKeyPath

        $templateContent = @(
            "targetScope = '{0}'" -f $targetScope
            ''
            '// ============== //'
            '//   Parameters   //'
            '// ============== //'
            ''
        )

        # Add primary (service) parameters
        foreach ($parameter in $ModuleData.parameters) {
            $templateContent += Get-ModuleParameter -ParameterData $parameter
        }
        # Add additional (extension) parameters
        foreach ($parameter in $ModuleData.additionalParameters) {
            $templateContent += Get-ModuleParameter -ParameterData $parameter
        }
        # Add telemetry parameter
        $templateContent += Get-ModuleParameter -ParameterData @{
            level       = 0
            name        = 'enableDefaultTelemetry'
            type        = 'bool'
            default     = $true
            description = 'Enable telemetry via the Customer Usage Attribution ID (GUID).'
            required    = $false
        }

        #################
        ##  VARIABLES  ##
        #################

        foreach ($variable in $ModuleData.variables) {
            $templateContent += $variable
        }
        # Add telemetry variable
        # TODO: Should only be added if module has children)
        $templateContent += @(
            'var enableReferencedModulesTelemetry = false'
            ''
        )

        ###################
        ##  DEPLOYMENTS  ##
        ###################

        $templateContent += @(
            ''
            '// =============== //'
            '//   Deployments   //'
            '// =============== //'
            ''
        )

        # Telemetry
        $templateContent += Get-Content -Path (Join-Path 'src' 'telemetry.bicep')
        $templateContent += ''

        # Deployment resource declaration line
        $serviceAPIVersion = Split-Path (Split-Path $JSONFilePath -Parent) -Leaf
        $templateContent += "resource $resourceTypeSingular '$ProviderNamespace/$ResourceType@$serviceAPIVersion' = {"

        foreach ($parameter in ($ModuleData.parameters | Where-Object { $_.level -eq 0 })) {
            $templateContent += '  {0}: {0}' -f $parameter.name
        }

        $templateContent += '  properties: {'
        foreach ($parameter in ($ModuleData.parameters | Where-Object { $_.level -eq 1 })) {
            $templateContent += '    {0}: {0}' -f $parameter.name
        }

        $templateContent += @(
            '  }'
            '}'
            ''
        )


        # Other collected resources
        $templateContent += $ModuleData.resources

        # TODO: Add children if applicable

        #######################################
        ##  Create template outputs section  ##
        #######################################

        # Output header comment
        $templateContent += @(
            '// =========== //'
            '//   Outputs   //'
            '// =========== //'
            ''
            "@description('The name of the $resourceTypeSingular.')"
            "output name string = $resourceTypeSingular.name"
            ''
            "@description('The resource ID of the $resourceTypeSingular.')"
            "output resourceId string = $resourceTypeSingular.id"
            ''
        )

        if ($targetScope -eq 'resourceGroup') {
            $templateContent += @(
                "@description('The name of the resource group the $resourceTypeSingular was created in.')"
                'output resourceGroupName string = resourceGroup().name'
                ''
            )
        }

        # Update file
        # -----------
        Set-Content -Path $templatePath -Value $templateContent.TrimEnd()
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
