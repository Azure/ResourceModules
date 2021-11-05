
$KeyVaultTokens = @()

## Tokens from Azure Resources (Dependancies)
$ResoucesWithTokensTag = Get-AzResource -Tag @{ 'enableForTokens' = 'true' }
foreach ($Resource in $resoucesWithTokensTag) {
    # User Assigned Managed Identities
    if ($Resource.Type -eq 'Microsoft.ManagedIdentity/userAssignedIdentities') {
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
}

## Tokens for Azure Tenant
$TenantId = (Get-AzContext -ErrorAction SilentlyContinue).Tenant.Id
if ($TenantId) {
    $KeyVaultTokens += @{
        'Name'  = 'tenantId'
        'Value' = $TenantId
    }
}

## Custom Tokens (Should not contain sensitive Information!!!!)
$KeyVaultTokens += @{
    'Name'  = 'namePrefix'
    'Value' = 'carml'
}

## Push Tokens to Tokens Key Vault
if ($KeyVaultTokens) {
    $TokensKeyVault = Get-AzKeyVault -Tag @{ 'resourceRole' = 'tokensKeyVault' }
    if ($TokensKeyVault) {
        $KeyVaultTokens | ForEach-Object {
            Set-AzKeyVaultSecret -Name $PSItem.Name -SecretValue (ConvertTo-SecureString -AsPlainText $PSItem.Value) -VaultName $TokensKeyVault.VaultName
        }
    }
}

