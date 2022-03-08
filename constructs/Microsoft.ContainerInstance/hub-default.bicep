targetScope = 'subscription'

@description('Name of the resource group')
param resourceGroupName string = 'rg-enterprise-networking-hubs'

@description('The hub\'s regional affinity. All resources tied to this hub will also be homed in this region. The network team maintains this approved regional list which is a subset of zones with Availability Zone support.')
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

@description('Optional. Array of Security Rules to deploy to the Network Security Group. When not provided, an NSG including only the built-in roles will be deployed.')
param networkSecurityGroupSecurityRules array = []

@description('A /24 to contain the regional firewall, management, and gateway subnet')
@minLength(10)
@maxLength(18)
param hubVnetAddressSpace string = '10.200.0.0/24'

@description('A /26 under the VNet Address Space for the regional Azure Firewall')
@minLength(10)
@maxLength(18)
param azureFirewallSubnetAddressSpace string = '10.200.0.0/26'

@description('A /27 under the VNet Address Space for our regional On-Prem Gateway')
@minLength(10)
@maxLength(18)
param azureGatewaySubnetAddressSpace string = '10.200.0.64/27'

@description('A /27 under the VNet Address Space for regional Azure Bastion')
@minLength(10)
@maxLength(18)
param azureBastionSubnetAddressSpace string = '10.200.0.96/27'

@description('Allow egress traffic for cluster nodes. See https://docs.microsoft.com/en-us/azure/aks/limit-egress-traffic#required-outbound-network-rules-and-fqdns-for-aks-clusters')
param enableOutboundInternet bool = false

var baseFwPipName = 'pip-fw-${location}'
var hubFwPipNames = [
  '${baseFwPipName}-default'
  '${baseFwPipName}-01'
  '${baseFwPipName}-02'
]

var hubFwName = 'fw-${location}'
var fwPoliciesBaseName = 'fw-policies-base'
var fwPoliciesName = 'fw-policies-${location}'
var hubVNetName = 'vnet-${location}-hub'
var bastionNetworkNsgName = 'nsg-${location}-bastion'
var hubLaName = 'la-hub-${location}-${uniqueString(resourceId('Microsoft.Network/virtualNetworks', hubVNetName))}'

var networkRuleCollectionGroup = [
  {
    name: 'aks-allow-outbound-network'
    priority: 100
    action: {
      type: 'Allow'
    }
    rules: [
      {
        name: 'SecureTunnel01'
        ipProtocols: [
          'UDP'
        ]
        destinationPorts: [
          '1194'
        ]
        sourceAddresses: [
          '*'
        ]
        sourceIpGroups: []
        ruleType: 'NetworkRule'
        destinationIpGroups: []
        destinationAddresses: [
          'AzureCloud.${replace(location, ' ', '')}'
        ]
        destinationFqdns: []
      }
      {
        name: 'SecureTunnel02'
        ipProtocols: [
          'TCP'
        ]
        destinationPorts: [
          '9000'
        ]
        sourceAddresses: [
          '*'
        ]
        sourceIpGroups: []
        ruleType: 'NetworkRule'
        destinationIpGroups: []
        destinationAddresses: [
          'AzureCloud.${replace(location, ' ', '')}'
        ]
        destinationFqdns: []
      }
      {
        name: 'NTP'
        ipProtocols: [
          'UDP'
        ]
        destinationPorts: [
          '123'
        ]
        sourceAddresses: [
          '*'
        ]
        sourceIpGroups: []
        ruleType: 'NetworkRule'
        destinationIpGroups: []
        destinationAddresses: [
          '*'
        ]
        destinationFqdns: []
      }
    ]
    ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
  }
]

var applicationRuleCollectionGroup = [
  {
    name: 'aks-allow-outbound-app'
    priority: 110
    action: {
      type: 'Allow'
    }
    rules: [
      {
        name: 'NodeToApiServer'
        protocols: [
          {
            protocolType: 'Https'
            port: 443
          }
        ]
        terminateTLS: false
        sourceAddresses: [
          '*'
        ]
        sourceIpGroups: []
        targetFqdns: [
          '*.hcp.${replace(location, ' ', '')}.azmk8s.io'
        ]
        targetUrls: []
        fqdnTags: []
        webCategories: []
        ruleType: 'ApplicationRule'
      }
      {
        name: 'MCR'
        protocols: [
          {
            protocolType: 'Https'
            port: 443
          }
        ]
        terminateTLS: false
        sourceAddresses: [
          '*'
        ]
        sourceIpGroups: []
        targetFqdns: [
          'mcr.microsoft.com'
        ]
        targetUrls: []
        fqdnTags: []
        webCategories: []
        ruleType: 'ApplicationRule'
      }
      {
        name: 'McrStorage'
        protocols: [
          {
            protocolType: 'Https'
            port: 443
          }
        ]
        terminateTLS: false
        sourceAddresses: [
          '*'
        ]
        sourceIpGroups: []
        targetFqdns: [
          '*.data.mcr.microsoft.com'
        ]
        targetUrls: []
        fqdnTags: []
        webCategories: []
        ruleType: 'ApplicationRule'
      }
      {
        name: 'Ops'
        protocols: [
          {
            protocolType: 'Https'
            port: 443
          }
        ]
        terminateTLS: false
        sourceAddresses: [
          '*'
        ]
        sourceIpGroups: []
        targetFqdns: [
          'management.azure.com'
        ]
        targetUrls: []
        fqdnTags: []
        webCategories: []
        ruleType: 'ApplicationRule'
      }
      {
        name: 'AAD'
        protocols: [
          {
            protocolType: 'Https'
            port: 443
          }
        ]
        terminateTLS: false
        sourceAddresses: [
          '*'
        ]
        sourceIpGroups: []
        targetFqdns: [
          'login.microsoftonline.com'
        ]
        targetUrls: []
        fqdnTags: []
        webCategories: []
        ruleType: 'ApplicationRule'
      }
      {
        name: 'Packages'
        protocols: [
          {
            protocolType: 'Https'
            port: 443
          }
        ]
        terminateTLS: false
        sourceAddresses: [
          '*'
        ]
        sourceIpGroups: []
        targetFqdns: [
          'packages.microsoft.com'
        ]
        targetUrls: []
        fqdnTags: []
        webCategories: []
        ruleType: 'ApplicationRule'
      }
      {
        name: 'Repositories'
        protocols: [
          {
            protocolType: 'Https'
            port: 443
          }
        ]
        terminateTLS: false
        sourceAddresses: [
          '*'
        ]
        sourceIpGroups: []
        targetFqdns: [
          'acs-mirror.azureedge.net'
        ]
        targetUrls: []
        fqdnTags: []
        webCategories: []
        ruleType: 'ApplicationRule'
      }
    ]
    ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
  }
]

module rg '../../arm/Microsoft.Resources/resourceGroups/deploy.bicep' = {
  name: resourceGroupName
  params: {
    name: resourceGroupName
    location: location
  }
}

module hubLa '../../arm/Microsoft.OperationalInsights/workspaces/deploy.bicep' = {
  name: hubLaName
  params: {
    name: hubLaName
    location: location
    serviceTier: 'PerGB2018'
    dataRetention: 30
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
  scope: resourceGroup(resourceGroupName)
  dependsOn: [
    rg
  ]
}

module bastionNsg '../../arm/Microsoft.Network/networkSecurityGroups/deploy.bicep' = {
  name: bastionNetworkNsgName
  params: {
    name: bastionNetworkNsgName
    location: location
    networkSecurityGroupSecurityRules: networkSecurityGroupSecurityRules
    diagnosticWorkspaceId: hubLa.outputs.resourceId
  }
  scope: resourceGroup(resourceGroupName)
  dependsOn: [
    rg
  ]
}

module hubVNet '../../arm/Microsoft.Network/virtualNetworks/deploy.bicep' = {
  name: hubVNetName
  params: {
    name: hubVNetName
    location: location
    addressPrefixes: array(hubVnetAddressSpace)
    diagnosticWorkspaceId: hubLa.outputs.resourceId
    subnets: [
      {
        name: 'AzureFirewallSubnet'
        addressPrefix: azureFirewallSubnetAddressSpace
      }
      {
        name: 'GatewaySubnet'
        addressPrefix: azureGatewaySubnetAddressSpace
      }
      {
        name: 'AzureBastionSubnet'
        addressPrefix: azureBastionSubnetAddressSpace
        networkSecurityGroupName: bastionNsg.outputs.name
      }
    ]
  }
  scope: resourceGroup(resourceGroupName)
  dependsOn: [
    rg
  ]
}

module hubFwPips '../../arm/Microsoft.Network/publicIPAddresses/deploy.bicep' = [for item in hubFwPipNames: {
  name: item
  params: {
    name: item
    location: location
    skuName: 'Standard'
    publicIPAllocationMethod: 'Static'
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
}]

module fwPoliciesBase '../../arm/Microsoft.Network/firewallPolicies/deploy.bicep' = {
  name: fwPoliciesBaseName
  params: {
    name: fwPoliciesBaseName
    location: location
    tier: 'Standard'
    threatIntelMode: 'Deny'
    ipAddresses: []
    enableProxy: true
    servers: []
    ruleCollectionGroups: [
      {
        name: 'DefaultNetworkRuleCollectionGroup'
        priority: 200
        ruleCollections: [
          {
            ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
            action: {
              type: 'Allow'
            }
            rules: [
              {
                ruleType: 'NetworkRule'
                name: 'DNS'
                ipProtocols: [
                  'UDP'
                ]
                sourceAddresses: [
                  '*'
                ]
                sourceIpGroups: []
                destinationAddresses: [
                  '*'
                ]
                destinationIpGroups: []
                destinationFqdns: []
                destinationPorts: [
                  '53'
                ]
              }
            ]
            name: 'org-wide-allowed'
            priority: 100
          }
        ]
      }
    ]
  }
  scope: resourceGroup(resourceGroupName)
  dependsOn: [
    rg
  ]
}

module fwPolicies '../../arm/Microsoft.Network/firewallPolicies/deploy.bicep' = {
  name: fwPoliciesName
  params: {
    name: fwPoliciesName
    location: location
    basePolicyResourceId: fwPoliciesBase.outputs.resourceId
    tier: 'Standard'
    threatIntelMode: 'Deny'
    ipAddresses: []
    enableProxy: true
    servers: []
    ruleCollectionGroups: [
      {
        name: 'DefaultDnatRuleCollectionGroup'
        priority: 100
        ruleCollections: []
      }
      {
        name: 'DefaultNetworkRuleCollectionGroup'
        priority: 200
        ruleCollections: enableOutboundInternet ? networkRuleCollectionGroup : []
      }
      {
        name: 'DefaultApplicationRuleCollectionGroup'
        priority: 300
        ruleCollections: enableOutboundInternet ? applicationRuleCollectionGroup : []
      }
    ]
  }
  scope: resourceGroup(resourceGroupName)
  dependsOn: [
    rg
    fwPoliciesBase
  ]
}

module hubFw '../../arm/Microsoft.Network/azureFirewalls/deploy.bicep' = {
  name: hubFwName
  scope: resourceGroup(resourceGroupName)
  params: {
    name: hubFwName
    location: location
    zones: [
      '1'
      '2'
      '3'
    ]
    azureSkuName: 'AZFW_VNet'
    azureSkuTier: 'Standard'
    threatIntelMode: 'Deny'
    ipConfigurations: [
      {
        name: hubFwPipNames[0]
        publicIPAddressResourceId: hubFwPips[0].outputs.resourceId
        subnetResourceId: '${subscription().id}/resourceGroups/${resourceGroupName}/providers/Microsoft.Network/virtualNetworks/${hubVNetName}/subnets/AzureFirewallSubnet'
      }
      {
        name: hubFwPipNames[1]
        publicIPAddressResourceId: hubFwPips[1].outputs.resourceId
      }
      {
        name: hubFwPipNames[2]
        publicIPAddressResourceId: hubFwPips[2].outputs.resourceId
      }
    ]
    natRuleCollections: []
    networkRuleCollections: []
    applicationRuleCollections: []
    firewallPolicyId: fwPolicies.outputs.resourceId
    diagnosticWorkspaceId: hubLa.outputs.resourceId
  }
  dependsOn: [
    rg
  ]
}

output hubVnetId string = hubVNet.outputs.resourceId
