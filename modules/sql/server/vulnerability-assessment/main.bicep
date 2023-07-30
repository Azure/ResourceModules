@description('Required. The name of the vulnerability assessment.')
param name string

@description('Required. The Name of SQL Server.')
param serverName string

@description('Optional. Recurring scans state.')
param recurringScansIsEnabled bool = false

@description('Optional. Specifies that the schedule scan notification will be is sent to the subscription administrators.')
param recurringScansEmailSubscriptionAdmins bool = false

@description('Optional. Specifies an array of email addresses to which the scan notification is sent.')
param recurringScansEmails array = []

@description('Optional. A blob storage to hold the scan results.')
param storageAccountResourceId string = ''

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-9319755b-f697-4146-b966-4656e0b46cac-${uniqueString(deployment().name)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource server 'Microsoft.Sql/servers@2022-02-01-preview' existing = {
  name: serverName
}

resource vulnerabilityAssessment 'Microsoft.Sql/servers/vulnerabilityAssessments@2022-02-01-preview' = {
  name: name
  parent: server
  properties: {
    storageContainerPath: 'https://${last(split(storageAccountResourceId, '/'))}.blob.${environment().suffixes.storage}/vulnerability-assessment/'
    storageAccountAccessKey: listKeys(storageAccountResourceId, '2019-06-01').keys[0].value
    recurringScans: {
      isEnabled: recurringScansIsEnabled
      emailSubscriptionAdmins: recurringScansEmailSubscriptionAdmins
      emails: recurringScansEmails
    }
  }
}

@description('The name of the deployed vulnerability assessment.')
output name string = vulnerabilityAssessment.name

@description('The resource ID of the deployed vulnerability assessment.')
output resourceId string = vulnerabilityAssessment.id

@description('The resource group of the deployed vulnerability assessment.')
output resourceGroupName string = resourceGroup().name
