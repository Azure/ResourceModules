@description('Required. The name of the event hub namespace')
param namespaceName string

@description('Required. The name of the disaster recovery config')
param name string

@description('Optional. Resource ID of the Primary/Secondary event hub namespace name, which is part of GEO DR pairing')
param partnerNamespaceId string = ''

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param telemetryCuaId string = ''

resource pid_cuaId 'Microsoft.Resources/deployments@2021-04-01' = if (!empty(telemetryCuaId)) {
  name: 'pid-${telemetryCuaId}'
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
output disasterRecoveryConfigName string = disasterRecoveryConfig.name

@description('The resource ID of the disaster recovery config.')
output disasterRecoveryConfigResourceId string = disasterRecoveryConfig.id

@description('The name of the resource group the disaster recovery config was created in.')
output disasterRecoveryConfigResourceGroup string = resourceGroup().name
