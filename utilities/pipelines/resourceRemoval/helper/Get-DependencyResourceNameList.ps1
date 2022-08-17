<#
.SYNOPSIS
Get a list of all dependency resources specified in the dependencies parameter files

.DESCRIPTION
Get a list of all dependency resources specified in the dependencies parameter files
Note: It only considers resources that use the 'name' parameter

.PARAMETER DependencyParameterPath
Optional. The path the the dependency parameters parent folder. Defaults to 'utilities/pipelines/dependencies'

.EXAMPLE
Get-DependencyResourceNameList

Get the list of all dependency names from the current set of parameter files
#>
function Get-DependencyResourceNameList {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string] $DependencyParameterPath = (Join-Path (Get-Item $PSScriptRoot).Parent.Parent.FullName 'dependencies')
    )

    # Load used function
    $repoRootPath = (Get-Item $PSScriptRoot).Parent.Parent.Parent.Parent.FullName
    . (Join-Path $repoRootPath 'utilities' 'pipelines' 'tokensReplacement' 'Convert-TokensInFileList.ps1')

    # Get target files
    $parameterFolders = Get-ChildItem -Path $dependencyParameterPath -Recurse -Filter 'parameters' -Directory
    $parameterFilePaths = [System.Collections.ArrayList]@()
    foreach ($parameterFolderPath in $parameterFolders.FullName) {
        $parameterFilePaths += Get-ChildItem -Path $parameterFolderPath -Recurse -Filter '*.json'
    }

    # Replace tokens in dependency parameter files
    $GlobalVariablesObject = Get-Content -Path (Join-Path $repoRootPath 'settings.yml') | ConvertFrom-Yaml -ErrorAction Stop | Select-Object -ExpandProperty variables

    # Construct Token Configuration Input
    $tokenConfiguration = @{
        FilePathList = $parameterFilePaths
        Tokens       = @{}
        TokenPrefix  = $GlobalVariablesObject | Select-Object -ExpandProperty tokenPrefix
        TokenSuffix  = $GlobalVariablesObject | Select-Object -ExpandProperty tokenSuffix
        Verbose      = $false
    }

    $null = Convert-TokensInFileList @tokenConfiguration

    $dependencyResourceNames = [System.Collections.ArrayList]@()
    foreach ($parameterFilePath in $parameterFilePaths) {
        $paramFileContent = ConvertFrom-Json (Get-Content -Path $parameterFilePath -Raw)
        if ($nameParam = $paramFileContent.parameters.name.value) {
            $dependencyResourceNames += $nameParam
        }
    }

    if ($Settings.parameterFileTokens.localTokens) {
        Write-Verbose 'Restoring Tokens'
        $null = Convert-TokensInFileList @tokenConfiguration -SwapValueWithName $true
    }

    return $dependencyResourceNames
}
