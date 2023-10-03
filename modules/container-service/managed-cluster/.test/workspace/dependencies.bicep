@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the DNS Zone to create.')
param dnsZoneName string

@description('Required. The name of the monitoring workspace to create.')
param monitoringWorkspaceName string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
  location: location
}

resource monitoringWorkspace 'Microsoft.Monitor/accounts@2023-04-03' = {
  name: monitoringWorkspaceName
  location: location
}

resource dnsZone 'Microsoft.Network/dnsZones@2018-05-01' = {
  name: dnsZoneName
  location: 'global'
}

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the created Managed Identity.')
output managedIdentityResourceId string = managedIdentity.id

@description('The resource ID of the created DNS Zone.')
output dnsZoneResourceId string = dnsZone.id

@description('The resource ID of the created Log Analytics Workspace.')
output workspaceResourceId string = monitoringWorkspace.id
