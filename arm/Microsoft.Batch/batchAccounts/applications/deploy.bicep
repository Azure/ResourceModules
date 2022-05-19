@description('Required. Name of the batch Account.')
param batchName string

@description('Required. Name of the application package.')
param appName string

@description('Optional. The package to use if a client requests the application but does not specify a version. This property can only be set to the name of an existing package.')
param defaultVersion string = ''

@description('Optional. The display name for the application package.')
param displayName string = ''

@description('Optional. A value indicating whether packages within the application may be overwritten using the same version string.')
param allowUpdates bool = true

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = true

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name, location)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource batch 'Microsoft.Batch/batchAccounts@2022-01-01' existing = {
  name: batchName
}

resource application 'Microsoft.Batch/batchAccounts/applications@2022-01-01' = {
  name: appName
  parent: batch
  properties: {
    allowUpdates: allowUpdates
    defaultVersion: !empty(defaultVersion) ? defaultVersion : null
    displayName: !empty(displayName) ? displayName : null
  }
}

@description('The name of the resource group the application was created in.')
output resourceGroupName string = resourceGroup().name

@description('The name of the created application.')
output name string = application.name

@description('The resource ID of the created application.')
output resourceId string = application.id

@description('The location the resource was deployed into.')
output location string = batch.location
