targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //
@description('Optional. The name of the resource group to deploy for a testing purposes.')
@maxLength(90)
param resourceGroupName string = 'ms.datafactory.factories-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'dffcom'

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
    keyVaultName: 'dep-<<namePrefix>>-kv-${serviceShort}'
    managedIdentityName: 'dep-<<namePrefix>>-msi-${serviceShort}'
    storageAccountName: 'dep<<namePrefix>>st${serviceShort}'
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
    eventHubNamespaceEventHubName: 'dep-<<namePrefix>>-evh-${serviceShort}'
    eventHubNamespaceName: 'dep-<<namePrefix>>-evhns-${serviceShort}'
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
    name: '<<namePrefix>>${serviceShort}001'
    cMKKeyName: resourceGroupResources.outputs.keyVaultEncryptionKeyName
    cMKKeyVaultResourceId: resourceGroupResources.outputs.keyVaultResourceId
    cMKUserAssignedIdentityResourceId: resourceGroupResources.outputs.managedIdentityResourceId
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: diagnosticDependencies.outputs.storageAccountResourceId
    diagnosticWorkspaceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
    diagnosticEventHubAuthorizationRuleId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
    diagnosticEventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
    gitConfigureLater: true
    integrationRuntime: {
      managedVirtualNetworkName: 'default'
      name: 'AutoResolveIntegrationRuntime'
      type: 'Managed'
      typeProperties: {
        computeProperties: {
          location: 'AutoResolve'
        }
      }
    }
    lock: 'CanNotDelete'
    managedPrivateEndpoints: [
      {
        fqdns: [
          resourceGroupResources.outputs.storageAccountBlobEndpoint
        ]
        groupId: 'blob'
        name: '${resourceGroupResources.outputs.storageAccountName}-managed-privateEndpoint'
        privateLinkResourceId: resourceGroupResources.outputs.storageAccountResourceId
      }
    ]
    managedVirtualNetworkName: 'default'
    privateEndpoints: [
      {
        privateDnsZoneGroups: {
          privateDNSResourceIds: [
            resourceGroupResources.outputs.privateDNSResourceId
          ]
        }
        service: 'dataFactory'
        subnetResourceId: resourceGroupResources.outputs.subnetResourceId
      }
    ]
    publicNetworkAccess: 'Disabled'
    roleAssignments: [
      {
        principalIds: [
          resourceGroupResources.outputs.managedIdentityPrincipalId
        ]
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    systemAssignedIdentity: true
    userAssignedIdentities: {
      '${resourceGroupResources.outputs.managedIdentityResourceId}': {}
    }
  }
}
