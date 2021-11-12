targetScope = 'resourceGroup'

param policyExemptionName string
param displayName string = ''
param policyExemptionDescription string = ''
param metadata object = {}
param exemptionCategory string = 'Mitigated'
param policyAssignmentId string
param policyDefinitionReferenceIds array = []
param expiresOn string = ''
param subscriptionId string = subscription().subscriptionId
param resourceGroupName string = resourceGroup().name
param location string = resourceGroup().location

var policyExemptionName_var = toLower(replace(policyExemptionName, ' ', '-'))

resource policyExemption 'Microsoft.Authorization/policyExemptions@2020-07-01-preview' = {
  name: policyExemptionName_var
  location: location
  properties: {
    displayName: (empty(displayName) ? null : displayName)
    description: (empty(policyExemptionDescription) ? null : policyExemptionDescription)
    metadata: (empty(metadata) ? null : metadata)
    exemptionCategory: exemptionCategory
    policyAssignmentId: policyAssignmentId
    policyDefinitionReferenceIds: (empty(policyDefinitionReferenceIds) ? [] : policyDefinitionReferenceIds)
    expiresOn: (empty(expiresOn) ? null : expiresOn)
  }
}

output policyExemptionName string = policyExemption.name
output policyExemptionId string = resourceId(subscriptionId, resourceGroupName, 'Microsoft.Authorization/policyExemptions', policyExemption.name)
output policyExemptionScope string = resourceGroup().id
