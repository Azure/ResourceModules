targetScope = 'resourceGroup'

param roleName string
param roleDescription string = ''
param actions array = []
param notActions array = []
param dataActions array = []
param notDataActions array = []
param subscriptionId string = subscription().id
param resourceGroupName string = resourceGroup().name
param location string = resourceGroup().location

resource roleDefinition 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' = {
  name: guid(roleName, subscriptionId, resourceGroupName, location)
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
      resourceGroup().id
    ]
  }
}

output roleDefinitionScope string = resourceGroup().id
output roleDefintionId string = roleDefinition.id
