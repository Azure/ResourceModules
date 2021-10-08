@description('Required. Private DNS zone name.')
param privateDnsZoneName string

@description('Optional. Array of custom objects describing vNet links of the DNS zone. Each object should contain properties \'vnetResourceId\' and \'registrationEnabled\'. The \'vnetResourceId\' is a resource Id of a vNet to link, \'registrationEnabled\' (bool) enables automatic DNS registration in the zone for the linked vNet.')
param vnetLinks array = []

@description('Optional. The location of the PrivateDNSZone. Should be global.')
param location string = 'global'

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Switch to lock Traffic Manager from deletion.')
param lockForDeletion bool = false

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

var builtInRoleNames = {
  'Owner': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  'Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Avere Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','4f8fab4f-1852-4a58-a46a-8eaf358af14a')
  'Log Analytics Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','92aaf0da-9dab-42b6-94a3-d43ce8d16293')
  'Log Analytics Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','73c42c96-874c-492b-b04d-ab87d138a893')
  'Managed Application Contributor Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','641177b8-a67a-45b9-a033-47bc880bb21e')
  'Managed Application Operator Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','c7393b34-138c-406f-901b-d8cf2b17e6ae')
  'Managed Applications Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','b9331d33-8a36-4f8c-b097-4f54124fdb44')
  'Monitoring Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','749f88d5-cbae-40b8-bcfc-e573ddc772fa')
  'Monitoring Metrics Publisher': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','3913510d-42f4-4e42-8a64-420c390055eb')
  'Monitoring Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','43d0d8ad-25c7-4714-9337-8ba259a9fe05')
  'Network Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','4d97b98b-1d4f-4787-a291-c67834d212e7')
  'Private DNS Zone Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','b12aa53e-6015-4669-85d0-8515ebb3ae7f')
  'Resource Policy Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','36243c78-bf99-498c-9df9-86d9f8d28608')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions','18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
}

module pid_cuaId './.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2018-09-01' = {
  name: privateDnsZoneName
  location: location
  tags: tags
  
  resource virtualNetworkLinks 'virtualNetworkLinks@2018-09-01' = [for vnetLink in vnetLinks: if (!empty(vnetLinks)) {
    name: '${(empty(vnetLinks) ? 'dummy' : last(split(vnetLink.vnetResourceId, '/')))}'
    location: location
    tags: tags
    properties: {
      registrationEnabled: vnetLink.registrationEnabled
      virtualNetwork: {
        id: vnetLink.vnetResourceId
      }
    }
  }]
}

resource privateDnsZone_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lockForDeletion) {
  name: '${privateDnsZone.name}-doNotDelete'
  properties: {
    level: 'CanNotDelete'
  }
  scope: privateDnsZone
}

module privateDnsZone_rbac './.bicep/nested_rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: 'rbac-${deployment().name}${index}'
  params: {
    roleAssignmentObj: roleAssignment
    builtInRoleNames: builtInRoleNames
    resourceName: privateDnsZone.name
  }
}]

output privateDnsZoneResourceGroup string = resourceGroup().name
output privateDnsZoneName string = privateDnsZone.name
output privateDnsZoneResourceId string = privateDnsZone.id
