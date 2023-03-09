@sys.description('Required. The IDs of the principals to assign the role to.')
param principalIds array

@sys.description('Required. The name of the role to assign.')
@allowed([
  'AllDatabasesAdmin'
  'AllDatabasesViewer'
])
param role string

@sys.description('Required. The resource ID of the resource to apply the role assignment to.')
param resourceId string

@sys.description('Optional. The principal type of the assigned principal ID.')
@allowed([
  'App'
  'Group'
  'User'
])
param principalType string = 'Group'

resource azureDataExplorer 'Microsoft.Kusto/clusters@2022-12-29' existing = {
  name: last(split(resourceId, '/'))!
}

resource roleAssignment 'Microsoft.Kusto/clusters/principalAssignments@2022-12-29' = [for principalId in principalIds: {
  name: guid(azureDataExplorer.id, principalId, role)
  parent: azureDataExplorer
  properties: {
    role: role
    principalId: principalId
    principalType: !empty(principalType) ? any(principalType) : null
    tenantId: subscription().tenantId
  }
}]
