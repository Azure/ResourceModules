@description('Required. Name of the Serivce Fabric cluster.')
param serviceFabricClusterName string = ''

@description('Optional. Application name.')
param name string = 'defaultApplication'

@description('Optional. List of Services to be created in the Application.')
param services array = []

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Describes the managed identities for an Azure resource.')
param identity object = {}

@description('Optional. List of user assigned identities for the application, each mapped to a friendly name.')
param managedIdentities array = []

@description('Optional. The maximum number of nodes where Service Fabric will reserve capacity for this application. Note that this does not mean that the services of this application will be placed on all of those nodes. By default, the value of this property is zero and it means that the services can be placed on any node.')
param maximumNodes int = 0

@description('Optional. The minimum number of nodes where Service Fabric will reserve capacity for this application. Note that this does not mean that the services of this application will be placed on all of those nodes. If this property is set to zero, no capacity will be reserved. The value of this property cannot be more than the value of the MaximumNodes property.')
param minimumNodes int = 0

@description('Optional. List of application capacity metric description.')
param metrics array = []

@description('Optional. List of application parameters with overridden values from their default values specified in the application manifest.')
param parameters object = {}

@description('Optional. Remove the current application capacity settings')
param removeApplicationCapacity bool = false

@description('Optional. The application type name as defined in the application manifest.')
param typeName string = ''

@description('Optional. The version of the application type as defined in the application manifest.')
param typeVersion string = ''

@description('Optional. Describes the policy for a monitored application upgrade.')
param upgradePolicy object = {}

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

var identity_var = {
  type: contains(identity, 'type') ? identity.type : 'None'
  userAssignedIdentities: contains(identity, 'userAssignedIdentities') ? identity.userAssignedIdentities : {}
}

var propertiesManagedIdentities_var = [for managedIdentity in managedIdentities: {
  name: contains(managedIdentity, 'name') ? managedIdentity.name : null
  principalId: contains(managedIdentity, 'principalId') ? managedIdentity.principalId : null
}]

var propertiesMetrics_var = [for metric in metrics: {
  maximumCapacity: contains(metric, 'maximumCapacity') ? metric.maximumCapacity : 0
  name: contains(metric, 'name') ? metric.name : null
  reservationCapacity: contains(metric, 'reservationCapacity') ? metric.reservationCapacity : 0
  totalApplicationCapacity: contains(metric, 'totalApplicationCapacity') ? metric.totalApplicationCapacity : 1
}]

var upgradePolicy_var = union({
  forceRestart: contains(upgradePolicy, 'forceRestart') ? upgradePolicy.forceRestart : false
  recreateApplication: contains(upgradePolicy, 'recreateApplication') ? upgradePolicy.recreateApplication : false
  upgradeMode: contains(upgradePolicy, 'upgradeMode') ? upgradePolicy.upgradeMode : 'Invalid'
  upgradeReplicaSetCheckTimeout: contains(upgradePolicy, 'upgradeReplicaSetCheckTimeout') ? upgradePolicy.upgradeReplicaSetCheckTimeout : null
}, contains(upgradePolicy, 'rollingUpgradeMonitoringPolicy') ? {
  rollingUpgradeMonitoringPolicy: {
    failureAction: contains(upgradePolicy.rollingUpgradeMonitoringPolicy, 'failureAction') ? upgradePolicy.rollingUpgradeMonitoringPolicy.failureAction : 'Manual'
    healthCheckRetryTimeout: contains(upgradePolicy.rollingUpgradeMonitoringPolicy, 'healthCheckRetryTimeout') ? upgradePolicy.rollingUpgradeMonitoringPolicy.healthCheckRetryTimeout : null
    healthCheckStableDuration: contains(upgradePolicy.rollingUpgradeMonitoringPolicy, 'healthCheckStableDuration') ? upgradePolicy.rollingUpgradeMonitoringPolicy.healthCheckStableDuration : null
    healthCheckWaitDuration: contains(upgradePolicy.rollingUpgradeMonitoringPolicy, 'healthCheckWaitDuration') ? upgradePolicy.rollingUpgradeMonitoringPolicy.healthCheckWaitDuration : null
    upgradeDomainTimeout: contains(upgradePolicy.rollingUpgradeMonitoringPolicy, 'upgradeDomainTimeout') ? upgradePolicy.rollingUpgradeMonitoringPolicy.upgradeDomainTimeout : null
    upgradeTimeout: contains(upgradePolicy.rollingUpgradeMonitoringPolicy, 'upgradeTimeout') ? upgradePolicy.rollingUpgradeMonitoringPolicy.upgradeTimeout : null
  }
} : {}, contains(upgradePolicy, 'applicationHealthPolicy') ? union({
  applicationHealthPolicy: {
    considerWarningAsError: contains(upgradePolicy.applicationHealthPolicy, 'considerWarningAsError') ? upgradePolicy.applicationHealthPolicy.considerWarningAsError : false
    maxPercentUnhealthyDeployedApplications: contains(upgradePolicy.applicationHealthPolicy, 'maxPercentUnhealthyDeployedApplications') ? upgradePolicy.applicationHealthPolicy.maxPercentUnhealthyDeployedApplications : 0
    serviceTypeHealthPolicyMap: contains(upgradePolicy.applicationHealthPolicy, 'serviceTypeHealthPolicyMap') ? upgradePolicy.applicationHealthPolicy.serviceTypeHealthPolicyMap : {}
  }
}, contains(upgradePolicy.applicationHealthPolicy, 'defaultServiceTypeHealthPolicy') ? {
  defaultServiceTypeHealthPolicy: {
    maxPercentUnhealthyPartitionsPerService: contains(upgradePolicy.applicationHealthPolicy.defaultServiceTypeHealthPolicy, 'maxPercentUnhealthyPartitionsPerService') ? upgradePolicy.applicationHealthPolicy.defaultServiceTypeHealthPolicy.maxPercentUnhealthyPartitionsPerService : 0
    maxPercentUnhealthyReplicasPerPartition: contains(upgradePolicy.applicationHealthPolicy.defaultServiceTypeHealthPolicy, 'maxPercentUnhealthyReplicasPerPartition') ? upgradePolicy.applicationHealthPolicy.defaultServiceTypeHealthPolicy.maxPercentUnhealthyReplicasPerPartition : 0
    maxPercentUnhealthyServices: contains(upgradePolicy.applicationHealthPolicy.defaultServiceTypeHealthPolicy, 'maxPercentUnhealthyServices') ? upgradePolicy.applicationHealthPolicy.defaultServiceTypeHealthPolicy.maxPercentUnhealthyServices : 0
  }
} : {}) : {})

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
  tags: tags
  identity: !empty(identity) ? identity_var : null
  properties: {
    managedIdentities: !empty(managedIdentities) ? propertiesManagedIdentities_var : []
    maximumNodes: maximumNodes
    metrics: !empty(metrics) ? propertiesMetrics_var : []
    minimumNodes: minimumNodes
    parameters: parameters
    removeApplicationCapacity: removeApplicationCapacity
    typeName: !empty(typeName) ? typeName : null
    typeVersion: !empty(typeVersion) ? typeVersion : null
    upgradePolicy: !empty(upgradePolicy) ? upgradePolicy_var : {}
  }
}

module applications_services 'services/deploy.bicep' = [for (service, index) in services: {
  name: '${deployment().name}-SFC-Services-${index}'
  params: {
    serviceFabricClusterName: serviceFabricCluster.name
    applicationName: applications.name
    name: contains(service, 'name') ? service.name : 'defaultService'
    correlationScheme: contains(service, 'correlationScheme') ? service.correlationScheme : []
    defaultMoveCost: contains(service, 'defaultMoveCost') ? service.defaultMoveCost : ''
    hasPersistedState: contains(service, 'hasPersistedState') ? service.hasPersistedState : true
    instanceCloseDelayDuration: contains(service, 'instanceCloseDelayDuration') ? service.instanceCloseDelayDuration : ''
    instanceCount: contains(service, 'instanceCount') ? service.instanceCount : -1
    minReplicaSetSize: contains(service, 'minReplicaSetSize') ? service.minReplicaSetSize : 1
    partitionDescription: contains(service, 'partitionDescription') ? service.partitionDescription : {}
    placementConstraints: contains(service, 'placementConstraints') ? service.placementConstraints : ''
    quorumLossWaitDuration: contains(service, 'quorumLossWaitDuration') ? service.quorumLossWaitDuration : ''
    replicaRestartWaitDuration: contains(service, 'replicaRestartWaitDuration') ? service.replicaRestartWaitDuration : ''
    serviceDnsName: contains(service, 'serviceDnsName') ? service.serviceDnsName : ''
    serviceKind: contains(service, 'serviceKind') ? service.serviceKind : ''
    serviceLoadMetrics: contains(service, 'serviceLoadMetrics') ? service.serviceLoadMetrics : []
    servicePackageActivationMode: contains(service, 'servicePackageActivationMode') ? service.servicePackageActivationMode : ''
    servicePlacementPolicies: contains(service, 'servicePlacementPolicies') ? service.servicePlacementPolicies : []
    serviceTypeName: contains(service, 'serviceTypeName') ? service.serviceTypeName : ''
    standByReplicaKeepDuration: contains(service, 'standByReplicaKeepDuration') ? service.standByReplicaKeepDuration : ''
    tags: contains(service, 'tags') ? service.tags : {}
    targetReplicaSetSize: contains(service, 'targetReplicaSetSize') ? service.targetReplicaSetSize : 1
  }
}]

@description('The resource name of the Application.')
output applicationName string = applications.name

@description('The resource group of the Application.')
output applicationResourceGroup string = resourceGroup().name

@description('The resource ID of the Application.')
output applicationResourceId string = applications.id
