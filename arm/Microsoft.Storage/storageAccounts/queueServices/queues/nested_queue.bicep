@maxLength(24)
@description('Required. Name of the Storage Account.')
param storageAccountName string = ''

@description('The name of the storage queue to deploy')
param queueName string

@description('A name-value pair that represents queue metadata.')
param metadata object = {}

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or it\'s fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

resource queue 'Microsoft.Storage/storageAccounts/queueServices/queues@2019-06-01' = {
  name: '${storageAccountName}/default/${queueName}'
  properties: {
    metadata: metadata
  }
}

module queue_rbac './.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${deployment().name}-Rbac-${(empty(roleAssignments) ? 'dummy' : index)}'
  params: {
    roleAssignmentObj: roleAssignment
    resourceName: queue.name
  }
}]

@description('The name of the deployed queue')
output queueName string = queue.name

@description('The ID of the deployed queue')
output queueResourceId string = queue.id

@description('The resource group of the deployed queue')
output queueResourceGroup string = resourceGroup().name
