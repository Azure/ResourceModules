<#
.SYNOPSIS
This script gets the tokens <<token>> that exist in a parameter file from an Azure Key Vault so that it can be swapped at runtime

.DESCRIPTION
This script gets the tokens <<token>> that exist in a parameter file from an Azure Key Vault so that it can be swapped at runtime

.PARAMETER SubscriptionId
Mandatory. The Azure subscription containing the key vault.

.PARAMETER TokensKeyVaultName
Optional. The name of the Key Vault. It will be used to find a Key Vault that contains Custom Parameter File Tokens.

.PARAMETER TokensKeyVaultSecretNamePrefix
Optional. An identifier used to filter for the Token Names (Secret Name) in Key Vault (i.e. ParameterFileToken-)

.EXAMPLE
Get-RemoteCustomParameterFileTokens -TokensKeyVaultName 'contoso-kv' -SubscriptionId '1234-1234'12345678-1234-123456789101'

.EXAMPLE
Get-RemoteCustomParameterFileTokens -TokensKeyVaultName 'contoso-kv' -SubscriptionId '1234-1234'12345678-1234-123456789101' -TokensKeyVaultSecretNamePrefix 'myToken-'

#>
function Get-RemoteCustomParameterFileTokens {
    [CmdletBinding()]
    param (
        [parameter(Mandatory)]
        [string]$TokensKeyVaultName,

        [parameter(Mandatory)]
        [string]$SubscriptionId,

        [parameter(Mandatory = $false)]
        [string]$TokensKeyVaultSecretNamePrefix = '*'
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
        $ReturnedTokens = @()
    }
    process {
        ## Remote Custom Parameter File Tokens (Should Not Contain Sensitive Information if being passed to regular strings)
        Write-Verbose "Finding Tokens Key Vault by Name: $TokensKeyVaultName"
        ## Find Token Key Vault by Name
        $TokensKeyVault = Get-AzKeyVault -VaultName $TokensKeyVaultName -ErrorAction 'SilentlyContinue'
        # If no Key Vault exists. Exit
        if (!$TokensKeyVault) {
            Write-Verbose('No Tokens Key Vault Detected in the current Subscription Context')
            exit
        }
        ## Get Tokens
        Write-Verbose("Tokens Key Vault Found: $TokensKeyVaultName")
        $Tokens = Get-AzKeyVaultSecret -VaultName $TokensKeyVaultName -ErrorAction SilentlyContinue |
            Where-Object -Property ContentType -Like '*ParameterFileToken' |
            Where-Object -Property Name -Like "$($TokensKeyVaultSecretNamePrefix)*"
        ## If no Tokens exist. Exit
        if (!$Tokens) {
            Write-Verbose("No Tokens Found using Secret Name Prefix '$TokensKeyVaultSecretNamePrefix' In Key Vault ($TokensKeyVaultName) or Principal does not have permissions to read it")
            exit
        }
        ## Get Token Values and Add to the Returned Object
        Write-Verbose("Key Vault Tokens Found: $($Tokens.count)")
        $Tokens | ForEach-Object {
            $TokenName = $PSItem.Name
            $GetTokenInput = @{
                SecretName = $TokenName
                VaultName  = $TokensKeyVaultName
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
            $ReturnedTokens += [ordered]@{ Name = $TokenName; Value = $TokenValue }
        }
    }
    end {
        return [psobject]$ReturnedTokens | ForEach-Object { [PSCustomObject]$PSItem }
    }
}
