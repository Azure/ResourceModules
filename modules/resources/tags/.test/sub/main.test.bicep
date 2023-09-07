targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'rtsub'

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../main.bicep' = {
  name: '${uniqueString(deployment().name)}-test-${serviceShort}'
  params: {
    onlyUpdate: true
    tags: {
      'hidden-title': 'This is visible in the resource name'
      Test: 'Yes'
      TestToo: 'No'
    }
    enableDefaultTelemetry: enableDefaultTelemetry
  }
}
