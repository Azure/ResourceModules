targetScope = 'resourceGroup'

param policyExemptionName string
param policyExemptionProperties object
param subscriptionId string = subscription().subscriptionId
param resourceGroupName string = resourceGroup().name

resource policyExemption 'Microsoft.Authorization/policyExemptions@2020-07-01-preview' = {
  name: policyExemptionName
  properties: policyExemptionProperties
}

output policyExemptionId string = resourceId(subscriptionId, resourceGroupName, 'Microsoft.Authorization/policyExemptions', policyExemption.name)
output policyExemptionScope string = resourceGroup().id
