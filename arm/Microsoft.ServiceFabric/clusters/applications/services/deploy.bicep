@description('Required. Name of the Serivce Fabric cluster.')
param serviceFabricClusterName string = ''

@description('Optional. Application name.')
param applicationName string = 'defaultApplication'

@description('Optional. Name of the Service.')
param name string = 'defaultService'

@description('Optional. Properties of the Service.')
param properties object = {}

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

var correlationScheme_var = [for correlationScheme in items(properties.value.correlationScheme): {
  scheme: contains(correlationScheme.key, 'scheme') ? correlationScheme.value.scheme : null
  serviceName: contains(correlationScheme.key, 'serviceName') ? correlationScheme.value.serviceName : null
}]

var serviceLoadMetrics_var = [for serviceLoadMetric in items(properties.value.serviceLoadMetrics): {
  defaultLoad: contains(serviceLoadMetric, 'defaultLoad') ? serviceLoadMetric.value.defaultLoad : 1
  name: contains(serviceLoadMetric.value, 'name') ? serviceLoadMetric.value.name : null
  primaryDefaultLoad: contains(serviceLoadMetric, 'primaryDefaultLoad') ? serviceLoadMetric.value.primaryDefaultLoad : 1
  secondaryDefaultLoad: contains(serviceLoadMetric, 'secondaryDefaultLoad') ? serviceLoadMetric.value.secondaryDefaultLoad : 1
  weight: contains(serviceLoadMetric.value, 'weight') ? serviceLoadMetric.value.weight : null
}]

var properties_var = {
  correlationScheme: contains(properties, 'correlationScheme') ? correlationScheme_var : []
  defaultMoveCost: contains(properties, 'defaultMoveCost') ? properties.defaultMoveCost : null
  partitionDescription: {
    partitionScheme: contains(properties.partitionDescription, 'partitionScheme') ? properties.partitionDescription.partitionScheme : null
    count: contains(properties.partitionDescription, 'count') ? properties.partitionDescription.count : 1
    names: contains(properties.partitionDescription, 'names') ? properties.partitionDescription.names : []
  }
  placementConstraints: contains(properties, 'placementConstraints') ? properties.placementConstraints : null
  serviceDnsName: contains(properties, 'serviceDnsName') ? properties.serviceDnsName : null
  serviceLoadMetrics: contains(properties, 'serviceLoadMetrics') ? serviceLoadMetrics_var : []
  servicePackageActivationMode: contains(properties, 'servicePackageActivationMode') ? properties.servicePackageActivationMode : null
  servicePlacementPolicies: contains(properties, 'servicePlacementPolicies') ? properties.servicePlacementPolicies : []
  serviceTypeName: contains(properties, 'serviceTypeName') ? properties.serviceTypeName : null
  serviceKind: contains(properties, 'serviceKind') ? properties.serviceKind : null
  hasPersistedState: contains(properties, 'hasPersistedState') ? properties.hasPersistedState : true
  minReplicaSetSize: contains(properties, 'minReplicaSetSize') ? properties.minReplicaSetSize : 1
  quorumLossWaitDuration: contains(properties, 'quorumLossWaitDuration') ? properties.quorumLossWaitDuration : null
  replicaRestartWaitDuration: contains(properties, 'replicaRestartWaitDuration') ? properties.replicaRestartWaitDuration : null
  standByReplicaKeepDuration: contains(properties, 'standByReplicaKeepDuration') ? properties.standByReplicaKeepDuration : null
  targetReplicaSetSize: contains(properties, 'targetReplicaSetSize') ? properties.targetReplicaSetSize : 1
}

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
  location: location
  tags: tags
  properties: !empty(properties) ? properties_var : {}
}

@description('The resource name of the service.')
output serviceName string = services.name

@description('The resource group of the service.')
output serviceResourceGroup string = resourceGroup().name

@description('The resource ID of the service.')
output serviceResourceId string = services.id
