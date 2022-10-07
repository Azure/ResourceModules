<#
.SYNOPSIS
Merge the sections prior & after the updated content with the new content into on connected content array

.DESCRIPTION
Merge the sections prior & after the updated content with the new content into on connected content array

.PARAMETER OldContent
Mandatory. The original content to update

.PARAMETER NewContent
Mandatory. The new content to merge into the original

.PARAMETER SectionStartIdentifier
Mandatory. The identifier/header to search for. If not found, the new section is added at the end of the content array

.PARAMETER ParentStartIdentifier
Optional. Tells the function that you're currently processing a sub-section (indented by one #) by providing the parent identifier

.EXAMPLE
Merge-MarkdownFileWithNewContent -OldContent @('# Title', '', '## Section 1', ...) -NewContent @('# Title', '', '## Section 1', ...) -SectionStartIdentifier '## Resource Types'

Update the original content of the '## Resource Types' section with the newly provided
#>
function Merge-MarkdownFileWithNewContent {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [object[]] $OldContent,

        [Parameter(Mandatory)]
        [object[]] $newContent,

        [Parameter(Mandatory = $false)]
        [string] $ParentStartIdentifier = '',

        [Parameter(Mandatory)]
        [string] $SectionStartIdentifier,

        [Parameter(Mandatory = $false)]
        [ValidateSet('table', 'list', 'none')]
        [string] $ContentType = 'none'
    )

    # Get start index
    $sectionStartInputObject = @{
        Content                = $OldContent
        SectionStartIdentifier = $SectionStartIdentifier
    }
    if (-not [String]::IsNullOrEmpty($ParentStartIdentifier)) {
        $sectionStartInputObject['ParentStartIdentifier'] = $ParentStartIdentifier
    }
    $startIndex = Get-MarkdownSectionStartIndex @sectionStartInputObject

    # Process content
    if ($startIndex -eq $OldContent.Count - 1 -and [String]::IsNullOrEmpty($ParentStartIdentifier)) {
        # Section is not existing (end of file)
        $startContent = $OldContent
        if ($OldContent[$startIndex] -ne $SectionStartIdentifier ) {
            # Add section header
            $startContent = $startContent + @('', $SectionStartIdentifier)
        }
        $endContent = @()
    } else {
        switch ($ContentType) {
            'table' {
                $tableStartIndex = $startIndex + 1
                while (-not $OldContent[$tableStartIndex].StartsWith('|') -and -not ($tableStartIndex -ge $OldContent.count) -and -not ($OldContent[$tableStartIndex].StartsWith('#'))) {
                    $tableStartIndex++
                }
                if ($OldContent[$tableStartIndex].StartsWith('#')) {
                    # Seems like there is no table yet
                    $tableStartIndex = $startIndex + 1
                }

                $startContent = $OldContent[0..($tableStartIndex - 1)]

                if ($startIndex -eq $ReadMeFileContent.Count - 1) {
                    # Not found section until end of file. Assuming it does not exist
                    $endContent = @()
                    if ($ReadMeFileContent[$startIndex] -notcontains $SectionStartIdentifier) {
                        $newContent = @('', $SectionStartIdentifier) + $newContent
                    }
                } else {
                    $endIndex = Get-MarkdownSectionEndIndex -ReadMeFileContent $OldContent -startIndex $tableStartIndex -ContentType $ContentType
                    if ($endIndex -ne $OldContent.Count - 1) {
                        $endContent = $OldContent[$endIndex..($OldContent.Count - 1)]
                    }
                }
            }
            'list' {
                $listStartIndex = $startIndex + 1
                while (-not $OldContent[$listStartIndex].StartsWith('- ') -and -not ($listStartIndex -ge $OldContent.count) -and -not ($OldContent[$listStartIndex].StartsWith('# '))) {
                    $listStartIndex++
                }
                if ($OldContent[$listStartIndex].StartsWith('#')) {
                    # Seems like there is no table yet
                    $listStartIndex = $listStartIndex + 1
                }

                $startContent = $OldContent[0..($listStartIndex - 1)]

                if ($startIndex -eq $ReadMeFileContent.Count - 1) {
                    # Not found section until end of file. Assuming it does not exist
                    $endContent = @()
                    if ($ReadMeFileContent[$startIndex] -notcontains $SectionStartIdentifier) {
                        $newContent = @('', $SectionStartIdentifier) + $newContent
                    }
                } else {
                    $endIndex = Get-MarkdownSectionEndIndex -ReadMeFileContent $OldContent -startIndex $listStartIndex -ContentType $ContentType
                    if ($endIndex -ne $OldContent.Count - 1) {
                        $endContent = $OldContent[$endIndex..($OldContent.Count - 1)]
                    }
                }
            }
            'none' {
                if ($OldContent[$startIndex + 1] -like "$level *" -and -not [String]::IsNullOrEmpty($ParentStartIdentifier)) {
                    # section was not found - let's insert it at the end of the sub-section
                    $startContent = $OldContent[0..($startIndex)]
                    $newContent = @($SectionStartIdentifier, '') + $newContent
                    $endContent = $OldContent[($startIndex + 1)..($OldContent.Count - 1)]
                } else {
                    # section was found
                    $startContent = $OldContent[0..($startIndex)]
                    $endIndex = Get-MarkdownSectionEndIndex -ReadMeFileContent $OldContent -startIndex $startIndex -ContentType $ContentType
                    if ($endIndex -ne $OldContent.Count - 1) {
                        $endContent = $OldContent[$endIndex..($OldContent.Count - 1)]
                    }
                }
            }
            Default {}
        }
    }

    # Add a little space
    if ($startContent -and (-not [String]::IsNullOrEmpty($startContent[-1]))) { $startContent += @('') }
    if ($endContent -and (-not [String]::IsNullOrEmpty($endContent[0]))) { $endContent = @('') + $endContent }

    # Build result
    $newContent = (($startContent + $newContent + $endContent) | Out-String).TrimEnd().Replace("`r", '').Split("`n")
    return $newContent
}
