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

    $result = ''

    # description line (optional)
    if ($ParameterData.description) {
        $description = $ParameterData.description.Replace("'", '"')
        $descriptionLine = "@description('" + $description + "')"
    }

    # todo:
    # secure (optional)
    # allowed (optional)
    # minValue (optional)
    # maxValue (optional)
    # minLength (optional)
    # maxLength (optional)
    # other?

    # param line (mandatory)
    switch ($ParameterData.type) {
        'boolean' { $parameterType = 'bool'; break }
        'integer' { $parameterType = 'int'; break }
        Default { $parameterType = $ParameterData.type }
    }
    $paramLine = 'param ' + $ParameterData.name + ' ' + $parameterType

    if ($ParameterData.default) {
        switch ($ParameterData.type) {
            'boolean' {
                $defaultValue = $ParameterData.default.ToString().ToLower() ; break
            }
            'string' { $defaultValue = "'" + $ParameterData.default + "'"; break }
            Default { $defaultValue = $ParameterData.default }
        }

        $paramLine += ' = ' + $defaultValue
    }
    # to do: default value depending on type: quotes/no quotes, boolean, arrays (multiline) etc...

    # building and returning the final parameter entry
    $result = $descriptionLine + [System.Environment]::NewLine + $paramLine + [System.Environment]::NewLine + [System.Environment]::NewLine
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

function Set-ModuleTempalate {

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
        . (Join-Path $PSScriptRoot 'Get-DiagnosticOptionsList.ps1')
        . (Join-Path $PSScriptRoot 'Get-SupportsPrivateEndpoint.ps1')
        . (Join-Path $PSScriptRoot 'Resolve-ModuleData.ps1')
        . (Join-Path $repoRootPath 'utilities' 'tools' 'Set-ModuleReadMe.ps1')
    }

    process {
        ##########################################
        ##  Create template parameters section  ##
        ##########################################

        $templateContent = ''

        # Parameters header comment
        $templateContent += Get-SectionDivider -SectionName 'Parameters'

        # Add parameters
        foreach ($parameter in $ModuleData) {
            $templateContent += Get-ModuleParameter -ParameterData $parameter
        }

        ###########################################
        ##  Create template deployments section  ##
        ###########################################

        # Deployments header comment
        $templateContent += Get-SectionDivider -SectionName 'Deployments'

        # Deployment resource declaration line
        $templateContent += Get-DeploymentResourceFirstLine -ProviderNamespace $ProviderNamespace -ResourceType $ResourceType -JSONFilePath $JSONFilePath

        # Add deployment parameters section

        $templateContent += Get-DeploymentResourceParameters -ModuleData $ModuleData
        # Deployment resource finising line
        # to do
        $templateContent += Get-DeploymentResourceLastLine

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

# $templateContent = Set-ModuleTempalate -ProviderNamespace $providerNamespace -ResourceType $resourceType -ModuleData $resolvedModuleData -JSONFilePath $jsonFilePath -JSONKeyPath $jsonKeyPath
# $templateContent | Out-File -FilePath (Join-Path $PSScriptRoot 'deploy.bicep')
