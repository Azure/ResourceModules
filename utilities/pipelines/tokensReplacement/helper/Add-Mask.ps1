function Add-Mask {
    <#
        .SYNOPSIS
            Masking a value prevents a string or variable from being printed in the log.
            Each masked word separated by whitespace is replaced with the * character.
        .EXAMPLE
            Add-Mask -Value "Super Secret"
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [System.Security.SecureString]
        $Value
    )
    $ValueNew = ConvertFrom-SecureString -SecureString $Value -AsPlainText
    Write-Output ("`n::add-mask::{0}" -f $ValueNew) | Out-Null
}
