@description('Required. Name of the resource.')
param name string

@allowed([
  'C0'
  'F0'
  'S1'
])
@description('Required. The name of the Azure Health Bot SKU.')
param sku string

@description('Optional. The ID(s) to assign to the resource.')
param userAssignedIdentities object = {}

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. The name of the customer managed key to use for encryption.')
param cMKKeyName string = ''

@description('Conditional. The resource ID of a key vault to reference a customer managed key for encryption from. Required if \'cMKKeyName\' is not empty.')
param cMKKeyVaultResourceId string = ''

@description('Conditional. User assigned identity to use when fetching the customer managed key. Required if \'cMKKeyName\' is not empty.')
param cMKUserAssignedIdentityResourceId string = ''

@description('Optional. The version of the customer managed key to reference for encryption. If not provided, latest is used.')
param cMKKeyVersion string = ''

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = ''

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

var identityType = !empty(userAssignedIdentities) ? 'UserAssigned' : 'None'

var identity = identityType != 'None' ? {
  type: identityType
  userAssignedIdentities: !empty(userAssignedIdentities) ? userAssignedIdentities : null
} : null

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

resource cMKUserAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' existing = if (!empty(cMKUserAssignedIdentityResourceId)) {
  name: last(split(cMKUserAssignedIdentityResourceId, '/'))!
  scope: resourceGroup(split(cMKUserAssignedIdentityResourceId, '/')[2], split(cMKUserAssignedIdentityResourceId, '/')[4])
}

resource cMKKeyVault 'Microsoft.KeyVault/vaults@2023-02-01' existing = if (!empty(cMKKeyVaultResourceId)) {
  name: last(split(cMKKeyVaultResourceId, '/'))!
  scope: resourceGroup(split(cMKKeyVaultResourceId, '/')[2], split(cMKKeyVaultResourceId, '/')[4])

  resource cMKKey 'keys@2023-02-01' existing = if (!empty(cMKKeyName)) {
    name: cMKKeyName
  }
}

resource azureHealthBot 'Microsoft.HealthBot/healthBots@2022-08-08' = {
  name: name
  location: location
  tags: tags
  identity: identity
  sku: {
    name: sku
  }
  properties: {
    keyVaultProperties: !empty(cMKKeyName) ? {
      keyName: cMKKeyName
      keyVaultUri: cMKKeyVault.properties.vaultUri
      keyVersion: !empty(cMKKeyVersion) ? cMKKeyVersion : last(split(cMKKeyVault::cMKKey.properties.keyUriWithVersion, '/'))
      userIdentity: cMKUserAssignedIdentity.id
    } : null
  }
}

resource azureHealthBot_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock)) {
  name: '${azureHealthBot.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: azureHealthBot
}

module healthBot_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-HealthBot-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: azureHealthBot.id
  }
}]

@description('The resource group the health bot was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The name of the health bot.')
output name string = azureHealthBot.name

@description('The resource ID of the health bot.')
output resourceId string = azureHealthBot.id

@description('The location the resource was deployed into.')
output location string = azureHealthBot.location
