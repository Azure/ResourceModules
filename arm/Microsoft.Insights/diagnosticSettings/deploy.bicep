targetScope = 'subscription'

@description('Optional. Name of the ActivityLog diagnostic settings.')
@minLength(1)
@maxLength(260)
param name string = '${uniqueString(subscription().id)}-ActivityLog'

@description('Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.')
@minValue(0)
@maxValue(365)
param diagnosticLogsRetentionInDays int = 365

@description('Optional. Resource ID of the diagnostic storage account.')
param diagnosticStorageAccountId string = ''

@description('Optional. Resource ID of the diagnostic log analytics workspace.')
param diagnosticWorkspaceId string = ''

@description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
param diagnosticEventHubAuthorizationRuleId string = ''

@description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.')
param diagnosticEventHubName string = ''

@description('Optional. The name of logs that will be streamed.')
@allowed([
  'Administrative'
  'Security'
  'ServiceHealth'
  'Alert'
  'Recommendation'
  'Policy'
  'Autoscale'
  'ResourceHealth'
])
param logsToEnable array = [
  'Administrative'
  'Security'
  'ServiceHealth'
  'Alert'
  'Recommendation'
  'Policy'
  'Autoscale'
  'ResourceHealth'
]

var diagnosticsLogs = [for log in logsToEnable: {
  category: log
  enabled: true
  retentionPolicy: {
    enabled: true
    days: diagnosticLogsRetentionInDays
  }
}]

resource diagnosticSetting 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: name
  properties: {
    storageAccountId: (empty(diagnosticStorageAccountId) ? null : diagnosticStorageAccountId)
    workspaceId: (empty(diagnosticWorkspaceId) ? null : diagnosticWorkspaceId)
    eventHubAuthorizationRuleId: (empty(diagnosticEventHubAuthorizationRuleId) ? null : diagnosticEventHubAuthorizationRuleId)
    eventHubName: (empty(diagnosticEventHubName) ? null : diagnosticEventHubName)
    logs: ((empty(diagnosticStorageAccountId) && empty(diagnosticWorkspaceId) && empty(diagnosticEventHubAuthorizationRuleId) && empty(diagnosticEventHubName)) ? null : diagnosticsLogs)
  }
}

@description('The name of the diagnostic settings')
output diagnosticsName string = diagnosticSetting.name

@description('The resource ID of the diagnostic settings')
output diagnosticResourceId string = diagnosticSetting.id

@description('The name of the subscription to deploy into')
output subscriptionName string = subscription().displayName
