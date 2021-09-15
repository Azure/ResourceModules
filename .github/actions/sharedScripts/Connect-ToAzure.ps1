function Connect-ToAzure {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $clientID,

        [Parameter(Mandatory)]
        [securestring] $clientSecret,

        [Parameter(Mandatory = $false)]
        [string] $tenantId = '',

        [Parameter(Mandatory = $false)]
        [string] $subscriptionId = ''
    )

    ###############
    ##   LOGIN   ##
    ###############
    Write-Verbose "Login to environment" -Verbose
    $credential = New-Object PSCredential -ArgumentList $clientID, $clientSecret
    $loginInputObject = @{
        ServicePrincipal = $true
        Credential       = $credential
    }
    if (-not [String]::IsNullOrEmpty($tenantId)) { $loginInputObject['tenantId'] = $tenantId }
    if (-not [String]::IsNullOrEmpty($subscriptionId)) { $loginInputObject['subscriptionId'] = $subscriptionId }

    Connect-AzAccount @loginInputObject
}