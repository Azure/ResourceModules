targetScope = 'subscription'
param policyDefinitionName string
param policyDefinitionProperties object
param subscriptionId string = subscription().id
param location string = deployment().location

resource policyDefinition 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: policyDefinitionName
  location: location
  properties: policyDefinitionProperties
}

output policyDefinitionId string = subscriptionResourceId(subscriptionId,'Microsoft.Authorization/policyDefinitions',policyDefinition.name)
output roleDefinitionIds array = (contains(policyDefinitionProperties.policyRule.then, 'details') ? ((contains(policyDefinitionProperties.policyRule.then.details, 'roleDefinitionIds') ? policyDefinitionProperties.policyRule.then.details.roleDefinitionIds : [])) : [])
