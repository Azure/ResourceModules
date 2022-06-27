<#
.SYNOPSIS
Get the relative file paths of all parameter files in the given module.

.DESCRIPTION
Get the relative file paths of all parameter files in the given module.
The relative path is returned instead of the full one to make paths easier to read in the pipeline.

.PARAMETER ModulePath
Mandatory. The module path to search in.

.EXAMPLE
Get-ModuleParameterFiles -ModulePath 'C:\ResourceModules\modules\Microsoft.Compute\virtualMachines'

Returns the relative file paths of all parameter files of the virtual machines module.
#>
function Get-ModuleParameterFiles {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $ModulePath
    )

    # Note: Should be 'recurse', but is not working with powershell 7.2.1 on GitHub hosted agents but needs 7.2.2
    # $parameterFilePaths = (Get-ChildItem -Recurse -Path $ModulePath -Filter '*parameters.json' -File).FullName

    $parameterFilePaths = (Get-ChildItem -Path "$ModulePath/.deploymentTests" -Filter '*parameters.json' -File).FullName

    if (-not $parameterFilePaths) {
        throw "No parameter files found for module [$ModulePath]"
    }

    $parameterFilePaths = $parameterFilePaths | ForEach-Object {
        $_.Replace($ModulePath, '').Trim('\').Trim('/')
    }

    Write-Verbose 'Found parameter files'
    $parameterFilePaths | ForEach-Object { Write-Verbose "- $_" }

    return $parameterFilePaths
}
