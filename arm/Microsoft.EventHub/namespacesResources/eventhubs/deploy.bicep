@description('Required. The name of the EventHub namespace')
param namespaceName string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

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
var builtInRoleNames = {
  'Owner': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  'Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Azure Event Hubs Data Owner': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f526a384-b230-433a-b45c-95f59c4a2dec')
  'Azure Event Hubs Data Receiver': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'a638d3c7-ab3a-418d-83e6-5f17a39d4fde')
  'Azure Event Hubs Data Sender': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '2b629674-e913-4c01-ae53-ef4638d8f975')
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

resource eventHub 'Microsoft.EventHub/namespaces/eventhubs@2017-04-01' = {
  name: '${namespaceName}/${eventHubName}'
  tags: tags
  properties: eventHubConfiguration.properties
  dependsOn: []
}

resource keyVault_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lock != 'NotSpecified') {
  name: '${eventHubName}-${lock}-lock'
  properties: {
    level: lock
    notes: (lock == 'CanNotDelete') ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: eventHub
}

resource eventHubConfiguration_consumerGroups 'Microsoft.EventHub/namespaces/eventhubs/consumergroups@2017-04-01' = [for (consumerGroups, index) in eventHubConfiguration.consumerGroups: {
  name: '${eventHub.name}/${consumerGroups.name}'
}]

resource eventHub_authorizationRules 'Microsoft.EventHub/namespaces/eventhubs/authorizationRules@2017-04-01' = [for authorizationRule in authorizationRules: if (length(authorizationRules) > 0) {
  name: '${eventHub.name}/${authorizationRule.name}'
  properties: {
    rights: authorizationRule.properties.rights
  }
}]

module eventHub_rbac './.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: 'rbac-${deployment().name}${index}'
  params: {
    roleAssignmentObj: roleAssignment
    builtInRoleNames: builtInRoleNames
    resourceName: eventHub.name
  }
}]

output namespaceName string = namespaceName
output eventHubId string = eventHub.id
output namespaceResourceGroup string = resourceGroup().name
output authRuleResourceId string = resourceId('Microsoft.EventHub/namespaces/authorizationRules', namespaceName, defaultSASKeyName)
