#requires -version 6.0

<#
.SYNOPSIS
Update the 'Resource Types' section of the given readme file

.DESCRIPTION
Update the 'Resource Types' section of the given readme file
The section is added at the end if it does not exist

.PARAMETER TemplateFileContent
Mandatory. The template file content object to crawl data from

.PARAMETER ReadMeFileContent
Mandatory. The readme file content array to update

.PARAMETER SectionStartIdentifier
Optional. The identifier of the 'outputs' section. Defaults to '## Resource Types'

.PARAMETER ResourceTypesToExclude
Optional. The resource types to exclude from the list. By default excludes 'Microsoft.Resources/deployments'

.EXAMPLE
Set-ResourceTypesSection -TemplateFileContent @{ resource = @{}; ... } -ReadMeFileContent @('# Title', '', '## Section 1', ...)

Update the given readme file's 'Resource Types' section based on the given template file content
#>
function Set-ResourceTypesSection {

    [CmdletBinding(SupportsShouldProcess)]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'ResourceTypesToExclude', Justification = 'Variable used inside Where-Object block.')]
    param (
        [Parameter(Mandatory)]
        [hashtable] $TemplateFileContent,

        [Parameter(Mandatory)]
        [object[]] $ReadMeFileContent,

        [Parameter(Mandatory = $false)]
        [string] $SectionStartIdentifier = '## Resource Types',

        [Parameter(Mandatory = $false)]
        [string[]] $ResourceTypesToExclude = @('Microsoft.Resources/deployments')
    )

    # Process content
    $SectionContent = [System.Collections.ArrayList]@(
        '| Resource Type | API Version |',
        '| :-- | :-- |'
    )

    $RelevantResourceTypeObjects = Get-NestedResourceList $TemplateFileContent | Where-Object {
        $_.type -notin $ResourceTypesToExclude -and $_
    } | Select-Object 'Type', 'ApiVersion' -Unique | Sort-Object Type -Culture en-US

    foreach ($resourceTypeObject in $RelevantResourceTypeObjects) {
        $ProviderNamespace, $ResourceType = $resourceTypeObject.Type -split '/', 2
        # Validate if Reference URL Is working
        $TemplatesBaseUrl = 'https://docs.microsoft.com/en-us/azure/templates'
        try {
            $ResourceReferenceUrl = '{0}/{1}/{2}/{3}' -f $TemplatesBaseUrl, $ProviderNamespace, $resourceTypeObject.ApiVersion, $ResourceType
            $null = Invoke-WebRequest -Uri $ResourceReferenceUrl
        } catch {
            # Validate if Reference URL is working using the latest documented API version (with no API version in the URL)
            try {
                $ResourceReferenceUrl = '{0}/{1}/{2}' -f $TemplatesBaseUrl, $ProviderNamespace, $ResourceType
                $null = Invoke-WebRequest -Uri $ResourceReferenceUrl
            } catch {
                # Check if the resource is a child resource
                if ($ResourceType.Split('/').length -gt 1) {
                    $ResourceReferenceUrl = '{0}/{1}/{2}' -f $TemplatesBaseUrl, $ProviderNamespace, $ResourceType.Split('/')[0]
                } else {
                    # Use the default Templates URL (Last resort)
                    $ResourceReferenceUrl = '{0}' -f $TemplatesBaseUrl
                }
            }
        }
        $SectionContent += ('| `{0}` | [{1}]({2}) |' -f $resourceTypeObject.type, $resourceTypeObject.apiVersion, $ResourceReferenceUrl)
    }

    # Build result
    if ($PSCmdlet.ShouldProcess('Original file with new resource type content', 'Merge')) {
        $updatedFileContent = Merge-FileWithNewContent -oldContent $ReadMeFileContent -newContent $SectionContent -SectionStartIdentifier $SectionStartIdentifier -contentType 'table'
    }
    return $updatedFileContent
}

<#
.SYNOPSIS
Update the 'parameters' section of the given readme file

.DESCRIPTION
Update the 'parameters' section of the given readme file
The section is added at the end if it does not exist

.PARAMETER TemplateFileContent
Mandatory. The template file content object to crawl data from

.PARAMETER ReadMeFileContent
Mandatory. The readme file content array to update

.PARAMETER currentFolderPath
Mandatory. The current folder path

.PARAMETER SectionStartIdentifier
Optional. The identifier of the 'outputs' section. Defaults to '## Parameters'

.PARAMETER ColumnsInOrder
Optional. The order of parameter categories to show in the readme parameters section.

.EXAMPLE
Set-ParametersSection -TemplateFileContent @{ resource = @{}; ... } -ReadMeFileContent @('# Title', '', '## Section 1', ...)

Update the given readme file's 'Parameters' section based on the given template file content
#>
function Set-ParametersSection {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [hashtable] $TemplateFileContent,

        [Parameter(Mandatory)]
        [object[]] $ReadMeFileContent,

        [Parameter(Mandatory)]
        [string] $currentFolderPath,

        [Parameter(Mandatory = $false)]
        [string] $SectionStartIdentifier = '## Parameters',

        [Parameter(Mandatory = $false)]
        [string[]] $ColumnsInOrder = @('Required', 'Conditional', 'Optional', 'Generated')
    )

    # Get all descriptions
    $descriptions = $TemplateFileContent.parameters.Values.metadata.description

    # Get the module parameter categories
    $paramCategories = $descriptions | ForEach-Object { $_.Split('.')[0] } | Select-Object -Unique

    # Sort categories
    $sortedParamCategories = $ColumnsInOrder | Where-Object { $paramCategories -contains $_ }
    # Add all others that exist but are not specified in the columnsInOrder parameter
    $sortedParamCategories += $paramCategories | Where-Object { $ColumnsInOrder -notcontains $_ }

    # Collect file information
    $currentLevelFolders = Get-ChildItem -Path $currentFolderPath -Directory -Depth 0
    $folderNames = ($null -ne $currentLevelFolders) ? ($currentLevelFolders.FullName | ForEach-Object { Split-Path $_ -Leaf }) : @()

    # Add name as property for later reference
    $TemplateFileContent.parameters.Keys | ForEach-Object { $TemplateFileContent.parameters[$_]['name'] = $_ }

    $newSectionContent = [System.Collections.ArrayList]@()
    # Create parameter blocks
    foreach ($category in $sortedParamCategories) {

        # 1. Prepare
        # Filter to relevant items
        [array] $categoryParameters = $TemplateFileContent.parameters.Values | Where-Object { $_.metadata.description -like "$category. *" } | Sort-Object -Property 'Name' -Culture 'en-US'

        # Check properties for later reference
        $hasDefault = $categoryParameters.defaultValue.count -gt 0
        $hasAllowed = $categoryParameters.allowedValues.count -gt 0

        # 2. Create header including optional columns
        $newSectionContent += @(
            ('**{0} parameters**' -f $category),
            ('| Parameter Name | Type | {0}{1}Description |' -f ($hasDefault ? 'Default Value | ' : ''), ($hasAllowed ? 'Allowed Values | ' : '')),
            ('| :-- | :-- | {0}{1}:-- |' -f ($hasDefault ? ':-- | ' : ''), ($hasAllowed ? ':-- | ' : ''))
        )

        # 3. Add individual parameters
        foreach ($parameter in $categoryParameters) {

            # Check for local readme references
            if ($folderNames -and $parameter.name -in $folderNames -and $parameter.type -in @('object', 'array')) {
                if ($folderNames -contains $parameter.name) {
                    $type = '_[{0}]({0}/readme.md)_ {1}' -f $parameter.name, $parameter.type
                }
            } elseif ($folderNames -and $parameter.name -like '*Obj' -and $parameter.name.TrimEnd('Obj') -in $folderNames -and $parameter.type -in @('object', 'array')) {
                if ($folderNames -contains $parameter.name.TrimEnd('Obj')) {
                    $type = '_[{0}]({0}/readme.md)_ {1}' -f $parameter.name.TrimEnd('Obj'), $parameter.type
                }
            } else {
                $type = $parameter.type
            }

            # Add external single quotes to all default values of type string except for those using functions
            $defaultValue = ($parameter.defaultValue -is [array]) ? ('[{0}]' -f (($parameter.defaultValue | Sort-Object) -join ', ')) : (($parameter.defaultValue -is [hashtable]) ? '{object}' : (($parameter.defaultValue -is [string]) -and ($parameter.defaultValue -notmatch '\[\w+\(.*\).*\]') ? '''' + $parameter.defaultValue + '''' : $parameter.defaultValue))
            $description = $parameter.metadata.description.Replace("`r`n", '<p>').Replace("`n", '<p>')
            $allowedValue = ($parameter.allowedValues -is [array]) ? ('[{0}]' -f (($parameter.allowedValues | Sort-Object) -join ', ')) : (($parameter.allowedValues -is [hashtable]) ? '{object}' : $parameter.allowedValues)
            # Further, replace all "empty string" default values with actual visible quotes
            if ([regex]::Match($allowedValue, '^(\[\s*,.+)|(\[.+,\s*,)|(.+,\s*\])$').Captures.Count -gt 0) {
                $allowedValue = $allowedValue -replace '\[\s*,', "[''," -replace ',\s*,', ", ''," -replace ',\s*\]', ", '']"
            }

            # Update parameter table content based on parameter category
            ## Remove category from parameter description
            $description = $description.substring("$category. ".Length)
            $defaultValueColumnValue = ($hasDefault ? (-not [String]::IsNullOrEmpty($defaultValue) ? "``$defaultValue`` | " : ' | ') : '')
            $allowedValueColumnValue = ($hasAllowed ? (-not [String]::IsNullOrEmpty($allowedValue) ? "``$allowedValue`` | " : ' | ') : '')
            $newSectionContent += ('| `{0}` | {1} | {2}{3}{4} |' -f $parameter.name, $type, $defaultValueColumnValue, $allowedValueColumnValue, $description)
        }
        $newSectionContent += ''
    }

    # Build result
    if ($PSCmdlet.ShouldProcess('Original file with new parameters content', 'Merge')) {
        $updatedFileContent = Merge-FileWithNewContent -oldContent $ReadMeFileContent -newContent $newSectionContent -SectionStartIdentifier $SectionStartIdentifier -contentType 'none'
    }

    # Build sub-section 'ParameterUsage'
    if (Test-Path (Join-Path $PSScriptRoot 'moduleReadMeSource')) {
        if ($resourceUsageSourceFiles = Get-ChildItem (Join-Path $PSScriptRoot 'moduleReadMeSource') -Recurse -Filter 'resourceUsage-*') {
            foreach ($sourceFile in $resourceUsageSourceFiles.FullName) {
                $parameterName = (Split-Path $sourceFile -LeafBase).Replace('resourceUsage-', '')
                if ($templateFileContent.parameters.Keys -contains $parameterName) {
                    $subSectionStartIdentifier = '### Parameter Usage: `{0}`' -f $ParameterName

                    # Build result
                    $updateParameterUsageInputObject = @{
                        OldContent             = $updatedFileContent
                        NewContent             = (Get-Content $sourceFile -Raw).Trim()
                        SectionStartIdentifier = $subSectionStartIdentifier
                        ParentStartIdentifier  = $SectionStartIdentifier
                        ContentType            = 'none'
                    }
                    if ($PSCmdlet.ShouldProcess(('Original file with new parameter usage [{0}] content' -f $parameterName), 'Merge')) {
                        $updatedFileContent = Merge-FileWithNewContent @updateParameterUsageInputObject
                    }
                }
            }
        }
    }

    return $updatedFileContent
}

<#
.SYNOPSIS
Update the 'outputs' section of the given readme file

.DESCRIPTION
Update the 'outputs' section of the given readme file
The section is added at the end if it does not exist

.PARAMETER TemplateFileContent
Mandatory. The template file content object to crawl data from

.PARAMETER ReadMeFileContent
Mandatory. The readme file content array to update

.PARAMETER SectionStartIdentifier
Optional. The identifier of the 'outputs' section. Defaults to '## Outputs'

.EXAMPLE
Set-OutputsSection -TemplateFileContent @{ resource = @{}; ... } -ReadMeFileContent @('# Title', '', '## Section 1', ...)

Update the given readme file's 'Outputs' section based on the given template file content
#>
function Set-OutputsSection {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [hashtable] $TemplateFileContent,

        [Parameter(Mandatory)]
        [object[]] $ReadMeFileContent,

        [Parameter(Mandatory = $false)]
        [string] $SectionStartIdentifier = '## Outputs'
    )

    # Process content
    if ($TemplateFileContent.outputs.Values.metadata) {
        # Template has output descriptions
        $SectionContent = [System.Collections.ArrayList]@(
            '| Output Name | Type | Description |',
            '| :-- | :-- | :-- |'
        )
        foreach ($outputName in ($templateFileContent.outputs.Keys | Sort-Object -Culture en-US)) {
            $output = $TemplateFileContent.outputs[$outputName]
            $description = $output.metadata.description.Replace("`r`n", '<p>').Replace("`n", '<p>')
            $SectionContent += ("| ``{0}`` | {1} | {2} |" -f $outputName, $output.type, $description)
        }
    } else {
        $SectionContent = [System.Collections.ArrayList]@(
            '| Output Name | Type |',
            '| :-- | :-- |'
        )
        foreach ($outputName in ($templateFileContent.outputs.Keys | Sort-Object -Culture en-US)) {
            $output = $TemplateFileContent.outputs[$outputName]
            $SectionContent += ("| ``{0}`` | {1} |" -f $outputName, $output.type)
        }
    }

    # Build result
    if ($PSCmdlet.ShouldProcess('Original file with new output content', 'Merge')) {
        $updatedFileContent = Merge-FileWithNewContent -oldContent $ReadMeFileContent -newContent $SectionContent -SectionStartIdentifier $SectionStartIdentifier -contentType 'table'
    }
    return $updatedFileContent
}

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

<#
.SYNOPSIS
Sort the given JSON parameters into a new JSON parameter object, all parameter sorted into required & non-required parameters, each sorted alphabetically

.DESCRIPTION
Sort the given JSON parameters into a new JSON parameter object, all parameter sorted into required & non-required parameters, each sorted alphabetically.
The location where required & non-required parameters start is highlighted with by a corresponding comment

.PARAMETER ParametersJSON
Mandatory. The parameter JSON object to process

.PARAMETER RequiredParametersList
Mandatory. A list of all required top-level (i.e. non-nested) parameter names

.EXAMPLE
Build-OrderedJSONObject -RequiredParametersList @('name') -ParametersJSON '{ "lock": { "value": "CanNotDelete" }, "name": { "value": "carml" }, "diagnosticLogsRetentionInDays": { "value": 7 } }'

Build a formatted Parameter-JSON object with one required parameter. Would result into:

'{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        // Required parameters
        "name": {
            "value": "carml"
        },
        // Non-required parameters
        "diagnosticLogsRetentionInDays": {
            "value": 7
        },
        "lock": {
            "value": "CanNotDelete"
        }
    }
}'
#>
function Build-OrderedJSONObject {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $ParametersJSON,

        [Parameter(Mandatory = $false)]
        [AllowEmptyCollection()]
        [string[]] $RequiredParametersList = @()
    )

    # [1/9] Sort parameter alphabetically
    $orderedJSONParameters = Get-OrderedParametersJSON -ParametersJSON $ParametersJSON -RequiredParametersList $RequiredParametersList

    # [2/9] Build the ordered parameter file syntax back up
    $jsonExample = ([ordered]@{
            '$schema'      = 'https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#'
            contentVersion = '1.0.0.0'
            parameters     = (-not [String]::IsNullOrEmpty($orderedJSONParameters)) ? $orderedJSONParameters : @{}
        } | ConvertTo-Json -Depth 99)

    # [3/8] If we have at least one required and one other parameter we want to add a comment
    if ($RequiredParametersList.Count -ge 1 -and $OrderedJSONParameters.Keys.Count -ge 2) {

        $jsonExampleArray = $jsonExample -split '\n'

        # [4/8] Check where the 'last' required parameter is located in the example (and what its indent is)
        $parameterToSplitAt = $RequiredParametersList[-1]
        $parameterStartIndex = ($jsonExampleArray | Select-String '.*"parameters": \{.*' | ForEach-Object { $_.LineNumber - 1 })[0]
        $requiredParameterIndent = ([regex]::Match($jsonExampleArray[($parameterStartIndex + 1)], '^(\s+).*')).Captures.Groups[1].Value.Length

        # [5/8] Add a comment where the required parameters start
        $jsonExampleArray = $jsonExampleArray[0..$parameterStartIndex] + ('{0}// Required parameters' -f (' ' * $requiredParameterIndent)) + $jsonExampleArray[(($parameterStartIndex + 1) .. ($jsonExampleArray.Count))]

        # [6/8] Find the location if the last required parameter
        $requiredParameterStartIndex = ($jsonExampleArray | Select-String "^[\s]{$requiredParameterIndent}`"$parameterToSplitAt`": \{.*" | ForEach-Object { $_.LineNumber - 1 })[0]

        # [7/8] If we have more than only required parameters, let's add a corresponding comment
        if ($orderedJSONParameters.Keys.Count -gt $RequiredParametersList.Count ) {
            # Search in rest of array for the next closing bracket with the same indent - and then add the search index (1) & initial index (1) count back in
            $requiredParameterEndIndex = ($jsonExampleArray[($requiredParameterStartIndex + 1)..($jsonExampleArray.Count)] | Select-String "^[\s]{$requiredParameterIndent}\}" | ForEach-Object { $_.LineNumber - 1 })[0] + 1 + $requiredParameterStartIndex

            # Add a comment where the non-required parameters start
            $jsonExampleArray = $jsonExampleArray[0..$requiredParameterEndIndex] + ('{0}// Non-required parameters' -f (' ' * $requiredParameterIndent)) + $jsonExampleArray[(($requiredParameterEndIndex + 1) .. ($jsonExampleArray.Count))]
        }

        # [8/8] Convert the processed array back into a string
        return $jsonExampleArray | Out-String
    }

    return $jsonExample
}

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
    # [2.3] Syntax: Everything left of a ':' should be wrapped in quotes (as a parameter name is always a string)
    $paramInJsonFormat = $paramInJsonFormat -replace '([0-9a-zA-Z]+):', '"$1":'

    # [2.4] Split the object to format line-by-line (& also remove any empty lines)
    $paramInJSONFormatArray = $paramInJsonFormat -split '\n' | Where-Object { $_ }

    # [2.5] Syntax: Replace Bicep resource ID references
    for ($index = 0; $index -lt $paramInJSONFormatArray.Count; $index++) {
        if ($paramInJSONFormatArray[$index] -like '*:*' -and ($paramInJSONFormatArray[$index] -split ':')[1].Trim() -notmatch '".+"' -and $paramInJSONFormatArray[$index] -like '*.*') {
            # In case of a reference like : "virtualWanId": resourceGroupResources.outputs.virtualWWANResourceId
            $paramInJSONFormatArray[$index] = '{0}: "<{1}>"' -f ($paramInJSONFormatArray[$index] -split ':')[0], ([regex]::Match(($paramInJSONFormatArray[$index] -split ':')[0], '"(.+)"')).Captures.Groups[1].Value
        }
        if ($paramInJSONFormatArray[$index] -notlike '*:*' -and $paramInJSONFormatArray[$index] -notlike '*"*"*' -and $paramInJSONFormatArray[$index] -like '*.*') {
            # In case of a reference like : [ \n resourceGroupResources.outputs.managedIdentityPrincipalId \n ]
            $paramInJSONFormatArray[$index] = '"<{0}>"' -f $paramInJSONFormatArray[$index].Split('.')[-1].Trim()
        }
    }

    # [2.6] Syntax: Add comma everywhere unless:
    # - the current line has an opening 'object: {' or 'array: [' character
    # - the line after the current line has a closing 'object: {' or 'array: [' character
    # - it's the last closing bracket
    for ($index = 0; $index -lt $paramInJSONFormatArray.Count; $index++) {
        if (($paramInJSONFormatArray[$index] -match '[\{|\[]') -or (($index -lt $paramInJSONFormatArray.Count - 1) -and $paramInJSONFormatArray[$index + 1] -match '[\]|\}]') -or ($index -eq $paramInJSONFormatArray.Count - 1)) {
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

<#
.SYNOPSIS
Generate 'Deployment examples' for the ReadMe out of the parameter files currently used to test the template

.DESCRIPTION
Generate 'Deployment examples' for the ReadMe out of the parameter files currently used to test the template

.PARAMETER TemplateFilePath
Mandatory. The path to the template file

.PARAMETER TemplateFileContent
Mandatory. The template file content object to crawl data from

.PARAMETER TemplateFilePath
Mandatory. The path to the template file

.PARAMETER ReadMeFileContent
Mandatory. The readme file content array to update

.PARAMETER SectionStartIdentifier
Optional. The identifier of the 'outputs' section. Defaults to '## Deployment examples'

.PARAMETER addJson
Optional. A switch to control whether or not to add a ARM-JSON-Parameter file example. Defaults to true.

.PARAMETER addBicep
Optional. A switch to control whether or not to add a Bicep deployment example. Defaults to true.

.PARAMETER ProjectSettings
Optional. Projects settings to draw information from. For example the `namePrefix`.

.EXAMPLE
Set-DeploymentExamplesSection -TemplateFileContent @{ resource = @{}; ... } -TemplateFilePath 'C:/deploy.bicep' -ReadMeFileContent @('# Title', '', '## Section 1', ...)

Update the given readme file's 'Deployment Examples' section based on the given template file content
#>
function Set-DeploymentExamplesSection {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [string] $TemplateFilePath,

        [Parameter(Mandatory)]
        [hashtable] $TemplateFileContent,

        [Parameter(Mandatory = $true)]
        [object[]] $ReadMeFileContent,

        [Parameter(Mandatory = $false)]
        [bool] $addJson = $true,

        [Parameter(Mandatory = $false)]
        [bool] $addBicep = $true,

        [Parameter(Mandatory = $false)]
        [hashtable] $ProjectSettings = @{},

        [Parameter(Mandatory = $false)]
        [string] $SectionStartIdentifier = '## Deployment examples'
    )

    # Load used function(s)
    . (Join-Path (Split-Path $PSScriptRoot -Parent) 'pipelines' 'sharedScripts' 'Get-ModuleTestFileList.ps1')

    # Process content
    $SectionContent = [System.Collections.ArrayList]@(
        'The following module usage examples are retrieved from the content of the files hosted in the module''s `.test` folder.',
        '   >**Note**: The name of each example is based on the name of the file from which it is taken.',
        '   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.',
        ''
    )

    $moduleRoot = Split-Path $TemplateFilePath -Parent
    $resourceTypeIdentifier = $moduleRoot.Replace('\', '/').Split('/modules/')[1].TrimStart('/')
    $resourceType = $resourceTypeIdentifier.Split('/')[1]
    $testFilePaths = Get-ModuleTestFileList -ModulePath $moduleRoot | ForEach-Object { Join-Path $moduleRoot $_ }

    $RequiredParametersList = $TemplateFileContent.parameters.Keys | Where-Object { $TemplateFileContent.parameters[$_].Keys -notcontains 'defaultValue' } | Sort-Object

    ############################
    ##   Process test files   ##
    ############################
    $pathIndex = 1
    foreach ($testFilePath in $testFilePaths) {

        # Read content
        $rawContentArray = Get-Content -Path $testFilePath
        $rawContent = Get-Content -Path $testFilePath -Encoding 'utf8' | Out-String

        # Format example header
        if ((Split-Path (Split-Path $testFilePath -Parent) -Leaf) -ne '.test') {
            $exampleTitle = Split-Path (Split-Path $testFilePath -Parent) -Leaf
        } else {
            $exampleTitle = ((Split-Path $testFilePath -LeafBase) -replace '\.', ' ') -replace ' parameters', ''
        }
        $TextInfo = (Get-Culture).TextInfo
        $exampleTitle = $TextInfo.ToTitleCase($exampleTitle)
        $SectionContent += @(
            '<h3>Example {0}: {1}</h3>' -f $pathIndex, $exampleTitle
        )

        ## ----------------------------------- ##
        ##   Handle by type (Bicep vs. JSON)   ##
        ## ----------------------------------- ##
        if ((Split-Path $testFilePath -Extension) -eq '.bicep') {

            # ------------------------- #
            #   Prepare Bicep to JSON   #
            # ------------------------- #

            # [1/6] Search for the relevant parameter start & end index
            $bicepTestStartIndex = $rawContentArray.IndexOf("module testDeployment '../../deploy.bicep' = {")

            $bicepTestEndIndex = $bicepTestStartIndex
            do {
                $bicepTestEndIndex++
            } while ($rawContentArray[$bicepTestEndIndex] -ne '}')

            $rawBicepExample = $rawContentArray[$bicepTestStartIndex..$bicepTestEndIndex]

            # [2/6] Replace placeholders
            $serviceShort = ([regex]::Match($rawContent, "(?m)^param serviceShort string = '(.+)'\s*$")).Captures.Groups[1].Value

            $rawBicepExampleString = ($rawBicepExample | Out-String)
            $rawBicepExampleString = $rawBicepExampleString -replace '\$\{serviceShort\}', $serviceShort
            $rawBicepExampleString = $rawBicepExampleString -replace '\$\{namePrefix\}', '' # Replacing with empty to not expose prefix and avoid potential deployment conflicts
            $rawBicepExampleString = $rawBicepExampleString -replace '(?m):\s*location\s*$', ': ''<location>'''

            # [3/6] Format header, remove scope property & any empty line
            $rawBicepExample = $rawBicepExampleString -split '\n'
            $rawBicepExample[0] = "module $resourceType './$resourceTypeIdentifier/deploy.bicep = {"
            $rawBicepExample = $rawBicepExample | Where-Object { $_ -notmatch 'scope: *' } | Where-Object { -not [String]::IsNullOrEmpty($_) }

            # [4/6] Extract param block
            $rawBicepExampleArray = $rawBicepExample -split '\n'
            $moduleDeploymentPropertyIndent = ([regex]::Match($rawBicepExampleArray[1], '^(\s+).*')).Captures.Groups[1].Value.Length
            $paramsStartIndex = ($rawBicepExampleArray | Select-String ("^[\s]{$moduleDeploymentPropertyIndent}params:[\s]*\{") | ForEach-Object { $_.LineNumber - 1 })[0] + 1
            $paramsEndIndex = ($rawBicepExampleArray[($paramsStartIndex + 1)..($rawBicepExampleArray.Count)] | Select-String "^[\s]{$moduleDeploymentPropertyIndent}\}" | ForEach-Object { $_.LineNumber - 1 })[0] + $paramsStartIndex
            $paramBlock = ($rawBicepExampleArray[$paramsStartIndex..$paramsEndIndex] | Out-String).TrimEnd()

            # [5/6] Convert Bicep parameter block to JSON parameter block to enable processing
            $conversionInputObject = @{
                BicepParamBlock = $paramBlock
            }
            $paramsInJSONFormat = ConvertTo-FormattedJSONParameterObject @conversionInputObject

            # [6/6] Convert JSON parameters back to Bicep and order & format them
            $conversionInputObject = @{
                JSONParameters         = $paramsInJSONFormat
                RequiredParametersList = $RequiredParametersList
            }
            $bicepExample = ConvertTo-FormattedBicep @conversionInputObject

            # --------------------- #
            #   Add Bicep example   #
            # --------------------- #
            if ($addBicep) {

                $formattedBicepExample = $rawBicepExample[0..($paramsStartIndex - 1)] + ($bicepExample -split '\n') + $rawBicepExample[($paramsEndIndex + 1)..($rawBicepExample.Count)]

                $SectionContent += @(
                    '',
                    '<details>'
                    ''
                    '<summary>via Bicep module</summary>'
                    ''
                    '```bicep',
                    ($formattedBicepExample | ForEach-Object { "$_" }).TrimEnd(),
                    '```',
                    '',
                    '</details>',
                    '<p>'
                )
            }

            # -------------------- #
            #   Add JSON example   #
            # -------------------- #
            if ($addJson) {

                # [1/2] Get all parameters from the parameter object and order them recursively
                $orderingInputObject = @{
                    ParametersJSON         = $paramsInJSONFormat | ConvertTo-Json -Depth 99
                    RequiredParametersList = $RequiredParametersList
                }
                $orderedJSONExample = Build-OrderedJSONObject @orderingInputObject

                # [2/2] Create the final content block
                $SectionContent += @(
                    '',
                    '<details>'
                    ''
                    '<summary>via JSON Parameter file</summary>'
                    ''
                    '```json',
                    $orderedJSONExample.Trim()
                    '```',
                    '',
                    '</details>',
                    '<p>'
                )
            }
        } else {
            # ------------------------- #
            #   Prepare JSON to Bicep   #
            # ------------------------- #

            $rawContentHashtable = $rawContent | ConvertFrom-Json -Depth 99 -AsHashtable -NoEnumerate

            # First we need to check if we're dealing with classic JSON-Parameter file, or a deployment test file (which contains resource deployments & parameters)
            $isParameterFile = $rawContentHashtable.'$schema' -like '*deploymentParameters*'
            if (-not $isParameterFile) {
                # Case 1: Uses deployment test file (instead of parameter file).
                # [1/3]  Need to extract parameters. The taarget is to get an object which 1:1 represents a classic JSON-Parameter file (aside from KeyVault references)
                $testResource = $rawContentHashtable.resources | Where-Object { $_.name -like '*-test-*' }

                # [2/3] Build the full ARM-JSON parameter file
                $jsonParameterContent = [ordered]@{
                    '$schema'      = 'https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#'
                    contentVersion = '1.0.0.0'
                    parameters     = $testResource.properties.parameters
                }
                $jsonParameterContent = ($jsonParameterContent | ConvertTo-Json -Depth 99).TrimEnd()

                # [3/3]  Remove 'externalResourceReferences' that are generated for Bicep's 'existing' resource references. Removing them will make the file more readable
                $jsonParameterContentArray = $jsonParameterContent -split '\n'
                foreach ($row in ($jsonParameterContentArray | Where-Object { $_ -like '*reference(extensionResourceId*' })) {
                    $expectedValue = ([regex]::Match($row, '.+\[reference\(extensionResourceId.+\.(.+)\.value\]"')).Captures.Groups[1].Value
                    $toReplaceValue = ([regex]::Match($row, '"(\[reference\(extensionResourceId.+)"')).Captures.Groups[1].Value

                    $jsonParameterContent = $jsonParameterContent.Replace($toReplaceValue, ('<{0}>' -f $expectedValue))
                }
            } else {
                # Case 2: Uses ARM-JSON parameter file
                $jsonParameterContent = $rawContent.TrimEnd()
            }

            # --------------------- #
            #   Add Bicep example   #
            # --------------------- #
            if ($addBicep) {

                # [1/5] Get all parameters from the parameter object
                $JSONParametersHashTable = (ConvertFrom-Json $jsonParameterContent -AsHashtable -Depth 99).parameters

                # [2/5] Handle the special case of Key Vault secret references (that have a 'reference' instead of a 'value' property)
                # [2.1] Find all references and split them into managable objects
                $keyVaultReferences = $JSONParametersHashTable.Keys | Where-Object { $JSONParametersHashTable[$_].Keys -contains 'reference' }

                if ($keyVaultReferences.Count -gt 0) {
                    $keyVaultReferenceData = @()
                    foreach ($reference in $keyVaultReferences) {
                        $resourceIdElem = $JSONParametersHashTable[$reference].reference.keyVault.id -split '/'
                        $keyVaultReferenceData += @{
                            subscriptionId    = $resourceIdElem[2]
                            resourceGroupName = $resourceIdElem[4]
                            vaultName         = $resourceIdElem[-1]
                            secretName        = $JSONParametersHashTable[$reference].reference.secretName
                            parameterName     = $reference
                        }
                    }
                }

                # [2.2] Remove any duplicates from the referenced key vaults and build 'existing' Key Vault references in Bicep format from them.
                #        Also, add a link to the corresponding Key Vault 'resource' to each identified Key Vault secret reference
                $extendedKeyVaultReferences = @()
                $counter = 0
                foreach ($reference in ($keyVaultReferenceData | Sort-Object -Property 'vaultName' -Unique)) {
                    $counter++
                    $extendedKeyVaultReferences += @(
                        "resource kv$counter 'Microsoft.KeyVault/vaults@2019-09-01' existing = {",
                    ("  name: '{0}'" -f $reference.vaultName),
                    ("  scope: resourceGroup('{0}','{1}')" -f $reference.subscriptionId, $reference.resourceGroupName),
                        '}',
                        ''
                    )

                    # Add attribute for later correct reference
                    $keyVaultReferenceData | Where-Object { $_.vaultName -eq $reference.vaultName } | ForEach-Object {
                        $_['vaultResourceReference'] = "kv$counter"
                    }
                }

                # [3/5] Remove the 'value' property from each parameter
                #      If we're handling a classic ARM-JSON parameter file that includes replacing all 'references' with the link to one of the 'existing' Key Vault resources
                if ((ConvertFrom-Json $rawContent -Depth 99).'$schema' -like '*deploymentParameters*') {
                    # If handling a classic parameter file
                    $JSONParameters = (ConvertFrom-Json $rawContent -Depth 99 -AsHashtable -NoEnumerate).parameters
                    $JSONParametersWithoutValue = @{}
                    foreach ($parameterName in $JSONParameters.psbase.Keys) {
                        $keysOnLevel = $JSONParameters[$parameterName].Keys
                        if ($keysOnLevel.count -eq 1 -and $keysOnLevel -eq 'value') {
                            $JSONParametersWithoutValue[$parameterName] = $JSONParameters[$parameterName]['value']
                        } else {
                            # replace key vault references
                            $matchingTuple = $keyVaultReferenceData | Where-Object { $_.parameterName -eq $parameterName }
                            $JSONParametersWithoutValue[$parameterName] = "{0}.getSecret('{1}')" -f $matchingTuple.vaultResourceReference, $matchingTuple.secretName
                        }
                    }
                } else {
                    # If handling a test deployment file
                    $JSONParametersWithoutValue = @{}
                    foreach ($parameter in $JSONParametersHashTable.Keys) {
                        $JSONParametersWithoutValue[$parameter] = $JSONParametersHashTable.$parameter.value
                    }
                }

                # [4/5] Convert the JSON parameters to a Bicep parameters block
                $conversionInputObject = @{
                    JSONParameters         = $JSONParametersWithoutValue
                    RequiredParametersList = $null -ne $RequiredParametersList ? $RequiredParametersList : @()
                }
                $bicepExample = ConvertTo-FormattedBicep @conversionInputObject

                # [5/5] Create the final content block: That means
                # - the 'existing' Key Vault resources
                # - a 'module' header that mimics a module deployment
                # - all parameters in Bicep format
                $SectionContent += @(
                    '',
                    '<details>'
                    ''
                    '<summary>via Bicep module</summary>'
                    ''
                    '```bicep',
                    $extendedKeyVaultReferences,
                    "module $resourceType './$resourceTypeIdentifier/deploy.bicep' = {"
                    "  name: '`${uniqueString(deployment().name)}-$resourceType'"
                    '  params: {'
                    $bicepExample.TrimEnd(),
                    '  }'
                    '}'
                    '```',
                    '',
                    '</details>'
                    '<p>'
                )
            }

            # -------------------- #
            #   Add JSON example   #
            # -------------------- #
            if ($addJson) {

                # [1/2] Get all parameters from the parameter object and order them recursively
                $orderingInputObject = @{
                    ParametersJSON         = (($jsonParameterContent | ConvertFrom-Json).parameters | ConvertTo-Json -Depth 99)
                    RequiredParametersList = $null -ne $RequiredParametersList ? $RequiredParametersList : @()
                }
                $orderedJSONExample = Build-OrderedJSONObject @orderingInputObject

                # [2/2] Create the final content block
                $SectionContent += @(
                    '',
                    '<details>',
                    '',
                    '<summary>via JSON Parameter file</summary>',
                    '',
                    '```json',
                    $orderedJSONExample.TrimEnd(),
                    '```',
                    '',
                    '</details>'
                    '<p>'
                )
            }
        }

        $SectionContent += @(
            ''
        )

        $pathIndex++
    }

    ######################
    ##   Built result   ##
    ######################
    if ($SectionContent) {
        if ($PSCmdlet.ShouldProcess('Original file with new template references content', 'Merge')) {
            return Merge-FileWithNewContent -oldContent $ReadMeFileContent -newContent $SectionContent -SectionStartIdentifier $SectionStartIdentifier
        }
    } else {
        return $ReadMeFileContent
    }
}

<#
.SYNOPSIS
Generate a table of content section for the given readme file

.DESCRIPTION
Generate a table of content section for the given readme file

.PARAMETER ReadMeFileContent
Mandatory. The readme file content array to update

.PARAMETER SectionStartIdentifier
Optional. The identifier of the 'navigation' section. Defaults to '## Navigation'

.EXAMPLE
Set-TableOfContent -ReadMeFileContent @('# Title', '', '## Section 1', ...)

Update the given readme's '## Navigation' section to reflect the latest file structure
#>
function Set-TableOfContent {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [object[]] $ReadMeFileContent,

        [Parameter(Mandatory = $false)]
        [string] $SectionStartIdentifier = '## Navigation'
    )

    $newSectionContent = [System.Collections.ArrayList]@()

    $contentPointer = 1
    while ($ReadMeFileContent[$contentPointer] -notlike '#*') {
        $contentPointer++
    }

    $headers = $ReadMeFileContent.Split('\n') | Where-Object { $_ -like '## *' }

    if ($headers -notcontains $SectionStartIdentifier) {
        $beforeContent = $ReadMeFileContent[0 .. ($contentPointer - 1)]
        $afterContent = $ReadMeFileContent[$contentPointer .. ($ReadMeFileContent.Count - 1)]

        $ReadMeFileContent = $beforeContent + @($SectionStartIdentifier, '') + $afterContent
    }

    $headers | Where-Object { $_ -ne $SectionStartIdentifier } | ForEach-Object {
        $newSectionContent += '- [{0}](#{1})' -f $_.Replace('#', '').Trim(), $_.Replace('#', '').Trim().Replace(' ', '-').Replace('.', '')
    }

    # Build result
    if ($PSCmdlet.ShouldProcess('Original file with new parameters content', 'Merge')) {
        $updatedFileContent = Merge-FileWithNewContent -oldContent $ReadMeFileContent -newContent $newSectionContent -SectionStartIdentifier $SectionStartIdentifier -contentType 'none'
    }

    return $updatedFileContent
}
#endregion

<#
.SYNOPSIS
Update/add the readme that matches the given template file

.DESCRIPTION
Update/add the readme that matches the given template file
Supports both ARM & bicep templates.

.PARAMETER TemplateFilePath
Mandatory. The path to the template to update

.PARAMETER TemplateFileContent
Optional. The template file content to process. If not provided, the template file content will be read from the TemplateFilePath file.
Using this property is useful if you already compiled the bicep template before invoking this function and want to avoid re-compiling it.

.PARAMETER ReadMeFilePath
Optional. The path to the readme to update. If not provided assumes a 'readme.md' file in the same folder as the template

.PARAMETER SectionsToRefresh
Optional. The sections to update. By default it refreshes all that are supported.
Currently supports: 'Resource Types', 'Parameters', 'Outputs', 'Template references'

.EXAMPLE
Set-ModuleReadMe -TemplateFilePath 'C:\deploy.bicep'

Update the readme in path 'C:\readme.md' based on the bicep template in path 'C:\deploy.bicep'

.EXAMPLE
Set-ModuleReadMe -TemplateFilePath 'C:/Microsoft.Network/loadBalancers/deploy.bicep' -SectionsToRefresh @('Parameters', 'Outputs')

Generate the Module ReadMe only for specific sections. Updates only the sections `Parameters` & `Outputs`. Other sections remain untouched.

.EXAMPLE
Set-ModuleReadMe -TemplateFilePath 'C:/Microsoft.Network/loadBalancers/deploy.bicep' -TemplateFileContent @{...}

(Re)Generate the readme file for template 'loadBalancer' based on the content provided in the TemplateFileContent parameter

.EXAMPLE
Set-ModuleReadMe -TemplateFilePath 'C:/Microsoft.Network/loadBalancers/deploy.bicep' -ReadMeFilePath 'C:/differentFolder'

Generate the Module ReadMe files into a specific folder path

.EXAMPLE
$templatePaths = (Get-ChildItem 'C:/Microsoft.Network' -Filter 'deploy.bicep' -Recurse).FullName
$templatePaths | ForEach-Object -Parallel { . '<PathToRepo>/utilities/tools/Set-ModuleReadMe.ps1' ; Set-ModuleReadMe -TemplateFilePath $_ }

Generate the Module ReadMe for any template in a folder path

.NOTES
The script autopopulates the Parameter Usage section of the ReadMe with the matching content in path './moduleReadMeSource'.
The content is added in case the given template has a parameter that matches the suffix of one of the files in that path.
To account for more parameter, just add another markdown file with the naming pattern 'resourceUsage-<parameterName>'
#>
function Set-ModuleReadMe {

    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory)]
        [string] $TemplateFilePath,

        [Parameter(Mandatory = $false)]
        [hashtable] $TemplateFileContent,

        [Parameter(Mandatory = $false)]
        [string] $ReadMeFilePath = (Join-Path (Split-Path $TemplateFilePath -Parent) 'readme.md'),

        [Parameter(Mandatory = $false)]
        [ValidateSet(
            'Resource Types',
            'Parameters',
            'Outputs',
            'Template references',
            'Navigation',
            'Deployment examples'
        )]
        [string[]] $SectionsToRefresh = @(
            'Resource Types',
            'Parameters',
            'Outputs',
            'Template references',
            'Navigation',
            'Deployment examples'
        )
    )

    # Load external functions
    . (Join-Path $PSScriptRoot 'helper/Merge-FileWithNewContent.ps1')
    . (Join-Path (Split-Path $PSScriptRoot -Parent) 'pipelines' 'sharedScripts' 'Get-NestedResourceList.ps1')

    # Check template & make full path
    $TemplateFilePath = Resolve-Path -Path $TemplateFilePath -ErrorAction Stop

    if (-not $TemplateFileContent) {

        if (-not (Test-Path $TemplateFilePath -PathType 'Leaf')) {
            throw "[$TemplateFilePath] is no valid file path."
        } else {
            if ((Split-Path -Path $TemplateFilePath -Extension) -eq '.bicep') {
                $templateFileContent = az bicep build --file $TemplateFilePath --stdout | ConvertFrom-Json -AsHashtable
            } else {
                $templateFileContent = ConvertFrom-Json (Get-Content $TemplateFilePath -Encoding 'utf8' -Raw) -ErrorAction Stop -AsHashtable
            }
        }
    }

    if (-not $templateFileContent) {
        throw "Failed to compile [$TemplateFilePath]"
    }

    $fullResourcePath = (Split-Path $TemplateFilePath -Parent).Replace('\', '/').split('/modules/')[1]

    $root = (Get-Item $PSScriptRoot).Parent.Parent.FullName
    $projectSettingsPath = Join-Path $root 'settings.json'
    if (Test-Path $projectSettingsPath) {
        $projectSettings = Get-Content $projectSettingsPath | ConvertFrom-Json -AsHashtable
    } else {
        Write-Warning "No settings file found in path [$projectSettingsPath]"
        $projectSettings = @{}
    }

    # Check readme
    if (-not (Test-Path $ReadMeFilePath) -or ([String]::IsNullOrEmpty((Get-Content $ReadMeFilePath -Raw)))) {
        # Create new readme file

        # Build resource name
        $serviceIdentifiers = $fullResourcePath.Replace('Microsoft.', '').Replace('/.', '/').Split('/')
        $serviceIdentifiers = $serviceIdentifiers | ForEach-Object { $_.substring(0, 1).toupper() + $_.substring(1) }
        $serviceIdentifiers = $serviceIdentifiers | ForEach-Object { $_ -creplace '(?<=\w)([A-Z])', '$1' }
        $assumedResourceName = $serviceIdentifiers -join ' '

        $initialContent = @(
            "# $assumedResourceName ``[$fullResourcePath]``",
            '',
            "This module deploys $assumedResourceName."
            '// TODO: Replace Resource and fill in description',
            ''
            '## Resource Types',
            '',
            '## Parameters',
            '',
            '### Parameter Usage: `<ParameterPlaceholder>`'
            ''
            '// TODO: Fill in Parameter usage'
            '',
            '## Outputs'
        )
        # New-Item $path $ReadMeFilePath -ItemType 'File' -Force -Value $initialContent
        $readMeFileContent = $initialContent
    } else {
        $readMeFileContent = Get-Content -Path $ReadMeFilePath -Encoding 'utf8'
    }

    # Update title
    if ($TemplateFilePath.Replace('\', '/') -like '*/modules/*') {

        if ($readMeFileContent[0] -notlike "*``[$fullResourcePath]``") {
            # Cut outdated
            $readMeFileContent[0] = $readMeFileContent[0].Split('`[')[0]

            # Add latest
            $readMeFileContent[0] = '{0} `[{1}]`' -f $readMeFileContent[0], $fullResourcePath
        }
        # Remove excess whitespace
        $readMeFileContent[0] = $readMeFileContent[0] -replace '\s+', ' '
    }

    if ($SectionsToRefresh -contains 'Resource Types') {
        # Handle [Resource Types] section
        # ===============================
        $inputObject = @{
            ReadMeFileContent   = $readMeFileContent
            TemplateFileContent = $templateFileContent
        }
        $readMeFileContent = Set-ResourceTypesSection @inputObject
    }

    if ($SectionsToRefresh -contains 'Parameters') {
        # Handle [Parameters] section
        # ===========================
        $inputObject = @{
            ReadMeFileContent   = $readMeFileContent
            TemplateFileContent = $templateFileContent
            currentFolderPath   = (Split-Path $TemplateFilePath -Parent)
        }
        $readMeFileContent = Set-ParametersSection @inputObject
    }

    if ($SectionsToRefresh -contains 'Outputs') {
        # Handle [Outputs] section
        # ========================
        $inputObject = @{
            ReadMeFileContent   = $readMeFileContent
            TemplateFileContent = $templateFileContent
        }
        $readMeFileContent = Set-OutputsSection @inputObject
    }

    $isTopLevelModule = $TemplateFilePath.Replace('\', '/').Split('/modules/')[1].Split('/').Count -eq 3 # <provider>/<resourceType>/deploy.*
    if ($SectionsToRefresh -contains 'Deployment examples' -and $isTopLevelModule) {
        # Handle [Deployment examples] section
        # ===================================
        $inputObject = @{
            ReadMeFileContent   = $readMeFileContent
            TemplateFilePath    = $TemplateFilePath
            TemplateFileContent = $templateFileContent
            ProjectSettings     = $projectSettings
        }
        $readMeFileContent = Set-DeploymentExamplesSection @inputObject
    }

    if ($SectionsToRefresh -contains 'Navigation') {
        # Handle [Navigation] section
        # ===================================
        $inputObject = @{
            ReadMeFileContent = $readMeFileContent
        }
        $readMeFileContent = Set-TableOfContent @inputObject
    }

    Write-Verbose 'New content:'
    Write-Verbose '============'
    Write-Verbose ($readMeFileContent | Out-String)

    if ($PSCmdlet.ShouldProcess("File in path [$ReadMeFilePath]", 'Overwrite')) {
        Set-Content -Path $ReadMeFilePath -Value $readMeFileContent -Force -Encoding 'utf8'
        Write-Verbose "File [$ReadMeFilePath] updated" -Verbose
    }
}
