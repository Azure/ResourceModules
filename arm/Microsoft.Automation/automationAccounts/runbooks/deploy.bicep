@description('Required. Name of the Automation Account runbook.')
param name string

@description('Required. Name of the parent Automation Account.')
param automationAccountName string

@allowed([
  'Graph'
  'GraphPowerShell'
  'GraphPowerShellWorkflow'
  'PowerShell'
  'PowerShellWorkflow'
])
@description('Required. The type of the runbook.')
param runbookType string

@description('Optional. The description of the runbook.')
param runbookDescription string = ''

@description('Optional. The uri of the runbook content.')
param uri string = ''

@description('Optional. The version of the runbook content.')
param version string = ''

@description('Optional. ID of the runbook storage account.')
param scriptStorageAccountId string = ''

@description('Optional. Time used as a basis for e.g. the schedule start date.')
param baseTime string = utcNow('u')

@description('Optional. SAS token validity length. Usage: \'PT8H\' - valid for 8 hours; \'P5D\' - valid for 5 days; \'P1Y\' - valid for 1 year. When not provided, the SAS token will be valid for 8 hours.')
param sasTokenValidityLength string = 'PT8H'

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the Automation Account resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered.')
param cuaId string = ''

var accountSasProperties = {
  signedServices: 'b'
  signedPermission: 'r'
  signedExpiry: dateTimeAdd(baseTime, sasTokenValidityLength)
  signedResourceTypes: 'o'
  signedProtocol: 'https'
}

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource automationAccount 'Microsoft.Automation/automationAccounts@2020-01-13-preview' existing = {
  name: automationAccountName
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' existing = if (!empty(scriptStorageAccountId)) {
  name: last(split(scriptStorageAccountId, '/'))
  scope: resourceGroup(split(scriptStorageAccountId, '/')[2], split(scriptStorageAccountId, '/')[4])
}

var publishContentLink = empty(uri) ? null : {
  uri: !empty(uri) ? (empty(scriptStorageAccountId) ? uri : '${uri}${storageAccount.listAccountSas('2021-04-01', accountSasProperties).accountSasToken}') : null
  version: !empty(version) ? version : null
}

resource runbook 'Microsoft.Automation/automationAccounts/runbooks@2019-06-01' = {
  name: name
  parent: automationAccount
  location: location
  tags: tags
  properties: {
    runbookType: runbookType
    description: runbookDescription
    publishContentLink: !empty(uri) ? publishContentLink : null
  }
}

@description('The name of the deployed runbook')
output runbookName string = runbook.name

@description('The resource ID of the deployed runbook')
output runbookResourceId string = runbook.id

@description('The resource group of the deployed runbook')
output runbookResourceGroup string = resourceGroup().name
