<#
.SYNOPSIS
Update the API Specs file in the given path

.DESCRIPTION
Update the API Specs file in the given path. The file contains an outline of all Provider Namespaces with their Resource Types and supported API versions.

.PARAMETER SpecsFilePath
Optional. The path the the file to create/overwrite. By default points to path '<root>/utilities/src/apiSpecsList.json'

.EXAMPLE
Set-ApiSpecsFile -SpecsFilePath 'C:/dev/ResourceModules/utilities/src/apiSpecsList.json'

Update the file in path 'C:/dev/ResourceModules/utilities/src/apiSpecsList.json' with the latest API versions.
#>
function Set-ApiSpecsFile {

    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $false)]
        [string] $SpecsFilePath = (Join-Path (Split-Path (Split-Path $PSScriptRoot -Parent)) 'src' 'apiSpecsList.json')
    )

    # Install and or import module
    if (-not (Get-Module 'AzureAPICrawler' -ListAvailable)) {
        if ($PSCmdlet.ShouldProcess("Module 'AzureAPICrawler with version [0.1.2]'", 'Install')) {
            $null = Install-Module 'AzureAPICrawler' -Scope 'CurrentUser' -Repository 'PSGallery' -RequiredVersion '0.1.2' -Force
        }
    }

    $null = Import-Module 'AzureAPICrawler'

    # Fetch data
    $res = Get-AzureApiSpecsVersionList -IncludePreview -Verbose
    $fileContent = $res | ConvertTo-Json

    # Set content
    if (-not (Test-Path $SpecsFilePath)) {
        if ($PSCmdlet.ShouldProcess('API Specs file [apiSpecsList.json]', 'Create')) {
            $null = New-Item -Path $SpecsFilePath -Force -Value $fileContent
        }
    } else {
        if ($PSCmdlet.ShouldProcess('API Specs file [apiSpecsList.json]', 'Update')) {
            $null = Set-Content -Path $SpecsFilePath -Value $fileContent -Force
        }
    }

    Write-Verbose 'Update complete'
}
