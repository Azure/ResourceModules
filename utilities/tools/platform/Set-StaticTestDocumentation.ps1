#region helper
<#
.SYNOPSIS
Get an outline of all Pester test cases implemented in the given test file

.DESCRIPTION
Get an outline of all Pester test cases implemented in the given test file
The output is returned as Markdown

.PARAMETER TestFilePath
Mandatory. The path to the test file to get the content from.

.EXAMPLE
Get-TestsAsMarkdown -TestFilePath 'C:/ResourceModules/utilities/pipelines/staticValidation/module.tests.ps1'

Get an outline of all Pester tests implemented in the test file 'module.tests.ps1'
#>
function Get-TestsAsMarkdown {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $TestFilePath
    )

    $content = Get-Content $TestFilePath

    $relevantContent = [System.Collections.ArrayList]@()
    foreach ($line in $content) {
        if ($line -match "^\s*Describe '(.*?)'.*$") {
            $formatted = $Matches[1]
            $formatted = (($formatted -split '\s*\[<.+?>\]\s*') -join ' ').Trim()
            $relevantContent += "- **$formatted**"
        } elseif ( $line -match "^\s*Context '(.*?)'.*$" ) {
            $formatted = $Matches[1]
            $formatted = (($formatted -split '\s*\[<.+?>\]\s*') -join ' ').Trim()
            $relevantContent += "  - **$formatted**"
        } elseif ( $line -match "^\s*It '(.*?)'.*$" ) {
            $formatted = $Matches[1]
            $formatted = (($formatted -split '\s*\[<.+?>\]\s*') -join ' ').Trim()
            $relevantContent += "    1. $formatted"
        }
    }

    return $relevantContent
}
#endregion

<#
.SYNOPSIS
Update the current documentation in the given wiki file path with the latest test detail of the given test file path.

.DESCRIPTION
Update the current documentation in the given wiki file path with the latest test detail of the given test file path.

.PARAMETER TestFilePath
Mandatory. The path to the test file to get the content from.

.PARAMETER WikiFilePath
Mandatory. The path to the Wiki file to update the data in. It should contain a header '## Outline'

.EXAMPLE
Set-StaticTestDocumentation -TestFilePath 'C:/ResourceModules/utilities/pipelines/staticValidation/module.tests.ps1' -WikiFilePath 'C:/ResourceModules/docs/wiki/The CI environment - Static validation.md'

Update the section '## Outline' of Wiki file 'The CI environment - Static validation.md' with the content of the Pester test file 'module.tests.ps1'
#>
function Set-StaticTestDocumentation {

    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true)]
        [string] $TestFilePath,

        [Parameter(Mandatory = $true)]
        [string] $WikiFilePath
    )

    # Load external functions
    $utilitiesRoot = Split-Path (Split-Path $PSScriptRoot)
    . (Join-Path $utilitiesRoot 'pipelines' 'sharedScripts' 'helper' 'Merge-FileWithNewContent.ps1')

    # Logic
    $contentArray = Get-Content -Path $WikiFilePath

    $testOutline = Get-TestsAsMarkdown -TestFilePath $TestFilePath

    $newContent = Merge-FileWithNewContent -oldContent $contentArray -newContent $testOutline -sectionStartIdentifier '## Outline'

    Write-Verbose 'New content:'
    Write-Verbose '============'
    Write-Verbose ($newContent | Out-String)

    if ($PSCmdlet.ShouldProcess("File in path [$WikiFilePath]", 'Overwrite')) {
        Set-Content -Path $WikiFilePath -Value $newContent -Force
        Write-Verbose "File [$WikiFilePath] updated" -Verbose
    }
}
