@description('Required. Name of the Log Analytics workspace')
param logAnalyticsWorkspaceName string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Required. Service Tier: PerGB2018, Free, Standalone, PerGB or PerNode')
@allowed([
  'Free'
  'Standalone'
  'PerNode'
  'PerGB2018'
])
param serviceTier string = 'PerGB2018'

@description('Optional. LAW gallerySolutions from the gallery.')
param gallerySolutions array = []

@description('Required. Number of days data will be retained for')
@minValue(0)
@maxValue(730)
param dataRetention int = 365

@description('Optional. The workspace daily quota for ingestion.')
@minValue(-1)
param dailyQuotaGb int = -1

@description('Optional. The network access type for accessing Log Analytics ingestion.')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccessForIngestion string = 'Enabled'

@description('Optional. The network access type for accessing Log Analytics query.')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccessForQuery string = 'Enabled'

@description('Optional. Log Analytics workspace resource identifier')
param diagnosticStorageAccountId string = ''

@description('Optional. List of additional Subscription IDs to collect Activity logs from. The subscription holding the Log Analytics workspace is added by default. The user/SPN/managed identity has to have reader access on the subscription you\'d like to collect Activity logs from.')
param activityLogAdditionalSubscriptionIDs array = []

@description('Optional. Automation Account resource identifier, value used to create a LinkedService between Log Analytics and an Automation Account.')
param automationAccountId string = ''

@description('Optional. Set to \'true\' to use resource or workspace permissions and \'false\' (or leave empty) to require workspace permissions.')
param useResourcePermissions bool = false

@description('Optional. Switch to lock storage from deletion.')
param lockForDeletion bool = false

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

var diagnosticStorageAccountName = ((!empty(diagnosticStorageAccountId)) ? split(diagnosticStorageAccountId, '/')[8] : 'placeholder')
var logAnalyticsSearchVersion = 1
var builtInRoleNames = {
  'Owner': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  'Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Automation Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f353d9bd-d4a6-484e-a77a-8050b599b867')
  'Azure Sentinel Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ab8e14d6-4a74-4a29-9ba8-549422addade')
  'Azure Sentinel Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8d289c81-5878-46d4-8554-54e1e3d8b5cb')
  'Azure Sentinel Responder': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3e150937-b8fe-4cfb-8069-0eaf05ecd056')
  'Data Purger': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '150f5e0c-0603-4f03-8c7f-cf70034c4e90')
  'Log Analytics Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '92aaf0da-9dab-42b6-94a3-d43ce8d16293')
  'Log Analytics Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '73c42c96-874c-492b-b04d-ab87d138a893')
  'Managed Application Contributor Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '641177b8-a67a-45b9-a033-47bc880bb21e')
  'Managed Application Operator Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'c7393b34-138c-406f-901b-d8cf2b17e6ae')
  'Managed Applications Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b9331d33-8a36-4f8c-b097-4f54124fdb44')
  'Monitoring Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '749f88d5-cbae-40b8-bcfc-e573ddc772fa')
  'Monitoring Metrics Publisher': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3913510d-42f4-4e42-8a64-420c390055eb')
  'Monitoring Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '43d0d8ad-25c7-4714-9337-8ba259a9fe05')
  'Resource Policy Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '36243c78-bf99-498c-9df9-86d9f8d28608')
  'Security Admin': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'fb1c8493-542b-48eb-b624-b4c8fea62acd')
  'Security Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '39bc4728-0917-49c7-9d2c-d95423bc2eb4')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
}

module pid_cuaId './.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-08-01' = {
  location: location
  name: logAnalyticsWorkspaceName
  tags: tags
  properties: {
    features: {
      searchVersion: logAnalyticsSearchVersion
      enableLogAccessUsingOnlyResourcePermissions: useResourcePermissions
    }
    sku: {
      name: serviceTier
    }
    retentionInDays: dataRetention
    workspaceCapping: {
      dailyQuotaGb: dailyQuotaGb
    }
    publicNetworkAccessForIngestion: publicNetworkAccessForIngestion
    publicNetworkAccessForQuery: publicNetworkAccessForQuery
  }

  resource logAnalyticsWorkspace_savedSearches_VMSSQueries 'savedSearches@2020-03-01-preview' = {
    name: 'VMSSQueries'
    properties: {
      etag: '*'
      displayName: 'VMSS Instance Count'
      category: 'VDC Saved Searches'
      query: 'Event | where Source == "ServiceFabricNodeBootstrapAgent" | summarize AggregatedValue = count() by Computer'
    }
  }

  resource logAnalyticsWorkspace_savedSearches_AzureFirewallThreatDeny 'savedSearches@2020-03-01-preview' = {
    name: 'AzureFirewallThreatDeny'
    properties: {
      etag: '*'
      displayName: 'Azure Threat Deny'
      category: 'VDC Saved Searches'
      query: 'AzureDiagnostics | where ResourceType == \'AZUREFIREWALLS\' and msg_s contains \'Deny\''
    }
  }

  resource logAnalyticsWorkspace_datasources_subscriptionId 'datasources@2020-03-01-preview' = {
    kind: 'AzureActivityLog'
    name: '${subscription().subscriptionId}'
    properties: {
      linkedResourceId: '${subscription().id}/providers/microsoft.insights/eventTypes/management'
    }
  }

  resource logAnalyticsWorkspace_datasources_applicationEvent 'datasources@2020-03-01-preview' = {
    name: 'applicationEvent'
    kind: 'WindowsEvent'
    properties: {
      eventLogName: 'Application'
      eventTypes: [
        {
          eventType: 'Error'
        }
        {
          eventType: 'Warning'
        }
        {
          eventType: 'Information'
        }
      ]
    }
  }

  resource logAnalyticsWorkspace_datasources_systemEvent 'datasources@2020-03-01-preview' = {
    name: 'systemEvent'
    kind: 'WindowsEvent'
    properties: {
      eventLogName: 'System'
      eventTypes: [
        {
          eventType: 'Error'
        }
        {
          eventType: 'Warning'
        }
        {
          eventType: 'Information'
        }
      ]
    }
  }

  resource logAnalyticsWorkspace_datasources_windowsPerfCounter1 'datasources@2020-03-01-preview' = {
    name: 'windowsPerfCounter1'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'Processor'
      instanceName: '*'
      intervalSeconds: 60
      counterName: '% Processor Time'
    }
  }

  resource logAnalyticsWorkspace_datasources_windowsPerfCounter2 'datasources@2020-03-01-preview' = {
    name: 'windowsPerfCounter2'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'Processor'
      instanceName: '*'
      intervalSeconds: 60
      counterName: '% Privileged Time'
    }
  }

  resource logAnalyticsWorkspace_datasources_windowsPerfCounter3 'datasources@2020-03-01-preview' = {
    name: 'windowsPerfCounter3'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'Processor'
      instanceName: '*'
      intervalSeconds: 60
      counterName: '% User Time'
    }
  }

  resource logAnalyticsWorkspace_datasources_windowsPerfCounter4 'datasources@2020-03-01-preview' = {
    name: 'windowsPerfCounter4'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'Processor'
      instanceName: '*'
      intervalSeconds: 60
      counterName: 'Processor Frequency'
    }
  }

  resource logAnalyticsWorkspace_datasources_windowsPerfCounter5 'datasources@2020-03-01-preview' = {
    name: 'windowsPerfCounter5'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'Process'
      instanceName: '*'
      intervalSeconds: 60
      counterName: 'Thread Count'
    }
  }

  resource logAnalyticsWorkspace_datasources_windowsPerfCounter6 'datasources@2020-03-01-preview' = {
    name: 'windowsPerfCounter6'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'Process'
      instanceName: '*'
      intervalSeconds: 60
      counterName: 'Handle Count'
    }
  }

  resource logAnalyticsWorkspace_datasources_windowsPerfCounter7 'datasources@2020-03-01-preview' = {
    name: 'windowsPerfCounter7'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'System'
      instanceName: '*'
      intervalSeconds: 60
      counterName: 'System Up Time'
    }
  }

  resource logAnalyticsWorkspace_datasources_windowsPerfCounter8 'datasources@2020-03-01-preview' = {
    name: 'windowsPerfCounter8'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'System'
      instanceName: '*'
      intervalSeconds: 60
      counterName: 'Context Switches/sec'
    }
  }

  resource logAnalyticsWorkspace_datasources_windowsPerfCounter9 'datasources@2020-03-01-preview' = {
    name: 'windowsPerfCounter9'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'System'
      instanceName: '*'
      intervalSeconds: 60
      counterName: 'Processor Queue Length'
    }
  }

  resource logAnalyticsWorkspace_datasources_windowsPerfCounter10 'datasources@2020-03-01-preview' = {
    name: 'windowsPerfCounter10'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'System'
      instanceName: '*'
      intervalSeconds: 60
      counterName: 'Processes'
    }
  }

  resource logAnalyticsWorkspace_datasources_windowsPerfCounter11 'datasources@2020-03-01-preview' = {
    name: 'windowsPerfCounter11'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'Memory'
      instanceName: '*'
      intervalSeconds: 60
      counterName: '% Committed Bytes In Use'
    }
  }

  resource logAnalyticsWorkspace_datasources_windowsPerfCounter12 'datasources@2020-03-01-preview' = {
    name: 'windowsPerfCounter12'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'Memory'
      instanceName: '*'
      intervalSeconds: 60
      counterName: 'Available MBytes'
    }
  }

  resource logAnalyticsWorkspace_datasources_windowsPerfCounter13 'datasources@2020-03-01-preview' = {
    name: 'windowsPerfCounter13'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'Memory'
      instanceName: '*'
      intervalSeconds: 60
      counterName: 'Available Bytes'
    }
  }

  resource logAnalyticsWorkspace_datasources_windowsPerfCounter14 'datasources@2020-03-01-preview' = {
    name: 'windowsPerfCounter14'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'Memory'
      instanceName: '*'
      intervalSeconds: 60
      counterName: 'Committed Bytes'
    }
  }

  resource logAnalyticsWorkspace_datasources_windowsPerfCounter15 'datasources@2020-03-01-preview' = {
    name: 'windowsPerfCounter15'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'Memory'
      instanceName: '*'
      intervalSeconds: 60
      counterName: 'Cache Bytes'
    }
  }

  resource logAnalyticsWorkspace_datasources_windowsPerfCounter16 'datasources@2020-03-01-preview' = {
    name: 'windowsPerfCounter16'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'Memory'
      instanceName: '*'
      intervalSeconds: 60
      counterName: 'Pool Paged Bytes'
    }
  }

  resource logAnalyticsWorkspace_datasources_windowsPerfCounter17 'datasources@2020-03-01-preview' = {
    name: 'windowsPerfCounter17'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'Memory'
      instanceName: '*'
      intervalSeconds: 60
      counterName: 'Pool Nonpaged Bytes'
    }
  }

  resource logAnalyticsWorkspace_datasources_windowsPerfCounter18 'datasources@2020-03-01-preview' = {
    name: 'windowsPerfCounter18'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'Memory'
      instanceName: '*'
      intervalSeconds: 60
      counterName: 'Pages/sec'
    }
  }

  resource logAnalyticsWorkspace_datasources_windowsPerfCounter19 'datasources@2020-03-01-preview' = {
    name: 'windowsPerfCounter19'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'Memory'
      instanceName: '*'
      intervalSeconds: 60
      counterName: 'Page Faults/sec'
    }
  }

  resource logAnalyticsWorkspace_datasources_windowsPerfCounter20 'datasources@2020-03-01-preview' = {
    name: 'windowsPerfCounter20'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'Process'
      instanceName: '*'
      intervalSeconds: 60
      counterName: 'Working Set'
    }
  }

  resource logAnalyticsWorkspace_datasources_windowsPerfCounter21 'datasources@2020-03-01-preview' = {
    name: 'windowsPerfCounter21'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'Process'
      instanceName: '*'
      intervalSeconds: 60
      counterName: 'Working Set - Private'
    }
  }

  resource logAnalyticsWorkspace_datasources_windowsPerfCounter22 'datasources@2020-03-01-preview' = {
    name: 'windowsPerfCounter22'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'LogicalDisk'
      instanceName: '*'
      intervalSeconds: 60
      counterName: '% Disk Time'
    }
  }

  resource logAnalyticsWorkspace_datasources_windowsPerfCounter23 'datasources@2020-03-01-preview' = {
    name: 'windowsPerfCounter23'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'LogicalDisk'
      instanceName: '*'
      intervalSeconds: 60
      counterName: '% Disk Read Time'
    }
  }

  resource logAnalyticsWorkspace_datasources_windowsPerfCounter24 'datasources@2020-03-01-preview' = {
    name: 'windowsPerfCounter24'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'LogicalDisk'
      instanceName: '*'
      intervalSeconds: 60
      counterName: '% Disk Write Time'
    }
  }

  resource logAnalyticsWorkspace_datasources_windowsPerfCounter25 'datasources@2020-03-01-preview' = {
    name: 'windowsPerfCounter25'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'LogicalDisk'
      instanceName: '*'
      intervalSeconds: 60
      counterName: '% Idle Time'
    }
  }

  resource logAnalyticsWorkspace_datasources_windowsPerfCounter26 'datasources@2020-03-01-preview' = {
    name: 'windowsPerfCounter26'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'LogicalDisk'
      instanceName: '*'
      intervalSeconds: 60
      counterName: 'Disk Bytes/sec'
    }
  }

  resource logAnalyticsWorkspace_datasources_windowsPerfCounter27 'datasources@2020-03-01-preview' = {
    name: 'windowsPerfCounter27'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'LogicalDisk'
      instanceName: '*'
      intervalSeconds: 60
      counterName: 'Disk Read Bytes/sec'
    }
  }

  resource logAnalyticsWorkspace_datasources_windowsPerfCounter28 'datasources@2020-03-01-preview' = {
    name: 'windowsPerfCounter28'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'LogicalDisk'
      instanceName: '*'
      intervalSeconds: 60
      counterName: 'Disk Write Bytes/sec'
    }
  }

  resource logAnalyticsWorkspace_datasources_windowsPerfCounter29 'datasources@2020-03-01-preview' = {
    name: 'windowsPerfCounter29'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'LogicalDisk'
      instanceName: '*'
      intervalSeconds: 60
      counterName: 'Disk Transfers/sec'
    }
  }

  resource logAnalyticsWorkspace_datasources_windowsPerfCounter30 'datasources@2020-03-01-preview' = {
    name: 'windowsPerfCounter30'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'LogicalDisk'
      instanceName: '*'
      intervalSeconds: 60
      counterName: 'Disk Reads/sec'
    }
  }

  resource logAnalyticsWorkspace_datasources_windowsPerfCounter31 'datasources@2020-03-01-preview' = {
    name: 'windowsPerfCounter31'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'LogicalDisk'
      instanceName: '*'
      intervalSeconds: 60
      counterName: 'Disk Writes/sec'
    }
  }

  resource logAnalyticsWorkspace_datasources_windowsPerfCounter32 'datasources@2020-03-01-preview' = {
    name: 'windowsPerfCounter32'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'LogicalDisk'
      instanceName: '*'
      intervalSeconds: 60
      counterName: 'Avg. Disk sec/Transfer'
    }
  }

  resource logAnalyticsWorkspace_datasources_windowsPerfCounter33 'datasources@2020-03-01-preview' = {
    name: 'windowsPerfCounter33'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'LogicalDisk'
      instanceName: '*'
      intervalSeconds: 60
      counterName: 'Avg. Disk sec/Read'
    }
  }

  resource logAnalyticsWorkspace_datasources_windowsPerfCounter34 'datasources@2020-03-01-preview' = {
    name: 'windowsPerfCounter34'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'LogicalDisk'
      instanceName: '*'
      intervalSeconds: 60
      counterName: 'Avg. Disk sec/Write'
    }
  }

  resource logAnalyticsWorkspace_datasources_windowsPerfCounter35 'datasources@2020-03-01-preview' = {
    name: 'windowsPerfCounter35'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'LogicalDisk'
      instanceName: '*'
      intervalSeconds: 60
      counterName: 'Avg. Disk Queue Length'
    }
  }

  resource logAnalyticsWorkspace_datasources_windowsPerfCounter36 'datasources@2020-03-01-preview' = {
    name: 'windowsPerfCounter36'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'LogicalDisk'
      instanceName: '*'
      intervalSeconds: 60
      counterName: 'Avg. Disk Write Queue Length'
    }
  }

  resource logAnalyticsWorkspace_datasources_windowsPerfCounter37 'datasources@2020-03-01-preview' = {
    name: 'windowsPerfCounter37'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'LogicalDisk'
      instanceName: '*'
      intervalSeconds: 60
      counterName: '% Free Space'
    }
  }

  resource logAnalyticsWorkspace_datasources_windowsPerfCounter38 'datasources@2020-03-01-preview' = {
    name: 'windowsPerfCounter38'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'LogicalDisk'
      instanceName: '*'
      intervalSeconds: 60
      counterName: 'Free Megabytes'
    }
  }

  resource logAnalyticsWorkspace_datasources_windowsPerfCounter39 'datasources@2020-03-01-preview' = {
    name: 'windowsPerfCounter39'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'Network Interface'
      instanceName: '*'
      intervalSeconds: 60
      counterName: 'Bytes Total/sec'
    }
  }

  resource logAnalyticsWorkspace_datasources_windowsPerfCounter40 'datasources@2020-03-01-preview' = {
    name: 'windowsPerfCounter40'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'Network Interface'
      instanceName: '*'
      intervalSeconds: 60
      counterName: 'Bytes Sent/sec'
    }
  }

  resource logAnalyticsWorkspace_datasources_windowsPerfCounter41 'datasources@2020-03-01-preview' = {
    name: 'windowsPerfCounter41'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'Network Interface'
      instanceName: '*'
      intervalSeconds: 60
      counterName: 'Bytes Received/sec'
    }
  }

  resource logAnalyticsWorkspace_datasources_windowsPerfCounter42 'datasources@2020-03-01-preview' = {
    name: 'windowsPerfCounter42'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'Network Interface'
      instanceName: '*'
      intervalSeconds: 60
      counterName: 'Packets/sec'
    }
  }

  resource logAnalyticsWorkspace_datasources_windowsPerfCounter43 'datasources@2020-03-01-preview' = {
    name: 'windowsPerfCounter43'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'Network Interface'
      instanceName: '*'
      intervalSeconds: 60
      counterName: 'Packets Sent/sec'
    }
  }

  resource logAnalyticsWorkspace_datasources_windowsPerfCounter44 'datasources@2020-03-01-preview' = {
    name: 'windowsPerfCounter44'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'Network Interface'
      instanceName: '*'
      intervalSeconds: 60
      counterName: 'Packets Received/sec'
    }
  }

  resource logAnalyticsWorkspace_datasources_windowsPerfCounter45 'datasources@2020-03-01-preview' = {
    name: 'windowsPerfCounter45'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'Network Interface'
      instanceName: '*'
      intervalSeconds: 60
      counterName: 'Packets Outbound Errors'
    }
  }

  resource logAnalyticsWorkspace_datasources_windowsPerfCounter46 'datasources@2020-03-01-preview' = {
    name: 'windowsPerfCounter46'
    kind: 'WindowsPerformanceCounter'
    properties: {
      objectName: 'Network Interface'
      instanceName: '*'
      intervalSeconds: 60
      counterName: 'Packets Received Errors'
    }
  }

  resource logAnalyticsWorkspace_datasources_sampleIISLog1 'datasources@2020-03-01-preview' = if (false) {
    name: 'sampleIISLog1'
    kind: 'IISLogs'
    properties: {
      state: 'OnPremiseEnabled'
    }
  }

  resource logAnalyticsWorkspace_datasources_sampleSyslog1 'datasources@2020-03-01-preview' = {
    name: 'sampleSyslog1'
    kind: 'LinuxSyslog'
    properties: {
      syslogName: 'kern'
      syslogSeverities: [
        {
          severity: 'emerg'
        }
        {
          severity: 'alert'
        }
        {
          severity: 'crit'
        }
        {
          severity: 'err'
        }
        {
          severity: 'warning'
        }
      ]
    }
  }

  resource logAnalyticsWorkspace_datasources_sampleSyslogCollection1 'datasources@2020-03-01-preview' = {
    name: 'sampleSyslogCollection1'
    kind: 'LinuxSyslogCollection'
    properties: {
      state: 'Enabled'
    }
  }

  resource logAnalyticsWorkspace_datasources_sampleLinuxPerf1 'datasources@2020-03-01-preview' = {
    name: 'sampleLinuxPerf1'
    kind: 'LinuxPerformanceObject'
    properties: {
      performanceCounters: [
        {
          counterName: '% Used Inodes'
        }
        {
          counterName: 'Free Megabytes'
        }
        {
          counterName: '% Used Space'
        }
        {
          counterName: 'Disk Transfers/sec'
        }
        {
          counterName: 'Disk Reads/sec'
        }
        {
          counterName: 'Disk Writes/sec'
        }
      ]
      objectName: 'Logical Disk'
      instanceName: '*'
      intervalSeconds: 10
    }
  }

  resource logAnalyticsWorkspace_datasources_sampleLinuxPerfCollection1 'datasources@2020-03-01-preview' = {
    name: 'sampleLinuxPerfCollection1'
    kind: 'LinuxPerformanceCollection'
    properties: {
      state: 'Enabled'
    }
  }

  resource logAnalyticsWorkspace_datasources_AzureActivityLog 'datasources@2020-03-01-preview' = [for item in activityLogAdditionalSubscriptionIDs: {
    kind: 'AzureActivityLog'
    name: '${(empty(activityLogAdditionalSubscriptionIDs) ? 'placeholder' : item)}'
    properties: {
      linkedResourceId: '/subscriptions/${item}/providers/microsoft.insights/eventTypes/management'
    }
    dependsOn: [
      logAnalyticsWorkspace
    ]
  }]

  resource storageinsightconfigs 'storageinsightconfigs@2020-03-01-preview' = if (!empty(diagnosticStorageAccountId)) {
    name: '${diagnosticStorageAccountName}'
    properties: {
      containers: []
      tables: [
        'WADWindowsEventLogsTable'
        'WADETWEventTable'
        'WADServiceFabric*EventTable'
        'LinuxsyslogVer2v0'
      ]
      storageAccount: {
        id: diagnosticStorageAccountId
        key: (empty(diagnosticStorageAccountId) ? '' : listKeys(diagnosticStorageAccountId, '2016-12-01').keys[0].value)
      }
    }
  }

  resource linkedServices 'linkedServices@2020-03-01-preview' = if (!empty(automationAccountId)) {
    name: 'Automation'
    properties: {
      resourceId: automationAccountId
    }
  }
}

@batchSize(1) // Serial loop deployment
resource solution 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = [for gallerySolution in gallerySolutions: if (!empty(gallerySolutions)) {
  name: (empty(gallerySolutions) ? 'dummy' : '${gallerySolution}(${logAnalyticsWorkspaceName})')
  location: location
  properties: {
    workspaceResourceId: logAnalyticsWorkspace.id
  }
  plan: {
    name: (empty(gallerySolutions) ? 'dummy' : '${gallerySolution}(${logAnalyticsWorkspaceName})')
    product: (empty(gallerySolutions) ? 'dummy' : 'OMSGallery/${gallerySolution}')
    promotionCode: ''
    publisher: 'Microsoft'
  }
  dependsOn: [
    logAnalyticsWorkspace
  ]
}]

resource logAnalyticsWorkspace_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lockForDeletion) {
  name: '${logAnalyticsWorkspaceName}-LADoNotDelete'
  properties: {
    level: 'CanNotDelete'
  }
  scope: logAnalyticsWorkspace
}

module logAnalyticsWorkspace_rbac './.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: 'rbac-${deployment().name}${index}'
  params: {
    roleAssignmentObj: roleAssignment
    builtInRoleNames: builtInRoleNames
    resourceName: logAnalyticsWorkspace.name
  }
}]

output logAnalyticsResourceId string = logAnalyticsWorkspace.id
output logAnalyticsResourceGroup string = resourceGroup().name
output logAnalyticsName string = logAnalyticsWorkspace.name
output logAnalyticsWorkspaceId string = reference(logAnalyticsWorkspace.id, '2015-03-20').customerId
