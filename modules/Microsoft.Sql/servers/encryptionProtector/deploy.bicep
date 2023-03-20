@description('Conditional. The name of the sql server.')
param sqlServerName string

@description('Required. The name of the server key.')
param serverKeyName string

@description('Optional. Key auto rotation opt-in.')
param autoRotationEnabled bool = false

@description('Optional. The encryption protector type like "ServiceManaged", "AzureKeyVault".')
@allowed([
  'AzureKeyVault'
  'ServiceManaged'
])
param serverKeyType string = 'ServiceManaged'

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
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

resource sqlServer 'Microsoft.Sql/servers@2021-11-01' existing = {
  name: sqlServerName
}

resource encryptionProtector 'Microsoft.Sql/servers/encryptionProtector@2021-11-01' = {
  name: 'current'
  parent: sqlServer
  properties: {
    serverKeyType: serverKeyType
    autoRotationEnabled: autoRotationEnabled
    serverKeyName: serverKeyName
  }
}

@description('The name of the deployed encryption protector.')
output name string = encryptionProtector.name

@description('The resource ID of the encryption protector.')
output resourceId string = encryptionProtector.id

@description('The resource group of the deployed encryption protector.')
output resourceGroupName string = resourceGroup().name