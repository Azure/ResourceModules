targetScope = 'managementGroup'

// ========== //
// Parameters //
// ========== //

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'ardmgmin'

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '<<namePrefix>>'

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../management-group/main.bicep' = {
  name: '${uniqueString(deployment().name)}-test-${serviceShort}'
  params: {
    enableDefaultTelemetry: enableDefaultTelemetry
    roleName: '${namePrefix}-testRole-${serviceShort}'
    actions: [
      'Microsoft.Compute/galleries/images/read'
      'Microsoft.Compute/galleries/read'
    ]
  }
}
