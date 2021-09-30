targetScope = 'managementGroup'

@description('Required. Specifies the name of the policy exemption. Space characters will be replaced by (-) and converted to lowercase')
@maxLength(64)
param policyExemptionName string

@description('Optional. The display name of the policy exemption. If not provided, will be replaced with the Policy exemption Name')
param displayName string = ''

@description('Optional. The display name of the policy exemption. If not provided, will be replaced with the Policy exemption Name')
param policyExemptionDescription string = ''

@description('Optional. The policy exemption metadata. Metadata is an open ended object and is typically a collection of key value pairs.')
param metadata object = {}

@description('Optional. The policy exemption category. Possible values are Waiver and Mitigated. Default is Mitigated')
@allowed([
  'Mitigated'
  'Waiver'
])
param exemptionCategory string = 'Mitigated'

@description('Required. The ID of the policy assignment that is being exempted.')
param policyAssignmentId string

@description('Optional. The policy definition reference ID list when the associated policy assignment is an assignment of a policy set definition.')
param policyDefinitionReferenceIds array = []

@description('Optional. The expiration date and time (in UTC ISO 8601 format yyyy-MM-ddTHH:mm:ssZ) of the policy exemption. e.g. 2021-10-02T03:57:00.000Z ')
param expiresOn string = ''

@description('Optional. The ID of the Management Group (Scope). Cannot be used with subscriptionId and does not support tenant level deployment (i.e. \'/\')')
param managementGroupId string = ''

@description('Optional. The ID of the Azure Subscription (Scope). Cannot be used with managementGroupId')
param subscriptionId string = ''

@description('Optional. The Target Scope for the Policy. The name of the resource group for the policy assignment')
param resourceGroupName string = ''

var var_policyExemptionName = toLower(replace(policyExemptionName, ' ', '-'))
var var_policyProperties = {
  displayName: (empty(displayName) ? json('null') : displayName)
  description: (empty(policyExemptionDescription) ? json('null') : policyExemptionDescription)
  metadata: (empty(metadata) ? json('null') : metadata)
  exemptionCategory: exemptionCategory
  policyAssignmentId: policyAssignmentId
  policyDefinitionReferenceIds: (empty(policyDefinitionReferenceIds) ? [] : policyDefinitionReferenceIds)
  expiresOn: (empty(expiresOn) ? json('null') : expiresOn)
}

module policyExemptions_mg './.bicep/nested_policyexemptions_mg.bicep' = if (!empty(managementGroupId) && empty(subscriptionId) && empty(resourceGroupName)) {
  name: '${var_policyExemptionName}-mg'
  scope: managementGroup(managementGroupId)
  params: {
    policyExemptionName: var_policyExemptionName
    properties: var_policyProperties
    managementGroupId: managementGroupId
  }
}

module policyExemptions_sub './.bicep/nested_policyexemptions_sub.bicep' = if (empty(managementGroupId) && !empty(subscriptionId) && empty(resourceGroupName)) {
  name: '${var_policyExemptionName}-sub'
  scope: subscription(subscriptionId)
  params: {
    policyExemptionName: var_policyExemptionName
    properties: var_policyProperties
    subscriptionId: subscriptionId
  }
}

module policyExemptions_rg './.bicep/nested_policyexemptions_rg.bicep' = if (empty(managementGroupId) && !empty(resourceGroupName) && !empty(subscriptionId)) {
  name: '${var_policyExemptionName}-rg'
  scope: resourceGroup(subscriptionId, resourceGroupName)
  params: {
    policyExemptionName: var_policyExemptionName
    properties: var_policyProperties
    subscriptionId: subscriptionId
  }
}

output policyExemptionName string = var_policyExemptionName
output policyExemptionId string = !empty(managementGroupId) ? policyExemptions_mg.outputs.policyExemptionId : (!empty(resourceGroupName) ? policyExemptions_rg.outputs.policyExemptionId : policyExemptions_sub.outputs.policyExemptionId)
output policyExemptionScope string = !empty(managementGroupId) ? policyExemptions_mg.outputs.policyExemptionScope : (!empty(resourceGroupName) ? policyExemptions_rg.outputs.policyExemptionScope : policyExemptions_sub.outputs.policyExemptionScope)
