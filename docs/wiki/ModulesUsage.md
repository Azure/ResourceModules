# Modules Usage

This section gives you an overview of how to use the bicep modules.

---

## _Navigation_

- [Deploy template](#deploy-template)
  - [Deploy local template](#deploy-local-template)
    - [**Local:** PowerShell](#local-powershell)
    - [**Local:** Azure CLI](#local-azure-cli)
  - [Deploy remote template](#deploy-remote-template)
    - [**Remote:** PowerShell](#remote-powershell)
    - [**Remote:** Azure CLI](#remote-azure-cli)
- [Orchestrate deployment](#orchestrate-deployment)
  - [Template-orchestration](#template-orchestration)
- [Solution deployment](#solution-deployment)
  - [Sample solution](#sample-solution)
    - [Summary](#Summary)
    - [Repo structure](#repo-structure)
    - [YAML pipeline](#yaml-pipeline)
    - [Notes](#notes)

---

## Deploy template

This section shows you how to deploy a bicep template.

- [Deploy local template](#deploy-local-template)
- [Deploy remote template](#deploy-remote-template)

## Deploy local template

This sub-section gives you an example on how to deploy a template from your local drive.

### **Local:** PowerShell

This example targets a resource group level template.

```PowerShell
New-AzResourceGroup -Name 'ExampleGroup' -Location "Central US"

$inputObject = @{
 DeploymentName    = 'ExampleDeployment'
 ResourceGroupName = 'ExampleGroup'
 TemplateFile      = "$home\ResourceModules\arm\Microsoft.KeyVault\vault\deploy.bicep"
}
New-AzResourceGroupDeployment @inputObject
```

### **Local:** Azure CLI

This example targets a resource group level template.

```bash
az group create --name 'ExampleGroup' --location "Central US"
$inputObject = @(
    '--name',           'ExampleDeployment',
    '--resource-group', 'ExampleGroup',
    '--template-file',  "$home\ResourceModules\arm\Microsoft.KeyVault\vault\deploy.bicep",
    '--parameters',     'storageAccountType=Standard_GRS',
)
az deployment group create @inputObject
```

## Deploy remote template

This section gives you an example on how to deploy a template that is stored at a publicly available remote location.

### **Remote:** PowerShell

```PowerShell
New-AzResourceGroup -Name 'ExampleGroup' -Location "Central US"

$inputObject = @{
 DeploymentName    = 'ExampleDeployment'
 ResourceGroupName = 'ExampleGroup'
 TemplateUri       = 'https://raw.githubusercontent.com/Azure/ResourceModules/main/arm/Microsoft.KeyVault/vaults/deploy.bicep'
}
New-AzResourceGroupDeployment @inputObject
```

### **Remote:** Azure CLI

```bash
az group create --name 'ExampleGroup' --location "Central US"

$inputObject = @(
    '--name',           'ExampleDeployment',
    '--resource-group', 'ExampleGroup',
    '--template-uri',   'https://raw.githubusercontent.com/Azure/ResourceModules/main/arm/Microsoft.KeyVault/vaults/deploy.bicep',
    '--parameters',     'storageAccountType=Standard_GRS',
)
az deployment group create @inputObject
```

---

## Orchestrate deployment

This section shows you how you can orchestrate a deployment using multiple resource modules

- [Template-orchestration](#template-orchestration)

### Template-orchestration

The _template-orchestrated_ approach means using a _main_ or so-called _master template_ for deploying resources in Azure. The _master template_ will only contain nested deployments, where the modules – instead of embedding their content into the _master template_ – will be linked from the _master template_.

With this approach, modules need to be stored in an available location, where Azure Resource Manager (ARM) can access them. This can be achieved by storing the modules templates in an accessible location location like _template specs_ or the _bicep registry_.

In an enterprise environment, the recommended approach is to store these templates in a private environment, only accessible by enterprise resources. Thus, only trusted authorities can have access to these files.

### **Example with a private bicep registry**

The following example shows how you could orchestrate a deployment of multiple resources using modules from a private bicep registry. In this example we will deploy a resource group with a contained NSG and use the same in a subsequent VNET deployment.

```bicep
targetScope = 'subscription'

// ================ //
// Input Parameters //
// ================ //

// RG parameters
@description('Required. The name of the resource group to deploy')
param resourceGroupName string = 'validation-rg'

@description('Optional. The location to deploy into')
param location string = deployment().location

// NSG parameters
@description('Required. The name of the vnet to deploy')
param networkSecurityGroupName string = 'BicepRegistryDemoNsg'

// VNET parameters
@description('Required. The name of the vnet to deploy')
param vnetName string = 'BicepRegistryDemoVnet'

@description('Required. An Array of 1 or more IP Address Prefixes for the Virtual Network.')
param vNetAddressPrefixes array = [
  '10.0.0.0/16'
]

@description('Required. An Array of subnets to deploy to the Virtual Network.')
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

### ***Example with template-specs***

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
@description('Required. The name of the vnet to deploy')
param networkSecurityGroupName string = 'TemplateSpecDemoNsg'

// Virtual Network parameters
@description('Required. The name of the vnet to deploy')
param vnetName string = 'TemplateSpecDemoVnet'

@description('Required. An Array of 1 or more IP Address Prefixes for the Virtual Network.')
param vNetAddressPrefixes array = [
  '10.0.0.0/16'
]

@description('Required. An Array of subnets to deploy to the Virtual Network.')
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

## Solution deployment

The bicep modules provided by this repo can also be clubbed together to create more complex infrastructures and in the form a completely reusable solutions or products.

### Sample solution

#### Summary

1. Below is an example which uses a _multi-repo_ approach
1. It fetches the _public_ **Azure/ResourceModules** repo for consuming bicep modules and uses the parameter files present in the _private_ **Contoso/MultiRepoTest** repo for deploying infrastructure
1. This example is for creating a network hub with following resources -
    1. First stage: **Deploy resource group**
        1. Checkout 'Azure/ResourceModules' repo at root of the agent
        1. Set environment variables for the agent
        1. Checkout 'contoso/MultiRepoTest' repo containing the parameter files in a nested folder - "MultiRepoTestParentFolder"
        1. Deploy resource group in target Azure subscription
    1. Second stage: **Deploy network hub resources**
        1. Checkout 'Azure/ResourceModules' repo at root of the agent
        1. Set environment variables for the agent
        1. Checkout 'contoso/MultiRepoTest' repo containing the parameter files in a nested folder - "MultiRepoTestParentFolder"
        1. Deploy network security group
        1. Deploy route table
        1. Deploy virtual network A
        1. Deploy virtual network B
        1. Establish virtual network peering between virtual network A and B
        1. Establish virtual network peering between virtual network B and A

#### Repo structure

![RepoStructure](/docs/media/MultiRepoTestFolderStructure.png)

#### YAML pipeline

``` YAML
name: 'Network Hub'

on:
  push:
    branches:
      - main
    paths:
      - 'network-hub-rg/Parameters/**'
      - '.github/workflows/network-hub.yml'

env:
  AZURE_CREDENTIALS: ${{ secrets.AZURE_CREDENTIALS }}
  removeDeployment: false

jobs:
  job_deploy_resource_group:
    runs-on: ubuntu-20.04
    name: 'Deploy resource group'
    steps:
      - name: 'Checkout ResourceModules repo at the root location'
        uses: actions/checkout@v2
        with:
          repository: 'Azure/ResourceModules'
          fetch-depth: 0

      - name: 'Set environment variables'
        uses: deep-mm/set-variables@v1.0
        with:
          variableFileName: 'global.variables'

      - name: 'Checkout MultiRepoTest repo in a nested MultiRepoTestParentFolder'
        uses: actions/checkout@v2
        with:
          repository: 'contoso/MultiRepoTest'
          fetch-depth: 0
          path: 'MultiRepoTestParentFolder'

      - name: 'Deploy resource group'
        uses: ./.github/actions/templates/validateModuleDeployment
        with:
          templateFilePath: './arm/Microsoft.Resources/resourceGroups/deploy.bicep'
          parameterFilePath: './MultiRepoTestParentFolder/network-hub-rg/Parameters/ResourceGroup/parameters.json'
          location: '${{ env.defaultLocation }}'
          resourceGroupName: '${{ env.resourceGroupName }}'
          subscriptionId: '${{ secrets.ARM_SUBSCRIPTION_ID }}'
          managementGroupId: '${{ secrets.ARM_MGMTGROUP_ID }}'
          removeDeployment: $(removeDeployment)

  job_deploy_network_hub_resources:
    runs-on: ubuntu-20.04
    name: 'Deploy network hub resources'
    needs: job_deploy_resource_group
    steps:
      - name: 'Checkout ResourceModules repo at the root location'
        uses: actions/checkout@v2
        with:
          repository: 'Azure/ResourceModules'
          fetch-depth: 0

      - name: 'Set environment variables'
        uses: deep-mm/set-variables@v1.0
        with:
          variableFileName: 'global.variables'

      - name: 'Checkout MultiRepoTest repo in a nested MultiRepoTestParentFolder'
        uses: actions/checkout@v2
        with:
          repository: 'contoso/MultiRepoTest'
          fetch-depth: 0
          path: 'MultiRepoTestParentFolder'

      - name: 'Deploy network security group'
        uses: ./.github/actions/templates/validateModuleDeployment
        with:
          templateFilePath: './arm/Microsoft.Network/networkSecurityGroups/deploy.bicep'
          parameterFilePath: './MultiRepoTestParentFolder/network-hub-rg/Parameters/NetworkSecurityGroups/parameters.json'
          location: '${{ env.defaultLocation }}'
          resourceGroupName: '${{ env.resourceGroupName }}'
          subscriptionId: '${{ secrets.ARM_SUBSCRIPTION_ID }}'
          managementGroupId: '${{ secrets.ARM_MGMTGROUP_ID }}'
          removeDeployment: $(removeDeployment)

      - name: 'Deploy route table'
        uses: ./.github/actions/templates/validateModuleDeployment
        with:
          templateFilePath: './arm/Microsoft.Network/routeTables/deploy.bicep'
          parameterFilePath: './MultiRepoTestParentFolder/network-hub-rg/Parameters/RouteTables/parameters.json'
          location: '${{ env.defaultLocation }}'
          resourceGroupName: '${{ env.resourceGroupName }}'
          subscriptionId: '${{ secrets.ARM_SUBSCRIPTION_ID }}'
          managementGroupId: '${{ secrets.ARM_MGMTGROUP_ID }}'
          removeDeployment: $(removeDeployment)

      - name: 'Deploy virtual network A'
        uses: ./.github/actions/templates/validateModuleDeployment
        with:
          templateFilePath: './arm/Microsoft.Network/virtualNetworks/deploy.bicep'
          parameterFilePath: './MultiRepoTestParentFolder/network-hub-rg/Parameters/VirtualNetwork/vnet-A.parameters.json'
          location: '${{ env.defaultLocation }}'
          resourceGroupName: '${{ env.resourceGroupName }}'
          subscriptionId: '${{ secrets.ARM_SUBSCRIPTION_ID }}'
          managementGroupId: '${{ secrets.ARM_MGMTGROUP_ID }}'
          removeDeployment: $(removeDeployment)

      - name: 'Deploy virtual network B'
        uses: ./.github/actions/templates/validateModuleDeployment
        with:
          templateFilePath: './arm/Microsoft.Network/virtualNetworks/deploy.bicep'
          parameterFilePath: './MultiRepoTestParentFolder/network-hub-rg/Parameters/VirtualNetwork/vnet-B.parameters.json'
          location: '${{ env.defaultLocation }}'
          resourceGroupName: '${{ env.resourceGroupName }}'
          subscriptionId: '${{ secrets.ARM_SUBSCRIPTION_ID }}'
          managementGroupId: '${{ secrets.ARM_MGMTGROUP_ID }}'
          removeDeployment: $(removeDeployment)

      - name: 'Deploy virtual network peering from VNet A to VNet B'
        uses: ./.github/actions/templates/validateModuleDeployment
        with:
          templateFilePath: './arm/Microsoft.Network/virtualNetworks/virtualNetworkPeerings/deploy.bicep'
          parameterFilePath: './MultiRepoTestParentFolder/network-hub-rg/Parameters/VirtualNetworkPeering/vneta-to-vnetb-peering.parameters.json'
          location: '${{ env.defaultLocation }}'
          resourceGroupName: '${{ env.resourceGroupName }}'
          subscriptionId: '${{ secrets.ARM_SUBSCRIPTION_ID }}'
          managementGroupId: '${{ secrets.ARM_MGMTGROUP_ID }}'
          removeDeployment: $(removeDeployment)

      - name: 'Deploy virtual network peering from VNet B to VNet A'
        uses: ./.github/actions/templates/validateModuleDeployment
        with:
          templateFilePath: './arm/Microsoft.Network/virtualNetworks/virtualNetworkPeerings/deploy.bicep'
          parameterFilePath: './MultiRepoTestParentFolder/network-hub-rg/Parameters/VirtualNetworkPeering/vnetb-to-vneta-peering.parameters.json'
          location: '${{ env.defaultLocation }}'
          resourceGroupName: '${{ env.resourceGroupName }}'
          subscriptionId: '${{ secrets.ARM_SUBSCRIPTION_ID }}'
          managementGroupId: '${{ secrets.ARM_MGMTGROUP_ID }}'
          removeDeployment: $(removeDeployment)
```

#### Notes

> 1. 'Azure/ResourceModules' repo has been checked out at the root location intentionally because the `deep-mm/set-variables@v1.0` task expects the _global.variables.json_ file in the _.github/variables/_ location. The GitHub Actions also expect the underlying utility scripts at a specific location
> 1. 'contoso/MultiRepoTest' repo has been checked out in a nested folder called as "MultiRepoTestParentFolder" to distinguish it from the folders from the other repo in the agent but can be downloaded at the root location too if desired
> 1. Comparison between IaCS and CARML -
>
>    Snippet of Resource Group deployment job from the _Solution_ repo of IaCS -
>
>    ![IaCS_RGDeployJob](/docs/media/IaCS_DeployRGJob.png)
>
>    | Sr. no. | Topic| IaCS | CARML |
>    | :-: | :-: | - | - |
>    | 1. | Authentication to Azure | Done via Service Connection | Done via an environment variable: ```AZURE_CREDENTIALS: ${{ secrets.AZURE_CREDENTIALS }}```
>    | 2. | Repo checkouts | Once specified at the top, _Components_ repo is not required to be downloaded in every job | All the requisite repos need to be downloaded every time in a job to complete successfully. With that, the 'Set environment variables' task also needs to be specified in every job after _Azure/ResourceModules_ repo has been checked out |
>    | 3. | Way of deployment | Each deployment "job" consists of a 'pipeline.jobs.deploy.yml' _template_ and a target module which are fetched from the _Components_ repo | Here, GitHub Action template called as "validateModuleDeployment" has been used |
>    | 4. | Passing parameters |  A dedicated 'deploymentBlocks' block is used to supply the parameter file from the local _Solutions_ repo | parameters.json file is directly specified under the "with" keyword which is passed onto the corresponding GitHub action |
