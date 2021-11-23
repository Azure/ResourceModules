@description('Required. The name of the EventHub namespace')
param namespaceName string

@description('Required. The name of the disaster recovery config')
param name string

@description('Optional. ARM ID of the Primary/Secondary eventhub namespace name, which is part of GEO DR pairing')
param partnerNamespaceId string = ''

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource disasterRecoveryConfig 'Microsoft.EventHub/namespaces/disasterRecoveryConfigs@2017-04-01' = {
  name: '${namespaceName}/${name}'
  properties: {
    partnerNamespace: partnerNamespaceId
  }
}

@description('The name of the disaster recovery config.')
output disasterRecoveryConfigName string = disasterRecoveryConfig.name

@description('The Resource ID of the disaster recovery config.')
output disasterRecoveryConfigResourceId string = disasterRecoveryConfig.id

@description('The name of the Resource Group the disaster recovery config was created in.')
output disasterRecoveryConfigResourceGroup string = resourceGroup().name
