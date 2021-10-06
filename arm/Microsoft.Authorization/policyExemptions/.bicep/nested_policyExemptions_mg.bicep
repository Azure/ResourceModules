targetScope = 'managementGroup'

param policyExemptionName string
param policyExemptionProperties object
param managementGroupId string
param location string = deployment().location

resource policyExemption 'Microsoft.Authorization/policyExemptions@2020-07-01-preview' = {
  name: policyExemptionName
  location: location
  properties: policyExemptionProperties
}

output policyExemptionId string =   extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups',managementGroupId),'Microsoft.Authorization/policyExemptions',policyExemption.name)
output policyExemptionScope string = tenantResourceId('Microsoft.Management/managementGroups',managementGroupId)
