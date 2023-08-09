metadata name = 'Site Auth Settings V2 Config'
metadata description = 'This module deploys a Site Auth Settings V2 Configuration.'
metadata owner = 'Azure/module-maintainers'

// ================ //
// Parameters       //
// ================ //
@description('Conditional. The name of the parent site resource. Required if the template is used in a standalone deployment.')
param appName string

@description('Required. Type of site to deploy.')
@allowed([
  'functionapp' // function app windows os
  'functionapp,linux' // function app linux os
  'functionapp,workflowapp' // logic app workflow
  'functionapp,workflowapp,linux' // logic app docker container
  'app' // normal web app
])
param kind string

@description('Required. The properties object values.')
param properties object

@description('Required. The configuration object name.')
param name string

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

// =========== //
// Existing resources //
// =========== //
resource app 'Microsoft.Web/sites@2022-03-01' existing = {
  name: appName
}

// ============ //
// Dependencies //
// ============ //
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

resource appConfig 'Microsoft.Web/sites/config@2022-03-01' = {
  name: name
  kind: kind
  parent: app
  properties: properties
}

// =========== //
// Outputs     //
// =========== //
@description('The name of the site config.')
output name string = appConfig.name

@description('The resource ID of the site config.')
output resourceId string = appConfig.id

@description('The resource group the site config was deployed into.')
output resourceGroupName string = resourceGroup().name
