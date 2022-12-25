targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //
@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'ms.devtestlab.labs-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'dtlnet'

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
    virtualNetworkName: 'dep-carml-vnet-${serviceShort}'
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
    name: 'carml${serviceShort}001'
    systemAssignedIdentity: true
    vmCreationResourceGroupId: resourceGroup.id
    browserConnect: 'Enabled'
    disableAutoUpgradeCseMinorVersion: true
    isolateLabResources: 'Enabled'
    premiumDataDisks: 'Enabled'
    virtualNetworks: [
      {
        name: resourceGroupResources.outputs.virtualNetworkName
        externalProviderResourceId: resourceGroupResources.outputs.virtualNetworkResourceId
        description: 'lab virtual network description'
        allowedSubnets: [
          {
            labSubnetName: resourceGroupResources.outputs.subnetName
            resourceId: resourceGroupResources.outputs.subnetResourceId
            allowPublicIp: 'Allow'
          }
        ]
        subnetOverrides: [
          {
            labSubnetName: resourceGroupResources.outputs.subnetName
            resourceId: resourceGroupResources.outputs.subnetResourceId
            useInVmCreationPermission: 'Allow'
            usePublicIpAddressPermission: 'Allow'
            sharedPublicIpAddressConfiguration: {
              allowedPorts: [
                {
                  transportProtocol: 'Tcp'
                  backendPort: 3389
                }
                {
                  transportProtocol: 'Tcp'
                  backendPort: 22
                }
              ]
            }
          }
        ]
      }
    ]
  }
}
