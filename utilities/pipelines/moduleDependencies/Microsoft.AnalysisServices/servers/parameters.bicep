targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

// Shared
var deploymentPrefix = 'analysisServicesServersParameters'
var location = deployment().location

// Resource Group
var resourceGroupParameters = {
  name: 'test-${deploymentPrefix}-rg'
}

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
  // scope: subscription()
  params: {
    name: resourceGroupParameters.name
    location: location
  }
}

// Storage Accounts
module storageAccount '../../../../../arm/Microsoft.Storage/storageAccounts/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-sa'
  scope: az.resourceGroup(resourceGroupParameters.name)
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
  scope: az.resourceGroup(resourceGroupParameters.name)
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
  scope: az.resourceGroup(resourceGroupParameters.name)
  params: {
    name: eventHubNamespaceParameters.name
    eventHubs: eventHubNamespaceParameters.eventHubs
  }
  dependsOn: [
    resourceGroup
  ]
}
