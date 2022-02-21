@description('Required. Name of the parent Service Bus Namespace for the Service Bus Topic.')
@minLength(6)
@maxLength(50)
param namespaceName string

@description('Required. Name of the Service Bus Topic.')
@minLength(6)
@maxLength(50)
param name string

@description('Optional. The maximum size of the topic in megabytes, which is the size of memory allocated for the topic. Default is 1024.')
param maxSizeInMegabytes int = 1024

@description('Optional. A value indicating if this topic requires duplicate detection.')
param requiresDuplicateDetection bool = false

@description('Optional. ISO 8601 default message timespan to live value. This is the duration after which the message expires, starting from when the message is sent to Service Bus. This is the default value used when TimeToLive is not set on a message itself.')
param defaultMessageTimeToLive string = 'P14D'

@description('Optional. Value that indicates whether server-side batched operations are enabled.')
param enableBatchedOperations bool = true

@description('Optional. ISO 8601 timeSpan structure that defines the duration of the duplicate detection history. The default value is 10 minutes.')
param duplicateDetectionHistoryTimeWindow string = 'PT10M'

@description('Optional. Maximum size (in KB) of the message payload that can be accepted by the topic. This property is only used in Premium today and default is 1024.')
param maxMessageSizeInKilobytes int = 1024

@description('Optional. Value that indicates whether the topic supports ordering.')
param supportOrdering bool = false

@description('Optional. ISO 8601 timespan idle interval after which the topic is automatically deleted. The minimum duration is 5 minutes.')
param autoDeleteOnIdle string = 'PT5M'

@description('Optional. Enumerates the possible values for the status of a messaging entity. - Active, Disabled, Restoring, SendDisabled, ReceiveDisabled, Creating, Deleting, Renaming, Unknown')
@allowed([
  'Active'
  'Disabled'
  'Restoring'
  'SendDisabled'
  'ReceiveDisabled'
  'Creating'
  'Deleting'
  'Renaming'
  'Unknown'
])
param status string = 'Active'

@description('Optional. A value that indicates whether the topic is to be partitioned across multiple message brokers.')
param enablePartitioning bool = false

@description('Optional. A value that indicates whether Express Entities are enabled. An express topic holds a message in memory temporarily before writing it to persistent storage.')
param enableExpress bool = false

@description('Optional. Authorization Rules for the Service Bus Topic')
param authorizationRules array = [
  {
    name: 'RootManageSharedAccessKey'
    properties: {
      rights: [
        'Listen'
        'Manage'
        'Send'
      ]
    }
  }
]

@allowed([
  'CanNotDelete'
  'NotSpecified'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = 'NotSpecified'

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource namespace 'Microsoft.ServiceBus/namespaces@2021-06-01-preview' existing = {
  name: namespaceName
}

resource topic 'Microsoft.ServiceBus/namespaces/topics@2021-06-01-preview' = {
  name: name
  parent: namespace
  properties: {
    autoDeleteOnIdle: autoDeleteOnIdle
    defaultMessageTimeToLive: defaultMessageTimeToLive
    duplicateDetectionHistoryTimeWindow: duplicateDetectionHistoryTimeWindow
    enableBatchedOperations: enableBatchedOperations
    enableExpress: enableExpress
    enablePartitioning: enablePartitioning
    maxMessageSizeInKilobytes: maxMessageSizeInKilobytes
    maxSizeInMegabytes: maxSizeInMegabytes
    requiresDuplicateDetection: requiresDuplicateDetection
    status: status
    supportOrdering: supportOrdering
  }
}

module topic_authorizationRules 'authorizationRules/deploy.bicep' = [for (authorizationRule, index) in authorizationRules: {
  name: '${deployment().name}-AuthRule-${index}'
  params: {
    namespaceName: namespaceName
    topicName: topic.name
    name: authorizationRule.name
    rights: contains(authorizationRule, 'rights') ? authorizationRule.rights : []
  }
}]

resource topic_lock 'Microsoft.Authorization/locks@2017-04-01' = if (lock != 'NotSpecified') {
  name: '${topic.name}-${lock}-lock'
  properties: {
    level: lock
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: topic
}

module topic_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${deployment().name}-rbac-${index}'
  params: {
    principalIds: roleAssignment.principalIds
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    resourceId: topic.id
  }
}]

@description('The name of the deployed topic')
output name string = topic.name

@description('The resource ID of the deployed topic')
output resourceId string = topic.id

@description('The resource group of the deployed topic')
output resourceGroupName string = resourceGroup().name
