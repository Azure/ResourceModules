<#
.SYNOPSIS
Generate a table of content section for the given readme file

.DESCRIPTION
Generate a table of content section for the given readme file

.PARAMETER ReadMeFileContent
Mandatory. The readme file content array to update

.PARAMETER SectionStartIdentifier
Optional. The identifier of the 'navigation' section. Defaults to '## Navigation'

.EXAMPLE
Set-TableOfContent -ReadMeFileContent @('# Title', '', '## Section 1', ...)

Update the given readme's '## Navigation' section to reflect the latest file structure
#>
function Set-TableOfContent {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [object[]] $ReadMeFileContent,

        [Parameter(Mandatory = $false)]
        [string] $SectionStartIdentifier = '## Navigation'
    )

    $newSectionContent = [System.Collections.ArrayList]@()

    $contentPointer = 1
    while ($ReadMeFileContent[$contentPointer] -notlike '#*') {
        $contentPointer++
    }

    $headers = $ReadMeFileContent.Split('\n') | Where-Object { $_ -like '## *' }

    if ($headers -notcontains $SectionStartIdentifier) {
        $beforeContent = $ReadMeFileContent[0 .. ($contentPointer - 1)]
        $afterContent = $ReadMeFileContent[$contentPointer .. ($ReadMeFileContent.Count - 1)]

        $ReadMeFileContent = $beforeContent + @($SectionStartIdentifier, '') + $afterContent
    }

    $headers | Where-Object { $_ -ne $SectionStartIdentifier } | ForEach-Object {
        $newSectionContent += '- [{0}](#{1})' -f $_.Replace('#', '').Trim(), $_.Replace('#', '').Trim().Replace(' ', '-').Replace('.', '')
    }

    # Build result
    if ($PSCmdlet.ShouldProcess('Original file with new parameters content', 'Merge')) {
        $updatedFileContent = Merge-MarkdownFileWithNewContent -oldContent $ReadMeFileContent -newContent $newSectionContent -SectionStartIdentifier $SectionStartIdentifier -contentType 'none'
    }

    return $updatedFileContent
}
