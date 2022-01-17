@description('Required. The name of the NetApp account.')
param netAppAccountName string

@description('Required. The name of the capacity pool.')
param capacityPoolName string

@description('Required. The name of the pool volume.')
param name string

@description('Optional. Location of the pool volume.')
param location string = resourceGroup().location

@description('Optional. The pool service level. Must match the one of the parent capacity pool.')
@allowed([
  'Premium'
  'Standard'
  'StandardZRS'
  'Ultra'
])
param serviceLevel string = 'Standard'

@description('Optional. A unique file path for the volume. This is the name of the volume export. A volume is mounted using the export path. File path must start with an alphabetical character and be unique within the subscription.')
param creationToken string = name

@description('Required. Maximum storage quota allowed for a file system in bytes.')
param usageThreshold int

@description('Optional. Set of protocol types.')
param protocolTypes array = []

@description('Required. The Azure Resource URI for a delegated subnet. Must have the delegation Microsoft.NetApp/volumes.')
param subnetResourceId string

@description('Optional. Export policy rules.')
param exportPolicyRules array = []

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or it\'s fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered')
param cuaId string = ''

resource pid_cuaId 'Microsoft.Resources/deployments@2021-04-01' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource netAppAccount 'Microsoft.NetApp/netAppAccounts@2021-04-01' existing = {
  name: netAppAccountName

  resource capacityPool 'capacityPools@2021-06-01' existing = {
    name: capacityPoolName
  }
}

resource volume 'Microsoft.NetApp/netAppAccounts/capacityPools/volumes@2021-06-01' = {
  name: name
  parent: netAppAccount::capacityPool
  location: location
  properties: {
    serviceLevel: serviceLevel
    creationToken: creationToken
    usageThreshold: usageThreshold
    protocolTypes: protocolTypes
    subnetId: subnetResourceId
    exportPolicy: !empty(exportPolicyRules) ? {
      rules: exportPolicyRules
    } : null
  }
}

module volume_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${deployment().name}-Rbac-${index}'
  params: {
    principalIds: roleAssignment.principalIds
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    resourceId: volume.id
  }
}]

@description('The name of the Volume.')
output volumeName string = volume.name

@description('The Resource ID of the Volume.')
output volumeResourceId string = volume.id

@description('The name of the Resource Group the Volume was created in.')
output volumeResourceGroup string = resourceGroup().name
