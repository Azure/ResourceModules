targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

// Resource Group
@description('Required. The name of the resource group to deploy for a testing purposes')
param resourceGroupName string

// Shared
var location = deployment().location
var serviceShort = 'vmwinmin'

// Virtual Network
var networkSecurityGroupParameters = {
  name: 'adp-sxx-nsg-${serviceShort}-01'
}

var virtualNetworkParameters = {
  name: 'adp-sxx-vnet-${serviceShort}-01'
  addressPrefix: [
    '10.0.0.0/16'
  ]
  subnets: [
    {
      name: 'sxx-subnet-x-01'
      addressPrefix: '10.0.0.0/24'
      networkSecurityGroupName: networkSecurityGroupParameters.name
    }
  ]
}

// =========== //
// Deployments //
// =========== //

module resourceGroup '../../../../../arm/Microsoft.Resources/resourceGroups/deploy.bicep' = {
  name: '${uniqueString(deployment().name, location)}-rg'
  params: {
    name: resourceGroupName
    location: location
  }
}

module networkSecurityGroup '../../../../../arm/Microsoft.Network/networkSecurityGroups/deploy.bicep' = {
  scope: az.resourceGroup(resourceGroupName)
  name: '${uniqueString(deployment().name, location)}-nsg'
  params: {
    name: networkSecurityGroupParameters.name
  }
  dependsOn: [
    resourceGroup
  ]
}

module virtualNetwork '../../../../../arm/Microsoft.Network/virtualNetworks/deploy.bicep' = {
  scope: az.resourceGroup(resourceGroupName)
  name: '${uniqueString(deployment().name, location)}-vnet'
  params: {
    name: virtualNetworkParameters.name
    addressPrefixes: virtualNetworkParameters.addressPrefix
    subnets: virtualNetworkParameters.subnets
  }
  dependsOn: [
    resourceGroup
    networkSecurityGroup
  ]
}

@description('The name of the resource group')
output resourceGroupName string = resourceGroup.outputs.resourceGroupName

@description('The resource ID of the resource group')
output resourceGroupResourceId string = resourceGroup.outputs.resourceGroupResourceId
