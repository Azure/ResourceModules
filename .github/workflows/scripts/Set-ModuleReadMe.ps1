#requires -version 6.0

function Get-NestedResourceList {

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
            $res += Get-NestedResource -TemplateFileContent $resource.properties.template
        } else {
            $res += Get-NestedResource -TemplateFileContent $resource
        }
    }
    return $res
}

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
        $newContent = @('', $sectionStartIdentifier) + $newContent
    } else {
        $endIndex = Get-EndIndex -ReadMeFileContent $oldContent -startIndex $startIndex
        $endContent = $oldContent[$endIndex..$oldContent.Count]
    }

    # Build result
    $newContent = (($startContent + $newContent + @('') + $endContent) | Out-String).TrimEnd().Replace("`r", '').Split("`n")
    return $newContent
}

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
        '| Parameter Name | Type | DefaultValue | Possible values | Description |',
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

    Write-Verbose 'New content:' -Verbose
    Write-Verbose '============' -Verbose
    Write-Verbose ($readMeFileContent | Out-String) -Verbose

    if ($PSCmdlet.ShouldProcess("File in path [$ReadMeFilePath]", 'Overwrite')) {
        Set-Content -Path $ReadMeFilePath -Value $readMeFileContent -Force
        Write-Verbose "File [$ReadMeFilePath] updated" -Verbose
    }
}
