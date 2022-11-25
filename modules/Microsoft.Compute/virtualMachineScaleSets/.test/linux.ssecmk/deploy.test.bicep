targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //
@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(80)
param resourceGroupName string = 'ms.compute.virtualmachinescalesets-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'cvmsslincmk'

@description('Optional. The password to leverage for the login.')
@secure()
param password string = newGuid()

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
  name: '${uniqueString(deployment().name, location)}-nestedDependencies'
  params: {
    location: location
    virtualNetworkName: 'dep-<<namePrefix>>-vnet-${serviceShort}'
    // Adding base time to make the name unique as purge protection must be enabled (but may not be longer than 24 characters total)
    keyVaultName: 'dep<<namePrefix>>kv${serviceShort}-${substring(uniqueString(baseTime), 0, 3)}'
    diskEncryptionSetName: 'dep-<<namePrefix>>-des-${serviceShort}'
    managedIdentityName: 'dep-<<namePrefix>>-msi-${serviceShort}'
    sshDeploymentScriptName: 'dep-<<namePrefix>>-ds-${serviceShort}'
    sshKeyName: 'dep-<<namePrefix>>-ssh-${serviceShort}'
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
    name: '<<namePrefix>>${serviceShort}001'
    adminUsername: 'scaleSetAdmin'
    imageReference: {
      publisher: 'Canonical'
      offer: '0001-com-ubuntu-server-jammy'
      sku: '22_04-lts-gen2'
      version: 'latest'
    }
    nicConfigurations: [
      {
        ipConfigurations: [
          {
            name: 'ipconfig1'
            properties: {
              subnet: {
                id: resourceGroupResources.outputs.subnetResourceId
              }
            }
          }
        ]
        nicSuffix: '-nic01'
      }
    ]
    osDisk: {
      diskSizeGB: '128'
      managedDisk: {
        storageAccountType: 'Premium_LRS'
        diskEncryptionSet: {
          id: resourceGroupResources.outputs.diskEncryptionSetResourceId
        }
      }
    }
    dataDisks: [
      {
        diskSizeGB: '128'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
          diskEncryptionSet: {
            id: resourceGroupResources.outputs.diskEncryptionSetResourceId
          }
        }
      }
    ]
    osType: 'Linux'
    skuName: 'Standard_B12ms'
    disablePasswordAuthentication: true
    publicKeys: [
      {
        keyData: resourceGroupResources.outputs.SSHKeyPublicKey
        path: '/home/scaleSetAdmin/.ssh/authorized_keys'
      }
    ]
  }
}
