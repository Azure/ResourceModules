targetScope = 'subscription'

param policyExemptionName string
param policyExemptionProperties object
param subscriptionId string
param location string = deployment().location

resource policyExemption 'Microsoft.Authorization/policyExemptions@2020-07-01-preview' = {
  name: policyExemptionName
  location: location
  properties: policyExemptionProperties
}

output policyExemptionId string =   subscriptionResourceId(subscriptionId,'Microsoft.Authorization/policyExemptions',policyExemption.name)
output policyExemptionScope string = subscription().id
