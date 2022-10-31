// ============== //
//   Parameters   //
// ============== //

@description('Required. Name of the addon for the private cloud')
param name string

@description('Conditional. The name of the parent privateClouds. Required if the template is used in a standalone deployment.')
param privateCloudName string

@description('Optional. The type of private cloud addon')
@allowed([
  'SRM'
  'VR'
  'HCX'
  'Arc'
])
param addonType string = ''

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
}

resource addon 'Microsoft.AVS/privateClouds/addons@2022-05-01' = {
  parent: privateCloud
  name: name
  properties: {
    addonType: addonType
  }
}

// =========== //
//   Outputs   //
// =========== //

@description('The name of the addon.')
output name string = addon.name

@description('The resource ID of the addon.')
output resourceId string = addon.id

@description('The name of the resource group the addon was created in.')
output resourceGroupName string = resourceGroup().name
