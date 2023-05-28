targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'ms.dbformysql.flexibleservers-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'dfmsfsp'

@description('Optional. The password to leverage for the login.')
@secure()
param password string = newGuid()

@description('Generated. Used as a basis for unique resource names.')
param baseTime string = utcNow('u')

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '<<namePrefix>>'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: location
}

module nestedDependencies1 'dependencies1.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-nestedDependencies1'
  params: {
    // Adding base time to make the name unique as purge protection must be enabled (but may not be longer than 24 characters total)
    location: location
    managedIdentityName: 'dep-${namePrefix}-msi-ds-${serviceShort}'
    pairedRegionScriptName: 'dep-${namePrefix}-ds-${serviceShort}'
  }
}

module nestedDependencies2 'dependencies2.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-nestedDependencies2'
  params: {
    // Adding base time to make the name unique as purge protection must be enabled (but may not be longer than 24 characters total)
    keyVaultName: 'dep-${namePrefix}-kv-${serviceShort}-${substring(uniqueString(baseTime), 0, 3)}'
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    geoBackupKeyVaultName: 'dep-${namePrefix}-kvp-${serviceShort}-${substring(uniqueString(baseTime), 0, 2)}'
    geoBackupManagedIdentityName: 'dep-${namePrefix}-msip-${serviceShort}'
    geoBackupLocation: nestedDependencies1.outputs.pairedRegionName
  }
}

// Diagnostics
// ===========
module diagnosticDependencies '../../../../.shared/.templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep${namePrefix}diasa${serviceShort}01'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}'
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
    enableDefaultTelemetry: enableDefaultTelemetry
    name: '${namePrefix}${serviceShort}001'
    location: resourceGroup.location
    lock: 'CanNotDelete'
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalIds: [
          nestedDependencies2.outputs.managedIdentityPrincipalId
        ]
        principalType: 'ServicePrincipal'
      }
    ]
    tags: {
      resourceType: 'MySQL Flexible Server'
      serverName: '${namePrefix}${serviceShort}001'
    }
    administratorLogin: 'adminUserName'
    administratorLoginPassword: password
    skuName: 'Standard_D2ds_v4'
    tier: 'GeneralPurpose'
    storageAutoIoScaling: 'Enabled'
    storageSizeGB: 32
    storageIOPS: 400
    backupRetentionDays: 20
    availabilityZone: '1'
    databases: [
      {

        name: 'testdb1'
      }
      {
        name: 'testdb2'
        charset: 'ascii'
        collation: 'ascii_general_ci'
      }
    ]
    firewallRules: [
      {
        endIpAddress: '0.0.0.0'
        name: 'AllowAllWindowsAzureIps'
        startIpAddress: '0.0.0.0'
      }
      {
        endIpAddress: '10.10.10.10'
        name: 'test-rule1'
        startIpAddress: '10.10.10.1'
      }
      {
        endIpAddress: '100.100.100.10'
        name: 'test-rule2'
        startIpAddress: '100.100.100.1'
      }
    ]
    highAvailability: 'SameZone'
    storageAutoGrow: 'Enabled'
    version: '8.0.21'
    cMKKeyVaultResourceId: nestedDependencies2.outputs.keyVaultResourceId
    cMKKeyName: nestedDependencies2.outputs.keyName
    cMKUserAssignedIdentityResourceId: nestedDependencies2.outputs.managedIdentityResourceId
    geoRedundantBackup: 'Enabled'
    geoBackupCMKKeyVaultResourceId: nestedDependencies2.outputs.geoBackupKeyVaultResourceId
    geoBackupCMKKeyName: nestedDependencies2.outputs.geoBackupKeyName
    geoBackupCMKUserAssignedIdentityResourceId: nestedDependencies2.outputs.geoBackupManagedIdentityResourceId
    userAssignedIdentities: {
      '${nestedDependencies2.outputs.managedIdentityResourceId}': {}
      '${nestedDependencies2.outputs.geoBackupManagedIdentityResourceId}': {}
    }
    diagnosticStorageAccountId: diagnosticDependencies.outputs.storageAccountResourceId
    diagnosticWorkspaceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
    diagnosticEventHubAuthorizationRuleId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
    diagnosticEventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
    diagnosticLogsRetentionInDays: 7
  }
}
