targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //
@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'ms.eventgrid.eventsubscriptions-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'egescom'

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

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-paramNested'
  params: {
    managedIdentityName: 'dep-<<namePrefix>>-msi-${serviceShort}'
    eventTopicName: 'dep-<<namePrefix>>-evt-${serviceShort}'
    serviceBusName: 'dep-<<namePrefix>>-sb-${serviceShort}'
    location: location
  }
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../deploy.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-test-${serviceShort}'
  params: {
    enableDefaultTelemetry: enableDefaultTelemetry
    name: '<<namePrefix>>${serviceShort}001'
    eventGridTopicName: last(split(nestedDependencies.outputs.eventTopicResourceId, '/'))
    expirationTimeUtc: '2026-01-01T11:00:21.715Z'
    filter: {
      isSubjectCaseSensitive: false
      enableAdvancedFilteringOnArrays: true
    }
    retryPolicy: {
      maxDeliveryAttempts: 10
      eventTimeToLive: '120'
    }
    eventDeliverySchema: 'EventGridSchema'
    destination: {
      endpointType: 'ServiceBusTopic'
      properties: {
        resourceId: nestedDependencies.outputs.serviceBusTopicResourceId

      }
    }
  }
}
