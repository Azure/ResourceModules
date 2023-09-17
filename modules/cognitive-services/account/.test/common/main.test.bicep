targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'ms.cognitiveservices.accounts-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'csacom'

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '[[namePrefix]]'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: location
}

// module nestedDependencies 'dependencies.bicep' = {
//   scope: resourceGroup
//   name: '${uniqueString(deployment().name, location)}-nestedDependencies'
//   params: {
//     virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
//     managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
//   }
// }

// Diagnostics
// ===========
// module diagnosticDependencies '../../../../.shared/.templates/diagnostic.dependencies.bicep' = {
//   scope: resourceGroup
//   name: '${uniqueString(deployment().name, location)}-diagnosticDependencies'
//   params: {
//     storageAccountName: 'dep${namePrefix}diasa${serviceShort}01'
//     logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
//     eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}'
//     eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}'
//     location: location
//   }
// }

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../main.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-test-${serviceShort}'
  params: {
    enableDefaultTelemetry: enableDefaultTelemetry
    name: '${namePrefix}${serviceShort}001'
    kind: 'Face'
    customSubDomainName: '${namePrefix}xdomain'
    // diagnosticSettings: [
    //   {
    //     // logAnalyticsDestinationType:
    //     // marketplacePartnerResourceId:
    //     name: 'customSetting'
    //     metricCategories: [
    //       {
    //         category: 'AllMetrics'
    //       }
    //     ]
    //     logCategoriesAndGroups: [
    //       {
    //         category: 'RequestResponse'
    //       }
    //       {
    //         category: 'Audit'
    //       }
    //     ]
    //     eventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
    //     eventHubAuthorizationRuleResourceId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
    //     storageAccountResourceId: diagnosticDependencies.outputs.storageAccountResourceId
    //     workspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
    //   }
    //   {
    //     eventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
    //     eventHubAuthorizationRuleResourceId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
    //     storageAccountResourceId: diagnosticDependencies.outputs.storageAccountResourceId
    //     workspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
    //   }
    // ]
    //lock: 'CanNotDelete'
    networkAcls: {
      defaultAction: 'Deny'
      ipRules: [
        {
          value: '40.74.28.0/23'
        }
      ]
      virtualNetworkRules: [
        {
          // id: nestedDependencies.outputs.subnetResourceId
          id: '/subscriptions/[[subscriptionId]]/resourceGroups/ms.cognitiveservices.accounts-csacom-rg/providers/Microsoft.Network/virtualNetworks/dep-[[namePrefix]]-vnet-csacom/subnets/defaultSubnet'
          ignoreMissingVnetServiceEndpoint: false
        }
      ]
    }
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        // principalId: nestedDependencies.outputs.managedIdentityPrincipalId
        principalId: '3cd458fe-6c10-4208-b70a-d6aee16f7ea6'
        principalType: 'ServicePrincipal'
      }
    ]
    sku: 'S0'
    managedIdentities: {
      systemAssigned: true
      userAssignedResourcesIds: [
        // nestedDependencies.outputs.managedIdentityResourceId
        '/subscriptions/[[subscriptionId]]/resourceGroups/ms.cognitiveservices.accounts-csacom-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/dep-[[namePrefix]]-msi-csacom'
      ]
    }
    privateEndpoints: [
      {
        privateDnsZoneResourceIds: [
          // nestedDependencies.outputs.privateDNSZoneResourceId
          '/subscriptions/[[subscriptionId]]/resourceGroups/ms.cognitiveservices.accounts-csacom-rg/providers/Microsoft.Network/privateDnsZones/privatelink.cognitiveservices.azure.com'
        ]
        service: 'account'
        // subnetResourceId: nestedDependencies.outputs.subnetResourceId
        subnetResourceId: '/subscriptions/[[subscriptionId]]/resourceGroups/ms.cognitiveservices.accounts-csacom-rg/providers/Microsoft.Network/virtualNetworks/dep-[[namePrefix]]-vnet-csacom/subnets/defaultSubnet'
        tags: {
          'hidden-title': 'This is visible in the resource name'
          Environment: 'Non-Prod'
          Role: 'DeploymentValidation'
        }
      }
    ]
    tags: {
      'hidden-title': 'This is visible in the resource name'
      Environment: 'Non-Prod'
      Role: 'DeploymentValidation'
    }
  }
}
