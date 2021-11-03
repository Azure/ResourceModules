@description('Optional. Determines whether tracing can be enabled.')
param allowTracing bool = true

@description('Required. The name of the of the Api Management service.')
param apiManagementServiceName string

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

@description('Optional. User (user id path) for whom subscription is being created in form /users/{userId}')
param ownerId string = ''

@description('Optional. Primary subscription key. If not specified during request key will be generated automatically.')
param primaryKey string = ''

@description('Required. Scope type to choose between a product, allApis or a specific api. Scope like /products/{productId} or /apis or /apis/{apiId}.')
param scope string = '/apis'

@description('Optional. Secondary subscription key. If not specified during request key will be generated automatically.')
param secondaryKey string = ''

@description('Optional. Initial subscription state. If no value is specified, subscription is created with Submitted state. Possible states are * active ? the subscription is active, * suspended ? the subscription is blocked, and the subscriber cannot call any APIs of the product, * submitted ? the subscription request has been made by the developer, but has not yet been approved or rejected, * rejected ? the subscription request has been denied by an administrator, * cancelled ? the subscription has been cancelled by the developer or administrator, * expired ? the subscription reached its expiration date and was deactivated. - suspended, active, expired, submitted, rejected, cancelled')
param state string = ''

@description('Required. Subscription name.')
param subscriptionName string

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource subscription 'Microsoft.ApiManagement/service/subscriptions@2020-06-01-preview' = {
  name: '${apiManagementServiceName}/${subscriptionName}'
  properties: {
    scope: scope
    displayName: subscriptionName
    ownerId: ((!empty(ownerId)) ? ownerId : json('null'))
    primaryKey: ((!empty(primaryKey)) ? primaryKey : json('null'))
    secondaryKey: ((!empty(secondaryKey)) ? secondaryKey : json('null'))
    state: ((!empty(state)) ? state : json('null'))
    allowTracing: allowTracing
  }
}

output subscriptionResourceId string = subscription.id
output subscriptionResourceName string = subscription.name
output subscriptionResourceGroup string = resourceGroup().name
