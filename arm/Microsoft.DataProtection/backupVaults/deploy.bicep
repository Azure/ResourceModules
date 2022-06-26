@description('Required. Name of the Backup Vault.')
param name string

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = ''

@description('Optional. Enables system assigned managed identity on the resource.')
param systemAssignedIdentity bool = false

@description('Optional. The ID(s) to assign to the resource.')
param userAssignedIdentities object = {}

@description('Optional. Tags of the Recovery Service Vault resource.')
param tags object = {}

@description('Optional. The datastore type to use.')
@allowed([
  'ArchiveStore'
  'SnapshotStore'
  'VaultStore'
])
param dataStoreType string = 'SnapshotStore'

@description('Optional. The vault redundancy level to use.')
@allowed([
  'LocallyRedundant'
  'GeoRedundant'
])
param type string = 'LocallyRedundant'

@description('Optional. List of all backup policies.')
param backupPolicies array = []

var identityType = systemAssignedIdentity ? (!empty(userAssignedIdentities) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned') : (!empty(userAssignedIdentities) ? 'UserAssigned' : 'None')

var identity = identityType != 'None' ? {
  type: identityType
  userAssignedIdentities: !empty(userAssignedIdentities) ? userAssignedIdentities : null
} : null

var enableReferencedModulesTelemetry = false

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name, location)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource backupVault 'Microsoft.DataProtection/backupVaults@2022-03-01' = {
  name: name
  location: location
  tags: tags
  identity: any(identity)
  properties: {
    storageSettings: [
      {
        type: type
        datastoreType: dataStoreType
      }
    ]
  }
}

module backupVault_backupPolicies 'backupPolicies/deploy.bicep' = [for (backupPolicy, index) in backupPolicies: {
  name: '${uniqueString(deployment().name, location)}-BV-BackupPolicy-${index}'
  params: {
    backupVaultName: backupVault.name
    name: backupPolicy.name
    properties: backupPolicy.properties
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

resource backupVault_lock 'Microsoft.Authorization/locks@2017-04-01' = if (!empty(lock)) {
  name: '${backupVault.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: backupVault
}

module backupVault_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-bv-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    resourceId: backupVault.id
  }
}]

@description('The resource ID of the backup vault.')
output resourceId string = backupVault.id

@description('The name of the resource group the recovery services vault was created in.')
output resourceGroupName string = resourceGroup().name

@description('The Name of the backup vault.')
output name string = backupVault.name

@description('The principal ID of the system assigned identity.')
output systemAssignedPrincipalId string = systemAssignedIdentity && contains(backupVault.identity, 'principalId') ? backupVault.identity.principalId : ''

@description('The location the resource was deployed into.')
output location string = backupVault.location
