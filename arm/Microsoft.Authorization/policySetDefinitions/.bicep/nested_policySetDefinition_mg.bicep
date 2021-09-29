targetScope = 'managementGroup'
param policySetDefinitionName string
param properties object
param managementGroupId string
param location string = deployment().location

resource policySetDefinition 'Microsoft.Authorization/policySetDefinitions@2020-09-01' = {
  name: policySetDefinitionName
  location: location
  properties: properties
}

output policySetDefinitionId string = extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups',managementGroupId),'Microsoft.Authorization/policySetDefinitions',policySetDefinition.name)
