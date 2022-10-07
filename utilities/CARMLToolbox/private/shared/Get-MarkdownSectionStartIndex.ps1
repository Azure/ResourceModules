<#
.SYNOPSIS
Find the array index that represents the start of a markdown section

.DESCRIPTION
Find the array index that represents the start of a markdown section (i.e., # (...))

.PARAMETER Content
Mandatory. The content to search in.

.PARAMETER ParentStartIdentifier
Optional. Tells the function that you're currently processing a sub-section (indented by one #) by providing the parent identifier

.PARAMETER SectionStartIdentifier
Mandatory. The identifier/header to search for. If not found, the end of the file is returned

.EXAMPLE
Get-MarkdownSectionStartIndex -Content @('# Title', '', '## Section 1', ...) -SectionStartIdentifier '## Resource Types'

Find the start index of the '## Resource Types' section in the given content.
#>
function Get-MarkdownSectionStartIndex {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [object[]] $Content,

        [Parameter(Mandatory = $false)]
        [string] $ParentStartIdentifier = '',

        [Parameter(Mandatory)]
        [string] $SectionStartIdentifier
    )

    $startIndex = 0
    while (-not ($Content[$startIndex] -eq $SectionStartIdentifier) -and -not ($startIndex -ge $Content.Count - 1)) {
        $startIndex++
    }

    # In case we're processing a child section (indented by one #) we should search until the main section starts / end of file is reached
    if ($startIndex -eq $Content.Count - 1 -and -not [String]::IsNullOrEmpty($ParentStartIdentifier)) {
        $level = $ParentStartIdentifier.TrimStart().Split(' ')[0]

        $parentSectionStartIndex = 0
        while (-not ($Content[$parentSectionStartIndex] -like "*$ParentStartIdentifier") -and -not ($parentSectionStartIndex -ge $Content.Count - 1)) {
            $parentSectionStartIndex++
        }

        $startIndex = $parentSectionStartIndex + 1
        while (-not ($Content[$startIndex] -like "$level *") -and -not ($startIndex -ge $Content.Count - 1)) {
            $startIndex++
        }

        if ($Content[$startIndex] -like "$level *") {
            $startIndex--
        }
    }

    return $startIndex
}
