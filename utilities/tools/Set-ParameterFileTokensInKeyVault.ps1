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
Optional. The Azure subscription containing the key vault.
#>
function Set-ParameterFileTokensInKeyVault {
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $false)]
        [string]$TokenKeyVaultName,

        [parameter(Mandatory = $false)]
        [psobject]$Tag = @{ 'resourceRole' = 'tokensKeyVault' },

        [parameter(Mandatory)]
        [string]$subscriptionId

    )
    begin {
        $KeyVaultTokens = @()
        ## Custom Tokens (Should not contain sensitive Information)
        $KeyVaultTokens += @(
            @{ Name = 'namePrefix'; Value = 'coca' }
            @{ Name = 'envPrefix'; Value = 'prod' }
            @{ Name = 'prinId2'; Value = 'prod' }
            #<#############> Add more Custom Tokens here <#############>
        )
    }
    process {
        ## Set Azure Context
        if ($subscriptionId) {
            $Context = Get-AzContext -ListAvailable | Where-Object Subscription -Match $subscriptionId
            if ($Context) {
                Write-Verbose 'Setting Azure Context'
                $Context | Set-AzContext
            }
        }
        ## Tokens from Azure Resources (Dependancies)
        $ResoucesWithTokensTag = Get-AzResource -Tag @{ 'enableForTokens' = 'true' }
        foreach ($Resource in $resoucesWithTokensTag) {
            # User Assigned Managed Identities
            if ($Resource.Type -eq 'Microsoft.ManagedIdentity/userAssignedIdentities') {
                Write-Verbose "Processing Tokens for User Assigned Managed Identity: $($Resource.Name)"
                # Tokens Properties (principal Id)
                if ($Resource.Tags.tokenValue -eq 'principalId') {
                    $Name = $Resource.Tags.tokenName
                    $Value = (Get-AzUserAssignedIdentity -Name $Resource.Name -ResourceGroupName $Resource.ResourceGroupName).PrincipalId
                    if ($Name -and $Value) {
                        $KeyVaultTokens += @{
                            'Name'  = $Name
                            'Value' = $Value
                        }
                    }
                }
            }
            #<#############> Add more Azure Resource Token types here <#############>
        }
        ## Tokens for Azure Tenant
        $TenantId = (Get-AzContext -ErrorAction SilentlyContinue).Tenant.Id
        if ($TenantId) {
            Write-Verbose 'Processing Tokens for Azure AD Tenant ID'
            $KeyVaultTokens += @{
                'Name'  = 'tenantId'
                'Value' = $TenantId
            }
        }

        ## Push Tokens to Tokens Key Vault
        if ($KeyVaultTokens) {
            Write-Verbose "Processing $($KeyVaultTokens.Count) Tokens"
            try {
                Write-Verbose 'Finding Tokens Key Vault by Tag:'
                $TokensKeyVault = Get-AzKeyVault -Tag $Tag | Select-Object -First 1
                if (!$TokensKeyVault) {
                    Write-Verbose "Finding Tokens Key Vault by Name: $TokenKeyVaultName"
                    $TokensKeyVault = Get-AzKeyVault -VaultName $TokenKeyVaultName
                    if ($TokensKeyVault) {
                        #Set Key Vault Tags for future updates
                        Write-Verbose "Token Key Vault Tags Not Found. Setting Tags on Key Vault $TokenKeyVaultName"
                        New-AzTag -Tag $Tag -ResourceId $TokensKeyVault.ResourceId
                    }
                }
            } catch {
                throw $PSitem.Exception.Message
            }
            if ($TokensKeyVault) {
                Write-Verbose "Processing Tokens for Tokens Key Vault: $($TokensKeyVault.VaultName)"
                try {
                    $KeyVaultTokens | ForEach-Object {
                        Write-Verbose "Creating Token: $($PSItem.Name)"
                        Set-AzKeyVaultSecret -Name $PSItem.Name -SecretValue (ConvertTo-SecureString -AsPlainText $PSItem.Value) -VaultName $TokensKeyVault.VaultName
                    }
                } catch {
                    throw $PSitem.Exception.Message
                }
            } else {
                throw 'No Token Key Vaults Found'
            }
        }
    }
}
