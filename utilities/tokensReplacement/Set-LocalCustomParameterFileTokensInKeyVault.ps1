<#
.SYNOPSIS
This script creates the tokens <<token>> that exist in a parameter file in an Azure Key Vault so that it can be swapped at runtime

.DESCRIPTION
This script creates the tokens <<token>> that exist in a parameter file in an Azure Key Vault so that it can be swapped at runtime

.PARAMETER LocalCustomParameterFileTokens
Mandatory. Object containing Name/Values for Local Custom Parameter File Tokens to push to Key Vault

.PARAMETER SubscriptionId
Mandatory. The Azure subscription containing the key vault.

.PARAMETER TokenKeyVaultName
Mandatory. The name of the Key Vault. It will be used as an alternative if the Tag is not provided.

.PARAMETER TokenKeyVaultSecretNamePrefix
Optional. An identifier used to filter for the Token Names (Secret Name) in Key Vault (i.e. ParameterFileToken-)

.PARAMETER TokenKeyVaultSecretContentType
Optional. An identifier used to filter for the Token (Secret Content Type) in Key Vault (i.e. ParameterFileToken or SecureParameterFileToken)

.EXAMPLE
Set-LocalCustomParameterFileTokensInKeyVault -LocalCustomParameterFileTokens @{name = 'tokenA'; value = 'tokenAvalue'} -TokensKeyVaultName 'contoso-kv' -SubscriptionId '1234-1234'12345678-1234-123456789101'

.EXAMPLE
Set-LocalCustomParameterFileTokensInKeyVault -LocalCustomParameterFileTokens @{name = 'tokenA'; value = 'tokenAvalue'} -TokensKeyVaultName 'contoso-kv' -SubscriptionId '1234-1234'12345678-1234-123456789101' -TokenKeyVaultSecretNamePrefix 'myPrefix-'

#>

function Set-LocalCustomParameterFileTokensInKeyVault {
    [CmdletBinding()]
    param (
        [parameter(Mandatory)]
        [psobject]$LocalCustomParameterFileTokens,

        [parameter(Mandatory)]
        [string]$TokenKeyVaultName,

        [parameter(Mandatory)]
        [string]$SubscriptionId,

        [parameter(Mandatory = $false)]
        [string]$TokenKeyVaultSecretNamePrefix,

        [parameter(Mandatory = $false)]
        [string]$TokenKeyVaultSecretContentType = 'ParameterFileToken'
    )
    begin {
        ## Set Azure Context
        try {
            $Context = Get-AzContext -ListAvailable | Where-Object Subscription -Match $SubscriptionId
            if ($Context) {
                Write-Verbose('Setting Azure Context')
                $Context | Set-AzContext | Out-Null
            }
        } catch {
            throw $PSitem.Exception.Message
            exit
        }
    }
    process {
        if ($LocalCustomParameterFileTokens.Count -eq 0) {
            Write-Verbose 'No Local Custom Parameter File Tokens Detected'
            exit
        }
        ## Local Custom Parameter File Tokens (Should not contain sensitive Information)
        Write-Verbose "Processing $($LocalCustomParameterFileTokens.Count) Local Custom Tokens in Settings File"
        try {
            Write-Verbose "Finding Tokens Key Vault by Name: $TokenKeyVaultName"
            $TokensKeyVault = Get-AzKeyVault -VaultName $TokenKeyVaultName
            ## IF Token Key Vault Exists
            if (!$TokensKeyVault) {
                Write-Verbose "No Token Key Vault Found with the Name: $TokenKeyVaultName in current subscription context"
                exit
            }
            Write-Verbose "Creating Tokens in Key Vault: $TokenKeyVaultName"
            ## Create / Update Tokens (Secrets) on Azure Key Vault
            $LocalCustomParameterFileTokens | ForEach-Object {
                $TokenName = -join ($TokenKeyVaultSecretNamePrefix, $PSItem.Name)
                Write-Verbose "Creating Token: $TokenName"
                Set-AzKeyVaultSecret -Name $TokenName -SecretValue (ConvertTo-SecureString -AsPlainText $PSItem.Value) -VaultName $TokenKeyVaultName -ContentType $TokenKeyVaultSecretContentType | Out-Null
            }
        } catch {
            throw $PSitem.Exception.Message
        }
    }
}
