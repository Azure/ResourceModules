@description('Required. The name of the managed identity to create.')
param managedIdentityName string

@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Key Vault to create.')
@minLength(3)
@maxLength(24)
param keyVaultName string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
  location: location
}

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: tenant().tenantId
    enablePurgeProtection: true // Required by batch account
    softDeleteRetentionInDays: 7
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: true
    enabledForDeployment: true
    enableRbacAuthorization: true
    accessPolicies: []
  }

  resource key 'keys@2022-07-01' = {
    name: 'keyEncryptionKey'
    properties: {
      kty: 'RSA'
    }
  }
}

// resource keyPermissions 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
//   name: guid('msi-${keyVault::key.id}-${location}-${managedIdentity.id}-Key-Reader-RoleAssignment')
//   scope: keyVault::key
//   properties: {
//     principalId: managedIdentity.properties.principalId
//     roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '12338af0-0e69-4776-bea7-57ae8d297424') // Key Vault Crypto User
//     principalType: 'ServicePrincipal'
//   }
// }

resource keyPermissions 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('msi-${keyVault::key.id}-${location}-${managedIdentity.id}-Key Vault Crypto User')
  scope: keyVault
  properties: {
    principalId: managedIdentity.properties.principalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'e147488a-f6f5-4113-8e2d-b22465e65bf6') // Key Vault Crypto Service Encryption User
    principalType: 'ServicePrincipal'
  }
}

// resource keyPermissions_2 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
//   name: guid('msi-${keyVault::key.id}-${location}-6bb8e274-af5d-4df2-98a3-4fd78b4cafd9-Key-Reader-RoleAssignment')
//   scope: keyVault::key
//   properties: {
//     principalId: '6bb8e274-af5d-4df2-98a3-4fd78b4cafd9'
//     roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '12338af0-0e69-4776-bea7-57ae8d297424') // Key Vault Crypto User
//     principalType: 'ServicePrincipal'
//   }
// }

resource keyPermissions_2 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  // name: guid('msi-${keyVault::key.id}-${location}-6bb8e274-af5d-4df2-98a3-4fd78b4cafd9-Key Vault Crypto User')
  name: guid('msi-${keyVault::key.id}-${location}-8b659b68-1eb9-4ea5-ab00-a6a182520436-4fd78b4cafd9-Key Vault Crypto User')
  scope: keyVault
  properties: {
    // principalId: '6bb8e274-af5d-4df2-98a3-4fd78b4cafd9' // AppId
    principalId: '8b659b68-1eb9-4ea5-ab00-a6a182520436' // Obj Id
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'e147488a-f6f5-4113-8e2d-b22465e65bf6') // Key Vault Crypto Service Encryption User
    principalType: 'ServicePrincipal'
  }
}

@description('The resource ID of the created managed identity.')
output managedIdentityResourceId string = managedIdentity.id

@description('The resource ID of the created Key Vault.')
output keyVaultResourceId string = keyVault.id

@description('The name of the Key Vault Encryption Key.')
output keyVaultEncryptionKeyName string = keyVault::key.name
