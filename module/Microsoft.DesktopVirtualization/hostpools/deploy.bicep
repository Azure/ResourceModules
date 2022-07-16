@description('Required. Name of the Host Pool.')
@minLength(1)
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. The friendly name of the Host Pool to be created.')
param hostpoolFriendlyName string = ''

@description('Optional. The description of the Host Pool to be created.')
param hostpoolDescription string = ''

@description('Optional. Set this parameter to Personal if you would like to enable Persistent Desktop experience. Defaults to Pooled.')
@allowed([
  'Personal'
  'Pooled'
])
param hostpoolType string = 'Pooled'

@description('Optional. Set the type of assignment for a Personal Host Pool type.')
@allowed([
  'Automatic'
  'Direct'
  ''
])
param personalDesktopAssignmentType string = ''

@description('Optional. Type of load balancer algorithm.')
@allowed([
  'BreadthFirst'
  'DepthFirst'
  'Persistent'
])
param loadBalancerType string = 'BreadthFirst'

@description('Optional. Maximum number of sessions.')
param maxSessionLimit int = 99999

@description('Optional. Host Pool RDP properties.')
param customRdpProperty string = 'audiocapturemode:i:1;audiomode:i:0;drivestoredirect:s:;redirectclipboard:i:1;redirectcomports:i:1;redirectprinters:i:1;redirectsmartcards:i:1;screen mode id:i:2;'

@description('Optional. Validation host pools allows you to test service changes before they are deployed to production. When set to true, the Host Pool will be deployed in a validation \'ring\' (environment) that receives all the new features (might be less stable). Defaults to false that stands for the stable, production-ready environment.')
param validationEnvironment bool = false

@description('Optional. The necessary information for adding more VMs to this Host Pool.')
param vmTemplate object = {}

@description('Optional. Host Pool token validity length. Usage: \'PT8H\' - valid for 8 hours; \'P5D\' - valid for 5 days; \'P1Y\' - valid for 1 year. When not provided, the token will be valid for 8 hours.')
param tokenValidityLength string = 'PT8H'

@description('Generated. Do not provide a value! This date value is used to generate a registration token.')
param baseTime string = utcNow('u')

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
  ''
  'CanNotDelete'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = ''

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. The type of preferred application group type, default to Desktop Application Group.')
@allowed([
  'Desktop'
  'None'
  'RailApplications'
])
param preferredAppGroupType string = 'Desktop'

@description('Optional. Enable Start VM on connect to allow users to start the virtual machine from a deallocated state. Important: Custom RBAC role required to power manage VMs.')
param startVMOnConnect bool = false

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalIds\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@description('Optional. The name of logs that will be streamed.')
@allowed([
  'Checkpoint'
  'Error'
  'Management'
  'Connection'
  'HostRegistration'
  'AgentHealthStatus'
])
param diagnosticLogCategoriesToEnable array = [
  'Checkpoint'
  'Error'
  'Management'
  'Connection'
  'HostRegistration'
  'AgentHealthStatus'
]

@description('Optional. The name of the diagnostic setting, if deployed.')
param diagnosticSettingsName string = '${name}-diagnosticSettings'

var diagnosticsLogs = [for category in diagnosticLogCategoriesToEnable: {
  category: category
  enabled: true
  retentionPolicy: {
    enabled: true
    days: diagnosticLogsRetentionInDays
  }
}]

var tokenExpirationTime = dateTimeAdd(baseTime, tokenValidityLength)

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name, location)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource hostPool 'Microsoft.DesktopVirtualization/hostpools@2021-07-12' = {
  name: name
  location: location
  tags: tags
  properties: {
    friendlyName: hostpoolFriendlyName
    description: hostpoolDescription
    hostPoolType: hostpoolType
    customRdpProperty: customRdpProperty
    personalDesktopAssignmentType: any(personalDesktopAssignmentType)
    preferredAppGroupType: preferredAppGroupType
    maxSessionLimit: maxSessionLimit
    loadBalancerType: loadBalancerType
    startVMOnConnect: startVMOnConnect
    validationEnvironment: validationEnvironment
    registrationInfo: {
      expirationTime: tokenExpirationTime
      token: null
      registrationTokenOperation: 'Update'
    }
    vmTemplate: ((!empty(vmTemplate)) ? null : string(vmTemplate))
  }
}

resource hostPool_lock 'Microsoft.Authorization/locks@2017-04-01' = if (!empty(lock)) {
  name: '${hostPool.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: hostPool
}

resource hostPool_diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2021-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(diagnosticWorkspaceId)) || (!empty(diagnosticEventHubAuthorizationRuleId)) || (!empty(diagnosticEventHubName))) {
  name: diagnosticSettingsName
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(diagnosticWorkspaceId) ? diagnosticWorkspaceId : null
    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null
    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null
    logs: diagnosticsLogs
  }
  scope: hostPool
}

module hostPool_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-HostPool-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    resourceId: hostPool.id
  }
}]

@description('The resource ID of the AVD host pool.')
output resourceId string = hostPool.id

@description('The resource group the AVD host pool was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The name of the AVD host pool.')
output name string = hostPool.name

@description('The expiration time for the registration token.')
output tokenExpirationTime string = dateTimeAdd(baseTime, tokenValidityLength)

@description('The location the resource was deployed into.')
output location string = hostPool.location
