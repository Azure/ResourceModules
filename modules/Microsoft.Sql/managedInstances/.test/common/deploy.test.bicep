targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //
@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(80)
param resourceGroupName string = 'ms.sql.managedinstances-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'sqlmicom'

@description('Optional. The password to leverage for the login.')
@secure()
param password string = newGuid()

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
  name: '${uniqueString(deployment().name, location)}-nestedDependencies'
  params: {
    keyVaultName: 'dep-<<namePrefix>>-kv-${serviceShort}'
    managedIdentityName: 'dep-<<namePrefix>>-msi-${serviceShort}'
    virtualNetworkName: 'dep-<<namePrefix>>-vnet-${serviceShort}'
    networkSecurityGroupName: 'dep-<<namePrefix>>-nsg-${serviceShort}'
    routeTableName: 'dep-<<namePrefix>>-rt-${serviceShort}'
    location: location
  }
}

// Diagnostics
// ===========
module diagnosticDependencies '../../../../.shared/dependencyConstructs/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep<<namePrefix>>azsa${serviceShort}01'
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
  name: '${uniqueString(deployment().name, location)}-test-${serviceShort}'
  params: {
    enableDefaultTelemetry: enableDefaultTelemetry
    name: '<<namePrefix>>-${serviceShort}'
    administratorLogin: 'adminUserName'
    administratorLoginPassword: password
    subnetId: resourceGroupResources.outputs.subnetResourceId
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    databases: [
      {
        backupLongTermRetentionPolicies: {
          name: 'default'
        }
        backupShortTermRetentionPolicies: {
          name: 'default'
        }
        name: '<<namePrefix>>-${serviceShort}-db-001'
      }
    ]
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: diagnosticDependencies.outputs.storageAccountResourceId
    diagnosticWorkspaceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
    diagnosticEventHubAuthorizationRuleId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
    diagnosticEventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
    dnsZonePartner: ''
    encryptionProtectorObj: {
      serverKeyName: '${resourceGroupResources.outputs.keyVaultName}_${resourceGroupResources.outputs.keyVaultKeyName}_${last(split(resourceGroupResources.outputs.keyVaultEncryptionKeyUrl, '/'))}'
      serverKeyType: 'AzureKeyVault'
    }
    hardwareFamily: 'Gen5'
    keys: [
      {
        name: '${resourceGroupResources.outputs.keyVaultName}_${resourceGroupResources.outputs.keyVaultKeyName}_${last(split(resourceGroupResources.outputs.keyVaultEncryptionKeyUrl, '/'))}'
        serverKeyType: 'AzureKeyVault'
        uri: resourceGroupResources.outputs.keyVaultEncryptionKeyUrl
      }
    ]
    licenseType: 'LicenseIncluded'
    lock: 'CanNotDelete'
    primaryUserAssignedIdentityId: resourceGroupResources.outputs.managedIdentityResourceId
    proxyOverride: 'Proxy'
    publicDataEndpointEnabled: false
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalIds: [
          resourceGroupResources.outputs.managedIdentityPrincipalId
        ]
      }
    ]
    securityAlertPoliciesObj: {
      emailAccountAdmins: true
      name: 'default'
      state: 'Enabled'
    }
    servicePrincipal: 'SystemAssigned'
    skuName: 'GP_Gen5'
    skuTier: 'GeneralPurpose'
    storageSizeInGB: 32
    systemAssignedIdentity: true
    timezoneId: 'UTC'
    userAssignedIdentities: {
      '${resourceGroupResources.outputs.managedIdentityResourceId}': {}
    }
    vCores: 4
    vulnerabilityAssessmentsObj: {
      emailSubscriptionAdmins: true
      name: 'default'
      recurringScansEmails: [
        'test1@contoso.com'
        'test2@contoso.com'
      ]
      recurringScansIsEnabled: true
      vulnerabilityAssessmentsStorageAccountId: diagnosticDependencies.outputs.storageAccountResourceId
    }
  }
}
