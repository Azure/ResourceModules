param volumeObj object
param location string
param capacityPoolName string
param poolServiceLevel string

resource volume 'Microsoft.NetApp/netAppAccounts/capacityPools/volumes@2021-04-01' = {
  name: '${capacityPoolName}/${volumeObj.poolVolumeName}'
  location: location
  properties: {
    serviceLevel: poolServiceLevel
    creationToken: volumeObj.creationToken
    usageThreshold: volumeObj.poolVolumeQuota
    protocolTypes: volumeObj.protocolTypes
    subnetId: volumeObj.subnetId
    exportPolicy: (contains(volumeObj, 'exportPolicy') ? volumeObj.exportPolicy : json('null'))
  }
}

module volume_rbac 'nested_capacityPool_volume_rbac.bicep' = [for (roleAssignment, index) in volumeObj.roleAssignments: {
  name: '${deployment().name}-Rbac-${index}'
  params: {
    roleAssignmentObj: roleAssignment
    resourceName: volume.name
  }
}]
