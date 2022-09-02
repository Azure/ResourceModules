targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //
@description('Optional. The name of the resource group to deploy for a testing purposes')
@maxLength(90)
param resourceGroupName string = 'ms.compute.virtualmachinescalesets-${serviceShort}-rg'

@description('Optional. The location to deploy resources to')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment .Should be kept short to not run into resource-name length-constraints')
param serviceShort string = 'cvmsslin'

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
    keyVaultName: 'dep-<<namePrefix>>-kv-${serviceShort}'
    storageAccountName: 'dep<<namePrefix>>sa${serviceShort}01'
    storageUploadDeploymentScriptName: 'dep-<<namePrefix>>-sads-${serviceShort}'
    sshDeploymentScriptName: 'dep-<<namePrefix>>-ds-${serviceShort}'
    sshKeyName: 'dep-<<namePrefix>>-ssh-${serviceShort}'
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
    adminUsername: 'scaleSetAdmin'
    imageReference: {
      offer: 'UbuntuServer'
      publisher: 'Canonical'
      sku: '18.04-LTS'
      version: 'latest'
    }
    osDisk: {
      createOption: 'fromImage'
      diskSizeGB: '128'
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    osType: 'Linux'
    skuName: 'Standard_B12ms'
    availabilityZones: [
      '2'
    ]
    bootDiagnosticStorageAccountName: last(split(diagnosticDependencies.outputs.storageAccountResourceId, '/'))
    dataDisks: [
      {
        caching: 'ReadOnly'
        createOption: 'Empty'
        diskSizeGB: '256'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
      {
        caching: 'ReadOnly'
        createOption: 'Empty'
        diskSizeGB: '128'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
    ]
    diagnosticStorageAccountId: diagnosticDependencies.outputs.storageAccountResourceId
    diagnosticWorkspaceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
    diagnosticEventHubAuthorizationRuleId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
    diagnosticEventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
    diagnosticLogsRetentionInDays: 7
    disablePasswordAuthentication: true
    encryptionAtHost: false
    extensionCustomScriptConfig: {
      enabled: true
      fileData: [
        {
          storageAccountId: resourceGroupResources.outputs.storageAccountResourceId
          uri: resourceGroupResources.outputs.storageAccountCSEFileUrl
        }
      ]
      protectedSettings: {
        commandToExecute: 'sudo apt-get update'
      }
    }
    extensionDependencyAgentConfig: {
      enabled: true
    }
    extensionDiskEncryptionConfig: {
      enabled: true
      settings: {
        EncryptionOperation: 'EnableEncryption'
        KekVaultResourceId: resourceGroupResources.outputs.keyVaultResourceId
        KeyEncryptionAlgorithm: 'RSA-OAEP'
        KeyEncryptionKeyURL: resourceGroupResources.outputs.keyVaultEncryptionKeyUrl
        KeyVaultResourceId: resourceGroupResources.outputs.keyVaultResourceId
        KeyVaultURL: resourceGroupResources.outputs.keyVaultUrl
        ResizeOSDisk: 'false'
        VolumeType: 'All'
      }
    }
    extensionMonitoringAgentConfig: {
      enabled: true
    }
    extensionNetworkWatcherAgentConfig: {
      enabled: true
    }
    lock: 'CanNotDelete'
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
    publicKeys: [
      {
        keyData: resourceGroupResources.outputs.SSHKey
        path: '/home/scaleSetAdmin/.ssh/authorized_keys'
      }
    ]
    roleAssignments: [
      {
        principalIds: [
          resourceGroupResources.outputs.managedIdentityPrincipalId
        ]
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    scaleSetFaultDomain: 1
    skuCapacity: 1
    systemAssignedIdentity: true
    upgradePolicyMode: 'Manual'
    userAssignedIdentities: {
      '${resourceGroupResources.outputs.managedIdentityResourceId}': {}
    }
    vmNamePrefix: 'vmsslinvm'
    vmPriority: 'Regular'
  }
}
