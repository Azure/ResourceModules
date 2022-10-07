<#
.SYNOPSIS
Get a string that indicates whether there are ARM/Bicep templates available in the given path

.DESCRIPTION
Get a string that indicates whether there are ARM/Bicep templates available in the given path.
The string represents markdown table columns.
Files must follow the naming schema 'deploy.json' & 'deploy.bicep'

.PARAMETER path
Mandatory. The path to check for templates

.EXAMPLE
Get-TypeColumnString -path 'C:\MyModule'

May return a string like ':heavy_check_mark: | :heavy_check_mark: |' if both ARM & bicep templates are available in the given module path
#>
function Get-TypeColumnString {

    [CmdletBinding()]
    [OutputType('System.String')]
    param (
        [Parameter(Mandatory)]
        [string] $Path
    )

    $moduleFiles = Get-ChildItem -Path $Path -File -Force

    $outputString = ''

    if ($moduleFiles.Name -contains 'deploy.bicep') {
        # bicep exists
        $outputString += ':heavy_check_mark:'
    } else {
        $outputString += ''
    }

    return $outputString
}
