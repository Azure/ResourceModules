// ============== //
//   Parameters   //
// ============== //

@description('Required. The name of the data collection endpoint. The name is case insensitive.')
param name string

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. The kind of the resource.')
@allowed([
  'Linux'
  'Windows'
])
param kind string = 'Linux'

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Specify the type of lock.')
@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
param lock string = ''

@description('Optional. Resource tags.')
param tags object = {}

// =============== //
//   Deployments   //
// =============== //

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name, location)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource dataCollectionEndpoint 'Microsoft.Insights/dataCollectionEndpoints@2021-04-01' = {
  kind: kind
  location: location
  name: name
  tags: tags
}

resource dataCollectionEndpoint_lock 'Microsoft.Authorization/locks@2017-04-01' = if (!empty(lock)) {
  name: '${dataCollectionEndpoint.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: dataCollectionEndpoint
}

// =========== //
//   Outputs   //
// =========== //

@description('The name of the dataCollectionEndpoint.')
output name string = dataCollectionEndpoint.name

@description('The resource ID of the dataCollectionEndpoint.')
output resourceId string = dataCollectionEndpoint.id

@description('The name of the resource group the dataCollectionEndpoint was created in.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = dataCollectionEndpoint.location
