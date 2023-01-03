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
param serviceShort string = 'vmiitcom'

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
    enableDefaultTelemetry: enableDefaultTelemetry
    name: '<<namePrefix>>${serviceShort}001'
    customizationSteps: [
      {
        restartTimeout: '15m'
        type: 'WindowsRestart'
      }
    ]
    imageSource: {
      offer: 'Windows-10'
      publisher: 'MicrosoftWindowsDesktop'
      sku: 'win10-22h2-avd'
      type: 'PlatformImage'
      version: 'latest'
    }
    buildTimeoutInMinutes: 120
    imageReplicationRegions: []
    lock: 'CanNotDelete'
    managedImageName: ''
    osDiskSizeGB: 127
    roleAssignments: []
    sigImageDefinitionId: resourceGroupResources.outputs.sigImageDefinitionId
    subnetId: ''
    unManagedImageName: ''
    userMsiName: resourceGroupResources.outputs.managedIdentityName
    userMsiResourceGroup: resourceGroupName
    vmSize: 'Standard_D2s_v3'
  }
}
