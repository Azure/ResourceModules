@description('Required. Name of the Serivce Fabric cluster.')
param serviceFabricClusterName string = ''

@description('Optional. Application name.')
param applicationName string = 'defaultApplication'

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Describes the managed identities for an Azure resource.')
param identity object = {}

@description('Optional. The application resource properties.')
param properties object = {}

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

var identity_var = {
  type: !empty(identity) ? identity.type : 'None'
  userAssignedIdentities: !empty(identity) ? identity.userAssignedIdentities : null
}

var propertiesManagedIdentities_var = [for index in range(0, length(properties.managedIdentities)): {
  name: properties.managedIdentities.name[index]
  principalId: properties.managedIdentities.principalId[index]
}]

var propertiesMetrics_var = [for index in range(0, length(properties.metrics)): {
  maximumCapacity: contains(properties.metrics, 'maximumCapacity') ? properties.metrics.maximumCapacity : 0
  name: !empty(properties.metrics.name) ? properties.metrics.name : null
  reservationCapacity: contains(properties.metrics, 'reservationCapacity') ? properties.metrics.reservationCapacity : 0
  totalApplicationCapacity: contains(properties.metrics, 'totalApplicationCapacity') ? properties.metrics.totalApplicationCapacity : 1
}]

var upgradePolicy_var = {
  applicationHealthPolicy: {
    considerWarningAsError: contains(properties.upgradePolicy, 'considerWarningAsError') ? properties.upgradePolicy.considerWarningAsError : false
    defaultServiceTypeHealthPolicy: {
      maxPercentUnhealthyPartitionsPerService: contains(properties.upgradePolicy.defaultServiceTypeHealthPolicy, 'maxPercentUnhealthyPartitionsPerService') ? properties.upgradePolicy.defaultServiceTypeHealthPolicy.maxPercentUnhealthyPartitionsPerService : 0
      maxPercentUnhealthyReplicasPerPartition: contains(properties.upgradePolicy.defaultServiceTypeHealthPolicy, 'maxPercentUnhealthyReplicasPerPartition') ? properties.upgradePolicy.defaultServiceTypeHealthPolicy.maxPercentUnhealthyReplicasPerPartition : 0
      maxPercentUnhealthyServices: contains(properties.upgradePolicy.defaultServiceTypeHealthPolicy, 'maxPercentUnhealthyServices') ? properties.upgradePolicy.defaultServiceTypeHealthPolicy.maxPercentUnhealthyServices : 0
    }
    maxPercentUnhealthyDeployedApplications: contains(properties.upgradePolicy, 'maxPercentUnhealthyDeployedApplications') ? properties.upgradePolicy.maxPercentUnhealthyDeployedApplications : 0
    serviceTypeHealthPolicyMap: !empty(properties.upgradePolicy.serviceTypeHealthPolicyMap) ? properties.upgradePolicy.serviceTypeHealthPolicyMap : null
  }
  forceRestart: contains(properties.upgradePolicy, 'forceRestart') ? properties.upgradePolicy.forceRestart : false
  recreateApplication: contains(properties.upgradePolicy, 'recreateApplication') ? properties.upgradePolicy.recreateApplication : false
  rollingUpgradeMonitoringPolicy: {
    failureAction: !empty(properties.upgradePolicy.rollingUpgradeMonitoringPolicy.failureAction) ? properties.upgradePolicy.rollingUpgradeMonitoringPolicy.failureAction : 'Manual'
    healthCheckRetryTimeout: !empty(properties.upgradePolicy.rollingUpgradeMonitoringPolicy.healthCheckRetryTimeout) ? properties.upgradePolicy.rollingUpgradeMonitoringPolicy.healthCheckRetryTimeout : null
    healthCheckStableDuration: !empty(properties.upgradePolicy.rollingUpgradeMonitoringPolicy.healthCheckStableDuration) ? properties.upgradePolicy.rollingUpgradeMonitoringPolicy.healthCheckStableDuration : null
    healthCheckWaitDuration: !empty(properties.upgradePolicy.rollingUpgradeMonitoringPolicy.healthCheckWaitDuration) ? properties.upgradePolicy.rollingUpgradeMonitoringPolicy.healthCheckWaitDuration : null
    upgradeDomainTimeout: !empty(properties.upgradePolicy.rollingUpgradeMonitoringPolicy.upgradeDomainTimeout) ? properties.upgradePolicy.rollingUpgradeMonitoringPolicy.upgradeDomainTimeout : null
    upgradeTimeout: !empty(properties.upgradePolicy.rollingUpgradeMonitoringPolicy.upgradeTimeout) ? properties.upgradePolicy.rollingUpgradeMonitoringPolicy.upgradeTimeout : null
  }
  upgradeMode: !empty(properties.upgradePolicy.upgradeMode) ? properties.upgradePolicy.upgradeMode : 'Invalid'
  upgradeReplicaSetCheckTimeout: !empty(properties.upgradePolicy.upgradeReplicaSetCheckTimeout) ? properties.upgradePolicy.upgradeReplicaSetCheckTimeout : null
}

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource serviceFabricCluster 'Microsoft.ServiceFabric/clusters@2021-06-01' existing = {
  name: serviceFabricClusterName
}

resource applications 'Microsoft.ServiceFabric/clusters/applications@2021-06-01' = {
  name: applicationName
  location: location
  parent: serviceFabricCluster
  tags: tags
  identity: !empty(identity) ? identity_var : null
  properties: {
    managedIdentities: !empty(properties.managedIdentities) ? propertiesManagedIdentities_var : null
    maximumNodes: contains(properties, 'maximumNodes') ? properties.maximumNodes : 0
    metrics: !empty(properties.metrics) ? propertiesMetrics_var : null
    minimumNodes: contains(properties, 'minimumNodes') ? properties.minimumNodes : 0
    parameters: !empty(properties.parameters) ? properties.parameters : null
    removeApplicationCapacity: contains(properties, 'removeApplicationCapacity') ? properties.removeApplicationCapacity : false
    typeName: !empty(properties.typeName) ? properties.typeName : null
    typeVersion: !empty(properties.typeVersion) ? properties.typeVersion : null
    upgradePolicy: !empty(properties.upgradePolicy) ? upgradePolicy_var : null
  }
}

// Output
@description('The resource Id of the application.')
output applicationResourceId string = applications.id
