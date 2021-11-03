@maxLength(24)
@description('Required. Name of the Storage Account.')
param storageAccountName string

@description('The name of the storage container to deploy')
param name string

@allowed([
  'Container'
  'Blob'
  'None'
])
@description('Specifies whether data in the container may be accessed publicly and the level of access.')
param publicAccess string = 'None'

@description('Configure immutability policy.')
param immutabilityPolicyProperties object = {}

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or it\'s fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' = {
  name: '${storageAccountName}/default/${name}'
  properties: {
    publicAccess: publicAccess
  }
}

module immutabilityPolicy 'immutabilityPolicies/deploy.bicep' = if (!empty(immutabilityPolicyProperties)) {
  name: 'default'
  params: {
    storageAccountName: storageAccountName
    containerName: container.name
    immutabilityPeriodSinceCreationInDays: contains(immutabilityPolicyProperties, 'immutabilityPeriodSinceCreationInDays') ? immutabilityPolicyProperties.immutabilityPeriodSinceCreationInDays : 365
    allowProtectedAppendWrites: contains(immutabilityPolicyProperties, 'allowProtectedAppendWrites') ? immutabilityPolicyProperties.allowProtectedAppendWrites : true
  }
}

module container_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${deployment().name}-Rbac-${index}'
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
