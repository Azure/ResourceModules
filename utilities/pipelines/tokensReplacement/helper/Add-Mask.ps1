function Add-Mask {
    <#
        .SYNOPSIS
            Masking a value prevents a string or variable from being printed in the log.

        .PARAMETER Value
            Mandatory. The Secret Value as a Secure String

        .PARAMETER GitHubActions
            Optional. Switch that echos the add-mask functionality in GitHub Actions

        .PARAMETER AzureDevOps
            Optional. Switch that echos the task.setvariable functionality in Azure DevOps Pipelines

        .EXAMPLE
            Add-Mask -Value $SecureString -AzureDevOps

        .EXAMPLE
            Add-Mask -Value $SecureString -GitHubActions

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
