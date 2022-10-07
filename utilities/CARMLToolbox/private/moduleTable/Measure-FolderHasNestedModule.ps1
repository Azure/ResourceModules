<#
.SYNOPSIS
Check for the existens of any nested module levels

.DESCRIPTION
Check for the existens of any nested module levels.
A module is identified by folders that do not contain module-specific folders such as '.test'.
In other words, a module would contain a folder with e.g. a '.test' folder and would hence not count towards the hierarchy of parent folders.

.PARAMETER path
Mandatory. The path to search in.

.EXAMPLE
Measure-FolderHasNestedModule -path 'C:\dev\ApiManagement'

Check if the path 'C:\dev\ApiManagement' contains any number of nested modules
#>
function Measure-FolderHasNestedModule {

    [CmdletBinding()]
    [OutputType('System.Boolean')]
    param (
        [Parameter(Mandatory)]
        [string] $Path
    )

    # Get all folder paths that exist in the given path as long as they are not '.bicep' or '.test' folders
    # This works as long as the folder structure is consistent (e.g. no empty folders are created etc.)
    $rawFoundFolders = Get-ChildItem $Path -Directory -Recurse -Exclude @('.bicep', '.test') -Force
    $foundFolders = $rawFoundFolders | Where-Object { (Get-ChildItem $_.FullName -Directory -Depth 0 -Include '.test' -Force).count -gt 0 }
    if ($foundFolders) {
        return $true
    } else {
        return $false
    }
}
