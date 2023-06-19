@description('Optional. The location for the resource.')
param location string = resourceGroup().location

@description('Required. The name of the Web PubSub Service resource.')
param name string

@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints array = []

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = ''

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

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

module webPubSub_privateEndpoints '../../network/private-endpoints/main.bicep' = [for (privateEndpoint, index) in privateEndpoints: {
  name: '${uniqueString(deployment().name, location)}-WebPubSub-PrivateEndpoint-${index}'
  params: {
    groupIds: [
      privateEndpoint.service
    ]
    name: contains(privateEndpoint, 'name') ? privateEndpoint.name : 'pe-${last(split(webPubSub.id, '/'))}-${privateEndpoint.service}-${index}'
    serviceResourceId: webPubSub.id
    subnetResourceId: privateEndpoint.subnetResourceId
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

resource webPubSub_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock)) {
  name: '${webPubSub.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: webPubSub
}

module webPubSub_rbac '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-WebPubSub-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: webPubSub.id
  }
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
