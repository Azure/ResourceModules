<#
.SYNOPSIS
Provide a Object of strings that need to be replaced with other strings for multiple files

.DESCRIPTION
Provide a Object of strings that need to be replaced with other strings for multiple files

.PARAMETER Paths
Mandatory. Full Path for the file that contains the strings that need to be replaced. Supports multiple files comma seperated.

.PARAMETER TokensReplaceWith
Mandatory. An Object that contains the Replace Key and With Key For replacing tokens in files. See Example for structure.
.EXAMPLE
$Object = @(
    @{ Replace = "TextA"; With = "TextB" }
    @{ Replace = "TextC"; With = "TextD" }
)
Convert-TokensInFileList -Paths 'C:\fileA.txt','C:\fileB.txt' -TokensReplaceWith $Object

.EXAMPLE
$Object = @(
    @{ Replace = "TextA"; With = "TextB" }
    @{ Replace = "TextC"; With = "TextD" }
)
Convert-TokensInFileList -Paths 'C:\fileA.txt','C:\fileB.txt' -TokensReplaceWith $Object -OutputDirectory 'C:\customDirectory'

#>
function Convert-TokensInFileList {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string[]] $Paths,

        [Parameter(Mandatory)]
        [psobject] $TokensReplaceWith,

        [Parameter(Mandatory = $false)]
        [string] $OutputDirectory
    )
    Write-Verbose "$($TokensReplaceWith.Count) Tokens Found"
    foreach ($Path in $Paths) {
        Write-Verbose "Processing Tokens for file: $Path"
        $File = Get-Content -Path $Path
        $TokensReplaceWith |
            ForEach-Object {
                $File = $File -replace $PSItem.Replace, $PSItem.With
            }
        if (!$OutputDirectory) {
            Write-Verbose "Writing Output (Same Path): $Path"
            $File | Set-Content -Path $Path
        } else {
            $FileName = Split-Path $Path -Leaf
            Write-Verbose "Writing Output (New Path) to:  $OutputDirectory"
            $File | Set-Content -Path (Join-Path $OutputDirectory $FileName)
        }
    }
}
