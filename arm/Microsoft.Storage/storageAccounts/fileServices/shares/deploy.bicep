@maxLength(24)
@description('Required. Name of the Storage Account.')
param storageAccountName string

@description('The name of the file share to create')
param name string

@description('The maximum size of the share, in gigabytes. Must be greater than 0, and less than or equal to 5TB (5120). For Large File Shares, the maximum size is 102400.')
param sharedQuota int = 5120

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or it\'s fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource fileShare 'Microsoft.Storage/storageAccounts/fileServices/shares@2019-06-01' = {
  name: '${storageAccountName}/default/${name}'
  properties: {
    shareQuota: sharedQuota
  }
}

module fileShare_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${deployment().name}-Rbac-${index}'
  params: {
    roleAssignmentObj: roleAssignment
    resourceName: fileShare.name
  }
}]

@description('The name of the deployed file share')
output fileShareName string = fileShare.name

@description('The id of the deployed file share')
output fileShareResourceId string = fileShare.id

@description('The resource group of the deployed file share')
output fileShareResourceGroup string = resourceGroup().name
