targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //
@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'ms.cdn.profiles-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'cdnprof'

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

// =========== //
// Deployments //
// =========== //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

module resourceGroupResources 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-paramNested'
  params: {
    storageaccountname: 'dep<<namePrefix>>cdnstore${serviceShort}'
  }
}

// Diagnostics
// ===========
module diagnosticDependencies '../../../../.shared/dependencyConstructs/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep<<namePrefix>>diasa${serviceShort}01'
    logAnalyticsWorkspaceName: 'dep-<<namePrefix>>-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-<<namePrefix>>-evh-${serviceShort}'
    eventHubNamespaceName: 'dep-<<namePrefix>>-evhns-${serviceShort}'
    location: location
  }
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../deploy.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-testExecution'
  params: {
    name: 'dep-<<namePrefix>>-cdn-${serviceShort}'
    location: location
    profileProperties: {}
    sku: 'Standard_Verizon'
    enableDefaultTelemetry: enableDefaultTelemetry
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: diagnosticDependencies.outputs.storageAccountResourceId
    diagnosticWorkspaceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
    diagnosticEventHubAuthorizationRuleId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
    diagnosticEventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
    diagnosticSettingsName: 'cdnprofilediagnostics'
    endpointProperties: {
        originHostHeader: '${resourceGroupResources.outputs.storageAccountName}.blob.core.windows.net'
        contentTypesToCompress: [
          'text/plain'
          'text/html'
          'text/css'
          'text/javascript'
          'application/x-javascript'
          'application/javascript'
          'application/json'
          'application/xml'
        ]
        isCompressionEnabled: true
        isHttpAllowed: true
        isHttpsAllowed: true
        queryStringCachingBehavior: 'IgnoreQueryString'
        origins: [
          {
            name: '${resourceGroupResources.outputs.storageAccountName}.blob.core.windows.net'
            properties: {
              hostName: '${resourceGroupResources.outputs.storageAccountName}.blob.core.windows.net'
              httpPort: 80
              httpsPort: 443
              enabled: true
            }
          }
        ]
        originGroups: []
        geoFilters: []
      }
    }
  }
