// ============== //
//   Parameters   //
// ============== //

@description('Required. NSX Public IP Block identifier. Generally the same as the Public IP Block\'s display name')
param name string

@description('Conditional. The name of the parent privateClouds. Required if the template is used in a standalone deployment.')
param privateCloudName string

@description('Optional. Display name of the Public IP Block.')
param displayName string = ''

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. Number of Public IPs requested.')
param numberOfPublicIPs int = 

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

resource publicIP 'Microsoft.AVS/privateClouds/workloadNetworks/publicIPs@2022-05-01' = {
  parent: privateCloud::workloadNetwork
  name: name
  properties: {
    displayName: displayName
    numberOfPublicIPs: numberOfPublicIPs
  }
}

// =========== //
//   Outputs   //
// =========== //

@description('The name of the publicIP.')
output name string = publicIP.name

@description('The resource ID of the publicIP.')
output resourceId string = publicIP.id

@description('The name of the resource group the publicIP was created in.')
output resourceGroupName string = resourceGroup().name
