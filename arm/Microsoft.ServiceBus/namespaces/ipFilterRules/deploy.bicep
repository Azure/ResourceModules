@description('Conditional. The name of the parent Service Bus Namespace for the Service Bus Queue. Required if the template is used in a standalone deployment.')
@minLength(6)
@maxLength(50)
param namespaceName string

@description('Optional. The name of the ip filter rule.')
param name string = filterName

@description('Required. The IP Filter Action.')
@allowed([
  'Accept'
  // 'Reject' # Reason: Only Accept IpFilterRules are accepted by API
])
param action string

@description('Required. IP Filter name.')
param filterName string

@description('Required. IP Mask.')
param ipMask string

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = true

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource namespace 'Microsoft.ServiceBus/namespaces@2021-06-01-preview' existing = {
  name: namespaceName
}

resource ipFilterRule 'Microsoft.ServiceBus/namespaces/ipFilterRules@2018-01-01-preview' = {
  name: name
  parent: namespace
  properties: {
    action: action
    filterName: filterName
    ipMask: ipMask
  }
}

@description('The name of the IP filter rule.')
output name string = ipFilterRule.name

@description('The Resource ID of the IP filter rule.')
output resourceId string = ipFilterRule.id

@description('The name of the Resource Group the IP filter rule was created in.')
output resourceGroupName string = resourceGroup().name
