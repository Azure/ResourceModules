@description('Required. Name of the Application Insights')
param appInsightsName string

@description('Optional. Application type')
@allowed([
  'web'
  'other'
])
param appInsightsType string = 'web'

@description('Required. Resource Id of the log analytics workspace which the data will be ingested to. This property is required to create an application with this API version. Applications from older versions will not have this property.')
param appInsightsWorkspaceResourceId string

@description('Optional. The network access type for accessing Application Insights ingestion. - Enabled or Disabled')
@allowed([
  'Enabled'
  'Disabled'
])
param appInsightsPublicNetworkAccessForIngestion string = 'Enabled'

@description('Optional. The network access type for accessing Application Insights query. - Enabled or Disabled')
@allowed([
  'Enabled'
  'Disabled'
])
param appInsightsPublicNetworkAccessForQuery string = 'Enabled'

@description('Optional. The kind of application that this component refers to, used to customize UI. This value is a freeform string, values should typically be one of the following: web, ios, other, store, java, phone.')
param kind string = ''

@description('Optional. Location for all Resources')
param location string = resourceGroup().location

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or it\'s fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: location
  tags: tags
  kind: kind
  properties: {
    Application_Type: appInsightsType
    WorkspaceResourceId: appInsightsWorkspaceResourceId
    publicNetworkAccessForIngestion: appInsightsPublicNetworkAccessForIngestion
    publicNetworkAccessForQuery: appInsightsPublicNetworkAccessForQuery
  }
}

module appInsights_rbac '.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${deployment().name}-rbac-${index}'
  params: {
    roleAssignmentObj: roleAssignment
    resourceName: appInsights.name
  }
}]

output appInsightsName string = appInsightsName
output appInsightsResourceId string = appInsights.id
output appInsightsResourceGroup string = resourceGroup().name
output appInsightsKey string = appInsights.properties.InstrumentationKey
output appInsightsAppId string = appInsights.properties.AppId
