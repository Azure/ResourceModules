@description('Required. The name of the of the API Management service.')
param apiManagementServiceName string

@description('Optional. The name of the policy')
param name string = 'policy'

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

@description('Optional. Format of the policyContent.')
@allowed([
  'rawxml'
  'rawxml-link'
  'xml'
  'xml-link'
])
param format string = 'xml'

@description('Required. Contents of the Policy as defined by the format.')
param value string

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource service 'Microsoft.ApiManagement/service@2021-08-01' existing = {
  name: apiManagementServiceName
}

resource policy 'Microsoft.ApiManagement/service/policies@2021-08-01' = {
  name: name
  parent: service
  properties: {
    format: format
    value: value
  }
}

@description('The resource ID of the API management service policy')
output resourceId string = policy.id

@description('The name of the API management service policy')
output name string = policy.name

@description('The resource group the API management service policy was deployed into')
output resourceGroupName string = resourceGroup().name
