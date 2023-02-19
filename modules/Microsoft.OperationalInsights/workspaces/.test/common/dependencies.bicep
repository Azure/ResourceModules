@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Storage Account to create.')
param storageAccountName string

@description('Required. The name of the Automation Account to create.')
param automationAccountName string

@description('Required. The name of the Event Hub Workspace to create.')
param eventHubNamespaceName string

@description('Required. The name of the Event Hub to create.')
param eventHubName string

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

resource automationAccount 'Microsoft.Automation/automationAccounts@2021-06-22' = {
  name: automationAccountName
  location: location
  properties: {
    sku: {
      name: 'Basic'
    }
  }
}

resource eventHubNamespace 'Microsoft.EventHub/namespaces@2022-10-01-preview' = {
  name: eventHubNamespaceName
  location: location
  sku: {
    name: 'Basic'
    tier: 'Basic'
    capacity: 1
  }
  properties: {
    minimumTlsVersion: '1.2'
    publicNetworkAccess: 'Enabled'
    disableLocalAuth: false
    isAutoInflateEnabled: false
    maximumThroughputUnits: 0
    kafkaEnabled: false
    zoneRedundant: true
  }

  resource eventHub 'eventhubs@2022-10-01-preview' = {
    name: eventHubName
    properties: {
      messageRetentionInDays: 1
    }
  }
}

@description('The resource ID of the created Storage Account.')
output storageAccountResourceId string = storageAccount.id

@description('The resource ID of the created Automation Account.')
output automationAccountResourceId string = automationAccount.id

@description('The resource ID of the created Eventhub Namespace.')
output eventHubNamespaceResourceId string = eventHubNamespace.id

@description('The name of the created Eventhub.')
output eventHubName string = eventHubNamespace::eventHub.name
