@description('Required. API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.')
param name string

@description('Optional. Policies to apply to the Service Api.')
param apiManagementServiceApiPolicy object = {}

@description('Required. The name of the of the Api Management service.')
param apiManagementServiceName string

@description('Optional. Describes the Revision of the Api. If no value is provided, default revision 1 is created')
param apiRevision string = ''

@description('Optional. Description of the Api Revision.')
param apiRevisionDescription string = ''

@description('Optional. Type of Api to create. * http creates a SOAP to REST API * soap creates a SOAP pass-through API.')
@allowed([
  'http'
  'soap'
])
param apiType string = 'http'

@description('Optional. Indicates the Version identifier of the API if the API is versioned')
param apiVersion string = ''

@description('Optional. Description of the Api Version.')
param apiVersionDescription string = ''

@description('Optional. Version set details')
param apiVersionSet object = {}

@description('Optional. Collection of authentication settings included into this API.')
param authenticationSettings object = {}

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

@description('Optional. Description of the API. May include HTML formatting tags.')
param apiDescription string = ''

@description('Required. API name. Must be 1 to 300 characters long.')
@maxLength(300)
param displayName string

@description('Optional. Format of the Content in which the API is getting imported.')
@allowed([
  'wadl-xml'
  'wadl-link-json'
  'swagger-json'
  'swagger-link-json'
  'wsdl'
  'wsdl-link'
  'openapi'
  'openapi+json'
  'openapi-link'
  'openapi+json-link'
])
param format string = 'openapi'

@description('Optional. Indicates if API revision is current api revision.')
param isCurrent bool = true

@description('Required. Relative URL uniquely identifying this API and all of its resource paths within the API Management service instance. It is appended to the API endpoint base URL specified during the service instance creation to form a public URL for this API.')
param path string

@description('Optional. Describes on which protocols the operations in this API can be invoked. - http or https')
param protocols array = [
  'https'
]

@description('Optional. Absolute URL of the backend service implementing this API. Cannot be more than 2000 characters long.')
@maxLength(2000)
param serviceUrl string = ''

@description('Optional. API identifier of the source API.')
param sourceApiId string = ''

@description('Optional. Protocols over which API is made available.')
param subscriptionKeyParameterNames object = {}

@description('Optional. Specifies whether an API or Product subscription is required for accessing the API.')
param subscriptionRequired bool = false

@description('Optional. Type of API.')
@allowed([
  'http'
  'soap'
])
param type string = 'http'

@description('Optional. Content value when Importing an API.')
param value string = ''

@description('Optional. Criteria to limit import of WSDL to a subset of the document.')
param wsdlSelector object = {}

var apiVersionSetName = !empty(apiVersionSet) ? apiVersionSet.name : 'default'

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource apiVersionSetResource 'Microsoft.ApiManagement/service/apiVersionSets@2020-06-01-preview' = if (!empty(apiVersionSet)) {
  name: '${apiManagementServiceName}/${apiVersionSetName}'
  properties: apiVersionSet.properties
}

resource apis 'Microsoft.ApiManagement/service/apis@2020-06-01-preview' = {
  name: '${apiManagementServiceName}/${name}'
  properties: {
    apiRevision: !empty(apiRevision) ? apiRevision : null
    apiRevisionDescription: !empty(apiRevisionDescription) ? apiRevisionDescription : null
    apiType: !empty(apiType) ? apiType : null
    apiVersion: !empty(apiVersion) ? apiVersion : null
    apiVersionDescription: !empty(apiVersionDescription) ? apiVersionDescription : null
    apiVersionSetId: !empty(apiVersionSet) ? apiVersionSetResource.id : null
    authenticationSettings: authenticationSettings
    description: apiDescription
    displayName: displayName
    format: !empty(value) ? format : null
    isCurrent: isCurrent
    path: path
    protocols: protocols
    serviceUrl: !empty(serviceUrl) ? serviceUrl : null
    sourceApiId: !empty(sourceApiId) ? sourceApiId : null
    subscriptionKeyParameterNames: !empty(subscriptionKeyParameterNames) ? subscriptionKeyParameterNames : null
    subscriptionRequired: subscriptionRequired
    type: type
    value: !empty(value) ? value : null
    wsdlSelector: wsdlSelector
  }
  // resource apiManagementServiceApiPolicyResource 'policies@2020-06-01-preview' = if (!empty(apiManagementServiceApiPolicy)) {
  //   name: 'policy'
  //   properties: {
  //     value: apiManagementServiceApiPolicy.value
  //     format: apiManagementServiceApiPolicy.format
  //   }
  // }
}

@description('The name of the API management service api')
output apisName string = apis.name

@description('The resourceId of the API management service api')
output apisResourceId string = apis.id

@description('The resource group the API management service api was deployed to')
output apisResourceGroup string = resourceGroup().name
