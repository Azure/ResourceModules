﻿function Add-Mask {
    <#
        .SYNOPSIS
            Masking a value prevents a string or variable from being printed in the log.
        .EXAMPLE
            Add-Mask -Value "Super Secret"

        .NOTES
        Credit: https://www.powershellgallery.com/packages/Endjin.GitHubActions/1.0.3
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
        Write-Host ("`n::add-mask::{0}" -f $ValueConverted)
    }
    if ($AzureDevOps) {
        Write-Host "##vso[task.setvariable variable=$Value;issecret=true]$ValueConverted"
    }
}
