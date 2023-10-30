metadata name = 'NAT Gateways'
metadata description = 'This module deploys a NAT Gateway.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the Azure Bastion resource.')
param name string

@description('Optional. The idle timeout of the NAT gateway.')
param idleTimeoutInMinutes int = 5

@description('Optional. Use to have a new Public IP Address created for the NAT Gateway.')
param natGatewayPublicIpAddress bool = false

@description('Optional. Specifies the name of the Public IP used by the NAT Gateway. If it\'s not provided, a \'-pip\' suffix will be appended to the Bastion\'s name.')
param natGatewayPipName string = ''

@description('Optional. Resource ID of the Public IP Prefix object. This is only needed if you want your Public IPs created in a PIP Prefix.')
param publicIPPrefixResourceId string = ''

@description('Optional. DNS name of the Public IP resource. A region specific suffix will be appended to it, e.g.: your-DNS-name.westeurope.cloudapp.azure.com.')
param domainNameLabel string = ''

@description('Optional. Existing Public IP Address resource names to use for the NAT Gateway.')
param publicIpAddresses array = []

@description('Optional. Existing Public IP Prefixes resource names to use for the NAT Gateway.')
param publicIpPrefixes array = []

@description('Optional. A list of availability zones denoting the zone in which Nat Gateway should be deployed.')
param zones array = []

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments roleAssignmentType

@description('Optional. Tags for the resource.')
param tags object = {}

@description('Optional. The diagnostic settings of the Public IP.')
param publicIpDiagnosticSettings diagnosticSettingType

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

var publicIPPrefixResourceIds = [for publicIpPrefix in publicIpPrefixes: {
  id: az.resourceId('Microsoft.Network/publicIPPrefixes', publicIpPrefix)
}]

var publicIPAddressResourceIds = [for publicIpAddress in publicIpAddresses: {
  id: az.resourceId('Microsoft.Network/publicIPAddresses', publicIpAddress)
}]

var enableReferencedModulesTelemetry = false

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Network Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4d97b98b-1d4f-4787-a291-c67834d212e7')
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

// PUBLIC IP
// =========
module publicIPAddress '../public-ip-address/main.bicep' = if (natGatewayPublicIpAddress) {
  name: '${uniqueString(deployment().name, location)}-NatGateway-PIP'
  params: {
    name: !empty(natGatewayPipName) ? natGatewayPipName : '${name}-pip'
    diagnosticSettings: publicIpDiagnosticSettings
    domainNameLabel: domainNameLabel
    enableDefaultTelemetry: enableReferencedModulesTelemetry
    location: location
    lock: lock
    publicIPAllocationMethod: 'Static'
    publicIPPrefixResourceId: publicIPPrefixResourceId
    tags: tags
    skuName: 'Standard'
    zones: [
      '1'
      '2'
      '3'
    ]
  }
}

// NAT GATEWAY
// ===========
resource natGateway 'Microsoft.Network/natGateways@2023-04-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: 'Standard'
  }
  properties: {
    idleTimeoutInMinutes: idleTimeoutInMinutes
    publicIpPrefixes: publicIPPrefixResourceIds
    publicIpAddresses: publicIPAddressResourceIds
  }
  zones: zones
  dependsOn: [ publicIPAddress ]
}

resource natGateway_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot delete or modify the resource or child resources.'
  }
  scope: natGateway
}

resource natGateway_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for (roleAssignment, index) in (roleAssignments ?? []): {
  name: guid(natGateway.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
  properties: {
    roleDefinitionId: contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : roleAssignment.roleDefinitionIdOrName
    principalId: roleAssignment.principalId
    description: roleAssignment.?description
    principalType: roleAssignment.?principalType
    condition: roleAssignment.?condition
    conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
    delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
  }
  scope: natGateway
}]

@description('The name of the NAT Gateway.')
output name string = natGateway.name

@description('The resource ID of the NAT Gateway.')
output resourceId string = natGateway.id

@description('The resource group the NAT Gateway was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = natGateway.location

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

  @description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to \'\' to disable log collection.')
  metricCategories: {
    @description('Required. Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to \'AllMetrics\' to collect all metrics.')
    category: string
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
