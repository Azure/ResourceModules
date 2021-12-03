@description('Required. Name of the Serivce Fabric cluster.')
param serviceFabricClusterName string = ''

@description('Optional. Application name.')
param name string = 'defaultApplication'

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. List of Services to be created in the Application.')
param services array = []

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

var propertiesManagedIdentities_var = [for managedIdentity in properties.managedIdentities: {
  name: contains(managedIdentity, 'name') ? managedIdentity.name : null
  principalId: contains(managedIdentity, 'principalId') ? managedIdentity.principalId : null
}]

var propertiesMetrics_var = [for metric in properties.metrics: {
  maximumCapacity: contains(metric, 'maximumCapacity') ? metric.maximumCapacity : 0
  name: !empty(metric.name) ? metric.name : null
  reservationCapacity: contains(metric, 'reservationCapacity') ? metric.reservationCapacity : 0
  totalApplicationCapacity: contains(metric, 'totalApplicationCapacity') ? metric.totalApplicationCapacity : 1
}]

var upgradePolicy_var = {
  applicationHealthPolicy: {
    considerWarningAsError: contains(properties.upgradePolicy.applicationHealthPolicy, 'considerWarningAsError') ? properties.upgradePolicy.applicationHealthPolicy.considerWarningAsError : false
    defaultServiceTypeHealthPolicy: {
      maxPercentUnhealthyPartitionsPerService: contains(properties.upgradePolicy.applicationHealthPolicy.defaultServiceTypeHealthPolicy, 'maxPercentUnhealthyPartitionsPerService') ? properties.upgradePolicy.applicationHealthPolicy.defaultServiceTypeHealthPolicy.maxPercentUnhealthyPartitionsPerService : 0
      maxPercentUnhealthyReplicasPerPartition: contains(properties.upgradePolicy.applicationHealthPolicy.defaultServiceTypeHealthPolicy, 'maxPercentUnhealthyReplicasPerPartition') ? properties.upgradePolicy.applicationHealthPolicy.defaultServiceTypeHealthPolicy.maxPercentUnhealthyReplicasPerPartition : 0
      maxPercentUnhealthyServices: contains(properties.upgradePolicy.applicationHealthPolicy.defaultServiceTypeHealthPolicy, 'maxPercentUnhealthyServices') ? properties.upgradePolicy.applicationHealthPolicy.defaultServiceTypeHealthPolicy.maxPercentUnhealthyServices : 0
    }
    maxPercentUnhealthyDeployedApplications: contains(properties.upgradePolicy.applicationHealthPolicy, 'maxPercentUnhealthyDeployedApplications') ? properties.upgradePolicy.applicationHealthPolicy.maxPercentUnhealthyDeployedApplications : 0
    serviceTypeHealthPolicyMap: !empty(properties.upgradePolicy.applicationHealthPolicy.serviceTypeHealthPolicyMap) ? properties.upgradePolicy.applicationHealthPolicy.serviceTypeHealthPolicyMap : null
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
  name: name
  parent: serviceFabricCluster
  location: location
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

module applications_services 'services/deploy.bicep' = [for (service, index) in services: {
  name: '${deployment().name}-SFC-Services-${index}'
  params: {
    serviceFabricClusterName: serviceFabricCluster.name
    applicationName: applications.name
    name: contains(service, 'name') ? service.name : 'defaultService'
    properties: contains(service, 'properties') ? service.properties : {}
  }
}]

@description('The resource name of the Application.')
output applicationName string = applications.name

@description('The resource group of the Application.')
output applicationResourceGroup string = resourceGroup().name

@description('The resource ID of the Application.')
output applicationResourceId string = applications.id
