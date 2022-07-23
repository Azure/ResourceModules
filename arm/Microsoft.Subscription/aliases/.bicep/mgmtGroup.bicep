targetScope = 'managementGroup'

@description('Optional. This parameter can be used to create alias for existing subscription Id')
param subscriptionId string = ''

@description('Optional. The ID of the management group to deploy into. If not provided the subscription is deployed into the root management group')
param managementGroupId string = ''

resource subscriptionPlacement 'Microsoft.Management/managementGroups/subscriptions@2021-04-01' = {
  scope: tenant()
  name: '${managementGroupId}/${subscriptionId}'
}

output subscriptionId string = subscriptionPlacement.id
