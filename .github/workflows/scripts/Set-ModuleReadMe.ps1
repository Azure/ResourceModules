#requires -version 6.0

#region Helper functions
<#
.SYNOPSIS
Get a list of all resources (provider + service) in the given template content

.DESCRIPTION
Get a list of all resources (provider + service) in the given template content. Crawls through any children & nested deployment templates.

.PARAMETER TemplateFileContent
Mandatory. The template file content object to crawl data from

.EXAMPLE
Get-NestedResourceList -TemplateFileContent @{ resource = @{}; ... }

Returns a list of all resources in the given template object
#>
function Get-NestedResourceList {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable] $TemplateFileContent
    )

    $res = @()
    $currLevelResources = @()
    if ($TemplateFileContent.resources) {
        $currLevelResources += $TemplateFileContent.resources
    }
    foreach ($resource in $currLevelResources) {
        $res += $resource

        if ($resource.type -eq 'Microsoft.Resources/deployments') {
            $res += Get-NestedResourceList -TemplateFileContent $resource.properties.template
        } else {
            $res += Get-NestedResourceList -TemplateFileContent $resource
        }
    }
    return $res
}

<#
.SYNOPSIS
Find the array index that represents the end of the current section

.DESCRIPTION
Find the array index that represents the end of the current section
This index is identified by iterating through the subsequent array positions until a new chapter character (#) is found

.PARAMETER ReadMeFileContent
Mandatory. The content array to search in

.PARAMETER startIndex
Mandatory. The index to start the search from. Should usually be the current section's header index

.EXAMPLE
Get-EndIndex -ReadMeFileContent @('# Title', '', '## Section 1', ...) -startIndex = 13

Start from index '13' onward for the index that concludes the current section in the given content array
#>
function Get-EndIndex {

    param(
        [Parameter(Mandatory)]
        [object[]] $ReadMeFileContent,

        [Parameter(Mandatory)]
        [int] $startIndex
    )

    # shift one further
    $endIndex = $startIndex + 1

    # Identify next section
    while (-not $ReadMeFileContent[$endIndex].StartsWith('#') -and -not ($endIndex -ge $readMeFileContent.Count - 1)) {
        $endIndex++
    }

    return $endIndex
}

<#
.SYNOPSIS
Merge the sections prior & after the updated content with the new content into on connected content array

.DESCRIPTION
Merge the sections prior & after the updated content with the new content into on connected content array

.PARAMETER oldContent
Mandatory. The original content to update

.PARAMETER newContent
Mandatory. The new content to merge into the original

.PARAMETER sectionStartIdentifier
Mandatory. The identifier/header to search for. If not found, the new section is added at the end of the content array

.EXAMPLE
Merge-FileWithNewContent -oldContent @('# Title', '', '## Section 1', ...) -newContent @('# Title', '', '## Section 1', ...) -sectionStartIdentifier '## Resource Types'

Update the original content of the '## Resource Types' section with the newly provided
#>
function Merge-FileWithNewContent {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [object[]] $oldContent,

        [Parameter(Mandatory)]
        [object[]] $newContent,

        [Parameter(Mandatory)]
        [string] $sectionStartIdentifier
    )

    $startIndex = 0
    while (-not ($oldContent[$startIndex] -like $sectionStartIdentifier) -and -not ($startIndex -ge $oldContent.Count - 1)) {
        $startIndex++
    }
    $startContent = $oldContent[0..$startIndex]

    if ($startIndex -eq $ReadMeFileContent.Count - 1) {
        # Not found section until end of file. Assuming it does not exist
        $endContent = @()
        if ($ReadMeFileContent[$startIndex] -notcontains $sectionStartIdentifier) {
            $newContent = @('', $sectionStartIdentifier) + $newContent
        }
    } else {
        $endIndex = Get-EndIndex -ReadMeFileContent $oldContent -startIndex $startIndex
        if ($endIndex -ne $oldContent.Count - 1) {
            $endContent = $oldContent[$endIndex..($oldContent.Count - 1)]
        }
    }

    # Build result
    $newContent = (($startContent + $newContent + @('') + $endContent) | Out-String).TrimEnd().Replace("`r", '').Split("`n")
    return $newContent
}

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

.PARAMETER sectionStartIdentifier
Optional. The identifier of the 'outputs' section. Defaults to '## Resource Types'

.PARAMETER resourceTypesToExclude
Optional. The resource types to exclude from the list. By default excludes 'Microsoft.Resources/deployments'

.EXAMPLE
Set-ResourceTypesSection -TemplateFileContent @{ resource = @{}; ... } -ReadMeFileContent @('# Title', '', '## Section 1', ...)

Update the given readme file's 'Resource Types' section based on the given template file content
#>
function Set-ResourceTypesSection {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [hashtable] $TemplateFileContent,

        [Parameter(Mandatory)]
        [object[]] $ReadMeFileContent,

        [Parameter(Mandatory = $false)]
        [string] $sectionStartIdentifier = '## Resource Types',

        [Parameter(Mandatory = $false)]
        [string[]] $resourceTypesToExclude = @('Microsoft.Resources/deployments')
    )

    # Process content
    $sectionContent = [System.Collections.ArrayList]@(
        '| Resource Type | Api Version |',
        '| :-- | :-- |'
    )

    $relevantResourceTypes = Get-NestedResourceList $TemplateFileContent | Where-Object {
        $_.type -notin $resourceTypesToExclude -and $_
    } | Select-Object 'Type', 'ApiVersion' -Unique | Sort-Object Type

    foreach ($resourceType in $relevantResourceTypes) {
        $sectionContent += ('| `{0}` | {1} |' -f $resourceType.type, $resourceType.apiVersion)
    }

    # Build result
    $updatedFileContent = Merge-FileWithNewContent -oldContent $ReadMeFileContent -newContent $sectionContent -sectionStartIdentifier $sectionStartIdentifier
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

.PARAMETER sectionStartIdentifier
Optional. The identifier of the 'outputs' section. Defaults to '## Parameters'

.EXAMPLE
Set-ParametersSection -TemplateFileContent @{ resource = @{}; ... } -ReadMeFileContent @('# Title', '', '## Section 1', ...)

Update the given readme file's 'Parameters' section based on the given template file content
#>
function Set-ParametersSection {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [hashtable] $TemplateFileContent,

        [Parameter(Mandatory)]
        [object[]] $ReadMeFileContent,

        [Parameter(Mandatory = $false)]
        [string] $sectionStartIdentifier = '## Parameters'
    )

    # Process content
    $sectionContent = [System.Collections.ArrayList]@(
        '| Parameter Name | Type | Default Value | Possible Values | Description |',
        '| :-- | :-- | :-- | :-- | :-- |'
    )

    foreach ($paramName in ($templateFileContent.parameters.Keys | Sort-Object)) {
        $param = $TemplateFileContent.parameters[$paramName]
        $type = $param.type
        $defaultValue = ($param.defaultValue -is [array]) ? ('[{0}]' -f ($param.defaultValue -join ', ')) : (($param.defaultValue -is [hashtable]) ? '{object}' : $param.defaultValue)
        $allowed = ($param.allowedValues -is [array]) ? ('[{0}]' -f ($param.allowedValues -join ', ')) : (($param.allowedValues -is [hashtable]) ? '{object}' : $param.allowedValues)
        $description = $param.metadata.description
        $sectionContent += ('| `{0}` | {1} | {2} | {3} | {4} |' -f $paramName, $type, (($defaultValue) ? "``$defaultValue``" : ''), (($allowed) ? "``$allowed``" : ''), $description)
    }

    # Build result
    $updatedFileContent = Merge-FileWithNewContent -oldContent $ReadMeFileContent -newContent $sectionContent -sectionStartIdentifier $sectionStartIdentifier
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

.PARAMETER sectionStartIdentifier
Optional. The identifier of the 'outputs' section. Defaults to '## Outputs'

.EXAMPLE
Set-OutputsSection -TemplateFileContent @{ resource = @{}; ... } -ReadMeFileContent @('# Title', '', '## Section 1', ...)

Update the given readme file's 'Outputs' section based on the given template file content
#>
function Set-OutputsSection {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [hashtable] $TemplateFileContent,

        [Parameter(Mandatory)]
        [object[]] $ReadMeFileContent,

        [Parameter(Mandatory = $false)]
        [string] $sectionStartIdentifier = '## Outputs'
    )

    # Process content
    $sectionContent = [System.Collections.ArrayList]@(
        '| Output Name | Type |',
        '| :-- | :-- |'
    )

    foreach ($outputName in ($templateFileContent.outputs.Keys | Sort-Object)) {
        $output = $TemplateFileContent.outputs[$outputName]
        $sectionContent += ("| ``{0}`` | {1} |" -f $outputName, $output.type)
    }

    # Build result
    $updatedFileContent = Merge-FileWithNewContent -oldContent $ReadMeFileContent -newContent $sectionContent -sectionStartIdentifier $sectionStartIdentifier
    return $updatedFileContent
}

<#
.SYNOPSIS
Update the 'Template references' section of the given readme file

.DESCRIPTION
Update the 'Template references' section of the given readme file
The section is added at the end if it does not exist

.PARAMETER TemplateFileContent
Mandatory. The template file content object to crawl data from

.PARAMETER ReadMeFileContent
Mandatory. The readme file content array to update

.PARAMETER sectionStartIdentifier
Optional. The identifier of the 'outputs' section. Defaults to '## Template references'

.PARAMETER resourceTypesToExclude
Optional. The resource types to exclude from the list. By default excludes 'Microsoft.Resources/deployments'

.EXAMPLE
Set-ResourceTypesSection -TemplateFileContent @{ resource = @{}; ... } -ReadMeFileContent @('# Title', '', '## Section 1', ...)

Update the given readme file's 'Template references' section based on the given template file content
#>
function Set-TemplateReferencesSection {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [hashtable] $TemplateFileContent,

        [Parameter(Mandatory)]
        [object[]] $ReadMeFileContent,

        [Parameter(Mandatory = $false)]
        [string] $sectionStartIdentifier = '## Template references',

        [Parameter(Mandatory = $false)]
        [string[]] $resourceTypesToExclude = @('Microsoft.Resources/deployments')
    )

    # Process content
    $sectionContent = [System.Collections.ArrayList]@()

    $relevantResourceTypes = Get-NestedResourceList $TemplateFileContent | Where-Object {
        $_.type -notin $resourceTypesToExclude -and $_ -and $_.type -notlike '*/providers/*'
    } | Select-Object 'Type', 'ApiVersion' -Unique | Sort-Object Type

    $TextInfo = (Get-Culture).TextInfo
    foreach ($resourceType in $relevantResourceTypes) {
        $Type, $Resource = $resourceType.Type -split '/', 2
        $sectionContent += ('- [{0}](https://docs.microsoft.com/en-us/azure/templates/{1}/{2}/{3})' -f $TextInfo.ToTitleCase($Resource), $Type, $resourceType.ApiVersion, $Resource)
    }

    # Build result
    $updatedFileContent = Merge-FileWithNewContent -oldContent $ReadMeFileContent -newContent $sectionContent -sectionStartIdentifier $sectionStartIdentifier
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

.PARAMETER ReadMeFilePath
Optional. The path to the readme to update. If not provided assumes a 'readme.md' file in the same folder as the template

.PARAMETER sectionsToRefresh
Optional. The sections to update. By default it refreshes all that are supported.
Currently supports: 'Resource Types', 'Parameters', 'Outputs', 'Template references'

.EXAMPLE
Set-ModuleReadMe -TemplateFilePath 'C:\deploy.bicep'

Update the readme in path 'C:\readme.md' based on the bicep template in path 'C:\deploy.bicep'
#>
function Set-ModuleReadMe {

    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory)]
        [string] $TemplateFilePath,

        [Parameter(Mandatory = $false)]
        [string] $ReadMeFilePath = (Join-Path (Split-Path $TemplateFilePath -Parent) 'readme.md'),

        [Parameter(Mandatory = $false)]
        [ValidateSet(
            'Resource Types',
            'Parameters',
            'Outputs',
            'Template references'
        )]
        [string[]] $sectionsToRefresh = @(
            'Resource Types',
            'Parameters',
            'Outputs',
            'Template references'
        )
    )

    # Check template
    $null = Test-Path $TemplateFilePath -ErrorAction Stop

    if ((Split-Path -Path $TemplateFilePath -Extension) -eq '.bicep') {
        $templateFileContent = az bicep build --file $TemplateFilePath --stdout | ConvertFrom-Json -AsHashtable
    } else {
        $templateFileContent = ConvertFrom-Json (Get-Content $TemplateFilePath -Raw) -ErrorAction Stop -AsHashtable
    }

    # Check readme
    if (-not (Test-Path $ReadMeFilePath)) {
        # Create new readme file

        # Build resource name
        $TextInfo = (Get-Culture).TextInfo
        $serviceIdentifiers = (Split-Path $TemplateFilePath -Parent).Replace('\', '/').split('/arm/')[1].Replace('Microsoft.', '').Split('/') | ForEach-Object { $TextInfo.ToTitleCase($_) }
        $assumedResourceName = $serviceIdentifiers -join ''

        $initialContent = @(
            "# $assumedResourceName",
            '',
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
            '## Outputs',
            '',
            '## Template references'
        )
        # New-Item $path $ReadMeFilePath -ItemType 'File' -Force -Value $initialContent
        $readMeFileContent = $initialContent
    } else {
        $readMeFileContent = Get-Content -Path $ReadMeFilePath
    }

    # Update title
    $fullResourcePath = (Split-Path $TemplateFilePath -Parent).Replace('\', '/').Split('arm/')[1]
    if ($readMeFileContent[0] -notlike "*$fullResourcePath*") {
        $readMeFileContent[0] = '{0} `[{1}]`' -f $readMeFileContent[0], $fullResourcePath
    }

    if ($sectionsToRefresh -contains 'Resource Types') {
        # Handle [Resource Types] section
        # ===============================
        $inputObject = @{
            ReadMeFileContent   = $readMeFileContent
            TemplateFileContent = $templateFileContent
        }
        $readMeFileContent = Set-ResourceTypesSection @inputObject
    }

    if ($sectionsToRefresh -contains 'Parameters') {
        # Handle [Parameters] section
        # ===========================
        $inputObject = @{
            ReadMeFileContent   = $readMeFileContent
            TemplateFileContent = $templateFileContent
        }
        $readMeFileContent = Set-ParametersSection @inputObject
    }

    if ($sectionsToRefresh -contains 'Outputs') {
        # Handle [Outputs] section
        # ========================
        $inputObject = @{
            ReadMeFileContent   = $readMeFileContent
            TemplateFileContent = $templateFileContent
        }
        $readMeFileContent = Set-OutputsSection @inputObject
    }

    if ($sectionsToRefresh -contains 'Template references') {
        # Handle [TemplateReferences] section
        # ===================================
        $inputObject = @{
            ReadMeFileContent   = $readMeFileContent
            TemplateFileContent = $templateFileContent
        }
        $readMeFileContent = Set-TemplateReferencesSection @inputObject
    }

    Write-Verbose 'New content:'
    Write-Verbose '============'
    Write-Verbose ($readMeFileContent | Out-String)

    if ($PSCmdlet.ShouldProcess("File in path [$ReadMeFilePath]", 'Overwrite')) {
        Set-Content -Path $ReadMeFilePath -Value $readMeFileContent -Force
        Write-Verbose "File [$ReadMeFilePath] updated" -Verbose
    }
}
