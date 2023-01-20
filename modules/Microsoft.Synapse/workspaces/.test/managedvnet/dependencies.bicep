@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Storage Account to create.')
param storageAccountName string

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
            name: 'synapsews'
        }
    }
}

@description('The name of the created Storage Account.')
output storageAccountName string = storageAccount.name

@description('The name of the created container.')
output storageContainerName string = storageAccount::blobService::container.name
