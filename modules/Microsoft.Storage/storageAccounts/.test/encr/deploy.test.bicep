targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //
@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'ms.storage.storageaccounts-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'stsencr'

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
    // Adding base time to make the name unique as purge protection must be enabled (but may not be longer than 24 characters total)
    keyVaultName: 'dep-<<namePrefix>>-kv-${serviceShort}-${substring(uniqueString(baseTime), 0, 3)}'
    virtualNetworkName: 'dep-<<namePrefix>>-vnet-${serviceShort}'
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
    storageAccountSku: 'Standard_LRS'
    allowBlobPublicAccess: false
    requireInfrastructureEncryption: true
    privateEndpoints: [
      {
        service: 'blob'
        subnetResourceId: resourceGroupResources.outputs.subnetResourceId
        privateDnsZoneGroup: {
          privateDNSResourceIds: [
            resourceGroupResources.outputs.privateDNSZoneResourceId
          ]
        }
      }
    ]
    blobServices: {
      containers: [
        {
          name: '<<namePrefix>>container'
          publicAccess: 'None'
        }
      ]
    }
    systemAssignedIdentity: false
    userAssignedIdentities: {
      '${resourceGroupResources.outputs.managedIdentityResourceId}': {}
    }
    cMKKeyVaultResourceId: resourceGroupResources.outputs.keyVaultResourceId
    cMKKeyName: resourceGroupResources.outputs.keyName
    cMKUserAssignedIdentityResourceId: resourceGroupResources.outputs.managedIdentityResourceId
  }
}
