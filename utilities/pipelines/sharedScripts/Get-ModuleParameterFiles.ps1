<#
.SYNOPSIS
Get the file paths of all parameter files in the given module

.DESCRIPTION
Get the file paths of all parameter files in the given module

.PARAMETER ModulePath
Mandatory. The module path to search in

.EXAMPLE
Get-ModuleParameterFiles -ModulePath 'C:\ResourceModules\arm\Microsoft.Compute\virtualMachines'

Returns the file paths of all parameter files of the virtual machines module.
#>
function Get-ModuleParameterFiles {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $ModulePath
    )

    $parameterFilePaths = (Get-ChildItem -Path (Join-Path $ModulePath '.parameters') -Filter '*.json').FullName

    Write-Verbose 'Found parameter files'
    $parameterFilePaths | ForEach-Object { Write-Verbose "- $_" }

    return $parameterFilePaths
}
