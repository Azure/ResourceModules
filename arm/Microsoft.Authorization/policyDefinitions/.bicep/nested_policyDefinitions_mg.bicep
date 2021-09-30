targetScope = 'managementGroup'
param policyDefinitionName string
param properties object
param managementGroupId string
param returnRoleDefinitionIds bool = false
param location string = deployment().location

resource policyDefinition 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: policyDefinitionName
  location: location
  properties: properties
}

output policyDefinitionId string =   extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups',managementGroupId),'Microsoft.Authorization/policyDefinitions',policyDefinition.name)
output roleDefinitionIds array = returnRoleDefinitionIds ? properties.policyRule.then.details.roleDefinitionIds : []
