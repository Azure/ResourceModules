targetScope = 'managementGroup'

@description('Required. Specifies the name of the policy assignment.')
@maxLength(64)
param policySetDefinitionName string

@description('Optional. The display name of the policy assignment. If not provided, will be replaced with the Policy Assignment Name')
param displayName string = ''

@description('Optional. This message will be part of response in case of policy violation. If not provided, will be replaced with the Policy Assignment Name')
param policySetDescription string = ''

@description('Optional. The ID of the Management Group (Scope). Cannot be used with subscriptionId and does not support tenant level deployment (i.e. \'/\')')
param managementGroupId string = ''

@description('Optional. The ID of the Azure Subscription (Scope). Cannot be used with managementGroupId')
param subscriptionId string = ''

@description('Optional. The policy assignment metadata. Metadata is an open ended object and is typically a collection of key value pairs.')
param metadata object = {}

@description('Required. The array of Policy definitions object to include for this policy set. Each object must include the definition ID, parameters, ')
param policyDefinitions array

@description('Optional. The metadata describing groups of policy definition references within the policy set definition.')
param policyDefinitionGroups array = []

@description('Optional. The policy set definition parameters that can be used in policy definition references.')
param parameters object = {}

var emptyArray = []
var var_policySetDefinitionName = replace(policySetDefinitionName, ' ', '-')
var var_policySetDefinitionProperties = {
  policyType: 'Custom'
  displayName: (empty(displayName) ? policySetDefinitionName : json('null'))
  description: (empty(policySetDescription) ? policySetDefinitionName : json('null'))
  metadata: (empty(metadata) ? json('null') : metadata)
  parameters: (empty(parameters) ? json('null') : parameters)
  policyDefinitions: policyDefinitions
  policyDefinitionGroups: (empty(policyDefinitionGroups) ? emptyArray : policyDefinitionGroups)
}

module policySetDefinition_mg './.bicep/nested_policySetDefinition_mg.bicep' = if (empty(subscriptionId) && (!empty(managementGroupId))) {
  name: '${var_policySetDefinitionName}-mgDeployment'
  scope: managementGroup(managementGroupId)
  params: {
    policySetDefinitionName: var_policySetDefinitionName
    properties: var_policySetDefinitionProperties
    managementGroupId: managementGroupId
  }
}

module policySetDefinition_sub './.bicep/nested_policySetDefinition_sub.bicep' = if (empty(managementGroupId) && (!empty(subscriptionId))) {
  name: '${var_policySetDefinitionName}-subDeployment'
  scope: subscription(subscriptionId)
  params: {
    policySetDefinitionName: var_policySetDefinitionName
    properties: var_policySetDefinitionProperties
    subscriptionId: subscriptionId
  }
}

output policySetDefinitionName string = var_policySetDefinitionName
output policySetDefinitionId string = (!empty(managementGroupId)) ? policySetDefinition_mg.outputs.policySetDefinitionId : policySetDefinition_sub.outputs.policySetDefinitionId
