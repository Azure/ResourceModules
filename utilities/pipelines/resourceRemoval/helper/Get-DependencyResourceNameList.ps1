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

    $parameterFolders = Get-ChildItem -Path $dependencyParameterPath -Recurse -Filter 'parameters' -Directory
    # $parameterFilePaths = @()
    $parameterFilePaths = [System.Collections.ArrayList]@()
    foreach ($parameterFolderPath in $parameterFolders.FullName) {
        $parameterFilePaths += Get-ChildItem -Path $parameterFolderPath -Recurse -Filter '*.json'
    }

    # Replace tokens in dependency parameter files
    $Settings = Get-Content -Path (Join-Path $repoRootPath 'settings.json') | ConvertFrom-Json -AsHashtable

    # Add local tokens
    if ($Settings.parameterFileTokens.localTokens) {
        $tokenMap = @{}
        foreach ($token in $Settings.parameterFileTokens.localTokens) {
            $tokenMap += @{ $token.name = $token.value }
        }
        Write-Verbose ('Using local tokens [{0}]' -f ($tokenMap.Keys -join ', '))

        $ConvertTokensInputs = @{
            Tokens      = $tokenMap
            TokenPrefix = $Settings.parameterFileTokens.tokenPrefix
            TokenSuffix = $Settings.parameterFileTokens.tokenSuffix
            Verbose     = $false
        }
        $null = $parameterFilePaths | Convert-TokensInFileList @ConvertTokensInputs
    }

    $dependencyResourceNames = [System.Collections.ArrayList]@()
    foreach ($parameterFilePath in $parameterFilePaths) {
        $paramFileContent = ConvertFrom-Json (Get-Content -Path $parameterFilePath -Raw)
        if ($nameParam = $paramFileContent.parameters.name.value) {
            $dependencyResourceNames += $nameParam
        }
    }

    if ($Settings.parameterFileTokens.localTokens) {
        Write-Verbose 'Restoring Tokens'
        $ConvertTokensInputs += @{
            SwapValueWithName = $true
        }
        $null = $parameterFilePaths | Convert-TokensInFileList @ConvertTokensInputs
    }

    return $dependencyResourceNames
}
