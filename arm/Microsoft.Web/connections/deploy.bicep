@description('Optional. Alternative parameter values.')
param alternativeParameterValues object = {}

@description('Optional. Specific values for some API connections.')
param connectionApi object = {}

@description('Required. Connection Kind. Example: \'V1\' when using blobs. It can change depending on the resource.')
param connectionKind string

@description('Required. Connection name for connection. Example: \'azureblob\' when using blobs.  It can change depending on the resource.')
param connectionName string

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered.')
param cuaId string = ''

@description('Optional. Customized parameter values for specific connections.')
param customParameterValues object = {}

@description('Required. Display name connection. Example: \'blobconnection\' when using blobs. It can change depending on the resource.')
param displayName string

@description('Optional. Location of the deployment.')
param location string = resourceGroup().location

@description('Optional. Dictionary of nonsecret parameter values.')
param nonSecretParameterValues object = {}

@description('Optional. Connection strings or access keys for connection. Example: \'accountName\' and \'accessKey\' when using blobs.  It can change depending on the resource.')
@secure()
param parameterValues object = {}

@description('Optional. Value Type of parameter, in case alternativeParameterValues is used.')
param parameterValueType string = ''

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@description('Optional. Status of the connection.')
param statuses array = []

@description('Optional. Switch to lock Resource from deletion.')
param lockForDeletion bool = false

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Links to test the API connection.')
param testLinks array = []

var builtInRoleNames = {
  'Owner': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  'Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Log Analytics Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '92aaf0da-9dab-42b6-94a3-d43ce8d16293')
  'Log Analytics Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '73c42c96-874c-492b-b04d-ab87d138a893')
  'Logic App Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '87a39d53-fc1b-424a-814c-f7e04687dc9e')
  'Logic App Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '515c2055-d9d4-4321-b1b9-bd0c9a0f79fe')
  'Managed Application Contributor Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '641177b8-a67a-45b9-a033-47bc880bb21e')
  'Managed Application Operator Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'c7393b34-138c-406f-901b-d8cf2b17e6ae')
  'Managed Applications Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b9331d33-8a36-4f8c-b097-4f54124fdb44')
  'Monitoring Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '749f88d5-cbae-40b8-bcfc-e573ddc772fa')
  'Monitoring Metrics Publisher': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3913510d-42f4-4e42-8a64-420c390055eb')
  'Monitoring Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '43d0d8ad-25c7-4714-9337-8ba259a9fe05')
  'Resource Policy Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '36243c78-bf99-498c-9df9-86d9f8d28608')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
}

module pid_cuaId './.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource connection 'Microsoft.Web/connections@2016-06-01' = {
  name: connectionName
  location: location
  kind: connectionKind
  tags: tags
  properties: {
    displayName: displayName
    customParameterValues: customParameterValues
    parameterValueType: ((!empty(parameterValueType)) ? parameterValueType : json('null'))
    alternativeParameterValues: ((!empty(alternativeParameterValues)) ? alternativeParameterValues : json('null'))
    api: connectionApi
    parameterValues: (empty(alternativeParameterValues) ? parameterValues : json('null'))
    nonSecretParameterValues: ((!empty(nonSecretParameterValues)) ? nonSecretParameterValues : json('null'))
    testLinks: ((!empty(testLinks)) ? testLinks : json('null'))
    statuses: ((!empty(statuses)) ? statuses : json('null'))
  }
}

resource connection_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lockForDeletion) {
  name: '${connectionName}-connectionDoNotDelete'
  properties: {
    level: 'CanNotDelete'
  }
  scope: connection
}

module connection_rbac './.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: 'rbac-${deployment().name}${index}'
  params: {
    roleAssignmentObj: roleAssignment
    builtInRoleNames: builtInRoleNames
    resourceName: connection.name
  }
}]

output connectionResourceId string = connection.id
output connectionResourceGroup string = resourceGroup().name
output connectionName string = connection.name
