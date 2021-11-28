targetScope = 'managementGroup'

@description('Required. Specifies the name of the policy definition. Space characters will be replaced by (-) and converted to lowercase')
@maxLength(64)
param policyDefinitionName string

@description('Optional. The display name of the policy definition.')
param displayName string = ''

@description('Optional. The policy definition description.')
param policyDescription string = ''

@description('Optional. The policy definition mode. Default is All, Some examples are All, Indexed, Microsoft.KeyVault.Data.')
@allowed([
  'All'
  'Indexed'
  'Microsoft.KeyVault.Data'
  'Microsoft.ContainerService.Data'
  'Microsoft.Kubernetes.Data'
])
param mode string = 'All'

@description('Optional. The policy Definition metadata. Metadata is an open ended object and is typically a collection of key-value pairs.')
param metadata object = {}

@description('Optional. The policy definition parameters that can be used in policy definition references.')
param parameters object = {}

@description('Required. The Policy Rule details for the Policy Definition')
param policyRule object

@description('Optional. The group ID of the Management Group (Scope). Cannot be used with subscriptionId and does not support tenant level deployment (i.e. \'/\')')
param managementGroupId string = ''

@description('Optional. The subscription ID of the subscription (Scope). Cannot be used with managementGroupId')
param subscriptionId string = ''

@description('Optional. Location for all resources.')
param location string = deployment().location

var policyDefinitionName_var = toLower(replace(policyDefinitionName, ' ', '-'))

module policyDefinition_mg '.bicep/nested_policyDefinitions_mg.bicep' = if (empty(subscriptionId) && !empty(managementGroupId)) {
  name: '${policyDefinitionName_var}-mgDeployment'
  scope: managementGroup(managementGroupId)
  params: {
    policyDefinitionName: policyDefinitionName_var
    location: location
    managementGroupId: managementGroupId
    mode: mode
    displayName: (empty(displayName) ? '' : displayName)
    policyDescription: (empty(policyDescription) ? '' : policyDescription)
    metadata: (empty(metadata) ? {} : metadata)
    parameters: (empty(parameters) ? {} : parameters)
    policyRule: policyRule
  }
}

module policyDefinition_sub '.bicep/nested_policyDefinitions_sub.bicep' = if (empty(managementGroupId) && !empty(subscriptionId)) {
  name: '${policyDefinitionName_var}-subDeployment'
  scope: subscription(subscriptionId)
  params: {
    policyDefinitionName: policyDefinitionName_var
    location: location
    subscriptionId: subscriptionId
    mode: mode
    displayName: (empty(displayName) ? '' : displayName)
    policyDescription: (empty(policyDescription) ? '' : policyDescription)
    metadata: (empty(metadata) ? {} : metadata)
    parameters: (empty(parameters) ? {} : parameters)
    policyRule: policyRule
  }
}

output policyDefinitionName string = !empty(managementGroupId) ? policyDefinition_mg.outputs.policyDefinitionName : policyDefinition_sub.outputs.policyDefinitionName
output policyDefinitionId string = !empty(managementGroupId) ? policyDefinition_mg.outputs.policyDefinitionId : policyDefinition_sub.outputs.policyDefinitionId
output roleDefinitionIds array = !empty(managementGroupId) ? policyDefinition_mg.outputs.roleDefinitionIds : policyDefinition_sub.outputs.roleDefinitionIds
