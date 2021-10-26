@maxLength(24)
@description('Required. Name of the Storage Account.')
param storageAccountName string = ''

@description('The name of the storage container to deploy')
param name string

@allowed([
  'Container'
  'Blob'
  'None'
])
@description('Specifies whether data in the container may be accessed publicly and the level of access.')
param publicAccess string = 'None'

@description('Enable immutability policy for this blob container')
param enableWORM bool = false

@description('The immutability period for the blobs in the container since the policy creation, in days.')
param immutabilityPeriodSinceCreationInDays int = 365

@description('This property can only be changed for unlocked time-based retention policies. When enabled, new blocks can be written to an append blob while maintaining immutability protection and compliance. Only new blocks can be added and any existing blocks cannot be modified or deleted. This property cannot be changed with ExtendImmutabilityPolicy API')
param allowProtectedAppendWrites bool = true

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or it\'s fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' = {
  name: '${storageAccountName}/default/${name}'
  properties: {
    publicAccess: publicAccess
  }
}

module immutabilityPolicy '.immutabilityPolicies/deploy.bicep' = if (enableWORM) {
  name: 'default'
  params: {
    containerName: name
    immutabilityPeriodSinceCreationInDays: immutabilityPeriodSinceCreationInDays
    allowProtectedAppendWrites: allowProtectedAppendWrites
  }
}

module container_rbac './.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${deployment().name}-Rbac-${(empty(roleAssignments) ? 'dummy' : index)}'
  params: {
    roleAssignmentObj: roleAssignment
    resourceName: container.name
  }
}]

@description('The name of the deployed container')
output containerName string = container.name

@description('The ID of the deployed container')
output containerResourceId string = container.id

@description('The resource group of the deployed container')
output containerResourceGroup string = resourceGroup().name
