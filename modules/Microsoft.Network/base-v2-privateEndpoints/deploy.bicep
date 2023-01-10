@description('Required. Name of the private endpoint resource to create.')
param name string

@description('Required. Resource ID of the subnet where the endpoint needs to be created.')
param subnetResourceId string

@description('Required. Resource ID of the resource that needs to be connected to the network.')
param serviceResourceId string

type applicationSecurityGroup = {
  id: string
}

@description('Optional. Application security groups in which the private endpoint IP configuration is included.')
param applicationSecurityGroups applicationSecurityGroup[] = []

@description('Optional. The custom name of the network interface attached to the private endpoint.')
param customNetworkInterfaceName string = ''

type ipConfigurationProperties = {
  groupId: string
  memberName: string
  privateIPAddress: string
}

type ipConfiguration = {
  name: string
  properties: ipConfigurationProperties
}

@description('Optional. A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints.')
param ipConfigurations ipConfiguration[] = []

@description('Required. Subtype(s) of the connection to be created. The allowed values depend on the type serviceResourceId refers to.')
param groupIds array

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Tags to be applied on all resources/resource groups in this deployment.')
param tags object = {}

@description('Optional. Custom DNS configurations.')
param customDnsConfigs array = []

@description('Optional. Manual PrivateLink Service Connections.')
param manualPrivateLinkServiceConnections array = []

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

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

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2022-05-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    applicationSecurityGroups: applicationSecurityGroups
    customNetworkInterfaceName: customNetworkInterfaceName
    ipConfigurations: ipConfigurations
    privateLinkServiceConnections: [
      {
        name: name
        properties: {
          privateLinkServiceId: serviceResourceId
          groupIds: groupIds
        }
      }
    ]
    manualPrivateLinkServiceConnections: manualPrivateLinkServiceConnections
    subnet: {
      id: subnetResourceId
    }
    customDnsConfigs: customDnsConfigs
  }
}

@description('The resource group the private endpoint was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the private endpoint.')
output resourceId string = privateEndpoint.id

@description('The name of the private endpoint.')
output name string = privateEndpoint.name

@description('The location the resource was deployed into.')
output location string = privateEndpoint.location
