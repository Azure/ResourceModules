targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //
@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'ms.network.vpngateways-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'nvgcom'

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
    virtualHubName: 'dep-<<namePrefix>>-vh-${serviceShort}'
    virtualWANName: 'dep-<<namePrefix>>-vw-${serviceShort}'
    vpnSiteName: 'dep-<<namePrefix>>-vs-${serviceShort}'
  }
}

// ============== //
// Test Execution //
// ============== //
var vHubResourceId = '/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup.name}/providers/Microsoft.Network/virtualHubs/<<namePrefix>>${serviceShort}001'
module testDeployment '../../deploy.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name)}-test-${serviceShort}'
  params: {
    name: '<<namePrefix>>${serviceShort}001'
    virtualHubResourceId: resourceGroupResources.outputs.virtualHubResourceId
    bgpSettings: {
      asn: 65515
      peerWeight: 0
    }
    connections: [
      {
        connectionBandwidth: 100
        enableBgp: false
        name: 'Connection-dep-<<namePrefix>>-vs-${serviceShort}'
        remoteVpnSiteResourceId: resourceGroupResources.outputs.vpnSiteResourceId
        enableInternetSecurity: true
        vpnConnectionProtocolType: 'IKEv2'
        enableRateLimiting: false
        useLocalAzureIpAddress: false
        usePolicyBasedTrafficSelectors: false
        routingWeight: 0
        // routingConfiguration: {
        //   associatedRouteTable: {
        //     id: '${vHubResourceId}/hubRouteTables/defaultRouteTable'
        //   }
        //   propagatedRouteTables: {
        //     ids: [
        //       {
        //         id: '${vHubResourceId}/hubRouteTables/defaultRouteTable'
        //       }
        //     ]
        //     labels: [
        //       'default'
        //     ]
        //   }
        //   vnetRoutes: {
        //     staticRoutes: []
        //   }
        // }
        // vpnLinkConnections: [
        //   {
        //     name: last(split(resourceGroupResources.outputs.vpnSiteLink1ResourceId, '/'))
        //     id: resourceGroupResources.outputs.vpnSiteLink1ResourceId
        //   }
        //   {
        //     name: last(split(resourceGroupResources.outputs.vpnSiteLink2ResourceId, '/'))
        //     id: resourceGroupResources.outputs.vpnSiteLink2ResourceId
        //   }
        // ]
      }
    ]
    lock: 'CanNotDelete'
    natRules: [
      {
        externalMappings: [
          {
            addressSpace: '192.168.21.0/24'
          }
        ]
        internalMappings: [
          {
            addressSpace: '10.4.0.0/24'
          }
        ]
        mode: 'EgressSnat'
        name: 'natRule1'
        type: 'Static'
      }
    ]
  }
}
