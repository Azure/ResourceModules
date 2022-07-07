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
            $defaultValue = ($parameter.defaultValue -is [array]) ? ('[{0}]' -f ($parameter.defaultValue -join ', ')) : (($parameter.defaultValue -is [hashtable]) ? '{object}' : (($parameter.defaultValue -is [string]) -and ($parameter.defaultValue -notmatch '\[\w+\(.*\).*\]') ? '''' + $parameter.defaultValue + '''' : $parameter.defaultValue))
            $allowedValue = ($parameter.allowedValues -is [array]) ? ('[{0}]' -f ($parameter.allowedValues -join ', ')) : (($parameter.allowedValues -is [hashtable]) ? '{object}' : $parameter.allowedValues)
            $description = $parameter.metadata.description.Replace("`r`n", '<p>').Replace("`n", '<p>')

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
Generate 'Deployment examples' for the ReadMe out of the parameter files currently used to test the template

.DESCRIPTION
Generate 'Deployment examples' for the ReadMe out of the parameter files currently used to test the template

.PARAMETER TemplateFilePath
Mandatory. The path to the template file

.PARAMETER TemplateFileContent
Mandatory. The template file content object to crawl data from

.PARAMETER ReadMeFileContent
Mandatory. The readme file content array to update

.PARAMETER SectionStartIdentifier
Optional. The identifier of the 'outputs' section. Defaults to '## Deployment examples'

.PARAMETER addJson
Optional. A switch to control whether or not to add a ARM-JSON-Parameter file example. Defaults to true.

.PARAMETER addBicep
Optional. A switch to control whether or not to add a Bicep deployment example. Defaults to true.

.EXAMPLE
Set-DeploymentExamplesSection -TemplateFilePath 'C:/deploy.bicep' -TemplateFileContent @{ resource = @{}; ... } -ReadMeFileContent @('# Title', '', '## Section 1', ...)

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
        [string] $SectionStartIdentifier = '## Deployment examples'
    )

    # Load used function(s)
    . (Join-Path $PSScriptRoot 'helper' 'ConvertTo-OrderedHashtable.ps1')

    # Process content
    $SectionContent = [System.Collections.ArrayList]@()

    $moduleRoot = Split-Path $TemplateFilePath -Parent
    $resourceTypeIdentifier = $moduleRoot.Replace('\', '/').Split('/modules/')[1].TrimStart('/')
    $resourceType = $resourceTypeIdentifier.Split('/')[1]
    $parameterFiles = Get-ChildItem (Join-Path $moduleRoot '.test') -Filter '*parameters.json' -Recurse

    $requiredParameterNames = $TemplateFileContent.parameters.Keys | Where-Object { $TemplateFileContent.parameters[$_].Keys -notcontains 'defaultValue' }

    ############################
    ##   Process test files   ##
    ############################
    $pathIndex = 1
    foreach ($testFilePath in $parameterFiles.FullName) {
        $contentInJSONFormat = Get-Content -Path $testFilePath -Encoding 'utf8' | Out-String

        $exampleTitle = ((Split-Path $testFilePath -LeafBase) -replace '\.', ' ') -replace ' parameters', ''
        $TextInfo = (Get-Culture).TextInfo
        $exampleTitle = $TextInfo.ToTitleCase($exampleTitle)
        $SectionContent += @(
            '<h3>Example {0}: {1}</h3>' -f $pathIndex, $exampleTitle
        )

        if ($addBicep) {
            $JSONParametersHashTable = (ConvertFrom-Json $contentInJSONFormat -AsHashtable -Depth 99).parameters

            # Handle KeyVaut references
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

            # Handle VALUE references (i.e. remove them)
            $JSONParameters = (ConvertFrom-Json $contentInJSONFormat -Depth 99 -AsHashtable).parameters
            $JSONParametersWithoutValue = @{}
            foreach ($parameterName in $JSONParameters.Keys) {
                if ($JSONParameters[$parameterName].Keys -eq 'value') {
                    $JSONParametersWithoutValue[$parameterName] = $JSONParameters[$parameterName]['value']
                } else {
                    # replace key vault references
                    $matchingTuple = $keyVaultReferenceData | Where-Object { $_.parameterName -eq $parameterName }
                    $JSONParametersWithoutValue[$parameterName] = "{0}.getSecret('{1}')" -f $matchingTuple.vaultResourceReference, $matchingTuple.secretName
                }
            }

            # Order parameters recursively
            $JSONParametersWithoutValue = ConvertTo-OrderedHashtable -JSONInputObject ($JSONParametersWithoutValue | ConvertTo-Json -Depth 99)

            # Sort 'required' parameters to the front
            $orderedJSONParameters = [ordered]@{}
            $orderedTopLevelParameterNames = $JSONParametersWithoutValue.psbase.Keys # We must use PS-Base to handle conflicts of HashTable properties & keys (e.g. for a key 'keys').
            # Add required parameters first
            $orderedTopLevelParameterNames | Where-Object { $_ -in $requiredParameterNames } | ForEach-Object { $orderedJSONParameters[$_] = $JSONParametersWithoutValue[$_] }
            # Add rest after
            $orderedTopLevelParameterNames | Where-Object { $_ -notin $requiredParameterNames } | ForEach-Object { $orderedJSONParameters[$_] = $JSONParametersWithoutValue[$_] }

            if ($orderedJSONParameters.count -eq 0) {
                # Handle empty dictionaries (in case the parmaeter file was empty)
                $orderedJSONParameters = @{}
            }

            ## TODO: Add comment 'Required parameters' vs 'Non-required parameters'

            $templateParameterObject = $orderedJSONParameters | ConvertTo-Json -Depth 99
            if ($templateParameterObject -ne '{}') {
                $contentInBicepFormat = $templateParameterObject -replace '"', "'" # Update any [xyz: "xyz"] to [xyz: 'xyz']
                $contentInBicepFormat = $contentInBicepFormat -replace ',', '' # Update any [xyz: xyz,] to [xyz: xyz]
                $contentInBicepFormat = $contentInBicepFormat -replace "'(\w+)':", '$1:' # Update any  ['xyz': xyz] to [xyz: xyz]
                $contentInBicepFormat = $contentInBicepFormat -replace "'(.+.getSecret\('.+'\))'", '$1' # Update any  [xyz: 'xyz.GetSecret()'] to [xyz: xyz.GetSecret()]

                $bicepParamsArray = $contentInBicepFormat -split '\n'
                $bicepParamsArray = $bicepParamsArray[1..($bicepParamsArray.count - 2)]
            }

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
                ($bicepParamsArray | ForEach-Object { "  $_" }).TrimEnd(),
                '  }'
                '}'
                '```',
                '',
                '</details>'
                '<p>'
            )
        }

        if ($addJson) {
            $orderedContentInJSONFormat = ConvertTo-OrderedHashtable -JSONInputObject (($contentInJSONFormat | ConvertFrom-Json).parameters | ConvertTo-Json -Depth 99)

            # Sort 'required' parameters to the front
            $orderedJSONParameters = [ordered]@{}
            $orderedTopLevelParameterNames = $orderedContentInJSONFormat.psbase.Keys # We must use PS-Base to handle conflicts of HashTable properties & keys (e.g. for a key 'keys').
            # Add required parameters first
            $orderedTopLevelParameterNames | Where-Object { $_ -in $requiredParameterNames } | ForEach-Object { $orderedJSONParameters[$_] = $orderedContentInJSONFormat[$_] }
            # Add rest after
            $orderedTopLevelParameterNames | Where-Object { $_ -notin $requiredParameterNames } | ForEach-Object { $orderedJSONParameters[$_] = $orderedContentInJSONFormat[$_] }

            if ($orderedJSONParameters.count -eq 0) {
                # Handle empty dictionaries (in case the parmaeter file was empty)
                $orderedJSONParameters = ''
            }

            $jsonExample = ([ordered]@{
                    '$schema'      = 'https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#'
                    contentVersion = '1.0.0.0'
                    parameters     = (-not [String]::IsNullOrEmpty($orderedJSONParameters)) ? $orderedJSONParameters : @{}
                } | ConvertTo-Json -Depth 99)

            ## TODO: Add comment 'Required parameters' vs 'Non-required parameters'
            if ($requiredParameterNames -is [string]) {
                $requiredParameterNames = @($requiredParameterNames)
            }
            if ($requiredParameterNames.Count -ge 1 && $orderedJSONParameters.Count -ge 2) {
                # If we have at least one required and one other parameter we want to add a comment
                $parameterToSplitAt = $requiredParameterNames[-1]


                $jsonExampleArray = $jsonExample -split '\n'
                $parameterStartIndex = $jsonExampleArray | Select-String '.*"parameters": \{.*' | ForEach-Object { $_.LineNumber - 1 }
                $requiredParameterStartIndex = $jsonExampleArray | Select-String ".*`"$parameterToSplitAt`": \{.*" | ForEach-Object { $_.LineNumber - 1 }
                $requiredParameterEndIndex = 0 # TODO: Search

                $jsonExampleArray = $jsonExampleArray[0..$parameterStartIndex] + '    // Required parameters' + $jsonExampleArray[(($parameterStartIndex + 1) .. ($jsonExampleArray.Count))]
                $jsonExampleArray = $jsonExampleArray[0..$requiredParameterEndIndex] + '    // Non-required parameters' + $jsonExampleArray[(($requiredParameterEndIndex + 1) .. ($jsonExampleArray.Count))]
            }

            $SectionContent += @(
                '',
                '<details>',
                '',
                '<summary>via JSON Parameter file</summary>',
                '',
                '```json',
                $jsonExample,
                '```',
                '',
                '</details>'
                '<p>'
            )
            # $SectionContent += @(
            #     '',
            #     '<details>',
            #     '',
            #     '<summary>via JSON Parameter file</summary>',
            #     '',
            #     '```json',
            #     '{',
            #     '  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",',
            #     '  "contentVersion": "1.0.0.0",'
            #     '  "parameters": {'
            #     (-not [String]::IsNullOrEmpty($orderedJSONParameters)) ? ((($orderedJSONParameters | ConvertTo-Json -Depth 99) -split '\n') | ForEach-Object { "    $_" }).TrimEnd() : '',
            #     '  }',
            #     '}',
            #     '```',
            #     '',
            #     '</details>'
            #     '<p>'
            # )
        }

        $SectionContent += @(
            ''
        )

        $pathIndex++
    }

    # Build result
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
        [Hashtable] $TemplateFileContent,

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
        if ((Split-Path -Path $TemplateFilePath -Extension) -eq '.bicep') {
            $templateFileContent = az bicep build --file $TemplateFilePath --stdout --no-restore | ConvertFrom-Json -AsHashtable
        } else {
            $templateFileContent = ConvertFrom-Json (Get-Content $TemplateFilePath -Encoding 'utf8' -Raw) -ErrorAction Stop -AsHashtable
        }
    }

    if (-not $templateFileContent) {
        throw "Failed to compile [$TemplateFilePath]"
    }

    $fullResourcePath = (Split-Path $TemplateFilePath -Parent).Replace('\', '/').split('/modules/')[1]

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
