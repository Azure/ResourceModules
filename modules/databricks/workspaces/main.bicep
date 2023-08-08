metadata name = 'Azure Databricks Workspaces'
metadata description = 'This module deploys an Azure Databricks Workspace.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the Azure Databricks workspace to create.')
param name string

@description('Optional. The managed resource group ID.')
param managedResourceGroupId string = ''

@description('Optional. The pricing tier of workspace.')
@allowed([
  'trial'
  'standard'
  'premium'
])
param skuName string = 'premium'

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@description('Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.')
@minValue(0)
@maxValue(365)
param diagnosticLogsRetentionInDays int = 365

@description('Optional. Resource ID of the diagnostic storage account.')
param diagnosticStorageAccountId string = ''

@description('Optional. Resource ID of the diagnostic log analytics workspace.')
param diagnosticWorkspaceId string = ''

@description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
param diagnosticEventHubAuthorizationRuleId string = ''

@description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.')
param diagnosticEventHubName string = ''

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = ''

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. The resource ID of a Virtual Network where this Databricks Cluster should be created.')
param customVirtualNetworkResourceId string = ''

@description('Optional. The resource ID of a Azure Machine Learning workspace to link with Databricks workspace.')
param amlWorkspaceResourceId string = ''

@description('Optional. The name of the Private Subnet within the Virtual Network.')
param customPrivateSubnetName string = ''

@description('Optional. The name of a Public Subnet within the Virtual Network')
param customPublicSubnetName string = ''

@description('Optional. Disable Public IP.')
param disablePublicIp bool = false

@description('Conditional. The resource ID of a key vault to reference a customer managed key for encryption from. Required if \'cMKKeyName\' is not empty.')
param cMKManagedServicesKeyVaultResourceId string = ''

@description('Optional. The name of the customer managed key to use for encryption.')
param cMKManagedServicesKeyName string = ''

@description('Optional. The version of the customer managed key to reference for encryption. If not provided, the latest key version is used.')
param cMKManagedServicesKeyVersion string = ''

@description('Conditional. The resource ID of a key vault to reference a customer managed key for encryption from. Required if \'cMKKeyName\' is not empty.')
param cMKManagedDisksKeyVaultResourceId string = ''

@description('Optional. The name of the customer managed key to use for encryption.')
param cMKManagedDisksKeyName string = ''

@description('Optional. The version of the customer managed key to reference for encryption. If not provided, the latest key version is used.')
param cMKManagedDisksKeyVersion string = ''

@description('Optional. Enable Auto Rotation of Key.')
param cMKManagedDisksKeyRotationToLatestKeyVersionEnabled bool = true

@description('Optional. Name of the outbound Load Balancer Backend Pool for Secure Cluster Connectivity (No Public IP).')
param loadBalancerBackendPoolName string = ''

@description('Optional. Resource URI of Outbound Load balancer for Secure Cluster Connectivity (No Public IP) workspace.')
param loadBalancerResourceId string = ''

@description('Optional. Name of the NAT gateway for Secure Cluster Connectivity (No Public IP) workspace subnets.')
param natGatewayName string = ''

@description('Optional. Prepare the workspace for encryption. Enables the Managed Identity for managed storage account.')
param prepareEncryption bool = false

@description('Optional. Name of the Public IP for No Public IP workspace with managed vNet.')
param publicIpName string = ''

@description('Optional. A boolean indicating whether or not the DBFS root file system will be enabled with secondary layer of encryption with platform managed keys for data at rest.')
param requireInfrastructureEncryption bool = true

@description('Optional. Default DBFS storage account name.')
param storageAccountName string = ''

@description('Optional. Storage account SKU name.')
param storageAccountSkuName string = 'Standard_GRS'

@description('Optional. Address prefix for Managed virtual network.')
param vnetAddressPrefix string = '10.139'

@description('Optional. The workspace provider authorizations.')
param authorizations array = []

@description('Optional. The details of Managed Identity of Disk Encryption Set used for Managed Disk Encryption.')
param managedDiskIdentity object = {}

@description('Optional. 	The network access type for accessing workspace. Set value to disabled to access workspace only via private link.')
@allowed([
  'Disabled'
  'Enabled'
])
param publicNetworkAccess string = 'Enabled'

@description('Optional. Gets or sets a value indicating whether data plane (clusters) to control plane communication happen over private endpoint.')
@allowed([
  'AllRules'
  'NoAzureDatabricksRules'
])
param requiredNsgRules string = 'AllRules'

@description('Optional. The details of Managed Identity of Storage Account.')
param storageAccountIdentity object = {}

@description('Optional. The blob URI where the UI definition file is located.')
param uiDefinitionUri string = ''

@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints array = []

@description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to \'\' to disable log collection.')
@allowed([
  ''
  'allLogs'
  'dbfs'
  'clusters'
  'accounts'
  'jobs'
  'notebook'
  'ssh'
  'workspace'
  'secrets'
  'sqlPermissions'
  'instancePools'
])
param diagnosticLogCategoriesToEnable array = [
  'allLogs'
]

@description('Optional. The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings".')
param diagnosticSettingsName string = ''

var diagnosticsLogsSpecified = [for category in filter(diagnosticLogCategoriesToEnable, item => item != 'allLogs' && item != ''): {
  category: category
  enabled: true
  retentionPolicy: {
    enabled: true
    days: diagnosticLogsRetentionInDays
  }
}]

var diagnosticsLogs = contains(diagnosticLogCategoriesToEnable, 'allLogs') ? [
  {
    categoryGroup: 'allLogs'
    enabled: true
    retentionPolicy: {
      enabled: true
      days: diagnosticLogsRetentionInDays
    }
  }
] : contains(diagnosticLogCategoriesToEnable, '') ? [] : diagnosticsLogsSpecified

var enableReferencedModulesTelemetry = false

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

resource cMKManagedDisksKeyVault 'Microsoft.KeyVault/vaults@2023-02-01' existing = if (!empty(cMKManagedDisksKeyVaultResourceId)) {
  name: last(split(cMKManagedDisksKeyVaultResourceId, '/'))!
  scope: resourceGroup(split(cMKManagedDisksKeyVaultResourceId, '/')[2], split(cMKManagedDisksKeyVaultResourceId, '/')[4])
}

resource cMKManagedDisksKeyVaultKey 'Microsoft.KeyVault/vaults/keys@2023-02-01' existing = if (!empty(cMKManagedDisksKeyVaultResourceId) && !empty(cMKManagedDisksKeyName)) {
  name: '${last(split(cMKManagedDisksKeyVaultResourceId, '/'))}/${cMKManagedDisksKeyName}'!
  scope: resourceGroup(split(cMKManagedDisksKeyVaultResourceId, '/')[2], split(cMKManagedDisksKeyVaultResourceId, '/')[4])
}

resource cMKManagedServicesKeyVault 'Microsoft.KeyVault/vaults@2023-02-01' existing = if (!empty(cMKManagedServicesKeyVaultResourceId)) {
  name: last(split(cMKManagedServicesKeyVaultResourceId, '/'))!
  scope: resourceGroup(split(cMKManagedServicesKeyVaultResourceId, '/')[2], split(cMKManagedServicesKeyVaultResourceId, '/')[4])
}

resource cMKManagedServicesKeyVaultKey 'Microsoft.KeyVault/vaults/keys@2023-02-01' existing = if (!empty(cMKManagedServicesKeyVaultResourceId) && !empty(cMKManagedServicesKeyName)) {
  name: '${last(split(cMKManagedServicesKeyVaultResourceId, '/'))}/${cMKManagedServicesKeyName}'!
  scope: resourceGroup(split(cMKManagedServicesKeyVaultResourceId, '/')[2], split(cMKManagedServicesKeyVaultResourceId, '/')[4])
}

resource workspace 'Microsoft.Databricks/workspaces@2023-02-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: skuName
  }
  properties: {
    managedResourceGroupId: !empty(managedResourceGroupId) ? managedResourceGroupId : '${subscription().id}/resourceGroups/${name}-rg'
    parameters: {
      customVirtualNetworkId: !empty(customVirtualNetworkResourceId) ? {
        value: customVirtualNetworkResourceId
      } : null
      amlWorkspaceId: !empty(amlWorkspaceResourceId) ? {
        value: amlWorkspaceResourceId
      } : null
      customPrivateSubnetName: !empty(customPrivateSubnetName) ? {
        value: customPrivateSubnetName
      } : null
      customPublicSubnetName: !empty(customPublicSubnetName) ? {
        value: customPublicSubnetName
      } : null
      enableNoPublicIp: {
        value: disablePublicIp
      }
      loadBalancerBackendPoolName: !empty(loadBalancerBackendPoolName) ? {
        value: loadBalancerBackendPoolName
      } : null
      loadBalancerId: !empty(loadBalancerResourceId) ? {
        value: loadBalancerResourceId
      } : null
      natGatewayName: !empty(natGatewayName) ? {
        value: natGatewayName
      } : null
      prepareEncryption: {
        value: prepareEncryption
      }
      publicIpName: !empty(publicIpName) ? {
        value: publicIpName
      } : null
      requireInfrastructureEncryption: {
        value: requireInfrastructureEncryption
      }
      storageAccountName: !empty(storageAccountName) ? {
        value: storageAccountName
      } : null
      storageAccountSkuName: !empty(storageAccountSkuName) ? {
        value: storageAccountSkuName
      } : null
      vnetAddressPrefix: !empty(vnetAddressPrefix) ? {
        value: vnetAddressPrefix
      } : null
    }
    // authorizations: authorizations
    // managedDiskIdentity: managedDiskIdentity
    // publicNetworkAccess: publicNetworkAccess
    // requiredNsgRules: requiredNsgRules
    // storageAccountIdentity: storageAccountIdentity
    // uiDefinitionUri: uiDefinitionUri
    encryption: !empty(cMKManagedServicesKeyName) || !empty(cMKManagedServicesKeyName) ? {
      entities: {
        managedServices: !empty(cMKManagedServicesKeyName) ? {
          keySource: 'Microsoft.Keyvault'
          keyVaultProperties: {
            keyVaultUri: cMKManagedServicesKeyVault.properties.vaultUri
            keyName: cMKManagedServicesKeyName
            keyVersion: !empty(cMKManagedServicesKeyVersion) ? cMKManagedServicesKeyVersion : last(split(cMKManagedServicesKeyVaultKey.properties.keyUriWithVersion, '/'))
          }
        } : null
        managedDisk: !empty(cMKManagedDisksKeyName) ? {
          keySource: 'Microsoft.Keyvault'
          keyVaultProperties: {
            keyVaultUri: cMKManagedDisksKeyVault.properties.vaultUri
            keyName: cMKManagedDisksKeyName
            keyVersion: !empty(cMKManagedDisksKeyVersion) ? cMKManagedDisksKeyVersion : last(split(cMKManagedDisksKeyVaultKey.properties.keyUriWithVersion, '/'))
          }
          rotationToLatestKeyVersionEnabled: cMKManagedDisksKeyRotationToLatestKeyVersionEnabled
        } : null
      }
    } : null
  }
}

resource workspace_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock)) {
  name: '${workspace.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: workspace
}

// Note: Diagnostic Settings are only supported by the premium tier
resource workspace_diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2021-05-01-preview' = if (skuName == 'premium' && ((!empty(diagnosticStorageAccountId)) || (!empty(diagnosticWorkspaceId)) || (!empty(diagnosticEventHubAuthorizationRuleId)) || (!empty(diagnosticEventHubName)))) {
  name: !empty(diagnosticSettingsName) ? diagnosticSettingsName : '${name}-diagnosticSettings'
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(diagnosticWorkspaceId) ? diagnosticWorkspaceId : null
    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null
    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null
    logs: diagnosticsLogs
  }
  scope: workspace
}

module workspace_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-Databricks-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: workspace.id
  }
}]

module workspace_privateEndpoints '../../network/private-endpoints/main.bicep' = [for (privateEndpoint, index) in privateEndpoints: {
  name: '${uniqueString(deployment().name, location)}-Databricks-PrivateEndpoint-${index}'
  params: {
    groupIds: [
      privateEndpoint.service
    ]
    name: contains(privateEndpoint, 'name') ? privateEndpoint.name : 'pe-${last(split(workspace.id, '/'))}-${privateEndpoint.service}-${index}'
    serviceResourceId: workspace.id
    subnetResourceId: privateEndpoint.subnetResourceId
    enableDefaultTelemetry: enableReferencedModulesTelemetry
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

@description('The name of the deployed databricks workspace.')
output name string = workspace.name

@description('The resource ID of the deployed databricks workspace.')
output resourceId string = workspace.id

@description('The resource group of the deployed databricks workspace.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = workspace.location
