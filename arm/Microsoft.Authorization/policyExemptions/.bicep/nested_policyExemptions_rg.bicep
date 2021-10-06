targetScope = 'resourceGroup'

param policyExemptionName string
param policyExemptionProperties object
param subscriptionId string = subscription().subscriptionId
param resourceGroupName string = resourceGroup().name
param location string = resourceGroup().location

resource policyExemption 'Microsoft.Authorization/policyExemptions@2020-07-01-preview' = {
  name: policyExemptionName
  location: location
  properties: policyExemptionProperties
}

output policyExemptionId string = resourceId(subscriptionId, resourceGroupName, 'Microsoft.Authorization/policyExemptions', policyExemption.name)
output policyExemptionScope string = resourceGroup().id
