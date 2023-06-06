@description('Required. Name of the Automation Account.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. SKU name of the account.')
@allowed([
  'Free'
  'Basic'
])
param skuName string = 'Basic'

@description('Conditional. The resource ID of a key vault to reference a customer managed key for encryption from. Required if \'cMKKeyName\' is not empty.')
param cMKKeyVaultResourceId string = ''

@description('Optional. The name of the customer managed key to use for encryption.')
param cMKKeyName string = ''

@description('Conditional. User assigned identity to use when fetching the customer managed key. Required if \'cMKKeyName\' is not empty.')
param cMKUserAssignedIdentityResourceId string = ''

@description('Optional. The version of the customer managed key to reference for encryption. If not provided, the latest key version is used.')
param cMKKeyVersion string = ''

@description('Optional. List of modules to be created in the automation account.')
param modules array = []

@description('Optional. List of runbooks to be created in the automation account.')
param runbooks array = []

@description('Optional. List of schedules to be created in the automation account.')
param schedules array = []

@description('Optional. List of jobSchedules to be created in the automation account.')
param jobSchedules array = []

@description('Optional. List of variables to be created in the automation account.')
param variables array = []

@description('Optional. ID of the log analytics workspace to be linked to the deployed automation account.')
param linkedWorkspaceResourceId string = ''

@description('Optional. List of gallerySolutions to be created in the linked log analytics workspace.')
param gallerySolutions array = []

@description('Optional. List of softwareUpdateConfigurations to be created in the automation account.')
param softwareUpdateConfigurations array = []

@description('Optional. Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set.')
@allowed([
  ''
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = ''

@description('Optional. Disable local authentication profile used within the resource.')
param disableLocalAuth bool = true

@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints array = []

@minValue(0)
@maxValue(365)
@description('Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.')
param diagnosticLogsRetentionInDays int = 365

@description('Optional. Resource ID of the diagnostic storage account.')
param diagnosticStorageAccountId string = ''

@description('Optional. Resource ID of the diagnostic log analytics workspace.')
param diagnosticWorkspaceId string = ''

@description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
param diagnosticEventHubAuthorizationRuleId string = ''

@description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.')
param diagnosticEventHubName string = ''

@description('Optional. Enables system assigned managed identity on the resource.')
param systemAssignedIdentity bool = false

@description('Optional. The ID(s) to assign to the resource.')
param userAssignedIdentities object = {}

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = ''

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@description('Optional. Tags of the Automation Account resource.')
param tags object = {}

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource.')
@allowed([
  'allLogs'
  'JobLogs'
  'JobStreams'
  'DscNodeStatus'
])
param diagnosticLogCategoriesToEnable array = [
  'allLogs'
]

@description('Optional. The name of metrics that will be streamed.')
@allowed([
  'AllMetrics'
])
param diagnosticMetricsToEnable array = [
  'AllMetrics'
]

@description('Optional. The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings".')
param diagnosticSettingsName string = ''

var enableReferencedModulesTelemetry = false

var diagnosticsLogsSpecified = [for category in filter(diagnosticLogCategoriesToEnable, item => item != 'allLogs'): {
  category: category
  enabled: true
  retentionPolicy: {
    enabled: true
    days: diagnosticLogsRetentionInDays
  }
}]

var diagnosticsLogs = contains(diagnosticLogCategoriesToEnable, 'allLogs') ? [
  {
    categoryGroup: 'allLogs'
    enabled: true
    retentionPolicy: {
      enabled: true
      days: diagnosticLogsRetentionInDays
    }
  }
] : diagnosticsLogsSpecified

var diagnosticsMetrics = [for metric in diagnosticMetricsToEnable: {
  category: metric
  timeGrain: null
  enabled: true
  retentionPolicy: {
    enabled: true
    days: diagnosticLogsRetentionInDays
  }
}]

var identityType = systemAssignedIdentity ? (!empty(userAssignedIdentities) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned') : (!empty(userAssignedIdentities) ? 'UserAssigned' : 'None')

var identity = identityType != 'None' ? {
  type: identityType
  userAssignedIdentities: !empty(userAssignedIdentities) ? userAssignedIdentities : null
} : null

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

resource cMKKeyVault 'Microsoft.KeyVault/vaults@2021-10-01' existing = if (!empty(cMKKeyVaultResourceId)) {
  name: last(split(cMKKeyVaultResourceId, '/'))!
  scope: resourceGroup(split(cMKKeyVaultResourceId, '/')[2], split(cMKKeyVaultResourceId, '/')[4])
}

resource cMKKeyVaultKey 'Microsoft.KeyVault/vaults/keys@2021-10-01' existing = if (!empty(cMKKeyVaultResourceId) && !empty(cMKKeyName)) {
  name: '${last(split(cMKKeyVaultResourceId, '/'))}/${cMKKeyName}'!
  scope: resourceGroup(split(cMKKeyVaultResourceId, '/')[2], split(cMKKeyVaultResourceId, '/')[4])
}

resource automationAccount 'Microsoft.Automation/automationAccounts@2022-08-08' = {
  name: name
  location: location
  tags: tags
  identity: identity
  properties: {
    sku: {
      name: skuName
    }
    encryption: !empty(cMKKeyName) ? {
      keySource: 'Microsoft.KeyVault'
      identity: {
        userAssignedIdentity: cMKUserAssignedIdentityResourceId
      }
      keyVaultProperties: {
        keyName: cMKKeyName
        keyVaultUri: cMKKeyVault.properties.vaultUri
        keyVersion: !empty(cMKKeyVersion) ? cMKKeyVersion : last(split(cMKKeyVaultKey.properties.keyUriWithVersion, '/'))
      }
    } : null
    publicNetworkAccess: !empty(publicNetworkAccess) ? (publicNetworkAccess == 'Disabled' ? false : true) : (!empty(privateEndpoints) ? false : null)
    disableLocalAuth: disableLocalAuth
  }
}

module automationAccount_modules 'modules/main.bicep' = [for (module, index) in modules: {
  name: '${uniqueString(deployment().name, location)}-AutoAccount-Module-${index}'
  params: {
    name: module.name
    automationAccountName: automationAccount.name
    version: module.version
    uri: module.uri
    location: location
    tags: tags
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module automationAccount_schedules 'schedules/main.bicep' = [for (schedule, index) in schedules: {
  name: '${uniqueString(deployment().name, location)}-AutoAccount-Schedule-${index}'
  params: {
    name: schedule.name
    automationAccountName: automationAccount.name
    advancedSchedule: contains(schedule, 'advancedSchedule') ? schedule.advancedSchedule : null
    description: contains(schedule, 'description') ? schedule.description : ''
    expiryTime: contains(schedule, 'expiryTime') ? schedule.expiryTime : ''
    frequency: contains(schedule, 'frequency') ? schedule.frequency : 'OneTime'
    interval: contains(schedule, 'interval') ? schedule.interval : 0
    startTime: contains(schedule, 'startTime') ? schedule.startTime : ''
    timeZone: contains(schedule, 'timeZone') ? schedule.timeZone : ''
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module automationAccount_runbooks 'runbooks/main.bicep' = [for (runbook, index) in runbooks: {
  name: '${uniqueString(deployment().name, location)}-AutoAccount-Runbook-${index}'
  params: {
    name: runbook.name
    automationAccountName: automationAccount.name
    type: runbook.type
    description: contains(runbook, 'description') ? runbook.description : ''
    uri: contains(runbook, 'uri') ? runbook.uri : ''
    version: contains(runbook, 'version') ? runbook.version : ''
    location: location
    tags: tags
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module automationAccount_jobSchedules 'job-schedules/main.bicep' = [for (jobSchedule, index) in jobSchedules: {
  name: '${uniqueString(deployment().name, location)}-AutoAccount-JobSchedule-${index}'
  params: {
    automationAccountName: automationAccount.name
    runbookName: jobSchedule.runbookName
    scheduleName: jobSchedule.scheduleName
    parameters: contains(jobSchedule, 'parameters') ? jobSchedule.parameters : {}
    runOn: contains(jobSchedule, 'runOn') ? jobSchedule.runOn : ''
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
  dependsOn: [
    automationAccount_schedules
    automationAccount_runbooks
  ]
}]

module automationAccount_variables 'variables/main.bicep' = [for (variable, index) in variables: {
  name: '${uniqueString(deployment().name, location)}-AutoAccount-Variable-${index}'
  params: {
    automationAccountName: automationAccount.name
    name: variable.name
    description: contains(variable, 'description') ? variable.description : ''
    value: variable.value
    isEncrypted: contains(variable, 'isEncrypted') ? variable.isEncrypted : true
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module automationAccount_linkedService '../../operational-insights/workspaces/linked-services/main.bicep' = if (!empty(linkedWorkspaceResourceId)) {
  name: '${uniqueString(deployment().name, location)}-AutoAccount-LinkedService'
  params: {
    name: 'automation'
    logAnalyticsWorkspaceName: last(split(linkedWorkspaceResourceId, '/'))!
    enableDefaultTelemetry: enableReferencedModulesTelemetry
    resourceId: automationAccount.id
    tags: tags
  }
  // This is to support linked services to law in different subscription and resource group than the automation account.
  // The current scope is used by default if no linked service is intended to be created.
  scope: resourceGroup(!empty(linkedWorkspaceResourceId) ? split(linkedWorkspaceResourceId, '/')[2] : subscription().subscriptionId, !empty(linkedWorkspaceResourceId) ? split(linkedWorkspaceResourceId, '/')[4] : resourceGroup().name)
}

module automationAccount_solutions '../../operations-management/solutions/main.bicep' = [for (gallerySolution, index) in gallerySolutions: if (!empty(linkedWorkspaceResourceId)) {
  name: '${uniqueString(deployment().name, location)}-AutoAccount-Solution-${index}'
  params: {
    name: gallerySolution.name
    location: location
    logAnalyticsWorkspaceName: last(split(linkedWorkspaceResourceId, '/'))!
    product: contains(gallerySolution, 'product') ? gallerySolution.product : 'OMSGallery'
    publisher: contains(gallerySolution, 'publisher') ? gallerySolution.publisher : 'Microsoft'
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
  // This is to support solution to law in different subscription and resource group than the automation account.
  // The current scope is used by default if no linked service is intended to be created.
  scope: resourceGroup(!empty(linkedWorkspaceResourceId) ? split(linkedWorkspaceResourceId, '/')[2] : subscription().subscriptionId, !empty(linkedWorkspaceResourceId) ? split(linkedWorkspaceResourceId, '/')[4] : resourceGroup().name)
  dependsOn: [
    automationAccount_linkedService
  ]
}]

module automationAccount_softwareUpdateConfigurations 'software-update-configurations/main.bicep' = [for (softwareUpdateConfiguration, index) in softwareUpdateConfigurations: {
  name: '${uniqueString(deployment().name, location)}-AutoAccount-SwUpdateConfig-${index}'
  params: {
    name: softwareUpdateConfiguration.name
    automationAccountName: automationAccount.name
    frequency: softwareUpdateConfiguration.frequency
    operatingSystem: softwareUpdateConfiguration.operatingSystem
    rebootSetting: softwareUpdateConfiguration.rebootSetting
    azureVirtualMachines: contains(softwareUpdateConfiguration, 'azureVirtualMachines') ? softwareUpdateConfiguration.azureVirtualMachines : []
    excludeUpdates: contains(softwareUpdateConfiguration, 'excludeUpdates') ? softwareUpdateConfiguration.excludeUpdates : []
    expiryTime: contains(softwareUpdateConfiguration, 'expiryTime') ? softwareUpdateConfiguration.expiryTime : ''
    expiryTimeOffsetMinutes: contains(softwareUpdateConfiguration, 'expiryTimeOffsetMinutes') ? softwareUpdateConfiguration.expiryTimeOffsetMinute : 0
    includeUpdates: contains(softwareUpdateConfiguration, 'includeUpdates') ? softwareUpdateConfiguration.includeUpdates : []
    interval: contains(softwareUpdateConfiguration, 'interval') ? softwareUpdateConfiguration.interval : 1
    isEnabled: contains(softwareUpdateConfiguration, 'isEnabled') ? softwareUpdateConfiguration.isEnabled : true
    maintenanceWindow: contains(softwareUpdateConfiguration, 'maintenanceWindow') ? softwareUpdateConfiguration.maintenanceWindow : 'PT2H'
    monthDays: contains(softwareUpdateConfiguration, 'monthDays') ? softwareUpdateConfiguration.monthDays : []
    monthlyOccurrences: contains(softwareUpdateConfiguration, 'monthlyOccurrences') ? softwareUpdateConfiguration.monthlyOccurrences : []
    nextRun: contains(softwareUpdateConfiguration, 'nextRun') ? softwareUpdateConfiguration.nextRun : ''
    nextRunOffsetMinutes: contains(softwareUpdateConfiguration, 'nextRunOffsetMinutes') ? softwareUpdateConfiguration.nextRunOffsetMinutes : 0
    nonAzureComputerNames: contains(softwareUpdateConfiguration, 'nonAzureComputerNames') ? softwareUpdateConfiguration.nonAzureComputerNames : []
    nonAzureQueries: contains(softwareUpdateConfiguration, 'nonAzureQueries') ? softwareUpdateConfiguration.nonAzureQueries : []
    postTaskParameters: contains(softwareUpdateConfiguration, 'postTaskParameters') ? softwareUpdateConfiguration.postTaskParameters : {}
    postTaskSource: contains(softwareUpdateConfiguration, 'postTaskSource') ? softwareUpdateConfiguration.postTaskSource : ''
    preTaskParameters: contains(softwareUpdateConfiguration, 'preTaskParameters') ? softwareUpdateConfiguration.preTaskParameters : {}
    preTaskSource: contains(softwareUpdateConfiguration, 'preTaskSource') ? softwareUpdateConfiguration.preTaskSource : ''
    scheduleDescription: contains(softwareUpdateConfiguration, 'scheduleDescription') ? softwareUpdateConfiguration.scheduleDescription : ''
    scopeByLocations: contains(softwareUpdateConfiguration, 'scopeByLocations') ? softwareUpdateConfiguration.scopeByLocations : []
    scopeByResources: contains(softwareUpdateConfiguration, 'scopeByResources') ? softwareUpdateConfiguration.scopeByResources : [
      subscription().id
    ]
    scopeByTags: contains(softwareUpdateConfiguration, 'scopeByTags') ? softwareUpdateConfiguration.scopeByTags : {}
    scopeByTagsOperation: contains(softwareUpdateConfiguration, 'scopeByTagsOperation') ? softwareUpdateConfiguration.scopeByTagsOperation : 'All'
    startTime: contains(softwareUpdateConfiguration, 'startTime') ? softwareUpdateConfiguration.startTime : ''
    timeZone: contains(softwareUpdateConfiguration, 'timeZone') ? softwareUpdateConfiguration.timeZone : 'UTC'
    updateClassifications: contains(softwareUpdateConfiguration, 'updateClassifications') ? softwareUpdateConfiguration.updateClassifications : [
      'Critical'
      'Security'
    ]
    weekDays: contains(softwareUpdateConfiguration, 'weekDays') ? softwareUpdateConfiguration.weekDays : []
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
  dependsOn: [
    automationAccount_solutions
  ]
}]

resource automationAccount_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock)) {
  name: '${automationAccount.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: automationAccount
}

resource automationAccount_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(diagnosticWorkspaceId)) || (!empty(diagnosticEventHubAuthorizationRuleId)) || (!empty(diagnosticEventHubName))) {
  name: !empty(diagnosticSettingsName) ? diagnosticSettingsName : '${name}-diagnosticSettings'
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(diagnosticWorkspaceId) ? diagnosticWorkspaceId : null
    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null
    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null
    metrics: diagnosticsMetrics
    logs: diagnosticsLogs
  }
  scope: automationAccount
}

module automationAccount_privateEndpoints '../../network/private-endpoints/main.bicep' = [for (privateEndpoint, index) in privateEndpoints: {
  name: '${uniqueString(deployment().name, location)}-AutomationAccount-PrivateEndpoint-${index}'
  params: {
    groupIds: [
      privateEndpoint.service
    ]
    name: contains(privateEndpoint, 'name') ? privateEndpoint.name : 'pe-${last(split(automationAccount.id, '/'))}-${privateEndpoint.service}-${index}'
    serviceResourceId: automationAccount.id
    subnetResourceId: privateEndpoint.subnetResourceId
    enableDefaultTelemetry: enableReferencedModulesTelemetry
    location: reference(split(privateEndpoint.subnetResourceId, '/subnets/')[0], '2020-06-01', 'Full').location
    lock: contains(privateEndpoint, 'lock') ? privateEndpoint.lock : lock
    privateDnsZoneGroup: contains(privateEndpoint, 'privateDnsZoneGroup') ? privateEndpoint.privateDnsZoneGroup : {}
    roleAssignments: contains(privateEndpoint, 'roleAssignments') ? privateEndpoint.roleAssignments : []
    tags: contains(privateEndpoint, 'tags') ? privateEndpoint.tags : {}
    manualPrivateLinkServiceConnections: contains(privateEndpoint, 'manualPrivateLinkServiceConnections') ? privateEndpoint.manualPrivateLinkServiceConnections : []
    customDnsConfigs: contains(privateEndpoint, 'customDnsConfigs') ? privateEndpoint.customDnsConfigs : []
    ipConfigurations: contains(privateEndpoint, 'ipConfigurations') ? privateEndpoint.ipConfigurations : []
    applicationSecurityGroups: contains(privateEndpoint, 'applicationSecurityGroups') ? privateEndpoint.applicationSecurityGroups : []
    customNetworkInterfaceName: contains(privateEndpoint, 'customNetworkInterfaceName') ? privateEndpoint.customNetworkInterfaceName : ''
  }
}]

module automationAccount_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-AutoAccount-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: automationAccount.id
  }
}]

@description('The name of the deployed automation account.')
output name string = automationAccount.name

@description('The resource ID of the deployed automation account.')
output resourceId string = automationAccount.id

@description('The resource group of the deployed automation account.')
output resourceGroupName string = resourceGroup().name

@description('The principal ID of the system assigned identity.')
output systemAssignedPrincipalId string = systemAssignedIdentity && contains(automationAccount.identity, 'principalId') ? automationAccount.identity.principalId : ''

@description('The location the resource was deployed into.')
output location string = automationAccount.location
