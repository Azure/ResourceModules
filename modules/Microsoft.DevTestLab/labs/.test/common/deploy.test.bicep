targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //
@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'ms.devtestlab.labs-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'dtlcom'

@description('Generated. Used as a basis for unique resource names.')
param baseTime string = utcNow('u')

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
    managedIdentityName: 'dep-carml-msi-${serviceShort}'
    // Adding base time to make the name unique as purge protection must be enabled (but may not be longer than 24 characters total)
    keyVaultName: 'dep-carml-kv-${serviceShort}-${substring(uniqueString(baseTime), 0, 3)}'
    diskEncryptionSetName: 'dep-carml-des-${serviceShort}'
  }
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../deploy.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name)}-test-${serviceShort}'
  params: {
    enableDefaultTelemetry: enableDefaultTelemetry
    name: 'carml${serviceShort}001'
    announcement: {
      enabled: 'Enabled'
      expirationDate: '2025-12-30T13:00:00.000Z'
      markdown: 'DevTest Lab announcement text. <br> New line. It also supports Markdown'
      title: 'DevTest announcement title'
    }
    support: {
      enabled: 'Enabled'
      markdown: 'DevTest Lab support text. <br> New line. It also supports Markdown'
    }
    systemAssignedIdentity: true
    userAssignedIdentities: {
      '${resourceGroupResources.outputs.managedIdentityResourceId}': {}
    }
    managementIdentities: {
      '${resourceGroupResources.outputs.managedIdentityResourceId}': {}
    }
    vmCreationResourceGroupId: resourceGroup.id
    browserConnect: 'Enabled'
    extendedProperties: {
      RdpConnectionType: '7'
    }
    disableAutoUpgradeCseMinorVersion: true
    isolateLabResources: 'Disabled'
    encryptionType: 'EncryptionAtRestWithCustomerKey'
    encryptionDiskEncryptionSetId: resourceGroupResources.outputs.diskEncryptionSetResourceId
  }
}
