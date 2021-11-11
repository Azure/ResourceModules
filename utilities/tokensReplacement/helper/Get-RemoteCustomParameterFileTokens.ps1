<#
.SYNOPSIS
This script Gets the tokens <<token>> that exist in a parameter file from an Azure Key Vault so that it can be swapped at runtime

.DESCRIPTION
This script gets the tokens <<token>> that exist in a parameter file from an Azure Key Vault so that it can be swapped at runtime

.PARAMETER SubscriptionId
Mandatory. The Azure subscription containing the key vault.

.PARAMETER TokensKeyVaultName
Optional. The name of the Key Vault. It will be used to find a Key Vault that contains Custom Parameter File Tokens.

.PARAMETER TokensKeyVaultSecretNamePrefix
Optional. An identifier used to filter for the Token Names (Secret Name) in Key Vault (i.e. ParameterFileToken-)

#>
function Get-RemoteCustomParameterFileTokens {
    [CmdletBinding()]
    param (
        [parameter(Mandatory)]
        [string]$TokensKeyVaultName,

        [parameter(Mandatory)]
        [string]$SubscriptionId,

        [parameter(Mandatory = $false)]
        [string]$TokensKeyVaultSecretNamePrefix
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
            Write-Verbose 'Could not Find or Set Azure Context.. Exiting'
            exit
        }
        $ReturnedKeyVaultTokens = @()
    }
    process {
        ## Remote Custom Parameter File Tokens (Should Not Contain Sensitive Information if being passed to regular strings)
        Write-Verbose "Finding Tokens Key Vault by Name: $TokensKeyVaultName"
        ## Find Token Key Vault by Name
        $TokensKeyVault = Get-AzKeyVault -VaultName $TokensKeyVaultName -ErrorAction SilentlyContinue
        ## If Key Vault has been found, Get the Tokens
        if ($TokensKeyVault) {
            ## Get Tokens
            Write-Verbose("Tokens Key Vault Found: $($TokensKeyVault.VaultName)")
            $KeyVaultTokens = Get-AzKeyVaultSecret -VaultName $TokensKeyVault.VaultName -ErrorAction SilentlyContinue |
                Where-Object -Property ContentType -Like '*ParameterFileToken' |
                Where-Object -Property Name -Like "$($TokensKeyVaultSecretNamePrefix)*"
            ## If Tokens Found
            if ($KeyVaultTokens) {
                Write-Verbose("Key Vault Tokens Found: $($KeyVaultTokens.count)")
                ## Get Token Values and Add to the Returned Object
                $KeyVaultTokens | ForEach-Object {
                    $TokenName = $PSItem.Name
                    $GetTokenInput = @{
                        SecretName = $TokenName
                        VaultName  = $TokensKeyVault.VaultName
                    }
                    ## Check if Token Type is 'SecureParameterFileToken'
                    if (($PSItem.ContentType -eq 'SecureParameterFileToken')) {
                        $TokenValue = (Get-AzKeyVaultSecret @GetTokenInput -ErrorAction SilentlyContinue).SecretValue
                    } else {
                        $GetTokenInput += @{ AsPlainText = $true }
                        $TokenValue = Get-AzKeyVaultSecret @GetTokenInput -ErrorAction SilentlyContinue
                    }

                    ## Remove Prefix if Provided to Find the Token (Secret) in Key Vault
                    if ($TokensKeyVaultSecretNamePrefix) {
                        $TokenName = $TokenName.Replace($TokensKeyVaultSecretNamePrefix, '')
                    }
                    ## Add Token to Return Object
                    $ReturnedKeyVaultTokens += [ordered]@{ Name = $TokenName; Value = $TokenValue }
                }
            } else {
                Write-Verbose("No Tokens Found using TokensKeyVaultSecretNamePrefix '$TokensKeyVaultSecretNamePrefix' In Tokens Key Vault or Service Principal does not have permissions to Token Key Vault")
            }
        } else {
            Write-Verbose('No Tokens Key Vault Detected in the current Subscription Context')
        }
    }
    end {
        return [psobject]$ReturnedKeyVaultTokens | ForEach-Object { [PSCustomObject]$PSItem }
    }
}
