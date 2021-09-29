targetScope = 'managementGroup'
param policyDefinitionName string
param properties object
param managementGroupId string
param returnRoleDefinitions bool = false

resource policyDefinition 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: policyDefinitionName
  properties: properties
}

output policyDefinitionId string =   extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups',managementGroupId),'Microsoft.Authorization/policyDefinitions',policyDefinition.name)
output roleDefinitionIds array = returnRoleDefinitions ? properties.policyRule.then.details.roleDefinitionIds : []
