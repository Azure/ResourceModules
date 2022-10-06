<#
.SYNOPSIS
Sort the given JSON paramters into required & non-required parameters, each sorted alphabetically

.DESCRIPTION
Sort the given JSON paramters into required & non-required parameters, each sorted alphabetically

.PARAMETER ParametersJSON
Mandatory. The JSON parameters block to process (ideally already without 'value' property)

.PARAMETER RequiredParametersList
Mandatory. A list of all required top-level (i.e. non-nested) parameter names

.EXAMPLE
Get-OrderedParametersJSON -RequiredParametersList @('name') -ParametersJSON '{ "diagnosticLogsRetentionInDays": 7,"lock": "CanNotDelete","name": "carml" }'

Order the given JSON object alphabetically. Would result into:

@{
    name: 'carml'
    diagnosticLogsRetentionInDays: 7
    lock: 'CanNotDelete'
}
#>
function Get-OrderedParametersJSON {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $ParametersJSON,

        [Parameter(Mandatory = $false)]
        [AllowEmptyCollection()]
        [string[]] $RequiredParametersList = @()
    )

    # Load used function(s)
    . (Join-Path $PSScriptRoot 'helper' 'ConvertTo-OrderedHashtable.ps1')

    # [1/3] Get all parameters from the parameter object and order them recursively
    $orderedContentInJSONFormat = ConvertTo-OrderedHashtable -JSONInputObject $parametersJSON

    # [2/3] Sort 'required' parameters to the front
    $orderedJSONParameters = [ordered]@{}
    $orderedTopLevelParameterNames = $orderedContentInJSONFormat.psbase.Keys # We must use PS-Base to handle conflicts of HashTable properties & keys (e.g. for a key 'keys').
    # [2.1] Add required parameters first
    $orderedTopLevelParameterNames | Where-Object { $_ -in $RequiredParametersList } | ForEach-Object { $orderedJSONParameters[$_] = $orderedContentInJSONFormat[$_] }
    # [2.2] Add rest after
    $orderedTopLevelParameterNames | Where-Object { $_ -notin $RequiredParametersList } | ForEach-Object { $orderedJSONParameters[$_] = $orderedContentInJSONFormat[$_] }

    # [3/3] Handle empty dictionaries (in case the parmaeter file was empty)
    if ($orderedJSONParameters.count -eq 0) {
        $orderedJSONParameters = ''
    }

    return $orderedJSONParameters
}
