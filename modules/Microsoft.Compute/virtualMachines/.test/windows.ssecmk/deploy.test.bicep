targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //
@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(80)
param resourceGroupName string = 'ms.compute.virtualMachines-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'cvmwincmk'

@description('Optional. The password to leverage for the login.')
@secure()
param password string = newGuid()

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
  name: '${uniqueString(deployment().name, location)}-nestedDependencies'
  params: {
    location: location
    virtualNetworkName: 'dep-<<namePrefix>>-vnet-${serviceShort}'
    // managedIdentityName: 'dep-<<namePrefix>>-msi-${serviceShort}'
    keyVaultName: 'dep-<<namePrefix>>-kv-${serviceShort}'
    diskEncryptionSetName: 'dep-<<namePrefix>>-des-${serviceShort}'
  }
}

// ============== //
// Test Execution //
// ============== //
module testDeployment '../../deploy.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name)}-test-${serviceShort}'
  params: {
    location: location
    name: '<<namePrefix>>${serviceShort}'
    adminUsername: 'localAdminUser'
    imageReference: {
      publisher: 'MicrosoftWindowsServer'
      offer: 'WindowsServer'
      sku: '2019-datacenter'
      version: 'latest'
    }
    nicConfigurations: [
      {
        ipConfigurations: [
          {
            name: 'ipconfig01'
            subnetResourceId: resourceGroupResources.outputs.subnetResourceId
          }
        ]
        nicSuffix: '-nic-01'
      }
    ]
    osDisk: {
      diskSizeGB: '128'
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    osType: 'Windows'
    vmSize: 'Standard_B12ms'
    adminPassword: password
    dataDisks: [
      {
        diskSizeGB: '128'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
      {
        diskSizeGB: '128'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
    ]
  }
}
