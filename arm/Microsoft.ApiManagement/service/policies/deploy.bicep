@description('Required. The name of the of the Api Management service.')
param apiManagementServiceName string

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

@description('Required. Policy name')
param name string

@description('Optional. Policy properties.')
param properties object = {}

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource policy 'Microsoft.ApiManagement/service/policies@2020-06-01-preview' = if (!empty(properties)) {
  name: '${apiManagementServiceName}/${name}'
  properties: properties
}

@description('The resourceId of the API management service policy')
output policyResourceId string = policy.id

@description('The name of the API management service policy')
output policyName string = policy.name

@description('The resource group the API management service policy was deployed into')
output policyResourceGroup string = resourceGroup().name
