targetScope = 'subscription'
param policySetDefinitionName string
param properties object
param subscriptionId string = subscription().id
param location string = deployment().location

resource policySetDefinition 'Microsoft.Authorization/policySetDefinitions@2020-09-01' = {
  name: policySetDefinitionName
  location: location
  properties: properties
}

output policySetDefinitionId string = subscriptionResourceId(subscriptionId,'Microsoft.Authorization/policySetDefinitions',policySetDefinition.name)
