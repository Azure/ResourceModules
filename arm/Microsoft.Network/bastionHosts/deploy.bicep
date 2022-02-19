@description('Required. Name of the Azure Bastion resource')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Required. Shared services Virtual Network resource identifier')
param vNetId string

@description('Optional. Specifies the resource ID of the existing public IP to be leveraged by Azure Bastion.')
param publicIPAddressId string = ''

@description('Optional. Specifies the properties of the public IP to create and be used by Azure Bastion. If it\'s not provided and publicIPAddressId is empty, a \'-pip\' suffix will be appended to the Bastion\'s name.')
param publicIPAddressObject object = {}

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

@allowed([
  'CanNotDelete'
  'NotSpecified'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = 'NotSpecified'

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

@description('Optional. Optional. The name of bastion logs that will be streamed.')
@allowed([
  'BastionAuditLogs'
])
param logsToEnable array = [
  'BastionAuditLogs'
]

var diagnosticsLogs = [for log in logsToEnable: {
  category: log
  enabled: true
  retentionPolicy: {
    enabled: true
    days: diagnosticLogsRetentionInDays
  }
}]

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource publicIPAddressExisting 'Microsoft.Network/publicIPAddresses@2021-05-01' existing = if (!empty(publicIPAddressId)) {
  name: last(split(publicIPAddressId, '/'))
  scope: resourceGroup(split(publicIPAddressId, '/')[2], split(publicIPAddressId, '/')[4])
}

module publicIPAddress '.bicep/nested_publicIPAddress.bicep' = if (empty(publicIPAddressId)) {
  name: '${uniqueString(deployment().name, location)}-Bastion-PIP'
  params: {
    name: contains(publicIPAddressObject, 'name') ? (!(empty(publicIPAddressObject.name)) ? publicIPAddressObject.name : '${name}-pip') : '${name}-pip'
    publicIPPrefixResourceId: contains(publicIPAddressObject, 'publicIPPrefixResourceId') ? (!(empty(publicIPAddressObject.publicIPPrefixResourceId)) ? publicIPAddressObject.publicIPPrefixResourceId : '') : ''
    publicIPAllocationMethod: contains(publicIPAddressObject, 'publicIPAllocationMethod') ? (!(empty(publicIPAddressObject.publicIPAllocationMethod)) ? publicIPAddressObject.publicIPAllocationMethod : 'Static') : 'Static'
    skuName: contains(publicIPAddressObject, 'skuName') ? (!(empty(publicIPAddressObject.skuName)) ? publicIPAddressObject.skuName : 'Standard') : 'Standard'
    skuTier: contains(publicIPAddressObject, 'skuTier') ? (!(empty(publicIPAddressObject.skuTier)) ? publicIPAddressObject.skuTier : 'Regional') : 'Regional'
    roleAssignments: contains(publicIPAddressObject, 'roleAssignments') ? (!empty(publicIPAddressObject.roleAssignments) ? publicIPAddressObject.roleAssignments : []) : []
    metricsToEnable: contains(publicIPAddressObject, 'metricsToEnable') ? (!(empty(publicIPAddressObject.metricsToEnable)) ? publicIPAddressObject.metricsToEnable : [
      'AllMetrics'
    ]) : [
      'AllMetrics'
    ]
    logsToEnable: contains(publicIPAddressObject, 'logsToEnable') ? (!(empty(publicIPAddressObject.logsToEnable)) ? publicIPAddressObject.logsToEnable : [
      'DDoSProtectionNotifications'
      'DDoSMitigationFlowLogs'
      'DDoSMitigationReports'
    ]) : [
      'DDoSProtectionNotifications'
      'DDoSMitigationFlowLogs'
      'DDoSMitigationReports'
    ]
    location: location
    diagnosticStorageAccountId: diagnosticStorageAccountId
    diagnosticLogsRetentionInDays: diagnosticLogsRetentionInDays
    diagnosticWorkspaceId: diagnosticWorkspaceId
    diagnosticEventHubAuthorizationRuleId: diagnosticEventHubAuthorizationRuleId
    diagnosticEventHubName: diagnosticEventHubName
    lock: lock
    tags: tags
  }
}

resource azureBastion 'Microsoft.Network/bastionHosts@2021-05-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    ipConfigurations: [
      {
        name: 'IpConf'
        properties: {
          subnet: {
            id: '${vNetId}/subnets/AzureBastionSubnet'
          }
          publicIPAddress: {
            id: !(empty(publicIPAddressId)) ? publicIPAddressId : publicIPAddress.outputs.resourceId
          }
        }
      }
    ]
  }
}

resource azureBastion_lock 'Microsoft.Authorization/locks@2017-04-01' = if (lock != 'NotSpecified') {
  name: '${azureBastion.name}-${lock}-lock'
  properties: {
    level: lock
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: azureBastion
}

resource azureBastion_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (!empty(diagnosticStorageAccountId) || !empty(diagnosticWorkspaceId) || !empty(diagnosticEventHubAuthorizationRuleId) || !empty(diagnosticEventHubName)) {
  name: '${azureBastion.name}-diagnosticSettings'
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(diagnosticWorkspaceId) ? diagnosticWorkspaceId : null
    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null
    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null
    logs: diagnosticsLogs
  }
  scope: azureBastion
}

module azureBastion_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-Bastion-Rbac-${index}'
  params: {
    principalIds: roleAssignment.principalIds
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    resourceId: azureBastion.id
  }
}]

@description('The resource group the Azure Bastion was deployed into')
output resourceGroupName string = resourceGroup().name

@description('The name the Azure Bastion')
output name string = azureBastion.name

@description('The resource ID the Azure Bastion')
output resourceId string = azureBastion.id
