targetScope = 'managementGroup'

@sys.description('Required. Specifies the name of the policy Set Definition (Initiative). Maximum length is 24 characters for management group scope and 64 characters for subscription scope.')
@maxLength(64)
param name string

@sys.description('Optional. The display name of the Set Definition (Initiative). Maximum length is 128 characters.')
@maxLength(128)
param displayName string = ''

@sys.description('Optional. The description name of the Set Definition (Initiative)')
param description string = ''

@sys.description('Optional. The group Id of the Management Group (Scope). Cannot be used with subscriptionId and does not support tenant level deployment (i.e. \'/\')')
param managementGroupId string = ''

@sys.description('Optional. The subscription Id of the subscription (Scope). Cannot be used with managementGroupId')
param subscriptionId string = ''

@sys.description('Optional. The Set Definition (Initiative) metadata. Metadata is an open ended object and is typically a collection of key-value pairs.')
param metadata object = {}

@sys.description('Required. The array of Policy definitions object to include for this policy set. Each object must include the Policy definition Id, and optionally other properties like parameters')
param policyDefinitions array

@sys.description('Optional. The metadata describing groups of policy definition references within the Policy Set Definition (Initiative).')
param policyDefinitionGroups array = []

@sys.description('Optional. The Set Definition (Initiative) parameters that can be used in policy definition references.')
param parameters object = {}

@sys.description('Optional. Location for all resources.')
param location string = deployment().location

module policySetDefinition_mg 'managementGroup/deploy.bicep' = if (empty(subscriptionId) && !empty(managementGroupId)) {
  name: '${uniqueString(deployment().name, location)}-PolicySetDefinition-MG-Module'
  scope: managementGroup(managementGroupId)
  params: {
    name: name
    displayName: !empty(displayName) ? displayName : ''
    description: !empty(description) ? description : ''
    metadata: !empty(metadata) ? metadata : {}
    parameters: !empty(parameters) ? parameters : {}
    policyDefinitions: policyDefinitions
    policyDefinitionGroups: !empty(policyDefinitionGroups) ? policyDefinitionGroups : []
    managementGroupId: managementGroupId
  }
}

module policySetDefinition_sub 'subscription/deploy.bicep' = if (empty(managementGroupId) && !empty(subscriptionId)) {
  name: '${uniqueString(deployment().name, location)}-PolicySetDefinition-Sub-Module'
  scope: subscription(subscriptionId)
  params: {
    name: name
    displayName: !empty(displayName) ? displayName : ''
    description: !empty(description) ? description : ''
    metadata: !empty(metadata) ? metadata : {}
    parameters: !empty(parameters) ? parameters : {}
    policyDefinitions: policyDefinitions
    policyDefinitionGroups: !empty(policyDefinitionGroups) ? policyDefinitionGroups : []
    subscriptionId: subscriptionId
  }
}

@sys.description('Policy Set Definition Name')
output name string = !empty(managementGroupId) ? policySetDefinition_mg.outputs.name : policySetDefinition_sub.outputs.name

@sys.description('Policy Set Definition resource Id')
output resourceId string = !empty(managementGroupId) ? policySetDefinition_mg.outputs.resourceId : policySetDefinition_sub.outputs.resourceId
