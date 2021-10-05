@description('Optional. Name of the User Assigned Identity.')
param userMsiName string = guid(resourceGroup().id)

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Switch to lock Resource from deletion.')
param lockForDeletion bool = false

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

var builtInRoleNames = {
  'Owner': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  'Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Log Analytics Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','92aaf0da-9dab-42b6-94a3-d43ce8d16293')
  'Log Analytics Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','73c42c96-874c-492b-b04d-ab87d138a893')
  'Managed Application Contributor Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','641177b8-a67a-45b9-a033-47bc880bb21e')
  'Managed Application Operator Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','c7393b34-138c-406f-901b-d8cf2b17e6ae')
  'Managed Applications Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','b9331d33-8a36-4f8c-b097-4f54124fdb44')
  'Managed Identity Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','e40ec5ca-96e0-45a2-b4ff-59039f2c2b59')
  'Managed Identity Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','f1a07417-d97a-45cb-824c-7a7467783830')
  'Monitoring Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','749f88d5-cbae-40b8-bcfc-e573ddc772fa')
  'Monitoring Metrics Publisher': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','3913510d-42f4-4e42-8a64-420c390055eb')
  'Monitoring Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','43d0d8ad-25c7-4714-9337-8ba259a9fe05')
  'Resource Policy Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','36243c78-bf99-498c-9df9-86d9f8d28608')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
}

module pid_cuaId './.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource userMsi 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: userMsiName
  location: location
  tags: tags
}

resource userMsi_lock 'Microsoft.ManagedIdentity/userAssignedIdentities/providers/locks@2017-04-01' = if (lockForDeletion) {
  name: '${userMsiName}/Microsoft.Authorization/msiDoNotDelete'
  properties: {
    level: 'CannotDelete'
  }
  dependsOn: [
    userMsi
  ]
}

module userMsi_rbac './.bicep/nested_rbac.bicep' = [for (roleassignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-userMsi-Rbac-${index}'
  params: {
    roleAssignment: roleassignment
    builtInRoleNames: builtInRoleNames
    resourceName: userMsiName
  }
  dependsOn: [
    userMsi
  ]
}]

output msiName string = userMsiName
output msiResourceId string = userMsi.id
output msiPrincipalId string = userMsi.properties.principalId
output msiResourceGroup string = resourceGroup().name
