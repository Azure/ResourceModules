<#
.SYNOPSIS
Recieves an Input Object of Name/Value and Searches the Current File for the Name and Replaces it with the Value

.DESCRIPTION
Recieves an Input Object of Name/Value and Searches the Current File for the Name and Replaces it with the Value

.PARAMETER Paths
Mandatory. Full Path for the file that contains the strings that need to be replaced. Supports multiple files comma seperated.

.PARAMETER TokensReplaceWith
Mandatory. An Object that contains the Replace Key and With Key For replacing tokens in files. See Example for structure.

.PARAMETER RestoreTokens
Optional. A Boolean That swaps the tokens in the TokensReplaceWith Object. Default is False

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

.EXAMPLE
$Object = @(
    @{ Replace = "TextA"; With = "TextB" }
    @{ Replace = "TextC"; With = "TextD" }
)
Convert-TokensInFileList -Paths 'C:\fileA.txt','C:\fileB.txt' -TokensReplaceWith $Object -RestoreTokens $true
#>
function Convert-TokensInFileList {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string[]] $Paths,

        [Parameter(Mandatory, ValueFromPipeline = $true)]
        [psobject] $TokensReplaceWith,

        [Parameter(Mandatory = $false)]
        [string] $OutputDirectory,

        [Parameter(Mandatory = $false)]
        [bool] $RestoreTokens = $false
    )
    # Restore Tokens (Swap Replace with Value)
    if ($RestoreTokens) {
        Write-Verbose 'Restoring Tokens'
        $TokensReplaceWith | ForEach-Object {
            $Name = $PSitem.Value
            $Value = $PSItem.Name
            $PSitem.Name = $Name; $PSitem.Value = $Value
        }
    }
    # Begin the Replace Function
    Write-Verbose "$($TokensReplaceWith.Count) Tokens Found"
    # Process Path for Token Replacement
    foreach ($Path in $Paths) {
        # Extract Required Content From the Input
        try {
            $File = Get-Content -Path $Path
            $FileName = Split-Path $Path -Leaf
        } catch {
            throw $PSItem.Exception.Message
            exit
        }
        Write-Verbose "Processing Tokens for file: $FileName"
        # Perform the Replace of Tokens in the File
        $TokensReplaceWith |
            ForEach-Object {
                # If type is secure string
                if (($PSItem.Value | Get-Member -MemberType Property | Select-Object -ExpandProperty 'TypeName') -eq 'System.Security.SecureString') {
                    $PSItem.Value = $PSItem.Value | ConvertFrom-SecureString -AsPlainText
                }
                $File = $File -replace $PSItem.Name, $PSItem.Value
            }
        # Set Content
        if ($OutputDirectory -and (Test-Path -Path $OutputDirectory -PathType Container)) {
            # If Specific Output Directory Provided
            $Path = (Join-Path $OutputDirectory $FileName)
        }
        # Set Content to the Same Path
        Write-Verbose "Writing Output for: $FileName"
        $File | Set-Content -Path $Path
    }
}
