targetScope = 'subscription'
param policyDefinitionName string
param displayName string = ''
param policyDescription string = ''
param mode string = 'All'
param metadata object = {}
param parameters object = {}
param policyRule object
param subscriptionId string = ''
param location string = deployment().location

var policyDefinitionName_var = toLower(replace(policyDefinitionName, ' ', '-'))

resource policyDefinition 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: policyDefinitionName_var
  location: location
  properties: {
    policyType: 'Custom'
    mode: mode
    displayName: (empty(displayName) ? null : displayName)
    description: (empty(policyDescription) ? null : policyDescription)
    metadata: (empty(metadata) ? null : metadata)
    parameters: (empty(parameters) ? null : parameters)
    policyRule: policyRule
  }
}

output policyDefinitionName string = policyDefinition.name
output policyDefinitionId string = subscriptionResourceId(subscriptionId, 'Microsoft.Authorization/policyDefinitions', policyDefinition.name)
output roleDefinitionIds array = (contains(policyDefinition.properties.policyRule.then, 'details') ? ((contains(policyDefinition.properties.policyRule.then.details, 'roleDefinitionIds') ? policyDefinition.properties.policyRule.then.details.roleDefinitionIds : [])) : [])
