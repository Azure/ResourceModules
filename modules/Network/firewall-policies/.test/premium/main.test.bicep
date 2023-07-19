targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'ms.network.firewallpolicies-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'nfppre'

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

var certName = 'cert-${serviceShort}'

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
    managedIdentityName: 'dep-[[namePrefix]]-msi-${serviceShort}'
    certDeploymentScriptName: 'dep-[[namePrefix]]-ds-${serviceShort}'
    keyVaultName: 'dep-[[namePrefix]]-kv-${serviceShort}'
    certName: certName
  }
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../main.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-test-${serviceShort}'
  params: {
    enableDefaultTelemetry: enableDefaultTelemetry
    tier: 'Premium'
    name: '[[namePrefix]]${serviceShort}001'
    userAssignedIdentities: {
      '${nestedDependencies.outputs.managedIdentityResourceId}': {}
    }
    keyVaultSecretId: nestedDependencies.outputs.certificateSecretUrl
    certificateName: certName
    mode: 'Alert'
    bypassTrafficSettings: [
      {
        name: 'IDPS whitelist item 1'
        protocol: 'TCP'
        sourceAddresses: [
          '192.168.1.1'
        ]
        destinationAddresses: [
          '*'
        ]
        sourceIpGroups: []
        destinationIpGroups: []
        destinationPorts: [
          '443'
        ]
      }
    ]
    ruleCollectionGroups: [
      {
        name: '[[namePrefix]]-rule-001'
        priority: 5000
        ruleCollections: [
          {
            action: {
              type: 'Allow'
            }
            name: 'collection002'
            priority: 5555
            ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
            rules: [
              {
                destinationAddresses: [
                  '*'
                ]
                destinationFqdns: []
                destinationIpGroups: []
                destinationPorts: [
                  '80'
                ]
                ipProtocols: [
                  'TCP'
                  'UDP'
                ]
                name: 'rule002'
                ruleType: 'NetworkRule'
                sourceAddresses: [
                  '*'
                ]
                sourceIpGroups: []
              }
            ]
          }
        ]
      }
    ]
    tags: {
      Environment: 'Non-Prod'
      Role: 'DeploymentValidation'
    }
    allowSqlRedirect: true
    autoLearnPrivateRanges: 'Enabled'
  }
}
