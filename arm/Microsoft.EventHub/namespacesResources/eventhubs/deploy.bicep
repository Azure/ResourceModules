@description('Required. The name of the EventHub namespace')
param namespaceName string

@description('Required. The name of the EventHub')
param eventHubName string

@description('Optional. Authorization Rules for the Event Hub')
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

@description('Optional. Object to configure all properties of an Event Hub instance')
param eventHubConfiguration object = {
  properties: {
    messageRetentionInDays: 1
    partitionCount: 2
    status: 'Active'
  }
  consumerGroups: [
    {
      name: '$Default'
    }
  ]
}

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

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

var defaultSASKeyName = 'RootManageSharedAccessKey'

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource eventHub 'Microsoft.EventHub/namespaces/eventhubs@2021-06-01-preview' = {
  name: '${namespaceName}/${eventHubName}'
  tags: tags
  properties: eventHubConfiguration.properties
}

resource eventHub_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lock != 'NotSpecified') {
  name: '${last(split(eventHub.name, '/'))}-${lock}-lock'
  properties: {
    level: lock
    notes: (lock == 'CanNotDelete') ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: eventHub
}

resource eventHub_consumergroups 'Microsoft.EventHub/namespaces/eventhubs/consumergroups@2021-06-01-preview' = [for (consumerGroups, index) in eventHubConfiguration.consumerGroups: {
  name: '${eventHub.name}/${consumerGroups.name}'
}]

resource eventHub_authorizationRules 'Microsoft.EventHub/namespaces/eventhubs/authorizationRules@2021-06-01-preview' = [for authorizationRule in authorizationRules: {
  name: '${eventHub.name}/${authorizationRule.name}'
  properties: {
    rights: authorizationRule.properties.rights
  }
}]

module eventHub_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${deployment().name}-rbac-${index}'
  params: {
    roleAssignmentObj: roleAssignment
    resourceName: eventHub.name
  }
}]

@description('The Name of the Event Hub.')
output eventhubName string = eventHub.name

@description('The Resource ID of the Event Hub.')
output eventHubId string = eventHub.id

@description('The Resource Group Name of the Event Hub.')
output eventHubResourceGroup string = resourceGroup().name

@description('The AuthRuleResourceId of the Event Hub.')
output authRuleResourceId string = resourceId('Microsoft.EventHub/namespaces/authorizationRules', namespaceName, defaultSASKeyName)
