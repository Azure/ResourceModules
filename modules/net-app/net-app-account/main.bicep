metadata name = 'Azure NetApp Files'
metadata description = 'This module deploys an Azure NetApp File.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the NetApp account.')
param name string

@description('Optional. Fully Qualified Active Directory DNS Domain Name (e.g. \'contoso.com\').')
param domainName string = ''

@description('Optional. Required if domainName is specified. Username of Active Directory domain administrator, with permissions to create SMB server machine account in the AD domain.')
param domainJoinUser string = ''

@description('Optional. Required if domainName is specified. Password of the user specified in domainJoinUser parameter.')
@secure()
param domainJoinPassword string = ''

@description('Optional. Used only if domainName is specified. LDAP Path for the Organization Unit (OU) where SMB Server machine accounts will be created (i.e. \'OU=SecondLevel,OU=FirstLevel\').')
param domainJoinOU string = ''

@description('Optional. Required if domainName is specified. Comma separated list of DNS server IP addresses (IPv4 only) required for the Active Directory (AD) domain join and SMB authentication operations to succeed.')
param dnsServers string = ''

@description('Optional. Required if domainName is specified. NetBIOS name of the SMB server. A computer account with this prefix will be registered in the AD and used to mount volumes.')
param smbServerNamePrefix string = ''

@description('Optional. Capacity pools to create.')
param capacityPools array = []

@description('Optional. The ID(s) to assign to the resource.')
param userAssignedIdentities object = {}

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments roleAssignmentType

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Tags for all resources.')
param tags object = {}

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

var enableReferencedModulesTelemetry = false

var activeDirectoryConnectionProperties = [
  {
    username: !empty(domainName) ? domainJoinUser : null
    password: !empty(domainName) ? domainJoinPassword : null
    domain: !empty(domainName) ? domainName : null
    dns: !empty(domainName) ? dnsServers : null
    smbServerName: !empty(domainName) ? smbServerNamePrefix : null
    organizationalUnit: !empty(domainJoinOU) ? domainJoinOU : null
  }
]

var identityType = !empty(userAssignedIdentities) ? 'UserAssigned' : 'None'

var identity = identityType != 'None' ? {
  type: identityType
  userAssignedIdentities: !empty(userAssignedIdentities) ? userAssignedIdentities : null
} : null

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
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
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

resource netAppAccount 'Microsoft.NetApp/netAppAccounts@2022-11-01' = {
  name: name
  tags: tags
  identity: identity
  location: location
  properties: {
    activeDirectories: !empty(domainName) ? activeDirectoryConnectionProperties : null
  }
}

resource netAppAccount_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot delete or modify the resource or child resources.'
  }
  scope: netAppAccount
}

resource netAppAccount_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for (roleAssignment, index) in (roleAssignments ?? []): {
  name: guid(netAppAccount.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
  properties: {
    roleDefinitionId: contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : roleAssignment.roleDefinitionIdOrName
    principalId: roleAssignment.principalId
    description: roleAssignment.?description
    principalType: roleAssignment.?principalType
    condition: roleAssignment.?condition
    conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
    delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
  }
}]

module netAppAccount_capacityPools 'capacity-pool/main.bicep' = [for (capacityPool, index) in capacityPools: {
  name: '${uniqueString(deployment().name, location)}-ANFAccount-CapPool-${index}'
  params: {
    netAppAccountName: netAppAccount.name
    name: capacityPool.name
    location: location
    size: capacityPool.size
    serviceLevel: contains(capacityPool, 'serviceLevel') ? capacityPool.serviceLevel : 'Standard'
    qosType: contains(capacityPool, 'qosType') ? capacityPool.qosType : 'Auto'
    volumes: contains(capacityPool, 'volumes') ? capacityPool.volumes : []
    coolAccess: contains(capacityPool, 'coolAccess') ? capacityPool.coolAccess : false
    roleAssignments: contains(capacityPool, 'roleAssignments') ? capacityPool.roleAssignments : []
    encryptionType: contains(capacityPool, 'encryptionType') ? capacityPool.encryptionType : 'Single'
    tags: contains(capacityPool, 'tags') ? capacityPool.tags : {}
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

@description('The name of the NetApp account.')
output name string = netAppAccount.name

@description('The Resource ID of the NetApp account.')
output resourceId string = netAppAccount.id

@description('The name of the Resource Group the NetApp account was created in.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = netAppAccount.location

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
