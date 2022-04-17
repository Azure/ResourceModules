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

@description('The name of the deployed subscription alias')
output name string = aliases.name

@description('The resource ID of the deployed subscription alias')
output resourceId string = aliases.id

@description('The subscription ID attached to the deployed alias')
output subscriptionId string = aliases.properties.subscriptionId
