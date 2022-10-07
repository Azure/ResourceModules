#requires -version 6.0

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
            'CrossReferences',
            'Template references',
            'Navigation',
            'Deployment examples'
        )]
        [string[]] $SectionsToRefresh = @(
            'Resource Types',
            'Parameters',
            'Outputs',
            'CrossReferences',
            'Template references',
            'Navigation',
            'Deployment examples'
        )
    )

    # Check template & make full path
    $TemplateFilePath = Resolve-Path -Path $TemplateFilePath -ErrorAction Stop

    if (-not (Test-Path $TemplateFilePath -PathType 'Leaf')) {
        throw "[$TemplateFilePath] is no valid file path."
    }

    if (-not $TemplateFileContent) {
        if ((Split-Path -Path $TemplateFilePath -Extension) -eq '.bicep') {
            $templateFileContent = az bicep build --file $TemplateFilePath --stdout | ConvertFrom-Json -AsHashtable
        } else {
            $templateFileContent = ConvertFrom-Json (Get-Content $TemplateFilePath -Encoding 'utf8' -Raw) -ErrorAction Stop -AsHashtable
        }
    }

    if (-not $templateFileContent) {
        throw "Failed to compile [$TemplateFilePath]"
    }

    $moduleRoot = Split-Path $TemplateFilePath -Parent
    $fullModuleIdentifier = 'Microsoft.{0}' -f $moduleRoot.Replace('\', '/').split('/Microsoft.')[1]
    $isTopLevelModule = $fullModuleIdentifier.Split('/').Count -eq 2 # <provider>/<resourceType>

    # Check readme
    if (-not (Test-Path $ReadMeFilePath) -or ([String]::IsNullOrEmpty((Get-Content $ReadMeFilePath -Raw)))) {
        # Create new readme file

        # Build resource name
        $serviceIdentifiers = $fullModuleIdentifier.Replace('Microsoft.', '').Replace('/.', '/').Split('/')
        $serviceIdentifiers = $serviceIdentifiers | ForEach-Object { $_.substring(0, 1).toupper() + $_.substring(1) }
        $serviceIdentifiers = $serviceIdentifiers | ForEach-Object { $_ -creplace '(?<=\w)([A-Z])', '$1' }
        $assumedResourceName = $serviceIdentifiers -join ' '

        $initialContent = @(
            "# $assumedResourceName ``[$fullModuleIdentifier]``",
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
    if ($TemplateFilePath.Replace('\', '/') -like '*/deploy.*') {

        if ($readMeFileContent[0] -notlike "*``[$fullModuleIdentifier]``") {
            # Cut outdated
            $readMeFileContent[0] = $readMeFileContent[0].Split('`[')[0]

            # Add latest
            $readMeFileContent[0] = '{0} `[{1}]`' -f $readMeFileContent[0], $fullModuleIdentifier
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

    if ($SectionsToRefresh -contains 'CrossReferences') {
        # Handle [CrossReferences] section
        # ========================
        $inputObject = @{
            ModuleRoot           = $ModuleRoot
            FullModuleIdentifier = $fullModuleIdentifier
            ReadMeFileContent    = $readMeFileContent
            TemplateFileContent  = $templateFileContent
        }
        $readMeFileContent = Set-CrossReferencesSection @inputObject
    }

    if ($SectionsToRefresh -contains 'Deployment examples' -and $isTopLevelModule) {
        # Handle [Deployment examples] section
        # ===================================
        $inputObject = @{
            ModuleRoot           = $ModuleRoot
            FullModuleIdentifier = $fullModuleIdentifier
            ReadMeFileContent    = $readMeFileContent
            TemplateFileContent  = $templateFileContent
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
