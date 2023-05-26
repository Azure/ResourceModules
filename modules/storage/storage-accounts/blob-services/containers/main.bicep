@maxLength(24)
@description('Conditional. The name of the parent Storage Account. Required if the template is used in a standalone deployment.')
param storageAccountName string

@description('Required. The name of the storage container to deploy.')
param name string

@description('Optional. Default the container to use specified encryption scope for all writes.')
param defaultEncryptionScope string = ''

@description('Optional. Block override of encryption scope from the container default.')
param denyEncryptionScopeOverride bool = false

@description('Optional. Enable NFSv3 all squash on blob container.')
param enableNfsV3AllSquash bool = false

@description('Optional. Enable NFSv3 root squash on blob container.')
param enableNfsV3RootSquash bool = false

@description('Optional. This is an immutable property, when set to true it enables object level immutability at the container level. The property is immutable and can only be set to true at the container creation time. Existing containers must undergo a migration process.')
param immutableStorageWithVersioningEnabled bool = false

@description('Optional. Name of the immutable policy.')
param immutabilityPolicyName string = 'default'

@description('Optional. Configure immutability policy.')
param immutabilityPolicyProperties object = {}

@description('Optional. A name-value pair to associate with the container as metadata.')
param metadata object = {}

@allowed([
  'Container'
  'Blob'
  'None'
])
@description('Optional. Specifies whether data in the container may be accessed publicly and the level of access.')
param publicAccess string = 'None'

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

var enableReferencedModulesTelemetry = false

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' existing = {
  name: storageAccountName

  resource blobServices 'blobServices@2022-09-01' existing = {
    name: 'default'
  }
}

resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = {
  name: name
  parent: storageAccount::blobServices
  properties: {
    defaultEncryptionScope: !empty(defaultEncryptionScope) ? defaultEncryptionScope : null
    denyEncryptionScopeOverride: denyEncryptionScopeOverride == true ? denyEncryptionScopeOverride : null
    enableNfsV3AllSquash: enableNfsV3AllSquash == true ? enableNfsV3AllSquash : null
    enableNfsV3RootSquash: enableNfsV3RootSquash == true ? enableNfsV3RootSquash : null
    immutableStorageWithVersioning: immutableStorageWithVersioningEnabled == true ? {
      enabled: immutableStorageWithVersioningEnabled
    } : null
    metadata: metadata
    publicAccess: publicAccess
  }
}

module immutabilityPolicy 'immutability-policies/main.bicep' = if (!empty(immutabilityPolicyProperties)) {
  name: immutabilityPolicyName
  params: {
    storageAccountName: storageAccount.name
    containerName: container.name
    immutabilityPeriodSinceCreationInDays: contains(immutabilityPolicyProperties, 'immutabilityPeriodSinceCreationInDays') ? immutabilityPolicyProperties.immutabilityPeriodSinceCreationInDays : 365
    allowProtectedAppendWrites: contains(immutabilityPolicyProperties, 'allowProtectedAppendWrites') ? immutabilityPolicyProperties.allowProtectedAppendWrites : true
    allowProtectedAppendWritesAll: contains(immutabilityPolicyProperties, 'allowProtectedAppendWritesAll') ? immutabilityPolicyProperties.allowProtectedAppendWritesAll : true
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}

module container_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${deployment().name}-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: container.id
  }
}]

@description('The name of the deployed container.')
output name string = container.name

@description('The resource ID of the deployed container.')
output resourceId string = container.id

@description('The resource group of the deployed container.')
output resourceGroupName string = resourceGroup().name
