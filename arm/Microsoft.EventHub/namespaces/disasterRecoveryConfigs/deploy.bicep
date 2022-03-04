@description('Required. The name of the event hub namespace')
param namespaceName string

@description('Required. The name of the disaster recovery config')
param name string

@description('Optional. Resource ID of the Primary/Secondary event hub namespace name, which is part of GEO DR pairing')
param partnerNamespaceId string = ''

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

resource namespace 'Microsoft.EventHub/namespaces@2021-06-01-preview' existing = {
  name: namespaceName
}

resource disasterRecoveryConfig 'Microsoft.EventHub/namespaces/disasterRecoveryConfigs@2017-04-01' = {
  name: name
  parent: namespace
  properties: {
    partnerNamespace: partnerNamespaceId
  }
}

@description('The name of the disaster recovery config.')
output name string = disasterRecoveryConfig.name

@description('The resource ID of the disaster recovery config.')
output resourceId string = disasterRecoveryConfig.id

@description('The name of the resource group the disaster recovery config was created in.')
output resourceGroupName string = resourceGroup().name
