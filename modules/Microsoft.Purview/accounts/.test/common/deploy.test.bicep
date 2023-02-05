targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //
@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'ms.purview-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Tags')
param tags object = {}

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'pvacom'

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = false

// =========== //
// Deployments //
// =========== //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

module resourceGroupResources 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-paramNested'
  params: {
    virtualNetworkName: 'dep-<<namePrefix>>-vnet-${serviceShort}'
    managedIdentityName: 'dep-<<namePrefix>>-msi-${serviceShort}'
  }
}

// Diagnostics
// ===========
module diagnosticDependencies '../../../../.shared/dependencyConstructs/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep<<namePrefix>>diasa${serviceShort}01'
    logAnalyticsWorkspaceName: 'dep-<<namePrefix>>-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-<<namePrefix>>-evh-${serviceShort}01'
    eventHubNamespaceName: 'dep-<<namePrefix>>-evhns-${serviceShort}01'
    location: location

  }
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../deploy.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name)}-test-${serviceShort}'
  params: {
    name: '<<namePrefix>>${serviceShort}002'
    location: location
    tags: tags
    userAssignedIdentities: {
      '${nestedDependencies.outputs.managedIdentityResourceId}': {}
    }
    managedResourceGroupName: '<<namePrefix>>${serviceShort}002-managed-rg'
    publicNetworkAccess: 'Disabled'
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: diagnosticDependencies.outputs.storageAccountResourceId
    diagnosticWorkspaceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
    diagnosticEventHubAuthorizationRuleId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
    diagnosticEventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalIds: [
          nestedDependencies.outputs.managedIdentityPrincipalId
        ]
        principalType: 'ServicePrincipal'
      }
    ]
    subnetId: resourceGroupResources.outputs.subnetResourceId
    accountPrivateEndpointName: 'pe-<<namePrefix>>${serviceShort}002-account'
    accountPrivateEndpointNicName: 'nic-pe-<<namePrefix>>${serviceShort}002-account'
    accountPrivateEndpointIP: ''
    portalPrivateEndpointName: 'pe-<<namePrefix>>${serviceShort}002-portal'
    portalPrivateEndpointNicName: 'nic-pe-<<namePrefix>>${serviceShort}002-portal'
    portalPrivateEndpointIP: ''
    storageAccountBlobPrivateEndpointName: 'pe-<<namePrefix>>${serviceShort}002-sa-blob-blob'
    storageAccountBlobPrivateEndpointNicName: 'nic-pe-<<namePrefix>>${serviceShort}002-sa-blob-blob'
    storageAccountBlobPrivateEndpointIP: ''
    storageAccountQueuePrivateEndpointName: 'pe-<<namePrefix>>${serviceShort}002-sa-queue-blob'
    storageAccountQueuePrivateEndpointNicName: 'nic-pe-<<namePrefix>>${serviceShort}002-sa-queue-blob'
    storageAccountQueuePrivateEndpointIP: ''
    eventHubPrivateEndpointName: 'pe-<<namePrefix>>${serviceShort}002-eh'
    eventHubPrivateEndpointNicName: 'nic-e-<<namePrefix>>${serviceShort}002-eh'
    eventHubPrivateEndpointIP: ''
    enableDefaultTelemetry: enableDefaultTelemetry
    diagnosticLogCategoriesToEnable: [ 'allLogs' ]
    diagnosticMetricsToEnable: [ 'AllMetrics' ]
    lock: 'CanNotDelete'
  }
}
