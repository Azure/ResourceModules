targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'ms.managedservices.registrationdefinitions-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'msrdrg'

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '<<namePrefix>>'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-${serviceShort}'
  params: {
    enableDefaultTelemetry: enableDefaultTelemetry
    name: 'Component Validation - ${namePrefix}${serviceShort} Resource group assignment'
    authorizations: [
      {
        principalId: '9740a11d-a508-4a83-8ed5-4cb5bff5154a'
        principalIdDisplayName: 'ResourceModules-Reader'
        roleDefinitionId: 'acdd72a7-3385-48ef-bd42-f606fba81ae7'
      }
      {
        principalId: '9bce07dd-ae3a-4062-a24d-33631a4b35e8'
        principalIdDisplayName: 'ResourceModules-Contributor'
        roleDefinitionId: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
      }
      {
        principalId: '441519e3-00e5-4070-8ec8-4b8cddf6409a'
        principalIdDisplayName: 'ResourceModules-LHManagement'
        roleDefinitionId: '91c1777a-f3dc-4fae-b103-61d183457e46'
      }
    ]
    managedByTenantId: '195ee85d-2f10-4764-8352-a3c99aa772fb'
    registrationDescription: 'Managed by Lighthouse'
    resourceGroupName: resourceGroup.name
  }
}
