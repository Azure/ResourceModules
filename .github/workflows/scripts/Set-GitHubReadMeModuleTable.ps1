function Set-GitHubReadMeModuleTable {

    [CmdletBinding(SupportsShouldProcess)]
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
    $contentArray = Get-Content -Path $filePath
    $startIndex = [array]::IndexOf($contentArray, '<!-- ModuleTableStartMarker -->')
    $endIndex = [array]::IndexOf($contentArray, '<!-- ModuleTableEndMarker -->')

    $startContent = $contentArray[0..$startIndex] 
    $endContent = $contentArray[$endIndex..$contentArray.Count]

    $tableStringInputObject = @{
        Path           = $modulesPath
        RepositoryName = $repositoryName 
        Organization   = $organization 
        ColumnsInOrder = $columnsInOrder
    }
    $tableString = Get-ModulesAsMarkdownTable @tableStringInputObject

    $newContent = (($startContent + $tableString + $endContent) | Out-String).TrimEnd()
    
    if ($PSCmdlet.ShouldProcess("File in path [$filePath]", "Overwrite")) {
        Set-Content -Path $filePath -Value $newContent -Force -NoNewLine
        Write-Verbse "File [$filePath] updated" -Verbose
    }
}