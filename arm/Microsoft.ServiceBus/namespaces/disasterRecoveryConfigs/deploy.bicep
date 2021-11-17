@description('Required. Name of the parent Service Bus Namespace for the Service Bus Queue.')
@minLength(6)
@maxLength(50)
param namespaceName string

@description('Optional. The name of the disaster recovery config')
param name string = 'default'

@description('Optional. Primary/Secondary eventhub namespace name, which is part of GEO DR pairing')
param alternateName string = ''

@description('Optional. ARM Id of the Primary/Secondary eventhub namespace name, which is part of GEO DR pairing')
param partnerNamespace string = ''

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource disasterRecoveryConfig 'Microsoft.ServiceBus/namespaces/disasterRecoveryConfigs@2017-04-01' = {
  name: '${namespaceName}/${name}'
  properties: {
    alternateName: alternateName
    partnerNamespace: partnerNamespace
  }
}

@description('The name of the disaster recovery config.')
output disasterRecoveryConfigName string = disasterRecoveryConfig.name

@description('The Resource Id of the disaster recovery config.')
output disasterRecoveryConfigResourceId string = disasterRecoveryConfig.id

@description('The name of the Resource Group the disaster recovery config was created in.')
output disasterRecoveryConfigResourceGroup string = resourceGroup().name
