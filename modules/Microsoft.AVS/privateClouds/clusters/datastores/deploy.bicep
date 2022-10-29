// ============== //
//   Parameters   //
// ============== //

@description('Conditional. The name of the parent key vault. Required if the template is used in a standalone deployment.')
param privateCloudName string

@description('Conditional. The name of the parent key vault. Required if the template is used in a standalone deployment.')
param clusterName string

@description('Required. Name of the datastore in the private cloud cluster')
param name string

@description('Optional. An Azure NetApp Files volume from Microsoft.NetApp provider')
param netAppVolume object = {}

@description('Optional. An iSCSI volume from Microsoft.StoragePool provider')
param diskPoolVolume object = {}

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

    resource cluster 'clusters@2022-05-01' existing = {
        name: clusterName
    }
}

resource datastore 'Microsoft.AVS/privateClouds/clusters/datastores@2022-05-01' = {
  parent: privateCloud::cluster
  name: name
  properties: {
    netAppVolume: netAppVolume
    diskPoolVolume: diskPoolVolume
  }
}

// =========== //
//   Outputs   //
// =========== //

@description('The name of the datastore.')
output name string = datastore.name

@description('The resource ID of the datastore.')
output resourceId string = datastore.id

@description('The name of the resource group the datastore was created in.')
output resourceGroupName string = resourceGroup().name
