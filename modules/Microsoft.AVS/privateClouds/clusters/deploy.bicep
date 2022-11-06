// ============== //
//   Parameters   //
// ============== //

@description('Required. Name of the cluster in the private cloud')
param name string

@description('Required. The resource model definition representing SKU')
param sku object

@description('Conditional. The name of the parent privateClouds. Required if the template is used in a standalone deployment.')
param privateCloudName string

@description('Optional. The cluster size')
param clusterSize int = 

@description('Optional. The datastores to create as part of the cluster.')
param datastores array = []

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. The hosts')
param hosts array = []

@description('Optional. The placementPolicies to create as part of the cluster.')
param placementPolicies array = []

// ============= //
//   Variables   //
// ============= //

var enableReferencedModulesTelemetry = false

// =============== //
//   Deployments   //
// =============== //

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource privateCloud 'Microsoft.AVS/privateClouds@2022-05-01' existing = {
  name: privateCloudName
}

resource cluster 'Microsoft.AVS/privateClouds/clusters@2022-05-01' = {
  parent: privateCloud
  name: name
  sku: sku
  properties: {
    clusterSize: clusterSize
    hosts: hosts
  }
}

module cluster_datastores 'datastores/deploy.bicep' = [for (datastore, index) in datastores: {
  name: '${uniqueString(deployment().name)}-cluster-datastore-${index}'
  params: {
    privateCloudName: privateCloudName
    clusterName: name
    diskPoolVolume: contains(datastore, 'diskPoolVolume') ? datastore.diskPoolVolume : {}
    name: datastore.name
    netAppVolume: contains(datastore, 'netAppVolume') ? datastore.netAppVolume : {}
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module cluster_placementPolicies 'placementPolicies/deploy.bicep' = [for (placementPolicy, index) in placementPolicies: {
  name: '${uniqueString(deployment().name)}-cluster-placementPolicy-${index}'
  params: {
    privateCloudName: privateCloudName
    clusterName: name
    affinityStrength: contains(placementPolicy, 'affinityStrength') ? placementPolicy.affinityStrength : ''
    azureHybridBenefitType: contains(placementPolicy, 'azureHybridBenefitType') ? placementPolicy.azureHybridBenefitType : ''
    displayName: contains(placementPolicy, 'displayName') ? placementPolicy.displayName : ''
    hostMembers: contains(placementPolicy, 'hostMembers') ? placementPolicy.hostMembers : []
    name: placementPolicy.name
    state: contains(placementPolicy, 'state') ? placementPolicy.state : ''
    type: contains(placementPolicy, 'type') ? placementPolicy.type : ''
    vmMembers: contains(placementPolicy, 'vmMembers') ? placementPolicy.vmMembers : []
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

// =========== //
//   Outputs   //
// =========== //

@description('The name of the cluster.')
output name string = cluster.name

@description('The resource ID of the cluster.')
output resourceId string = cluster.id

@description('The name of the resource group the cluster was created in.')
output resourceGroupName string = resourceGroup().name
