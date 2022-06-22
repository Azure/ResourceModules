<#
.SYNOPSIS
Get the relative file paths of all parameter files in the given module.

.DESCRIPTION
Get the relative file paths of all parameter files in the given module.
The relative path is returned instead of the full one to make paths easier to read in the pipeline.

.PARAMETER ModulePath
Mandatory. The module path to search in.

.EXAMPLE
Get-DeploymentTestFileList -ModulePath 'C:\ResourceModules\arm\Microsoft.Compute\virtualMachines'

Returns the relative file paths of all parameter files of the virtual machines module.
#>
function Get-DeploymentTestFileList {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $ModulePath
    )

    $deploymentTests = @()
    if (Test-Path (Join-Path $ModulePath '.deploymentTests')) {
        $deploymentTests += (Get-ChildItem -Path (Join-Path $ModulePath '.deploymentTests') -Filter '*.bicep' -File).FullName
    }

    # Can be removed once all modules are migrated
    if (Test-Path (Join-Path $ModulePath '.parameters')) {
        $deploymentTests += (Get-ChildItem -Path (Join-Path $ModulePath '.parameters') -Include ('*parameters.json') -Recurse -File).FullName
    }

    if (-not $deploymentTests) {
        throw "No deployment test files found for module [$ModulePath]"
    }

    $deploymentTests = $deploymentTests | ForEach-Object {
        $_.Replace($ModulePath, '').Trim('\').Trim('/')
    }

    Write-Verbose 'Found parameter files'
    $deploymentTests | ForEach-Object { Write-Verbose "- $_" }

    return $deploymentTests
}
