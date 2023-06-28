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
param serviceShort string = 'cdnpcom'

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
    storageAccountName: 'dep${namePrefix}cdnstore${serviceShort}'
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
  }
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../main.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-test-${serviceShort}'
  params: {
    name: 'dep-${namePrefix}-test-${serviceShort}'
    location: location
    lock: 'CanNotDelete'
    originResponseTimeoutSeconds: 60
    sku: 'Standard_Verizon'
    enableDefaultTelemetry: enableDefaultTelemetry
    endpointProperties: {
      originHostHeader: '${nestedDependencies.outputs.storageAccountName}.blob.${environment().suffixes.storage}'
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
          name: 'dep-${namePrefix}-cdn-endpoint01'
          properties: {
            hostName: '${nestedDependencies.outputs.storageAccountName}.blob.${environment().suffixes.storage}'
            httpPort: 80
            httpsPort: 443
            enabled: true
          }
        }
      ]
      originGroups: []
      geoFilters: []
    }
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalIds: [
          nestedDependencies.outputs.managedIdentityPrincipalId
        ]
        principalType: 'ServicePrincipal'
      }
    ]
  }
}
