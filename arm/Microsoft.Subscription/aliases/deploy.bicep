targetScope = 'managementGroup'

@description('Conditional. EnrollmentAccount used for subscription billing. Required if no subscriptionId was provided.')
param enrollmentAccount string = ''

@description('Conditional. BillingAccount used for subscription billing. Required if no subscriptionId was provided.')
param billingAccount string = ''

@description('Required. Alias to assign to the subscription')
param alias string

@description('Conditional. Display name for the subscription. Required if no subscriptionId was provided.')
param displayName string = ''

@allowed([
  'Production'
  'DevTest'
])
@description('Optional. The workload type of the subscription.')
param workload string = 'Production'

@description('Optional. Owner Id of the subscription')
param ownerId string = ''

@description('Optional. Tenant Id of the subscription')
param tenantId string = ''

@description('Optional. This parameter can be used to create alias for an existing subscription Id')
param subscriptionId string = ''

@description('Optional. Tags for the subscription')
param tags object = {}

@description('Optional. The ID of the management group to deploy into. If not provided the subscription is deployed into the root management group')
param managementGroupId string = ''

@description('Optional. Array of role assignment objects to define RBAC on this resource.')
param roleAssignments array = []

@description('Optional. Location deployment metadata.')
param location string = deployment().location

@description('Optional. Enable telemetry via the Customer Usage Attribution ID (GUID).')
param enableDefaultTelemetry bool = true

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

resource aliases 'Microsoft.Subscription/aliases@2021-10-01' = {
  scope: tenant()
  name: alias
  properties: {
    workload: workload
    displayName: empty(subscriptionId) ? displayName : null
    billingScope: empty(subscriptionId) ? tenantResourceId('Microsoft.Billing/billingAccounts/enrollmentAccounts', billingAccount, enrollmentAccount) : null
    additionalProperties: {
      managementGroupId: !empty(managementGroupId) ? tenantResourceId('Microsoft.Management/managementGroups', managementGroupId) : null
      subscriptionOwnerId: !empty(ownerId) ? ownerId : null
      subscriptionTenantId: !empty(tenantId) ? tenantId : null
      tags: tags
    }
    subscriptionId: !empty(subscriptionId) ? subscriptionId : null
  }
}

module subscriptionPlacement '.bicep/mgmtGroup.bicep' = {
  scope: managementGroup(managementGroupId)
  name: '${uniqueString(deployment().name)}-placement'
  params: {
    managementGroupId: managementGroupId
    subscriptionId: aliases.properties.subscriptionId
  }
}

module subscription_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name)}-Subscription-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    subscriptionId: aliases.id
  }
  scope: subscription(aliases.id)
}]

@description('The name of the deployed subscription alias')
output name string = aliases.name

@description('The resource ID of the deployed subscription alias')
output resourceId string = aliases.id

@description('The subscription ID attached to the deployed alias')
output subscriptionId string = aliases.properties.subscriptionId
