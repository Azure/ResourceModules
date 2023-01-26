<#
.SYNOPSIS
Update the API Specs file in the given path

.DESCRIPTION
Update the API Specs file in the given path. The file contains an outline of all Provider Namespaces with their Resource Types and supported API versions.

.PARAMETER SpecsFilePath
Optional. The path the the file to create/overwrite. By default points to path '<root>/utilities/src/apiSpecsList.json'

.PARAMETER ModuleVersion
Optional. The module version of the AzureAPICrawler to install. Available versions at: https://www.powershellgallery.com/packages/AzureAPICrawler

.PARAMETER IncludePreview
Optional. A switch parameter to control whether or not to include Preview versions in the table

.PARAMETER IncludeExternalSources
Optional. A switch parameter to control whether or not to include versions of other sources (e.g., Get-AzResourceProvider) too

.EXAMPLE
Set-ApiSpecsFile -SpecsFilePath 'C:/dev/ResourceModules/utilities/src/apiSpecsList.json'

Update the file in path 'C:/dev/ResourceModules/utilities/src/apiSpecsList.json' with the latest API versions.
#>
function Set-ApiSpecsFile {

    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $false)]
        [string] $SpecsFilePath = (Join-Path (Split-Path (Split-Path $PSScriptRoot -Parent)) 'src' 'apiSpecsList.json'),

        [Parameter(Mandatory = $false)]
        [string] $ModuleVersion = '1.0.0',

        [Parameter(Mandatory = $false)]
        [switch] $IncludePreview,

        [Parameter(Mandatory = $false)]
        [switch] $IncludeExternalSources
    )

    # Install and or import module
    if (-not (Get-Module 'AzureAPICrawler' -ListAvailable)) {
        if ($PSCmdlet.ShouldProcess("Module 'AzureAPICrawler with version [$ModuleVersion]'", 'Install')) {
            $null = Install-Module 'AzureAPICrawler' -Scope 'CurrentUser' -Repository 'PSGallery' -RequiredVersion $ModuleVersion -Force
        }
    }

    $null = Import-Module 'AzureAPICrawler'

    # Fetch data
    $getInputObject = @{
        IncludePreview         = $IncludePreview
        IncludeExternalSources = $IncludeExternalSources
        Verbose                = $true
    }
    $res = Get-AzureApiSpecsVersionList @getInputObject
    $fileContent = $res | ConvertTo-Json

    # Set content
    if (-not (Test-Path $SpecsFilePath)) {
        if ($PSCmdlet.ShouldProcess('API Specs file [apiSpecsList.json]', 'Create')) {
            $null = New-Item -Path $SpecsFilePath -Value $fileContent -Force
        }
    } else {
        if ($PSCmdlet.ShouldProcess('API Specs file [apiSpecsList.json]', 'Update')) {
            $null = Set-Content -Path $SpecsFilePath -Value $fileContent -Force
        }
    }

    Write-Verbose 'Update complete'
}
