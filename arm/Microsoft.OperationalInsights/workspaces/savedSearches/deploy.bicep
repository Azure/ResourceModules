@description('Required. Name of the Log Analytics workspace')
param logAnalyticsWorkspaceName string

@description('Required. Name of the saved search')
param name string

@description('Requried. Display name for the search.')
param displayName string

@description('Required. Query category.')
param category string

@description('Required. Kusto Query to be stored.')
param query string

@description('Optional. Tags to configure in the resource.')
param tags array = []

@description('Optional. The function alias if query serves as a function..')
param functionAlias string = ''

@description('Optional. The optional function parameters if query serves as a function. Value should be in the following format: "param-name1:type1 = default_value1, param-name2:type2 = default_value2". For more examples and proper syntax please refer to /azure/kusto/query/functions/user-defined-functions.')
param functionParameters string = ''

@description('Optional. The version number of the query language.')
param version int = 2

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource workspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' existing = {
  name: logAnalyticsWorkspaceName
}

resource savedSearch 'Microsoft.OperationalInsights/workspaces/savedSearches@2020-08-01' = {
  name: name
  parent: workspace
  properties: {
    tags: tags
    displayName: displayName
    category: category
    query: query
    functionAlias: functionAlias
    functionParameters: functionParameters
    version: version
  }
}

@description('The resource ID of the deployed saved search')
output savedSearchResourceId string = savedSearch.id

@description('The resource group where the saved search is deployed')
output savedSearchResourceGroup string = resourceGroup().name

@description('The name of the deployed saved search')
output savedSearchName string = savedSearch.name
