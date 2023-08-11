metadata name = 'SQL Managed Instance Keys'
metadata description = 'This module deploys a SQL Managed Instance Key.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the key. Must follow the [<keyVaultName>_<keyName>_<keyVersion>] pattern.')
param name string

@description('Conditional. The name of the parent SQL managed instance. Required if the template is used in a standalone deployment.')
param managedInstanceName string

@description('Optional. The encryption protector type like "ServiceManaged", "AzureKeyVault".')
@allowed([
  'AzureKeyVault'
  'ServiceManaged'
])
param serverKeyType string = 'ServiceManaged'

@description('Optional. The URI of the key. If the ServerKeyType is AzureKeyVault, then either the URI or the keyVaultName/keyName combination is required.')
param uri string = ''

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

var splittedKeyUri = split(uri, '/')

// if serverManaged, use serverManaged, if uri provided use concated uri value
// MUST match the pattern '<keyVaultName>_<keyName>_<keyVersion>'
var serverKeyName = empty(uri) ? 'ServiceManaged' : '${split(splittedKeyUri[2], '.')[0]}_${splittedKeyUri[4]}_${splittedKeyUri[5]}'

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

resource managedInstance 'Microsoft.Sql/managedInstances@2022-02-01-preview' existing = {
  name: managedInstanceName
}

resource key 'Microsoft.Sql/managedInstances/keys@2022-02-01-preview' = {
  name: !empty(name) ? name : serverKeyName
  parent: managedInstance
  properties: {
    serverKeyType: serverKeyType
    uri: uri
  }
}

@description('The name of the deployed managed instance key.')
output name string = key.name

@description('The resource ID of the deployed managed instance key.')
output resourceId string = key.id

@description('The resource group of the deployed managed instance key.')
output resourceGroupName string = resourceGroup().name
