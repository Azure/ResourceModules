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
        [string] $OutputDirectory,

        [Parameter(Mandatory = $false)]
        [switch] $RestoreTokens
    )
    # Restore Tokens (Swap Replace with Value)
    if ($RestoreTokens) {
        Write-Verbose 'Restoring Tokens'
        $TokensReplaceWith | ForEach-Object {
            $Replace = $PSitem.With; $With = $PSItem.Replace
            $PSitem.Replace = $Replace; $PSitem.With = $With
        }
    }
    Write-Verbose "$($TokensReplaceWith.Count) Tokens Found"
    # Process Path for Token Replacement
    foreach ($Path in $Paths) {
        $File = Get-Content -Path $Path
        $FileName = Split-Path $Path -Leaf
        Write-Verbose "Processing Tokens for file: $FileName"
        $TokensReplaceWith |
            ForEach-Object {
                $File = $File -replace $PSItem.Replace, $PSItem.With
            }
        if (!$OutputDirectory) {
            $File | Set-Content -Path $Path
        } else {
            Write-Verbose "Writing Output (New Path) to:  $OutputDirectory"
            $File | Set-Content -Path (Join-Path $OutputDirectory $FileName)
        }
    }
}
