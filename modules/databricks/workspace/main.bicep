metadata name = 'Azure Databricks Workspaces'
metadata description = 'This module deploys an Azure Databricks Workspace.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the Azure Databricks workspace to create.')
param name string

@description('Optional. The managed resource group ID. It is created by the module as per the to-be resource ID you provide.')
param managedResourceGroupResourceId string = ''

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
param roleAssignments roleAssignmentType

@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingType

@description('Optional. The lock settings of the service.')
param lock lockType

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

@description('Optional. The name of a Public Subnet within the Virtual Network.')
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
param requireInfrastructureEncryption bool = false

@description('Optional. Default DBFS storage account name.')
param storageAccountName string = ''

@description('Optional. Storage account SKU name.')
param storageAccountSkuName string = 'Standard_GRS'

@description('Optional. Address prefix for Managed virtual network.')
param vnetAddressPrefix string = '10.139'

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

@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints privateEndpointType

var enableReferencedModulesTelemetry = false

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator (Preview)': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f58310d9-a9f6-439a-9e8d-f62e7b41a168')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
}

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

resource cMKManagedDisksKeyVault 'Microsoft.KeyVault/vaults@2021-10-01' existing = if (!empty(cMKManagedDisksKeyVaultResourceId)) {
  name: last(split((!empty(cMKManagedDisksKeyVaultResourceId) ? cMKManagedDisksKeyVaultResourceId : 'dummyVault'), '/'))!
  scope: resourceGroup(split((!empty(cMKManagedDisksKeyVaultResourceId) ? cMKManagedDisksKeyVaultResourceId : '//'), '/')[2], split((!empty(cMKManagedDisksKeyVaultResourceId) ? cMKManagedDisksKeyVaultResourceId : '////'), '/')[4])

  resource cMKKeyDisk 'keys@2023-02-01' existing = if (!empty(cMKManagedDisksKeyName)) {
    name: !empty(cMKManagedDisksKeyName) ? cMKManagedDisksKeyName : 'dummyKey'
  }
}

resource cMKManagedServicesKeyVault 'Microsoft.KeyVault/vaults@2021-10-01' existing = if (!empty(cMKManagedServicesKeyVaultResourceId)) {
  name: last(split((!empty(cMKManagedServicesKeyVaultResourceId) ? cMKManagedServicesKeyVaultResourceId : 'dummyVault'), '/'))!
  scope: resourceGroup(split((!empty(cMKManagedServicesKeyVaultResourceId) ? cMKManagedServicesKeyVaultResourceId : '//'), '/')[2], split((!empty(cMKManagedServicesKeyVaultResourceId) ? cMKManagedServicesKeyVaultResourceId : '////'), '/')[4])

  resource cMKKey 'keys@2023-02-01' existing = if (!empty(cMKManagedServicesKeyName)) {
    name: !empty(cMKManagedServicesKeyName) ? cMKManagedServicesKeyName : 'dummyKey'
  }
}

resource workspace 'Microsoft.Databricks/workspaces@2023-02-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: skuName
  }
  properties: {
    managedResourceGroupId: !empty(managedResourceGroupResourceId) ? managedResourceGroupResourceId : '${subscription().id}/resourceGroups/${name}-rg'
    parameters: union(
      // Always added parameters
      {
        enableNoPublicIp: {
          value: disablePublicIp
        }
        prepareEncryption: {
          value: prepareEncryption
        }
        vnetAddressPrefix: {
          value: vnetAddressPrefix
        }
        requireInfrastructureEncryption: {
          value: requireInfrastructureEncryption
        }
      },
      // Parameters only added if not empty
      !empty(customVirtualNetworkResourceId) ? {
        customVirtualNetworkId: {
          value: customVirtualNetworkResourceId
        }
      } : {},
      !empty(amlWorkspaceResourceId) ? {
        amlWorkspaceId: {
          value: amlWorkspaceResourceId
        }
      } : {},
      !empty(customPrivateSubnetName) ? {
        customPrivateSubnetName: {
          value: customPrivateSubnetName
        }
      } : {},
      !empty(customPublicSubnetName) ? {
        customPublicSubnetName: {
          value: customPublicSubnetName
        }
      } : {},
      !empty(loadBalancerBackendPoolName) ? {
        loadBalancerBackendPoolName: {
          value: loadBalancerBackendPoolName
        }
      } : {},
      !empty(loadBalancerResourceId) ? {
        loadBalancerId: {
          value: loadBalancerResourceId
        }
      } : {},
      !empty(natGatewayName) ? {
        natGatewayName: {
          value: natGatewayName
        }
      } : {},
      !empty(publicIpName) ? {
        publicIpName: {
          value: publicIpName
        }
      } : {},
      !empty(storageAccountName) ? {
        storageAccountName: {
          value: storageAccountName
        }
      } : {},
      !empty(storageAccountSkuName) ? {
        storageAccountSkuName: {
          value: storageAccountSkuName
        }
      } : {})
    publicNetworkAccess: publicNetworkAccess
    requiredNsgRules: requiredNsgRules
    encryption: !empty(cMKManagedServicesKeyName) || !empty(cMKManagedServicesKeyName) ? {
      entities: {
        managedServices: !empty(cMKManagedServicesKeyName) ? {
          keySource: 'Microsoft.Keyvault'
          keyVaultProperties: {
            keyVaultUri: cMKManagedServicesKeyVault.properties.vaultUri
            keyName: cMKManagedServicesKeyName
            keyVersion: !empty(cMKManagedServicesKeyVersion) ? cMKManagedServicesKeyVersion : last(split(cMKManagedServicesKeyVault::cMKKey.properties.keyUriWithVersion, '/'))
          }
        } : null
        managedDisk: !empty(cMKManagedDisksKeyName) ? {
          keySource: 'Microsoft.Keyvault'
          keyVaultProperties: {
            keyVaultUri: cMKManagedDisksKeyVault.properties.vaultUri
            keyName: cMKManagedDisksKeyName
            keyVersion: !empty(cMKManagedDisksKeyVersion) ? cMKManagedDisksKeyVersion : last(split(cMKManagedDisksKeyVault::cMKKeyDisk.properties.keyUriWithVersion, '/'))
          }
          rotationToLatestKeyVersionEnabled: cMKManagedDisksKeyRotationToLatestKeyVersionEnabled
        } : null
      }
    } : null
  }
}

resource workspace_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot delete or modify the resource or child resources.'
  }
  scope: workspace
}

// Note: Diagnostic Settings are only supported by the premium tier
resource workspace_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [for (diagnosticSetting, index) in (diagnosticSettings ?? []): {
  name: diagnosticSetting.?name ?? '${name}-diagnosticSettings'
  properties: {
    storageAccountId: diagnosticSetting.?storageAccountResourceId
    workspaceId: diagnosticSetting.?workspaceResourceId
    eventHubAuthorizationRuleId: diagnosticSetting.?eventHubAuthorizationRuleResourceId
    eventHubName: diagnosticSetting.?eventHubName
    logs: diagnosticSetting.?logCategoriesAndGroups ?? [
      {
        categoryGroup: 'AllLogs'
        enabled: true
      }
    ]
    marketplacePartnerId: diagnosticSetting.?marketplacePartnerResourceId
    logAnalyticsDestinationType: diagnosticSetting.?logAnalyticsDestinationType
  }
  scope: workspace
}]

resource workspace_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for (roleAssignment, index) in (roleAssignments ?? []): {
  name: guid(workspace.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
  properties: {
    roleDefinitionId: contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : roleAssignment.roleDefinitionIdOrName
    principalId: roleAssignment.principalId
    description: roleAssignment.?description
    principalType: roleAssignment.?principalType
    condition: roleAssignment.?condition
    conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
    delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
  }
  scope: workspace
}]

module workspace_privateEndpoints '../../network/private-endpoint/main.bicep' = [for (privateEndpoint, index) in (privateEndpoints ?? []): {
  name: '${uniqueString(deployment().name, location)}-workspace-PrivateEndpoint-${index}'
  params: {
    groupIds: [
      privateEndpoint.?service ?? 'databricks_ui_api'
    ]
    name: privateEndpoint.?name ?? 'pep-${last(split(workspace.id, '/'))}-${privateEndpoint.?service ?? 'databricks_ui_api'}-${index}'
    serviceResourceId: workspace.id
    subnetResourceId: privateEndpoint.subnetResourceId
    enableDefaultTelemetry: privateEndpoint.?enableDefaultTelemetry ?? enableReferencedModulesTelemetry
    location: privateEndpoint.?location ?? reference(split(privateEndpoint.subnetResourceId, '/subnets/')[0], '2020-06-01', 'Full').location
    lock: privateEndpoint.?lock ?? lock
    privateDnsZoneGroupName: privateEndpoint.?privateDnsZoneGroupName
    privateDnsZoneResourceIds: privateEndpoint.?privateDnsZoneResourceIds
    roleAssignments: privateEndpoint.?roleAssignments
    tags: privateEndpoint.?tags ?? tags
    manualPrivateLinkServiceConnections: privateEndpoint.?manualPrivateLinkServiceConnections
    customDnsConfigs: privateEndpoint.?customDnsConfigs
    ipConfigurations: privateEndpoint.?ipConfigurations
    applicationSecurityGroupResourceIds: privateEndpoint.?applicationSecurityGroupResourceIds
    customNetworkInterfaceName: privateEndpoint.?customNetworkInterfaceName
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

type privateEndpointType = {
  @description('Optional. The name of the private endpoint.')
  name: string?

  @description('Optional. The location to deploy the private endpoint to.')
  location: string?

  @description('Optional. The service (sub-) type to deploy the private endpoint for. For example "vault" or "blob".')
  service: string?

  @description('Required. Resource ID of the subnet where the endpoint needs to be created.')
  subnetResourceId: string

  @description('Optional. The name of the private DNS zone group to create if privateDnsZoneResourceIds were provided.')
  privateDnsZoneGroupName: string?

  @description('Optional. The private DNS zone groups to associate the private endpoint with. A DNS zone group can support up to 5 DNS zones.')
  privateDnsZoneResourceIds: string[]?

  @description('Optional. Custom DNS configurations.')
  customDnsConfigs: {
    fqdn: string?
    ipAddresses: string[]
  }[]?

  @description('Optional. A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints.')
  ipConfigurations: {
    name: string
    groupId: string
    memberName: string
    privateIpAddress: string
  }[]?

  @description('Optional. Application security groups in which the private endpoint IP configuration is included.')
  applicationSecurityGroupResourceIds: string[]?

  @description('Optional. The custom name of the network interface attached to the private endpoint.')
  customNetworkInterfaceName: string?

  @description('Optional. Specify the type of lock.')
  lock: lockType

  @description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
  roleAssignments: roleAssignmentType

  @description('Optional. Tags to be applied on all resources/resource groups in this deployment.')
  tags: object?

  @description('Optional. Manual PrivateLink Service Connections.')
  manualPrivateLinkServiceConnections: array?

  @description('Optional. Enable/Disable usage telemetry for module.')
  enableTelemetry: bool?
}[]?

type diagnosticSettingType = {
  @description('Optional. The name of diagnostic setting.')
  name: string?

  @description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to \'\' to disable log collection.')
  logCategoriesAndGroups: {
    @description('Optional. Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.')
    category: string?

    @description('Optional. Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to \'AllLogs\' to collect all logs.')
    categoryGroup: string?
  }[]?

  @description('Optional. A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type.')
  logAnalyticsDestinationType: ('Dedicated' | 'AzureDiagnostics' | null)?

  @description('Optional. Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  workspaceResourceId: string?

  @description('Optional. Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  storageAccountResourceId: string?

  @description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
  eventHubAuthorizationRuleResourceId: string?

  @description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  eventHubName: string?

  @description('Optional. The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.')
  marketplacePartnerResourceId: string?
}[]?
