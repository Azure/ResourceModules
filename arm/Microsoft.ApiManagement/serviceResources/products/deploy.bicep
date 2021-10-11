@description('Required. The name of the of the Api Management service.')
param apiManagementServiceName string

@description('Optional. Whether subscription approval is required. If false, new subscriptions will be approved automatically enabling developers to call the product’s APIs immediately after subscribing. If true, administrators must manually approve the subscription before the developer can any of the product’s APIs. Can be present only if subscriptionRequired property is present and has a value of false.')
param approvalRequired bool = false

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

@description('Optional. Product description. May include HTML formatting tags.')
param description string = ''

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Product API\'s name list.')
param productApis array = []

@description('Optional. Product\'s Group name list.')
param productGroups array = []

@description('Required. Product Name.')
param productName string = ''

@description('Optional. whether product is published or not. Published products are discoverable by users of developer portal. Non published products are visible only to administrators. Default state of Product is notPublished. - notPublished or published')
param state string = 'published'

@description('Optional. Whether a product subscription is required for accessing APIs included in this product. If true, the product is referred to as "protected" and a valid subscription key is required for a request to an API included in the product to succeed. If false, the product is referred to as "open" and requests to an API included in the product can be made without a subscription key. If property is omitted when creating a new product it\'s value is assumed to be true.')
param subscriptionRequired bool = false

@description('Optional. Whether the number of subscriptions a user can have to this product at the same time. Set to null or omit to allow unlimited per user subscriptions. Can be present only if subscriptionRequired property is present and has a value of false.')
param subscriptionsLimit int = 1

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Product terms of use. Developers trying to subscribe to the product will be presented and required to accept these terms before they can complete the subscription process.')
param terms string = ' '

module pid_cuaId './nested_pid_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource apiManagementServiceName_productName 'Microsoft.ApiManagement/service/products@2020-06-01-preview' = {
  name: '${apiManagementServiceName}/${productName}'
  location: location
  tags: tags
  properties: {
    description: description
    displayName: productName
    terms: terms
    subscriptionRequired: subscriptionRequired
    approvalRequired: (subscriptionRequired ? approvalRequired : json('null'))
    subscriptionsLimit: (subscriptionRequired ? subscriptionsLimit : json('null'))
    state: state
  }
}

module productApis_name './nested_productApis_name.bicep' = [for i in range(0, length(productApis)): {
  name: 'productApis-${deployment().name}-${i}'
  params: {
    apiManagementServiceName: apiManagementServiceName
    productName: productName
    productApis: productApis
  }
  dependsOn: [
    apiManagementServiceName_productName
  ]
}]

module group_name './nested_group_name.bicep' = [for i in range(0, length(productGroups)): {
  name: 'group-${deployment().name}-${i}'
  params: {
    apiManagementServiceName: apiManagementServiceName
    productName: productName
    productGroups: productGroups
  }
  dependsOn: [
    apiManagementServiceName_productName
  ]
}]

output productResourceId string = apiManagementServiceName_productName.id
output productApisResourceIds array = [for item in productApis: resourceId('Microsoft.ApiManagement/service/products/apis', apiManagementServiceName, productName, item)]
output productResourceName string = productName
output productResourceGroup string = resourceGroup().name