targetScope = 'subscription'

@description('Name of the resource group')
param resourceGroupName string = 'rg-spoke'

@description('The regional hub network to which this regional spoke will peer to.')
param hubVnetResourceId string

@description('The spokes\'s regional affinity, must be the same as the hub\'s location. All resources tied to this spoke will also be homed in this region. The network team maintains this approved regional list which is a subset of zones with Availability Zone support.')
@allowed([
  'australiaeast'
  'canadacentral'
  'centralus'
  'eastus'
  'eastus2'
  'westus2'
  'francecentral'
  'germanywestcentral'
  'northeurope'
  'southafricanorth'
  'southcentralus'
  'uksouth'
  'westeurope'
  'japaneast'
  'southeastasia'
])
param location string

@description('A /16 to contain the cluster')
@minLength(10)
@maxLength(18)
param clusterVnetAddressSpace string = '10.240.0.0/16'

@description('The resource ID of the Log Analytics Workspace in the hub')
param hubLaWorkspaceResourceId string

@description('The resource ID of the Firewall in the hub')
param hubFwResourceId string

var orgAppId = 'BU0001A0008'
var clusterVNetName = 'vnet-spoke-${orgAppId}-00'
var routeTableName = 'route-to-${location}-hub-fw'
var nsgNodePoolsName = 'nsg-${clusterVNetName}-nodepools'
var nsgAksiLbName = 'nsg-${clusterVNetName}-aksilbs'
var nsgAppGwName = 'nsg-${clusterVNetName}-appgw'
var hubNetworkName = split(hubVnetResourceId, '/')[8]
var toHubPeeringName = 'spoke-${orgAppId}-to-${hubNetworkName}'
var primaryClusterPipName = 'pip-${orgAppId}-00'

module rg '../../arm/Microsoft.Resources/resourceGroups/deploy.bicep' = {
  name: resourceGroupName
  params: {
    name: resourceGroupName
    location: location
  }
}

module routeTable '../../arm/Microsoft.Network/routeTables/deploy.bicep' = {
  name: routeTableName
  params: {
    name: routeTableName
    location: location
    routes: [
      {
        name: 'r-nexthop-to-fw'
        properties: {
          nextHopType: 'VirtualAppliance'
          addressPrefix: '0.0.0.0/0'
          nextHopIpAddress: reference(hubFwResourceId, '2020-05-01').ipConfigurations[0].properties.privateIpAddress
        }
      }
    ]
  }
  scope: resourceGroup(resourceGroupName)
  dependsOn: [
    rg
  ]
}

module nsgNodePools '../../arm/Microsoft.Network/networkSecurityGroups/deploy.bicep' = {
  name: nsgNodePoolsName
  params: {
    name: nsgNodePoolsName
    location: location
    networkSecurityGroupSecurityRules: []
    diagnosticWorkspaceId: hubLaWorkspaceResourceId
  }
  scope: resourceGroup(resourceGroupName)
  dependsOn: [
    rg
  ]
}

module nsgAksiLb '../../arm/Microsoft.Network/networkSecurityGroups/deploy.bicep' = {
  name: nsgAksiLbName
  params: {
    name: nsgAksiLbName
    location: location
    networkSecurityGroupSecurityRules: []
    diagnosticWorkspaceId: hubLaWorkspaceResourceId
  }
  scope: resourceGroup(resourceGroupName)
  dependsOn: [
    rg
  ]
}

module nsgAppGw '../../arm/Microsoft.Network/networkSecurityGroups/deploy.bicep' = {
  name: nsgAppGwName
  params: {
    name: nsgAppGwName
    location: location
    networkSecurityGroupSecurityRules: [
      {
        name: 'Allow443InBound'
        properties: {
          description: 'Allow ALL web traffic into 443. (If you wanted to allow-list specific IPs, this is where you\'d list them.)'
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: 'Internet'
          destinationPortRange: '443'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowControlPlaneInBound'
        properties: {
          description: 'Allow Azure Control Plane in. (https://docs.microsoft.com/azure/application-gateway/configuration-infrastructure#network-security-groups)'
          protocol: '*'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationPortRange: '65200-65535'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 110
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowHealthProbesInBound'
        properties: {
          description: 'Allow Azure Health Probes in. (https://docs.microsoft.com/azure/application-gateway/configuration-infrastructure#network-security-groups)'
          protocol: '*'
          sourcePortRange: '*'
          sourceAddressPrefix: 'AzureLoadBalancer'
          destinationPortRange: '*'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 120
          direction: 'Inbound'
        }
      }
      {
        name: 'DenyAllInBound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationPortRange: '*'
          destinationAddressPrefix: '*'
          access: 'Deny'
          priority: 1000
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowAllOutBound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationPortRange: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 1000
          direction: 'Outbound'
        }
      }
    ]
    diagnosticWorkspaceId: hubLaWorkspaceResourceId
  }
  scope: resourceGroup(resourceGroupName)
  dependsOn: [
    rg
  ]
}

module clusterVNet '../../arm/Microsoft.Network/virtualNetworks/deploy.bicep' = {
  name: clusterVNetName
  params: {
    name: clusterVNetName
    location: location
    addressPrefixes: array(clusterVnetAddressSpace)
    diagnosticWorkspaceId: hubLaWorkspaceResourceId
    subnets: [
      {
        name: 'snet-clusternodes'
        addressPrefix: '10.240.0.0/22'
        routeTableName: routeTable.outputs.name
        networkSecurityGroupName: nsgNodePools.outputs.name
        privateEndpointNetworkPolicies: 'Disabled'
        privateLinkServiceNetworkPolicies: 'Enabled'
      }
      {
        name: 'snet-clusteringressservices'
        addressPrefix: '10.240.4.0/28'
        routeTableName: routeTable.outputs.name
        networkSecurityGroupName: nsgAksiLb.outputs.name
        privateEndpointNetworkPolicies: 'Disabled'
        privateLinkServiceNetworkPolicies: 'Disabled'
      }
      {
        name: 'snet-applicationgateway'
        addressPrefix: '10.240.4.16/28'
        networkSecurityGroupName: nsgAppGw.outputs.name
        privateEndpointNetworkPolicies: 'Disabled'
        privateLinkServiceNetworkPolicies: 'Disabled'
      }
    ]
    virtualNetworkPeerings: [
      {
        remoteVirtualNetworkId: hubVnetResourceId
        remotePeeringName: toHubPeeringName
        allowForwardedTraffic: true
        allowVirtualNetworkAccess: true
        allowGatewayTransit: false
        remotePeeringEnabled: true
        useRemoteGateways: false
      }
    ]
  }
  scope: resourceGroup(resourceGroupName)
  dependsOn: [
    rg
  ]
}

module primaryClusterPip '../../arm/Microsoft.Network/publicIPAddresses/deploy.bicep' = {
  name: primaryClusterPipName
  params: {
    name: primaryClusterPipName
    location: location
    skuName: 'Standard'
    publicIPAllocationMethod: 'Static'
    publicIPAddressVersion: 'IPv4'
    zones: [
      '1'
      '2'
      '3'
    ]
  }
  scope: resourceGroup(resourceGroupName)
  dependsOn: [
    rg
  ]
}

output clusterVnetResourceId string = clusterVNet.outputs.resourceId
output nodepoolSubnetResourceIds array = clusterVNet.outputs.subnetResourceIds
