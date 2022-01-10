@description('Required. Name of the Serivce Fabric cluster.')
param serviceFabricClusterName string = ''

@description('Optional. Application name.')
param applicationName string = 'defaultApplication'

@description('Optional. Name of the Service.')
param name string = 'defaultService'

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. A list that describes the correlation of the service with other services.')
param correlationScheme array = []

@description('Optional. Specifies the move cost for the service.')
@allowed([
  'High'
  'Low'
  'Medium'
  'Zero'
  ''
])
param defaultMoveCost string = ''

@description('Optional. Describes how the service is partitioned.')
param partitionDescription object = {}

@description('Optional. The placement constraints as a string. Placement constraints are boolean expressions on node properties and allow for restricting a service to particular nodes based on the service requirements. For example, to place a service on nodes where NodeType is blue specify the following: "NodeColor == blue)".')
param placementConstraints string = ''

@description('Optional. Dns name used for the service. If this is specified, then the service can be accessed via its DNS name instead of service name.')
param serviceDnsName string = ''

@description('Optional. The service load metrics is given as an array of ServiceLoadMetricDescription objects.')
param serviceLoadMetrics array = []

@description('Optional. The activation Mode of the service package')
@allowed([
  'ExclusiveProcess'
  'SharedProcess'
  ''
])
param servicePackageActivationMode string = ''

@description('Optional. A list that describes the correlation of the service with other services.')
param servicePlacementPolicies array = []

@description('Optional. The name of the service type')
param serviceTypeName string = ''

@description('Optional. Set the object type')
@allowed([
  'Stateful'
  'Stateless'
  ''
])
param serviceKind string = ''

@description('Optional. A flag indicating whether this is a persistent service which stores states on the local disk. If it is then the value of this property is true, if not it is false.')
param hasPersistedState bool = true

@description('Optional. The minimum replica set size as a number.')
param minReplicaSetSize int = 1

@description('Optional. The maximum duration for which a partition is allowed to be in a state of quorum loss, represented in ISO 8601 format (hh:mm:ss.s).')
param quorumLossWaitDuration string = ''

@description('Optional. The duration between when a replica goes down and when a new replica is created, represented in ISO 8601 format (hh:mm:ss.s).')
param replicaRestartWaitDuration string = ''

@description('Optional. The definition on how long StandBy replicas should be maintained before being removed, represented in ISO 8601 format (hh:mm:ss.s).')
param standByReplicaKeepDuration string = ''

@description('Optional. The target replica set size as a number.')
param targetReplicaSetSize int = 1

@description('Optional. Delay duration for RequestDrain feature to ensures that the endpoint advertised by the stateless instance is removed before the delay starts prior to closing the instance. This delay enables existing requests to drain gracefully before the instance actually goes down (/azure/service-fabric/service-fabric-application-upgrade-advanced#avoid-connection-drops-during-stateless-service-planned-downtime-preview). It is first interpreted as a string representing an ISO 8601 duration. If that fails, then it is interpreted as a number representing the total number of milliseconds.')
param instanceCloseDelayDuration string = ''

@description('Optional. The instance count.')
param instanceCount int = -1

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

var serviceLoadMetrics_var = [for serviceLoadMetric in serviceLoadMetrics: {
  defaultLoad: contains(serviceLoadMetric, 'defaultLoad') ? serviceLoadMetric.value.defaultLoad : 1
  name: contains(serviceLoadMetric.value, 'name') ? serviceLoadMetric.value.name : null
  primaryDefaultLoad: contains(serviceLoadMetric, 'primaryDefaultLoad') ? serviceLoadMetric.value.primaryDefaultLoad : 1
  secondaryDefaultLoad: contains(serviceLoadMetric, 'secondaryDefaultLoad') ? serviceLoadMetric.value.secondaryDefaultLoad : 1
  weight: contains(serviceLoadMetric.value, 'weight') ? serviceLoadMetric.value.weight : null
}]

var properties = union({
  correlationScheme: correlationScheme
  defaultMoveCost: !empty(defaultMoveCost) ? defaultMoveCost : null
  placementConstraints: !empty(placementConstraints) ? placementConstraints : null
  serviceDnsName: !empty(serviceDnsName) ? serviceDnsName : null
  // serviceLoadMetrics: contains(properties, 'serviceLoadMetrics') ? serviceLoadMetrics_var : []
  servicePackageActivationMode: !empty(servicePackageActivationMode) ? servicePackageActivationMode : null
  servicePlacementPolicies: !empty(servicePlacementPolicies) ? servicePlacementPolicies : []
  serviceTypeName: !empty(serviceTypeName) ? serviceTypeName : null
  serviceKind: !empty(serviceKind) ? serviceKind : null
}, (!empty(partitionDescription) ? {
  partitionDescription: {
    partitionScheme: contains(partitionDescription, 'partitionScheme') ? partitionDescription.partitionScheme : null
    count: contains(partitionDescription, 'count') ? partitionDescription.count : 1
    names: contains(partitionDescription, 'names') ? partitionDescription.names : []
  }
} : {}), (!empty(serviceLoadMetrics) ? {
  serviceLoadMetrics: serviceLoadMetrics_var
} : {}), (serviceKind == 'Stateful' ? {
  'serviceKind': serviceKind
  hasPersistedState: hasPersistedState
  minReplicaSetSize: minReplicaSetSize
  quorumLossWaitDuration: quorumLossWaitDuration
  replicaRestartWaitDuration: replicaRestartWaitDuration
  standByReplicaKeepDuration: standByReplicaKeepDuration
  targetReplicaSetSize: targetReplicaSetSize
} : {}), (serviceKind == 'Stateless' ? {
  'serviceKind': serviceKind
  instanceCloseDelayDuration: instanceCloseDelayDuration
  instanceCount: instanceCount
} : {}))

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource serviceFabricCluster 'Microsoft.ServiceFabric/clusters@2021-06-01' existing = {
  name: serviceFabricClusterName

  resource applications 'applications@2021-06-01' existing = {
    name: applicationName
  }
}

resource services 'Microsoft.ServiceFabric/clusters/applications/services@2021-06-01' = {
  name: name
  parent: serviceFabricCluster::applications
  tags: tags
  properties: properties
}

@description('The resource name of the service.')
output serviceName string = services.name

@description('The resource group of the service.')
output serviceResourceGroup string = resourceGroup().name

@description('The resource ID of the service.')
output serviceResourceId string = services.id
