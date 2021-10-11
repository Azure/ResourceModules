param netAppAccountName string
param capacityPoolName string
param volume object
param builtInRoleNames object

module name_Rbac_volume_roleAssignments_dummy './nested_name_Rbac_volume_roleAssignments_dummy.bicep' = [for i in range(0, length(array(volume.roleAssignments))): {
  name: '${deployment().name}-Rbac-${(empty(array(volume.roleAssignments)) ? 'dummy' : i)}'
  params: {
    netAppAccountName: netAppAccountName
    capacityPoolName: capacityPoolName
    volumeName: volume.poolVolumeName
    roleAssignment: array(volume.roleAssignments)[i]
    builtInRoleNames: builtInRoleNames
  }
  dependsOn: []
}]