targetScope = 'managementGroup'

@sys.description('Required. Specifies the name of the policy exemption. Maximum length is 64 characters for management group, subscription and resource group scopes.')
@maxLength(64)
param name string

@sys.description('Optional. The display name of the policy exemption. Maximum length is 128 characters.')
@maxLength(128)
param displayName string = ''

@sys.description('Optional. The description of the policy exemption.')
param description string = ''

@sys.description('Optional. The policy exemption metadata. Metadata is an open ended object and is typically a collection of key-value pairs.')
param metadata object = {}

@sys.description('Optional. The policy exemption category. Possible values are Waiver and Mitigated. Default is Mitigated.')
@allowed([
  'Mitigated'
  'Waiver'
])
param exemptionCategory string = 'Mitigated'

@sys.description('Required. The resource ID of the policy assignment that is being exempted.')
param policyAssignmentId string

@sys.description('Optional. The policy definition reference ID list when the associated policy assignment is an assignment of a policy set definition.')
param policyDefinitionReferenceIds array = []

@sys.description('Optional. The expiration date and time (in UTC ISO 8601 format yyyy-MM-ddTHH:mm:ssZ) of the policy exemption. e.g. 2021-10-02T03:57:00.000Z.')
param expiresOn string = ''

@sys.description('Optional. The group ID of the management group to be exempted from the policy assignment. If not provided, will use the current scope for deployment.')
param managementGroupId string = managementGroup().name

@sys.description('Optional. The subscription ID of the subscription to be exempted from the policy assignment. Cannot use with management group ID parameter.')
param subscriptionId string = ''

@sys.description('Optional. The name of the resource group to be exempted from the policy assignment. Must also use the subscription ID parameter.')
param resourceGroupName string = ''

@sys.description('Optional. Location deployment metadata.')
param location string = deployment().location

@sys.description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = true

var enableReferencedModulesTelemetry = false

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name, location)}'
  location: location
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

module policyExemption_mg 'managementGroup/deploy.bicep' = if (empty(subscriptionId) && empty(resourceGroupName)) {
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
    location: location
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}

module policyExemption_sub 'subscription/deploy.bicep' = if (!empty(subscriptionId) && empty(resourceGroupName)) {
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
    location: location
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}

module policyExemption_rg 'resourceGroup/deploy.bicep' = if (!empty(resourceGroupName) && !empty(subscriptionId)) {
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
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}

@sys.description('Policy Exemption Name.')
output name string = empty(subscriptionId) && empty(resourceGroupName) ? policyExemption_mg.outputs.name : (!empty(subscriptionId) && empty(resourceGroupName) ? policyExemption_sub.outputs.name : policyExemption_rg.outputs.name)

@sys.description('Policy Exemption resource ID.')
output resourceId string = empty(subscriptionId) && empty(resourceGroupName) ? policyExemption_mg.outputs.resourceId : (!empty(subscriptionId) && empty(resourceGroupName) ? policyExemption_sub.outputs.resourceId : policyExemption_rg.outputs.resourceId)

@sys.description('Policy Exemption Scope.')
output scope string = empty(subscriptionId) && empty(resourceGroupName) ? policyExemption_mg.outputs.scope : (!empty(subscriptionId) && empty(resourceGroupName) ? policyExemption_sub.outputs.scope : policyExemption_rg.outputs.scope)
