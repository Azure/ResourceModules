targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //
@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'ms.virtualmachineimages.imagetemplates-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'vmicom'

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
    managedIdentityName: 'dep-<<namePrefix>>-msi-${serviceShort}'
    sigImageDefinitionName: 'dep-<<namePrefix>>-imgd-${serviceShort}'
    galleryName: 'dep<<namePrefix>>sig${serviceShort}'
  }
}


// ============== //
// Test Execution //
// ============== //

module testDeployment '../../deploy.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name)}-test-${serviceShort}'
  params: {
    name: '<<namePrefix>>${serviceShort}001'
    customizationSteps: [
      {
        restartTimeout: '30m'
        type: 'WindowsRestart'
      }
    ]
    imageSource: {
      offer: 'Windows-10'
      publisher: 'MicrosoftWindowsDesktop'
      sku: '19h2-evd'
      type: 'PlatformImage'
      version: 'latest'
    }
    userMsiName: resourceGroupResources.outputs.managedIdentityName
    buildTimeoutInMinutes: 0
    imageReplicationRegions: []
    lock: 'CanNotDelete'
    managedImageName: '<<namePrefix>>-az-mi-x-${serviceShort}-001'
    osDiskSizeGB: 127
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Contributor'
        principalIds: [
          resourceGroupResources.outputs.managedIdentityPrincipalId
        ]
      }
    ]
    sigImageDefinitionId: resourceGroupResources.outputs.sigImageDefinitionId
    subnetId: ''
    unManagedImageName: '<<namePrefix>>-az-umi-x-${serviceShort}-001'
    userMsiResourceGroup: resourceGroupName
    vmSize: 'Standard_D2s_v3'
  }
}
