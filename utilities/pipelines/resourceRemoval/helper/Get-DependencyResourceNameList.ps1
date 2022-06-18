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
    . (Join-Path $repoRootPath 'utilities' 'pipelines' 'tokensReplacement' 'Convert-TokensInFile.ps1')

    $parameterFolders = Get-ChildItem -Path $dependencyParameterPath -Recurse -Filter 'parameters' -Directory
    $parameterFilePaths = [System.Collections.ArrayList]@()
    foreach ($parameterFolderPath in $parameterFolders.FullName) {
        $parameterFilePaths += Get-ChildItem -Path $parameterFolderPath -Recurse -Filter '*.json'
    }

    # Replace tokens in dependency parameter files
    $GlobalVariablesObject = Get-Content -Path (Join-Path $PSScriptRoot '..\..\global.variables.yml') | ConvertFrom-Yaml -ErrorAction Stop | Select-Object -ExpandProperty variables

    # Construct Token Configuration Input
    $tokenConfiguration = @{
        Tokens      = @{}
        TokenPrefix = $GlobalVariablesObject | Select-Object -ExpandProperty tokenPrefix
        TokenSuffix = $GlobalVariablesObject | Select-Object -ExpandProperty tokenSuffix
    }

    ## Local Tokens from global.variables.yml
    foreach ($localToken in $GlobalVariablesObject.Keys | ForEach-Object { if ($PSItem.contains('localToken_')) { $PSItem } }) {
        $tokenConfiguration.Tokens[$localToken.Replace('localToken_', '')] = $GlobalVariablesObject.$localToken
    }
    $parameterFilePaths | ForEach-Object { $null = Convert-TokensInFile @tokenConfiguration -FilePath $_ }

    $dependencyResourceNames = [System.Collections.ArrayList]@()
    foreach ($parameterFilePath in $parameterFilePaths) {
        $paramFileContent = ConvertFrom-Json (Get-Content -Path $parameterFilePath -Raw)
        if ($nameParam = $paramFileContent.parameters.name.value) {
            $dependencyResourceNames += $nameParam
        }
    }

    Write-Verbose 'Restoring Tokens'
    $parameterFilePaths | ForEach-Object { $null = Convert-TokensInFile @tokenConfiguration -FilePath $_ -SwapValueWithName $true }

    return $dependencyResourceNames
}
