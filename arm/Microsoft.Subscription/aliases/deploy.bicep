targetScope = 'managementGroup'

@description('Required. EnrollmentAccount used for subscription billing')
param enrollmentAccount string

@description('Required. BillingAccount used for subscription billing')
param billingAccount string

@description('Required. Alias to assign to the subscription')
param subscriptionAlias string

@description('Required. Display name for the subscription')
param subscriptionDisplayName string

@allowed([
  'Production'
  'DevTest'
])
@description('Optional. The workload type of the subscription.')
param subscriptionWorkload string = 'Production'

@description('Optional. Owner Id of the subscription')
param subscriptionOwnerId string = ''

@description('Optional. Tenant Id of the subscription')
param subscriptionTenantId string = ''

@description('Optional. This parameter can be used to create alias for existing subscription Id')
param subscriptionId string = ''

@description('Optional. Tags for the subscription')
param tags object = {}

@description('Optional. The ID of the management group to deploy into. If not provided the subscription is deployed into the root management group')
param managementGroupId string = ''

resource alias 'Microsoft.Subscription/aliases@2021-10-01' = {
  scope: tenant()
  name: subscriptionAlias
  properties: {
    workload: subscriptionWorkload
    displayName: empty(subscriptionId) ? subscriptionDisplayName : null
    billingScope: empty(subscriptionId) ? tenantResourceId('Microsoft.Billing/billingAccounts/enrollmentAccounts', billingAccount, enrollmentAccount) : null
    additionalProperties: {
      managementGroupId: !empty(managementGroupId) ? tenantResourceId('Microsoft.Management/managementGroups', managementGroupId) : null
      subscriptionOwnerId: !empty(subscriptionOwnerId) ? subscriptionOwnerId : null
      subscriptionTenantId: !empty(subscriptionTenantId) ? subscriptionTenantId : null
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
    subscriptionId: alias.properties.subscriptionId
  }
}

@description('The name of the deployed subscription alias')
output name string = alias.name

@description('The resource ID of the deployed subscription alias')
output resourceId string = alias.id

@description('The subscription ID attached to the deployed alias')
output subscriptionId string = alias.properties.subscriptionId
