metadata name = 'Key Vaults'
metadata description = 'This module deploys a Key Vault.'
metadata owner = 'Azure/module-maintainers'

// ================ //
// Parameters       //
// ================ //
@description('Required. Name of the Key Vault. Must be globally unique.')
@maxLength(24)
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. All access policies to create.')
param accessPolicies array = []

@description('Optional. All secrets to create.')
@secure()
param secrets object = {}

@description('Optional. All keys to create.')
param keys array = []

@description('Optional. Specifies if the vault is enabled for deployment by script or compute.')
param enableVaultForDeployment bool = true

@description('Optional. Specifies if the vault is enabled for a template deployment.')
param enableVaultForTemplateDeployment bool = true

@description('Optional. Specifies if the azure platform has access to the vault for enabling disk encryption scenarios.')
param enableVaultForDiskEncryption bool = true

@description('Optional. Switch to enable/disable Key Vault\'s soft delete feature.')
param enableSoftDelete bool = true

@description('Optional. softDelete data retention days. It accepts >=7 and <=90.')
param softDeleteRetentionInDays int = 90

@description('Optional. Property that controls how data actions are authorized. When true, the key vault will use Role Based Access Control (RBAC) for authorization of data actions, and the access policies specified in vault properties will be ignored (warning: this is a preview feature). When false, the key vault will use the access policies specified in vault properties, and any policy stored on Azure Resource Manager will be ignored. If null or not specified, the vault is created with the default value of false. Note that management actions are always authorized with RBAC.')
param enableRbacAuthorization bool = false

@description('Optional. The vault\'s create mode to indicate whether the vault need to be recovered or not. - recover or default.')
param createMode string = 'default'

@description('Optional. Provide \'true\' to enable Key Vault\'s purge protection feature.')
param enablePurgeProtection bool = true

@description('Optional. Specifies the SKU for the vault.')
@allowed([
  'premium'
  'standard'
])
param vaultSku string = 'premium'

@description('Optional. Service endpoint object information. For security reasons, it is recommended to set the DefaultAction Deny.')
param networkAcls object = {}

@description('Optional. Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set and networkAcls are not set.')
@allowed([
  ''
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = ''

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = ''

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints array = []

@description('Optional. Resource tags.')
param tags object = {}

type metricCategories = {

  @description('Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.')
  category: string
}[]

type logCategoriesAndGroups = {

  @description('Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.')
  category: string?

  @description('Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.')
  categoryGroup: string?
}[]

@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings {
  @description('Optional. The name of diagnostic setting.')
  name: string?

  @description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to \'\' to disable log collection.')
  logCategoriesAndGroups: logCategoriesAndGroups?

  @description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to \'\' to disable log collection.')
  metricCategories: metricCategories?

  @description('A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type.')
  logAnalyticsDestinationType: ('Dedicated' | 'AzureDiagnostics' | null)?

  @description('Optional. Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  workspaceResourceId: string?

  @description('Optional. Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  storageAccountResourceId: string?

  @description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
  eventHubAuthorizationRuleResourceId: string?

  @description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  eventHubName: string?

  @description('The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.')
  marketplacePartnerResourceId: string?
}[] = []

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

// =========== //
// Variables   //
// =========== //

var formattedAccessPolicies = [for accessPolicy in accessPolicies: {
  applicationId: contains(accessPolicy, 'applicationId') ? accessPolicy.applicationId : ''
  objectId: contains(accessPolicy, 'objectId') ? accessPolicy.objectId : ''
  permissions: accessPolicy.permissions
  tenantId: contains(accessPolicy, 'tenantId') ? accessPolicy.tenantId : tenant().tenantId
}]

var secretList = !empty(secrets) ? secrets.secureList : []

var enableReferencedModulesTelemetry = false

// ============ //
// Dependencies //
// ============ //
resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name, location)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    enabledForDeployment: enableVaultForDeployment
    enabledForTemplateDeployment: enableVaultForTemplateDeployment
    enabledForDiskEncryption: enableVaultForDiskEncryption
    enableSoftDelete: enableSoftDelete
    softDeleteRetentionInDays: softDeleteRetentionInDays
    enableRbacAuthorization: enableRbacAuthorization
    createMode: createMode
    enablePurgeProtection: enablePurgeProtection ? enablePurgeProtection : null
    tenantId: subscription().tenantId
    accessPolicies: formattedAccessPolicies
    sku: {
      name: vaultSku
      family: 'A'
    }
    networkAcls: !empty(networkAcls) ? {
      bypass: contains(networkAcls, 'bypass') ? networkAcls.bypass : null
      defaultAction: contains(networkAcls, 'defaultAction') ? networkAcls.defaultAction : null
      virtualNetworkRules: contains(networkAcls, 'virtualNetworkRules') ? networkAcls.virtualNetworkRules : []
      ipRules: contains(networkAcls, 'ipRules') ? networkAcls.ipRules : []
    } : null
    publicNetworkAccess: !empty(publicNetworkAccess) ? any(publicNetworkAccess) : (!empty(privateEndpoints) && empty(networkAcls) ? 'Disabled' : null)
  }
}

resource keyVault_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock)) {
  name: '${keyVault.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: keyVault
}

resource keyVault_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [for (diagnosticSetting, index) in diagnosticSettings: {
  name: diagnosticSetting.?name ?? '${name}-diagnosticSettings'
  properties: {
    storageAccountId: diagnosticSetting.?storageAccountResourceId ?? null
    workspaceId: diagnosticSetting.?workspaceResourceId ?? null
    eventHubAuthorizationRuleId: diagnosticSetting.?eventHubAuthorizationRuleResourceId ?? null
    eventHubName: diagnosticSetting.?eventHubName ?? null
    metrics: diagnosticSetting.?metricCategories ?? [
      {
        category: 'AllMetrics'
        timeGrain: null
        enabled: true
      }
    ]
    logs: diagnosticSetting.?logCategoriesAndGroups ?? [
      {
        categoryGroup: 'allLogs'
        enabled: true
      }
    ]
    marketplacePartnerId: diagnosticSetting.?marketplacePartnerResourceId ?? null
    logAnalyticsDestinationType: diagnosticSetting.?logAnalyticsDestinationType ?? null
  }
  scope: keyVault
}]

module keyVault_accessPolicies 'access-policy/main.bicep' = if (!empty(accessPolicies)) {
  name: '${uniqueString(deployment().name, location)}-KeyVault-AccessPolicies'
  params: {
    keyVaultName: keyVault.name
    accessPolicies: formattedAccessPolicies
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}

module keyVault_secrets 'secret/main.bicep' = [for (secret, index) in secretList: {
  name: '${uniqueString(deployment().name, location)}-KeyVault-Secret-${index}'
  params: {
    name: secret.name
    value: secret.value
    keyVaultName: keyVault.name
    attributesEnabled: contains(secret, 'attributesEnabled') ? secret.attributesEnabled : true
    attributesExp: contains(secret, 'attributesExp') ? secret.attributesExp : -1
    attributesNbf: contains(secret, 'attributesNbf') ? secret.attributesNbf : -1
    contentType: contains(secret, 'contentType') ? secret.contentType : ''
    tags: contains(secret, 'tags') ? secret.tags : {}
    roleAssignments: contains(secret, 'roleAssignments') ? secret.roleAssignments : []
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

module keyVault_keys 'key/main.bicep' = [for (key, index) in keys: {
  name: '${uniqueString(deployment().name, location)}-KeyVault-Key-${index}'
  params: {
    name: key.name
    keyVaultName: keyVault.name
    attributesEnabled: contains(key, 'attributesEnabled') ? key.attributesEnabled : true
    attributesExp: contains(key, 'attributesExp') ? key.attributesExp : -1
    attributesNbf: contains(key, 'attributesNbf') ? key.attributesNbf : -1
    curveName: contains(key, 'curveName') ? key.curveName : 'P-256'
    keyOps: contains(key, 'keyOps') ? key.keyOps : []
    keySize: contains(key, 'keySize') ? key.keySize : -1
    kty: contains(key, 'kty') ? key.kty : 'EC'
    tags: contains(key, 'tags') ? key.tags : {}
    roleAssignments: contains(key, 'roleAssignments') ? key.roleAssignments : []
    enableDefaultTelemetry: enableReferencedModulesTelemetry
    rotationPolicy: contains(key, 'rotationPolicy') ? key.rotationPolicy : {}
  }
}]

module keyVault_privateEndpoints '../../network/private-endpoint/main.bicep' = [for (privateEndpoint, index) in privateEndpoints: {
  name: '${uniqueString(deployment().name, location)}-KeyVault-PrivateEndpoint-${index}'
  params: {
    groupIds: [
      privateEndpoint.service
    ]
    name: contains(privateEndpoint, 'name') ? privateEndpoint.name : 'pe-${last(split(keyVault.id, '/'))}-${privateEndpoint.service}-${index}'
    serviceResourceId: keyVault.id
    subnetResourceId: privateEndpoint.subnetResourceId
    enableDefaultTelemetry: enableReferencedModulesTelemetry
    location: contains(privateEndpoint, 'location') ? privateEndpoint.location : reference(split(privateEndpoint.subnetResourceId, '/subnets/')[0], '2020-06-01', 'Full').location
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

module keyVault_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-KeyVault-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: keyVault.id
  }
}]

// =========== //
// Outputs     //
// =========== //
@description('The resource ID of the key vault.')
output resourceId string = keyVault.id

@description('The name of the resource group the key vault was created in.')
output resourceGroupName string = resourceGroup().name

@description('The name of the key vault.')
output name string = keyVault.name

@description('The URI of the key vault.')
output uri string = keyVault.properties.vaultUri

@description('The location the resource was deployed into.')
output location string = keyVault.location
