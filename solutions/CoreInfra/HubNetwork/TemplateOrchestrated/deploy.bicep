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

@description('Required. Name of Azure Bastion.')
param bastionName string

@description('Required. Name of Azure Firewall.')
param azureFirewallName string

/*
@description('Optional. Resource ID of the storage account to be used for diagnostic logs.')
param diagnosticStorageAccountId string

@description('Optional. Resource ID of the Log Analytics workspace to be used for diagnostic logs.')
param workspaceId string

@description('Optional. Authorization ID of the Event Hub Namespace to be used for diagnostic logs.')
param eventHubAuthorizationRuleId string

@description('Optional. Name of the Event Hub to be used for diagnostic logs.')
param eventHubName string
*/

module resourceGroups '../../../../modules/Microsoft.Resources/resourceGroups/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-rg'
  params: {
    name: resourceGroupName
    location: location
    tags: tags
  }
}

module NSG_bastion_subnet '../../../../modules/Microsoft.Network/networkSecurityGroups/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-bastion-subnet'
  scope: resourceGroup(resourceGroupName)
  params: {
    name: nsgBastionSubnetName
    securityRules: bastion_nsg_rules
    tags: tags
    lock: lock
    /*
    diagnosticWorkspaceId: workspaceId
    diagnosticStorageAccountId: diagnosticStorageAccountId
    diagnosticEventHubAuthorizationRuleId: eventHubAuthorizationRuleId
    diagnosticEventHubName: eventHubName
    */
  }
  dependsOn: [
    resourceGroups
  ]
}
module VirtualNetwork '../../../../modules/Microsoft.Network/virtualNetworks/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-VirtualNetwork_Hub'
  scope: resourceGroup(resourceGroupName)
  params: {
    name: vnet_hub
    addressPrefixes: [
      '192.168.100.0/24'
    ]
    subnets: [
      // {
      //   addressPrefix: '192.168.100.0/26'
      //   name: 'Subnet-Hub'
      //   //  networkSecurityGroupId: ''
      //   //  routeTableId: ''
      // }
      {
        addressPrefix: '192.168.100.64/26'
        name: 'AzureBastionSubnet'
        networkSecurityGroupId: NSG_bastion_subnet.outputs.resourceId
        //  routeTableId: ''
      }
      {
        addressPrefix: '192.168.100.128/26'
        name: 'GatewaySubnet'
      }
      {
        addressPrefix: '192.168.100.192/26'
        name: 'AzureFirewallSubnet'
      }
    ]
    tags: tags
    lock: lock
    /*
    diagnosticWorkspaceId: workspaceId
    diagnosticStorageAccountId: diagnosticStorageAccountId
    diagnosticEventHubAuthorizationRuleId: eventHubAuthorizationRuleId
    diagnosticEventHubName: eventHubName
    */
  }
}
module publicIPAddresses '../../../../modules/Microsoft.Network/publicIPAddresses/deploy.bicep' = {
  scope: resourceGroup(resourceGroupName)
  name: '${uniqueString(deployment().name)}-bastion-pip'
  params: {
    location: location
    name: 'az-pip-bastion-001'
    skuName: 'Standard'
    publicIPAllocationMethod: 'Static'
  }
  dependsOn: [
    resourceGroups
  ]
}

module bastionHosts '../../../../modules/Microsoft.Network/bastionHosts/deploy.bicep' = {
  scope: resourceGroup(resourceGroupName)
  name: '${uniqueString(deployment().name)}-bastionHosts'
  params: {
    location: location
    name: bastionName
    vNetId: VirtualNetwork.outputs.resourceId
    azureBastionSubnetPublicIpId: publicIPAddresses.outputs.resourceId
  }
  dependsOn: [
    VirtualNetwork
    publicIPAddresses
  ]
}

module Azure_Firewall '../../../../modules/Microsoft.Network/azureFirewalls/deploy.bicep' = {

  name: '${uniqueString(deployment().name)}-AzureFirewall'
  scope: resourceGroup(resourceGroupName)
  params: {
    name: azureFirewallName
    location: location
    firewallPolicyId: ''
    vNetId: VirtualNetwork.outputs.resourceId
    tags: tags
    lock: lock
    // diagnosticWorkspaceId: workspaceId
    // diagnosticStorageAccountId: diagnosticStorageAccountId
    // diagnosticEventHubAuthorizationRuleId: eventHubAuthorizationRuleId
    // diagnosticEventHubName: eventHubName
  }
  dependsOn: [
    VirtualNetwork
  ]
}

module Route_Table_Hub '../../../../modules/Microsoft.Network/routeTables/deploy.bicep' = {

  name: '${uniqueString(deployment().name)}-RouteTable-Hub'
  scope: resourceGroup(resourceGroupName)
  params: {
    name: 'subnet-to-AFW-udr-x-001'
    // lock: 'CanNotDelete'

    routes: [
      {
        name: 'default'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopIpAddress: Azure_Firewall.outputs.privateIp
          nextHopType: 'VirtualAppliance'
        }
      }
    ]
  }
  dependsOn: [
    Azure_Firewall
  ]
}

module Hub_Subnet '../../../../modules/Microsoft.Network/virtualNetworks/subnets/deploy.bicep' = {
  name: '${uniqueString(deployment().name)}-Subnet-Hub'
  scope: resourceGroup(resourceGroupName)
  params: {
    name: 'Subnet-Hub'
    addressPrefix: '192.168.100.0/26'
    routeTableId: Route_Table_Hub.outputs.resourceId
    virtualNetworkName: VirtualNetwork.outputs.name
  }
  dependsOn: [
    Route_Table_Hub
  ]
}
