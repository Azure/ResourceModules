metadata name = 'SignalR Service SignalR'
metadata description = 'This module deploys a SignalR Service SignalR.'
metadata owner = 'Azure/module-maintainers'

@description('Optional. The location for the resource.')
param location string = resourceGroup().location

@description('Required. The name of the SignalR Service resource.')
param name string

@description('Optional. The kind of the service.')
@allowed([
  'SignalR'
  'RawWebSockets'
])
param kind string = 'SignalR'

@description('Optional. The SKU of the service.')
@allowed([
  'Free_F1'
  'Standard_S1'
  'Standard_S2'
  'Standard_S3'
  'Premium_P1'
  'Premium_P2'
  'Premium_P3'
])
param sku string = 'Standard_S1'

@description('Optional. The unit count of the resource.')
param capacity int = 1

@description('Optional. The tags of the resource.')
param tags object = {}

@description('Optional. The allowed origin settings of the resource.')
param allowedOrigins array = [
  '*'
]

@description('Optional. The disable Azure AD auth settings of the resource.')
param disableAadAuth bool = false

@description('Optional. The disable local auth settings of the resource.')
param disableLocalAuth bool = true

@description('Optional. The features settings of the resource, `ServiceMode` is the only required feature. See https://learn.microsoft.com/en-us/azure/templates/microsoft.signalrservice/signalr?pivots=deployment-language-bicep#signalrfeature for more information.')
param features array = [
  {
    flag: 'ServiceMode'
    value: 'Serverless'
  }
]

@description('Optional. Networks ACLs, this value contains IPs to allow and/or Subnet information. Can only be set if the \'SKU\' is not \'Free_F1\'. For security reasons, it is recommended to set the DefaultAction Deny.')
param networkAcls object = {}

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
param liveTraceCatagoriesToEnable array = [
  'ConnectivityLogs'
  'MessagingLogs'
]

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

@description('Optional. Upstream templates to enable. For more information, see https://learn.microsoft.com/en-us/azure/templates/microsoft.signalrservice/2022-02-01/signalr?pivots=deployment-language-bicep#upstreamtemplate.')
param upstreamTemplatesToEnable array = []

@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints array = []

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments roleAssignmentType

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

var liveTraceCatagories = [for configuration in liveTraceCatagoriesToEnable: {
  name: configuration
  enabled: 'true'
}]

var resourceLogConfiguration = [for configuration in resourceLogConfigurationsToEnable: {
  name: configuration
  enabled: 'true'
}]

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

resource signalR 'Microsoft.SignalRService/signalR@2022-02-01' = {
  name: name
  location: location
  kind: kind
  sku: {
    name: sku
    capacity: capacity
    tier: sku == 'Free_F1' ? 'Free' : sku == 'Standard_S1' || sku == 'Standard_S2' || sku == 'Standard_S3' ? 'Standard' : 'Premium'
  }
  tags: tags
  properties: {
    cors: {
      allowedOrigins: allowedOrigins
    }
    disableAadAuth: disableAadAuth
    disableLocalAuth: disableLocalAuth
    features: features
    liveTraceConfiguration: !empty(liveTraceCatagoriesToEnable) ? {
      categories: liveTraceCatagories
    } : {}
    networkACLs: !empty(networkAcls) ? any(networkAcls) : null
    publicNetworkAccess: !empty(publicNetworkAccess) ? any(publicNetworkAccess) : (!empty(privateEndpoints) && empty(networkAcls) ? 'Disabled' : null)
    resourceLogConfiguration: {
      categories: resourceLogConfiguration
    }
    tls: {
      clientCertEnabled: clientCertEnabled
    }
    upstream: !empty(upstreamTemplatesToEnable) ? {
      templates: upstreamTemplatesToEnable
    } : {}
  }
}

module signalR_privateEndpoints '../../network/private-endpoint/main.bicep' = [for (privateEndpoint, index) in privateEndpoints: {
  name: '${uniqueString(deployment().name, location)}-SignalR-PrivateEndpoint-${index}'
  params: {
    groupIds: [
      privateEndpoint.service
    ]
    name: contains(privateEndpoint, 'name') ? privateEndpoint.name : 'pe-${last(split(signalR.id, '/'))}-${privateEndpoint.service}-${index}'
    serviceResourceId: signalR.id
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

resource signalR_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot delete or modify the resource or child resources.'
  }
  scope: signalR
}

resource signalR_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for (roleAssignment, index) in (roleAssignments ?? []): {
  name: guid(signalR.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
  properties: {
    roleDefinitionId: contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : roleAssignment.roleDefinitionIdOrName
    principalId: roleAssignment.principalId
    description: roleAssignment.?description
    principalType: roleAssignment.?principalType
    condition: roleAssignment.?condition
    conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
    delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
  }
  scope: signalR
}]

@description('The SignalR name.')
output name string = signalR.name

@description('The SignalR resource group.')
output resourceGroupName string = resourceGroup().name

@description('The SignalR resource ID.')
output resourceId string = signalR.id

@description('The location the resource was deployed into.')
output location string = signalR.location

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
