@description('Required. Administrator username for the server.')
param administratorLogin string

@description('Required. The administrator login password.')
@secure()
param administratorLoginPassword string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Required. The name of the server.')
param name string

@description('Optional. Whether or not ADS should be enabled.')
param enableADS bool = false

@description('Required. Whether or not Azure IP\'s are allowed.')
param allowAzureIps bool = false

@allowed([
  'CanNotDelete'
  'NotSpecified'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = 'NotSpecified'

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

@description('Optional. The databases to create in the server')
param databases array = []

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource server 'Microsoft.Sql/servers@2020-02-02-preview' = {
  location: location
  name: name
  tags: tags
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    version: '12.0'
  }

  resource server_AllowAllWindowsAzureIps 'firewallrules@2021-02-01-preview' = if (allowAzureIps) {
    name: 'AllowAllWindowsAzureIps'
    properties: {
      endIpAddress: '0.0.0.0'
      startIpAddress: '0.0.0.0'
    }
  }

  resource server_Default 'securityAlertPolicies@2021-02-01-preview' = if (enableADS) {
    name: 'Default'
    properties: {
      state: 'Enabled'
      disabledAlerts: []
      emailAddresses: []
      emailAccountAdmins: true
    }
  }
}

resource server_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lock != 'NotSpecified') {
  name: '${server.name}-${lock}-lock'
  properties: {
    level: lock
    notes: (lock == 'CanNotDelete') ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: server
}

module server_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${deployment().name}-rbac-${index}'
  params: {
    roleAssignmentObj: roleAssignment
    resourceName: server.name
  }
}]

module server_databases 'databases/deploy.bicep' = [for (database, index) in databases: {
  name: '${deployment().name}-db-${index}'
  params: {
    name: database.name
    serverName: server.name
    maxSizeBytes: database.maxSizeBytes
    tier: database.tier
    skuName: database.skuName
    collation: database.collation
    autoPauseDelay: contains(database, 'autoPauseDelay') ? database.autoPauseDelay : ''
    isLedgerOn: contains(database, 'isLedgerOn') ? database.isLedgerOn : false
    location: contains(database, 'location') ? database.location : server.location
    licenseType: contains(database, 'licenseType') ? database.licenseType : ''
    maintenanceConfigurationId: contains(database, 'maintenanceConfigurationId') ? database.maintenanceConfigurationId : ''
    minCapacity: contains(database, 'minCapacity') ? database.minCapacity : ''
    highAvailabilityReplicaCount: contains(database, 'highAvailabilityReplicaCount') ? database.highAvailabilityReplicaCount : 0
    readScale: contains(database, 'readScale') ? database.readScale : 'Disabled'
    requestedBackupStorageRedundancy: contains(database, 'requestedBackupStorageRedundancy') ? database.requestedBackupStorageRedundancy : ''
    sampleName: contains(database, 'sampleName') ? database.sampleName : ''
    tags: contains(database, 'tags') ? database.tags : {}
    zoneRedundant: contains(database, 'zoneRedundant') ? database.zoneRedundant : false
  }
}]

@description('The name of the deployed SQL server')
output serverName string = server.name

@description('The resourceId of the deployed SQL server')
output serverResourceId string = server.id

@description('The resourceGroup of the deployed SQL server')
output serverResourceGroup string = resourceGroup().name
