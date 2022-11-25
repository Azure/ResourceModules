@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Storage Account to create.')
param storageAccountName string

@description('Required. The name of the Container to create.')
param storageContainerName string

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' = {
    name: storageAccountName
    location: location
    sku: {
        name: 'Standard_LRS'
    }
    kind: 'StorageV2'
    properties: {
        isHnsEnabled: true
    }

    resource blobService 'blobServices@2021-09-01' = {
        name: 'default'

        resource container 'containers@2021-09-01' = {
            name: storageContainerName
        }
    }
}

@description('The resource ID of the created Storage Account.')
output storageAccountResourceId string = storageAccount.id
