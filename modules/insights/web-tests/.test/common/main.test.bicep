targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'ms.insights.webtests-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'iwtcom'

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '<<namePrefix>>'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-nestedDependencies'
  params: {
    appInsightName: 'dep-${namePrefix}-appi-${serviceShort}'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    location: location
  }
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../main.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-test-${serviceShort}'
  params: {
    name: '${namePrefix}${serviceShort}001'
    tags: {
      'hidden-link:${nestedDependencies.outputs.appInsightResourceId}': 'Resource'
    }
    enableDefaultTelemetry: enableDefaultTelemetry
    webTestName: 'wt${namePrefix}$${serviceShort}001'
    syntheticMonitorId: '${namePrefix}${serviceShort}001'
    locations: [
      {
        Id: 'emea-nl-ams-azr'
      }
    ]
    request: {
      RequestUrl: 'https://learn.microsoft.com/en-us/'
      HttpVerb: 'GET'
    }
    lock: 'CanNotDelete'
  }
}
