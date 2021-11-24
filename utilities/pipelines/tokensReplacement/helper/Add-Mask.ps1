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
        $Value,

        [Parameter(Mandatory = $false, ParameterSetName = 'GitHubActions')]
        [Switch]
        $GitHubActions,

        [Parameter(Mandatory = $false, ParameterSetName = 'AzureDevOps')]
        [Switch]
        $AzureDevOps
    )
    $ValueConverted = ConvertFrom-SecureString -SecureString $Value -AsPlainText -ErrorAction SilentlyContinue
    if ($GitHubActions) {
        Write-Output ("`n::add-mask::{$ValueConverted}")
    }
    if ($AzureDevOps) {
        Write-Output ("`n`#`#vso[task.setvariable variable={$ValueConverted};issecret=true]")
    }
}
