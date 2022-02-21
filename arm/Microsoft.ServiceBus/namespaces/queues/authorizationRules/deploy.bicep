@description('Required. The name of the service bus namepace queue')
param name string

@description('Required. The name of the parent service bus namespace')
param namespaceName string

@description('Required. The name of the parent service bus namespace queue')
param queueName string

@description('Optional. The rights associated with the rule.')
@allowed([
  'Listen'
  'Manage'
  'Send'
])
param rights array = []

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource namespace 'Microsoft.ServiceBus/namespaces@2021-06-01-preview' existing = {
  name: namespaceName

  resource queue 'queues@2021-06-01-preview' existing = {
    name: queueName
  }
}

resource authorizationRule 'Microsoft.ServiceBus/namespaces/queues/authorizationRules@2017-04-01' = {
  name: name
  parent: namespace::queue
  properties: {
    rights: rights
  }
}

@description('The name of the authorization rule.')
output name string = authorizationRule.name

@description('The Resource ID of the authorization rule.')
output resourceId string = authorizationRule.id

@description('The name of the Resource Group the authorization rule was created in.')
output resourceGroupName string = resourceGroup().name
