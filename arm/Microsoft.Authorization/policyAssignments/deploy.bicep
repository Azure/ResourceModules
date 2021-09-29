targetScope = 'managementGroup'

@description('Required. Specifies the name of the policy assignment.')
@maxLength(24)
param policyAssignmentName string

@description('Required. Specifies the ID of the policy definition or policy set definition being assigned.')
param policyDefinitionID string

@description('Optional. Parameters for the policy assignment if needed.')
param parameters object = {}

@description('Optional. The managed identity associated with the policy assignment. Policy assignments must include a resource identity when assigning \'Modify\' policy definitions.')
@allowed([
  'SystemAssigned'
  'None'
])
param identity string = 'SystemAssigned'

@description('Required. The IDs Of the Azure Role Definition list that is used to assign permissions to the identity. You need to provide either the fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.. See https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles for the list IDs for built in Roles. They must match on what is on the policy definition')
param roleDefinitionIds array = []

@description('Optional. This message will be part of response in case of policy violation. If not provided, will be replaced with the Policy Assignment Name')
param policyAssignmentDescription string = ''

@description('Optional. The display name of the policy assignment. If not provided, will be replaced with the Policy Assignment Name')
param displayName string = ''

@description('Optional. The policy assignment metadata. Metadata is an open ended object and is typically a collection of key value pairs.')
param metadata object = {}

@description('Optional. The messages that describe why a resource is non-compliant with the policy. If not provided will be replaced with empty')
param nonComplianceMessage string = ''

@description('Optional. The policy assignment enforcement mode. Possible values are Default and DoNotEnforce. - Default or DoNotEnforce')
@allowed([
  'Default'
  'DoNotEnforce'
])
param enforcementMode string = 'Default'

@description('Optional. The Target Scope for the Policy. The name of the management group for the policy assignment')
param managementGroupId string = ''

@description('Optional. The Target Scope for the Policy. The Id of the subscription for the policy assignment')
param subscriptionId string = ''

@description('Optional. The Target Scope for the Policy. The name of the resource group for the policy assignment')
param resourceGroupName string = ''

@description('Optional. The policy excluded scopes')
param notScopes array = []

@description('Optional. Location for all resources.')
param location string = deployment().location

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

var nonComplianceMessage_var = {
  message: (empty(nonComplianceMessage) ? 'null' : nonComplianceMessage)
}

var var_properties = {
  displayName: (empty(displayName) ? json('null') : displayName)
  metadata: (empty(metadata) ? json('null') : metadata)
  description: (empty(policyAssignmentDescription) ? json('null') : policyAssignmentDescription)
  policyDefinitionId: policyDefinitionID
  parameters: parameters
  nonComplianceMessages: (empty(nonComplianceMessage) ? [] : array(nonComplianceMessage_var))
  enforcementMode: enforcementMode
  notScopes: (empty(notScopes) ? [] : notScopes)
}

var var_identity = {
  type: identity
}

module policyAssignment_mg '.bicep/nested_policyAssignments_mg.bicep' = if ((!empty(managementGroupId) && empty(subscriptionId) && empty(resourceGroupName))) {
  name: 'policyAssignment_mg'
  scope: managementGroup(managementGroupId)
  params: {
    policyAssignmentName: policyAssignmentName
    location: location
    properties: var_properties
    identity: var_identity
    managementGroupId: managementGroupId
  }
}

module policyAssignment_sub '.bicep/nested_policyAssignments_sub.bicep' = if (empty(managementGroupId) && (!empty(subscriptionId) && empty(resourceGroupName))) {
  name: 'policyAssignment_sub'
  scope: subscription(subscriptionId)
  params: {
    policyAssignmentName: policyAssignmentName
    location: location
    properties: var_properties
    identity: var_identity
    subscriptionId: subscriptionId
  }
}

module policyAssignment_rg '.bicep/nested_policyAssignments_rg.bicep' = if (empty(managementGroupId) && !empty(resourceGroupName) && (!empty(subscriptionId))) {
  name: 'policyAssignment_rg'
  scope: resourceGroup(subscriptionId, resourceGroupName)
  params: {
    policyAssignmentName: policyAssignmentName
    location: location
    properties: var_properties
    identity: var_identity
    resourceGroupName: resourceGroupName
    subscriptionId: subscriptionId
  }
}

output policyAssignmentName string = policyAssignmentName
output policyAssignmentPrincipalId string = !empty(managementGroupId) ? policyAssignment_mg.outputs.policyAssignmentPrincipalId : (!empty(resourceGroupName) ? policyAssignment_rg.outputs.policyAssignmentPrincipalId : policyAssignment_sub.outputs.policyAssignmentPrincipalId)
output policyAssignmentId string = !empty(managementGroupId) ? policyAssignment_mg.outputs.policyAssignmentId : (!empty(resourceGroupName) ? policyAssignment_rg.outputs.policyAssignmentId : policyAssignment_sub.outputs.policyAssignmentId)
