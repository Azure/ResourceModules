// ========== //
// Parameters //
// ========== //

@description('Required. The name of the resource group to deploy for a testing purposes')
@maxLength(90)
param resourceGroupName string

@description('Required. The name of the storage account to create')
param storageAccountName string

@description('Required. The name of the log analytics workspace to create')
param logAnalyticsWorkspaceName string

@description('Required. The name of the event hub namespace to be created')
param eventHubNamespaceName string

@description('Required. The name of the event hub to be created inside the event hub namespace')
param eventHubNamespaceEventHubName string

@description('Optional. The location to deploy to')
param location string = resourceGroup().location

// =========== //
// Deployments //
// =========== //

module storageAccount '../../Microsoft.Storage/storageAccounts/deploy.bicep' = {
  scope: az.resourceGroup(resourceGroupName)
  name: '${uniqueString(deployment().name, location)}-sa'
  params: {
    name: storageAccountName
    storageAccountKind: 'StorageV2'
    storageAccountSku: 'Standard_LRS'
    allowBlobPublicAccess: false
    location: location
  }
}

module logAnalyticsWorkspace '../../Microsoft.OperationalInsights/workspaces/deploy.bicep' = {
  scope: az.resourceGroup(resourceGroupName)
  name: '${uniqueString(deployment().name, location)}-oms'
  params: {
    name: logAnalyticsWorkspaceName
    location: location
  }
}

module eventHubNamespace '../../Microsoft.EventHub/namespaces/deploy.bicep' = {
  scope: az.resourceGroup(resourceGroupName)
  name: '${uniqueString(deployment().name, location)}-ehn'
  params: {
    name: eventHubNamespaceName
    eventHubs: [
      {
        name: eventHubNamespaceEventHubName
        authorizationRules: [
          {
            name: 'RootManageSharedAccessKey'
            rights: [
              'Listen'
              'Manage'
              'Send'
            ]
          }
        ]
      }
    ]
    location: location
  }
}

// ======= //
// Outputs //
// ======= //

output storageAccountResourceId string = storageAccount.outputs.resourceId
output logAnalyticsWorkspaceResourceId string = logAnalyticsWorkspace.outputs.resourceId
output eventHubNamespaceResourceId string = eventHubNamespace.outputs.resourceId
