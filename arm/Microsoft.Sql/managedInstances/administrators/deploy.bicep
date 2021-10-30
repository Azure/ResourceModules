@description('Name of the resource.')
param managedInstanceName string

@description('Required. Login name of the managed instance administrator.')
param login string

@description('Required. SID (object ID) of the managed instance administrator.')
param sid string

@description('Optional. Tenant ID of the managed instance administrator.')
param tenantId string = ''

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId './.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource administrator 'Microsoft.Sql/managedInstances/administrators@2021-02-01-preview' = {
  name: '${managedInstanceName}/ActiveDirectory'
  properties: {
    administratorType: 'ActiveDirectory'
    login: login
    sid: sid
    tenantId: tenantId
  }
}

@description('The name of the deployed managed instance')
output administratorName string = administrator.name

@description('The resourceId of the deployed managed instance')
output administratorResourceId string = administrator.id

@description('The resource group of the deployed managed instance')
output administratorResourceGroup string = resourceGroup().name
