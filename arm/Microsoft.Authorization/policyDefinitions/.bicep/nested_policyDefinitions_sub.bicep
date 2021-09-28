targetScope = 'subscription'
param policyDefinitionName string
param properties object
param subscriptionId string = subscription().id

resource policyDefinition 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: policyDefinitionName
  properties: properties
}

output policyDefinitionId string = subscriptionResourceId(subscriptionId,'Microsoft.Authorization/policySetDefinitions',policyDefinition.name)

