@description('Conditional. The name of the parent event hub namespace. Required if the template is used in a standalone deployment.')
param namespaceName string

@description('Required. The name of the event hub.')
param name string

@description('Optional. Authorization Rules for the event hub.')
param authorizationRules array = [
  {
    name: 'RootManageSharedAccessKey'
    rights: [
      'Listen'
      'Manage'
      'Send'
    ]
  }
]

@description('Optional. Number of days to retain the events for this Event Hub, value should be 1 to 7 days.')
@minValue(1)
@maxValue(7)
param messageRetentionInDays int = 1

@description('Optional. Number of partitions created for the Event Hub, allowed values are from 1 to 32 partitions.')
@minValue(1)
@maxValue(32)
param partitionCount int = 2

@description('Optional. Enumerates the possible values for the status of the Event Hub.')
@allowed([
  'Active'
  'Creating'
  'Deleting'
  'Disabled'
  'ReceiveDisabled'
  'Renaming'
  'Restoring'
  'SendDisabled'
  'Unknown'
])
param status string = 'Active'

@description('Optional. The consumer groups to create in this event hub instance.')
param consumerGroups array = [
  {
    name: '$Default'
  }
]

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = ''

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@description('Optional. Name for capture destination.')
param captureDescriptionDestinationName string = 'EventHubArchive.AzureBlockBlob'

@description('Optional. Blob naming convention for archive, e.g. {Namespace}/{EventHub}/{PartitionId}/{Year}/{Month}/{Day}/{Hour}/{Minute}/{Second}. Here all the parameters (Namespace,EventHub .. etc) are mandatory irrespective of order.')
param captureDescriptionDestinationArchiveNameFormat string = '{Namespace}/{EventHub}/{PartitionId}/{Year}/{Month}/{Day}/{Hour}/{Minute}/{Second}'

@description('Optional. Blob container Name.')
param captureDescriptionDestinationBlobContainer string = ''

@description('Optional. Resource ID of the storage account to be used to create the blobs.')
param captureDescriptionDestinationStorageAccountResourceId string = ''

@description('Optional. A value that indicates whether capture description is enabled.')
param captureDescriptionEnabled bool = false

@description('Optional. Enumerates the possible values for the encoding format of capture description. Note: "AvroDeflate" will be deprecated in New API Version.')
@allowed([
  'Avro'
  'AvroDeflate'
])
param captureDescriptionEncoding string = 'Avro'

@description('Optional. The time window allows you to set the frequency with which the capture to Azure Blobs will happen.')
@minValue(60)
@maxValue(900)
param captureDescriptionIntervalInSeconds int = 300

@description('Optional. The size window defines the amount of data built up in your Event Hub before an capture operation.')
@minValue(10485760)
@maxValue(524288000)
param captureDescriptionSizeLimitInBytes int = 314572800

@description('Optional. A value that indicates whether to Skip Empty Archives.')
param captureDescriptionSkipEmptyArchives bool = false

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = true

var enableReferencedModulesTelemetry = false

var eventHubPropertiesSimple = {
  messageRetentionInDays: messageRetentionInDays
  partitionCount: partitionCount
  status: status
}
var eventHubPropertiesWithCapture = {
  messageRetentionInDays: messageRetentionInDays
  partitionCount: partitionCount
  status: status
  captureDescription: {
    destination: {
      name: captureDescriptionDestinationName
      properties: {
        archiveNameFormat: captureDescriptionDestinationArchiveNameFormat
        blobContainer: captureDescriptionDestinationBlobContainer
        storageAccountResourceId: captureDescriptionDestinationStorageAccountResourceId
      }
    }
    enabled: captureDescriptionEnabled
    encoding: captureDescriptionEncoding
    intervalInSeconds: captureDescriptionIntervalInSeconds
    sizeLimitInBytes: captureDescriptionSizeLimitInBytes
    skipEmptyArchives: captureDescriptionSkipEmptyArchives
  }
}

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource namespace 'Microsoft.EventHub/namespaces@2021-11-01' existing = {
  name: namespaceName
}

resource eventHub 'Microsoft.EventHub/namespaces/eventhubs@2021-11-01' = {
  name: name
  parent: namespace
  properties: captureDescriptionEnabled ? eventHubPropertiesWithCapture : eventHubPropertiesSimple
}

resource eventHub_lock 'Microsoft.Authorization/locks@2017-04-01' = if (!empty(lock)) {
  name: '${eventHub.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: eventHub
}

module eventHub_consumergroups 'consumergroups/deploy.bicep' = [for (consumerGroup, index) in consumerGroups: {
  name: '${deployment().name}-ConsumerGroup-${index}'
  params: {
    namespaceName: namespaceName
    eventHubName: eventHub.name
    name: consumerGroup.name
    userMetadata: contains(consumerGroup, 'userMetadata') ? consumerGroup.userMetadata : ''
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module eventHub_authorizationRules 'authorizationRules/deploy.bicep' = [for (authorizationRule, index) in authorizationRules: {
  name: '${deployment().name}-AuthRule-${index}'
  params: {
    namespaceName: namespaceName
    eventHubName: eventHub.name
    name: authorizationRule.name
    rights: contains(authorizationRule, 'rights') ? authorizationRule.rights : []
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module eventHub_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${deployment().name}-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    resourceId: eventHub.id
  }
}]

@description('The name of the event hub.')
output name string = eventHub.name

@description('The resource ID of the event hub.')
output eventHubId string = eventHub.id

@description('The resource group the event hub was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The authentication rule resource ID of the event hub.')
output resourceId string = az.resourceId('Microsoft.EventHub/namespaces/authorizationRules', namespaceName, 'RootManageSharedAccessKey')
