targetScope = 'subscription'

param roleName string
param description string = ''
param actions array = []
param notActions array = []
param dataActions array = []
param notDataActions array = []
param subscriptionId string = subscription().subscriptionId
param assignableScopes array = []

resource roleDefinition 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' = {
  name: guid(roleName, subscriptionId)
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
    assignableScopes: assignableScopes == [] ? array(subscription().id) : assignableScopes
  }
}

output roleDefinitionName string = roleDefinition.name
output roleDefinitionScope string = subscription().id
output roleDefinitionResourceId string = subscriptionResourceId(subscriptionId, 'Microsoft.Authorization/roleDefinitions', roleDefinition.name)
