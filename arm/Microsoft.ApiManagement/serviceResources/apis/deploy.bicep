@description('Required. API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.')
param apiManagementServiceApiName string

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

var apiVersionSetNotEmpty = (!empty(apiVersionSet))
var apiVersionSetName = (apiVersionSetNotEmpty ? apiVersionSet.name : 'default')

module pid_cuaId './.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource apiVersionSetResource 'Microsoft.ApiManagement/service/apiVersionSets@2020-06-01-preview' = if (apiVersionSetNotEmpty) {
  name: '${apiManagementServiceName}/${apiVersionSetName}'
  properties: apiVersionSet.properties
}

resource apiManagementServiceApi 'Microsoft.ApiManagement/service/apis@2020-06-01-preview' = {
  name: '${apiManagementServiceName}/${apiManagementServiceApiName}'
  properties: {
    apiRevision: ((!empty(apiRevision)) ? apiRevision : json('null'))
    apiRevisionDescription: ((!empty(apiRevisionDescription)) ? apiRevisionDescription : json('null'))
    apiType: ((!empty(apiType)) ? apiType : json('null'))
    apiVersion: ((!empty(apiVersion)) ? apiVersion : json('null'))
    apiVersionDescription: ((!empty(apiVersionDescription)) ? apiVersionDescription : json('null'))
    apiVersionSetId: (apiVersionSetNotEmpty ? apiVersionSetResource.id : json('null'))
    authenticationSettings: authenticationSettings
    description: apiDescription
    displayName: displayName
    format: ((!empty(value)) ? format : json('null'))
    isCurrent: isCurrent
    path: path
    protocols: protocols
    serviceUrl: ((!empty(serviceUrl)) ? serviceUrl : json('null'))
    sourceApiId: ((!empty(sourceApiId)) ? sourceApiId : json('null'))
    subscriptionKeyParameterNames: ((!empty(subscriptionKeyParameterNames)) ? subscriptionKeyParameterNames : json('null'))
    subscriptionRequired: subscriptionRequired
    type: type
    value: ((!empty(value)) ? value : json('null'))
    wsdlSelector: wsdlSelector
  }
  resource apiManagementServiceApiPolicyResource 'policies@2020-06-01-preview' = if (!empty(apiManagementServiceApiPolicy)) {
    name: 'policy'
    properties: {
      value: apiManagementServiceApiPolicy.value
      format: apiManagementServiceApiPolicy.format
    }
  }
}

output apimServiceApiName string = apiManagementServiceApi.name
output apimServiceApiResourceId string = apiManagementServiceApi.id
output apimServiceApiResourceGroup string = resourceGroup().name
