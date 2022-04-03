<#
.SYNOPSIS
Get the relative file paths of all parameter files in the given module

.DESCRIPTION
Get the relative file paths of all parameter files in the given module.
We return the relative instead of the full-path to make paths easier to read in the pipeline.

.PARAMETER ModulePath
Mandatory. The module path to search in

.EXAMPLE
Get-ModuleParameterFiles -ModulePath 'C:\ResourceModules\arm\Microsoft.Compute\virtualMachines'

Returns the relative file paths of all parameter files of the virtual machines module.
#>
function Get-ModuleParameterFiles {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $ModulePath
    )

    $parameterFilePaths = (Get-ChildItem -Path $ModulePath -Filter '*parameters.json' -Recurse).FullName | ForEach-Object {
        $_.Replace("$ModulePath", '').Trim('\').Trim('/')
    }

    Write-Verbose 'Found parameter files'
    $parameterFilePaths | ForEach-Object { Write-Verbose "- $_" }

    return $parameterFilePaths
}
