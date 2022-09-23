targetScope = 'subscription'

@description('Required. Name of the Resource Group.')
param resourceGroupName string

@description('Optional. Tags to be applied on all resources/resource groups in this deployment.')
param tags object

@description('Resource Group location')
param location string

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
@description('Optional. Specify the type of lock for all resources/resource group defined in this template.')
param lock string

@description('Required. Name of the network security group for the Azure Bastion Host subnet.')
param nsgBastionSubnetName string

@description('Required. NSG security rules for the Azure Bastion Host subnet.')
param bastion_nsg_rules array

@description('Required. Name of the virtual network.')
param vnet_hub string

@description('Required. Name of the virtual network.')
param vnetName2 string = 'vnet-spoke'

@description('Optional. Resource ID of the storage account to be used for diagnostic logs.')
param diagnosticStorageAccountId string

@description('Optional. Resource ID of the Log Analytics workspace to be used for diagnostic logs.')
param workspaceId string

@description('Optional. Authorization ID of the Event Hub Namespace to be used for diagnostic logs.')
param eventHubAuthorizationRuleId string

@description('Optional. Name of the Event Hub to be used for diagnostic logs.')
param eventHubName string
module resourceGroups '../../../../modules/Microsoft.Resources/resourceGroups/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-rg'
  params: {
    name: resourceGroupName
    location: location
    tags: tags
  }
}
module VirtualNetworkSpoke '../../../../modules/Microsoft.Network/virtualNetworks/deploy.bicep' = {
  name: 'VirtualNetwork_Spoke'
  scope: resourceGroup(resourceGroupName)
  params: {
    name: vnetName2
    addressPrefixes: [
      '192.168.101.0/24'
    ]
    subnets: [
      {
        addressPrefix: '192.168.101.0/26'
        name: 'DefaultSubnet'
      }
    ]
    tags: tags
    lock: lock
    diagnosticWorkspaceId: workspaceId
    diagnosticStorageAccountId: diagnosticStorageAccountId
    diagnosticEventHubAuthorizationRuleId: eventHubAuthorizationRuleId
    diagnosticEventHubName: eventHubName
  }
  dependsOn: [
    resourceGroups
  ]
}
