<#
.SYNOPSIS
Login to Azure using a service principal

.DESCRIPTION
Login to Azure using a service principal

.PARAMETER clientID
Mandatory. The application (client) id of the service principal to log in with 

.PARAMETER clientSecret
Mandatory. The service principal secret to use for the login

.PARAMETER tenantId
Optional. The ID of the tenant to log into

.PARAMETER subscriptionId
Optional. The ID of the subscription to log into

.EXAMPLE
Connect-ToAzure -clientID '12345' -clientSecret '<Placeholder>' -subscriptionId '12345'
#>
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