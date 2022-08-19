@description('Optional. The location to deploy to')
param location string = resourceGroup().location

@description('Required. The names of the VNET Gateways to create.')
param virtualNetworkGateways array

resource vnetGateways 'Microsoft.Network/virtualNetworkGateways@2021-08-01' = [for (virtualNetworkGateway, index) in virtualNetworkGateways: {
    name: virtualNetworkGateway
    properties: {
    }
}]
//   name: name
//   location: location
//   tags: tags
//   properties: {
//     ipConfigurations: ipConfiguration
//     activeActive: isActiveActiveValid
//     enableBgp: isBgpValid
//     bgpSettings: isBgpValid ? bgpSettings : null
//     sku: {
//       name: virtualNetworkGatewaySku
//       tier: virtualNetworkGatewaySku
//     }
//     gatewayType: virtualNetworkGatewayType
//     vpnType: vpnType_var
//     vpnClientConfiguration: !empty(vpnClientAddressPoolPrefix) ? vpnClientConfiguration : null
//   }
//   dependsOn: [
//     virtualGatewayPublicIP
//   ]
// }

@description('The resource ID of the created Virtual Network Gateways.')
output virtualNetworkGatewayResourceIds array = [for gateway in virtualNetworkGateways: az.resourceId('Microsoft.Network/virtualNetworkGateways', gateway)]
