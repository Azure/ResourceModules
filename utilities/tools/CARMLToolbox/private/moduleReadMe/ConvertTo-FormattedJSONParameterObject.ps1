<#
.SYNOPSIS
Convert the given Bicep parameter block to JSON parameter block

.DESCRIPTION
Convert the given Bicep parameter block to JSON parameter block

.PARAMETER BicepParamBlock
Mandatory. The Bicep parameter block to process

.EXAMPLE
ConvertTo-FormattedJSONParameterObject -BicepParamBlock "name: 'carml'\nlock: 'CanNotDelete'"

Convert the Bicep string "name: 'carml'\nlock: 'CanNotDelete'" into a parameter JSON object. Would result into:

@{
    lock = @{
        value = 'carml'
    }
    lock = @{
        value = 'CanNotDelete'
    }
}
#>
function ConvertTo-FormattedJSONParameterObject {

    [CmdletBinding()]
    param (
        [Parameter()]
        [string] $BicepParamBlock
    )

    if ([String]::IsNullOrEmpty($BicepParamBlock)) {
        # Case: No mandatory parameters
        return @{}
    }

    # [1/4] Detect top level params for later processing
    $bicepParamBlockArray = $BicepParamBlock -split '\n'
    $topLevelParamIndent = ([regex]::Match($bicepParamBlockArray[0], '^(\s+).*')).Captures.Groups[1].Value.Length
    $topLevelParams = $bicepParamBlockArray | Where-Object { $_ -match "^\s{$topLevelParamIndent}[0-9a-zA-Z]+:.*" } | ForEach-Object { ($_ -split ':')[0].Trim() }

    # [2/4] Add JSON-specific syntax to the Bicep param block to enable us to treat is as such
    # [2.1] Syntax: Outer brackets
    $paramInJsonFormat = @(
        '{',
        $BicepParamBlock
        '}'
    ) | Out-String

    # [2.2] Syntax: All single-quotes are double-quotes
    $paramInJsonFormat = $paramInJsonFormat -replace "'", '"'

    # [2.3] Split the object to format line-by-line (& also remove any empty lines)
    $paramInJSONFormatArray = $paramInJsonFormat -split '\n' | Where-Object { -not [String]::IsNullOrEmpty($_.Trim()) }

    for ($index = 0; $index -lt $paramInJSONFormatArray.Count; $index++) {

        $line = $paramInJSONFormatArray[$index]

        # [2.4] Syntax:
        # - Everything left of a leftest ':' should be wrapped in quotes (as a parameter name is always a string)
        # - However, we don't want to accidently catch something like "CriticalAddonsOnly=true:NoSchedule"
        [regex]$pattern = '^\s*\"{0}([0-9a-zA-Z]+):'
        $line = $pattern.replace($line, '"$1":', 1)

        # [2.5] Syntax: Replace Bicep resource ID references
        $mayHaveValue = $line -like '*:*'
        if ($mayHaveValue) {

            # Individual checks
            $isLineWithEmptyObjectValue = $line -match '^.+:\s*{\s*}\s*$' # e.g. test: {}
            $isLineWithObjectPropertyReferenceValue = ($line -split ':')[1].Trim() -like '*.*' # e.g. resourceGroupResources.outputs.virtualWWANResourceId`
            $isLineWithReferenceInLineKey = ($line -split ':')[0].Trim() -like '*.*'

            $lineValue = ($line -split ':')[1].Trim()
            $isLineWithStringValue = $lineValue -match '".+"' # e.g. "value"
            $isLineWithFunction = $lineValue -match '[a-zA-Z]+\(.+\)' # e.g. (split(resourceGroupResources.outputs.recoveryServicesVaultResourceId, "/"))[4]
            $isLineWithPlainValue = $lineValue -match '^\w+$' # e.g. adminPassword: password
            $isLineWithPrimitiveValue = $lineValue -match '^\s*true|false|[0-9]+$' # e.g. isSecure: true

            # Combined checks
            # In case of an output reference like '"virtualWanId": resourceGroupResources.outputs.virtualWWANResourceId' we'll only show "<virtualWanId>" (but NOT e.g. 'reference': {})
            $isLineWithObjectPropertyReference = -not $isLineWithEmptyObjectValue -and -not $isLineWithStringValue -and $isLineWithObjectPropertyReferenceValue
            # In case of a parameter/variable reference like 'adminPassword: password' we'll only show "<adminPassword>" (but NOT e.g. enableMe: true)
            $isLineWithParameterOrVariableReferenceValue = $isLineWithPlainValue -and -not $isLineWithPrimitiveValue
            # In case of any contained line like ''${resourceGroupResources.outputs.managedIdentityResourceId}': {}' we'll only show "managedIdentityResourceId: {}"
            $isLineWithObjectReferenceKeyAndEmptyObjectValue = $isLineWithEmptyObjectValue -and $isLineWithReferenceInLineKey
            # In case of any contained function like '"backupVaultResourceGroup": (split(resourceGroupResources.outputs.recoveryServicesVaultResourceId, "/"))[4]' we'll only show "<backupVaultResourceGroup>"

            if ($isLineWithObjectPropertyReference -or $isLineWithFunction -or $isLineWithParameterOrVariableReferenceValue) {
                $line = '{0}: "<{1}>"' -f ($line -split ':')[0], ([regex]::Match(($line -split ':')[0], '"(.+)"')).Captures.Groups[1].Value
            } elseif ($isLineWithObjectReferenceKeyAndEmptyObjectValue) {
                $line = '"<{0}>": {1}' -f (($line -split ':')[0] -split '\.')[-1].TrimEnd('}"'), ($line -split ':')[1].Trim()
            }
        } else {
            if ($line -notlike '*"*"*' -and $line -like '*.*') {
                # In case of a array value like '[ \n -> resourceGroupResources.outputs.managedIdentityPrincipalId <- \n ]' we'll only show "<managedIdentityPrincipalId>""
                $line = '"<{0}>"' -f $line.Split('.')[-1].Trim()
            }
        }


        $paramInJSONFormatArray[$index] = $line
    }

    # [2.6] Syntax: Add comma everywhere unless:
    # - the current line has an opening 'object: {' or 'array: [' character
    # - the line after the current line has a closing 'object: {' or 'array: [' character
    # - it's the last closing bracket
    for ($index = 0; $index -lt $paramInJSONFormatArray.Count; $index++) {
        if (($paramInJSONFormatArray[$index] -match '[\{|\[]\s*$') -or (($index -lt $paramInJSONFormatArray.Count - 1) -and $paramInJSONFormatArray[$index + 1] -match '^\s*[\]|\}]\s*$') -or ($index -eq $paramInJSONFormatArray.Count - 1)) {
            continue
        }
        $paramInJSONFormatArray[$index] = '{0},' -f $paramInJSONFormatArray[$index].Trim()
    }

    # [2.7] Format the final JSON string to an object to enable processing
    $paramInJsonFormatObject = $paramInJSONFormatArray | Out-String | ConvertFrom-Json -AsHashtable -Depth 99

    # [3/4] Inject top-level 'value`' properties
    $paramInJsonFormatObjectWithValue = @{}
    foreach ($paramKey in $topLevelParams) {
        $paramInJsonFormatObjectWithValue[$paramKey] = @{
            value = $paramInJsonFormatObject[$paramKey]
        }
    }

    # [4/4] Return result
    return $paramInJsonFormatObjectWithValue
}
