@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Storage Account to create.')
param storageAccountName string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
  location: location
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    allowBlobPublicAccess: false
  }
  resource blobServices 'blobServices@2021-09-01' = {
    name: 'default'
    resource container 'containers@2021-09-01' = {
      name: 'vhds'
      properties: {
        publicAccess: 'None'
      }
    }
  }
}

// resource blobServices 'Microsoft.Storage/storageAccounts/blobServices@2021-09-01' = {
//   name: 'default'
//   parent: storageAccount
// }

// resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-09-01' = {
//   name: 'vhds'
//   parent: blobServices
//   properties: {
//     publicAccess: 'None'
//   }
// }

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the created Managed Identity.')
output managedIdentityResourceId string = managedIdentity.id
