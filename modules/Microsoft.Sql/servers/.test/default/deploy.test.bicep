targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //
@description('Optional. The name of the resource group to deploy for a testing purposes')
@maxLength(90)
param resourceGroupName string = 'ms.sql.servers-${serviceShort}-rg'

@description('Optional. The location to deploy resources to')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints')
param serviceShort string = 'sqldef'

@description('Optional. The password to leverage for the login.')
@secure()
param password string = newGuid()

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
    managedIdentityName: 'dep-<<namePrefix>>-msi-${serviceShort}'
    virtualNetworkName: 'adp-<<namePrefix>>-vnet-${serviceShort}'
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
  name: '${uniqueString(deployment().name)}-test-${serviceShort}'
  params: {
    name: '<<namePrefix>>-${serviceShort}'
    lock: 'CanNotDelete'
    administratorLogin: 'adminUserName'
    administratorLoginPassword: password
    location: location
    minimalTlsVersion: '1.2'
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalIds: [
          resourceGroupResources.outputs.managedIdentityPrincipalId
        ]
      }
    ]
    vulnerabilityAssessmentsObj: {
      name: 'default'
      emailSubscriptionAdmins: true
      recurringScansIsEnabled: true
      recurringScansEmails: [
        'test1@contoso.com'
        'test2@contoso.com'
      ]
      vulnerabilityAssessmentsStorageAccountId: diagnosticDependencies.outputs.storageAccountResourceId
    }
    databases: [
      {
        name: '<<namePrefix>>-${serviceShort}db-001'
        collation: 'SQL_Latin1_General_CP1_CI_AS'
        skuTier: 'BusinessCritical'
        skuName: 'BC_Gen5'
        skuCapacity: 12
        skuFamily: 'Gen5'
        maxSizeBytes: 34359738368
        licenseType: 'LicenseIncluded'
        diagnosticLogsRetentionInDays: 7
        diagnosticStorageAccountId: diagnosticDependencies.outputs.storageAccountResourceId
        diagnosticWorkspaceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
        diagnosticEventHubAuthorizationRuleId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
        diagnosticEventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
      }
    ]
    firewallRules: [
      {
        name: 'AllowAllWindowsAzureIps'
        endIpAddress: '0.0.0.0'
        startIpAddress: '0.0.0.0'
      }
    ]
    securityAlertPolicies: [
      {
        name: 'Default'
        state: 'Enabled'
        emailAccountAdmins: true
      }
    ]
    systemAssignedIdentity: true
    userAssignedIdentities: {
      '${resourceGroupResources.outputs.managedIdentitResourceId}': {}
    }
    privateEndpoints: [
      {
        subnetResourceId: resourceGroupResources.outputs.privateEndpointSubnetResourceId
        service: 'sqlServer'
      }
    ]
  }
}
