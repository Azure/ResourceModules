targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. Name of the Resource Group.')
param resourceGroupName string = ''

@description('Optional. Name of deployment.')
param deploymentPrefix string = ''

@description('Optional. Tags to be applied on all resources/resource groups in this deployment.')
param tags object = {}

@description('Optional. Resource Group location')
param location string = 'eastus2'

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
@description('Optional. Specify the type of lock for all resources/resource group defined in this template.')
param lock string = ''

@description('Optional. Name of the virtual network.')
param vnetName string = ''

@description('Required. Virtual network address prefix.')
param vnetAddressPrefix string = ''

@description('Required. Virtual network bastion subnet address space.')
param vnetBastionSubnetAddressPrefix string

@description('Required. Virtual network web tier subnet address space.')
param vnetWebSubnetAddressPrefix string

@description('Required. Virtual network application tier subnet address space.')
param vnetAppSubnetAddressPrefix string

@description('Required. Virtual network database tier subnet address space.')
param vnetDbSubnetAddressPrefix string

@description('Optional. Name of the subnet for the web tier.')
param webTierSubnetName string = ''

@description('Optional. Name of the subnet for the application tier.')
param appTierSubnetName string = ''

@description('Optional. Name of the subnet for the database tier.')
param dbTierSubnetName string = ''

@description('Optional. Name of the network security group for the Azure Bastion Host subnet.')
param nsgBastionSubnetName string = ''

@description('Optional. Name of the network security group for the Azure Bastion Host subnet.')
param nsgWebTierSubnetName string = ''

@description('Optional. Name of the network security group for the Azure Bastion Host subnet.')
param nsgAppTierSubnetName string = ''

@description('Optional. Name of the network security group for the Azure Bastion Host subnet.')
param nsgDbTierSubnetName string = ''

@description('Optional. Name of the route table for the Azure Bastion Host subnet.')
param udrWebTierSubnetName string = ''

@description('Optional. Name of the route table for the Azure Bastion Host subnet.')
param udrAppTierSubnetName string = ''

@description('Optional. Name of the route table for the Azure Bastion Host subnet.')
param udrDbTierSubnetName string = ''

@description('Optional. Name of the application security group for the Azure Bastion Host subnet.')
param asgWebTierSubnetName string = ''

@description('Optional. Name of the application security group for the Azure Bastion Host subnet.')
param asgAppTierSubnetName string = ''

@description('Optional. Name of the application security group for the Azure Bastion Host subnet.')
param asgDbTierSubnetName string = ''

@description('Optional. Resource ID of the storage account to be used for diagnostic logs.')
param diagnosticStorageAccountId string = ''

@description('Optional. Resource ID of the Log Analytics workspace to be used for diagnostic logs.')
param workspaceId string = ''

@description('Optional. Authorization ID of the Event Hub Namespace to be used for diagnostic logs.')
param eventHubAuthorizationRuleId string = ''

@description('Optional. Name of the Event Hub to be used for diagnostic logs.')
param eventHubName string = ''

@description('Do not modify, used to set unique value for resource deployment.')
param time string = utcNow()

// ========== //
// variables  //
// ========== //
var varLocationLowercase = toLower(location)
var varDeploymentPrefixLowerCase = toLower(varDeploymentPrefix)
var varBastionSubnetName = 'AzureBastionSubnet'
var varDeploymentPrefix = !empty(deploymentPrefix) ? deploymentPrefix : '3tier'
var varResourceGroupName = !empty(resourceGroupName) ? resourceGroupName : 'rg-${varDeploymentPrefixLowerCase}-${varLocationLowercase}-network'
var varVnetName = !empty(vnetName) ? vnetName : 'vnet-${varDeploymentPrefixLowerCase}-${varLocationLowercase}-001'
var varWebTierSubnetName = !empty(webTierSubnetName) ? webTierSubnetName : 'snet-${varDeploymentPrefixLowerCase}-web-${varLocationLowercase}-001'
var varAppTierSubnetName = !empty(appTierSubnetName) ? appTierSubnetName : 'snet-${varDeploymentPrefixLowerCase}-app-${varLocationLowercase}-001'
var varDbTierSubnetName = !empty(dbTierSubnetName) ? dbTierSubnetName : 'snet-${varDeploymentPrefixLowerCase}-db-${varLocationLowercase}-001'
var varNsgBastionSubnetName = !empty(nsgBastionSubnetName) ? nsgBastionSubnetName : 'nsg-${varDeploymentPrefixLowerCase}-bastion-${varLocationLowercase}-001'
var varNsgWebTierSubnetName = !empty(nsgWebTierSubnetName) ? nsgWebTierSubnetName : 'nsg-${varDeploymentPrefixLowerCase}-web-${varLocationLowercase}-001'
var varNsgAppTierSubnetName = !empty(nsgAppTierSubnetName) ? nsgAppTierSubnetName : 'nsg-${varDeploymentPrefixLowerCase}-app-${varLocationLowercase}-001'
var varNsgDbTierSubnetName = !empty(nsgDbTierSubnetName) ? nsgDbTierSubnetName : 'nsg-${varDeploymentPrefixLowerCase}-db-${varLocationLowercase}-001'
var varUdrWebTierSubnetName = !empty(udrWebTierSubnetName) ? udrWebTierSubnetName : 'route-${varDeploymentPrefixLowerCase}-web-${varLocationLowercase}-001'
var varUdrAppTierSubnetName = !empty(udrAppTierSubnetName) ? udrAppTierSubnetName : 'route-${varDeploymentPrefixLowerCase}-app-${varLocationLowercase}-001'
var varUdrDbTierSubnetName = !empty(udrDbTierSubnetName) ? udrDbTierSubnetName : 'route-${varDeploymentPrefixLowerCase}-db-${varLocationLowercase}-001'
var varAsgWebTierSubnetName = !empty(asgWebTierSubnetName) ? asgWebTierSubnetName : 'asg-${varDeploymentPrefixLowerCase}-web-${varLocationLowercase}-001'
var varAsgAppTierSubnetName = !empty(asgAppTierSubnetName) ? asgAppTierSubnetName : 'asg-${varDeploymentPrefixLowerCase}-app-${varLocationLowercase}-001'
var varAsgDbTierSubnetName = !empty(asgDbTierSubnetName) ? asgDbTierSubnetName : 'asg-${varDeploymentPrefixLowerCase}-db-${varLocationLowercase}-001'

// ========== //
// Deployments//
// ========== //

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: varResourceGroupName
  location: varLocationLowercase
  tags: !empty(tags) ? tags : {}
}

module nsgBastionSubnet '../../../../../modules/Microsoft.Network/networkSecurityGroups/deploy.bicep' = {
  scope: resourceGroup
  name: 'Deploy-Bastion-NSG-${time}'
  params: {
    name: varNsgBastionSubnetName
    securityRules: [
      {
        name: 'AllowhttpsInbound'
        properties: {
          description: 'Allow inbound TCP 443 connections from the Internet'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: 'Internet'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 120
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowGatewayManagerInbound'
        properties: {
          description: 'Allow inbound TCP 443 connections from the Gateway Manager'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: 'GatewayManager'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 130
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowAzureLoadBalancerInbound'
        properties: {
          description: 'Allow inbound TCP 443 connections from the Azure Load Balancer'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: 'AzureLoadBalancer'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 140
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowBastionHostCommunication'
        properties: {
          description: 'Allow inbound 8080 and 5701 connections from the Virtual Network'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRanges: [
            '8080'
            '5701'
          ]
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 150
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowSshRdpOutbound'
        properties: {
          description: 'Allow outbound SSH and RDP connections to Virtual Network'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRanges: [
            '22'
            '3389'
          ]
          sourceAddressPrefix: '*'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 100
          direction: 'Outbound'
        }
      }
      {
        name: 'AllowAzureCloudOutbound'
        properties: {
          description: 'Allow outbound 443 connections to Azure cloud'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: 'AzureCloud'
          access: 'Allow'
          priority: 110
          direction: 'Outbound'
        }
      }
      {
        name: 'AllowBastionCommunication'
        properties: {
          description: 'Allow outbound 8080 and 5701 connections to Virtual Network'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRanges: [
            '8080'
            '5701'
          ]
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 120
          direction: 'Outbound'
        }
      }
      {
        name: 'AllowGetSessionInformation'
        properties: {
          description: 'Allow outbound 80 connections to Internet'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '80'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: 'Internet'
          access: 'Allow'
          priority: 130
          direction: 'Outbound'
        }
      }
    ]
    tags: !empty(tags) ? tags : {}
    lock: !empty(lock) ? lock : ''
    diagnosticWorkspaceId: !empty(workspaceId) ? workspaceId : ''
    diagnosticStorageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : ''
    diagnosticEventHubAuthorizationRuleId: !empty(eventHubAuthorizationRuleId) ? eventHubAuthorizationRuleId : ''
    diagnosticEventHubName: !empty(eventHubName) ? eventHubName : ''
  }
  dependsOn: []
}

module nsgWebSubnet '../../../../../modules/Microsoft.Network/networkSecurityGroups/deploy.bicep' = {
  scope: resourceGroup
  name: 'Deploy-Web-NSG-${time}'
  params: {
    name: varNsgWebTierSubnetName
    securityRules: []
    tags: !empty(tags) ? tags : {}
    lock: !empty(lock) ? lock : ''
    diagnosticWorkspaceId: !empty(workspaceId) ? workspaceId : ''
    diagnosticStorageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : ''
    diagnosticEventHubAuthorizationRuleId: !empty(eventHubAuthorizationRuleId) ? eventHubAuthorizationRuleId : ''
    diagnosticEventHubName: !empty(eventHubName) ? eventHubName : ''
  }
}

module nsgAppSubnet '../../../../../modules/Microsoft.Network/networkSecurityGroups/deploy.bicep' = {
  scope: resourceGroup
  name: 'Deploy-App-NSG-${time}'
  params: {
    name: varNsgAppTierSubnetName
    securityRules: []
    tags: !empty(tags) ? tags : {}
    lock: !empty(lock) ? lock : ''
    diagnosticWorkspaceId: !empty(workspaceId) ? workspaceId : ''
    diagnosticStorageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : ''
    diagnosticEventHubAuthorizationRuleId: !empty(eventHubAuthorizationRuleId) ? eventHubAuthorizationRuleId : ''
    diagnosticEventHubName: !empty(eventHubName) ? eventHubName : ''
  }
}

module nsgDbSubnet '../../../../../modules/Microsoft.Network/networkSecurityGroups/deploy.bicep' = {
  scope: resourceGroup
  name: 'Deploy-Db-NSG-${time}'
  params: {
    name: varNsgDbTierSubnetName
    securityRules: []
    tags: !empty(tags) ? tags : {}
    lock: !empty(lock) ? lock : ''
    diagnosticWorkspaceId: !empty(workspaceId) ? workspaceId : ''
    diagnosticStorageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : ''
    diagnosticEventHubAuthorizationRuleId: !empty(eventHubAuthorizationRuleId) ? eventHubAuthorizationRuleId : ''
    diagnosticEventHubName: !empty(eventHubName) ? eventHubName : ''
  }
}

module udrWebSubnet '../../../../../modules/Microsoft.Network/routeTables/deploy.bicep' = {
  scope: resourceGroup
  name: 'Deploy-Web-UDR-${time}'
  params: {
    name: varUdrWebTierSubnetName
    tags: !empty(tags) ? tags : {}
    lock: !empty(lock) ? lock : ''
  }
}

module udrAppSubnet '../../../../../modules/Microsoft.Network/routeTables/deploy.bicep' = {
  scope: resourceGroup
  name: 'Deploy-App-UDR-${time}'
  params: {
    name: varUdrAppTierSubnetName
    tags: !empty(tags) ? tags : {}
    lock: !empty(lock) ? lock : ''
  }
}

module udrDbSubnet '../../../../../modules/Microsoft.Network/routeTables/deploy.bicep' = {
  scope: resourceGroup
  name: 'Deploy-DB-UDR-${time}'
  params: {
    name: varUdrDbTierSubnetName
    tags: !empty(tags) ? tags : {}
    lock: !empty(lock) ? lock : ''
  }
}

module asgWebSubnet '../../../../../modules/Microsoft.Network/applicationSecurityGroups/deploy.bicep' = {
  scope: resourceGroup
  name: 'Deploy-Web-ASG-${time}'
  params: {
    name: varAsgWebTierSubnetName
    tags: !empty(tags) ? tags : {}
    lock: !empty(lock) ? lock : ''
  }
}

module asgAppSubnet '../../../../../modules/Microsoft.Network/applicationSecurityGroups/deploy.bicep' = {
  scope: resourceGroup
  name: 'Deploy-App-ASG-${time}'
  params: {
    name: varAsgAppTierSubnetName
    tags: !empty(tags) ? tags : {}
    lock: !empty(lock) ? lock : ''
  }
}

module asgDbSubnet '../../../../../modules/Microsoft.Network/applicationSecurityGroups/deploy.bicep' = {
  scope: resourceGroup
  name: 'Deploy-DB-ASG-${time}'
  params: {
    name: varAsgDbTierSubnetName
    tags: !empty(tags) ? tags : {}
    lock: !empty(lock) ? lock : ''
  }
}

module virtualNetwork '../../../../../modules/Microsoft.Network/virtualNetworks/deploy.bicep' = {
  scope: resourceGroup
  name: 'Deploy-vNet-${time}'
  params: {
    name: varVnetName
    addressPrefixes: [
      vnetAddressPrefix
    ]
    subnets: [
      {
        addressPrefix: vnetBastionSubnetAddressPrefix
        name: varBastionSubnetName
        networkSecurityGroupId: nsgBastionSubnet.outputs.resourceId
        //  routeTableId: ''
      }
      {
        addressPrefix: vnetWebSubnetAddressPrefix
        name: varWebTierSubnetName
        networkSecurityGroupId: nsgWebSubnet.outputs.resourceId
        routeTableId: udrWebSubnet.outputs.resourceId
      }
      {
        addressPrefix: vnetAppSubnetAddressPrefix
        name: varAppTierSubnetName
        networkSecurityGroupId: nsgAppSubnet.outputs.resourceId
        routeTableId: udrAppSubnet.outputs.resourceId
      }
      {
        addressPrefix: vnetDbSubnetAddressPrefix
        name: varDbTierSubnetName
        networkSecurityGroupId: nsgDbSubnet.outputs.resourceId
        routeTableId: udrDbSubnet.outputs.resourceId
      }
    ]
    tags: !empty(tags) ? tags : {}
    lock: !empty(lock) ? lock : ''
    diagnosticWorkspaceId: !empty(workspaceId) ? workspaceId : ''
    diagnosticStorageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : ''
    diagnosticEventHubAuthorizationRuleId: !empty(eventHubAuthorizationRuleId) ? eventHubAuthorizationRuleId : ''
    diagnosticEventHubName: !empty(eventHubName) ? eventHubName : ''
  }
  dependsOn: [
    asgWebSubnet
    asgAppSubnet
    asgDbSubnet
  ]

}

// ========== //
// Outputs    //
// ========== //
output virtualNetworkId string = virtualNetwork.outputs.resourceId
output bastionSubnetId string = virtualNetwork.outputs.subnetResourceIds[0]
output webSubnetId string = virtualNetwork.outputs.subnetResourceIds[1]
output appSubnetId string = virtualNetwork.outputs.subnetResourceIds[2]
output dbSubnetId string = virtualNetwork.outputs.subnetResourceIds[3]
output asgWebId string = asgWebSubnet.outputs.resourceId
output asgAppId string = asgWebSubnet.outputs.resourceId
output asgDbId string = asgWebSubnet.outputs.resourceId
