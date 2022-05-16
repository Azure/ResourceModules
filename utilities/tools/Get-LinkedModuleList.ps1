function Get-LinkedModuleList {

    [CmdletBinding()]
    param (
        [Parameter()]
        [string] $path = (Join-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) 'arm')
    )

    $resultSet = @{}

    $templatePaths = (Get-ChildItem -Path $path -Recurse -Filter '.bicep').FullName

    $templatePaths
}
Get-LinkedModuleList
