@description('Required. Name of the Host Pool')
@minLength(1)
param hostPoolName string

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

@description('Optional. Set the type of assignment for a Personal Host Pool type')
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

@description('Optional. Host Pool RDP properties')
param customRdpProperty string = 'audiocapturemode:i:1;audiomode:i:0;drivestoredirect:s:;redirectclipboard:i:1;redirectcomports:i:1;redirectprinters:i:1;redirectsmartcards:i:1;screen mode id:i:2;'

@description('Optional. Whether to use validation enviroment. When set to true, the Host Pool will be deployed in a validation \'ring\' (environment) that receives all the new features (might be less stable). Ddefaults to false that stands for the stable, production-ready environment.')
param validationEnviroment bool = false

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

@description('Optional. Resource identifier of the Diagnostic Storage Account.')
param diagnosticStorageAccountId string = ''

@description('Optional. Resource identifier of Log Analytics.')
param workspaceId string = ''

@description('Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
param eventHubAuthorizationRuleId string = ''

@description('Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.')
param eventHubName string = ''

@allowed([
  'CanNotDelete'
  'NotSpecified'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = 'NotSpecified'

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

@description('Optional. The type of preferred application group type, default to Desktop Application Group')
@allowed([
  'Desktop'
  'None'
  'RailApplications'
])
param preferredAppGroupType string = 'None'

@description('Optional. Enable Start VM on connect to allow users to start the virtual machine from a deallocated state. Important: Custom RBAC role required to power manage VMs.')
param startVMOnConnect bool = false

@description('Optional. Validation host pool allows you to test service changes before they are deployed to production.')
param validationEnvironment bool = false

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalIds\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or it\'s fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
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
param logsToEnable array = [
  'Checkpoint'
  'Error'
  'Management'
  'Connection'
  'HostRegistration'
  'AgentHealthStatus'
]

var diagnosticsLogs = [for log in logsToEnable: {
  category: log
  enabled: true
  retentionPolicy: {
    enabled: true
    days: diagnosticLogsRetentionInDays
  }
}]

var tokenExpirationTime = dateTimeAdd(baseTime, tokenValidityLength)

var builtInRoleNames = {
  'Owner': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  'Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Application Group Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ca6382a4-1721-4bcf-a114-ff0c70227b6b')
  'Desktop Virtualization Application Group Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '86240b0e-9422-4c43-887b-b61143f32ba8')
  'Desktop Virtualization Application Group Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'aebf23d0-b568-4e86-b8f9-fe83a2c6ab55')
  'Desktop Virtualization Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '082f0a83-3be5-4ba1-904c-961cca79b387')
  'Desktop Virtualization Host Pool Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'e307426c-f9b6-4e81-87de-d99efb3c32bc')
  'Desktop Virtualization Host Pool Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ceadfde2-b300-400a-ab7b-6143895aa822')
  'Desktop Virtualization Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '49a72310-ab8d-41df-bbb0-79b649203868')
  'Desktop Virtualization Session Host Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '2ad6aaab-ead9-4eaa-8ac5-da422f562408')
  'Desktop Virtualization User Session Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ea4bfff8-7fb4-485a-aadd-d4129a0ffaa6')
  'Log Analytics Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '92aaf0da-9dab-42b6-94a3-d43ce8d16293')
  'Log Analytics Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '73c42c96-874c-492b-b04d-ab87d138a893')
  'Managed Application Contributor Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '641177b8-a67a-45b9-a033-47bc880bb21e')
  'Managed Application Operator Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'c7393b34-138c-406f-901b-d8cf2b17e6ae')
  'Managed Applications Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b9331d33-8a36-4f8c-b097-4f54124fdb44')
  'Monitoring Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '749f88d5-cbae-40b8-bcfc-e573ddc772fa')
  'Monitoring Metrics Publisher': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3913510d-42f4-4e42-8a64-420c390055eb')
  'Monitoring Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '43d0d8ad-25c7-4714-9337-8ba259a9fe05')
  'Resource Policy Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '36243c78-bf99-498c-9df9-86d9f8d28608')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
}

module pid_cuaId './.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource hostPool 'Microsoft.DesktopVirtualization/hostpools@2021-07-12' = {
  name: hostPoolName
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
    validationEnviroment: validationEnviroment
    startVMOnConnect: startVMOnConnect
    validationEnvironment: validationEnvironment
    registrationInfo: {
      expirationTime: tokenExpirationTime
      token: null
      registrationTokenOperation: 'Update'
    }
    vmTemplate: ((!empty(vmTemplate)) ? json('null') : string(vmTemplate))
  }
}

resource hostPool_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lock != 'NotSpecified') {
  name: '${hostPool.name}-${lock}-lock'
  properties: {
    level: lock
    notes: (lock == 'CanNotDelete') ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: hostPool
}

resource hostPool_diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2017-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(workspaceId)) || (!empty(eventHubAuthorizationRuleId)) || (!empty(eventHubName))) {
  name: '${hostPoolName}-diagnosticsetting'
  properties: {
    storageAccountId: (empty(diagnosticStorageAccountId) ? json('null') : diagnosticStorageAccountId)
    workspaceId: (empty(workspaceId) ? json('null') : workspaceId)
    eventHubAuthorizationRuleId: (empty(eventHubAuthorizationRuleId) ? json('null') : eventHubAuthorizationRuleId)
    eventHubName: (empty(eventHubName) ? json('null') : eventHubName)
    logs: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? json('null') : diagnosticsLogs)
  }
  scope: hostPool
}

module hostPool_rbac './.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-Rbac-${index}'
  params: {
    roleAssignmentObj: roleAssignment
    builtInRoleNames: builtInRoleNames
    resourceName: hostPool.name
  }
}]

output hostPoolResourceId string = hostPool.id
output hostPoolResourceGroup string = resourceGroup().name
output hostPoolName string = hostPoolName
output tokenExpirationTime string = dateTimeAdd(baseTime, tokenValidityLength)
output hostpoolToken string = '${hostPool.properties.registrationInfo.token}'
