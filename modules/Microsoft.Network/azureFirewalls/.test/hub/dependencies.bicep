@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

param virtualWanName string

param virtualHubName string

param firewallPolicyName string

resource virtualWan 'Microsoft.Network/virtualWans@2021-08-01' = {
  name: virtualWanName
  location: location
  properties: {
    disableVpnEncryption: false
    allowBranchToBranchTraffic: true
    type: 'Standard'
  }
}

resource virtualHub 'Microsoft.Network/virtualHubs@2021-08-01' = {
  name: virtualHubName
  location: location
  properties: {
    addressPrefix: '10.1.0.0/16'
    virtualWan: {
      id: virtualWan.id
    }
  }
}

resource policy 'Microsoft.Network/firewallPolicies@2021-08-01' = {
  name: firewallPolicyName
  location: location
  properties: {
    threatIntelMode: 'Alert'
  }
}

@description('The resource ID of the created Virtual Hub.')
output virtualHubResourceId string = virtualHub.id

@description('The resource ID of the created Firewall Policie.')
output firewallPolicyResourceId string = policy.id
