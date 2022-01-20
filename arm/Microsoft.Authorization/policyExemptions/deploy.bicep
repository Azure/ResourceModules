targetScope = 'managementGroup'

@sys.description('Required. Specifies the name of the policy exemption.')
@maxLength(64)
param name string

@sys.description('Optional. The display name of the policy exemption.')
param displayName string = ''

@sys.description('Optional. The description of the policy exemption.')
param description string = ''

@sys.description('Optional. The policy exemption metadata. Metadata is an open ended object and is typically a collection of key-value pairs.')
param metadata object = {}

@sys.description('Optional. The policy exemption category. Possible values are Waiver and Mitigated. Default is Mitigated')
@allowed([
  'Mitigated'
  'Waiver'
])
param exemptionCategory string = 'Mitigated'

@sys.description('Required. The resource ID of the policy assignment that is being exempted.')
param policyAssignmentId string

@sys.description('Optional. The policy definition reference ID list when the associated policy assignment is an assignment of a policy set definition.')
param policyDefinitionReferenceIds array = []

@sys.description('Optional. The expiration date and time (in UTC ISO 8601 format yyyy-MM-ddTHH:mm:ssZ) of the policy exemption. e.g. 2021-10-02T03:57:00.000Z ')
param expiresOn string = ''

@sys.description('Optional. The group ID of the management group to be exempted from the policy assignment. Cannot use with subscription ID parameter.')
param managementGroupId string = ''

@sys.description('Optional. The subscription ID of the subscription to be exempted from the policy assignment. Cannot use with management group ID parameter.')
param subscriptionId string = ''

@sys.description('Optional. The name of the resource group to be exempted from the policy assignment. Must also use the subscription ID parameter.')
param resourceGroupName string = ''

@sys.description('Optional. Location for all resources.')
param location string = deployment().location

module policyExemption_mg '.bicep/nested_policyExemptions_mg.bicep' = if (!empty(managementGroupId) && empty(subscriptionId) && empty(resourceGroupName)) {
  name: '${uniqueString(deployment().name, location)}-PolicyExemption-MG-Module'
  scope: managementGroup(managementGroupId)
  params: {
    name: name
    displayName: !empty(displayName) ? displayName : ''
    description: !empty(description) ? description : ''
    metadata: !empty(metadata) ? metadata : {}
    exemptionCategory: exemptionCategory
    policyAssignmentId: policyAssignmentId
    policyDefinitionReferenceIds: !empty(policyDefinitionReferenceIds) ? policyDefinitionReferenceIds : []
    expiresOn: !empty(expiresOn) ? expiresOn : ''
    managementGroupId: managementGroupId
  }
}

module policyExemption_sub '.bicep/nested_policyExemptions_sub.bicep' = if (empty(managementGroupId) && !empty(subscriptionId) && empty(resourceGroupName)) {
  name: '${uniqueString(deployment().name, location)}-PolicyExemption-Sub-Module'
  scope: subscription(subscriptionId)
  params: {
    name: name
    displayName: !empty(displayName) ? displayName : ''
    description: !empty(description) ? description : ''
    metadata: !empty(metadata) ? metadata : {}
    exemptionCategory: exemptionCategory
    policyAssignmentId: policyAssignmentId
    policyDefinitionReferenceIds: !empty(policyDefinitionReferenceIds) ? policyDefinitionReferenceIds : []
    expiresOn: !empty(expiresOn) ? expiresOn : ''
    subscriptionId: subscriptionId
  }
}

module policyExemption_rg '.bicep/nested_policyExemptions_rg.bicep' = if (empty(managementGroupId) && !empty(resourceGroupName) && !empty(subscriptionId)) {
  name: '${uniqueString(deployment().name, location)}-PolicyExemption-RG-Module'
  scope: resourceGroup(subscriptionId, resourceGroupName)
  params: {
    name: name
    displayName: !empty(displayName) ? displayName : ''
    description: !empty(description) ? description : ''
    metadata: !empty(metadata) ? metadata : {}
    exemptionCategory: exemptionCategory
    policyAssignmentId: policyAssignmentId
    policyDefinitionReferenceIds: !empty(policyDefinitionReferenceIds) ? policyDefinitionReferenceIds : []
    expiresOn: !empty(expiresOn) ? expiresOn : ''
    subscriptionId: subscriptionId
    resourceGroupName: resourceGroupName
  }
}

@sys.description('Policy Exemption Name')
output name string = !empty(managementGroupId) ? policyExemption_mg.outputs.name : (!empty(resourceGroupName) ? policyExemption_rg.outputs.name : policyExemption_sub.outputs.name)

@sys.description('Policy Exemption resource ID')
output resourceId string = !empty(managementGroupId) ? policyExemption_mg.outputs.resourceId : (!empty(resourceGroupName) ? policyExemption_rg.outputs.resourceId : policyExemption_sub.outputs.resourceId)

@sys.description('Policy Exemption Scope')
output scope string = !empty(managementGroupId) ? policyExemption_mg.outputs.scope : (!empty(resourceGroupName) ? policyExemption_rg.outputs.scope : policyExemption_sub.outputs.scope)
