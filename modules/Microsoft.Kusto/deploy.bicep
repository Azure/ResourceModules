// ================ //
// Parameters       //
// ================ //
@description('Required. Name of the azure data explorer cluster. Must be globally unique.')
@minLength(4)
@maxLength(22)
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Required. SKU of the cluster.')
param sku object = {}

@description('Required. User managed identity resource id.')
param userManagedIdentityResourceId string

@description('Required. Key name.')
param keyName string

@description('Required. Key vault uri.')
param keyVaultUri string

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionName\' and \'principalId\' to define RBAC role assignments on this resource. ')
param roleAssignments array = []

@description('Optional. Array of database objects that contain the \'name\' and \'location\' to define database on this resource. ')
param databases array = []

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = ''

@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints array = []

resource azureDataExplorer 'Microsoft.Kusto/clusters@2022-12-29' = {
  name: name
  location: location
  sku: {
    name: sku.name
    tier: sku.tier
    capacity: sku.capacity
  }
  tags: tags
  properties: {
    trustedExternalTenants: []
    enableDiskEncryption: true
    keyVaultProperties: {
      keyName: keyName
      keyVaultUri: keyVaultUri
      keyVersion: 'Latest'
      userIdentity: userManagedIdentityResourceId
    }
    enableStreamingIngest: false
    languageExtensions: {
      value: []
    }
    enablePurge: false
    enableDoubleEncryption: false
    engineType: 'V3'
    acceptedAudiences: []
    restrictOutboundNetworkAccess: 'Disabled'
    allowedFqdnList: []
    publicNetworkAccess: 'Disabled'
    allowedIpRangeList: []
    enableAutoStop: true
    publicIPType: 'IPv4'
  }
  zones: [
    '1'
    '3'
    '2'
  ]
  identity: {
    type: 'SystemAssigned, UserAssigned'
    userAssignedIdentities: {
      '${userManagedIdentityResourceId}': {
      }
    }
  }
}

output id string = azureDataExplorer.id

output location string = azureDataExplorer.location

output name string = azureDataExplorer.name

module azureDataExplorerCluster_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${deployment().name}-Rbac-${index}'
  params: {
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    role: roleAssignment.role
    resourceId: azureDataExplorer.id
  }
}]

module modADXDb 'databases/deploy.bicep' = [for (database, index) in databases: {
  name: '${deployment().name}-databases-${index}'
  params: {
    name: database.name
    location: azureDataExplorer.location
    clusterName: azureDataExplorer.name
    softDeletePeriod: database.softDeletePeriod
    hotCachePeriod: database.hotCachePeriod
  }
}]

module azureDataExplorerCluster_privateEndpoints '../Microsoft.Network/privateEndpoints/deploy.bicep' = [for (privateEndpoint, index) in privateEndpoints: {
  name: '${uniqueString(deployment().name, location)}-adx-PE-${index}'
  params: {
    groupIds: [
      privateEndpoint.service
    ]
    name: contains(privateEndpoint, 'name') ? privateEndpoint.name : 'pe-${last(split(azureDataExplorer.id, '/'))}-${privateEndpoint.service}-${index}'
    serviceResourceId: azureDataExplorer.id
    subnetResourceId: privateEndpoint.subnetResourceId
    enableDefaultTelemetry: false
    location: reference(split(privateEndpoint.subnetResourceId, '/subnets/')[0], '2020-06-01', 'Full').location
    lock: contains(privateEndpoint, 'lock') ? privateEndpoint.lock : lock
    privateDnsZoneGroup: contains(privateEndpoint, 'privateDnsZoneGroup') ? privateEndpoint.privateDnsZoneGroup : {}
    roleAssignments: contains(privateEndpoint, 'roleAssignments') ? privateEndpoint.roleAssignments : []
    tags: contains(privateEndpoint, 'tags') ? privateEndpoint.tags : {}
    manualPrivateLinkServiceConnections: contains(privateEndpoint, 'manualPrivateLinkServiceConnections') ? privateEndpoint.manualPrivateLinkServiceConnections : []
    customDnsConfigs: contains(privateEndpoint, 'customDnsConfigs') ? privateEndpoint.customDnsConfigs : []
    ipConfigurations: contains(privateEndpoint, 'ipConfigurations') ? privateEndpoint.ipConfigurations : []
    applicationSecurityGroups: contains(privateEndpoint, 'applicationSecurityGroups') ? privateEndpoint.applicationSecurityGroups : []
    customNetworkInterfaceName: contains(privateEndpoint, 'customNetworkInterfaceName') ? privateEndpoint.customNetworkInterfaceName : ''
  }
}]
