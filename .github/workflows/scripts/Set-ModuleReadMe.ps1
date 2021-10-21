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
    $sectionContent = [System.Collections.ArrayList]@(
        '| Resource Type | Api Version |',
        '| :-- | :-- |'
    )

    $relevantResourceTypes = Get-NestedResourceList $TemplateFileContent | Where-Object {
        $_.type -notin $ResourceTypesToExclude -and $_
    } | Select-Object 'Type', 'ApiVersion' -Unique | Sort-Object Type

    foreach ($resourceType in $relevantResourceTypes) {
        $sectionContent += ('| `{0}` | {1} |' -f $resourceType.type, $resourceType.apiVersion)
    }

    # Build result
    if ($PSCmdlet.ShouldProcess('Original file with new resource type content', 'Merge')) {
        $updatedFileContent = Merge-FileWithNewContent -oldContent $ReadMeFileContent -newContent $sectionContent -SectionStartIdentifier $SectionStartIdentifier
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

.PARAMETER SectionStartIdentifier
Optional. The identifier of the 'outputs' section. Defaults to '## Parameters'

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

        [Parameter(Mandatory = $false)]
        [string] $SectionStartIdentifier = '## Parameters'
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
    if ($PSCmdlet.ShouldProcess('Original file with new parameters content', 'Merge')) {
        $updatedFileContent = Merge-FileWithNewContent -oldContent $ReadMeFileContent -newContent $sectionContent -SectionStartIdentifier $SectionStartIdentifier
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
        $sectionContent = [System.Collections.ArrayList]@(
            '| Output Name | Type | Description |',
            '| :-- | :-- | :-- |'
        )
        foreach ($outputName in ($templateFileContent.outputs.Keys | Sort-Object)) {
            $output = $TemplateFileContent.outputs[$outputName]
            $sectionContent += ("| ``{0}`` | {1} | {2} |" -f $outputName, $output.type, $output.metadata.description)
        }
    } else {
        $sectionContent = [System.Collections.ArrayList]@(
            '| Output Name | Type |',
            '| :-- | :-- |'
        )
        foreach ($outputName in ($templateFileContent.outputs.Keys | Sort-Object)) {
            $output = $TemplateFileContent.outputs[$outputName]
            $sectionContent += ("| ``{0}`` | {1} |" -f $outputName, $output.type)
        }
    }

    # Build result
    if ($PSCmdlet.ShouldProcess('Original file with new output content', 'Merge')) {
        $updatedFileContent = Merge-FileWithNewContent -oldContent $ReadMeFileContent -newContent $sectionContent -SectionStartIdentifier $SectionStartIdentifier
    }
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

.PARAMETER SectionStartIdentifier
Optional. The identifier of the 'outputs' section. Defaults to '## Template references'

.PARAMETER ResourceTypesToExclude
Optional. The resource types to exclude from the list. By default excludes 'Microsoft.Resources/deployments'

.EXAMPLE
Set-ResourceTypesSection -TemplateFileContent @{ resource = @{}; ... } -ReadMeFileContent @('# Title', '', '## Section 1', ...)

Update the given readme file's 'Template references' section based on the given template file content
#>
function Set-TemplateReferencesSection {

    [CmdletBinding(SupportsShouldProcess)]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'ResourceTypesToExclude', Justification = 'Variable used inside Where-Object block.')]
    param (
        [Parameter(Mandatory)]
        [hashtable] $TemplateFileContent,

        [Parameter(Mandatory)]
        [object[]] $ReadMeFileContent,

        [Parameter(Mandatory = $false)]
        [string] $SectionStartIdentifier = '## Template references',

        [Parameter(Mandatory = $false)]
        [string[]] $ResourceTypesToExclude = @('Microsoft.Resources/deployments')
    )

    # Process content
    $sectionContent = [System.Collections.ArrayList]@()

    $relevantResourceTypes = Get-NestedResourceList $TemplateFileContent | Where-Object {
        $_.type -notin $ResourceTypesToExclude -and $_ -and $_.type -notlike '*/providers/*'
    } | Select-Object 'Type', 'ApiVersion' -Unique | Sort-Object Type

    $TextInfo = (Get-Culture).TextInfo
    foreach ($resourceType in $relevantResourceTypes) {
        $Type, $Resource = $resourceType.Type -split '/', 2
        $sectionContent += ('- [{0}](https://docs.microsoft.com/en-us/azure/templates/{1}/{2}/{3})' -f $TextInfo.ToTitleCase($Resource), $Type, $resourceType.ApiVersion, $Resource)
    }

    # Build result
    if ($PSCmdlet.ShouldProcess('Original file with new template references content', 'Merge')) {
        $updatedFileContent = Merge-FileWithNewContent -oldContent $ReadMeFileContent -newContent $sectionContent -SectionStartIdentifier $SectionStartIdentifier -contentType 'list'
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

.PARAMETER ReadMeFilePath
Optional. The path to the readme to update. If not provided assumes a 'readme.md' file in the same folder as the template

.PARAMETER SectionsToRefresh
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
        [string[]] $SectionsToRefresh = @(
            'Resource Types',
            'Parameters',
            'Outputs',
            'Template references'
        )
    )

    # Load external functions
    . (Join-Path $PSScriptRoot 'helper/Merge-FileWithNewContent.ps1')

    # Check template
    $null = Test-Path $TemplateFilePath -ErrorAction Stop

    if ((Split-Path -Path $TemplateFilePath -Extension) -eq '.bicep') {
        $templateFileContent = az bicep build --file $TemplateFilePath --stdout | ConvertFrom-Json -AsHashtable
    } else {
        $templateFileContent = ConvertFrom-Json (Get-Content $TemplateFilePath -Encoding 'utf8' -Raw) -ErrorAction Stop -AsHashtable
    }

    # Check readme
    if (-not (Test-Path $ReadMeFilePath) -or ([String]::IsNullOrEmpty((Get-Content $ReadMeFilePath -Raw)))) {
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
        $readMeFileContent = Get-Content -Path $ReadMeFilePath -Encoding 'utf8'
    }

    # Update title
    $fullResourcePath = (Split-Path $TemplateFilePath -Parent).Replace('\', '/').Split('arm/')[1]
    if ($readMeFileContent[0] -notlike "*$fullResourcePath*") {
        $readMeFileContent[0] = '{0} `[{1}]`' -f $readMeFileContent[0], $fullResourcePath
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

    if ($SectionsToRefresh -contains 'Template references') {
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
        Set-Content -Path $ReadMeFilePath -Value $readMeFileContent -Force -Encoding 'utf8'
        Write-Verbose "File [$ReadMeFilePath] updated" -Verbose
    }
}
