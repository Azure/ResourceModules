<#
.SYNOPSIS
Extract the resource name from the provided module path's readme

.DESCRIPTION
Extract the resource name from the provided module path's readme

.PARAMETER path
Mandatory. The path to the module to process

.EXAMPLE
Get-ResourceModuleName -path 'C:\KeyVault'

Get the resource name defined in the KeyVault-Module's readme. E.g. 'Key Vault'
#>
function Get-ResourceModuleName {

    [CmdletBinding()]
    [OutputType('System.String')]
    param (
        [Parameter(Mandatory)]
        [string] $Path
    )

    if (-not (Test-Path "$Path/readme.md")) {
        Write-Warning "No [readme.md] found in folder [$Path]"
        return ''
    }

    $moduleReadMeContent = Get-Content -Path "$Path/readme.md"
    $moduleName = $moduleReadMeContent[0].TrimStart('# ').Split('`')[0].Trim()

    if (-not [String]::IsNullOrEmpty($moduleName)) {
        return $moduleName
    } else {
        return ''
    }
}
