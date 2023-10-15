targetScope = 'subscription'

metadata name = 'Using a large set of parameters'
metadata description = 'This instance deploys the module with a large set of possible parameters.'

// ========== //
// Parameters //
// ========== //

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'cbcom'

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '[[namePrefix]]'

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../main.bicep' = {
  name: '${uniqueString(deployment().name)}-test-${serviceShort}'
  params: {
    enableDefaultTelemetry: enableDefaultTelemetry
    name: '${namePrefix}${serviceShort}001'
    amount: 500
    contactEmails: [
      'dummy@contoso.com'
    ]
    thresholds: [
      50
      75
      90
      100
      110
    ]
  }
}
