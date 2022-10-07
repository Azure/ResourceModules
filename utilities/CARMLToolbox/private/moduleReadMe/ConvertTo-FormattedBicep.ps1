<#
.SYNOPSIS
Convert the given parameter JSON object into a formatted Bicep object (i.e., sorted & with required/non-required comments)

.DESCRIPTION
Convert the given parameter JSON object into a formatted Bicep object (i.e., sorted & with required/non-required comments)

.PARAMETER JSONParameters
Mandatory. The parameter JSON object to process.

.PARAMETER RequiredParametersList
Mandatory. A list of all required top-level (i.e. non-nested) parameter names

.EXAMPLE
ConvertTo-FormattedBicep -RequiredParametersList @('name') -JSONParameters @{ lock = @{ value = 'carml' }; lock = @{ value = 'CanNotDelete' } }

Convert the given JSONParameters object with one required parameter to a formatted Bicep object. Would result into:

'
    // Required parameters
    name: 'carml'
    // Non-required parameters
    diagnosticLogsRetentionInDays: 7
    lock: 'CanNotDelete'
'
#>
function ConvertTo-FormattedBicep {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [hashtable] $JSONParameters,

        [Parameter(Mandatory = $false)]
        [AllowEmptyCollection()]
        [string[]] $RequiredParametersList = @()
    )

    # Remove 'value' parameter property, if any (e.g. when dealing with a classic parameter file)
    $JSONParametersWithoutValue = @{}
    foreach ($parameterName in $JSONParameters.psbase.Keys) {
        $keysOnLevel = $JSONParameters[$parameterName].Keys
        if ($keysOnLevel.count -eq 1 -and $keysOnLevel -eq 'value') {
            $JSONParametersWithoutValue[$parameterName] = $JSONParameters[$parameterName].value
        } else {
            $JSONParametersWithoutValue[$parameterName] = $JSONParameters[$parameterName]
        }
    }

    # [1/4] Order parameters recursively
    if ($JSONParametersWithoutValue.Keys.Count -gt 0) {
        $orderedJSONParameters = Get-OrderedParametersJSON -ParametersJSON ($JSONParametersWithoutValue | ConvertTo-Json -Depth 99) -RequiredParametersList $RequiredParametersList
    } else {
        $orderedJSONParameters = @{}
    }
    # [2/4] Remove any JSON specific formatting
    $templateParameterObject = $orderedJSONParameters | ConvertTo-Json -Depth 99
    if ($templateParameterObject -ne '{}') {
        $contentInBicepFormat = $templateParameterObject -replace '"', "'" # Update any [xyz: "xyz"] to [xyz: 'xyz']
        $contentInBicepFormat = $contentInBicepFormat -replace ',', '' # Update any [xyz: xyz,] to [xyz: xyz]
        $contentInBicepFormat = $contentInBicepFormat -replace "'(\w+)':", '$1:' # Update any  ['xyz': xyz] to [xyz: xyz]
        $contentInBicepFormat = $contentInBicepFormat -replace "'(.+.getSecret\('.+'\))'", '$1' # Update any  [xyz: 'xyz.GetSecret()'] to [xyz: xyz.GetSecret()]

        $bicepParamsArray = $contentInBicepFormat -split '\n'
        $bicepParamsArray = $bicepParamsArray[1..($bicepParamsArray.count - 2)]
    }

    # [3/4] Format params with indent
    $BicepParams = ($bicepParamsArray | ForEach-Object { "  $_" } | Out-String).TrimEnd()

    # [4/4]  Add comment where required & optional parameters start
    $splitInputObject = @{
        BicepParams            = $BicepParams
        RequiredParametersList = $RequiredParametersList
        AllParametersList      = $JSONParametersWithoutValue.Keys
    }
    $commentedBicepParams = Add-BicepParameterTypeComment @splitInputObject

    return $commentedBicepParams
}
