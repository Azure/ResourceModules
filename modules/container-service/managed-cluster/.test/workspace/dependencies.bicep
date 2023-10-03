@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Kubelet Identity Managed Identity to create.')
param managedIdentityKubeletIdentityName string

@description('Required. The name of the DNS Zone to create.')
param dnsZoneName string

@description('Required. The name of the monitoring workspace to create.')
param monitoringWorkspaceName string

var addressPrefix = '10.1.0.0/22'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-04-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: map(range(0, 3), i => {
        name: 'subnet-${i}'
        properties: {
          addressPrefix: cidrSubnet(addressPrefix, 24, i)
        }
      })
  }
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
  location: location
}

resource monitoringWorkspace 'Microsoft.Monitor/accounts@2023-04-03' = {
  name: monitoringWorkspaceName
  location: location
}

@description('The resource ID of the created Virtual Network Subnet.')
output subnetResourceIds array = [
  virtualNetwork.properties.subnets[0].id
  virtualNetwork.properties.subnets[1].id
  virtualNetwork.properties.subnets[2].id
]

resource dnsZone 'Microsoft.Network/dnsZones@2018-05-01' = {
  name: dnsZoneName
  location: 'global'
}

resource managedIdentityKubeletIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityKubeletIdentityName
  location: location
}

resource roleAssignmentKubeletIdentity 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('msi-${location}-${managedIdentityKubeletIdentity.id}-ManagedIdentityOperator-RoleAssignment')
  scope: managedIdentityKubeletIdentity
  properties: {
    principalId: managedIdentity.properties.principalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f1a07417-d97a-45cb-824c-7a7467783830') // Managed Identity Operator Role used for Kubelet identity.
    principalType: 'ServicePrincipal'
  }
}

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the created Managed Identity.')
output managedIdentityResourceId string = managedIdentity.id

@description('The resource ID of the created Kubelet Identity Managed Identity.')
output managedIdentityKubeletIdentityResourceId string = managedIdentityKubeletIdentity.id

@description('The resource ID of the created DNS Zone.')
output dnsZoneResourceId string = dnsZone.id

@description('The resource ID of the created Log Analytics Workspace.')
output workspaceResourceId string = monitoringWorkspace.id
