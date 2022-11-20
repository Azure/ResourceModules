function Set-ApiSpecsTable {

    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $false)]
        [string] $SpecsFilePath = (Join-Path (Split-Path (Split-Path $PSScriptRoot -Parent)) 'src' 'apiSpecsList.json')
    )

    if (-not (Get-Module 'AzureAPICrawler' -ListAvailable)) {
        if ($PSCmdlet.ShouldProcess("Module 'AzureAPICrawler with version [0.1.2]'", 'Install')) {
            $null = Install-Module 'AzureAPICrawler' -Scope 'CurrentUser' -Repository 'PSGallery' -RequiredVersion '0.1.2' -Force
        }
    }

    $null = Import-Module 'AzureAPICrawler'


    if (-not (Test-Path $SpecsFilePath)) {
        if ($PSCmdlet.ShouldProcess('API Specs file [apiSpecsList.json]', 'Create')) {
            Write-Verbose 'Generating new API Specs file'
            $null = New-Item -Path $SpecsFilePath -Force
        }
    }

    $res = Get-AzureApiSpecsVersionList -IncludePreview -Verbose

    $fileContent = $res | ConvertTo-Json

    if ($PSCmdlet.ShouldProcess('API Specs file [apiSpecsList.json]', 'Update')) {
        $null = Set-Item -Path $SpecsFilePath -Value $fileContent -Force
    }
}
