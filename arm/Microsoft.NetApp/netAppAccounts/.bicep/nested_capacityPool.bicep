param capacityPoolObj object
param location string
param netAppAccountName string

resource capacityPool 'Microsoft.NetApp/netAppAccounts/capacityPools@2021-04-01' = {
  name: '${netAppAccountName}/${capacityPoolObj.poolName}'
  location: location
  properties: {
    serviceLevel: capacityPoolObj.poolServiceLevel
    size: capacityPoolObj.poolSize
  }
}

module capacityPool_volumes 'nested_capacityPool_volume.bicep' = [for (volume, index) in capacityPoolObj.volumes: {
  name: '${deployment().name}-Vol-${index}'
  params: {
    volumeObj: volume
    location: location
    capacityPoolName: capacityPool.name
    poolServiceLevel: capacityPool.properties.serviceLevel
  }
}]

module capacityPool_rbac 'nested_capacityPool_rbac.bicep' = [for (roleAssignment, index) in capacityPoolObj.roleAssignments: {
  name: '${deployment().name}-Rbac-${index}'
  params: {
    roleAssignmentObj: roleAssignment
    resourceName: capacityPool.name
  }
}]
