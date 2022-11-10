
<#
.SYNOPSIS
Update the module overview table in the given markdown file

.DESCRIPTION
Update the module overview table in the given markdown file

.PARAMETER markdownFilePath
Mandatory. The path to the markdown file to update.

.PARAMETER moduleFolderPath
Mandatory. The path to the modules folder.

.EXAMPLE
Set-ReadMeModuleTable -markdownFilePath './docs/wiki/The library - Module overview.md' -moduleFolderPath './modules'

Update the file 'The library - Module overview.md' based on the modules in path './modules'
#>
function Set-ModuleOverviewTable {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [string] $markdownFilePath,

        [Parameter(Mandatory = $true)]
        [string] $moduleFolderPath
    )

    # Load external functions
    $toolsRoot = Split-Path $PSScriptRoot -Parent
    . (Join-Path $toolsRoot 'helper' 'Merge-FileWithNewContent.ps1')
    . (Join-Path $toolsRoot 'Get-ModulesFeatureOutline.ps1')

    # Logic
    $originalContentArray = Get-Content -Path $markdownFilePath

    $functionInput = @{
        ModuleFolderPath = $moduleFolderPath
        ReturnMarkdown   = $true
        OnlyTopLevel     = $true
    }
    $featureTableString = Get-ModulesFeatureOutline @functionInput -Verbose

    $newContent = Merge-FileWithNewContent -oldContent $originalContentArray -newContent $featureTableString.TrimEnd() -sectionStartIdentifier '# Feature table' -contentType 'table'

    Write-Verbose 'New content:'
    Write-Verbose '============'
    Write-Verbose ($newContent | Out-String)

    if ($PSCmdlet.ShouldProcess("File in path [$markdownFilePath]", 'Overwrite')) {
        Set-Content -Path $markdownFilePath -Value $newContent -Force
        Write-Verbose "File [$markdownFilePath] updated" -Verbose
    }
}
