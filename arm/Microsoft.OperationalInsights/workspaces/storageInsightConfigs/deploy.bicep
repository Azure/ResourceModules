@description('Required. Name of the Log Analytics workspace.')
param logAnalyticsWorkspaceName string

@description('Required. Name of the saved search.')
param name string

@description('Required. The Azure Resource Manager ID of the storage account resource.')
param storageAccountId string

@description('Optional. The names of the blob containers that the workspace should read.')
param containers array = []

@description('Optional. The names of the Azure tables that the workspace should read.')
param tables array = []

@description('Optional. The ETag of the data source.')
param etag string = '*'

@description('Optional. Tags to configure in the resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource storageinsightconfig 'Microsoft.OperationalInsights/workspaces/storageInsightConfigs@2020-08-01' = {
  name: '${logAnalyticsWorkspaceName}/${name}'
  tags: tags
  eTag: etag
  properties: {
    containers: containers
    tables: tables
    storageAccount: {
      id: storageAccountId
      key: listKeys(storageAccountId, '2016-12-01').keys[0].value
    }
  }
}
