metadata name = 'Relay Namespace WCF Relays'
metadata description = 'This module deploys a Relay Namespace WCF Relay.'
metadata owner = 'Azure/module-maintainers'

@description('Conditional. The name of the parent Relay Namespace for the WCF Relay. Required if the template is used in a standalone deployment.')
@minLength(6)
@maxLength(50)
param namespaceName string

@description('Required. Name of the WCF Relay.')
@minLength(6)
@maxLength(50)
param name string

@allowed([
  'Http'
  'NetTcp'
])
@description('Required. Type of WCF Relay.')
param relayType string

@description('Optional. A value indicating if this relay requires client authorization.')
param requiresClientAuthorization bool = true

@description('Optional. A value indicating if this relay requires transport security.')
param requiresTransportSecurity bool = true

@description('Optional. User-defined string data for the WCF Relay.')
param userMetadata string = ''

@description('Optional. Authorization Rules for the WCF Relay.')
param authorizationRules array = [
  {
    name: 'RootManageSharedAccessKey'
    rights: [
      'Listen'
      'Manage'
      'Send'
    ]
  }
  {
    name: 'defaultListener'
    rights: [
      'Listen'
    ]
  }
  {
    name: 'defaultSender'
    rights: [
      'Send'
    ]
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

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

var enableReferencedModulesTelemetry = false

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

resource namespace 'Microsoft.Relay/namespaces@2021-11-01' existing = {
  name: namespaceName
}

resource wcfRelay 'Microsoft.Relay/namespaces/wcfRelays@2021-11-01' = {
  name: name
  parent: namespace
  properties: {
    relayType: relayType
    requiresClientAuthorization: requiresClientAuthorization
    requiresTransportSecurity: requiresTransportSecurity
    userMetadata: !empty(userMetadata) ? userMetadata : null
  }
}

module wcfRelay_authorizationRules 'authorization-rule/main.bicep' = [for (authorizationRule, index) in authorizationRules: {
  name: '${deployment().name}-AuthorizationRule-${index}'
  params: {
    namespaceName: namespaceName
    wcfRelayName: wcfRelay.name
    name: authorizationRule.name
    rights: contains(authorizationRule, 'rights') ? authorizationRule.rights : []
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

resource wcfRelay_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock)) {
  name: '${wcfRelay.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: wcfRelay
}

module wcfRelay_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${deployment().name}-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: wcfRelay.id
  }
}]

@description('The name of the deployed wcf relay.')
output name string = wcfRelay.name

@description('The resource ID of the deployed wcf relay.')
output resourceId string = wcfRelay.id

@description('The resource group of the deployed wcf relay.')
output resourceGroupName string = resourceGroup().name
