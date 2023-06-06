@sys.description('Required. The IDs of the principals to assign the role to.')
param principalIds array

@sys.description('Required. The name of the role to assign. If it cannot be found you can specify the role definition ID instead.')
param roleDefinitionIdOrName string

@sys.description('Required. The resource ID of the resource to apply the role assignment to.')
param resourceId string

@sys.description('Optional. The principal type of the assigned principal ID.')
@allowed([
  'ServicePrincipal'
  'Group'
  'User'
  'ForeignGroup'
  'Device'
  ''
])
param principalType string = ''

@sys.description('Optional. The description of the role assignment.')
param description string = ''

@sys.description('Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".')
param condition string = ''

@sys.description('Optional. Version of the condition.')
@allowed([
  '2.0'
])
param conditionVersion string = '2.0'

@sys.description('Optional. Id of the delegated managed identity resource.')
param delegatedManagedIdentityResourceId string = ''

var builtInRoleNames = {
  'Azure Kubernetes Fleet Manager Contributor Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '63bb64ad-9799-4770-b5c3-24ed299a07bf')
  'Azure Kubernetes Fleet Manager RBAC Admin': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '434fb43a-c01c-447e-9f67-c3ad923cfaba')
  'Azure Kubernetes Fleet Manager RBAC Cluster Admin': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18ab4d3d-a1bf-4477-8ad9-8359bc988f69')
  'Azure Kubernetes Fleet Manager RBAC Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '30b27cfc-9c84-438e-b0ce-70e35255df80')
  'Azure Kubernetes Fleet Manager RBAC Writer': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '5af6afb3-c06c-4fa4-8848-71a8aee05683')
  'Azure Kubernetes Service Cluster Admin Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '0ab0b1a8-8aac-4efd-b8c2-3ee1fb270be8')
  'Azure Kubernetes Service Cluster Monitoring User': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '1afdec4b-e479-420e-99e7-f82237c7c5e6')
  'Azure Kubernetes Service Cluster User Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4abbcc35-e782-43d8-92c5-2d3f1bd2253f')
  'Azure Kubernetes Service Contributor Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ed7f3fbd-7b88-4dd4-9017-9adb7ce333f8')
  'Azure Kubernetes Service RBAC Admin': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3498e952-d568-435e-9b2c-8d77e338d7f7')
  'Azure Kubernetes Service RBAC Cluster Admin': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b1ff04bb-8a4e-4dc4-8eb5-8693973ce19b')
  'Azure Kubernetes Service RBAC Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f6c6a51-bcf8-42ba-9220-52d62157d7db')
  'Azure Kubernetes Service RBAC Writer': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'a7ffa36f-339b-4b5c-8bdf-e2c188b2c0eb')
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Kubernetes Agentless Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'd5a2ae44-610b-4500-93be-660a0c5f5ca6')
  'Log Analytics Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '92aaf0da-9dab-42b6-94a3-d43ce8d16293')
  'Log Analytics Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '73c42c96-874c-492b-b04d-ab87d138a893')
  'Managed Application Contributor Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '641177b8-a67a-45b9-a033-47bc880bb21e')
  'Managed Application Operator Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'c7393b34-138c-406f-901b-d8cf2b17e6ae')
  'Managed Applications Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b9331d33-8a36-4f8c-b097-4f54124fdb44')
  'Monitoring Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '749f88d5-cbae-40b8-bcfc-e573ddc772fa')
  'Monitoring Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '43d0d8ad-25c7-4714-9337-8ba259a9fe05')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Resource Policy Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '36243c78-bf99-498c-9df9-86d9f8d28608')
  'Role Based Access Control Administrator (Preview)': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f58310d9-a9f6-439a-9e8d-f62e7b41a168')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
}

resource managedCluster 'Microsoft.ContainerService/managedClusters@2022-11-01' existing = {
  name: last(split(resourceId, '/'))!
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for principalId in principalIds: {
  name: guid(managedCluster.id, principalId, roleDefinitionIdOrName)
  properties: {
    description: description
    roleDefinitionId: contains(builtInRoleNames, roleDefinitionIdOrName) ? builtInRoleNames[roleDefinitionIdOrName] : roleDefinitionIdOrName
    principalId: principalId
    principalType: !empty(principalType) ? any(principalType) : null
    condition: !empty(condition) ? condition : null
    conditionVersion: !empty(conditionVersion) && !empty(condition) ? conditionVersion : null
    delegatedManagedIdentityResourceId: !empty(delegatedManagedIdentityResourceId) ? delegatedManagedIdentityResourceId : null
  }
  scope: managedCluster
}]
