targetScope = 'tenant'
param MGConfig object
param builtInRoleNames object
param MGDeplLoop int

module MGRbacDeplLoop_MGDeplLoop_mgRBACDeplLoop './nested_MGRbacDeplLoop_MGDeplLoop_mgRBACDeplLoop.bicep' = [for i in range(0, (contains(MGConfig, 'roleAssignments') ? length(array(MGConfig.roleAssignments)) : 0)): {
  name: 'MGRbacDeplLoop-${MGDeplLoop}-${i}'
  params: {
    MGName: MGConfig.name
    roleAssignment: array(MGConfig.roleAssignments)[i]
    builtInRoleNames: builtInRoleNames
  }
  dependsOn: []
}]
