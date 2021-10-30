targetScope = 'managementGroup'

param roleName string
param roleDescription string = ''
param actions array = []
param notActions array = []
param dataActions array = []
param notDataActions array = []
param managementGroupId string
param location string = deployment().location

resource roleDefinition 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' = {
  name: guid(roleName, managementGroupId, location)
  properties: {
    roleName: roleName
    description: roleDescription
    type: 'customRole'
    permissions: [
      {
        actions: actions
        notActions: notActions
        dataActions: dataActions
        notDataActions: notDataActions
      }
    ]
    assignableScopes: [
      tenantResourceId('Microsoft.Management/managementGroups', managementGroupId)
    ]
  }
}

output roleDefinitionName string = roleDefinition.name
output roleDefinitionScope string = tenantResourceId('Microsoft.Management/managementGroups', managementGroupId)
output roleDefinitionId string = extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', managementGroupId), 'Microsoft.Authorization/roleDefinitions', roleDefinition.name)
