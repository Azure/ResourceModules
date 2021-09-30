targetScope = 'subscription'

param policyExemptionName string
param properties object
param subscriptionId string

resource policyExemption 'Microsoft.Authorization/policyExemptions@2020-07-01-preview' = {
  name: policyExemptionName
  properties: properties
}

output policyExemptionId string =   subscriptionResourceId(subscriptionId,'Microsoft.Authorization/policyExemptions',policyExemption.name)
output policyExemptionScope string = subscription().id
