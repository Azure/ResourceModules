@description('Required. The name of the NetApp account.')
param netAppAccountName string

@description('Optional. Fully Qualified Active Directory DNS Domain Name (e.g. \'contoso.com\')')
param domainName string = ''

@description('Optional. Required if domainName is specified. Username of Active Directory domain administrator, with permissions to create SMB server machine account in the AD domain.')
param domainJoinUser string = ''

@description('Optional. Required if domainName is specified. Password of the user specified in domainJoinUser parameter')
@secure()
param domainJoinPassword string = ''

@description('Optional. Used only if domainName is specified. LDAP Path for the Organization Unit (OU) where SMB Server machine accounts will be created (i.e. \'OU=SecondLevel,OU=FirstLevel\').')
param domainJoinOU string = ''

@description('Optional. Required if domainName is specified. Comma separated list of DNS server IP addresses (IPv4 only) required for the Active Directory (AD) domain join and SMB authentication operations to succeed.')
param dnsServers string = ''

@description('Optional. Required if domainName is specified. NetBIOS name of the SMB server. A computer account with this prefix will be registered in the AD and used to mount volumes')
param smbServerNamePrefix string = ''

@description('Optional. Capacity pools to create.')
param capacityPools array = []

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or it\'s fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@allowed([
  'CanNotDelete'
  'NotSpecified'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = 'NotSpecified'

@description('Optional. Tags for all resources.')
param tags object = {}

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

var activeDirectoryConnectionProperties = [
  {
    username: (empty(domainName) ? json('null') : domainJoinUser)
    password: (empty(domainName) ? json('null') : domainJoinPassword)
    domain: (empty(domainName) ? json('null') : domainName)
    dns: (empty(domainName) ? json('null') : dnsServers)
    smbServerName: (empty(domainName) ? json('null') : smbServerNamePrefix)
    organizationalUnit: (empty(domainJoinOU) ? json('null') : domainJoinOU)
  }
]

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource netAppAccount 'Microsoft.NetApp/netAppAccounts@2021-04-01' = {
  name: netAppAccountName
  tags: tags
  location: location
  properties: {
    activeDirectories: (empty(domainName) ? json('null') : activeDirectoryConnectionProperties)
  }
}

resource netAppAccount_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lock != 'NotSpecified') {
  name: '${netAppAccount.name}-${lock}-lock'
  properties: {
    level: lock
    notes: (lock == 'CanNotDelete') ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: netAppAccount
}

module netAppAccount_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-ANFAccount-Rbac-${index}'
  params: {
    roleAssignmentObj: roleAssignment
    resourceName: netAppAccount.name
  }
}]

module netAppAccount_capacityPools '.bicep/nested_capacityPool.bicep' = [for (capacityPool, index) in capacityPools: {
  name: '${uniqueString(deployment().name, location)}-ANFAccount-CapPool-${index}'
  params: {
    capacityPoolObj: capacityPool
    location: location
    netAppAccountName: netAppAccount.name
  }
}]

output netAppAccountName string = netAppAccount.name
output netAppAccountResourceId string = netAppAccount.id
output netAppAccountResourceGroup string = resourceGroup().name
