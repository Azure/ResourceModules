targetScope = 'tenant'

@description('Blocks users from moving Azure subscriptions from this AAD directory to a different one.')
param blockSubscriptionsIntoTenant bool = false

@description('Blocks users from moving Azure subscriptions from a different AAD directory to a this one.')
param blockSubscriptionsLeavingTenant bool = false

@description('A list of users who can bypass the policy definitions and will always be able to move subscriptions out or in of this AAD directory.')
param exemptedPrincipals array = []

resource policy 'Microsoft.Subscription/policies@2021-10-01' = {
  name: 'default'
  blockSubscriptionsIntoTenant: blockSubscriptionsIntoTenant
  blockSubscriptionsLeavingTenant: blockSubscriptionsLeavingTenant
  exemptedPrincipals: exemptedPrincipals
}

@description('The resource ID of the subscription policy.')
output resourceId string = policy.id

@description('The resource name of the subscription policy.')
output name string = policy.name

@description('The object ID of the subscription policy.')
output policyId string = policy.properties.policyId
