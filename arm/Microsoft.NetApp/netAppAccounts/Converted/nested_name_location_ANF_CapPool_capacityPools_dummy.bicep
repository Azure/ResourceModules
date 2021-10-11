param netAppAccountName string
param location string
param lockForDeletion bool
param tags object
param capacityPool object
param builtInRoleNames object

module name_Rbac_capacityPool_roleAssignments_dummy './nested_name_Rbac_capacityPool_roleAssignments_dummy.bicep' = [for i in range(0, length(array(capacityPool.roleAssignments))): {
  name: '${deployment().name}-Rbac-${(empty(capacityPool.roleAssignments) ? 'dummy' : i)}'
  params: {
    netAppAccountName: netAppAccountName
    capacityPoolName: capacityPool.poolName
    roleAssignment: array(capacityPool.roleAssignments)[i]
    builtInRoleNames: builtInRoleNames
  }
  dependsOn: []
}]

@batchSize(1)
resource netAppAccountName_capacityPool_poolName_capacityPool_volumes_dummy_capacityPool_volumes_volumeLoop_poolVolumeName 'Microsoft.NetApp/netAppAccounts/capacityPools/volumes@2021-04-01' = [for i in range(0, length(capacityPool.volumes)): if (!empty(capacityPool.volumes)) {
  name: '${netAppAccountName}/${capacityPool.poolName}/${(empty(capacityPool.volumes) ? 'dummy' : capacityPool.volumes[i].poolVolumeName)}'
  tags: tags
  location: location
  properties: {
    serviceLevel: capacityPool.poolServiceLevel
    creationToken: capacityPool.volumes[i].creationToken
    usageThreshold: capacityPool.volumes[i].poolVolumeQuota
    protocolTypes: capacityPool.volumes[i].protocolTypes
    subnetId: capacityPool.volumes[i].subnetId
    exportPolicy: ((!contains(capacityPool.volumes[i], 'exportPolicy')) ? json('null') : capacityPool.volumes[i].exportPolicy)
  }
  dependsOn: []
}]

@batchSize(1)
resource netAppAccountName_capacityPool_poolName_capacityPool_volumes_dummy_capacityPool_volumes_volumeLoop_poolVolumeName_Microsoft_Authorization_volumesDoNotDelete 'Microsoft.NetApp/netAppAccounts/capacityPools/volumes/providers/locks@2016-09-01' = [for i in range(0, length(capacityPool.volumes)): if (!empty(capacityPool.volumes)) {
  name: '${netAppAccountName}/${capacityPool.poolName}/${(empty(capacityPool.volumes) ? 'dummy' : capacityPool.volumes[i].poolVolumeName)}/Microsoft.Authorization/volumesDoNotDelete'
  properties: {
    level: 'CannotDelete'
  }
  dependsOn: [
    'Microsoft.NetApp/netAppAccounts/${netAppAccountName}/capacityPools/${capacityPool.poolName}/volumes/${(empty(capacityPool.volumes) ? 'dummy' : capacityPool.volumes[i].poolVolumeName)}'
  ]
}]

module name_Vol_capacityPool_volumes_dummy './nested_name_Vol_capacityPool_volumes_dummy.bicep' = [for i in range(0, length(array(capacityPool.volumes))): {
  name: '${deployment().name}-Vol-${(empty(array(capacityPool.volumes)) ? 'dummy' : i)}'
  params: {
    netAppAccountName: netAppAccountName
    capacityPoolName: capacityPool.poolName
    volume: array(capacityPool.volumes)[i]
    builtInRoleNames: builtInRoleNames
  }
  dependsOn: [
    netAppAccountName_capacityPool_poolName_capacityPool_volumes_dummy_capacityPool_volumes_volumeLoop_poolVolumeName
  ]
}]