@description('Required. The name of the parent Azure Recovery Service Vault.')
param recoveryVaultName string

@description('Required. The name of the replication Alert Setting.')
param name string

@description('Required. Comma separated list of custom email address for sending alert emails.')
param emailAddresses string = ''

@description('Optional. The locale for the email notification.')
param locale string = ''

@description('Optional. The value indicating whether to send email to subscription administrator.')
@allowed([
  'DoNotSend'
  'Send'
])
param sendToOwners string = 'Send'

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

resource recoveryVault 'Microsoft.RecoveryServices/vaults@2022-08-01' existing = {
  name: recoveryVaultName
}

resource replicationAlertSetting 'Microsoft.RecoveryServices/vaults/replicationAlertSettings@2022-08-01' = {
  name: name
  parent: recoveryVault
  properties: {
    customEmailAddresses: [
      emailAddresses
    ]
    locale: locale
    sendToOwners: sendToOwners

  }

}

@description('The name of the replication Alert Setting.')
output name string = replicationAlertSetting.name

@description('The name of the resource group the replication alert setting was created.')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the replication alert setting.')
output resourceId string = replicationAlertSetting.id
