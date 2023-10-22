metadata name = 'SignalR Web PubSub Services'
metadata description = 'This module deploys a SignalR Web PubSub Service.'
metadata owner = 'Azure/module-maintainers'

@description('Optional. The location for the resource.')
param location string = resourceGroup().location

@description('Required. The name of the Web PubSub Service resource.')
param name string

@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints array = []

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments roleAssignmentType

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. The unit count of the resource. 1 by default.')
param capacity int = 1

@allowed([
  'Free_F1'
  'Standard_S1'
])
@description('Optional. Pricing tier of the resource.')
param sku string = 'Standard_S1'

@description('Optional. Enables system assigned managed identity on the resource.')
param systemAssignedIdentity bool = false

@description('Optional. The ID(s) to assign to the resource.')
param userAssignedIdentities object = {}

@description('Optional. When set as true, connection with AuthType=aad won\'t work.')
param disableAadAuth bool = false

@description('Optional. Disables all authentication methods other than AAD authentication. For security reasons, this value should be set to `true`.')
param disableLocalAuth bool = true

@description('Optional. Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set.')
@allowed([
  ''
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = ''

@allowed([
  'ConnectivityLogs'
  'MessagingLogs'
])
@description('Optional. Control permission for data plane traffic coming from public networks while private endpoint is enabled.')
param resourceLogConfigurationsToEnable array = [
  'ConnectivityLogs'
  'MessagingLogs'
]

@description('Optional. Request client certificate during TLS handshake if enabled.')
param clientCertEnabled bool = false

@description('Optional. Networks ACLs, this value contains IPs to allow and/or Subnet information. Can only be set if the \'SKU\' is not \'Free_F1\'. For security reasons, it is recommended to set the DefaultAction Deny.')
param networkAcls object = {}

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

var resourceLogConfiguration = [for configuration in resourceLogConfigurationsToEnable: {
  name: configuration
  enabled: 'true'
}]

var identityType = systemAssignedIdentity ? 'SystemAssigned' : !empty(userAssignedIdentities) ? 'UserAssigned' : 'None'

var identity = {
  type: identityType
  userAssignedIdentities: !empty(userAssignedIdentities) ? userAssignedIdentities : null
}

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Log Analytics Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '92aaf0da-9dab-42b6-94a3-d43ce8d16293')
  'Log Analytics Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '73c42c96-874c-492b-b04d-ab87d138a893')
  'Managed Application Contributor Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '641177b8-a67a-45b9-a033-47bc880bb21e')
  'Managed Application Operator Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'c7393b34-138c-406f-901b-d8cf2b17e6ae')
  'Managed Applications Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b9331d33-8a36-4f8c-b097-4f54124fdb44')
  'Monitoring Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '749f88d5-cbae-40b8-bcfc-e573ddc772fa')
  'Monitoring Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '43d0d8ad-25c7-4714-9337-8ba259a9fe05')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Resource Policy Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '36243c78-bf99-498c-9df9-86d9f8d28608')
  'Role Based Access Control Administrator (Preview)': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f58310d9-a9f6-439a-9e8d-f62e7b41a168')
  'SignalR AccessKey Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '04165923-9d83-45d5-8227-78b77b0a687e')
  'SignalR App Server': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '420fcaa2-552c-430f-98ca-3264be4806c7')
  'SignalR REST API Owner': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'fd53cd77-2268-407a-8f46-7e7863d0f521')
  'SignalR REST API Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ddde6b66-c0df-4114-a159-3618637b3035')
  'SignalR Service Owner': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7e4f1700-ea5a-4f59-8f37-079cfe29dce3')
  'SignalR/Web PubSub Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8cf5e20a-e4b2-4e9d-b3a1-5ceb692c2761')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
  'Web PubSub Service Owner (Preview)': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '12cf5a90-567b-43ae-8102-96cf46c7d9b4')
  'Web PubSub Service Reader (Preview)': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'bfb1c7d2-fb1a-466b-b2ba-aee63b92deaf')
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

resource webPubSub 'Microsoft.SignalRService/webPubSub@2021-10-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    capacity: capacity
    name: sku
    tier: sku == 'Standard_S1' ? 'Standard' : 'Free'
  }
  identity: identity
  properties: {
    disableAadAuth: disableAadAuth
    disableLocalAuth: disableLocalAuth
    networkACLs: !empty(networkAcls) ? any(networkAcls) : null
    publicNetworkAccess: !empty(publicNetworkAccess) ? any(publicNetworkAccess) : (!empty(privateEndpoints) && empty(networkAcls) ? 'Disabled' : null)
    resourceLogConfiguration: {
      categories: resourceLogConfiguration
    }
    tls: {
      clientCertEnabled: clientCertEnabled
    }
  }
}

module webPubSub_privateEndpoints '../../network/private-endpoint/main.bicep' = [for (privateEndpoint, index) in privateEndpoints: {
  name: '${uniqueString(deployment().name, location)}-WebPubSub-PrivateEndpoint-${index}'
  params: {
    groupIds: [
      privateEndpoint.service
    ]
    name: contains(privateEndpoint, 'name') ? privateEndpoint.name : 'pe-${last(split(webPubSub.id, '/'))}-${privateEndpoint.service}-${index}'
    serviceResourceId: webPubSub.id
    subnetResourceId: privateEndpoint.subnetResourceId
    location: contains(privateEndpoint, 'location') ? privateEndpoint.location : reference(split(privateEndpoint.subnetResourceId, '/subnets/')[0], '2020-06-01', 'Full').location
    lock: privateEndpoint.?lock ?? lock
    privateDnsZoneGroupName: contains(privateEndpoint, 'privateDnsZoneGroupName') ? privateEndpoint.privateDnsZoneGroupName : 'default'
    privateDnsZoneResourceIds: contains(privateEndpoint, 'privateDnsZoneResourceIds') ? privateEndpoint.privateDnsZoneResourceIds : []
    roleAssignments: contains(privateEndpoint, 'roleAssignments') ? privateEndpoint.roleAssignments : []
    tags: contains(privateEndpoint, 'tags') ? privateEndpoint.tags : {}
    manualPrivateLinkServiceConnections: contains(privateEndpoint, 'manualPrivateLinkServiceConnections') ? privateEndpoint.manualPrivateLinkServiceConnections : []
    customDnsConfigs: contains(privateEndpoint, 'customDnsConfigs') ? privateEndpoint.customDnsConfigs : []
    ipConfigurations: contains(privateEndpoint, 'ipConfigurations') ? privateEndpoint.ipConfigurations : []
    applicationSecurityGroupResourceIds: contains(privateEndpoint, 'applicationSecurityGroupResourceIds') ? privateEndpoint.applicationSecurityGroupResourceIds : []
    customNetworkInterfaceName: contains(privateEndpoint, 'customNetworkInterfaceName') ? privateEndpoint.customNetworkInterfaceName : ''
  }
}]

resource webPubSub_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot delete or modify the resource or child resources.'
  }
  scope: webPubSub
}

resource webPubSub_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for (roleAssignment, index) in (roleAssignments ?? []): {
  name: guid(webPubSub.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
  properties: {
    roleDefinitionId: contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : roleAssignment.roleDefinitionIdOrName
    principalId: roleAssignment.principalId
    description: roleAssignment.?description
    principalType: roleAssignment.?principalType
    condition: roleAssignment.?condition
    conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
    delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
  }
  scope: webPubSub
}]

@description('The Web PubSub name.')
output name string = webPubSub.name

@description('The Web PubSub resource group.')
output resourceGroupName string = resourceGroup().name

@description('The Web PubSub resource ID.')
output resourceId string = webPubSub.id

@description('The Web PubSub externalIP.')
output externalIP string = webPubSub.properties.externalIP

@description('The Web PubSub hostName.')
output hostName string = webPubSub.properties.hostName

@description('The Web PubSub publicPort.')
output publicPort int = webPubSub.properties.publicPort

@description('The Web PubSub serverPort.')
output serverPort int = webPubSub.properties.serverPort

@description('The location the resource was deployed into.')
output location string = webPubSub.location

// =============== //
//   Definitions   //
// =============== //

type lockType = {
  @description('Optional. Specify the name of lock.')
  name: string?

  @description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
}?

type roleAssignmentType = {
  @description('Required. The name of the role to assign. If it cannot be found you can specify the role definition ID instead.')
  roleDefinitionIdOrName: string

  @description('Required. The principal ID of the principal (user/group/identity) to assign the role to.')
  principalId: string

  @description('Optional. The principal type of the assigned principal ID.')
  principalType: ('ServicePrincipal' | 'Group' | 'User' | 'ForeignGroup' | 'Device' | null)?

  @description('Optional. The description of the role assignment.')
  description: string?

  @description('Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container"')
  condition: string?

  @description('Optional. Version of the condition.')
  conditionVersion: '2.0'?

  @description('Optional. The Resource Id of the delegated managed identity resource.')
  delegatedManagedIdentityResourceId: string?
}[]?
