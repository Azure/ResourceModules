@description('Required. Name of the parent Service Bus Namespace for the Service Bus Queue.')
@minLength(6)
@maxLength(50)
param namespaceName string

@description('Optional. The name of the ip filter rule')
param name string = filterName

@description('Required. The IP Filter Action')
@allowed([
  'Accept'
  // 'Reject' # Reason: Only Accept IpFilterRules are accepted by API
])
param action string

@description('Required. IP Filter name')
param filterName string

@description('Required. IP Mask')
param ipMask string

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
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
