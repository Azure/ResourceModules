@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Required. Name of the network watcher resource. Must be in the resource group where the Flow log will be created and same region as the NSG')
param networkWatcherName string

@description('Required. Resource ID of the NSG that must be enabled for Flow Logs.')
param networkSecurityGroupResourceId string

@description('Required. Resource identifier of the Diagnostic Storage Account.')
param diagnosticStorageAccountId string

@description('Optional. If the flow log retention should be enabled')
param retentionEnabled bool = true

@description('Optional. If the flow log should be enabled')
param flowLogEnabled bool = true

@description('Optional. The flow log format version')
@allowed([
  1
  2
])
param logFormatVersion int = 2

@description('Optional. Enables/disables flow analytics. If Flow Analytics was previously enabled, workspaceResourceID is mandatory (even when disabling it)')
param flowAnalyticsEnabled bool = false

@description('Optional. Resource identifier of Log Analytics.')
param workspaceResourceId string = ''

@description('Optional. The interval in minutes which would decide how frequently TA service should do flow analytics.')
@allowed([
  10
  60
])
param flowLogIntervalInMinutes int = 60

@description('Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.')
@minValue(0)
@maxValue(365)
param retentionInDays int = 365

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

var nsgName = split(networkSecurityGroupResourceId, '/')[8]
var fullFlowLogName = '${networkWatcherName}/${uniqueString(nsgName)}'
var flowAnalyticsConfig = {
  networkWatcherFlowAnalyticsConfiguration: {
    enabled: flowAnalyticsEnabled
    workspaceResourceId: workspaceResourceId
    trafficAnalyticsInterval: flowLogIntervalInMinutes
  }
}

module pid_cuaId './.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource flowLog 'Microsoft.Network/networkWatchers/flowLogs@2021-05-01' = {
  name: fullFlowLogName
  location: location
  tags: tags
  properties: {
    targetResourceId: networkSecurityGroupResourceId
    storageId: diagnosticStorageAccountId
    enabled: flowLogEnabled
    retentionPolicy: {
      days: retentionInDays
      enabled: retentionEnabled
    }
    format: {
      type: 'JSON'
      version: logFormatVersion
    }
    flowAnalyticsConfiguration: (empty(workspaceResourceId) ? json('null') : flowAnalyticsConfig)
  }
}

output deploymentResourceGroup string = resourceGroup().name
output flowLogResourceId string = flowLog.id
output flowLogName string = flowLog.name
