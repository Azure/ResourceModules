@description('Required. The name of the NetApp account.')
param netAppAccountName string

@description('Required. The name of the capacity pool.')
param capacityPoolName string

@description('Required. The name of the pool volume.')
param name string

@description('Optional. Location of the pool volume.')
param location string = resourceGroup().location

@description('Optional. The pool service level.')
@allowed([
  'Premium'
  'Standard'
  'StandardZRS'
  'Ultra'
])
param serviceLevel string = 'Standard'

@description('Required. A unique file path for the volume.')
param creationToken string

@description('Required. Maximum storage quota allowed for a file system in bytes.')
param usageThreshold int

@description('Optional. Set of protocol types.')
param protocolTypes array = []

@description('Required. The Azure Resource URI for a delegated subnet. Must have the delegation Microsoft.NetApp/volumes.')
param subnetId string

@description('Optional. The Azure Resource URI for a delegated subnet. Must have the delegation Microsoft.NetApp/volumes.')
param exportPolicy object = {}

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or it\'s fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource netAppAccount 'Microsoft.NetApp/netAppAccounts@2021-04-01' existing = {
  name: netAppAccountName
  resource capacityPool 'capacityPools@2021-06-01' existing = {
    name: capacityPoolName
    resource volume 'volumes@2021-06-01' = {
      name: name
      location: location
      properties: {
        serviceLevel: serviceLevel
        creationToken: creationToken
        usageThreshold: usageThreshold
        protocolTypes: protocolTypes
        subnetId: subnetId
        exportPolicy: empty(exportPolicy) ? null : exportPolicy
      }
    }
  }
}

module volume_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${deployment().name}-Rbac-${index}'
  params: {
    roleAssignmentObj: roleAssignment
    resourceName: '${netAppAccountName}/${netAppAccount::capacityPool.name}/${netAppAccount::capacityPool::volume.name}'
  }
}]

@description('The name of the Volume.')
output volumeName string = netAppAccount::capacityPool::volume.name

@description('The Resource Id of the Volume.')
output volumeResourceId string = netAppAccount::capacityPool::volume.id

@description('The name of the Resource Group the Volume was created in.')
output volumeResourceGroup string = resourceGroup().name
