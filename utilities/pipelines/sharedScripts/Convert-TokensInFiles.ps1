<#
.SYNOPSIS
Provide a Object of strings that need to be replaced with other strings for multiple files

.DESCRIPTION
Provide a Object of strings that need to be replaced with other strings for multiple files

.PARAMETER Paths
Mandatory. Full Path for the file that contains the strings that need to be replaced. Supports multiple files comma seperated.

.PARAMETER TokensReplaceWith

.EXAMPLE
$Object = @(
    @{ Replace = "TextA"; With = "TextB" }
    @{ Replace = "TextC"; With = "TextD" }
)
Convert-TokensInFiles -Paths 'C:\fileA.txt','C:\fileB.txt' -TokensReplaceWith $Object

#>
function Convert-TokensInFiles {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string[]] $Paths,

        [Parameter(Mandatory)]
        [psobject] $TokensReplaceWith
    )

    foreach ($Path in $Paths) {
        $File = Get-Content -Path $Path
        $TokensReplaceWith |
            ForEach-Object {
                $File = $File -replace $PSItem.Replace, $PSItem.With
            }
        $File | Set-Content -Path $Path
    }
}
