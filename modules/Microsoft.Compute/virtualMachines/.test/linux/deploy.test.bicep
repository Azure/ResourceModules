targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'ms.compute.virtualMachines-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'cvmlincom'

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-nestedDependencies'
  params: {
    location: location
    virtualNetworkName: 'dep-<<namePrefix>>-vnet-${serviceShort}'
    applicationSecurityGroupName: 'dep-<<namePrefix>>-asg-${serviceShort}'
    managedIdentityName: 'dep-<<namePrefix>>-msi-${serviceShort}'
    keyVaultName: 'dep-<<namePrefix>>-kv-${serviceShort}'
    loadBalancerName: 'dep-<<namePrefix>>-lb-${serviceShort}'
    recoveryServicesVaultName: 'dep-<<namePrefix>>-rsv-${serviceShort}'
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
  name: '${uniqueString(deployment().name, location)}-test-${serviceShort}'
  params: {
    enableDefaultTelemetry: enableDefaultTelemetry
    name: '<<namePrefix>>${serviceShort}'
    location: location
    adminUsername: 'localAdministrator'
    imageReference: {
      publisher: 'Canonical'
      offer: '0001-com-ubuntu-server-focal'
      sku: '20_04-lts-gen2' // Note: 22.04 does not support OMS extension
      version: 'latest'
    }
    nicConfigurations: [
      {
        deleteOption: 'Delete'
        ipConfigurations: [
          {
            applicationSecurityGroups: [
              {
                id: nestedDependencies.outputs.applicationSecurityGroupResourceId
              }
            ]
            loadBalancerBackendAddressPools: [
              {
                id: nestedDependencies.outputs.loadBalancerBackendPoolResourceId
              }
            ]
            name: 'ipconfig01'
            pipConfiguration: {
              publicIpNameSuffix: '-pip-01'
              roleAssignments: [
                {
                  roleDefinitionIdOrName: 'Reader'
                  principalIds: [
                    nestedDependencies.outputs.managedIdentityPrincipalId
                  ]
                  principalType: 'ServicePrincipal'
                }
              ]
            }
            subnetResourceId: nestedDependencies.outputs.subnetResourceId
          }
        ]
        nicSuffix: '-nic-01'
        roleAssignments: [
          {
            roleDefinitionIdOrName: 'Reader'
            principalIds: [
              nestedDependencies.outputs.managedIdentityPrincipalId
            ]
            principalType: 'ServicePrincipal'
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
    vmSize: 'Standard_DS2_v2'
    availabilityZone: 1
    backupPolicyName: nestedDependencies.outputs.recoveryServicesVaultBackupPolicyName
    backupVaultName: nestedDependencies.outputs.recoveryServicesVaultName
    backupVaultResourceGroup: nestedDependencies.outputs.recoveryServicesVaultResourceGroupName
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
    enableAutomaticUpdates: true
    patchMode: 'AutomaticByPlatform'
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
          storageAccountId: nestedDependencies.outputs.storageAccountResourceId
          uri: nestedDependencies.outputs.storageAccountCSEFileUrl
        }
      ]
    }
    extensionCustomScriptProtectedSetting: {
      commandToExecute: 'value=$(./${nestedDependencies.outputs.storageAccountCSEFileName}); echo "$value"'
    }
    extensionDependencyAgentConfig: {
      enabled: true
    }
    extensionAzureDiskEncryptionConfig: {
      enabled: true
      settings: {
        EncryptionOperation: 'EnableEncryption'
        KekVaultResourceId: nestedDependencies.outputs.keyVaultResourceId
        KeyEncryptionAlgorithm: 'RSA-OAEP'
        KeyEncryptionKeyURL: nestedDependencies.outputs.keyVaultEncryptionKeyUrl
        KeyVaultResourceId: nestedDependencies.outputs.keyVaultResourceId
        KeyVaultURL: nestedDependencies.outputs.keyVaultUrl
        ResizeOSDisk: 'false'
        VolumeType: 'All'
      }
    }
    extensionAadJoinConfig: {
      enabled: true
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
        keyData: nestedDependencies.outputs.SSHKeyPublicKey
        path: '/home/localAdministrator/.ssh/authorized_keys'
      }
    ]
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalIds: [
          nestedDependencies.outputs.managedIdentityPrincipalId
        ]
        principalType: 'ServicePrincipal'
      }
    ]
    systemAssignedIdentity: true
    userAssignedIdentities: {
      '${nestedDependencies.outputs.managedIdentityResourceId}': {}
    }
  }
  dependsOn: [
    nestedDependencies // Required to leverage `existing` SSH key reference
  ]
}
