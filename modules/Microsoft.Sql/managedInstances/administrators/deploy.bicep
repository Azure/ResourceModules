@description('Conditional. The name of the parent SQL managed instance. Required if the template is used in a standalone deployment.')
param managedInstanceName string

@description('Required. Login name of the managed instance administrator.')
param login string

@description('Required. SID (object ID) of the managed instance administrator.')
param sid string

@description('Optional. The name of the managed instance administrator.')
param name string = 'ActiveDirectory'

@description('Optional. Tenant ID of the managed instance administrator.')
param tenantId string = ''

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

@description('The name of the deployed managed instance.')
output name string = administrator.name

@description('The resource ID of the deployed managed instance.')
output resourceId string = administrator.id

@description('The resource group of the deployed managed instance.')
output resourceGroupName string = resourceGroup().name
