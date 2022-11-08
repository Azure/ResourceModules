targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //
@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'ms.servicefabric.clusters-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'sfccom'

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
    managedIdentityName: 'dep-<<namePrefix>>-msi-${serviceShort}'
    storageAccountName: 'dep<<namePrefix>>azsa${serviceShort}01'
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
    lock: 'CanNotDelete'
    tags: {
      resourceType: 'Service Fabric'
      clusterName: '<<namePrefix>>${serviceShort}001'

    }
    addOnFeatures: [
      'RepairManager'
      'DnsService'
      'BackupRestoreService'
      'ResourceMonitorService'
    ]
    maxUnusedVersionsToKeep: 2
    azureActiveDirectory: {
      clientApplication: resourceGroupResources.outputs.managedIdentityPrincipalId
      clusterApplication: 'cf33fea8-b30f-424f-ab73-c48d99e0b222'
      tenantId: '<<tenantId>>'
    }
    certificateCommonNames: {
      commonNames: [
        {
          certificateCommonName: 'certcommon'
          certificateIssuerThumbprint: '0AC113D5E1D94C401DDEB0EE2B1B96CC130'
        }
      ]
      x509StoreName: ''
    }
    clientCertificateCommonNames: [
      {
        certificateCommonName: 'clientcommoncert1'
        certificateIssuerThumbprint: '0AC113D5E1D94C401DDEB0EE2B1B96CC130'
        isAdmin: false
      }
      {
        certificateCommonName: 'clientcommoncert2'
        certificateIssuerThumbprint: '0AC113D5E1D94C401DDEB0EE2B1B96CC131'
        isAdmin: false
      }
    ]
    clientCertificateThumbprints: [
      {
        certificateThumbprint: '0AC113D5E1D94C401DDEB0EE2B1B96CC130'
        isAdmin: false
      }
      {
        certificateThumbprint: '0AC113D5E1D94C401DDEB0EE2B1B96CC131'
        'isAdmin': false
      }
    ]
    diagnosticsStorageAccountConfig: {
      blobEndpoint: 'https://${last(split(resourceGroupResources.outputs.storageAccountResourceId, '/'))}.blob.${environment().suffixes.storage}/'
      protectedAccountKeyName: 'StorageAccountKey1'
      queueEndpoint: 'https://${last(split(resourceGroupResources.outputs.storageAccountResourceId, '/'))}.queue.${environment().suffixes.storage}/'
      storageAccountName: last(split(resourceGroupResources.outputs.storageAccountResourceId, '/'))
      tableEndpoint: 'https://${last(split(resourceGroupResources.outputs.storageAccountResourceId, '/'))}.table.${environment().suffixes.storage}/'
    }
    fabricSettings: [
      {
        name: 'Security'
        parameters: [
          {
            name: 'ClusterProtectionLevel'
            value: 'EncryptAndSign'
          }
        ]
      }
      {
        name: 'UpgradeService'
        parameters: [
          {
            name: 'AppPollIntervalInSeconds'
            value: '60'
          }
        ]
      }
    ]
    managementEndpoint: 'https://<<namePrefix>>${serviceShort}001.westeurope.cloudapp.azure.com:19080'
    reliabilityLevel: 'Silver'
    nodeTypes: [
      {
        applicationPorts: {
          endPort: 30000
          startPort: 20000
        }
        clientConnectionEndpointPort: 19000
        durabilityLevel: 'Silver'
        ephemeralPorts: {
          endPort: 65534
          startPort: 49152
        }
        httpGatewayEndpointPort: 19080
        isPrimary: true
        name: 'Node01'

        isStateless: false
        multipleAvailabilityZones: false

        placementProperties: {}
        reverseProxyEndpointPort: ''
        vmInstanceCount: 5
      }
      {
        applicationPorts: {
          endPort: 30000
          startPort: 20000
        }
        clientConnectionEndpointPort: 19000
        durabilityLevel: 'Bronze'
        ephemeralPorts: {
          endPort: 64000
          startPort: 49000
          httpGatewayEndpointPort: 19007
          isPrimary: true
          name: 'Node02'
          vmInstanceCount: 5
        }
      }
    ]
    notifications: [
      {
        isEnabled: true
        notificationCategory: 'WaveProgress'
        notificationLevel: 'Critical'
        notificationTargets: [
          {
            notificationChannel: 'EmailUser'
            receivers: [
              'SomeReceiver'
            ]
          }
        ]
      }
    ]
    upgradeDescription: {
      forceRestart: false
      upgradeReplicaSetCheckTimeout: '1.00:00:00'
      healthCheckWaitDuration: '00:00:30'
      healthCheckStableDuration: '00:01:00'
      healthCheckRetryTimeout: '00:45:00'
      upgradeTimeout: '02:00:00'
      upgradeDomainTimeout: '02:00:00'
      healthPolicy: {
        maxPercentUnhealthyNodes: 0
        maxPercentUnhealthyApplications: 0
      }
      deltaHealthPolicy: {
        maxPercentDeltaUnhealthyNodes: 0
        maxPercentUpgradeDomainDeltaUnhealthyNodes: 0
        maxPercentDeltaUnhealthyApplications: 0
      }

    }
    vmImage: 'Linux'
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalIds: [
          resourceGroupResources.outputs.managedIdentityPrincipalId
        ]
        principalType: 'ServicePrincipal'
      }
    ]
    applicationTypes: [
      {
        name: 'WordCount' // not idempotent
      }
    ]
  }
}
