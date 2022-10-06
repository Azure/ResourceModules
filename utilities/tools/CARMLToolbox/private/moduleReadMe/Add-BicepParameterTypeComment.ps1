<#
.SYNOPSIS
Add comments to indicate required & non-required parameters to the given Bicep example

.DESCRIPTION
Add comments to indicate required & non-required parameters to the given Bicep example.
'Required' is only added if the example has at least one required parameter
'Non-Required' is only added if the example has at least one required parameter and at least one non-required parameter

.PARAMETER BicepParams
Mandatory. The Bicep parameter block to add the comments to (i.e., should contain everything in between the brackets of a 'params: {...} block)

.PARAMETER AllParametersList
Mandatory. A list of all top-level (i.e. non-nested) parameter names

.PARAMETER RequiredParametersList
Mandatory. A list of all required top-level (i.e. non-nested) parameter names

.EXAMPLE
Add-BicepParameterTypeComment -AllParametersList @('name', 'lock') -RequiredParametersList @('name') -BicepParams "name: 'carml'\nlock: 'CanNotDelete'"

Add type comments to given bicep params string, using one required parameter 'name'. Would return:

'
    // Required parameters
    name: 'carml'
    // Non-required parameters
    lock: 'CanNotDelete'
'
#>
function Add-BicepParameterTypeComment {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [string] $BicepParams,

        [Parameter(Mandatory = $false)]
        [AllowEmptyCollection()]
        [string[]] $AllParametersList = @(),

        [Parameter(Mandatory = $false)]
        [AllowEmptyCollection()]
        [string[]] $RequiredParametersList = @()
    )

    if ($RequiredParametersList.Count -ge 1 -and $AllParametersList.Count -ge 2) {

        $BicepParamsArray = $BicepParams -split '\n'

        # [1/4] Check where the 'last' required parameter is located in the example (and what its indent is)
        $parameterToSplitAt = $RequiredParametersList[-1]
        $requiredParameterIndent = ([regex]::Match($BicepParamsArray[0], '^(\s+).*')).Captures.Groups[1].Value.Length

        # [2/4] Add a comment where the required parameters start
        $BicepParamsArray = @('{0}// Required parameters' -f (' ' * $requiredParameterIndent)) + $BicepParamsArray[(0 .. ($BicepParamsArray.Count))]

        # [3/4] Find the location if the last required parameter
        $requiredParameterStartIndex = ($BicepParamsArray | Select-String ('^[\s]{0}{1}:.+' -f "{$requiredParameterIndent}", $parameterToSplitAt) | ForEach-Object { $_.LineNumber - 1 })[0]

        # [4/4] If we have more than only required parameters, let's add a corresponding comment
        if ($AllParametersList.Count -gt $RequiredParametersList.Count) {
            $nextLineIndent = ([regex]::Match($BicepParamsArray[$requiredParameterStartIndex + 1], '^(\s+).*')).Captures.Groups[1].Value.Length
            if ($nextLineIndent -gt $requiredParameterIndent) {
                # Case Param is object/array: Search in rest of array for the next closing bracket with the same indent - and then add the search index (1) & initial index (1) count back in
                $requiredParameterEndIndex = ($BicepParamsArray[($requiredParameterStartIndex + 1)..($BicepParamsArray.Count)] | Select-String "^[\s]{$requiredParameterIndent}\S+" | ForEach-Object { $_.LineNumber - 1 })[0] + 1 + $requiredParameterStartIndex
            } else {
                # Case Param is single line bool/string/int: Add an index (1) for the 'required' comment
                $requiredParameterEndIndex = $requiredParameterStartIndex
            }

            # Add a comment where the non-required parameters start
            $BicepParamsArray = $BicepParamsArray[0..$requiredParameterEndIndex] + ('{0}// Non-required parameters' -f (' ' * $requiredParameterIndent)) + $BicepParamsArray[(($requiredParameterEndIndex + 1) .. ($BicepParamsArray.Count))]
        }

        return ($BicepParamsArray | Out-String).TrimEnd()
    }

    return $BicepParams
}
