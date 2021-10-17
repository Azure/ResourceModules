#region Helper functions

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

    $tableStartIndex = $resourcesSectionStartIndex + 1
    while ($oldContent[$tableStartIndex] -notlike '*|*' -and -not ($tableStartIndex -ge $oldContent.count)) {
        $tableStartIndex++
    }

    $startContent = $oldContent[0..($tableStartIndex - 1)]

    $tableEndIndex = $tableStartIndex + 2
    while ($oldContent[$tableEndIndex] -like '|*' -and -not ($tableEndIndex -ge $oldContent.count)) {
        $tableEndIndex++
    }

    if ($startIndex -eq $ReadMeFileContent.Count - 1) {
        # Not found section until end of file. Assuming it does not exist
        $endContent = @()
        if ($ReadMeFileContent[$startIndex] -notcontains $sectionStartIdentifier) {
            $newContent = @('', $sectionStartIdentifier) + $newContent
        }
    } else {
        if ($tableEndIndex -ne $oldContent.Count - 1) {
            $endContent = $oldContent[$tableEndIndex..($oldContent.Count - 1)]
        }
    }

    # Build result
    $newContent = (($startContent + $newContent + @('') + $endContent) | Out-String).TrimEnd().Replace("`r", '').Split("`n")
    return $newContent
}
#endregion

<#
.SYNOPSIS
Update the given ReadMe file with the latest module table

.DESCRIPTION
Update the given ReadMe file with the latest module table.
You can specify the columns to be generated.
Note that the ReadMe file should have the following lines right before & after the table to enable the replacement of the correct area:
- '<!-- ModuleTableStartMarker -->'
- '<!-- ModuleTableEndMarker -->'

.PARAMETER filePath
Mandatory. The path to the ReadMe file to update

.PARAMETER modulesPath
Mandatory. The path to the modules folder to process

.PARAMETER repositoryName
Mandatory. The name of the repository the modules are in (required to generate the correct links)

.PARAMETER organization
Mandatory. The name of the organization the modules are in (required to generate the correct links)

.PARAMETER columnsInOrder
Mandatory. The set of columns to add to the table in the order you expect them in the table.
Available are 'Name', 'ProviderNamespace', 'ResourceType', 'TemplateType', 'Deploy' & 'Status'

.EXAMPLE
Set-GitHubReadMeModuleTable -filePath 'C:\readme.md' -modulesPath 'C:\arm' -repositoryName 'ResourceModules' -organization 'Azure' -columnsInOrder @('Name','Status')

Update the defined table section in the 'readme.md' file with a table that has the columns 'Name' & 'Status'
#>
function Set-GitHubReadMeModuleTable {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string] $filePath,

        [Parameter(Mandatory)]
        [string] $modulesPath,

        [Parameter(Mandatory)]
        [string] $repositoryName,

        [Parameter(Mandatory)]
        [string] $organization,

        [Parameter(Mandatory)]
        [ValidateSet('Name', 'ProviderNamespace', 'ResourceType', 'TemplateType', 'Deploy', 'Status')]
        [string[]] $columnsInOrder,

        [Parameter(Mandatory = $false)]
        [string] $sortByColumn = 'ProviderNamespace'
    )

    # Load functions
    . (Join-Path $PSScriptRoot 'Get-ModulesAsMarkdownTable.ps1')

    # Logic
    $contentArray = Get-Content -Path $filePath

    $tableStringInputObject = @{
        Path           = $modulesPath
        RepositoryName = $repositoryName
        Organization   = $organization
        ColumnsInOrder = $columnsInOrder
        sortByColumn   = $sortByColumn
    }
    $tableString = Get-ModulesAsMarkdownTable @tableStringInputObject

    $newContent = Merge-FileWithNewContent -oldContent $contentArray -newContent $tableString -sectionStartIdentifier '## Available Resource Modules'

    Write-Verbose 'New content:' -Verbose
    Write-Verbose '============' -Verbose
    Write-Verbose ($newContent | Out-String) -Verbose

    if ($PSCmdlet.ShouldProcess("File in path [$filePath]", 'Overwrite')) {
        Set-Content -Path $filePath -Value $newContent -Force
        Write-Verbose "File [$filePath] updated" -Verbose
    }
}
