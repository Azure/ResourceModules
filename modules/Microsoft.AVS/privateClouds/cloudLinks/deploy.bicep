// ============== //
//   Parameters   //
// ============== //

@description('Required. Name of the cloud link resource')
param name string

@description('Conditional. The name of the parent privateClouds. Required if the template is used in a standalone deployment.')
param privateCloudName string

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. Identifier of the other private cloud participating in the link.')
param linkedCloud string = ''

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

resource cloudLink 'Microsoft.AVS/privateClouds/cloudLinks@2022-05-01' = {
  parent: privateCloud
  name: name
  properties: {
    linkedCloud: linkedCloud
  }
}

// =========== //
//   Outputs   //
// =========== //

@description('The name of the cloudLink.')
output name string = cloudLink.name

@description('The resource ID of the cloudLink.')
output resourceId string = cloudLink.id

@description('The name of the resource group the cloudLink was created in.')
output resourceGroupName string = resourceGroup().name
