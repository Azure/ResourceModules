// ============== //
//   Parameters   //
// ============== //

@description('Conditional. The name of the parent key vault. Required if the template is used in a standalone deployment.')
param privateCloudName string

@description('Conditional. The name of the parent key vault. Required if the template is used in a standalone deployment.')
param workloadNetworkName string

@description('Required. NSX Segment identifier. Generally the same as the Segment\'s display name')
param name string

@description('Optional. Subnet configuration for segment')
param subnet object = {}

@description('Optional. Display name of the segment.')
param displayName string = ''

@description('Optional. Gateway which to connect segment to.')
param connectedGateway string = ''

@description('Optional. NSX revision number.')
param revision int = 

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = true


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

resource segment 'Microsoft.AVS/privateClouds/workloadNetworks/segments@2022-05-01' = {
  parent: privateCloud::workloadNetwork
  name: name
  properties: {
    subnet: subnet
    displayName: displayName
    connectedGateway: connectedGateway
    revision: revision
  }
}

// =========== //
//   Outputs   //
// =========== //

@description('The name of the segment.')
output name string = segment.name

@description('The resource ID of the segment.')
output resourceId string = segment.id

@description('The name of the resource group the segment was created in.')
output resourceGroupName string = resourceGroup().name
