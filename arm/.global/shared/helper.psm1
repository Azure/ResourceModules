# Load used functions
$repoRootPath = (Get-Item $PSScriptRoot).Parent.Parent.Parent.FullName

. (Join-Path $repoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Get-NestedResourceList.ps1')
. (Join-Path $repoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Get-ScopeOfTemplateFile.ps1')


function Get-MarkdownSectionStartIndex {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [array] $ReadMeContent,

        [Parameter(Mandatory = $true)]
        [string] $MarkdownSectionIdentifier
    )

    $sectionStartIndex = 0
    while ($ReadMeContent[$sectionStartIndex] -notlike $MarkdownSectionIdentifier -and -not ($sectionStartIndex -ge $ReadMeContent.count)) {
        $sectionStartIndex++
    }

    return $sectionStartIndex
}

function Get-MarkdownSectionEndIndex {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [array] $ReadMeContent,

        [Parameter(Mandatory = $true)]
        [int] $SectionStartIndex
    )

    $sectionEndIndex = $sectionStartIndex + 1
    while ($readMeContent[$sectionEndIndex] -notlike '*# *' -and -not ($sectionEndIndex -ge $ReadMeContent.count)) {
        $sectionEndIndex++
    }

    return $sectionEndIndex
}

function Get-TableStartAndEndIndex {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [array] $ReadMeContent,

        [Parameter(Mandatory = $true)]
        [string] $MarkdownSectionIdentifier
    )

    $sectionStartIndex = Get-MarkdownSectionStartIndex -ReadMeContent $ReadMeContent -MarkdownSectionIdentifier $MarkdownSectionIdentifier

    $tableStartIndex = $sectionStartIndex + 1
    while ($readMeContent[$tableStartIndex] -notlike '*|*' -and -not ($tableStartIndex -ge $readMeContent.count)) {
        $tableStartIndex++
    }

    $tableEndIndex = $tableStartIndex + 2
    while ($readMeContent[$tableEndIndex] -like '|*' -and -not ($tableEndIndex -ge $readMeContent.count)) {
        $tableEndIndex++
    }

    return $tableStartIndex, $tableEndIndex
}
