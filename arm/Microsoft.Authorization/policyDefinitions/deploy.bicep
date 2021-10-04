targetScope = 'managementGroup'

@description('Required. Specifies the name of the policy definition. Space characters will be replaced by (-) and converted to lowercase')
@maxLength(64)
param policyDefinitionName string

@description('Optional. The display name of the policy definition. If not provided, will be replaced with the Policy Definition Name')
param displayName string = ''

@description('Optional. The display name of the policy definition. If not provided, will be replaced with the Policy Definition Name')
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

@description('Optional. The policy Definition metadata. Metadata is an open ended object and is typically a collection of key value pairs.')
param metadata object = {}

@description('Optional. The policy set definition parameters that can be used in policy definition references.')
param parameters object = {}

@description('Required. The policy rule. Must include \'[\' when defining parameters to escape the template expressions and prevent them from being evaluated by the top level deployment.')
param policyRule object

@description('Optional. The ID of the Management Group (Scope). Cannot be used with subscriptionId and does not support tenant level deployment (i.e. \'/\')')
param managementGroupId string = ''

@description('Optional. The ID of the Azure Subscription (Scope). Cannot be used with managementGroupId')
param subscriptionId string = ''

@description('Optional. Default is false. If set to True, role definitions array will be returned as an output. Only use if the Policy Definition supports it.')
param returnRoleDefinitionIds bool = false

@description('Optional. Location for all resources.')
param location string = deployment().location

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

var policyDefinitionName_var = toLower(replace(policyDefinitionName, ' ', '-'))
var policyDefinitionProperties_var = {
  policyType: 'Custom'
  mode: mode
  displayName: (empty(displayName) ? json('null') : displayName)
  description: (empty(policyDescription) ? json('null') : policyDescription)
  metadata: (empty(metadata) ? json('null') : metadata)
  parameters: (empty(parameters) ? json('null') : parameters)
  policyRule: policyRule
}

module policyDefinitions_mg './.bicep/nested_policyDefinitions_mg.bicep' = if (empty(subscriptionId) && !empty(managementGroupId)) {
  name: '${policyDefinitionName_var}-mgDeployment'
  scope: managementGroup(managementGroupId)
  params: {
    policyDefinitionName: policyDefinitionName_var
    location: location
    policyDefinitionProperties: policyDefinitionProperties_var
    managementGroupId: managementGroupId
    returnRoleDefinitionIds: returnRoleDefinitionIds
  }
}

module policyDefinitions_sub './.bicep/nested_policyDefinitions_sub.bicep' = if (empty(managementGroupId) && !empty(subscriptionId)) {
  name: '${policyDefinitionName_var}-subDeployment'
  scope: subscription(subscriptionId)
  params: {
    policyDefinitionName: policyDefinitionName_var
    location: location
    policyDefinitionProperties: policyDefinitionProperties_var
    subscriptionId: subscriptionId
    returnRoleDefinitionIds: returnRoleDefinitionIds
  }
}

output policyDefinitionName string = policyDefinitionName_var
output policyDefinitionId string = !empty(managementGroupId) ? policyDefinitions_mg.outputs.policyDefinitionId : policyDefinitions_sub.outputs.policyDefinitionId
output roleDefinitionIds array = !empty(managementGroupId) ? policyDefinitions_mg.outputs.roleDefinitionIds : policyDefinitions_sub.outputs.roleDefinitionIds
