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
Get-MarkdownSectionEndIndex -ReadMeFileContent @('# Title', '', '## Section 1', ...) -startIndex = 13

Start from index '13' onward for the index that concludes the current section in the given content array
#>
function Get-MarkdownSectionEndIndex {

    param(
        [Parameter(Mandatory)]
        [object[]] $ReadMeFileContent,

        [Parameter(Mandatory)]
        [int] $startIndex,

        [Parameter(Mandatory = $false)]
        [ValidateSet('table', 'list', 'none')]
        [string] $ContentType = 'none'
    )

    # shift one further
    $endIndex = $startIndex + 1

    if ($endIndex -ge $readMeFileContent.Count) {
        # We are at the end of the file
        return $startIndex
    }

    switch ($ContentType) {
        'list' {
            # Identify end of list
            while ($ReadMeFileContent[$endIndex].StartsWith('- ') -and -not ($endIndex -ge $readMeFileContent.Count - 1) -and -not $ReadMeFileContent[$endIndex].StartsWith('#')) {
                $endIndex++
            }
        }
        'table' {
            # Identify end of table
            while ($ReadMeFileContent[$endIndex].StartsWith('|') -and -not ($endIndex -ge $readMeFileContent.Count - 1) -and -not $ReadMeFileContent[$endIndex].StartsWith('#')) {
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

    if ($ReadMeFileContent[$endIndex].StartsWith('#')) {
        # We're already in the next section. Hence the section was empty
        $endIndex--
    }

    return $endIndex
}
