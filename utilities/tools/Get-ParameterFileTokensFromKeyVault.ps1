
<#
.SYNOPSIS
This script Gets the tokens <<token>> that exist in a parameter file from an Azure Key Vault so that it can be swapped at runtime

.DESCRIPTION
This script gets the tokens <<token>> that exist in a parameter file from an Azure Key Vault so that it can be swapped at runtime

.PARAMETER TokenKeyVaultName
Optional. The name of the Key Vault. It will be used as an alternative if the Tag is not provided.

.PARAMETER Tag
Optional. The Tag used to find the Tokens Key Vault in an Azure Subscription. Default is @{ 'resourceRole' = 'tokensKeyVault' }

.PARAMETER subscriptionId
Optional. The Azure subscription containing the key vault.
#>
function Get-ParameterFileTokensFromKeyVault {
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $false)]
        [string]$TokenKeyVaultName,

        [parameter(Mandatory = $false)]
        [psobject]$Tag = @{ 'resourceRole' = 'tokensKeyVault' },

        [parameter(Mandatory)]
        [string]$subscriptionId
    )

    process {
        $CustomParameterFileTokens = @()

        ## Set Azure Context
        if ($subscriptionId) {
            $Context = Get-AzContext -ListAvailable | Where-Object Subscription -Match $subscriptionId
            if ($Context) {
                Write-Verbose 'Setting Azure Context'
                $Context | Set-AzContext
            }
        }
        try {
            Write-Verbose 'Finding Tokens Key Vault by Tag'
            $TokensKeyVault = Get-AzKeyVault -Tag $Tag | Select-Object -First 1
            if (!$TokensKeyVault) {
                Write-Verbose "Finding Tokens Key Vault by Name: $TokenKeyVaultName"
                $TokensKeyVault = Get-AzKeyVault -VaultName $TokenKeyVaultName
            }
        } catch {
            throw $PSitem.Exception.Message
        }

        if ($TokensKeyVault) {
            ## Get Tokens
            Write-Verbose("Tokens Key Vault Found: $($TokensKeyVault.VaultName)")
            $KeyVaultTokens = Get-AzKeyVaultSecret -VaultName $TokensKeyVault.VaultName | Where-Object -Property Name -Like 'ParameterFileToken-*'
            if ($KeyVaultTokens) {
                Write-Verbose("Key Vault Tokens Found: $($KeyVaultTokens.count)")
                $KeyVaultTokens | ForEach-Object {
                    $CustomParameterFileTokens += [ordered]@{ Replace = "<<$($PSItem.Name)>>"; With = (Get-AzKeyVaultSecret -SecretName $PSItem.Name -VaultName $TokensKeyVault.VaultName -AsPlainText -ErrorAction SilentlyContinue) }
                }
            } else {
                Write-Verbose('No Tokens Found In Tokens Key Vault')
            }
        } else {
            Write-Verbose('No Tokens Key Vault Detected')
        }
    }
    end {
        return [psobject]$CustomParameterFileTokens
    }
}
