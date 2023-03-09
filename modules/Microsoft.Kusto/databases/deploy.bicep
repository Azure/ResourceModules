@description('The name of the Azure Data Explorer Database.')
param name string

@description('The location of the Azure Data Explorer Database.')
param location string

@description('The name of the Azure Data Explorer Cluster.')
param clusterName string

// @description('The kind of the Azure Data Explorer Database.')
// param kind string = 'ReadWrite'

@description('The soft delete period of the Azure Data Explorer Database.')
@minValue(1)
@maxValue(36500)
param softDeletePeriod int = 365

@description('The hot cache period of the Azure Data Explorer Database.')
@minValue(0)
@maxValue(36500)
param hotCachePeriod int = 31

resource azureDataExplorer 'Microsoft.Kusto/clusters@2022-12-29' existing = {
  name: clusterName
}

resource azureDataExplorerDatabase 'Microsoft.Kusto/clusters/databases@2022-12-29' = {
  name: name
  location: location
  kind: 'ReadWrite'
  parent: azureDataExplorer
  properties: {
    softDeletePeriod: 'P${softDeletePeriod}D'
    hotCachePeriod: 'P${hotCachePeriod}D'
  }
}
