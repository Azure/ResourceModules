targetScope = 'managementGroup'
param name string
param displayName string = ''
param description string = ''
param mode string = 'All'
param metadata object = {}
param parameters object = {}
param policyRule object
param managementGroupId string

var name_var = toLower(replace(name, ' ', '-'))

resource policyDefinition 'Microsoft.Authorization/policyDefinitions@2021-06-01' = {
  name: name_var
  properties: {
    policyType: 'Custom'
    mode: mode
    displayName: empty(displayName) ? null : displayName
    description: empty(description) ? null : description
    metadata: empty(metadata) ? null : metadata
    parameters: empty(parameters) ? null : parameters
    policyRule: policyRule
  }
}

output PolicyDefinitionName string = policyDefinition.name
output policyDefinitionResourceId string = extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', managementGroupId), 'Microsoft.Authorization/policyDefinitions', policyDefinition.name)
output roleDefinitionIds array = (contains(policyDefinition.properties.policyRule.then, 'details') ? ((contains(policyDefinition.properties.policyRule.then.details, 'roleDefinitionIds') ? policyDefinition.properties.policyRule.then.details.roleDefinitionIds : [])) : [])
