@description('Required. The name of the disk encryption set that is being created.')
param name string

@description('Optional. Resource location.')
param location string = resourceGroup().location

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = ''

@description('Required. Resource ID of the KeyVault containing the key or secret.')
param keyVaultResourceId string

@description('Required. Key URL (with version) pointing to a key or secret in KeyVault.')
param keyName string

@description('Optional. The version of the customer managed key to reference for encryption. If not provided, the latest key version is used.')
param keyVersion string = ''

@description('Optional. The type of key used to encrypt the data of the disk. For security reasons, it is recommended to set encryptionType to EncryptionAtRestWithPlatformAndCustomerKeys.')
@allowed([
  'EncryptionAtRestWithCustomerKey'
  'EncryptionAtRestWithPlatformAndCustomerKeys'
])
param encryptionType string = 'EncryptionAtRestWithPlatformAndCustomerKeys'

@description('Optional. Multi-tenant application client ID to access key vault in a different tenant. Setting the value to "None" will clear the property.')
param federatedClientId string = 'None'

@description('Optional. Set this flag to true to enable auto-updating of this disk encryption set to the latest key version.')
param rotationToLatestKeyVersionEnabled bool = false

@description('Conditional. Enables system assigned managed identity on the resource. Required if userAssignedIdentities is empty.')
param systemAssignedIdentity bool = true

@description('Conditional. The ID(s) to assign to the resource. Required if systemAssignedIdentity is set to "false".')
param userAssignedIdentities object = {}

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@description('Optional. Tags of the disk encryption resource.')
param tags object = {}

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

var identityType = systemAssignedIdentity ? (!empty(userAssignedIdentities) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned') : 'UserAssigned'

var identity = {
  type: identityType
  userAssignedIdentities: !empty(userAssignedIdentities) ? userAssignedIdentities : null
}

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

resource keyVault 'Microsoft.KeyVault/vaults@2021-10-01' existing = {
  name: last(split(keyVaultResourceId, '/'))!
  scope: resourceGroup(split(keyVaultResourceId, '/')[2], split(keyVaultResourceId, '/')[4])

  resource key 'keys@2021-10-01' existing = {
    name: keyName
  }
}

// Note: This is only enabled for user-assigned identities as the service's system-assigned identity isn't available during its initial deployment
module keyVaultPermissions '.bicep/nested_keyVaultPermissions.bicep' = [for (userAssignedIdentityId, index) in items(userAssignedIdentities): {
  name: '${uniqueString(deployment().name, location)}-DiskEncrSet-KVPermissions-${index}'
  params: {
    keyName: keyName
    keyVaultResourceId: keyVaultResourceId
    userAssignedIdentityResourceId: userAssignedIdentityId.key
    rbacAuthorizationEnabled: keyVault.properties.enableRbacAuthorization
  }
  scope: resourceGroup(split(keyVaultResourceId, '/')[2], split(keyVaultResourceId, '/')[4])
}]

resource diskEncryptionSet 'Microsoft.Compute/diskEncryptionSets@2022-07-02' = {
  name: name
  location: location
  tags: tags
  identity: identity
  properties: {
    activeKey: {
      sourceVault: {
        id: keyVaultResourceId
      }
      keyUrl: !empty(keyVersion) ? '${keyVault::key.properties.keyUri}/${keyVersion}' : keyVault::key.properties.keyUriWithVersion
    }
    encryptionType: encryptionType
    federatedClientId: federatedClientId
    rotationToLatestKeyVersionEnabled: rotationToLatestKeyVersionEnabled
  }
  dependsOn: [
    keyVaultPermissions
  ]
}

module diskEncryptionSet_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-DiskEncrSet-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: diskEncryptionSet.id
  }
}]

resource diskEncryptionSet_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock)) {
  name: '${diskEncryptionSet.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: diskEncryptionSet
}

@description('The resource ID of the disk encryption set.')
output resourceId string = diskEncryptionSet.id

@description('The name of the disk encryption set.')
output name string = diskEncryptionSet.name

@description('The resource group the disk encryption set was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The principal ID of the disk encryption set.')
output principalId string = systemAssignedIdentity == true ? diskEncryptionSet.identity.principalId : ''

@description('The idenities of the disk encryption set.')
output identities object = diskEncryptionSet.identity

@description('The name of the key vault with the disk encryption key.')
output keyVaultName string = last(split(keyVaultResourceId, '/'))!

@description('The location the resource was deployed into.')
output location string = diskEncryptionSet.location
