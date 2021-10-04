@description('Required. The name to be used for the Application Gateway.')
param applicationGatewayName string

@description('Optional. The name of the SKU for the Application Gateway.')
@allowed([
  'Standard_Small'
  'Standard_Medium'
  'Standard_Large'
  'WAF_Medium'
  'WAF_Large'
  'Standard_v2'
  'WAF_v2'
])
param sku string = 'WAF_Medium'

@description('Optional. The number of Application instances to be configured.')
@minValue(1)
@maxValue(10)
param capacity int = 2

@description('Optional. Enables HTTP/2 support.')
param http2Enabled bool = true

@description('Required. PublicIP Resource Id used in Public Frontend.')
param frontendPublicIpResourceId string

@metadata({
  description: 'Optional. The private IP within the Application Gateway subnet to be used as frontend private address.'
  limitations: 'The IP must be available in the configured subnet. If empty, allocation method will be set to dynamic. Once a method (static or dynamic) has been configured, it cannot be changed'
})
param frontendPrivateIpAddress string = ''

@description('Required. The name of the Virtual Network where the Application Gateway will be deployed.')
param vNetName string

@description('Required. The name of Gateway Subnet Name where the Application Gateway will be deployed.')
param subnetName string

@description('Optional. The name of the Virtual Network Resource Group where the Application Gateway will be deployed.')
param vNetResourceGroup string = resourceGroup().name

@description('Optional. The Subscription Id of the Virtual Network where the Application Gateway will be deployed.')
param vNetSubscriptionId string = subscription().subscriptionId

@description('Optional. Resource Id of an User assigned managed identity which will be associated with the App Gateway.')
param managedIdentityResourceId string = ''

@description('Optional. Application Gateway IP configuration name.')
param gatewayIpConfigurationName string = 'gatewayIpConfiguration01'

@description('Optional. SSL certificate reference name for a certificate stored in the Key Vault to configure the HTTPS listeners.')
param sslCertificateName string = 'sslCertificate01'

@description('Optional. Secret Id of the SSL certificate stored in the Key Vault that will be used to configure the HTTPS listeners.')
param sslCertificateKeyVaultSecretId string = ''

@description('Required. The backend pools to be configured.')
param backendPools array

@description('Required. The backend HTTP settings to be configured. These HTTP settings will be used to rewrite the incoming HTTP requests for the backend pools.')
param backendHttpConfigurations array

@description('Optional. The backend HTTP settings probes to be configured.')
param probes array = []

@description('Required. The frontend http listeners to be configured.')
param frontendHttpListeners array = []

@description('Required. The frontend https listeners to be configured.')
param frontendHttpsListeners array = []

@description('Optional. The http redirects to be configured. Each redirect will route http traffic to a pre-defined frontEnd https listener.')
param frontendHttpRedirects array = []

@description('Required. The routing rules to be configured. These rules will be used to route requests from frontend listeners to backend pools using a backend HTTP configuration.')
param routingRules array

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.')
@minValue(0)
@maxValue(365)
param diagnosticLogsRetentionInDays int = 365

@description('Optional. Resource identifier of the Diagnostic Storage Account.')
param diagnosticStorageAccountId string = ''

@description('Optional. Resource identifier of Log Analytics.')
param workspaceId string = ''

@description('Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
param eventHubAuthorizationRuleId string = ''

@description('Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.')
param eventHubName string = ''

@description('Optional. Switch to lock Key Vault from deletion.')
param lockForDeletion bool = false

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered.')
param cuaId string = ''

var diagnosticsMetrics = [
  {
    category: 'AllMetrics'
    timeGrain: null
    enabled: true
    retentionPolicy: {
      enabled: true
      days: diagnosticLogsRetentionInDays
    }
  }
]
var diagnosticsLogs = [
  {
    category: 'ApplicationGatewayAccessLog'
    enabled: true
    retentionPolicy: {
      enabled: true
      days: diagnosticLogsRetentionInDays
    }
  }
  {
    category: 'ApplicationGatewayPerformanceLog'
    enabled: true
    retentionPolicy: {
      enabled: true
      days: diagnosticLogsRetentionInDays
    }
  }
  {
    category: 'ApplicationGatewayFirewallLog'
    enabled: true
    retentionPolicy: {
      enabled: true
      days: diagnosticLogsRetentionInDays
    }
  }
]
var applicationGatewayResourceId = resourceId('Microsoft.Network/applicationGateways', applicationGatewayName)
var subnetResourceId = resourceId(vNetSubscriptionId, vNetResourceGroup, 'Microsoft.Network/virtualNetworks/subnets', vNetName, subnetName)
var frontendPublicIPConfigurationName = 'public'
var frontendPrivateIPConfigurationName = 'private'
var frontendPrivateIPDynamicConfiguration = {
  privateIPAllocationMethod: 'Dynamic'
  subnet: {
    id: subnetResourceId
  }
}
var frontendPrivateIPStaticConfiguration = {
  privateIPAllocationMethod: 'Static'
  privateIPAddress: frontendPrivateIpAddress
  subnet: {
    id: subnetResourceId
  }
}
var redirectConfigurationsHttpRedirectNamePrefix = 'httpRedirect'
var httpListenerhttpRedirectNamePrefix = 'httpRedirect'
var requestRoutingRuleHttpRedirectNamePrefix = 'httpRedirect'
var wafConfiguration = {
  enabled: true
  firewallMode: 'Detection'
  ruleSetType: 'OWASP'
  ruleSetVersion: '3.0'
  disabledRuleGroups: []
  requestBodyCheck: true
  maxRequestBodySizeInKb: '128'
}
var sslCertificates = [
  {
    name: sslCertificateName
    properties: {
      keyVaultSecretId: sslCertificateKeyVaultSecretId
    }
  }
]
var frontendPorts = concat((empty(frontendHttpListeners) ? frontendHttpListeners : frontendHttpPorts), (empty(frontendHttpsListeners) ? frontendHttpsListeners : frontendHttpsPorts), (empty(frontendHttpRedirects) ? frontendHttpRedirects : frontendHttpRedirectPorts))
var httpListeners = concat((empty(frontendHttpListeners) ? frontendHttpListeners : frontendHttpListeners_var), (empty(frontendHttpsListeners) ? frontendHttpsListeners : frontendHttpsListeners_var), (empty(frontendHttpRedirects) ? frontendHttpRedirects : frontendHttpRedirects_var))
var redirectConfigurations = (empty(frontendHttpRedirects) ? frontendHttpRedirects : httpRedirectConfigurations)
var requestRoutingRules = concat(httpsRequestRoutingRules, (empty(frontendHttpRedirects) ? frontendHttpRedirects : httpRequestRoutingRules))
var identity = {
  type: 'UserAssigned'
  userAssignedIdentities: {
    '${managedIdentityResourceId}': {}
  }
}
var builtInRoleNames = {
  'Owner': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  'Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Avere Cluster Create': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'a7b1b19a-0e83-4fe5-935c-faaefbfd18c3')
  'Avere Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4f8fab4f-1852-4a58-a46a-8eaf358af14a')
  'Azure Service Deploy Release Management Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '21d96096-b162-414a-8302-d8354f9d91b2')
  'CAL-Custom-Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7b266cd7-0bba-4ae2-8423-90ede5e1e898')
  'ExpressRoute Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'a48d7896-14b4-4889-afef-fbb65a96e5a2')
  'Log Analytics Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '92aaf0da-9dab-42b6-94a3-d43ce8d16293')
  'Log Analytics Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '73c42c96-874c-492b-b04d-ab87d138a893')
  'Managed Application Contributor Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '641177b8-a67a-45b9-a033-47bc880bb21e')
  'Managed Application Operator Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'c7393b34-138c-406f-901b-d8cf2b17e6ae')
  'Managed Applications Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b9331d33-8a36-4f8c-b097-4f54124fdb44')
  'masterreader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'a48d7796-14b4-4889-afef-fbb65a93e5a2')
  'Monitoring Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '749f88d5-cbae-40b8-bcfc-e573ddc772fa')
  'Monitoring Metrics Publisher': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3913510d-42f4-4e42-8a64-420c390055eb')
  'Monitoring Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '43d0d8ad-25c7-4714-9337-8ba259a9fe05')
  'Network Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4d97b98b-1d4f-4787-a291-c67834d212e7')
  'Resource Policy Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '36243c78-bf99-498c-9df9-86d9f8d28608')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
  'Virtual Machine Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '9980e02c-c2be-4d73-94e8-173b1dc7cf3c')
}
var backendAddressPools = [for i in range(0, length(backendPools)): {
  name: backendPools[i].backendPoolName
  type: 'Microsoft.Network/applicationGateways/backendAddressPools'
  properties: {
    backendAddresses: (contains(backendPools[i], 'BackendAddresses') ? backendPools[i].BackendAddresses : [])
  }
}]
var probes_var = [for i in range(0, length(probes)): {
  name: '${probes[i].backendHttpConfigurationName}Probe'
  type: 'Microsoft.Network/applicationGateways/probes'
  properties: {
    protocol: probes[i].protocol
    host: probes[i].host
    path: probes[i].path
    interval: (contains(probes[i], 'interval') ? probes[i].interval : 30)
    timeout: (contains(probes[i], 'timeout') ? probes[i].timeout : 30)
    unhealthyThreshold: (contains(probes[i], 'timeout') ? probes[i].unhealthyThreshold : 3)
    minServers: (contains(probes[i], 'timeout') ? probes[i].minServers : 0)
    match: {
      body: (contains(probes[i], 'timeout') ? probes[i].body : '')
      statusCodes: probes[i].statusCodes
    }
  }
}]
var backendHttpConfigurations_var = [for i in range(0, length(backendHttpConfigurations)): {
  name: backendHttpConfigurations[i].backendHttpConfigurationName
  properties: {
    port: backendHttpConfigurations[i].port
    protocol: backendHttpConfigurations[i].protocol
    cookieBasedAffinity: backendHttpConfigurations[i].cookieBasedAffinity
    pickHostNameFromBackendAddress: backendHttpConfigurations[i].pickHostNameFromBackendAddress
    probeEnabled: backendHttpConfigurations[i].probeEnabled
    probe: (bool(backendHttpConfigurations[i].probeEnabled) ? json('{"id": "${applicationGatewayResourceId}/probes/${backendHttpConfigurations[i].backendHttpConfigurationName}Probe"}') : json('null'))
  }
}]
var frontendHttpsPorts = [for i in range(0, length(frontendHttpsListeners)): {
  name: 'port${frontendHttpsListeners[i].port}'
  properties: {
    Port: frontendHttpsListeners[i].port
  }
}]
var frontendHttpsListeners_var = [for i in range(0, length(frontendHttpsListeners)): {
  name: frontendHttpsListeners[i].frontendListenerName
  properties: {
    FrontendIPConfiguration: {
      Id: '${applicationGatewayResourceId}/frontendIPConfigurations/${frontendHttpsListeners[i].frontendIPType}'
    }
    FrontendPort: {
      Id: '${applicationGatewayResourceId}/frontendPorts/port${frontendHttpsListeners[i].port}'
    }
    Protocol: 'https'
    SslCertificate: {
      Id: '${applicationGatewayResourceId}/sslCertificates/${sslCertificateName}'
    }
  }
}]
var frontendHttpPorts = [for i in range(0, length(frontendHttpListeners)): {
  name: 'port${frontendHttpListeners[i].port}'
  properties: {
    Port: frontendHttpListeners[i].port
  }
}]
var frontendHttpListeners_var = [for i in range(0, length(frontendHttpListeners)): {
  name: frontendHttpListeners[i].frontendListenerName
  properties: {
    FrontendIPConfiguration: {
      Id: '${applicationGatewayResourceId}/frontendIPConfigurations/${frontendHttpListeners[i].frontendIPType}'
    }
    FrontendPort: {
      Id: '${applicationGatewayResourceId}/frontendPorts/port${frontendHttpListeners[i].port}'
    }
    Protocol: 'http'
  }
}]
var httpsRequestRoutingRules = [for i in range(0, length(routingRules)): {
  name: '${routingRules[i].frontendListenerName}-${routingRules[i].backendHttpConfigurationName}-${routingRules[i].backendHttpConfigurationName}'
  properties: {
    RuleType: 'Basic'
    httpListener: {
      id: '${applicationGatewayResourceId}/httpListeners/${routingRules[i].frontendListenerName}'
    }
    backendAddressPool: {
      id: '${applicationGatewayResourceId}/backendAddressPools/${routingRules[i].backendPoolName}'
    }
    backendHttpSettings: {
      id: '${applicationGatewayResourceId}/backendHttpSettingsCollection/${routingRules[i].backendHttpConfigurationName}'
    }
  }
}]
var frontendHttpRedirectPorts = [for i in range(0, length(frontendHttpRedirects)): {
  name: 'port${frontendHttpRedirects[i].port}'
  properties: {
    Port: frontendHttpRedirects[i].port
  }
}]
var frontendHttpRedirects_var = [for i in range(0, length(frontendHttpRedirects)): {
  name: '${httpListenerhttpRedirectNamePrefix}${frontendHttpRedirects[i].port}'
  properties: {
    FrontendIPConfiguration: {
      Id: '${applicationGatewayResourceId}/frontendIPConfigurations/${frontendHttpRedirects[i].frontendIPType}'
    }
    FrontendPort: {
      Id: '${applicationGatewayResourceId}/frontendPorts/port${frontendHttpRedirects[i].port}'
    }
    Protocol: 'http'
  }
}]
var httpRequestRoutingRules = [for i in range(0, length(frontendHttpRedirects)): {
  name: '${requestRoutingRuleHttpRedirectNamePrefix}${frontendHttpRedirects[i].port}-${frontendHttpRedirects[i].frontendListenerName}'
  properties: {
    RuleType: 'Basic'
    httpListener: {
      id: '${applicationGatewayResourceId}/httpListeners/${httpListenerhttpRedirectNamePrefix}${frontendHttpRedirects[i].port}'
    }
    redirectConfiguration: {
      id: '${applicationGatewayResourceId}/redirectConfigurations/${redirectConfigurationsHttpRedirectNamePrefix}${frontendHttpRedirects[i].port}'
    }
  }
}]
var httpRedirectConfigurations = [for i in range(0, length(frontendHttpRedirects)): {
  name: '${redirectConfigurationsHttpRedirectNamePrefix}${frontendHttpRedirects[i].port}'
  properties: {
    redirectType: 'Permanent'
    includePath: true
    includeQueryString: true
    requestRoutingRules: [
      {
        id: '${applicationGatewayResourceId}/requestRoutingRules/${requestRoutingRuleHttpRedirectNamePrefix}${frontendHttpRedirects[i].port}-${frontendHttpRedirects[i].frontendListenerName}'
      }
    ]
    targetListener: {
      id: '${applicationGatewayResourceId}/httpListeners/${frontendHttpRedirects[i].frontendListenerName}'
    }
  }
}]

module pid_cuaId './.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource applicationGateway 'Microsoft.Network/applicationGateways@2021-02-01' = {
  name: applicationGatewayName
  location: location
  identity: (empty(managedIdentityResourceId) ? json('null') : identity)
  tags: tags
  properties: {
    sku: {
      name: sku
      tier: (endsWith(sku, 'v2') ? sku : substring(sku, 0, indexOf(sku, '_')))
      capacity: capacity
    }
    gatewayIPConfigurations: [
      {
        name: gatewayIpConfigurationName
        properties: {
          subnet: {
            id: subnetResourceId
          }
        }
      }
    ]
    frontendIPConfigurations: [
      {
        name: frontendPrivateIPConfigurationName
        type: 'Microsoft.Network/applicationGateways/frontendIPConfigurations'
        properties: (empty(frontendPrivateIpAddress) ? frontendPrivateIPDynamicConfiguration : frontendPrivateIPStaticConfiguration)
      }
      {
        name: frontendPublicIPConfigurationName
        properties: {
          publicIPAddress: {
            id: frontendPublicIpResourceId
          }
        }
      }
    ]
    sslCertificates: (empty(sslCertificateKeyVaultSecretId) ? json('null') : sslCertificates)
    backendAddressPools: backendAddressPools
    probes: probes_var
    backendHttpSettingsCollection: backendHttpConfigurations_var
    frontendPorts: frontendPorts
    httpListeners: httpListeners
    redirectConfigurations: redirectConfigurations
    requestRoutingRules: requestRoutingRules
    enableHttp2: http2Enabled
    webApplicationFirewallConfiguration: (startsWith(sku, 'WAF') ? wafConfiguration : json('null'))
  }
  dependsOn: []
}

resource applicationGateway_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lockForDeletion) {
  name: '${applicationGateway.name}-appGatewayDoNotDelete'
  properties: {
    level: 'CanNotDelete'
  }
  scope: applicationGateway
}

resource applicationGateway_diagnosticSettingName 'Microsoft.Insights/diagnosticsettings@2017-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(workspaceId)) || (!empty(eventHubAuthorizationRuleId)) || (!empty(eventHubName))) {
  name: '${applicationGateway.name}-diagnosticSettings'
  properties: {
    storageAccountId: (empty(diagnosticStorageAccountId) ? json('null') : diagnosticStorageAccountId)
    workspaceId: (empty(workspaceId) ? json('null') : workspaceId)
    eventHubAuthorizationRuleId: (empty(eventHubAuthorizationRuleId) ? json('null') : eventHubAuthorizationRuleId)
    eventHubName: (empty(eventHubName) ? json('null') : eventHubName)
    metrics: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? json('null') : diagnosticsMetrics)
    logs: ((empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName)) ? json('null') : diagnosticsLogs)
  }
  scope: applicationGateway
}

module applicationGateway_rbac './.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: 'rbac-${deployment().name}${index}'
  params: {
    roleAssignment: roleAssignment
    builtInRoleNames: builtInRoleNames
    resourceName: applicationGateway.name
  }
  dependsOn: [
    applicationGateway
  ]
}]

output applicationGatewayName string = applicationGateway.name
output applicationGatewayResourceId string = applicationGateway.id
output applicationGatewayResourceGroup string = resourceGroup().name
