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

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = ''

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

resource netAppAccount 'Microsoft.NetApp/netAppAccounts@2022-05-01' = {
  name: name
  tags: tags
  location: location
  properties: {
    activeDirectories: !empty(domainName) ? activeDirectoryConnectionProperties : null
  }
}

resource netAppAccount_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock)) {
  name: '${netAppAccount.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: netAppAccount
}

module netAppAccount_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-ANFAccount-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: netAppAccount.id
  }
}]

module netAppAccount_capacityPools 'capacity-pools/main.bicep' = [for (capacityPool, index) in capacityPools: {
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
