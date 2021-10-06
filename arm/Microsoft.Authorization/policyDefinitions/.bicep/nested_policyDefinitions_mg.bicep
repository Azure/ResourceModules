targetScope = 'managementGroup'
param policyDefinitionName string
param policyDefinitionProperties object
param managementGroupId string
param location string = deployment().location

resource policyDefinition 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: policyDefinitionName
  location: location
  properties: policyDefinitionProperties
}

output policyDefinitionId string =   extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups',managementGroupId),'Microsoft.Authorization/policyDefinitions',policyDefinition.name)
output roleDefinitionIds array = (contains(policyDefinitionProperties.policyRule.then, 'details') ? ((contains(policyDefinitionProperties.policyRule.then.details, 'roleDefinitionIds') ? policyDefinitionProperties.policyRule.then.details.roleDefinitionIds : [])) : [])
