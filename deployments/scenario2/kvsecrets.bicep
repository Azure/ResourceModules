targetScope = 'subscription'

param prefix string = 'scenario2team5'
param location string = 'centralus'

var keyVaultName = '${prefix}-keyvault'

// kv secrets
module kv_secrets '../../arm/Microsoft.KeyVault/vaults//secrets/deploy.bicep' = {
  scope: resourceGroup('scenario2team5-shared')
  name: '${prefix}-secret'
  params: {
    keyVaultName: keyVaultName
    name: 'sqlsecret'
    value: 'C@rm1w0rkshop!!!'
  }
}
