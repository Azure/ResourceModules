targetScope = 'managementGroup'
param name string
param displayName string = ''
param description string = ''
param metadata object = {}
param policyDefinitions array
param policyDefinitionGroups array = []
param parameters object = {}
param managementGroupId string

var name_var = replace(name, ' ', '-')

resource policySetDefinition 'Microsoft.Authorization/policySetDefinitions@2021-06-01' = {
  name: name_var
  properties: {
    policyType: 'Custom'
    displayName: empty(displayName) ? null : displayName
    description: empty(description) ? null : description
    metadata: empty(metadata) ? null : metadata
    parameters: empty(parameters) ? null : parameters
    policyDefinitions: policyDefinitions
    policyDefinitionGroups: empty(policyDefinitionGroups) ? [] : policyDefinitionGroups
  }
}

output policySetDefinitionName string = policySetDefinition.name
output policySetDefinitionResourceId string = extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups', managementGroupId), 'Microsoft.Authorization/policySetDefinitions', policySetDefinition.name)
