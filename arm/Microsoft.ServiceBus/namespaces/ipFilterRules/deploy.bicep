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

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource ipFilterRule 'Microsoft.ServiceBus/namespaces/ipFilterRules@2018-01-01-preview' = {
  name: '${namespaceName}/${name}'
  properties: {
    action: action
    filterName: filterName
    ipMask: ipMask
  }
}

@description('The name of the IP filter rule.')
output ipFilterRuleName string = ipFilterRule.name

@description('The Resource Id of the IP filter rule.')
output ipFilterRuleResourceId string = ipFilterRule.id

@description('The name of the Resource Group the IP filter rule was created in.')
output ipFilterRuleResourceGroup string = resourceGroup().name
