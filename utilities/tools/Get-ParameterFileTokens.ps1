<#
.SYNOPSIS
This script Gets the tokens <<token>> that exist in a parameter file from an Azure Key Vault so that it can be swapped at runtime

.DESCRIPTION
This script gets the tokens <<token>> that exist in a parameter file from an Azure Key Vault so that it can be swapped at runtime

.PARAMETER SubscriptionId
Mandatory. The Azure subscription containing the key vault.

.PARAMETER TokenKeyVaultName
Optional. The name of the Key Vault. It will be used as an alternative if the Tag is not provided.

.PARAMETER TokenKeyVaultSecretNamePrefix
Optional. An identifier used to filter for the Token Names (Secret Name) in Key Vault (i.e. ParameterFileToken-)

.PARAMETER LocalCustomParameterFileTokens
Optional. Object containing Name/Values for Local Custom Parameter File Tokens
#>
function Get-ParameterFileTokens {
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
                $TokenName = "<<$($PSItem.Name)>>"
                Write-Verbose "Adding Parameter File Local Token Name: $TokenName"
                $AllCustomParameterFileTokens += [ordered]@{ Replace = "$TokenName"; With = "$($PSItem.Value)" }
            }
        } else {
            Write-Verbose 'No Local Custom Parameter File Tokens Detected'
        }

        ## Remote Custom Parameter File Tokens (Can Contain sensitive Information)
        ## Set Azure Context
        if ($TokenKeyVaultName) {
            Write-Verbose "Finding Tokens Key Vault by Name: $TokenKeyVaultName"
            $Context = Get-AzContext -ListAvailable | Where-Object Subscription -Match $SubscriptionId
            if ($Context) {
                Write-Verbose('Setting Azure Context')
                $Context | Set-AzContext
            }
            ## Find Token Key Vault by Name
            $TokensKeyVault = Get-AzKeyVault -VaultName $TokenKeyVaultName -ErrorAction SilentlyContinue
            ## If Key Vault has been found, Get the Tokens
            if ($TokensKeyVault) {
                ## Get Tokens
                Write-Verbose("Tokens Key Vault Found: $($TokensKeyVault.VaultName)")
                $KeyVaultTokens = Get-AzKeyVaultSecret -VaultName $TokensKeyVault.VaultName -ErrorAction SilentlyContinue | Where-Object -Property Name -Like "$($TokenKeyVaultSecretNamePrefix)*"
                if ($KeyVaultTokens) {
                    Write-Verbose("Key Vault Tokens Found: $($KeyVaultTokens.count)")
                    $KeyVaultTokens | ForEach-Object {
                        $TokenName = "<<$($PSItem.Name.Replace($TokenKeyVaultSecretNamePrefix,''))>>"
                        Write-Verbose "Adding Parameter File Remote Token Name: $TokenName"
                        $AllCustomParameterFileTokens += [ordered]@{ Replace = "$TokenName"; With = (Get-AzKeyVaultSecret -SecretName $PSItem.Name -VaultName $TokensKeyVault.VaultName -AsPlainText -ErrorAction SilentlyContinue) }
                    }
                } else {
                    Write-Verbose("No Tokens Found using TokenKeyVaultSecretNamePrefix '$TokenKeyVaultSecretNamePrefix' In Tokens Key Vault or Service Principal does not have permissions to Token Key Vault")
                }
            } else {
                Write-Verbose('No Tokens Key Vault Detected in the current Subscription Context')
            }
        }
    }
    end {
        return [psobject]$AllCustomParameterFileTokens | ForEach-Object { [PSCustomObject]$PSItem }
    }
}
