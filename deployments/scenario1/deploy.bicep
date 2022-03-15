targetScope = 'subscription'

param prefix string = 'team5'
param location string = 'centralus'

var appInsightsName = '${prefix}-app-insights'
var loganalyticsName = '${prefix}-ws'
var vnetName = '${prefix}-vnet'
var vNetAddressPrefixes = [
  '10.0.0.0/16'
]
var subnets = [
  {
    name: 'WebSubnet'
    addressPrefix: '10.0.0.0/24'
  }
  {
    name: 'AppSubnet'
    addressPrefix: '10.0.1.0/24'
  }
  {
    name: 'DataSubnet'
    addressPrefix: '10.0.2.0/24'
  }
]

var keyVaultName = '${prefix}-keyvault'
// Create Resource Groups

@description('The Resource Groups to create')

module rsg_web_tier '../../arm/Microsoft.Resources/resourceGroups/deploy.bicep' = {
  name: '${prefix}-web'
  params: {
    name: '${prefix}-web'
    location: location
  }
}

module rsg_app_tier '../../arm/Microsoft.Resources/resourceGroups/deploy.bicep' = {
  name: '${prefix}-app'
  params: {
    name: '${prefix}-app'
    location: location
  }
}

module rsg_data_tier '../../arm/Microsoft.Resources/resourceGroups/deploy.bicep' = {
  name: '${prefix}-data'
  params: {
    name: '${prefix}-data'
    location: location
  }
}

module rsg_shared '../../arm/Microsoft.Resources/resourceGroups/deploy.bicep' = {
  name: '${prefix}-shared'
  params: {
    name: '${prefix}-shared'
    location: location
  }
}

// Create Web Tier

module site '../../arm/Microsoft.Web/sites/deploy.bicep' = {
  name: '${prefix}-web-site'
  scope: resourceGroup(rsg_web_tier.name)
  params: {
    name: '${prefix}-web-site'
    location: location
    kind: 'app'
    appServicePlanObject: {
      serverOS: 'Windows'
      skuName: 'P1v2'
      skuCapacity: 1
      skuTier: 'PremiumV2'
      skuSize: 'P1v2'
      skuFamily: 'Pv2'
    }
    functionsWorkerRuntime: 'dotnet'
  }
}

// Create App Tier

// Virtual Network
module vnet '../../arm/Microsoft.Network/virtualnetworks/deploy.bicep' = {
  name: 'team5-vnet'
  scope: resourceGroup(rsg_shared.name)
  params: {
    location: location
    name: vnetName
    addressPrefixes: vNetAddressPrefixes
    subnets: subnets
  }
  dependsOn: [
    rsg_shared
  ]
}

// Key Vault
module kv '../../arm/Microsoft.KeyVault/vaults/deploy.bicep' = {
  scope: resourceGroup(rsg_shared.name)
  name: 'team5-keyvault'
  params: {
    location: location
    name: keyVaultName
  }
}

// Create DB Tier

// Create Log Analytics

module logAnalytics '../../arm/Microsoft.OperationalInsights/workspaces/deploy.bicep' = {
  name: loganalyticsName
  scope: resourceGroup(rsg_shared.name)
  params: {
    location: location
    name: loganalyticsName
  }
  dependsOn: [
    rsg_shared
  ]
}

// Create App Insights

module app_insights '../../arm/Microsoft.Insights/components/deploy.bicep' = {
  name: appInsightsName
  scope: resourceGroup(rsg_shared.name)
  params: {
    name: appInsightsName
    location: location
    workspaceResourceId: logAnalytics.outputs.resourceId
  }
  dependsOn: [
    rsg_shared
    logAnalytics
  ]
}
