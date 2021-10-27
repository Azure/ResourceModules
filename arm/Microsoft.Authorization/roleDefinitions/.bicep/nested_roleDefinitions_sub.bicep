targetScope = 'subscription'

param roleName string
param roleDescription string = ''
param actions array = []
param notActions array = []
param dataActions array = []
param notDataActions array = []
param subscriptionId string = subscription().subscriptionId
param location string = deployment().location

resource roleDefinition 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' = {
  name: guid(roleName, subscriptionId, location)
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
      subscription().id
    ]
  }
}

output roleDefinitionName string = roleDefinition.name
output roleDefinitionScope string = subscription().id
output roleDefinitionId string = subscriptionResourceId(subscriptionId, 'Microsoft.Authorization/roleDefinitions', roleDefinition.name)
