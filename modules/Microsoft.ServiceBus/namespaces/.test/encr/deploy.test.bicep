targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //
@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'ms.servicebus.namespaces-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'sbnencr'

@description('Generated. Used as a basis for unique resource names.')
param baseTime string = utcNow('u')

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
    // Adding base time to make the name unique as purge protection must be enabled (but may not be longer than 24 characters total)
    keyVaultName: 'dep-<<namePrefix>>-kv-${serviceShort}-${substring(uniqueString(baseTime), 0, 3)}'
    managedIdentityName: 'dep-<<namePrefix>>-msi-${serviceShort}'
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
    skuName: 'Premium'
    roleAssignments: [
      {
        principalIds: [
          resourceGroupResources.outputs.managedIdentityPrincipalId
        ]
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    networkRuleSets: {
      defaultAction: 'Deny'
      trustedServiceAccessEnabled: true
      virtualNetworkRules: [
        {
          subnet: {
            ignoreMissingVnetServiceEndpoint: true
            id: resourceGroupResources.outputs.subnetResourceId
          }
        }
      ]
      ipRules: [
        {
          ipMask: '10.0.1.0/32'
          action: 'Allow'
        }
        {
          ipMask: '10.0.2.0/32'
          action: 'Allow'
        }
      ]
    }
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
        name: 'AnotherKey'
        rights: [
          'Listen'
          'Send'
        ]
      }
    ]
    systemAssignedIdentity: false
    userAssignedIdentities: {
      '${resourceGroupResources.outputs.managedIdentityResourceId}': {}
    }
    cMKKeyVaultResourceId: resourceGroupResources.outputs.keyVaultResourceId
    cMKKeyName: resourceGroupResources.outputs.keyName
    cMKUserAssignedIdentityResourceId: resourceGroupResources.outputs.managedIdentityResourceId
  }
}
