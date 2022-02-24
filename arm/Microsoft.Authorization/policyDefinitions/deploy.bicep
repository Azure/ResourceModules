targetScope = 'managementGroup'

@sys.description('Required. Specifies the name of the policy definition. Maximum length is 64 characters for management group scope and subscription scope.')
@maxLength(64)
param name string

@sys.description('Optional. The display name of the policy definition. Maximum length is 128 characters.')
@maxLength(128)
param displayName string = ''

@sys.description('Optional. The policy definition description.')
param description string = ''

@sys.description('Optional. The policy definition mode. Default is All, Some examples are All, Indexed, Microsoft.KeyVault.Data.')
@allowed([
  'All'
  'Indexed'
  'Microsoft.KeyVault.Data'
  'Microsoft.ContainerService.Data'
  'Microsoft.Kubernetes.Data'
])
param mode string = 'All'

@sys.description('Optional. The policy Definition metadata. Metadata is an open ended object and is typically a collection of key-value pairs.')
param metadata object = {}

@sys.description('Optional. The policy definition parameters that can be used in policy definition references.')
param parameters object = {}

@sys.description('Required. The Policy Rule details for the Policy Definition')
param policyRule object

@sys.description('Optional. The group Id of the Management Group (Scope). Cannot be used with subscriptionId and does not support tenant level deployment (i.e. \'/\')')
param managementGroupId string = ''

@sys.description('Optional. The subscription Id of the subscription (Scope). Cannot be used with managementGroupId')
param subscriptionId string = ''

@sys.description('Optional. Location for all resources.')
param location string = deployment().location

module policyDefinition_mg 'managementGroup/deploy.bicep' = if (empty(subscriptionId) && !empty(managementGroupId)) {
  name: '${uniqueString(deployment().name, location)}-PolicyDefinition-MG-Module'
  scope: managementGroup(managementGroupId)
  params: {
    name: name
    managementGroupId: managementGroupId
    mode: mode
    displayName: !empty(displayName) ? displayName : ''
    description: !empty(description) ? description : ''
    metadata: !empty(metadata) ? metadata : {}
    parameters: !empty(parameters) ? parameters : {}
    policyRule: policyRule
  }
}

module policyDefinition_sub 'subscription/deploy.bicep' = if (empty(managementGroupId) && !empty(subscriptionId)) {
  name: '${uniqueString(deployment().name, location)}-PolicyDefinition-Sub-Module'
  scope: subscription(subscriptionId)
  params: {
    name: name
    subscriptionId: subscriptionId
    mode: mode
    displayName: !empty(displayName) ? displayName : ''
    description: !empty(description) ? description : ''
    metadata: !empty(metadata) ? metadata : {}
    parameters: !empty(parameters) ? parameters : {}
    policyRule: policyRule
  }
}

@sys.description('Policy Definition Name')
output name string = !empty(managementGroupId) ? policyDefinition_mg.outputs.name : policyDefinition_sub.outputs.name

@sys.description('Policy Definition resource Id')
output resourceId string = !empty(managementGroupId) ? policyDefinition_mg.outputs.resourceId : policyDefinition_sub.outputs.resourceId

@sys.description('Policy Definition Role Definition IDs')
output roleDefinitionIds array = !empty(managementGroupId) ? policyDefinition_mg.outputs.roleDefinitionIds : policyDefinition_sub.outputs.roleDefinitionIds
