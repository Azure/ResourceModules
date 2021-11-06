<#
.SYNOPSIS
This script creates the tokens <<token>> that exist in a parameter file in an Azure Key Vault so that it can be swapped at runtime

.DESCRIPTION
This script creates the tokens <<token>> that exist in a parameter file in an Azure Key Vault so that it can be swapped at runtime

.PARAMETER TokenKeyVaultName
Optional. The name of the Key Vault. It will be used as an alternative if the Tag is not provided.

.PARAMETER Tag
Optional. The Tag used to find the Tokens Key Vault in an Azure Subscription. Default is @{ 'resourceRole' = 'tokensKeyVault' }

.PARAMETER subscriptionId
Mandatory. The Azure subscription containing the key vault.

.PARAMETER TokenNameIdentifierPrefix
Optional. An identifier used to Set as a Prefix for the Token Names (i.e. ParameterFileToken-)

.PARAMETER customTokensConfigPath
Optional. Path to the Repository Settings (JSON) file where Custom Parameter File Tokens Exist

#>
function Set-ParameterFileTokensInKeyVault {
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $false)]
        [string]$TokenKeyVaultName,

        [parameter(Mandatory = $false)]
        [psobject]$Tag = @{ 'resourceRole' = 'tokensKeyVault' },

        [parameter(Mandatory)]
        [string]$subscriptionId,

        [parameter(Mandatory = $false)]
        [string]$TokenNameIdentifierPrefix = 'ParameterFileToken-',

        [parameter(Mandatory)]
        [string]$customTokensConfigPath

    )
    begin {
        $KeyVaultTokens = @()
    }
    process {
        ## Custom Parameter File Tokens (Should not contain sensitive Information)
        if ($customTokensConfigPath) {
            $CustomParameterFileTokens = (Get-Content -Path $customTokensConfigPath | ConvertFrom-Json -ErrorAction SilentlyContinue).customParameterFileTokens.tokens
            if ($CustomParameterFileTokens) {
                Write-Verbose "Found $($CustomParameterFileTokens.Count) Custom Tokens in Settings File"
                $KeyVaultTokens += $CustomParameterFileTokens
            }
        }
        ## Set Azure Context
        if ($subscriptionId) {
            $Context = Get-AzContext -ListAvailable | Where-Object Subscription -Match $subscriptionId
            if ($Context) {
                Write-Verbose 'Setting Azure Context'
                $Context | Set-AzContext
            }
        }
        ## Push Tokens to Tokens Key Vault
        if ($KeyVaultTokens) {
            Write-Verbose "Processing $($KeyVaultTokens.Count) Tokens"
            try {
                if ($TokenKeyVaultName) {
                    Write-Verbose "Finding Tokens Key Vault by Name: $TokenKeyVaultName"
                    $TokensKeyVault = Get-AzKeyVault -VaultName $TokenKeyVaultName
                }
                if (!$TokensKeyVault) {
                    Write-Verbose 'Finding Tokens Key Vault by Tag:'
                    $TokensKeyVault = Get-AzKeyVault -Tag $Tag | Select-Object -First 1
                    if (!($TokensKeyVault.Tags -match $Tag)) {
                        #Set Key Vault Tags for future updates
                        Write-Verbose "Key Vault Tags Not Found. Setting Tags on Key Vault $TokenKeyVaultName"
                        New-AzTag -Tag $Tag -ResourceId $TokensKeyVault.ResourceId -ErrorAction SilentlyContinue
                    }
                }
            } catch {
                throw $PSitem.Exception.Message
            }
            if ($TokensKeyVault) {
                Write-Verbose "Creating Tokens in Key Vault: $($TokensKeyVault.VaultName)"
                try {
                    $KeyVaultTokens | ForEach-Object {
                        Write-Verbose "Creating Token: $($PSItem.Name)"
                        $TokenName = $TokenNameIdentifierPrefix + $PSItem.Name
                        Set-AzKeyVaultSecret -Name $TokenName -SecretValue (ConvertTo-SecureString -AsPlainText $PSItem.Value) -VaultName $TokensKeyVault.VaultName | Out-Null
                    }
                } catch {
                    throw $PSitem.Exception.Message
                }
            } else {
                Write-Verbose 'No Token Key Vaults Found'
            }
        }
    }
}
