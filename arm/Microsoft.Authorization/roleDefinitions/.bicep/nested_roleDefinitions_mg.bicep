targetScope = 'managementGroup'

param roleName string
param description string = ''
param actions array = []
param notActions array = []
param managementGroupId string
param assignableScopes array = []

resource roleDefinition 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' = {
  name: guid(roleName, managementGroupId)
  properties: {
    roleName: roleName
    description: description
    type: 'customRole'
    permissions: [
      {
        actions: actions
        notActions: notActions
      }
    ]
    assignableScopes: assignableScopes == [] ? array(tenantResourceId('Microsoft.Management/managementGroups', managementGroupId)) : assignableScopes
  }
}

output roleDefinitionName string = roleDefinition.name
output roleDefinitionScope string = tenantResourceId('Microsoft.Management/managementGroups', managementGroupId)
output roleDefinitionResourceId string = extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', managementGroupId), 'Microsoft.Authorization/roleDefinitions', roleDefinition.name)
