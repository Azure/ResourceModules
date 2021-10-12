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

.PARAMETER PAT
Optional. The PAT to push with to the target repository

.PARAMETER gitUserName
Optional. The username to push with to the target repository

.PARAMETER gitEmail
Optional. The email address to push with to the target repository

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
        [string] $sortByColumn = 'ProviderNamespace',

        [Parameter(Mandatory = $false)]
        [string] $PAT,

        [Parameter(Mandatory = $false)]
        [string] $gitUserName = 'CARMLPipelinePrincipal',

        [Parameter(Mandatory = $false)]
        [string] $gitEmail = 'CARML@microsoft.com'
    )

    # Load functions
    . (Join-Path $PSScriptRoot 'Get-ModulesAsMarkdownTable.ps1')

    # Logic
    $contentArray = Get-Content -Path $filePath
    $startIndex = [array]::IndexOf($contentArray, '<!-- ModuleTableStartMarker -->')
    $endIndex = [array]::IndexOf($contentArray, '<!-- ModuleTableEndMarker -->')

    $startContent = $contentArray[0..$startIndex]
    $endContent = $contentArray[$endIndex..$contentArray.Count]

    $tableStringInputObject = @{
        Path           = $modulesPath
        RepositoryName = $repositoryName
        Organization   = $organization
        ColumnsInOrder = $columnsInOrder
        sortByColumn   = $sortByColumn
    }
    $tableString = Get-ModulesAsMarkdownTable @tableStringInputObject

    $newContent = (($startContent + $tableString + $endContent) | Out-String).TrimEnd()

    if ($PSCmdlet.ShouldProcess("File in path [$filePath]", 'Overwrite')) {
        Set-Content -Path $filePath -Value $newContent -Force -NoNewline
        Write-Verbose "File [$filePath] updated" -Verbose
        Write-Verbose 'New content:' -Verbose
        Write-Verbose '============' -Verbose
        Write-Verbose ($newContent | Out-String) -Verbose
    }

    git config --global user.email $gitEmail
    git config --global user.name $gitUserName

    if (-not [String]::IsNullOrEmpty($PAT)) {
        git config --global user.token $PAT
    }

    git pull
    git add .
    git commit -m "Push updated Readme in path [$filePath]"
    git push
}
