targetScope = 'subscription'

param prefix string = 'team5'
param location string = 'centralus'

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

// Create DB Tier
