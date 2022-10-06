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
            '',
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
