@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

// @description('Required. The name of the Managed Identity to create.')
// param managedIdentityName string

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: 'testkvcarmludt'
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: tenant().tenantId
    enablePurgeProtection: false
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

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: 'testsacarmludt'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'

  resource blobService 'blobServices@2021-09-01' = {
    name: 'default'

    resource container 'containers@2021-09-01' = {
      name: 'scripts'
    }
  }
}

// resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
//     name: managedIdentityName
//     location: location
// }

// resource keyPermissions 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
//     name: guid('msi-${keyVault::key.id}-${location}-${managedIdentity.id}-KeyVault-Reader-RoleAssignment.')
//     scope: keyVault::key
//     properties: {
//         principalId: managedIdentity.properties.principalId
//         roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '12338af0-0e69-4776-bea7-57ae8d297424') // Key Vault Crypto User
//         principalType: 'ServicePrincipal'
//     }
// }

// @description('The principal ID of the created Managed Identity.')
// output managedIdentityPrincipalId string = managedIdentity.properties.principalId

// @description('The resource ID of the created Managed Identity.')
// output managedIdentityResourceId string = managedIdentity.id

@description('The resource ID of the created Key Vault.')
output keyVaultResourceId string = keyVault.id

@description('The name of the created encryption key.')
output keyName string = keyVault::key.name // Note: this is returning keyvaultName/keyName when experimentalfeature is enabled

@description('The resource ID of the created Storage Account.')
output storageAccountResourceId string = storageAccount.id

@description('The resource ID of the created Storage Account.')
output storageContainerName string = storageAccount::blobService::container.name
