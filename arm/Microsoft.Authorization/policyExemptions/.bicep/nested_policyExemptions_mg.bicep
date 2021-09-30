targetScope = 'managementGroup'

param policyExemptionName string
param properties object
param managementGroupId string

resource policyExemption 'Microsoft.Authorization/policyExemptions@2020-07-01-preview' = {
  name: policyExemptionName
  properties: properties
}

output policyExemptionId string =   extensionResourceId(tenantResourceId('Microsoft.Management/managementGroups',managementGroupId),'Microsoft.Authorization/policyExemptions',policyExemption.name)
output policyExemptionScope string = tenantResourceId('Microsoft.Management/managementGroups',managementGroupId)
