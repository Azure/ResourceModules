@description('Conditional. The name of the parent DNS zone. Required if the template is used in a standalone deployment.')
param dnsZoneName string

@description('Required. The name of the CNAME record.')
param name string

@description('Optional. A CNAME record. Cannot be used in conjuction with the "targetResource" property.')
param cnameRecord object = {}

@description('Optional. The metadata attached to the record set.')
param metadata object = {}

@description('Optional. The TTL (time-to-live) of the records in the record set.')
param ttl int = 3600

@description('Optional. A reference to an azure resource from where the dns resource value is taken. Also known as an alias record sets and are only supported for record types A, AAAA and CNAME. A resource ID can be an Azure Traffic Manager, Azure CDN, Front Door, Static Web App, or a resource ID of a record set of the same type in the DNS zone (i.e. A, AAAA or CNAME). Cannot be used in conjuction with the "aRecords" property.')
param targetResourceId string = ''

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource dnsZone 'Microsoft.Network/dnsZones@2018-05-01' existing = {
  name: dnsZoneName
}

resource CNAME 'Microsoft.Network/dnsZones/CNAME@2018-05-01' = {
  name: name
  parent: dnsZone
  properties: {
    CNAMERecord: !empty(cnameRecord) ? cnameRecord : null
    metadata: metadata
    TTL: ttl
    targetResource: !empty(targetResourceId) ? {
      id: targetResourceId
    } : null
  }
}

module CNAME_roleAssignments '.bicep/nested_roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name)}-DNSCNAME-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    condition: contains(roleAssignment, 'condition') ? roleAssignment.condition : ''
    delegatedManagedIdentityResourceId: contains(roleAssignment, 'delegatedManagedIdentityResourceId') ? roleAssignment.delegatedManagedIdentityResourceId : ''
    resourceId: CNAME.id
  }
}]

@description('The name of the deployed CNAME record.')
output name string = CNAME.name

@description('The resource ID of the deployed CNAME record.')
output resourceId string = CNAME.id

@description('The resource group of the deployed CNAME record.')
output resourceGroupName string = resourceGroup().name
