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
param serviceShort string = 'vmitadv'

@description('Optional. The version of the Azure Compute Gallery Image Definition to be added.')
param sigImageVersion string = utcNow('yyyy.MM.dd')

@description('Optional. The staging resource group name in the same location and subscription as the image template. Must not exist.')
param stagingResourceGroupName string = 'ms.virtualmachineimages.imagetemplates-${serviceShort}-staging-rg'

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
  name: '${uniqueString(resourceGroupName, location)}-paramNested'
  params: {
    managedIdentityName: 'dep-<<namePrefix>>-msi-${serviceShort}'
    sigImageDefinitionName: 'dep-<<namePrefix>>-imgd-${serviceShort}'
    galleryName: 'dep<<namePrefix>>sig${serviceShort}'
    virtualNetworkName: 'dep<<namePrefix>>-vnet-${serviceShort}'
  }
}

// required for the Azure Image Builder service to assign the list of User Assigned Identities to the Build VM.
resource msi_managedIdentityOperatorRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(subscription().id, 'ManagedIdentityContributor', '<<namePrefix>>')
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f1a07417-d97a-45cb-824c-7a7467783830') // Managed Identity Operator
    principalId: resourceGroupResources.outputs.managedIdentityPrincipalId
    principalType: 'ServicePrincipal'
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
    name: '<<namePrefix>>${serviceShort}001'
    customizationSteps: [
      {
        restartTimeout: '10m'
        type: 'WindowsRestart'
      }
    ]
    imageSource: {
      offer: 'Windows-11'
      publisher: 'MicrosoftWindowsDesktop'
      sku: 'win11-22h2-avd'
      type: 'PlatformImage'
      version: 'latest'
    }
    buildTimeoutInMinutes: 60
    imageReplicationRegions: []
    lock: 'CanNotDelete'
    osDiskSizeGB: 127
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalIds: [
          resourceGroupResources.outputs.managedIdentityPrincipalId
        ]
        principalType: 'ServicePrincipal'
      }
    ]
    sigImageDefinitionId: resourceGroupResources.outputs.sigImageDefinitionId
    sigImageVersion: sigImageVersion
    subnetId: resourceGroupResources.outputs.subnetId
    stagingResourceGroup: '${subscription().id}/resourcegroups/${stagingResourceGroupName}'
    unManagedImageName: '<<namePrefix>>-umi-${serviceShort}-001'
    userMsiName: resourceGroupResources.outputs.managedIdentityName
    userMsiResourceGroup: resourceGroupName
    vmUserAssignedIdentities: [
      resourceGroupResources.outputs.managedIdentityResourceId
    ]
    vmSize: 'Standard_D2s_v3'
  }
}
