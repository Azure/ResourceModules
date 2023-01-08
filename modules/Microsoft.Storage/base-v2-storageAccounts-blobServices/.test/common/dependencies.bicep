@description('Required. The name of the Storage Account to create.')
param storageAccountName string

@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

@description('The name of the created Storage Account.')
output storageAccountName string = storageAccount.name
