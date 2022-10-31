// ============== //
//   Parameters   //
// ============== //

@description('Required. NSX DHCP identifier. Generally the same as the DHCP display name')
param name string

@description('Conditional. The name of the parent privateClouds. Required if the template is used in a standalone deployment.')
param privateCloudName string

@description('Optional. Type of DHCP: SERVER or RELAY.')
@allowed([
  'SERVER'
  'RELAY'
])
param dhcpType string = ''

@description('Optional. Display name of the DHCP entity.')
param displayName string = ''

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = true

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

resource dhcpConfiguration 'Microsoft.AVS/privateClouds/workloadNetworks/dhcpConfigurations@2022-05-01' = {
  parent: privateCloud::workloadNetwork
  name: name
  properties: {
    dhcpType: dhcpType
    displayName: displayName
    revision: revision
  }
}

// =========== //
//   Outputs   //
// =========== //

@description('The name of the dhcpConfiguration.')
output name string = dhcpConfiguration.name

@description('The resource ID of the dhcpConfiguration.')
output resourceId string = dhcpConfiguration.id

@description('The name of the resource group the dhcpConfiguration was created in.')
output resourceGroupName string = resourceGroup().name
