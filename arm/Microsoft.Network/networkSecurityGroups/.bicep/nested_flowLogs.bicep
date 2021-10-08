param location string
param networkSecurityGroupName string
param flowLogName string
param flowLogEnabled bool
param retentionEnabled bool
param logFormatVersion int
param diagnosticStorageAccountId string
param diagnosticLogsRetentionInDays int
param tags object
param flowLogworkspaceId string
param flowAnalyticsConfig object
param nsgResourceGroup string

resource flowLog 'Microsoft.Network/networkWatchers/flowLogs@2021-02-01' = {
  name: flowLogName
  location: location
  tags: tags
  properties: {
    targetResourceId: resourceId(nsgResourceGroup, 'Microsoft.Network/networkSecurityGroups', networkSecurityGroupName)
    storageId: diagnosticStorageAccountId
    enabled: flowLogEnabled
    retentionPolicy: {
      days: diagnosticLogsRetentionInDays
      enabled: retentionEnabled
    }
    format: {
      type: 'JSON'
      version: logFormatVersion
    }
    flowAnalyticsConfiguration: (empty(flowLogworkspaceId) ? json('null') : flowAnalyticsConfig)
  }
}

output flowLogName string = flowLog.name
output flowLogResourceId string = flowLog.id
