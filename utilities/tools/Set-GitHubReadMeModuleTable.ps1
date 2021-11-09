#region Helper functions

<#
.SYNOPSIS
Update the given ReadMe file with the latest module table

.DESCRIPTION
Update the given ReadMe file with the latest module table.
You can specify the columns to be generated.
Note that the ReadMe file should have the following lines right before & after the table to enable the replacement of the correct area:
- '<!-- ModuleTableStartMarker -->'
- '<!-- ModuleTableEndMarker -->'

.PARAMETER FilePath
Mandatory. The path to the ReadMe file to update

.PARAMETER ModulesPath
Mandatory. The path to the modules folder to process

.PARAMETER RepositoryName
Mandatory. The name of the repository the modules are in (required to generate the correct links)

.PARAMETER Organization
Mandatory. The name of the Organization the modules are in (required to generate the correct links)

.PARAMETER ColumnsInOrder
Mandatory. The set of columns to add to the table in the order you expect them in the table.
Available are 'Name', 'ProviderNamespace', 'ResourceType', 'TemplateType', 'Deploy' & 'Status'

.EXAMPLE
Set-GitHubReadMeModuleTable -FilePath 'C:\readme.md' -ModulesPath 'C:\arm' -RepositoryName 'ResourceModules' -Organization 'Azure' -ColumnsInOrder @('Name','Status')

Update the defined table section in the 'readme.md' file with a table that has the columns 'Name' & 'Status'
#>
function Set-GitHubReadMeModuleTable {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string] $FilePath,

        [Parameter(Mandatory)]
        [string] $ModulesPath,

        [Parameter(Mandatory)]
        [string] $RepositoryName,

        [Parameter(Mandatory)]
        [string] $Organization,

        [Parameter(Mandatory)]
        [ValidateSet('Name', 'ProviderNamespace', 'ResourceType', 'TemplateType', 'Deploy', 'Status')]
        [string[]] $ColumnsInOrder,

        [Parameter(Mandatory = $false)]
        [string] $SortByColumn = 'ProviderNamespace'
    )

    # Load external functions
    . (Join-Path $PSScriptRoot 'helper/Get-ModulesAsMarkdownTable.ps1')
    . (Join-Path $PSScriptRoot 'helper/Merge-FileWithNewContent.ps1')

    # Logic
    $contentArray = Get-Content -Path $FilePath

    $tableStringInputObject = @{
        Path           = $ModulesPath
        RepositoryName = $RepositoryName
        Organization   = $Organization
        ColumnsInOrder = $ColumnsInOrder
        SortByColumn   = $SortByColumn
    }
    $tableString = Get-ModulesAsMarkdownTable @tableStringInputObject

    $newContent = Merge-FileWithNewContent -oldContent $contentArray -newContent $tableString -sectionStartIdentifier '# Available Resource Modules'

    Write-Verbose 'New content:'
    Write-Verbose '============'
    Write-Verbose ($newContent | Out-String)

    if ($PSCmdlet.ShouldProcess("File in path [$FilePath]", 'Overwrite')) {
        Set-Content -Path $FilePath -Value $newContent -Force
        Write-Verbose "File [$FilePath] updated" -Verbose
    }
}
