// ============== //
//   Parameters   //
// ============== //

@description('Required. Name of the VMware vSphere Distributed Resource Scheduler (DRS) placement policy')
param name string

@description('Conditional. The name of the parent clusters. Required if the template is used in a standalone deployment.')
param clusterName string

@description('Conditional. The name of the parent privateClouds. Required if the template is used in a standalone deployment.')
param privateCloudName string

@description('Optional. VM-Host placement policy affinity strength (should/must)')
@allowed([
  'Should'
  'Must'
])
param affinityStrength string = ''

@description('Optional. Placement policy hosts opt-in Azure Hybrid Benefit type')
@allowed([
  'SqlHost'
  'None'
])
param azureHybridBenefitType string = ''

@description('Optional. Display name of the placement policy')
param displayName string = ''

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. Host members list')
param hostMembers array = []

@description('Optional. Whether the placement policy is enabled or disabled')
@allowed([
  'Enabled'
  'Disabled'
])
param state string = ''

@description('Optional. placement policy type')
@allowed([
  'VmVm'
  'VmHost'
])
param type string = ''

@description('Optional. Virtual machine members list')
param vmMembers array = []

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

    resource cluster 'clusters@2022-05-01' existing = {
      name: clusterName
    }
}

resource placementPolicy 'Microsoft.AVS/privateClouds/clusters/placementPolicies@2022-05-01' = {
  parent: privateCloud::cluster
  name: name
  properties: {
    affinityStrength: affinityStrength
    azureHybridBenefitType: azureHybridBenefitType
    displayName: displayName
    hostMembers: hostMembers
    state: state
    type: type
    vmMembers: vmMembers
  }
}

// =========== //
//   Outputs   //
// =========== //

@description('The name of the placementPolicy.')
output name string = placementPolicy.name

@description('The resource ID of the placementPolicy.')
output resourceId string = placementPolicy.id

@description('The name of the resource group the placementPolicy was created in.')
output resourceGroupName string = resourceGroup().name
