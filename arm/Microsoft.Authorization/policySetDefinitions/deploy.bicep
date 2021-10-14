targetScope = 'managementGroup'

@description('Required. Specifies the name of the policy Set Definition (Initiative). Space characters will be replaced by (-) and converted to lowercase')
@maxLength(64)
param policySetDefinitionName string

@description('Optional. The display name of the Set Definition (Initiative)')
param displayName string = ''

@description('Optional. The Description name of the Set Definition (Initiative)')
param policySetDescription string = ''

@description('Optional. The ID of the Management Group (Scope). Cannot be used with subscriptionId and does not support tenant level deployment (i.e. \'/\')')
param managementGroupId string = ''

@description('Optional. The ID of the Azure Subscription (Scope). Cannot be used with managementGroupId')
param subscriptionId string = ''

@description('Optional. The Set Definition (Initiative) metadata. Metadata is an open ended object and is typically a collection of key value pairs.')
param metadata object = {}

@description('Required. The array of Policy definitions object to include for this policy set. Each object must include the Policy definition ID, and optionally other properties like parameters')
param policyDefinitions array

@description('Optional. The metadata describing groups of policy definition references within the Policy Set Definition (Initiative).')
param policyDefinitionGroups array = []

@description('Optional. The Set Definition (Initiative) parameters that can be used in policy definition references.')
param parameters object = {}

@description('Optional. Location for all resources.')
param location string = deployment().location

var policySetDefinitionName_var = replace(policySetDefinitionName, ' ', '-')

module policySetDefinition_mg './.bicep/nested_policySetDefinition_mg.bicep' = if (empty(subscriptionId) && !empty(managementGroupId)) {
  name: '${policySetDefinitionName_var}-mgDeployment'
  scope: managementGroup(managementGroupId)
  params: {
    policySetDefinitionName: policySetDefinitionName_var
    displayName: (empty(displayName) ? '' : displayName)
    policySetDescription: (empty(policySetDescription) ? '' : policySetDescription)
    metadata: (empty(metadata) ? {} : metadata)
    parameters: (empty(parameters) ? {} : parameters)
    policyDefinitions: policyDefinitions
    policyDefinitionGroups: (empty(policyDefinitionGroups) ? [] : policyDefinitionGroups)
    managementGroupId: managementGroupId
    location: location
  }
}

module policySetDefinition_sub './.bicep/nested_policySetDefinition_sub.bicep' = if (empty(managementGroupId) && !empty(subscriptionId)) {
  name: '${policySetDefinitionName_var}-subDeployment'
  scope: subscription(subscriptionId)
  params: {
    policySetDefinitionName: policySetDefinitionName_var
    displayName: (empty(displayName) ? '' : displayName)
    policySetDescription: (empty(policySetDescription) ? '' : policySetDescription)
    metadata: (empty(metadata) ? {} : metadata)
    parameters: (empty(parameters) ? {} : parameters)
    policyDefinitions: policyDefinitions
    policyDefinitionGroups: (empty(policyDefinitionGroups) ? [] : policyDefinitionGroups)
    subscriptionId: subscriptionId
    location: location
  }
}

output policySetDefinitionName string = !empty(managementGroupId) ? policySetDefinition_mg.outputs.policySetDefinitionName : policySetDefinition_sub.outputs.policySetDefinitionName
output policySetDefinitionId string = !empty(managementGroupId) ? policySetDefinition_mg.outputs.policySetDefinitionId : policySetDefinition_sub.outputs.policySetDefinitionId
