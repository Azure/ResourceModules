targetScope = 'managementGroup'

@sys.description('Required. Specifies the name of the policy definition.')
@maxLength(64)
param name string

@sys.description('Optional. The display name of the policy definition.')
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

@sys.description('Optional. The group ID of the Management Group (Scope). Cannot be used with subscriptionId and does not support tenant level deployment (i.e. \'/\')')
param managementGroupId string = ''

@sys.description('Optional. The subscription ID of the subscription (Scope). Cannot be used with managementGroupId')
param subscriptionId string = ''

@sys.description('Optional. Location for all resources.')
param location string = deployment().location

module policyDefinition_mg '.bicep/nested_policyDefinitions_mg.bicep' = if (empty(subscriptionId) && !empty(managementGroupId)) {
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

module policyDefinition_sub '.bicep/nested_policyDefinitions_sub.bicep' = if (empty(managementGroupId) && !empty(subscriptionId)) {
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
output policyDefinitionName string = !empty(managementGroupId) ? policyDefinition_mg.outputs.policyDefinitionName : policyDefinition_sub.outputs.policyDefinitionName

@sys.description('Policy Definition resource ID')
output policyDefinitionResourceId string = !empty(managementGroupId) ? policyDefinition_mg.outputs.policyDefinitionResourceId : policyDefinition_sub.outputs.policyDefinitionResourceId

@sys.description('Policy Definition Role Definition IDs')
output roleDefinitionIds array = !empty(managementGroupId) ? policyDefinition_mg.outputs.roleDefinitionIds : policyDefinition_sub.outputs.roleDefinitionIds
