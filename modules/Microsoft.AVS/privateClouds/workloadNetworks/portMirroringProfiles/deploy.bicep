// ============== //
//   Parameters   //
// ============== //

@description('Required. NSX Port Mirroring identifier. Generally the same as the Port Mirroring display name')
param name string

@description('Conditional. The name of the parent privateClouds. Required if the template is used in a standalone deployment.')
param privateCloudName string

@description('Optional. Destination VM Group.')
param destination string = ''

@description('Optional. Direction of port mirroring profile.')
@allowed([
  'INGRESS'
  'EGRESS'
  'BIDIRECTIONAL'
])
param direction string = ''

@description('Optional. Display name of the port mirroring profile.')
param displayName string = ''

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. NSX revision number.')
param revision int = 

@description('Optional. Source VM Group.')
param source string = ''

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

resource portMirroringProfile 'Microsoft.AVS/privateClouds/workloadNetworks/portMirroringProfiles@2022-05-01' = {
  parent: privateCloud::workloadNetwork
  name: name
  properties: {
    destination: destination
    direction: direction
    displayName: displayName
    revision: revision
    source: source
  }
}

// =========== //
//   Outputs   //
// =========== //

@description('The name of the portMirroringProfile.')
output name string = portMirroringProfile.name

@description('The resource ID of the portMirroringProfile.')
output resourceId string = portMirroringProfile.id

@description('The name of the resource group the portMirroringProfile was created in.')
output resourceGroupName string = resourceGroup().name
