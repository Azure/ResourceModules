<#
.SYNOPSIS
Update the given ReadMe file with the latest module table

.DESCRIPTION
Update the given ReadMe file with the latest module table.
You can specify the columns to be generated.

.PARAMETER FilePath
Mandatory. The path to the ReadMe file to update

.PARAMETER ModulesPath
Mandatory. The path to the modules folder to process

.PARAMETER RepositoryName
Mandatory. The name of the repository the modules are in (required to generate the correct links)

.PARAMETER Organization
Mandatory. The name of the Organization the modules are in (required to generate the correct links)

.PARAMETER ProjectName
Mandatory. The name of the Azure DevOps project the pipelines are in (required to generate the correct links) - in case Azure DevOps is used

.PARAMETER Environment
Mandatory. The environment to generate the badges for (either Azure DevOps - or GitHub)

.PARAMETER ColumnsInOrder
Mandatory. The set of columns to add to the table in the order you expect them in the table.
Available are 'Name', 'ProviderNamespace', 'ResourceType', 'TemplateType', 'Deploy' & 'Status'

.EXAMPLE
Set-ReadMeModuleTable -FilePath 'C:\README.md' -ModulesPath 'C:\modules' -RepositoryName 'ResourceModules' -Organization 'Azure' -ColumnsInOrder @('Name','Status')

Update the defined table section in the 'README.md' file with a table that has the columns 'Name' & 'Status'
#>
function Set-ReadMeModuleTable {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [string] $FilePath,

        [Parameter(Mandatory = $true)]
        [string] $ModulesPath,

        [Parameter(Mandatory = $true)]
        [string] $RepositoryName,

        [Parameter(Mandatory = $true)]
        [string] $Organization,

        [Parameter(Mandatory = $false)]
        [ValidateSet('Name', 'ProviderNamespace', 'ResourceType', 'TemplateType', 'Deploy', 'Status')]
        [string[]] $ColumnsInOrder = @('Name', 'ProviderNamespace', 'ResourceType'),

        [Parameter(Mandatory = $false)]
        [string] $SortByColumn = 'ProviderNamespace',

        [Parameter(Mandatory = $true)]
        [ValidateSet('GitHub', 'ADO')]
        [string] $Environment,

        [Parameter(Mandatory = $false)]
        [string] $ProjectName = ''
    )

    # Load external functions
    $utilitiesRoot = Split-Path (Split-Path $PSScriptRoot)
    . (Join-Path $utilitiesRoot 'pipelines' 'sharedScripts' 'helper' 'Merge-FileWithNewContent.ps1')
    . (Join-Path $utilitiesRoot 'tools' 'helper' 'Get-ModulesAsMarkdownTable.ps1')

    # Logic
    $contentArray = Get-Content -Path $FilePath

    # Handle space in the projectname
    $urlEncodedProjectName = [uri]::EscapeDataString($ProjectName)

    $tableStringInputObject = @{
        Path           = $ModulesPath
        RepositoryName = $RepositoryName
        Organization   = $Organization
        ColumnsInOrder = $ColumnsInOrder
        SortByColumn   = $SortByColumn
        Environment    = $Environment
        ProjectName    = $urlEncodedProjectName
    }
    Write-Verbose ($tableStringInputObject | ConvertTo-Json | Out-String) -Verbose
    $tableString = Get-ModulesAsMarkdownTable @tableStringInputObject -Verbose

    $newContent = Merge-FileWithNewContent -oldContent $contentArray -newContent $tableString -sectionStartIdentifier '## Available Resource Modules' -contentType 'table'

    Write-Verbose 'New content:'
    Write-Verbose '============'
    Write-Verbose ($newContent | Out-String)

    if ($PSCmdlet.ShouldProcess("File in path [$FilePath]", 'Overwrite')) {
        Set-Content -Path $FilePath -Value $newContent -Force
        Write-Verbose "File [$FilePath] updated" -Verbose
    }
}
