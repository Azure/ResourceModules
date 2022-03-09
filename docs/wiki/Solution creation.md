This section shows you how you can orchestrate a deployment using multiple resource modules.

> **Note:** For the sake of the below examples we assume you leverage Bicep as your primary DSL.

- [Template-orchestration](#template-orchestration)

# Template-orchestration

The _template-orchestrated_ approach means using a _main_ or so-called _master template_ for deploying resources in Azure. This template will only contain nested deployments, where the modules – instead of embedding their content into the _master template_ – will be referenced by the _master template_.

With this approach, modules need to be stored in an available location, where the Azure Resource Manager (ARM) can access them. This can be achieved by storing the modules templates in an accessible location location like _local_, _template specs_ or the _bicep registry_.

In an enterprise environment, the recommended approach is to store these templates in a private environment, only accessible by enterprise resources. Thus, only trusted authorities can have access to these files.

## ***Example with local file references***

The following example shows how you could orchestrate a deployment of multiple resources using local module references. In this example we will deploy a resource group with a contained NSG and use the same in a subsequent VNET deployment.

```bicep
targetScope = 'subscription'

// ================ //
// Input Parameters //
// ================ //

// RG parameters
@description('Optional. The name of the resource group to deploy')
param resourceGroupName string = 'validation-rg'

@description('Optional. The location to deploy into')
param location string = deployment().location

// NSG parameters
@description('Optional. The name of the vnet to deploy')
param networkSecurityGroupName string = 'BicepRegistryDemoNsg'

// VNET parameters
@description('Optional. The name of the vnet to deploy')
param vnetName string = 'BicepRegistryDemoVnet'

@description('Optional. An Array of 1 or more IP Address Prefixes for the Virtual Network.')
param vNetAddressPrefixes array = [
  '10.0.0.0/16'
]

@description('Optional. An Array of subnets to deploy to the Virual Network.')
param subnets array = [
  {
    name: 'PrimarySubnet'
    addressPrefix: '10.0.0.0/24'
    networkSecurityGroupName: networkSecurityGroupName
  }
  {
    name: 'SecondarySubnet'
    addressPrefix: '10.0.1.0/24'
    networkSecurityGroupName: networkSecurityGroupName
  }
]

// =========== //
// Deployments //
// =========== //

// Resource Group
module rg '../arm/Microsoft.Resources/resourceGroups/deploy.bicep' = {
  name: 'registry-rg'
  params: {
    name: resourceGroupName
    location: location
  }
}

// Network Security Group
module nsg '../arm/Microsoft.Network/networkSecurityGroups/deploy.bicep' = {
  name: 'registry-nsg'
  scope: resourceGroup(resourceGroupName)
  params: {
    name: networkSecurityGroupName
  }
  dependsOn: [
    rg
  ]
}

// Virtual Network
module vnet '../arm/Microsoft.Network/virtualNetworks/deploy.bicep' = {
  name: 'registry-vnet'
  scope: resourceGroup(resourceGroupName)
  params: {
    name: vnetName
    addressPrefixes: vNetAddressPrefixes
    subnets: subnets
  }
  dependsOn: [
    nsg
    rg
  ]
}
```

## ***Example with a private bicep registry***

The following example shows how you could orchestrate a deployment of multiple resources using modules from a private bicep registry. In this example we will deploy a resource group with a contained NSG and use the same in a subsequent VNET deployment.

```bicep
targetScope = 'subscription'

// ================ //
// Input Parameters //
// ================ //

// RG parameters
@description('Optional. The name of the resource group to deploy')
param resourceGroupName string = 'validation-rg'

@description('Optional. The location to deploy into')
param location string = deployment().location

// NSG parameters
@description('Optional. The name of the vnet to deploy')
param networkSecurityGroupName string = 'BicepRegistryDemoNsg'

// VNET parameters
@description('Optional. The name of the vnet to deploy')
param vnetName string = 'BicepRegistryDemoVnet'

@description('Optional. An Array of 1 or more IP Address Prefixes for the Virtual Network.')
param vNetAddressPrefixes array = [
  '10.0.0.0/16'
]

@description('Optional. An Array of subnets to deploy to the Virual Network.')
param subnets array = [
  {
    name: 'PrimarySubnet'
    addressPrefix: '10.0.0.0/24'
    networkSecurityGroupName: networkSecurityGroupName
  }
  {
    name: 'SecondarySubnet'
    addressPrefix: '10.0.1.0/24'
    networkSecurityGroupName: networkSecurityGroupName
  }
]

// =========== //
// Deployments //
// =========== //

// Resource Group
module rg 'br/modules:microsoft.resources.resourcegroups:0.4.735' = {
  name: 'registry-rg'
  params: {
    name: resourceGroupName
    location: location
  }
}

// Network Security Group
module nsg 'br/modules:microsoft.network.networksecuritygroups:0.4.735' = {
  name: 'registry-nsg'
  scope: resourceGroup(resourceGroupName)
  params: {
    name: networkSecurityGroupName
  }
  dependsOn: [
    rg
  ]
}

// Virtual Network
module vnet 'br/modules:microsoft.network.virtualnetworks:0.4.735' = {
  name: 'registry-vnet'
  scope: resourceGroup(resourceGroupName)
  params: {
    name: vnetName
    addressPrefixes: vNetAddressPrefixes
    subnets: subnets
  }
  dependsOn: [
    nsg
    rg
  ]
}
```

The example assumes you are using a [`bicepconfig.json`](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/bicep-config) configuration file like:

```json
{
    "moduleAliases": {
        "br": {
            "modules": {
                "registry": "<registryName>.azurecr.io",
                "modulePath": "bicep/modules"
            }
        }
    }
}
```


## ***Example with template-specs***

The following example shows how you could orchestrate a deployment of multiple resources using template specs. In this example we will deploy a NSG and use the same in a subsequent VNET deployment.

```bicep
targetScope = 'subscription'

// ================ //
// Input Parameters //
// ================ //

// RG parameters
@description('Optional. The name of the resource group to deploy')
param resourceGroupName string = 'validation-rg'

@description('Optional. The location to deploy into')
param location string = deployment().location

// Network Security Group parameters
@description('Optional. The name of the vnet to deploy')
param networkSecurityGroupName string = 'TemplateSpecDemoNsg'

// Virtual Network parameters
@description('Optional. The name of the vnet to deploy')
param vnetName string = 'TemplateSpecDemoVnet'

@description('Optional. An Array of 1 or more IP Address Prefixes for the Virtual Network.')
param vNetAddressPrefixes array = [
  '10.0.0.0/16'
]

@description('Optional. An Array of subnets to deploy to the Virual Network.')
param subnets array = [
  {
    name: 'PrimarySubnet'
    addressPrefix: '10.0.0.0/24'
    networkSecurityGroupName: networkSecurityGroupName
  }
  {
    name: 'SecondarySubnet'
    addressPrefix: '10.0.1.0/24'
    networkSecurityGroupName: networkSecurityGroupName
  }
]

// =========== //
// Deployments //
// =========== //

// Resource Group
module rg 'ts/modules:microsoft.resources.resourcegroups:0.4.735' = {
  name: 'rgDeployment'
  params: {
    name: resourceGroupName
    location: location
  }
}

// Network Security Group
module nsg 'ts/modules:microsoft.network.networksecuritygroups:0.4.735' = {
  name: 'nsgDeployment'
  scope: resourceGroup(resourceGroupName)
  params: {
    name:  networkSecurityGroupName
  }
    dependsOn: [
    rg
  ]
}

// Virtual Network
module vnet 'ts/modules:microsoft.network.virtualnetworks:0.4.735' = {
  name: 'vnetDeployment'
  scope: resourceGroup(resourceGroupName)
  params: {
    name:  vnetName
    addressPrefixes: vNetAddressPrefixes
    subnets : subnets
  }
  dependsOn: [
    rg
    nsg
  ]
}
```

The example assumes you are using a [`bicepconfig.json`](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/bicep-config) configuration file like:

```json
{
    "moduleAliases": {
        "ts": {
            "modules": {
                "subscription": "<<subscriptionId>>",
                "resourceGroup": "artifacts-rg"
            }
        }
    }
}
```
