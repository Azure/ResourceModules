@description('Required. The name of the event hub namespace')
param namespaceName string

@description('Required. The name of the event hub namespace event hub')
param eventHubName string

@description('Required. The name of the consumer group')
param name string

@description('Optional. User Metadata is a placeholder to store user-defined string data with maximum length 1024. e.g. it can be used to store descriptive data, such as list of teams and their contact information also user-defined configuration settings can be stored.')
param userMetadata string = ''

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource namespace 'Microsoft.EventHub/namespaces@2021-06-01-preview' existing = {
  name: namespaceName

  resource eventhub 'eventHubs@2021-06-01-preview' existing = {
    name: eventHubName
  }
}

resource consumerGroup 'Microsoft.EventHub/namespaces/eventhubs/consumergroups@2021-06-01-preview' = {
  name: name
  parent: namespace::eventhub
  properties: {
    userMetadata: !empty(userMetadata) ? userMetadata : null
  }
}

@description('The name of the consumer group.')
output name string = consumerGroup.name

@description('The resource ID of the consumer group.')
output resourceId string = consumerGroup.id

@description('The name of the resource group the consumer group was created in.')
output resourceGroupName string = resourceGroup().name
