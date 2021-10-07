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

var builtInRoleNames = {
  'Owner': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  'Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Application Insights Component Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ae349356-3a1b-4a5e-921d-050484c6347e')
  'Application Insights Snapshot Debugger': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '08954f03-6346-4c2e-81c0-ec3a5cfae23b')
  'Data Purger': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '150f5e0c-0603-4f03-8c7f-cf70034c4e90')
  'Log Analytics Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '92aaf0da-9dab-42b6-94a3-d43ce8d16293')
  'Log Analytics Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '73c42c96-874c-492b-b04d-ab87d138a893')
  'Managed Application Contributor Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '641177b8-a67a-45b9-a033-47bc880bb21e')
  'Managed Application Operator Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'c7393b34-138c-406f-901b-d8cf2b17e6ae')
  'Managed Applications Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b9331d33-8a36-4f8c-b097-4f54124fdb44')
  'Monitoring Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '749f88d5-cbae-40b8-bcfc-e573ddc772fa')
  'Monitoring Metrics Publisher': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3913510d-42f4-4e42-8a64-420c390055eb')
  'Monitoring Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '43d0d8ad-25c7-4714-9337-8ba259a9fe05')
  'Resource Policy Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '36243c78-bf99-498c-9df9-86d9f8d28608')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
  'Website Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'de139f84-1756-47ae-9be6-808fbbe84772')
}

module pid_cuaId './.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
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

module appInsights_rbac './.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: 'rbac-${deployment().name}${index}'
  params: {
    roleAssignmentObj: roleAssignment
    builtInRoleNames: builtInRoleNames
    resourceName: appInsights.name
  }
}]

output appInsightsName string = appInsightsName
output appInsightsResourceId string = appInsights.id
output appInsightsResourceGroup string = resourceGroup().name
output appInsightsKey string = appInsights.properties.InstrumentationKey
output appInsightsAppId string = appInsights.properties.AppId
