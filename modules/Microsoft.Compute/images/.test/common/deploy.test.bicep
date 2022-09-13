targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for a testing purposes')
@maxLength(90)
param resourceGroupName string = 'ms.compute.images-${serviceShort}-rg'

@description('Optional. The location to deploy resources to')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints')
param serviceShort string = 'imgcom'

// TODO: discuss the following challenge: roleassignment must be a globally unique identifier (GUID). The GUID is normally generated with role + scope + identity.
// Identity in this case is the MSI deployed in the resourceGroupResources01 module. We cannot get that as output since the resource name requires a value that can be calculated at the start of the deployment.
// Using the msi name as a workaround. Creating var in order not to duplicate its value (roleAssignment guid + input for resourceGroupResources01 module).
// Same for destinationStorageAccountName. Creating other vars for consistency.

// ========= //
// Variables //
// ========= //

var managedIdentityName = 'dep-<<namePrefix>>-msi-${serviceShort}'
var destinationStorageAccountName = 'dep<<namePrefix>>sa${serviceShort}01'
var imageTemplateNamePrefix = 'dep-<<namePrefix>>-imgt-${serviceShort}'
var triggerImageDeploymentScriptName = 'dep-<<namePrefix>>-ds-${serviceShort}-triggerImageTemplate'
var copyVhdDeploymentScriptName = 'dep-<<namePrefix>>-ds-${serviceShort}-copyVhdToStorage'

// =========== //
// Deployments //
// =========== //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

module resourceGroupResources01 'dependencies01.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-paramNested01'
  params: {
    managedIdentityName: managedIdentityName
    storageAccountName: destinationStorageAccountName
  }
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(subscription().subscriptionId, 'Contributor', managedIdentityName)
  properties: {
    roleDefinitionId: '/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'
    principalId: resourceGroupResources01.outputs.managedIdentityPrincipalId
  }
}

module resourceGroupResources02 'dependencies02.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-paramNested02'
  params: {
    managedIdentityResourceId: resourceGroupResources01.outputs.managedIdentityResourceId
    imageTemplateNamePrefix: imageTemplateNamePrefix
    triggerImageDeploymentScriptName: triggerImageDeploymentScriptName
    copyVhdDeploymentScriptName: copyVhdDeploymentScriptName
    destinationStorageAccountName: destinationStorageAccountName
  }
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../deploy.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name)}-test-${serviceShort}'
  params: {
    // Required parameters
    name: '<<namePrefix>>${serviceShort}001'
    osAccountType: 'Premium_LRS'
    osDiskBlobUri: resourceGroupResources02.outputs.vhdUri
    osDiskCaching: 'ReadWrite'
    osType: 'Windows'
    // Non-required parameters
    hyperVGeneration: 'V1'
    roleAssignments: [
      {
        principalIds: [
          resourceGroupResources01.outputs.managedIdentityPrincipalId
        ]
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    zoneResilient: true
  }
}
