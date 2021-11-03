param serviceFabricClusterName string
param location string
param tags object

var vmNodeType0Name = 'nodevm'

resource supportLogStorageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  kind: 'Storage'
  location: location
  name: 'suprtlogstrg01'
  sku: {
    name: 'Standard_LRS'
  }
  tags: tags
}

resource applicationDiagnosticsStorageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  kind: 'Storage'
  location: location
  name: 'appdiagstrg01'
  sku: {
    name: 'Standard_LRS'
  }
  tags: tags
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-03-01' = {
  location: location
  name: 'vnet-01'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'subnet-01'
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
    ]
  }
  tags: tags
}

resource loadBalancerPublicIPAddress 'Microsoft.Network/publicIPAddresses@2021-03-01' = {
  name: 'ServiceFabricLBPIP'
  location: location
  properties: {
    dnsSettings: {
      domainNameLabel: serviceFabricClusterName
    }
    publicIPAllocationMethod: 'Dynamic'
  }
  tags: tags
}

resource loadBalancer 'Microsoft.Network/loadBalancers@2021-03-01' = {
  name: 'ServiceFabricLB'
  location: location
  properties: {
    frontendIPConfigurations: [
      {
        name: 'LoadBalancerIPConfig'
        properties: {
          publicIPAddress: {
            id: loadBalancerPublicIPAddress.id
          }
        }
      }
    ]
    backendAddressPools: [
      {
        name: 'LoadBalancerBEAddressPool'
        properties: {}
      }
    ]
    loadBalancingRules: [
      {
        name: 'LBRule'
        properties: {
          backendAddressPool: {
            id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', 'LB-${serviceFabricClusterName}-${vmNodeType0Name}', 'LoadBalancerBEAddressPool')
          }
          backendPort: 19000
          enableFloatingIP: true
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', 'LB-${serviceFabricClusterName}-${vmNodeType0Name}', 'LoadBalancerIPConfig')
          }
          frontendPort: 19000
          idleTimeoutInMinutes: 5
          probe: {
            id: resourceId('Microsoft.Network/loadBalancers/probes', 'LB-${serviceFabricClusterName}-${vmNodeType0Name}', 'FabricGatewayProbe')
          }
          protocol: 'Tcp'
        }
      }
      {
        name: 'LBHttpRule'
        properties: {
          backendAddressPool: {
            id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', 'LB-${serviceFabricClusterName}-${vmNodeType0Name}', 'LoadBalancerBEAddressPool')
          }
          backendPort: 19080
          enableFloatingIP: false
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', 'LB-${serviceFabricClusterName}-${vmNodeType0Name}', 'LoadBalancerIPConfig')
          }
          frontendPort: 19080
          idleTimeoutInMinutes: 5
          probe: {
            id: resourceId('Microsoft.Network/loadBalancers/probes', 'LB-${serviceFabricClusterName}-${vmNodeType0Name}', 'FabricHttpGatewayProbe')
          }
          protocol: 'Tcp'
        }
      }
      {
        name: 'AppPortLBRule1'
        properties: {
          backendAddressPool: {
            id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', 'LB-${serviceFabricClusterName}-${vmNodeType0Name}', 'LoadBalancerBEAddressPool')
          }
          backendPort: 80
          enableFloatingIP: false
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', 'LB-${serviceFabricClusterName}-${vmNodeType0Name}', 'LoadBalancerIPConfig')
          }
          frontendPort: 80
          idleTimeoutInMinutes: 5
          probe: {
            id: resourceId('Microsoft.Network/loadBalancers/probes', 'LB-${serviceFabricClusterName}-${vmNodeType0Name}', 'AppPortProbe1')
          }
          protocol: 'Tcp'
        }
      }
      {
        name: 'AppPortLBRule2'
        properties: {
          backendAddressPool: {
            id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', 'LB-${serviceFabricClusterName}-${vmNodeType0Name}', 'LoadBalancerBEAddressPool')
          }
          backendPort: 8081
          enableFloatingIP: false
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', 'LB-${serviceFabricClusterName}-${vmNodeType0Name}', 'LoadBalancerIPConfig')
          }
          frontendPort: 8081
          idleTimeoutInMinutes: 5
          probe: {
            id: resourceId('Microsoft.Network/loadBalancers/probes', 'LB-${serviceFabricClusterName}-${vmNodeType0Name}', 'AppPortProbe2')
          }
          protocol: 'Tcp'
        }
      }
    ]
    probes: [
      {
        name: 'FabricGatewayProbe'
        properties: {
          port: 19000
          protocol: 'Tcp'
          intervalInSeconds: 5
          numberOfProbes: 2
        }
      }
      {
        name: 'FabricHttpGatewayProbe'
        properties: {
          port: 19080
          protocol: 'Tcp'
          intervalInSeconds: 5
          numberOfProbes: 2
        }
      }
      {
        name: 'AppPortProbe1'
        properties: {
          port: 80
          protocol: 'Tcp'
          intervalInSeconds: 5
          numberOfProbes: 2
        }
      }
      {
        name: 'AppPortProbe2'
        properties: {
          port: 8081
          protocol: 'Tcp'
          intervalInSeconds: 5
          numberOfProbes: 2
        }
      }
    ]
    inboundNatPools: [
      {
        name: 'LoadBalancerBEAddressNatPool'
        properties: {
          backendPort: 22
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', 'LB-${serviceFabricClusterName}-${vmNodeType0Name}', 'LoadBalancerIPConfig')
          }
          frontendPortRangeEnd: 4500
          frontendPortRangeStart: 3389
          protocol: 'Tcp'
        }
      }
    ]
  }
  tags: tags
  dependsOn: [
    loadBalancerPublicIPAddress
  ]
}
