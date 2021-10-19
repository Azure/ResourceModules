#region Helper functions
<#
.SYNOPSIS
Find the array index that represents the end of the current section

.DESCRIPTION
Find the array index that represents the end of the current section
This index is identified by iterating through the subsequent array positions until a new chapter character (#) is found

.PARAMETER ReadMeFileContent
Mandatory. The content array to search in

.PARAMETER startIndex
Mandatory. The index to start the search from. Should usually be the current section's header index

.EXAMPLE
Get-EndIndex -ReadMeFileContent @('# Title', '', '## Section 1', ...) -startIndex = 13

Start from index '13' onward for the index that concludes the current section in the given content array
#>
function Get-EndIndex {

    param(
        [Parameter(Mandatory)]
        [object[]] $ReadMeFileContent,

        [Parameter(Mandatory)]
        [int] $startIndex,

        [Parameter(Mandatory = $false)]
        [ValidateSet('table', 'list')]
        [string] $contentType = 'table'
    )

    # shift one further
    $endIndex = $startIndex + 1

    if ($endIndex -ge $readMeFileContent.Count) {
        # We are at the end of the file
        return $startIndex
    }

    switch ($contentType) {
        'list' {
            # Identify end of list
            while ($ReadMeFileContent[$endIndex].StartsWith('- ') -and -not ($endIndex -ge $readMeFileContent.Count - 1)) {
                $endIndex++
            }
        }
        'table' {
            # Identify end of table
            while ($ReadMeFileContent[$endIndex].StartsWith('|') -and -not ($endIndex -ge $readMeFileContent.Count - 1)) {
                $endIndex++
            }
        }
        Default {
            # Identify next section
            while (-not $ReadMeFileContent[$endIndex].StartsWith('#') -and -not ($endIndex -ge $readMeFileContent.Count - 1)) {
                $endIndex++
            }
        }
    }

    return $endIndex
}
#endregion

<#
.SYNOPSIS
Merge the sections prior & after the updated content with the new content into on connected content array

.DESCRIPTION
Merge the sections prior & after the updated content with the new content into on connected content array

.PARAMETER oldContent
Mandatory. The original content to update

.PARAMETER newContent
Mandatory. The new content to merge into the original

.PARAMETER sectionStartIdentifier
Mandatory. The identifier/header to search for. If not found, the new section is added at the end of the content array

.EXAMPLE
Merge-FileWithNewContent -oldContent @('# Title', '', '## Section 1', ...) -newContent @('# Title', '', '## Section 1', ...) -sectionStartIdentifier '## Resource Types'

Update the original content of the '## Resource Types' section with the newly provided
#>
function Merge-FileWithNewContent {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [object[]] $oldContent,

        [Parameter(Mandatory)]
        [object[]] $newContent,

        [Parameter(Mandatory)]
        [string] $sectionStartIdentifier,

        [Parameter(Mandatory = $false)]
        [ValidateSet('table', 'list')]
        [string] $contentType = 'table'
    )

    $startIndex = 0
    while (-not ($oldContent[$startIndex] -like "*$sectionStartIdentifier") -and -not ($startIndex -ge $oldContent.Count - 1)) {
        $startIndex++
    }

    switch ($contentType) {
        'table' {
            $tableStartIndex = $startIndex + 1
            while (-not ($oldContent[$tableStartIndex].StartsWith('|')) -and -not ($tableStartIndex -ge $oldContent.count)) {
                $tableStartIndex++
            }

            $startContent = $oldContent[0..($tableStartIndex - 1)]

            if ($startIndex -eq $ReadMeFileContent.Count - 1) {
                # Not found section until end of file. Assuming it does not exist
                $endContent = @()
                if ($ReadMeFileContent[$startIndex] -notcontains $sectionStartIdentifier) {
                    $newContent = @('', $sectionStartIdentifier) + $newContent
                }
            } else {
                $endIndex = Get-EndIndex -ReadMeFileContent $oldContent -startIndex $tableStartIndex -contentType $contentType
                if ($endIndex -ne $oldContent.Count - 1) {
                    $endContent = $oldContent[$endIndex..($oldContent.Count - 1)]
                }
            }
        }
        'list' {
            $listStartIndex = $startIndex + 1
            while (-not ($oldContent[$listStartIndex].StartsWith('- ')) -and -not ($listStartIndex -ge $oldContent.count)) {
                $listStartIndex++
            }

            $startContent = $oldContent[0..($listStartIndex - 1)]

            if ($startIndex -eq $ReadMeFileContent.Count - 1) {
                # Not found section until end of file. Assuming it does not exist
                $endContent = @()
                if ($ReadMeFileContent[$startIndex] -notcontains $sectionStartIdentifier) {
                    $newContent = @('', $sectionStartIdentifier) + $newContent
                }
            } else {
                $endIndex = Get-EndIndex -ReadMeFileContent $oldContent -startIndex $listStartIndex -contentType $contentType
                if ($endIndex -ne $oldContent.Count - 1) {
                    $endContent = $oldContent[$endIndex..($oldContent.Count - 1)]
                }
            }
        }
        Default {}
    }

    # Add a little space
    if ($startContent -and (-not [String]::IsNullOrEmpty($startContent[-1]))) { $startContent += @('') }
    if ($endContent -and (-not [String]::IsNullOrEmpty($endContent[0]))) { $endContent = @('') + $endContent }

    # Build result
    $newContent = (($startContent + $newContent + $endContent) | Out-String).TrimEnd().Replace("`r", '').Split("`n")
    return $newContent
}
