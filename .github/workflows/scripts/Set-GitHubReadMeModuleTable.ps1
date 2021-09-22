function Set-GitHubReadMeModuleTable {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $filePath,

        [Parameter(Mandatory)]
        [string] $modulesPath,

        [Parameter(Mandatory)]
        [string] $repositoryName,

        [Parameter(Mandatory)]
        [string] $organization,

        [Parameter(Mandatory)]
        [string[]] $columnsInOrder
    )

    # Load functions
    . (Join-Path $PSScriptRoot 'Get-ModulesAsMarkdownTable.ps1')

    # Logic
    Write-Verbose "Processing path [$filePath]" -Verbose
    
    $contentArray = Get-Content -Path $filePath
    $startIndex = [array]::IndexOf($contentArray, '<!-- ModuleTableStartMarker -->')
    $endIndex = [array]::IndexOf($contentArray, '<!-- ModuleTableEndMarker -->')

    $startContent = $contentArray[0..$startIndex] 
    $endContent = $contentArray[$endIndex..$contentArray.Count] # | Out-String

    $tableStringInputObject = @{
        Path           = $modulesPath
        RepositoryName = $repositoryName 
        Organization   = $organization 
        ColumnsInOrder = $columnsInOrder
    }
    $tableString = Get-ModulesAsMarkdownTable @tableStringInputObject

    $res = $startContent + $tableString + $endContent
    $res

}
$input = @{
    modulesPath    = 'C:\dev\ip\Azure-Modules\ResourceModules\arm' 
    filePath       = 'C:\dev\ip\Azure-Modules\ResourceModules\arm\README.md' 
    repositoryName = 'ResourceModules' 
    organization   = 'Azure' 
    columnsInOrder = @('Name', 'ProviderNamespace','ResourceType','TemplateType')
}
# Set-GitHubReadMeModuleTable @input

$input = @{
    modulesPath    = 'C:\dev\ip\Azure-Modules\ResourceModules\arm' 
    filePath       = 'C:\dev\ip\Azure-Modules\ResourceModules\README.md' 
    repositoryName = 'ResourceModules' 
    organization   = 'Azure' 
    columnsInOrder = @('Name', 'TemplateType', 'Status', 'Deploy')
}
Set-GitHubReadMeModuleTable @input