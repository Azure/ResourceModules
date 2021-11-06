<#
.SYNOPSIS
This script creates the tokens <<token>> that exist in a parameter file in an Azure Key Vault so that it can be swapped at runtime

.DESCRIPTION
This script creates the tokens <<token>> that exist in a parameter file in an Azure Key Vault so that it can be swapped at runtime

.PARAMETER SubscriptionId
Mandatory. The Azure subscription containing the key vault.

.PARAMETER TokenKeyVaultName
Mandatory. The name of the Key Vault. It will be used as an alternative if the Tag is not provided.

.PARAMETER TokenKeyVaultSecretNamePrefix
Optional. An identifier used to filter for the Token Names (Secret Name) in Key Vault (i.e. ParameterFileToken-)

.PARAMETER LocalCustomParameterFileTokens
Optional. Object containing Name/Values for Local Custom Parameter File Tokens to push to Key Vault
#>
function Set-ParameterFileTokensInKeyVault {
    [CmdletBinding()]
    param (
        [parameter(Mandatory)]
        [string]$TokenKeyVaultName,

        [parameter(Mandatory)]
        [string]$SubscriptionId,

        [parameter(Mandatory = $false)]
        [string]$TokenKeyVaultSecretNamePrefix = 'ParameterFileToken-',

        [parameter(Mandatory = $false)]
        [psobject]$LocalCustomParameterFileTokens
    )
    begin {
        $AllCustomParameterFileTokens = @()
    }
    process {
        ## Local Custom Parameter File Tokens (Should not contain sensitive Information)
        if ($LocalCustomParameterFileTokens) {
            Write-Verbose "Found $($LocalCustomParameterFileTokens.Count) Local Custom Tokens in Settings File"
            $LocalCustomParameterFileTokens | ForEach-Object {
                Write-Verbose "Adding Parameter File Local Token Name: $($PSitem.Name)"
                $AllCustomParameterFileTokens += $PSitem
            }
        } else {
            Write-Verbose 'No Local Custom Parameter File Tokens Detected'
        }
        ## Set Azure Context
        $Context = Get-AzContext -ListAvailable | Where-Object Subscription -Match $SubscriptionId
        if ($Context) {
            Write-Verbose 'Setting Azure Context'
            $Context | Set-AzContext
        }
        ## Push Tokens to Tokens Key Vault
        if ($AllCustomParameterFileTokens) {
            Write-Verbose "Processing $($AllCustomParameterFileTokens.Count) Tokens"
            try {
                if ($TokenKeyVaultName) {
                    Write-Verbose "Finding Tokens Key Vault by Name: $TokenKeyVaultName"
                    $TokensKeyVault = Get-AzKeyVault -VaultName $TokenKeyVaultName
                }
                ## IF Token Key Vault Exists
                if ($TokensKeyVault) {
                    Write-Verbose "Creating Tokens in Key Vault: $($TokensKeyVault.VaultName)"
                    try {
                        $AllCustomParameterFileTokens | ForEach-Object {
                            Write-Verbose "Creating Token: $($PSItem.Name)"
                            $TokenName = $TokenKeyVaultSecretNamePrefix + $PSItem.Name
                            Set-AzKeyVaultSecret -Name $TokenName -SecretValue (ConvertTo-SecureString -AsPlainText $PSItem.Value) -VaultName $TokensKeyVault.VaultName | Out-Null
                        }
                    } catch {
                        throw $PSitem.Exception.Message
                    }
                } else {
                    Write-Verbose 'No Token Key Vaults Found'
                }
            } catch {
                throw $PSitem.Exception.Message
            }
        }
    }
}
