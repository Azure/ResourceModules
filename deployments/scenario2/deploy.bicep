targetScope = 'subscription'

param prefix string = 'scenario2team5'
param location string = 'centralus'

var keyVaultName = '${prefix}-keyvault'

// Create Resource Groups

@description('The Resource Groups to create')

module rsg_app_tier '../../arm/Microsoft.Resources/resourceGroups/deploy.bicep' = {
  name: '${prefix}-app'
  params: {
    name: '${prefix}-app'
    location: location
  }
}

module rsg_data_tier '../../arm/Microsoft.Resources/resourceGroups/deploy.bicep' = {
  name: '${prefix}-data'
  params: {
    name: '${prefix}-data'
    location: location
  }
}

module rsg_shared '../../arm/Microsoft.Resources/resourceGroups/deploy.bicep' = {
  name: '${prefix}-shared'
  params: {
    name: '${prefix}-shared'
    location: location
  }
}

// Key Vault
module kv '../../arm/Microsoft.KeyVault/vaults/deploy.bicep' = {
  scope: resourceGroup(rsg_shared.name)
  name: 'team5-keyvault'
  params: {
    location: location
    name: keyVaultName
  }
}

// Create App Tier

// container registry
module container_registry '../../arm/Microsoft.ContainerRegistry/registries/deploy.bicep' = {
  scope: resourceGroup(rsg_app_tier.name)
  name: '${prefix}-reg'
  params: {
    name: '${prefix}container'
    location: location
  }
}

resource kvresource 'Microsoft.KeyVault/vaults@2021-11-01-preview' existing = {
  scope: resourceGroup(rsg_shared.name)
  name: 'scenario2team5-keyvault'
}

module db '../../arm/Microsoft.Sql/servers/deploy.bicep' = {
  name: '${prefix}-db'
  scope: resourceGroup(rsg_data_tier.name)
  params: {
    location: location
    name: '${prefix}-db'
    administratorLogin: 'sampleadminloginname'
    administratorLoginPassword: kvresource.getSecret('sqlsecret')
  }
  dependsOn: [
    rsg_data_tier
  ]
}
