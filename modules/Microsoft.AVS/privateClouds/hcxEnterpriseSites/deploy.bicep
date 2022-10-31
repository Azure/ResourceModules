// ============== //
//   Parameters   //
// ============== //

@description('Required. Name of the HCX Enterprise Site in the private cloud')
param name string

@description('Conditional. The name of the parent privateClouds. Required if the template is used in a standalone deployment.')
param privateCloudName string

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

resource hcxEnterpriseSite 'Microsoft.AVS/privateClouds/hcxEnterpriseSites@2022-05-01' = {
  parent: privateCloud
  name: name
  properties: {
  }
}

// =========== //
//   Outputs   //
// =========== //

@description('The name of the hcxEnterpriseSite.')
output name string = hcxEnterpriseSite.name

@description('The resource ID of the hcxEnterpriseSite.')
output resourceId string = hcxEnterpriseSite.id

@description('The name of the resource group the hcxEnterpriseSite was created in.')
output resourceGroupName string = resourceGroup().name
