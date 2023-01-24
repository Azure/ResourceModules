@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: 'testsaexpudt01'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'

  resource blobService 'blobServices@2021-09-01' = {
    name: 'default'

    resource container 'containers@2021-09-01' = {
      name: 'container01'
    }
  }
}

@description('The name of the created Storage Account Blob Container.')
output storageContainerName string = storageAccount::blobService::container.name // Note: this is returning storageAccountName/default/containerName when experimentalfeature is enabled

@description('The name of the created Storage Account Blob Container.')
output storageContainerPublicAccess string = storageAccount::blobService::container.properties.publicAccess
