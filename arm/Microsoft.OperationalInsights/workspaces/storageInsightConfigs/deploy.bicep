@description('Required. Name of the Log Analytics workspace.')
param logAnalyticsWorkspaceName string

@description('The name of the storage insights config')
param name string = last(split(storageAccountId, '/'))

@description('Required. The Azure Resource Manager ID of the storage account resource.')
param storageAccountId string

@description('Optional. The names of the blob containers that the workspace should read.')
param containers array = []

@description('Optional. The names of the Azure tables that the workspace should read.')
param tables array = []

@description('Optional. Tags to configure in the resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' existing = {
  name: last(split(storageAccountId, '/'))
}

resource workspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' existing = {
  name: logAnalyticsWorkspaceName
}

resource storageinsightconfig 'Microsoft.OperationalInsights/workspaces/storageInsightConfigs@2020-08-01' = {
  name: name
  parent: workspace
  tags: tags
  properties: {
    containers: containers
    tables: tables
    storageAccount: {
      id: storageAccountId
      key: storageAccount.listKeys().keys[0].value
    }
  }
}

@description('The resource ID of the deployed storage insights configuration')
output storageinsightconfigResourceId string = storageinsightconfig.id

@description('The resource group where the storage insight configuration is deployed')
output storageinsightconfigResourceGroup string = resourceGroup().name

@description('The name of the storage insights configuration')
output storageinsightconfigName string = storageinsightconfig.name
