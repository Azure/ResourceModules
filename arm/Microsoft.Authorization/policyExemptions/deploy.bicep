targetScope = 'managementGroup'

@description('Required. Specifies the name of the policy exemption. Space characters will be replaced by (-) and converted to lowercase')
@maxLength(64)
param policyExemptionName string

@description('Optional. The display name of the policy exemption.')
param displayName string = ''

@description('Optional. The description of the policy exemption.')
param policyExemptionDescription string = ''

@description('Optional. The policy exemption metadata. Metadata is an open ended object and is typically a collection of key-value pairs.')
param metadata object = {}

@description('Optional. The policy exemption category. Possible values are Waiver and Mitigated. Default is Mitigated')
@allowed([
  'Mitigated'
  'Waiver'
])
param exemptionCategory string = 'Mitigated'

@description('Required. The resource ID of the policy assignment that is being exempted.')
param policyAssignmentId string

@description('Optional. The policy definition reference ID list when the associated policy assignment is an assignment of a policy set definition.')
param policyDefinitionReferenceIds array = []

@description('Optional. The expiration date and time (in UTC ISO 8601 format yyyy-MM-ddTHH:mm:ssZ) of the policy exemption. e.g. 2021-10-02T03:57:00.000Z ')
param expiresOn string = ''

@description('Optional. The group ID of the management group to be exempted from the policy assignment. Cannot use with subscription ID parameter.')
param managementGroupId string = ''

@description('Optional. The subscription ID of the subscription to be exempted from the policy assignment. Cannot use with management group ID parameter.')
param subscriptionId string = ''

@description('Optional. The name of the resource group to be exempted from the policy assignment. Must also use the subscription ID parameter.')
param resourceGroupName string = ''

@description('Optional. Location for all resources.')
param location string = deployment().location

var policyExemptionName_var = toLower(replace(policyExemptionName, ' ', '-'))

module policyExemption_mg '.bicep/nested_policyExemptions_mg.bicep' = if (!empty(managementGroupId) && empty(subscriptionId) && empty(resourceGroupName)) {
  name: '${policyExemptionName_var}-mg'
  scope: managementGroup(managementGroupId)
  params: {
    policyExemptionName: policyExemptionName_var
    displayName: (empty(displayName) ? '' : displayName)
    policyExemptionDescription: (empty(policyExemptionDescription) ? '' : policyExemptionDescription)
    metadata: (empty(metadata) ? {} : metadata)
    exemptionCategory: exemptionCategory
    policyAssignmentId: policyAssignmentId
    policyDefinitionReferenceIds: (empty(policyDefinitionReferenceIds) ? [] : policyDefinitionReferenceIds)
    expiresOn: (empty(expiresOn) ? '' : expiresOn)
    managementGroupId: managementGroupId
    location: location
  }
}

module policyExemption_sub '.bicep/nested_policyExemptions_sub.bicep' = if (empty(managementGroupId) && !empty(subscriptionId) && empty(resourceGroupName)) {
  name: '${policyExemptionName_var}-sub'
  scope: subscription(subscriptionId)
  params: {
    policyExemptionName: policyExemptionName_var
    displayName: (empty(displayName) ? '' : displayName)
    policyExemptionDescription: (empty(policyExemptionDescription) ? '' : policyExemptionDescription)
    metadata: (empty(metadata) ? {} : metadata)
    exemptionCategory: exemptionCategory
    policyAssignmentId: policyAssignmentId
    policyDefinitionReferenceIds: (empty(policyDefinitionReferenceIds) ? [] : policyDefinitionReferenceIds)
    expiresOn: (empty(expiresOn) ? '' : expiresOn)
    subscriptionId: subscriptionId
    location: location
  }
}

module policyExemption_rg '.bicep/nested_policyExemptions_rg.bicep' = if (empty(managementGroupId) && !empty(resourceGroupName) && !empty(subscriptionId)) {
  name: '${policyExemptionName_var}-rg'
  scope: resourceGroup(subscriptionId, resourceGroupName)
  params: {
    policyExemptionName: policyExemptionName_var
    displayName: (empty(displayName) ? '' : displayName)
    policyExemptionDescription: (empty(policyExemptionDescription) ? '' : policyExemptionDescription)
    metadata: (empty(metadata) ? {} : metadata)
    exemptionCategory: exemptionCategory
    policyAssignmentId: policyAssignmentId
    policyDefinitionReferenceIds: (empty(policyDefinitionReferenceIds) ? [] : policyDefinitionReferenceIds)
    expiresOn: (empty(expiresOn) ? '' : expiresOn)
    subscriptionId: subscriptionId
    resourceGroupName: resourceGroupName
    location: location
  }
}

output policyExemptionName string = !empty(managementGroupId) ? policyExemption_mg.outputs.policyExemptionName : (!empty(resourceGroupName) ? policyExemption_rg.outputs.policyExemptionName : policyExemption_sub.outputs.policyExemptionName)
output policyExemptionId string = !empty(managementGroupId) ? policyExemption_mg.outputs.policyExemptionId : (!empty(resourceGroupName) ? policyExemption_rg.outputs.policyExemptionId : policyExemption_sub.outputs.policyExemptionId)
output policyExemptionScope string = !empty(managementGroupId) ? policyExemption_mg.outputs.policyExemptionScope : (!empty(resourceGroupName) ? policyExemption_rg.outputs.policyExemptionScope : policyExemption_sub.outputs.policyExemptionScope)
