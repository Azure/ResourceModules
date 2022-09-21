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
        $descriptionLine = "@description('" + $ParameterData.description + "')"
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
    $paramLine = 'param ' + $ParameterData.name + ' ' + $ParameterData.type

    if ($ParameterData.default) {
        $paramLine += ' = ' + $ParameterData.default
    }
    # to do: default value depending on type: quotes/no quotes, boolean, arrays (multiline) etc...

    # building and returning the final parameter entry
    $result = $descriptionLine + [System.Environment]::NewLine + $paramLine + [System.Environment]::NewLine + [System.Environment]::NewLine
    return $result
}

function Get-DeploymentResourceFirstLine {
    param (
        [Parameter(Mandatory = $true)]
        [object] $ParameterData
    )
    # resource keyVault 'Microsoft.KeyVault/vaults@2021-11-01-preview' = {

    $result = ''

    $result += "@description('" + $ParameterData.description + "')"

    $paramLine = 'param ' + $ParameterData.name + ' ' + $ParameterData.type
    if ($ParameterData.default) {
        $paramLine += ' = ' + $ParameterData.default
    }

    # param location string = resourceGroup().location
    $result = $descriptionLine + [System.Environment]::NewLine + $paramLine + [System.Environment]::NewLine
    return $result
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
        [Hashtable] $ModuleData
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)

        $repoRootPath = (Get-Item $PSScriptRoot).Parent.Parent.Parent
        $templatePath = Join-Path $repoRootPath 'modules' $ProviderNamespace $ResourceType 'deploy.bicep'
        # Load used functions
        . (Join-Path $PSScriptRoot 'Get-DiagnosticOptionsList.ps1')
        . (Join-Path $PSScriptRoot 'Get-SupportsPrivateEndpoint.ps1')
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
        foreach ($parameter in $ModuleData.parameters) {
            $templateContent += Get-ModuleParameter -ParameterData $parameter
        }

        ###########################################
        ##  Create template deployments section  ##
        ###########################################

        # Deployments header comment
        $templateContent += Get-SectionDivider -SectionName 'Deployments'

        # Deployment resource declaration line
        # to do

        # Add deployment parameters
        foreach ($parameter in $ModuleData.parameters) {
            # to do
        }

        # Deployment resource finising line
        # to do


        return $templateContent # will be replaced with writing the template file
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }

}

# using dummy module data for the first draft
$moduleData = @{
    parameters = @(
        @{
            level         = 0
            name          = 'sku'
            type          = 'object'
            description   = 'Optional. My sample description'
            allowedValues = @('')
            required      = $false
            default       = ''
        }
        @{
            level       = 1
            name        = 'firewallEnabled'
            type        = 'boolean'
            description = 'Optional. My sample description 2'
            default     = $true
        }
    )
}

Set-ModuleTempalate -ProviderNamespace 'Microsoft.KeyVault' -ResourceType 'vaults' -ModuleData $moduleData
