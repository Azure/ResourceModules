targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

// Resource Group
@description('Required. The name of the resource group to deploy for a testing purposes')
param resourceGroupName string

// Shared
var location = deployment().location

// Diagnostic Storage Account
var storageAccountParameters = {
  name: 'adpsxxazsaaspar01'
  storageAccountKind: 'StorageV2'
  storageAccountSku: 'Standard_LRS'
  allowBlobPublicAccess: false
}

// Log Analytics
var logAnalyticsWorkspaceParameters = {
  name: 'adp-sxx-az-law-aspar-001'
}

// Event Hub Namespace
var eventHubNamespaceParameters = {
  name: 'adp-sxx-az-evhns-aspar-001'
  eventHubs: [
    {
      name: 'adp-sxx-az-evh-aspar-001'
      authorizationRules: [
        {
          name: 'RootManageSharedAccessKey'
          rights: [
            'Listen'
            'Manage'
            'Send'
          ]
        }
        {
          name: 'SendListenAccess'
          rights: [
            'Listen'
            'Send'
          ]
        }
      ]
    }
  ]
}

// =========== //
// Deployments //
// =========== //

// Resource Group
module resourceGroup '../../../../../arm/Microsoft.Resources/resourceGroups/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-rg'
  params: {
    name: resourceGroupName
    location: location
  }
}

// Storage Accounts
module storageAccount '../../../../../arm/Microsoft.Storage/storageAccounts/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-sa'
  scope: az.resourceGroup(resourceGroupName)
  params: {
    name: storageAccountParameters.name
    storageAccountKind: storageAccountParameters.storageAccountKind
    storageAccountSku: storageAccountParameters.storageAccountSku
    allowBlobPublicAccess: storageAccountParameters.allowBlobPublicAccess
  }
  dependsOn: [
    resourceGroup
  ]
}

// Log Analytics Workspace
module logAnalyticsWorkspace '../../../../../arm/Microsoft.OperationalInsights/workspaces/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-oms'
  scope: az.resourceGroup(resourceGroupName)
  params: {
    name: logAnalyticsWorkspaceParameters.name
  }
  dependsOn: [
    resourceGroup
  ]
}

// Log Analytics Workspace
module eventHubNamespace '../../../../../arm/Microsoft.EventHub/namespaces/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-ehn'
  scope: az.resourceGroup(resourceGroupName)
  params: {
    name: eventHubNamespaceParameters.name
    eventHubs: eventHubNamespaceParameters.eventHubs
  }
  dependsOn: [
    resourceGroup
  ]
}

@description('The name of the resource group')
output resourceGroupName string = resourceGroup.outputs.resourceGroupName

@description('The resource ID of the resource group')
output resourceGroupResourceId string = resourceGroup.outputs.resourceGroupResourceId
