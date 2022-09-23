function Get-SectionDivider {
    param (
        [Parameter(Mandatory = $true)]
        [string] $SectionName
    )
    $outerMarginLength = 2
    $spacesOuterLines = 1
    $additionalSpacesMiddleLine = 2

    $outerDividerLine = $('/' * $outerMarginLength) + $(' ' * $spacesOuterLines) + $('=' * $additionalSpacesMiddleLine) + $('=' * $SectionName.Length) + $('=' * $additionalSpacesMiddleLine) + $(' ' * $spacesOuterLines) + $('/' * $outerMarginLength)
    $middleDividerLine = $('/' * $outerMarginLength) + $(' ' * $spacesOuterLines) + $(' ' * $additionalSpacesMiddleLine) + $SectionName + $(' ' * $additionalSpacesMiddleLine) + $(' ' * $spacesOuterLines) + $('/' * $outerMarginLength)

    return ('{0}{2}{1}{2}{0}{2}{2}' -f $outerDividerLine, $middleDividerLine, [System.Environment]::NewLine)
}

function Get-ModuleParameter {
    param (
        [Parameter(Mandatory = $true)]
        [object] $ParameterData
    )

    $result = @()

    # description (optional)
    # ----------------------
    if ($ParameterData.description) {
        $result += '@description({0}. {1})' -f (($ParameterData.required) ? 'Required' : 'Optional'), $ParameterData.description
    }

    # secure (optional)
    # -----------------
    if ($ParameterData.secure) {
        $result += '@secure'
    }

    # allowed (optional)
    # ------------------
    if ($ParameterData.allowedValues) {
        $result += '@allowed(['
        switch ($ParameterData.type) {
            'boolean' {
                $result += $ParameterData.allowedValues | ForEach-Object { "  '{0}'" -f $_.ToLower() }
                break
            }
            'string' {
                $result += $ParameterData.allowedValues | ForEach-Object { "  '$_'" }
                break
            }
            default {
                $result += $ParameterData.allowedValues | ForEach-Object { "  $_" }
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
        switch ($ParameterData.type) {
            'boolean' {
                $defaultValue = $ParameterData.default.ToString().ToLower() # boolean 'True' must be lower-cased
                break
            }
            'string' {
                $defaultValue = "'{0}'" -f $ParameterData.default
                break
            }
            default {
                $defaultValue = $ParameterData.default
            }
        }

        $paramLine += " = $defaultValue"
    }
    $result += $paramLine

    $result += ''

    return $result
}

function Get-ModuleOutputName {
    param (
        [Parameter(Mandatory = $true)]
        [string] $ResourceType
    )

    $result = ''

    $resourceSingularName = Get-ResourceTypeSingularName -ResourceType $ResourceType
    $description = "@description('The name of the {0}')" -f $resourceSingularName
    $outputLine = 'output name string = {0}.name' -f $resourceSingularName


    # building and returning the final parameter entry
    $result = $description + [System.Environment]::NewLine + $outputLine + [System.Environment]::NewLine + [System.Environment]::NewLine
    return $result
}

function Get-ModuleOutputId {
    param (
        [Parameter(Mandatory = $true)]
        [string] $ResourceType
    )

    $result = ''

    $resourceSingularName = Get-ResourceTypeSingularName -ResourceType $ResourceType
    $description = "@description('The resource ID of the {0}')" -f $resourceSingularName
    $outputLine = 'output resourceId string = {0}.id' -f $resourceSingularName


    # building and returning the final parameter entry
    $result = $description + [System.Environment]::NewLine + $outputLine + [System.Environment]::NewLine + [System.Environment]::NewLine
    return $result
}

function Get-ModuleOutputRg {
    param (
        [Parameter(Mandatory = $true)]
        [string] $ResourceType
    )

    $result = ''


    # @description('The resource group of the deployed resource.')
    # output resourceGroupName string = resourceGroup().name

    $resourceSingularName = Get-ResourceTypeSingularName -ResourceType $ResourceType
    $description = "@description('The name of the resource group the {0} was created in.')" -f $resourceSingularName
    $outputLine = 'output resourceGroupName string = resourceGroup().name'

    # building and returning the final parameter entry
    $result = $description + [System.Environment]::NewLine + $outputLine + [System.Environment]::NewLine + [System.Environment]::NewLine
    return $result
}
function Get-ApiVersion {
    param (
        [Parameter(Mandatory = $true)]
        [string] $JSONFilePath
    )

    return Split-Path -Path (Split-Path -Path $JSONFilePath -Parent) -Leaf
}

function Get-ResourceTypeSingularName {
    param (
        [Parameter(Mandatory = $true)]
        [string] $ResourceType
    )

    if ($ResourceType -like '*ii') { return $ResourceType -replace 'ii$', 'us' }
    if ($ResourceType -like '*ies') { return $ResourceType -replace 'ies$', 'y' }
    if ($ResourceType -like '*s') { return $ResourceType -replace 's$', '' }

    return $ResourceType
}

function Get-DeploymentResourceFirstLine {
    param (
        [Parameter(Mandatory = $true)]
        [string] $ProviderNamespace,

        [Parameter(Mandatory = $true)]
        [string] $ResourceType,

        [Parameter(Mandatory = $true)]
        [string] $JSONFilePath
    )

    # resource keyVault 'Microsoft.KeyVault/vaults@2021-11-01-preview' = {

    $result = ''

    $apiversion = Get-ApiVersion -JSONFilePath $JSONFilePath
    $resouceName = Get-ResourceTypeSingularName -ResourceType $ResourceType

    $result += ("resource {0} '{1}/{2}@{3}' = " -f $resouceName, $ProviderNamespace, $ResourceType, $apiversion)
    $result += '{' + [System.Environment]::NewLine

    return $result
}

function Get-DeploymentResourceParametersNewLevel {
    param (
        [Parameter(Mandatory = $true)]
        [string] $levelParentName,

        [Parameter(Mandatory = $true)]
        [int] $levelParentLevel,

        [Parameter(Mandatory = $true)]
        [ValidateSet(
            'Begin',
            'End'
        )]
        [string] $BeginOrEnd
    )

    # properties: {
    # }

    $result = ''
    if ($BeginOrEnd -eq 'Begin') {
        $result += Get-IntentSpaces -level $levelParentLevel
        $result += $levelParentName + ': {'
        $result += [System.Environment]::NewLine
    } else {
        $result += Get-IntentSpaces -level $levelParentLevel
        $result += '}' + [System.Environment]::NewLine
    }
    return $result
}

function Get-DeploymentResourceSignleParameter {
    param (
        [Parameter(Mandatory = $true)]
        [object] $ParameterData
    )

    # tags: tags
    # properties: {
    #     enabledForDeployment: enableVaultForDeployment
    # }

    $result = ''
    $result += Get-IntentSpaces -level $ParameterData.level
    $result += $ParameterData.name + ': ' + $ParameterData.name
    $result += [System.Environment]::NewLine

    return $result
}

function Get-DeploymentResourceParameters {
    param (
        [Parameter(Mandatory = $true)]
        [array] $ModuleData
    )

    # tags: tags
    # properties: {
    #     enabledForDeployment: enableVaultForDeployment
    # }

    $result = ''

    foreach ($moduleParameter in $ModuleData | Where-Object { $_.level -eq 0 } ) {
        $result += Get-DeploymentResourceSignleParameter -ParameterData $moduleParameter
    }

    $result += Get-DeploymentResourceParametersNewLevel -levelParentName 'properties' -levelParentLevel 0 -BeginOrEnd Begin
    foreach ($moduleParameter in $ModuleData | Where-Object { $_.level -eq 1 } ) {
        $result += Get-DeploymentResourceSignleParameter -ParameterData $moduleParameter
    }
    $result += Get-DeploymentResourceParametersNewLevel -levelParentName 'properties' -levelParentLevel 0 -BeginOrEnd End

    return $result
}

function Get-DeploymentResourceLastLine {
    return '}' + [System.Environment]::NewLine + [System.Environment]::NewLine
}

function Get-IntentSpaces {
    param (
        [Parameter(Mandatory = $false)]
        [int] $level = 0
    )

    return ' ' * 2 * $($level + 1)
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
    }

    process {
        ##########################################
        ##  Create template parameters section  ##
        ##########################################

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

        #########################################
        ##  Create template variables section  ##
        #########################################

        foreach ($variable in $ModuleData.variables) {
            $templateContent += $variable
        }

        ###########################################
        ##  Create template deployments section  ##
        ###########################################


        $templateContent += @(
            ''
            '// =============== //'
            '//   Deployments   //'
            '// =============== //'
            ''
        )

        # TODO: Add telemetry

        # # Deployments header comment
        # $templateContent += Get-SectionDivider -SectionName 'Deployments'

        # Deployment resource declaration line
        $templateContent += Get-DeploymentResourceFirstLine -ProviderNamespace $ProviderNamespace -ResourceType $ResourceType -JSONFilePath $JSONFilePath

        # Add deployment parameters section

        $templateContent += Get-DeploymentResourceParameters -ModuleData $ModuleData
        # Deployment resource finising line
        # to do
        $templateContent += Get-DeploymentResourceLastLine

        # TODO: Add exension resources if applicable
        # TODO: Add children if applicable

        #######################################
        ##  Create template outputs section  ##
        #######################################

        # Output header comment
        $templateContent += Get-SectionDivider -SectionName 'Outputs'

        $templateContent += Get-ModuleOutputId -ResourceType $ResourceType

        $templateContent += Get-ModuleOutputRg -ResourceType $ResourceType

        $templateContent += Get-ModuleOutputName -ResourceType $ResourceType

        return $templateContent # will be replaced with writing the template file
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }

}

# . (Join-Path $PSScriptRoot 'Resolve-ModuleData.ps1')

# $jsonFilePath = 'C:\Users\shrivastavar\Hackathon\ResourceModules\utilities\tools\REST2CARML\temp\azure-rest-api-specs\specification\keyvault\resource-manager\Microsoft.KeyVault\stable\2022-07-01\keyvault.json'
# $jsonKeyPath = '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.KeyVault/vaults/{vaultName}'
# $providerNamespace = 'Microsoft.KeyVault'
# $resourceType = 'vaults'

# # $jsonFilePath = 'C:\Users\shrivastavar\Hackathon\ResourceModules\utilities\tools\REST2CARML\temp\azure-rest-api-specs\specification\storage\resource-manager\Microsoft.Storage\stable\2022-05-01\storage.json'
# # $jsonKeyPath = '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}'
# # $providerNamespace = 'Microsoft.Storage'
# # $resourceType = 'storageAccounts'

# $resolvedModuleData = Resolve-ModuleData -jsonFilePath $jsonFilePath -jsonKeyPath $jsonKeyPath
# $resolvedModuleData | ConvertTo-Json | Out-String | Out-File -FilePath (Join-Path $PSScriptRoot 'ModuleData.json')

# $templateContent = Set-ModuleTemplate -ProviderNamespace $providerNamespace -ResourceType $resourceType -ModuleData $resolvedModuleData -JSONFilePath $jsonFilePath -JSONKeyPath $jsonKeyPath
# $templateContent | Out-File -FilePath (Join-Path $PSScriptRoot 'deploy.bicep')
