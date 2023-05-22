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

var liveTraceCatagories = [for configuration in liveTraceCatagoriesToEnable: {
  name: configuration
  enabled: 'true'
}]

var resourceLogConfiguration = [for configuration in resourceLogConfigurationsToEnable: {
  name: configuration
  enabled: 'true'
}]

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

module signalR_privateEndpoints '../../network/private-endpoints/main.bicep' = [for (privateEndpoint, index) in privateEndpoints: {
  name: '${uniqueString(deployment().name, location)}-SignalR-PrivateEndpoint-${index}'
  params: {
    groupIds: [
      privateEndpoint.service
    ]
    name: contains(privateEndpoint, 'name') ? privateEndpoint.name : 'pe-${last(split(signalR.id, '/'))}-${privateEndpoint.service}-${index}'
    serviceResourceId: signalR.id
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

resource signalR_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock)) {
  name: '${signalR.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: signalR
}

module signalR_rbac '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-signalR-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: signalR.id
  }
}]

@description('The SignalR name.')
output name string = signalR.name

@description('The SignalR resource group.')
output resourceGroupName string = resourceGroup().name

@description('The SignalR resource ID.')
output resourceId string = signalR.id

@description('The location the resource was deployed into.')
output location string = signalR.location
