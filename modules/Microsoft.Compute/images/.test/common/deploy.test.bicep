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
    managedIdentityName: 'dep-<<namePrefix>>-msi-${serviceShort}'
    storageAccountName: 'dep<<namePrefix>>sa${serviceShort}01'
  }
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(subscription().subscriptionId, 'Contributor', 'dep-<<namePrefix>>-msi-imgcom')
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
    triggerImageDeploymentScriptName: 'dep-<<namePrefix>>-ds-${serviceShort}-triggerImageTemplate'
    imageTemplateNamePrefix: 'dep-<<namePrefix>>-imgt-${serviceShort}'
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
    osDiskBlobUri: 'https://adp<<namePrefix>>azsavhd001.blob.core.windows.net/vhds/adp-<<namePrefix>>-az-imgt-vhd-001.vhd'
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
