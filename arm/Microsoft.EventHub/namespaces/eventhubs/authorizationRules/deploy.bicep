@description('Required. The name of the EventHub namespace')
param namespaceName string

@description('Required. The name of the EventHub namespace eventHub')
param eventHubName string

@description('Required. The name of the authorization rule')
param name string

@description('Optional. The rights associated with the rule.')
@allowed([
  'Listen'
  'Manage'
  'Send'
])
param rights array = []

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource authorizationRule 'Microsoft.EventHub/namespaces/eventhubs/authorizationRules@2021-06-01-preview' = {
  name: '${namespaceName}/${eventHubName}/${name}'
  properties: {
    rights: rights
  }
}

@description('The name of the authorization rule.')
output authorizationRuleName string = authorizationRule.name

@description('The Resource Id of the authorization rule.')
output authorizationRuleResourceId string = authorizationRule.id

@description('The name of the Resource Group the authorization rule was created in.')
output authorizationRuleResourceGroup string = resourceGroup().name
