targetScope = 'subscription'

@description('The regional network spoke VNet Resource ID that the cluster will be joined to.')
@minLength(79)
param targetVnetResourceId string

@description('Name of the resource group')
param resourceGroupName string = 'rg-spoke'

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
@description('AKS Service, Node Pool, and supporting services (KeyVault, App Gateway, etc) region. This needs to be the same region as the vnet provided in these parameters.')
param location string = 'eastus2'

@allowed([
  'australiasoutheast'
  'canadaeast'
  'eastus2'
  'westus'
  'centralus'
  'westcentralus'
  'francesouth'
  'germanynorth'
  'westeurope'
  'ukwest'
  'northeurope'
  'japanwest'
  'southafricawest'
  'northcentralus'
  'eastasia'
  'eastus'
  'westus2'
  'francecentral'
  'uksouth'
  'japaneast'
  'southeastasia'
])
@description('For Azure resources that support native geo-redunancy, provide the location the redundant service will have its secondary. Should be different than the location parameter and ideally should be a paired region - https://docs.microsoft.com/azure/best-practices-availability-paired-regions. This region does not need to support availability zones.')
param geoRedundancyLocation string = 'centralus'

/*** VARIABLES ***/

var subRgUniqueString = uniqueString('aks', subscription().subscriptionId, resourceGroupName)

/*** EXISTING RESOURCES ***/

resource spokeResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' existing = {
  scope: subscription()
  name: '${split(targetVnetResourceId,'/')[4]}'
}

resource spokeVirtualNetwork 'Microsoft.Network/virtualNetworks@2021-05-01' existing = {
  scope: spokeResourceGroup
  name: '${last(split(targetVnetResourceId,'/'))}'

  resource snetClusterNodes 'subnets@2021-05-01' existing = {
    name: 'snet-clusternodes'
  }
}

/*** RESOURCES ***/

module rg '../../arm/Microsoft.Resources/resourceGroups/deploy.bicep' = {
  name: resourceGroupName
  params: {
    name: resourceGroupName
    location: location
  }
}

// This Log Analytics workspace will be the log sink for all resources in the cluster resource group. This includes ACR, the AKS cluster, Key Vault, etc. It also is the Container Insights log sink for the AKS cluster.
module laAks '../../arm/Microsoft.OperationalInsights/workspaces/deploy.bicep' = {
  name: 'la-aks-${subRgUniqueString}'
  params: {
    name: 'la-aks-${subRgUniqueString}'
    location: location
    serviceTier: 'PerGB2018'
    dataRetention: 30
  }
  scope: resourceGroup(resourceGroupName)
  dependsOn: [
    rg
  ]
}

// Azure Container Registry will be exposed via Private Link, set up the related Private DNS zone and virtual network link to the spoke.
module dnsPrivateZoneAcr '../../arm/Microsoft.Network/privateDnsZones/deploy.bicep' = {
  name: 'privatelink.azurecr.io'
  params: {
    name: 'privatelink.azurecr.io'
    location: 'global'
    virtualNetworkLinks: [
      {
        name: 'to_${spokeVirtualNetwork.name}'
        virtualNetworkResourceId: targetVnetResourceId
        registrationEnabled: false
      }
    ]
  }
  scope: resourceGroup(resourceGroupName)
  dependsOn: [
    rg
  ]
}

// The Container Registry that the AKS cluster will be authorized to use to pull images.
module acrAks '../../arm/Microsoft.ContainerRegistry/registries/deploy.bicep' = {
  name: 'acraks${subRgUniqueString}'
  params: {
    name: 'acraks${subRgUniqueString}'
    location: location
    acrSku: 'Premium'
    acrAdminUserEnabled: false
    networkRuleSetDefaultAction: 'Deny'
    networkRuleSetIpRules: []
    quarantinePolicyStatus: 'disabled'
    trustPolicyStatus: 'disabled'
    retentionPolicyDays: 15
    retentionPolicyStatus: 'enabled'
    publicNetworkAccess: 'Disabled'
    encryptionStatus: 'disabled'
    dataEndpointEnabled: true
    networkRuleBypassOptions: 'AzureServices'
    zoneRedundancy: 'Disabled' // This Preview feature only supports three regions at this time, and eastus2's paired region (centralus), does not support this. So disabling for now.
    replications: [
      {
        name: geoRedundancyLocation
        location: geoRedundancyLocation
      }
    ]
    diagnosticWorkspaceId: laAks.outputs.resourceId
    privateEndpoints: [
      {
        name: 'nodepools'
        subnetResourceId: spokeVirtualNetwork::snetClusterNodes.id
        service: 'registry'
        privateDnsZoneResourceIds: [
          dnsPrivateZoneAcr.outputs.resourceId
        ]
      }
    ]
  }
  scope: resourceGroup(resourceGroupName)
  dependsOn: [
    rg
    dnsPrivateZoneAcr
  ]
}

/*** OUTPUTS ***/

output containerRegistryName string = acrAks.name
