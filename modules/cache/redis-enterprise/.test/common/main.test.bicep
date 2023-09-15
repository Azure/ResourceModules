targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'ms.cache.redisenterprise-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'crecom'

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '[[namePrefix]]'

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
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
  }
}

// Diagnostics
// ===========
module diagnosticDependencies '../../../../.shared/.templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep${namePrefix}diasa${serviceShort}01'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}'
    location: location
  }
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../main.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-test-${serviceShort}'
  params: {
    enableDefaultTelemetry: enableDefaultTelemetry
    name: '${namePrefix}${serviceShort}001'
    capacity: 2
    diagnosticStorageAccountId: diagnosticDependencies.outputs.storageAccountResourceId
    diagnosticWorkspaceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
    diagnosticEventHubAuthorizationRuleId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
    diagnosticEventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
    diagnosticSettingsName: 'redisdiagnostics'
    lock: 'CanNotDelete'
    minimumTlsVersion: '1.2'
    zoneRedundant: true
    privateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDNSResourceIds: [
            nestedDependencies.outputs.privateDNSResourceId
          ]
        }
        service: 'redisEnterprise'
        subnetResourceId: nestedDependencies.outputs.subnetResourceId
        tags: {
          'hidden-title': 'This is visible in the resource name'
          Environment: 'Non-Prod'
          Role: 'DeploymentValidation'
        }
      }
    ]
    databases: [
      {
        name: '${namePrefix}${serviceShort}-db-01'
      }
      {
        name: '${namePrefix}${serviceShort}-db-02'
        clusteringPolicy: 'EnterpriseCluster'
        evictionPolicy: 'AllKeysLFU'
        persistenceAofEnabled: true
        persistenceAofFrequency: 'always'
        persistenceRdbEnabled: true
        persistenceRdbFrequency: '12h'
        port: 5000
      }
      {
        name: '${namePrefix}${serviceShort}-db-03'
        persistenceAofEnabled: true
        persistenceRdbEnabled: true
        port: 6000
        modules: [
          {
            name: 'RedisBloom'
          }
          {
            name: 'RedisTimeSeries'
          }
        ]
        geoReplication: {
          groupNickname: '${namePrefix}${serviceShort}-db-03-rep'
          linkedDatabases: [
            {
              id: '${namePrefix}${serviceShort}-db-01'
            }
          ]
        }
      }
    ]
    tags: {
      'hidden-title': 'This is visible in the resource name'
      resourceType: 'Redis Cache'
    }
  }
}
