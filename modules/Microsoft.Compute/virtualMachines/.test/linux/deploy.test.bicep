targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //
@description('Optional. The name of the resource group to deploy for a testing purposes')
@maxLength(90)
param resourceGroupName string = 'ms.compute.virtualMachines-${serviceShort}-test-rg'

@description('Optional. The location to deploy resources to')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints')
param serviceShort string = 'vmlindef'

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
    applicationSecurityGroupName: 'adp-<<namePrefix>>-asg-${serviceShort}'
    managedIdentityName: 'dep-<<namePrefix>>-msi-${serviceShort}'
    keyVaultName: 'dep-<<namePrefix>>-kv-${serviceShort}'
    loadBalancerName: 'dep-<<namePrefix>>-lb-${serviceShort}'
    recoveryServicesVaultName: 'dep-<<namePrefix>>-rsv-${serviceShort}'
    storageAccountName: 'dep<<namePrefix>>sa${serviceShort}01'
    storageUploadDeploymentScriptName: 'dep-<<namePrefix>>-sads-${serviceShort}'
  }
}

// Diagnostics
// ===========
module diagnosticDependencies '../../../../.shared/dependencyConstructs/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-diagDep'
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
    name: '<<namePrefix>>${serviceShort}'
    adminUsername: 'localAdminUser'
    imageReference: {
      offer: 'UbuntuServer'
      publisher: 'Canonical'
      sku: '18.04-LTS'
      version: 'latest'
    }
    nicConfigurations: [
      {
        deleteOption: 'Delete'
        ipConfigurations: [
          {
            applicationSecurityGroups: [
              {
                id: resourceGroupResources.outputs.applicationSecurityGroupResourceId
              }
            ]
            loadBalancerBackendAddressPools: [
              {
                id: resourceGroupResources.outputs.loadBalancerBackendPoolResourceId
              }
            ]
            name: 'ipconfig01'
            pipConfiguration: {
              publicIpNameSuffix: '-pip-01'
              roleAssignments: [
                {
                  principalIds: [
                    resourceGroupResources.outputs.managedIdentityPrincipalId
                  ]
                  roleDefinitionIdOrName: 'Reader'
                }
              ]
            }
            subnetResourceId: resourceGroupResources.outputs.subnetResourceId
          }
        ]
        nicSuffix: '-nic-01'
        roleAssignments: [
          {
            principalIds: [
              resourceGroupResources.outputs.managedIdentityPrincipalId
            ]
            roleDefinitionIdOrName: 'Reader'
          }
        ]
      }
    ]
    osDisk: {
      caching: 'ReadOnly'
      createOption: 'fromImage'
      deleteOption: 'Delete'
      diskSizeGB: '128'
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    osType: 'Linux'
    vmSize: 'Standard_B12ms'
    availabilityZone: 1
    backupPolicyName: resourceGroupResources.outputs.recoveryServicesVaultBackupPolicyName
    backupVaultName: last(split(resourceGroupResources.outputs.recoveryServicesVaultResourceId, '/'))
    backupVaultResourceGroup: (split(resourceGroupResources.outputs.recoveryServicesVaultResourceId, '/'))[4]
    dataDisks: [
      {
        caching: 'ReadWrite'
        createOption: 'Empty'
        deleteOption: 'Delete'
        diskSizeGB: '128'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
      {
        caching: 'ReadWrite'
        createOption: 'Empty'
        deleteOption: 'Delete'
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
    }
    extensionCustomScriptProtectedSetting: {
      commandToExecute: 'sudo apt-get update'
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
    extensionDSCConfig: {
      enabled: false
    }
    extensionMonitoringAgentConfig: {
      enabled: true
    }
    extensionNetworkWatcherAgentConfig: {
      enabled: true
    }
    lock: 'CanNotDelete'
    monitoringWorkspaceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
    publicKeys: [
      {
        keyData: 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDdOir5eO28EBwxU0Dyra7g9h0HUXDyMNFp2z8PhaTUQgHjrimkMxjYRwEOG/lxnYL7+TqZk+HcPTfbZOunHBw0Wx2CITzILt6531vmIYZGfq5YyYXbxZa5MON7L/PVivoRlPj5Z/t4RhqMhyfR7EPcZ516LJ8lXPTo8dE/bkOCS+kFBEYHvPEEKAyLs19sRcK37SeHjpX04zdg62nqtuRr00Tp7oeiTXA1xn5K5mxeAswotmd8CU0lWUcJuPBWQedo649b+L2cm52kTncOBI6YChAeyEc1PDF0Tn9FmpdOWKtI9efh+S3f8qkcVEtSTXoTeroBd31nzjAunMrZeM8Ut6dre+XeQQIjT7I8oEm+ZkIuIyq0x2fls8JXP2YJDWDqu8v1+yLGTQ3Z9XVt2lMti/7bIgYxS0JvwOr5n5L4IzKvhb4fm13LLDGFa3o7Nsfe3fPb882APE0bLFCmfyIeiPh7go70WqZHakpgIr6LCWTyePez9CsI/rfWDb6eAM8= generated-by-azure'
        path: '/home/localAdminUser/.ssh/authorized_keys'
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
    systemAssignedIdentity: true
    userAssignedIdentities: {
      '${resourceGroupResources.outputs.managedIdentityResourceId}': {}
    }
  }
}
