@description('Required. Name of the SQL managed instance.')
param managedInstanceName string

@description('Required. Login name of the managed instance administrator.')
param login string

@description('Required. SID (object ID) of the managed instance administrator.')
param sid string

@description('Optional. The name of the managed instance administrator')
param name string = 'ActiveDirectory'

@description('Optional. Tenant ID of the managed instance administrator.')
param tenantId string = ''

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId './.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource managedInstance 'Microsoft.Sql/managedInstances@2021-05-01-preview' existing = {
  name: managedInstanceName
}

resource administrator 'Microsoft.Sql/managedInstances/administrators@2021-02-01-preview' = {
  name: name
  parent: managedInstance
  properties: {
    administratorType: 'ActiveDirectory'
    login: login
    sid: sid
    tenantId: tenantId
  }
}

@description('The name of the deployed managed instance')
output administratorName string = administrator.name

@description('The resource ID of the deployed managed instance')
output administratorResourceId string = administrator.id

@description('The resource group of the deployed managed instance')
output administratorResourceGroup string = resourceGroup().name
