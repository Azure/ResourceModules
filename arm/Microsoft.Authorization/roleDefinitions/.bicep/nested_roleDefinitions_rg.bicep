targetScope = 'resourceGroup'

param roleName string
param description string = ''
param actions array = []
param notActions array = []
param dataActions array = []
param notDataActions array = []
param subscriptionId string = subscription().subscriptionId
param resourceGroupName string = resourceGroup().name
param assignableScopes array = []

resource roleDefinition 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' = {
  name: guid(roleName, subscriptionId, resourceGroupName)
  properties: {
    roleName: roleName
    description: description
    type: 'customRole'
    permissions: [
      {
        actions: actions
        notActions: notActions
        dataActions: dataActions
        notDataActions: notDataActions
      }
    ]
    assignableScopes: assignableScopes == [] ? array(resourceGroup().id) : assignableScopes
  }
}

output roleDefinitionName string = roleDefinition.name
output roleDefinitionScope string = resourceGroup().id
output roleDefinitionResourceId string = roleDefinition.id
