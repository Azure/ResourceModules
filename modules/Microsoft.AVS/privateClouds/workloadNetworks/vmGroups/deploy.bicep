// ============== //
//   Parameters   //
// ============== //

@description('Required. NSX VM Group identifier. Generally the same as the VM Group\'s display name')
param name string

@description('Conditional. The name of the parent privateClouds. Required if the template is used in a standalone deployment.')
param privateCloudName string

@description('Optional. Display name of the VM group.')
param displayName string = ''

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. Virtual machine members of this group.')
param members array = []

@description('Optional. NSX revision number.')
param revision int = 

@description('Optional. The name of the parent workloadNetworks. Required if the template is used in a standalone deployment.')
param workloadNetworkName string = 'default'

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

    resource workloadNetwork 'workloadNetworks@2022-05-01' existing = {
      name: workloadNetworkName
    }
}

resource vmGroup 'Microsoft.AVS/privateClouds/workloadNetworks/vmGroups@2022-05-01' = {
  parent: privateCloud::workloadNetwork
  name: name
  properties: {
    displayName: displayName
    members: members
    revision: revision
  }
}

// =========== //
//   Outputs   //
// =========== //

@description('The name of the vmGroup.')
output name string = vmGroup.name

@description('The resource ID of the vmGroup.')
output resourceId string = vmGroup.id

@description('The name of the resource group the vmGroup was created in.')
output resourceGroupName string = resourceGroup().name
